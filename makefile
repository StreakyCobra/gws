ifneq ($(wildcard config.mk),)
include config.mk
endif
PREFIX?=/usr/local
BIN?=$(PREFIX)/bin
DOC?=$(PREFIX)/share/doc/gws
BASH_COMPLETION?=/etc/bash_completion.d
ZSH_COMPLETION?=/usr/share/zsh/vendor-completions
GIT_CHECK=$(shell { [ -f .git/config ] && [ -x "$$(which git)" ]; } || echo git)
ifeq (,$(GIT_CHECK))
FORCE_INSTALL?=no
MAINTAINER?=$(shell git log -1 --format='%an <%ae>')
else
FORCE_INSTALL?=yes
endif

DIRECTORIES=$(BIN) $(DOC) $(BASH_COMPLETION) $(ZSH_COMPLETION)
INSTALL=$(BIN)/gws $(DOC)/changelog.gz $(DOC)/license $(DOC)/readme.md.gz $(BASH_COMPLETION)/gws $(ZSH_COMPLETION)/_gws
PACKAGE=gws_$(VERSION)
DEBIAN_TOOLS=dpkg dpkg-deb fakeroot
DEBIAN_FILES=$(shell ( cd debian; find . -type f ))
DEBIAN_TOOLS_CHECK=$(shell for tool in $(DEBIAN_TOOLS); do which $$tool 2>&1 > /dev/null || echo $$tool; done )

ifeq (,$(GIT_CHECK))
VERSION=$(shell git describe --tags)
endif

help:
	$(info Available targets are:)
	$(info $(tab)- test:                prepares a workspace for manual tests)
	$(info $(tab)- install (as root):   install gws with $(PREFIX) preffix)
	$(info $(tab)- uninstall (as root): uninstall gws with $(PREFIX) preffix)
ifeq (,$(DEBIAN_TOOLS_CHECK))
	$(info $(tab)- debian:              build a Debian package)
endif
	$(info $(tab)- clean:               clean built stuff)

all:

$(INSTALL): pre.install

install: $(INSTALL)

pre.install:
ifeq (,$(GIT_CHECK))
	$(if $(findstring yes,$(FORCE_INSTALL)),,\
		$(info Check Git repository status before install)\
		@git diff-index --quiet HEAD\
	)
else
ifeq (,$(VERSION))
	$(error Please define VERSION)
endif
endif
	@echo Install version: $(VERSION)

uninstall:
	rm -f $(INSTALL)
	rmdir $(DOC)

ifeq (,$(DEBIAN_TOOLS_CHECK))
debian: pre.package.check $(PACKAGE)_all.deb
endif

test:
	$(MAKE) --directory=tests

clean:
	$(MAKE) --directory=tests clean
	rm -rf gws_*

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

$(PACKAGE)_all.deb: $(addprefix $(PACKAGE)/DEBIAN/,$(DEBIAN_FILES))
	$(MAKE) install PREFIX=$(PACKAGE)/usr BASH_COMPLETION=$(PACKAGE)/$(BASH_COMPLETION) ZSH_COMPLETION=$(PACKAGE)/$(ZSH_COMPLETION)
	fakeroot dpkg --build $(PACKAGE)

pre.package.check:
ifeq (,$(MAINTAINER))
	$(error Please define MAINTAINER)
endif

define tab
	
endef

.PHONY: all test install uninstall debian pre.install pre.package.check
