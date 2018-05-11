% APE-ANALYSE(1) Bashpertium User Manuals

# NAME

ape-analyse.bash - Translate texts with apertium while developing

# SYNOPSIS

ape-analyse-bash [*options*] *langcode* [*file...*]

# DESCRIPTION

Ape-analyse is for translating short texts with an apertium analyser while
developing the dictionary, it is meant to help finding OOV words.

# OPTIONS

-d *PATH*
:   load apertium modes from PATH, this is passed directly to the apertium
    command. Typically you'll want . for current directory.

*LANGCODE* is  apertium monolingual definition, typically ISO-639-3 code
FILE should be text/plain or [text-with-metadata
container](https://github.com/flammie/bash-corpora#text-container-files).

# SEE ALSO

The bashpertium web-site is in github pages as:
https://flammie.github.io/bashpertium

For more information on apertium visit [apertium
wiki](http://wiki.apertium.org).


