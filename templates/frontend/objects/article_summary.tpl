{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showDatePublished bool Show the date this article was published?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}
{assign var=articlePath value=$article->getBestArticleId()}

{if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

<article class="row article">
	<div  class="col-sm-8">
		<h4 class="article__title">
			<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
				{$article->getLocalizedFullTitle()|escape}
			</a>
		</h4>
		{if $showAuthor}
			<p class="metadata">{$article->getAuthorString()|escape}</p>
		{/if}
		{call_hook name="Templates::Issue::Issue::Article"}
	</div>
	<div class="col-sm-4">
		{if !$hideGalleys}
			{foreach from=$article->getGalleys() item=galley}
				{assign var="hasArticleAccess" value=$hasAccess}
				{if ($article->getAccessStatus() == $smarty.const.ARTICLE_ACCESS_OPEN)}
					{assign var="hasArticleAccess" value=1}
				{/if}
				{include file="frontend/objects/galley_link.tpl" parent=$article hasAccess=$hasArticleAccess purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
			{/foreach}
		{/if}
	</div>
</article>
