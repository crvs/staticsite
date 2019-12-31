#!/bin/sh

user=$USER

for f in blog*; do
    install -m 500 -o $user -g $user $f $HOME/.local/bin/$f
done

# vi: et sts=4 ts=4 sw=4
