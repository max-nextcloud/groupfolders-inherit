to_entries
| map(
	if .key != "/"
	then .
	else {key: "", value: .value}
	end
)
| sort
| reduce .[] as $item ([];
	last as $previous
	| if $previous and ($item.key | startswith($previous.key))
	then
		. += [$item + {parent: $previous}]
	else
		if $previous.parent and ($item.key | startswith($previous.parent.key))
		then
			. += [$item + {parent: $previous.parent}]
		else
			. += [$item]
		end
	end
)
| .[]
| if .parent
	then { (.key): {value: .value, parent: .parent } }
	else { (.key): {value: .value}}
end
