#!/bin/sh

PKGID="odvr"
tar cvfz $PKGID-`date '+%Y%m%d'`.tar.gz usr var --owner 1000 --group 1000 --exclude "*~" --exclude .svn --exclude "*.a"

