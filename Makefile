.PHONY = clean install test uninstall

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

install: package
	sudo dpkg -i $(DEB)

test: making test-lib.sh test-project/Makefile $(wildcard test-cases/*)
	ls test-cases/* | ./repeat $(n) | parallel --color-failed --halt now,fail=1 bash
	-@rm -rf /tmp/*-making-test-bed

publish: package
	rsync --chown aptly:aptly $(DEB) root@$(REP):/home/aptly/$(DEB)
	$(APTLY) repo add fita /home/aptly/$(DEB) -remove-files
	$(APTLY) snapshot create $(SNAP) from repo fita
	$(APTLY) publish snapshot $(SNAP)
	echo $(SNAP) > publish

uninstall:
	sudo dpkg -r remove

clean:
	rm -rf *_amd64 *.deb
	cd test-project && make clean
