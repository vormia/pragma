{**
 * templates/frontend/pages/userRegister.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User registration form.
 *
 * @uses $primaryLocale string The primary locale for this journal/press
 *}
{include file="frontend/components/header.tpl" pageTitle="user.register"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="user.register"}</span>
				</h1>
			</header>

			<form id="register" method="post" action="{url op="register"}">
				{csrf}

				{if $source}
					<input type="hidden" name="source" value="{$source|escape}"/>
				{/if}

				{include file="common/formErrors.tpl"}

				{include file="frontend/components/registrationForm.tpl"}

				{* When a user is registering with a specific journal *}
				{if $currentContext}
					<fieldset>
						<legend>{translate key="plugins.themes.immersion.registration.consent"}</legend>
						{* Require the user to agree to the terms of the privacy policy *}
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" name="privacyConsent" id="privacyConsent" value="1"{if $privacyConsent} checked="checked"{/if}>
							{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE page="about" op="privacy"}{/capture}

							<label class="custom-control-label" for="privacyConsent">
								{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
							</label>
						</div>

						{* Ask the user to opt into public email notifications *}
						<div class="custom-control custom-checkbox">
							<input type="checkbox" class="custom-control-input" name="emailConsent" id="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}>
							<label class="custom-control-label" for="emailConsent">
								{translate key="user.register.form.emailConsent"}
							</label>
						</div>
					</fieldset>
					{* Allow the user to sign up as a reviewer *}
					{assign var=contextId value=$currentContext->getId()}
					{assign var=userCanRegisterReviewer value=0}
					{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
						{if $userGroup->getPermitSelfRegistration()}
							{assign var=userCanRegisterReviewer value=$userCanRegisterReviewer+1}
						{/if}
					{/foreach}
					{if $userCanRegisterReviewer}
						<fieldset>
							{if $userCanRegisterReviewer > 1}
								<legend>
									{translate key="user.reviewerPrompt"}
								</legend>
								{capture assign="checkboxLocaleKey"}user.reviewerPrompt.userGroup{/capture}
							{else}
								{capture assign="checkboxLocaleKey"}user.reviewerPrompt.optin{/capture}
							{/if}

							<div id="reviewerOptinGroup" class="custom-control custom-checkbox">
								{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
									{if $userGroup->getPermitSelfRegistration()}
										{assign var="userGroupId" value=$userGroup->getId()}
										<input type="checkbox" class="custom-control-input" name="reviewerGroup[{$userGroupId}]" id="checkbox-reviewer-interests" value="1"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>

										<label class="custom-control-label" for="checkbox-reviewer-interests">
											{translate key=$checkboxLocaleKey userGroup=$userGroup->getLocalizedName()}
										</label>
									{/if}
								{/foreach}
							</div>

							<div id="reviewerInterests" class="hidden">
								{*
								 * This container will be processed by the tag-it jQuery
								 * plugin. In order for it to work, your theme will need to
								 * load the jQuery tag-it plugin and initialize the
								 * component.
								 *
								 * Two data attributes are added which are not a default
								 * feature of the plugin. These are converted into options
								 * when the plugin is initialized on the element.
								 *
								 * See: /plugins/themes/default/js/main.js
								 *
								 * `data-field-name` represents the name used to POST the
								 * interests when the form is submitted.
								 *
								 * `data-autocomplete-url` is the URL used to request
								 * existing entries from the server.
								 *
								 * @link: http://aehlke.github.io/tag-it/
								 *}
								<legend>
									{translate key="user.interests"}
								</legend>
								<ul class="tag-it" id="tagitInput" data-field-name="interests[]"
								    data-autocomplete-url="{url|escape router=$smarty.const.ROUTE_PAGE page='user' op='getInterests'}">
									{foreach from=$interests item=interest}
										<li>{$interest|escape}</li>
									{/foreach}
								</ul>
							</div>
						</fieldset>
					{/if}
				{/if}

				{include file="frontend/components/registrationFormContexts.tpl"}

				{* When a user is registering for no specific journal, allow them to
				   enter their reviewer interests *}
				{if !$currentContext}
					<fieldset>
						<legend>
							{translate key="user.register.noContextReviewerInterests"}
						</legend>
						<div>
							<div>
								{* See comment for .tag-it above *}
								<ul class="tag-it" id="tagitInput" data-field-name="interests[]"
								    data-autocomplete-url="{url|escape router=$smarty.const.ROUTE_PAGE page='user' op='getInterests'}">
									{foreach from=$interests item=interest}
										<li>{$interest|escape}</li>
									{/foreach}
								</ul>
							</div>
						</div>
					</fieldset>
				{/if}

				{* recaptcha spam blocker *}
				{if $reCaptchaHtml}
					<fieldset class="recaptcha_wrapper">
						<div>
							<div class="recaptcha">
								{$reCaptchaHtml}
							</div>
						</div>
					</fieldset>
				{/if}

				<button class="btn btn-primary" type="submit">
					{translate key="user.register"}
				</button>
				{capture assign="rolesProfileUrl"}{url page="user" op="profile" path="roles"}{/capture}
				<a href="{url page="login" source=$rolesProfileUrl}" class="btn btn-secondary">{translate key="user.login"}</a>
			</form>
		</div>
	</div><!-- row -->
</main><!-- page container -->

{include file="frontend/components/footer.tpl"}
