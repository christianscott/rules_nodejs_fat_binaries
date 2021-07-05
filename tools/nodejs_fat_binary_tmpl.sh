#!/bin/bash
tmp=$(mktemp --directory)
unzip -qo $0 -d $tmp
node "$tmp/{ENTRYPOINT}"
exit $?
