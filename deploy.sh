#!/bin/sh

for dir in `du deploy | sed -n -E 's/^[0-9]+[ 	]deploy\/*//;/^./p'`;
do
	install -m 500 -o www -g www -d /var/www/htdocs/$dir
done

for file in `du -a deploy | sed -n -E 's/^[0-9]+[ 	]deploy\/*//;/.html$/p'`;
do
	install -m 500 -o www -g www deploy/$file /var/www/htdocs/$file
done
