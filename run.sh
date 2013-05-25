#!/bin/zsh
while [ 1 ]; do
    bundle exec thin start -D -p 3000
done
