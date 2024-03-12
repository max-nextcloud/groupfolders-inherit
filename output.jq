to_entries
| .[]
| "occ groupfolders:permissions -g '" 
	+ .value[0].mapping.id 
	+ "' " 
	+ $groupfolder_id 
	+ " '" 
	+ .key 
	+ "' +read +write +create +delete +share"
