# Staticsite

This is a simple static html blog generator using only 278 lines (as of this submission) of shell code.

## Organization

Posts are placed within the `posts` directory and are written in markdown, and have `.md` extension (anything else can be used to effectively save drafts inplace, for example).

Each post begins with a metadata section delimited by lines containing nothing but dashes.

The currently supported metadata is: `title:`, `date:`, `modified:`, `tags:`.

The `tags` line is a space-separated list of tags that you may want to place in the file.

The script generates a `tagindex.html` page for each tag in a post, which by default only has the tag name as title and lists the posts tagged with that tag.

Optionally, by creating the file `tag/<tag-name>/tagindex.md` the rendered markdown can be included above the list of posts.

The main index.html file is created by providing `tag/MAININDEX/tagindex.md`.

## Dependencies

The script uses mostly standard tools like sed(1) and awk(1) for text manipulation. The only non-standard tool that it makes use of is the lowdown(1) to compile markdown into html.

## Running

before running you should change the variables `blogname` and `baseurl` at the top of `makeposts.sh`

After writing all your posts, the whole thing can be compiled by running `./makeposts` and deployed into the default `/var/www/htdocs` by running `./deploy.sh` as root.

## Notes

This was written in openbsd and there may be slight differences in the syntax for sed and awk commands.

To generate a locally viewable copy simply set the `baseurl` variable in `makeposts.sh` to `file://<path-to-repo>/deploy`
