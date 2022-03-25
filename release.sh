#!/bin/bash
git checkout master
curl -s 'https://pypi.org/pypi/matrix-synapse/json' | jq -j -r '.info.version' > version
git add -A
git commit -m `cat version`
git push origin master
git tag `cat version`
git push origin `cat version`