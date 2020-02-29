#!/bin/sh

user=$USER

depcheck () {
    success="success"
    for p in $*; do 
        prog=`which $p`
        if [ "$prog" = "" ]; then
            echo "Couldn't find $p"
            success=""
        fi
    done

    if [ "$success" = "" ]; then
        return 1
    fi
    return 0
}

depcheck lowdown xmllint sqlite3
if [ "$?" = "1" ]; then
    echo Missing dependencies, aborting installation
    exit 1
fi


if [ "$user" = "root" ]; then
    group=wheel

    mode=555
    destination=/usr/local/bin

    docmode=444
    docdestination=/usr/local/man

else
    group=$user

    mode=700
    destination=$HOME/.local/bin

    docmode=600
    docdestination=$HOME/.local/man
fi

for f in src/*; do
    filename=${f#src/}
    install -m $mode -o $user -g $group $f \
        $destination/$filename
done

for d in doc/*; do
    section=${d##*.}
    filename=${d#doc/}
    install -m $mode -o $user -g $group $d \
        $docdestination/man${section}/$filename
done

# vi: et sts=4 ts=4 sw=4
