#!/usr/bin/bash

## library of apertium helper bash functions
## GPLv3

function ape_pwd_langs() {
    ape='*'
    if test -d modes ; then
        if ls modes/???-morph.mode ; then
            ape=$(ls -1 modes/???-morph.mode |\
                sed -e 's/modes\///' -e 's/-morph.mode//')
        elif ls modes/???-???.mode ; then
            ape=$(ls -1 modes/???-???.mode |\
                sed -e 's/modes\///' -e 's/.mode//')
        else
            ape='*'
        fi
    fi
    echo $ape
}

function ape_remake() {
    if test -f Makefile ; then
        make
    fi
}
