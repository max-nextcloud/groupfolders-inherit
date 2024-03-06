# Turn the object into a stream of objects with one key each:
to_entries
| first as $first
| reduce .[] as $item ([];
	if ($item.key != $first.key)
		and ($item.value | all(.mapping != $first.value[0].mapping) )
	then . += [{key: $item.key, value: $first.value}]
	# then . += [$item, {($item.key): $first.value}]
	else . 
	end
)
| .[]
| { (.key): .value }
