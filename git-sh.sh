#!/bin/sh

unpack() {
	(printf "\x1f\x8b\x08\0\0\0\0\0\0\x03"; (head -c2>/dev/null; cat)<$1) | zcat 2>/dev/null 
}

unpackobj() { 
	unpack .git/objects/$(echo $1 | sed 's,^\(..\)\(.*\),\1/\2,') 
}

log() {
	ref=$(cat .git/$(awk '{print $2}' < .git/HEAD))
	t=$(mktemp)
	while [ ! -z "$ref" ]; do 
		unpackobj $ref
		ref=$(unpackobj $ref | grep -a parent | awk '{print $2}')
	done
}

