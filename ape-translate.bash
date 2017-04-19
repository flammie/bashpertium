#!/bin/bash
function usage() {
    echo Usage: $0 [-d PATH] TRANSLATION FILE
    echo
    echo Options:
    echo    -d PATH   use PATH to find modes
    echo
    echo TRANSLATION is apertium pair definition, e.g. qzr-qaa
    echo
}
DSWITCH="-d ."
while test $# -gt 0 ; do
    case $1 in
        -d)
            DSWITCH="$1 $2";
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
if test -z "$PAIR" ; then
    usage
    exit 1
fi
if test -z "$INFILE" ; then
    usage
    exit 1
fi
if ! test -r "$INFILE" ; then
    echo "Cannot open $INFILE for reading"
    exit 1
fi
ANTIPAIR=${PAIR#???-}-${PAIR%-???}
if ! apertium ${DSWITCH} ${PAIR}-debug < ${INFILE} |\
    fgrep --colour=always '@' ; then
    if ! apertium ${DSWITCH} ${PAIR}-debug < ${INFILE} |\
        fgrep --colour=always '#' ; then
        apertium ${DSWITCH} ${PAIR} < ${INFILE}
    else
        apertium ${DSWITCH} ${PAIR}-debug < ${INFILE} |\
            egrep -o '#[^<]*' |\
            tr -d '#<' |\
            sort |\
            uniq |\
            apertium ${DSWITCH} ${ANTIPAIR}-morph |\
            egrep '[[:alnum:]]*<[[:alnum:]<>]*' --colour=always
    fi
fi
