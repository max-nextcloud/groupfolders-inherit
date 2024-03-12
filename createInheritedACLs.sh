#!/usr/bin/env bash

./occ groupfolders:permissions $1 \
	| jq -rc -f lib/groupfolders.jq \
	| jq -rc -f lib/output.jq --arg groupfolder_id $1
