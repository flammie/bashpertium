#!/bin/bash

function usage() {
    echo Usage: $0 [-d PATH] LANGUAGE-OR-PAIR FILE
    echo
    echo Options:
    echo    -d PATH   use PATH to find modes
    echo
    echo LANGUAGE-OR-PAIR is an apertium language spec definition, e.g. qzr or
    echo    qzr-qaa
    echo FILE should be pre-tokenised!!
    echo
}
APEPATH="./"
while test $# -gt 0 ; do
    case $1 in
        -d)
            APEPATH="$2";
            shift 2;;
        *)
            if test -z "$PAIR" ; then
                PAIR=$1;
            else
                INFILE=$1;
            fi;
            shift;;
    esac
done

apertium-destxt < $INFILE |\
    lt-proc -w -e $APEPATH$PAIR.automorf.bin |\
    cg-proc -w1n $APEPATH$PAIR.rlx.bin |\
    apertium-pretransfer |\
    lt-proc -b $APEPATH$PAIR.autobil.bin |\
    lrx-proc $APEPATH$PAIR.autolex.bin |\
    apertium-retxt
apertium-destxt < $INFILE |\
    hfst-proc $APEPATH$PAIR.automorf.hfst |\
    cg-proc -w1n $APEPATH$PAIR.rlx.bin |\
    apertium-pretransfer |\
    lt-proc -b $APEPATH$PAIR.autobil.bin |\
    lrx-proc $APEPATH$PAIR.autolex.bin |\
    apertium-retxt
