.PHONY = clean install test uninstall

A = /home/aptly/bin/aptly
VERSION = 0.0.$(shell git rev-list HEAD --count)
PKG = making_$(VERSION)_1_amd64
DEB = $(PKG).deb
DESCRIPTION = $(shell ./making -h | sed -n 2p | cut -d- -f2 | xargs)
DISK_USAGE = $(shell du -bs making | cut -d'	' -f1)
REP = aptly.fita.dev
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
	rsync --chown aptly:aptly $(DEB) root@$(REP):/home/aptly/debs/$(DEB)
	ssh root@$(REP) "runuser -u aptly -- $(A) repo add $(DEB) -remove-files"
	ssh root@$(REP) "runuser -u aptly -- $(A) snapshot create $(SNAP) from repo fita"
	ssh root@$(REP) "runuser -u aptly -- $(A) publish snapshot $(SNAP)"
	echo $(SNAP) > publish

uninstall:
	sudo dpkg -r remove

clean:
	rm -rf *_amd64 *.deb
	cd test-project && make clean
