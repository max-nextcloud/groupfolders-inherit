# Turn the object into a stream of objects with one key each:
to_entries
| first as $first
| reduce .[] as $item ([];
	if ($item.key != $first.key)
	then . += [$item, {key: $item.key, value: $first.value}]
	# then . += [$item, {($item.key): $first.value}]
	else . += [$item]
	end
)
| .[]
| { (.key): .value }
