#!/usr/bin/env bash

./occ groupfolders:permissions $1 \
	| jq -rc -f groupfolders.jq \
	| jq -rc -f output.jq --arg groupfolder_id $1
