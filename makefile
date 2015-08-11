PREFIX:=/usr/local
BIN:=$(PREFIX)/bin
DOC:=$(PREFIX)/share/doc/gws
BASH_COMPLETION:=/etc/bash_completion.d
ZSH_COMPLETION:=/usr/share/zsh/vendor-completions
FORCE_INSTALL:=no
MAINTAINER:=$(shell git log -1 --format='%an <%ae>')

VERSION=$(shell git describe --tags)
DIRECTORIES=$(BIN) $(DOC) $(BASH_COMPLETION) $(ZSH_COMPLETION)
INSTALL=$(BIN)/gws $(DOC)/changelog.gz $(DOC)/license $(DOC)/readme.md.gz $(BASH_COMPLETION)/gws $(ZSH_COMPLETION)/_gws
PACKAGE=gws-$(VERSION)
DEBIAN_FILES=$(shell ( cd debian; find . -type f ))

all: test

$(INSTALL): pre.install

install: $(INSTALL)

pre.install:
	$(if $(findstring yes,$(FORCE_INSTALL)),,\
		$(info Check repository status before install)\
		@git diff-index --quiet HEAD\
	)
	@echo Install version: $(VERSION)

uninstall:
	rm -f $(INSTALL)
	rmdir $(DOC)

debian: $(PACKAGE).deb

test:
	$(MAKE) --directory=tests

clean:
	$(MAKE) --directory=tests clean
	rm -rf gws-*

$(DIRECTORIES):
	@[ -d $@ ] || mkdir --parent $@

$(BIN)/gws: src/gws $(BIN)
	cp $< $@

$(DOC)/changelog.gz: CHANGELOG $(DOC)
	gzip -c $< > $@

$(DOC)/license: LICENSE $(DOC)
	cp $< $@

$(DOC)/readme.md.gz: README.md $(DOC)
	gzip -c $< > $@

$(ZSH_COMPLETION)/_gws: completions/zsh $(ZSH_COMPLETION)
	cp $< $@

$(BASH_COMPLETION)/gws: completions/bash $(BASH_COMPLETION)
	cp $< $@

$(PACKAGE)/DEBIAN/./control: debian/$(DEBIAN_FILES)
	[ -d $@ ] || mkdir --parent $(dir $@)
	fakeroot sed 's/@@version@@/$(VERSION)/; s/@@maintainer@@/$(MAINTAINER)/' $^ > $@

$(PACKAGE).deb: $(addprefix $(PACKAGE)/DEBIAN/,$(DEBIAN_FILES))
	$(MAKE) install PREFIX=$(PACKAGE)/usr BASH_COMPLETION=$(PACKAGE)/$(BASH_COMPLETION) ZSH_COMPLETION=$(PACKAGE)/$(ZSH_COMPLETION)
	fakeroot dpkg --build $(PACKAGE)

.PHONY: all test install uninstall debian
