#!/bin/bash -pe
PROGNAME="${0##*/}"

# $Id$

set +u
shopt -s xpg_echo

# The %% is for when this script is renamed with an extension like .sh or .bash.
if [ -n "$TMPDIR" ]; then
    TMPDIR=${TMPDIR}/${PROGNAME%%.*}
else
    TMPDIR=/var/tmp/${PROGNAME%%.*}
fi

unset INCOMING_MERGED OUTGOING_MERGED
while [ $# -gt 0 ]; do
    case "$1" in -*)
        case "$1" in *v*) VERBOSE=1;; esac
        case "$1" in *n*) NORUN=1;; esac
        case "$1" in *r*) INCOMING_MERGED=true;; esac
        case "$1" in *s*) OUTGOING_MERGED=true;; esac
        shift
    esac
done

[ $# -ne 0 ] && {
    echo "SYNTAX:  $PROGNAME [-rs]
WARNING:  Do not use -r or -s switch unless you have really satisfied all UU
merge conflicts (you do not need to re-add the UU files though)." 1>&2
    exit 3
}

Failout() {
    echo "Aborting $PROGNAME:  $*" 1>&2
    exit 1
}

[ -d "$TMPDIR" ] || {
    mkdir "$TMPDIR" || Failout "Failed to create temp directory '$TMPDIR'"
}

unset MOD
[ -z "$INCOMING_MERGED" ] && [ -z "$OUTGOING_MERGED" ] && {
    git branch | grep -q '^\* master$' || git checkout master
    [ -x relames/$PROGNAME ] ||
    Failout "$PROGNAME must be invoked from root directory of work area."
    git fetch upstream 2>&1 | grep -q ' master *-> upstream/master' && {
        MOD=true  # Flag that we need to merge incoming into mergeBranch
        echo 'Loading in-bound mods through to relamesSubtree...'
        git merge upstream/master  # master is exact mirror so no conflicts here
        git push origin master
        # Following should not fail since relamesSubtree is partial exact mirror
        git subtree split -P relames --annotate='(split)' -b relamesSubtree
        git push origin relamesSubtree
    }
}
git branch | grep -q '^\* mergeBranch$' || git checkout mergeBranch
[ -x $PROGNAME ] ||
Failout "$PROGNAME must be invoked from root directory of work area."
if [ -n "$INCOMING_MERGED" ]; then
    git commit -m 'Manually merged incoming mods'
elif [ -n "$MOD" ]; then
    echo 'Loading in-bound mods into mergeBranch...'
    git merge relamesSubtree || {
        echo "After you merge and re-add, resume by re-running $PROGNAME with switch -r."
        exit 0
    }
    INCOMING_MERGED=true
fi
[ -n "$INCOMING_MERGED" ] && git push origin mergeBranch

if [ -n "$OUTGOING_MERGED" ]; then
    git commit -m 'Manually merged outgoing mods'
elif git fetch admcRelames 2>&1 | grep -q ' master *-> admcRelames/master'; then
    echo 'Loading out-bound mods into mergeBranch...'
    git merge admcRelames/master || {
        echo "After you merge and re-add, resume by re-running $PROGNAME with switch -s."
        exit 0
    }
    OUTGOING_MERGED=true
fi
[ -n "$OUTGOING_MERGED" ] && {
    git push origin mergeBranch
    echo 'Pushing down...'
    git push admcRelames mergeBranch:master
}
