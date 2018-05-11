% APE-ANALYSE(1) Bashpertium User Manuals

# NAME

ape-translate.bash - Translate texts with apertium while developing

# SYNOPSIS

ape-translate.bash [*options*] *langpair* [*file...*]

# DESCRIPTION

Ape-translate is for translating short texts with an apertium translator while
developing the dictionary, it is meant to help finding OOV words of different
sorts and matching them to suggestions in relevant dictionaries.

# OPTIONS

-d *PATH*
:   load apertium modes from PATH, this is passed directly to the apertium
    command. Typically you'll want . for current directory.

*LANGPAIR* is  apertium translation definition, typically two ISO-639-3 codes
separated by a hyphen-minus character.
FILE should be text/plain or [text-with-metadata
container](https://github.com/flammie/bash-corpora#text-container-files).

# SEE ALSO

The bashpertium web-site is in github pages as:
https://flammie.github.io/bashpertium

For more information on apertium visit [apertium
wiki](http://wiki.apertium.org).


