PREFIX:=/usr/local
BIN:=$(PREFIX)/bin
DOC:=$(PREFIX)/share/doc/gws
BASH_COMPLETION:=/etc/bash_completion.d
ZSH_COMPLETION:=/usr/share/zsh/vendor-completions

DIRECTORIES=$(BIN) $(DOC) $(BASH_COMPLETION) $(ZSH_COMPLETION)
INSTALL=$(BIN)/gws $(DOC)/changelog.gz $(DOC)/licence $(DOC)/readme.md.gz $(BASH_COMPLETION)/gws $(ZSH_COMPLETION)/_gws

.PHONY: all test

all: test

install: $(INSTALL)

uninstall:
	rm -f $(INSTALL)
	rmdir $(DOC)

test:
	$(MAKE) --directory=tests

clean:
	$(MAKE) --directory=tests clean

$(DIRECTORIES):
	[ -d $@ ] || mkdir $@

$(BIN)/gws: src/gws $(BIN)
	cp $< $@

$(DOC)/changelog.gz: CHANGELOG $(DOC)
	gzip -c $< > $@

$(DOC)/licence: LICENSE $(DOC)
	cp $< $@

$(DOC)/readme.md.gz: README.md $(DOC)
	gzip -c $< > $@

$(ZSH_COMPLETION)/_gws: completions/zsh $(ZSH_COMPLETION)
	cp $< $@

$(BASH_COMPLETION)/gws: completions/bash $(BASH_COMPLETION)
	cp $< $@
