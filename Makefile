.PHONY = clean test package install uninstall

VERSION = 0.0.$(shell git rev-list HEAD --count)
PKG = making_$(VERSION)_1_amd64
DEB = $(PKG).deb
DESCRIPTION = $(shell ./making -h | sed -n 2p | cut -d- -f2 | xargs)
DISK_USAGE = $(shell du -bs making | cut -d'	' -f1)

REP = aptly.fita.dev
APTLY = ssh root@$(REP) runuser -u aptly -- /home/aptly/bin/aptly
SNAP = $(shell date -Im)

n ?= 1

package: $(DEB)
$(DEB): control making
	mkdir -p $(PKG)/DEBIAN $(PKG)/usr/bin
	sed 's/{{VERSION}}/$(VERSION)/; s/{{DESCRIPTION}}/$(DESCRIPTION)/; s/{{DISK_USAGE}}/$(DISK_USAGE)/' control > $(PKG)/DEBIAN/control
	cp making $(PKG)/usr/bin
	dpkg-deb --build $(PKG)

test: making test-lib.sh test-project/Makefile $(wildcard test-cases/*)
	ls test-cases/* | ./repeat $(n) | parallel --color-failed --halt now,fail=1 bash
	-@rm -rf /tmp/*-making-test-bed

publish: $(DEB)
	rsync --chown aptly:aptly $(DEB) root@$(REP):/home/aptly/$(DEB)
	$(APTLY) repo add -remove-files fita /home/aptly/$(DEB)
	$(APTLY) snapshot create $(SNAP) from repo fita
	$(APTLY) publish snapshot $(SNAP) filesystem:aptly.fita.dev:.
	echo $(SNAP) > publish

install: $(DEB)
	sudo dpkg -i $(DEB)
uninstall: $(DEB)
	sudo dpkg -r making

clean:
	rm -rf *_amd64 *.deb publish
	cd test-project && make clean
