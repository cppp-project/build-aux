# -*- makefile -*-
# Prepare build-aux dist.

srcdir ?= .

all : 

PACKAGE ?= build-aux
VERSION ?= 1.0.0

DIST_NAME = $(PACKAGE)-$(VERSION)

DISTFILES = \
	configure.ac COPYING Makefile.devel Makefile.in README.md update-autoconf-build-aux.sh \
	autoconf/missing \
	autoconf/config.sub \
	autoconf/compile \
	autoconf/config.guess \
	autoconf/ltmain.sh \
	autoconf/install-sh \
	autoconf/ar-lib \
	autoconf/mkinstalldirs

distdir : $(DISTFILES)
	for file in $(DISTFILES); do \
		if test -f $$file; then dir='.'; else dir='$(srcdir)'; fi; \
		distdir=`echo '$(distdir)'/$$file | sed -e 's|//*[^/]*$$||'`; \
		test -d "$$distdir" || mkdir -p "$$distdir" > /dev/null; \
		cp -rp "$$dir/$$file" '$(distdir)'/$$file || exit 1; \
	done

dist :
	abstmpdistdir=`pwd`/$(DIST_NAME) \
		&& mkdir -p $$abstmpdistdir \
		&& $(MAKE) distdir distdir="$$abstmpdistdir"

clean : 
	$(RM) -rf $(DIST_NAME)*
	$(RM) -f config.log config.status
