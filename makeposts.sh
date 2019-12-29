#!/bin/sh

blogname="MY BLOG"
baseurl=https://my_base_url.xyz

runmarkdown () {
        lowdown -e math $1 | sed "s@INSERTBASEURL@${baseurl}@g"
}

maketagindex () {
    manifest=$1
    tag=$2
    baseurl=$3
    cat $manifest | sort -r | awk -F';' -v T=$tag -v O=$baseurl/posts/ '
    {
        if ( $4 == T ) {
            printf("<h3 class=\"list-link\"><a href=%s%s>%s</a></h3>\n",O,$3,$2)
            printf("<h6 class=\"list-date\">published: %s</h6>\n",$1)
        }
    }'
}

getheader () {
    awk '
        BEGIN{
            printing = 0;
            printed = 0;
            skip = 0;
        }
        {
            if ($0 ~ "^-+$") {
                if (printing == 0) {
                    printing = 1;
                } else if( printing == 1) {
                    printed = 1;
                    printing = 0;
                }
                skip = 1;
            }
            if (printing == 1 && printed == 0 && skip == 0) {
                print $0;}
            skip=0
        }' $1
}


getbody () {
    awk '
        BEGIN{
            printing = 0;
            inheader = 0;
            skip = 0;
        }
        {
            if ($0 ~ "^-+$") {
                if (inheader == 0) {
                    inheader = 1;
                } else if( inheader == 1) {
                    inbody = 1;
                    inheader = 0;
                }
                skip = 1;
            }
            if (inheader == 0 && inbody == 1 && skip == 0) {
                print $0;}
            skip=0
        }' $1
}

headfile=`mktemp`
bodyfile=`mktemp`

htmlhead=`mktemp`
htmlbody=`mktemp`

postmanifest=`mktemp`

for file in `ls -1 posts/*.md`;
do
    outfile=${file%%.md}.html

    getheader posts/$file > $headfile
    getbody posts/$file > $bodyfile

    mkdir -p deploy/posts

    # add the title to head
    title=`cat $headfile | sed -n 's/^title: *//p'`
    printf "<title>%s: %s</title>" "$blogname" "$title"      > $htmlhead

    # add the title to body
    echo "" > $htmlbody
    printf "<h6 class=\"link\"><a href=\"%s/index.html\">home</a></h6>\n" "$baseurl" >> $htmlbody
    printf "<h1 class=\"entry-title\">%s</h1>\n" "$title" >> $htmlbody

    # add date to the body
    origdate=`cat $headfile | sed -n 's/^date: *//p'`
    modidate=`cat $headfile | sed -n 's/^modified: *//p'`

    printf "%s" '<h6 class="entry-date">'         >> $htmlbody
    printf "published: %s" $origdate              >> $htmlbody
    [ "$modidate" = "" ] || \
        printf " last modified: %s" $modidate  >> $htmlbody
    printf "%s" '</h6>'                           >> $htmlbody

    runmarkdown $bodyfile >> $htmlbody

    for tag in `cat $headfile | sed -n 's/^tags://p'`;
    do
        mkdir -p deploy/tags/$tag
    printf '<a href="%s/tags/%s/tagindex.html">' $baseurl $tag >> $htmlbody
    echo "$tag</a> " >> $htmlbody
    echo ${origdate}\;${title}\;${outfile}\;${tag} >> $postmanifest
    done

    ./html-templater -h $htmlhead $htmlbody > deploy/posts/$outfile
    echo ${origdate}\;${title}\;${outfile}\;MAININDEX >> $postmanifest
done

# make the indices using the postmanifest

tagindexraw=`mktemp`
for tag in `ls deploy/tags`;
do
    tagindexfile=deploy/tags/$tag/tagindex.html
    echo > $tagindexraw
    if [ -f tags/$tag/tagindex.md ]; then
        runmarkdown tags/$tag/tagindex.md >> $tagindexraw
    fi
    printf "<h6 class=\"link\"><a href=\"%s/index.html\">home</a></h6>\n" "$baseurl" >> $tagindexraw
    echo "<h2>Post list:</h2>" >> $tagindexraw
    maketagindex $postmanifest $tag $baseurl   >> $tagindexraw
    ./html-templater -h $htmlhead $tagindexraw > $tagindexfile
done


echo > $tagindexraw
if [ -f tags/MAININDEX/tagindex.md ]; then
    runmarkdown tags/MAININDEX/tagindex.md >> $tagindexraw
fi
echo "<h2>Post list:</h2>" >> $tagindexraw
maketagindex $postmanifest MAININDEX $baseurl >> $tagindexraw
./html-templater -h $htmlhead $tagindexraw > deploy/index.html

rm $headfile $bodyfile
rm $htmlhead $htmlbody
rm $tagindexraw
rm $postmanifest
# vim: et ts=4 sts=4
