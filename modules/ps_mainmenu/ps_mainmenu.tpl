{assign var=_groups value=Group::getGroups($language.id)}
{* 
Array
(
    [0] => Array
        (
            [id_group] => 1
            [reduction] => 0.00
            [price_display_method] => 0
            [show_prices] => 1
            [name] => Visiteur
        )

    [1] => Array
        (
            [id_group] => 2
            [reduction] => 0.00
            [price_display_method] => 0
            [show_prices] => 1
            [name] => Invité
        )
*}
{assign var=_customer_groups value=Customer::getGroupsStatic($customer.id)}
{* 
Array
(
    [0] => 3
    [1] => 6
)
*}

{assign var=_counter value=0}
{function name="menu" nodes=[] depth=0 parent=null}
    {if $nodes|count}
      <ul class="top-menu" {if $depth == 0}id="top-menu"{/if} data-depth="{$depth}">
        {foreach from=$nodes item=node}
{* AJOUT BURLET pour montrer le menu "Formation" (cms-page-10) seulement aux groupes "Professionnel" et "Commercial") *}
            {if $node.page_identifier == "cms-page-10"}
            {* cms-page-10 est la page pour la Formation. Dans ce cas, il faut appartenir au groupe Professionnel ou Commercial *}
                {assign var=_trouve value=0}
                {foreach from=$_groups item=_group}
                    {if $_group.name|in_array:["Professionnel","Commercial"]}
                        {* J'ai le id_group correspondant au group Professionnel ou Commercial *}
                        {* je vérifie si le id_group appartient au tableau customer_groups *}                        
                        {if in_array($_group.id_group,$_customer_groups)}
                            {assign var=_trouve value=1}
                        {/if}
                    {/if}
                {/foreach}
                {if $_trouve == 0}
                    {continue}
                {/if}
            {/if}

            <li class="{$node.type}{if $node.current} current {/if}" id="{$node.page_identifier}">
            {assign var=_counter value=$_counter+1}
              <a
                class="{if $depth >= 0}dropdown-item{/if}{if $depth === 1} dropdown-submenu{/if}"
                href="{$node.url}" data-depth="{$depth}"
                {if $node.open_in_new_window} target="_blank" {/if}
              >
                {if $node.children|count}
                  {* Cannot use page identifier as we can have the same page several times *}
                  {assign var=_expand_id value=10|mt_rand:100000}
                  <span class="float-xs-right hidden-md-up">
                    <span data-target="#top_sub_menu_{$_expand_id}" data-toggle="collapse" class="navbar-toggler collapse-icons">
                      <i class="material-icons add">&#xE313;</i>
                      <i class="material-icons remove">&#xE316;</i>
                    </span>
                  </span>
                {/if}
                {$node.label}
              </a>
              {if $node.children|count}
              <div {if $depth === 0} class="popover sub-menu js-sub-menu collapse"{else} class="collapse"{/if} id="top_sub_menu_{$_expand_id}">
                {menu nodes=$node.children depth=$node.depth parent=$node}
              </div>
              {/if}
            </li>
        {/foreach}
      </ul>
    {/if}
{/function}

<div class="menu js-top-menu position-static hidden-sm-down" id="_desktop_top_menu">
    {menu nodes=$menu.children}
    <div class="clearfix"></div>
</div>
