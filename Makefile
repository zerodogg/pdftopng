# PDFtoPNG makefile

VERSION=0.1.1

ifndef prefix
# This little trick ensures that make install will succeed both for a local
# user and for root. It will also succeed for distro installs as long as
# prefix is set by the builder.
prefix=$(shell perl -e 'if($$< == 0 or $$> == 0) { print "/usr" } else { print "$$ENV{HOME}/.local"}')
endif

BINDIR ?= $(prefix)/bin
DATADIR ?= $(prefix)/share

# Install pdftopng
install:
	mkdir -p "$(BINDIR)"
	cp pdftopng "$(BINDIR)"
	chmod 755 "$(BINDIR)/pdftopng"
	[  -e pdftopng.1 ] && mkdir -p "$(DATADIR)/man/man1" && cp pdftopng.1 "$(DATADIR)/man/man1" || true
# Unisntall an installed pdftopng
uninstall:
	rm -f "$(BINDIR)/pdftopng"
# Clean up the tree
clean:
	rm -f `find|egrep '~$$'`
	rm -f pdftopng-$(VERSION).tar.bz2
	rm -rf pdftopng-$(VERSION)
	rm -f pdftopng.1
# Verify syntax
test:
	@perl -c pdftopng
	@perl -c devel-tools/SetVersion
# Create a manpage from the POD
man:
	pod2man --name "pdftopng" --center "" --release "PDFtoPNG $(VERSION)" ./pdftopng ./pdftopng.1
# Create the tarball
distrib: clean test man
	mkdir -p pdftopng-$(VERSION)
	cp -r ./`ls|grep -v pdftopng-$(VERSION)` ./pdftopng-$(VERSION)
	rm -rf `find pdftopng-$(VERSION) -name \\.svn`
	tar -jcvf pdftopng-$(VERSION).tar.bz2 ./pdftopng-$(VERSION)
	rm -rf pdftopng-$(VERSION)
