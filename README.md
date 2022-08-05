# bashpertium: Collection of bash "oneliners" for apertium stuff

This is a collection of simple scripts to work with apertium development on
command-line. Basically part of Flammie's workflow either when developing or
writing articles.

## Dependencies

* autotools
* GNU sed (or sed that supports line breaks i.e. not Mac OS X broken sed)
* gawk (other awks *may* work)

## Installation

It's autotools, say `autoreconf -i && ./configure && sudo make install`.
If you cannot use `sudo`, say `./configure --prefix=$HOME` instead.

## Usage

The scripts included are now:

* `ape-translate.bash`
* `ape-analyse.bash`
* `ape-gloss.bash`
* `ape-coverage-text.bash`
* `ape-coverage-tokenlist.bash`
* `ape-coverage-uniq-c.bash`

All scripts should support apertium option `-d` to define path, and required
argument to define language or language pair, and optional arguments for
filenames.

### Translate, analyse or gloss

These are for development workflow, to repeatedly analyse same corpus and
collecting OOVs for addition.

### Coverage

These are to produce naïve coverage numbers for articles.
