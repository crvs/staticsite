#!/bin/sh

user=$USER
echo $user

for f in src/*; do
    filename=${f#src/}
    if [ "$user" = "root" ]; then
        mode=555
        group=wheel
        destination=/usr/local/bin
    else
        mode=700
        group=$user
        destination=$HOME/.local/bin
    fi
    install -m $mode -o $user -g $group $f $destination/$filename
done

# vi: et sts=4 ts=4 sw=4
