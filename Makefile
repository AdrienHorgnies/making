.PHONY = clean install uninstall

VERSION = $(shell git rev-list HEAD --count)
PKG = making_$(VERSION)_1_amd64
DEB = $(PKG).deb
DESCRIPTION = $(shell ./making -h | sed -n 2p | cut -d- -f2 | xargs)
DISK_USAGE = $(shell du -bs making | cut -d'	' -f1)

package: $(DEB)
$(DEB): control making
	mkdir -p $(PKG)/DEBIAN $(PKG)/usr/local/bin
	sed 's/{{VERSION}}/$(VERSION)/; s/{{DESCRIPTION}}/$(DESCRIPTION)/; s/{{DISK_USAGE}}/$(DISK_USAGE)/' control > $(PKG)/DEBIAN/control
	cp making $(PKG)/usr/local/bin
	dpkg-deb --build $(PKG)

install:
	sudo dpkg -i $(DEB)
uninstall:
	sudo dpkg -r remove

clean:
	rm -rf *_amd64 *.deb
