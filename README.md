# Staticsite

This is a simple static html blog generator using only 437 lines (as of this submission) of shell code.

## Organization

Posts are placed within dedicated directories, written in markdown, and have `.md` extension (anything else can be used to effectively save drafts inplace, for example).

Each post begins with a metadata section delimited by lines containing nothing but dashes `---`.
The currently supported metadata is: `title:`, `date:`, `modified:`, `tags:`.

- The `tags` line is a space-separated list of tags that you may want to place in the file.
- The lines with `date` and `modified` are recomended to be in format `YYYY-MM-DD` since these can be easily ordered in lexicographic order.
- The `title` line is the title of the post and it gets rendered as a heading at the top of the post.

The directories used by the script are registered at blogconfig in a line marked `postdirs: ` which is a space separated list of directory names (don't use directory names with spaces).

For each post `directory/post.md` the script compiles it to an html file located at `cache/directory_post.md` (notice the `_`), registers each tag `tagname` in the corresponding `cache/tag_tagname.html` file and registers the post at `index.html`.

To view the output of the site after compilation simply point your browser to `cache/index.html`.

Tag files can be enriched with an introduction by writing the corresponding `tag_tagname.md` file in the directory `indices`. Similar, a file named `index.md` in the directory `indices` will be rendered into the `index.html` file.

## Dependencies

The `blog-make` script depends on:
- `lowdown(1)` (for compiling markdown to html)
- `sqlite3(1)` (for keeping a searchable database of the post metadata)

## Installation

Simply run the install script `install.sh` which will place the scripts (contained in `src`) `blog` `blog-template` `blog-make` and `blog-deploy` on your `~/.local/bin` folder (which should be in your path).

If run as root the files will instead be placed in `/usr/local/bin`.

## Running

Before running you should change the `blogconfig` file to reflect your options.

After writing all your posts, the whole thing can be compiled by running `blog make` and deployed by running `blog deploy`.

## Note

- There may be slight divergences in the syntax of sed(1) and stat(1) over several different systems, please feel free to report if there are any errors.

### Changes in Version 3.1

- This is a bump up with minor bug fixes and just making the repositor more organized (or presentable at least).
- The `gettimestamp` function introduced in `blog-make` makes checks the operating system before issuing a call to stat(1) so that the right flags are used.
- The `blog` script now verifies where it is located so that it can call `blog-make`, `blog-template` and `blog-deploy` using the full path (and therefore this can be done within a call with `sudo(1)` or `doas(1)`).
- The `install.sh` script now allows systemwide installation (under `/usr/local/bin`) when installed by `root` (or using `sudo(1)` or `doas(1)`).

### Changes in Version 3

- Instead of a hardcoded destination directory the destination is configured in the `blogconfig` file
- There is now a unified interface using the script `blog` which wraps around other scripts 
- The scripts have been renamed to `blog-make`, `blog-deploy` and `blog-template`
- An installation script (`install.sh`) now allows a user to install locally the blog deployer.
- The blog directory no longer needs to contain all the scripts

### Changes in Version 2

- Posts can now be spread over several folders.
- Configuration takes place in the file blogconfig instead of the script.
- There is no need for the use of INSERTBASEURL anymore since all html files are contained in the same folder.
- Tagindex files are now located at `tag_<tagname>.html`
- A post called `<post>.md` located in directory `<dir>` is located at `<dir>_<post>.html`
- The compilation step does not compile posts that have not been changed.
