if .["\/"] then .
	else "Could not find permissions for root folder '/'." | halt_error 
	end
| ( .["\/"] | map(select(.mapping.type == "group")) | sort_by(.mask - .permissions) | first ) as $admin
| if $admin.permissions == 31 and $admin.mask == 0 then .
	else "Could not find admin group with full permissions." | halt_error 
	end
| to_entries
| reduce .[] as $item ([];
	if ($item.key != "\/")
		and ($item.value | all(.mapping != $admin.mapping) )
	then . += [{key: $item.key, value: [$admin]}]
	else . 
	end
)
| .[]
| { (.key): .value }
