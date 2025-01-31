{**
 * templates/frontend/components/registrationForm.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the basic registration form fields
 *
 * @uses $loginUrl string URL to post the login request
 * @uses $source string Optional URL to redirect to after successful login
 * @uses $username string Username
 * @uses $password string Password
 * @uses $remember boolean Should logged in cookies be preserved on this computer
 * @uses $disableUserReg boolean Can users register for this site?
 *}

<form method="post" action="{$loginUrl}">
	{csrf}
	<input type="hidden" name="source" value="{$source|strip_unsafe_html|escape}"/>

	<fieldset>
		<div class="form-group">
			<label for="usernameModal">
				{translate key="user.username"}
				<span class="required" aria-hidden="true">*</span>
				<span class="sr-only">
					{translate key="common.required"}
				</span>
			</label>
			<input type="text" class="form-control" name="username" id="usernameModal" value="{$username|escape}"
			       maxlength="32" required>
		</div>
		<div class="form-group">
			<label for="passwordModal">
				{translate key="user.password"}
				<span class="required" aria-hidden="true">*</span>
				<span class="sr-only">
					{translate key="common.required"}
				</span>
			</label>
			<input type="password" class="form-control" name="password" id="passwordModal" value="{$password|escape}"
			       maxlength="32" required>
		</div>
		<div class="row">
			<div class="col-md-6">
				<div class="form-group">
					<small>
						<a href="{url page="login" op="lostPassword"}">
							{translate key="user.login.forgotPassword"}
						</a>
					</small>
				</div>
			</div>
			<div class="col-md-6">
				<div class="custom-control custom-checkbox">
					<input type="checkbox" class="custom-control-input" name="remember" id="rememberModal" value="1"
					       checked="$remember">
					<label for="rememberModal" class="custom-control-label">
							{translate key="user.login.rememberUsernameAndPassword"}
					</label>
				</div>
			</div>
		</div>
		<div class="form-group">
			<button class="btn btn-primary" type="submit">
				{translate key="user.login"}
			</button>
		</div>
		{if !$disableUserReg}
			<div class="form-group">
				{translate key="plugins.themes.healthSciences.register.noAccount"}
				{capture assign=registerUrl}{url page="user" op="register" source=$source}{/capture}
				<a href="{$registerUrl}">
					{translate key="plugins.themes.healthSciences.register.registerHere"}
				</a>
			</div>
		{/if}
	</fieldset>
</form>
