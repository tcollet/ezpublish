{default attribute_base=ContentObjectAttribute}
{section show=count($attribute.content.modified)}

  <div class="warning">
  {"Warning, the ini file settings value and object value does not match."|i18n("design/standard/class/datatype")}
  {"The ini file has probably been modified manually since last time."|i18n("design/standard/class/datatype")}

  {section var=modified loop=$attribute.content.modified}
    <br/>{"Ini File : "|i18n("design/standard/class/datatype")}{$modified.item.file|wash}
    <br/>{"Ini Value: "|i18n("design/standard/class/datatype")}{$modified.item.ini_value|wash}
  {/section}
   </div>
{/section}

{switch match=$attribute.contentclass_attribute.data_int1}

{case in=array(1,4,5)}

<input type="text" size="10"
       name="{$attribute_base}_ini_setting_{$attribute.id}"
       value="{$attribute.data_text|wash}" />

{/case}

{case match=2}

<select name="{$attribute_base}_ini_setting_{$attribute.id}">
  <option value="enabled" {section show=$attribute.data_text|eq("enabled")}selected="selected"{/section}>{"Enabled"|i18n("design/standard/class/datatype")}</option>
  <option value="disabled" {section show=$attribute.data_text|eq("disabled")}selected="selected"{/section}>{"Disabled"|i18n("design/standard/class/datatype")}</option>  
</select>

{/case}

{case match=3}

<select name="{$attribute_base}_ini_setting_{$attribute.id}">
  <option value="true" {section show=$attribute.data_text|eq("true")}selected="selected"{/section}>{"True"|i18n("design/standard/class/datatype")}</option>
  <option value="false" {section show=$attribute.data_text|eq("false")}selected="selected"{/section}>{"False"|i18n("design/standard/class/datatype")}</option>  
</select>

{/case}

{case match=6}

<textarea class="box" name="{$attribute_base}_ini_setting_{$attribute.id}" cols="97" rows="5">{$attribute.data_text|wash}</textarea>

{/case}

{/switch}
{/default}
