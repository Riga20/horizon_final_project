{% macro hash_key(cols) -%}
md5(concat_ws('||', {% for c in cols %}coalesce(cast({{ c }} as text),''){{ ',' if not loop.last else '' }}{% endfor %}))
{%- endmacro %}
