 {let class_content=$attribute.class_content
     class_list=fetch(class,list,hash(class_filter,$class_content.class_constraint_list))}
{section show=array(0,1)|contains($class_content.type)}

<table width="100%" cellpadding="0" cellspacing="2" border="0">
<tr>
    {section name=Class loop=$class_list}
        <td>
<div class="objectheader">
            <h2>{'Create new %classname'|i18n('design/standard/content/datatype',,hash('%classname',$:item.name|wash))}</h2><div class="linebreak"/>
</div>
<div class="object">
<table width="100%" cellpadding="0" cellspacing="2" border="0">
<tr>
    <td colspan="2" align="left">
        <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_new_class_{$:item.id}][]" value="{'Add %classname'|i18n('design/standard/content/datatype',,hash('%classname',$:item.name|wash))}" />
    </td>
</tr>
</table>
</div>
        </td>
    {/section}
</tr>
</table>
{/section}
<table class="list" width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <th>
    </th>
    <th>
        Order
    </th>
    <th>
    </th>
</tr>
{section name=Relation loop=$attribute.content.relation_list sequence=array(bglight,bgdark)}
<tr class="{$:sequence}">
    <td width="1" align="right">
        <input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$:item.contentobject_id}" />
    </td>
    <td width="1">
        <input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$:item.priority}" />
    </td>
    <td>
        {section show=$:item.is_modified}
            {let object=fetch(content,object,hash(object_id,$:item.contentobject_id,
                                                  object_version,$:item.contentobject_version))
                 version=fetch(content,version,hash(object_id,$:item.contentobject_id,
                                                    version_id,$:item.contentobject_version))}
                <table cellspacing="0" cellpadding="0" border="0">
                {section name=Attribute loop=$:version.contentobject_attributes} 
<tr>
<td>
                    {$:item.contentclass_attribute.name}
</td>
<td>
                    {attribute_edit_gui attribute_base=concat($attribute_base,'_ezorl_edit_object_',$Relation:item.contentobject_id)
                                        html_class='half'
                                        attribute=$:item}
</td>
</tr>
                {/section}
</table>
            {/let}
        {section-else}
            {content_view_gui view=embed content_object=fetch(content,object,hash(object_id,$:item.contentobject_id,
                                                                                  object_version,$:item.contentobject_version))}
        {/section}
    </td>
</tr>
{/section}
</table>

<div class="buttonblock">
    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_edit_objects]" value="{'Edit objects'|i18n('design/standard/content/datatype')}" />
    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove objects'|i18n('design/standard/content/datatype')}" />
{section show=array(0,2)|contains($class_content.type)}
    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Browse objects'|i18n('design/standard/content/datatype')}" />
{/section}
</div>

{/let}