HXTPACKAGES	= hxt-charproperties \
                  hxt-regex-xmlschema \
                  hxt-unicode \
                  hxt \
                  hxt-curl \
                  hxt-tagsoup \
                  hxt-xpath \
		  hxt-relaxng \

# TODO : hxt-xslt hxt-cache
# old packages: hxt-filter hxt-binary janus/janus-library

all	:
	$(foreach i,$(HXTPACKAGES), ( cd $i && cabal configure && cabal build && cabal install && cabal sdist; ); )
	ghc-pkg list

global	:
	$(foreach i,$(HXTPACKAGES), ( cd $i && cabal configure && cabal build && cabal sdist && sudo cabal install --global; ); )
	ghc-pkg list

clean	:
	$(foreach i,$(HXTPACKAGES), ( cd $i && cabal clean; ); )

test	:
	[ -d ~/tmp ] || mkdir ~/tmp
	cp test-Makefile ~/tmp/Makefile
	$(foreach i, $(HXTPACKAGES), rm -f $(wildcard ~/tmp/$i-*.tar.gz); )
	$(foreach i, $(HXTPACKAGES), cp $(wildcard $i/dist/$i-*.tar.gz) ~/tmp; )
	$(MAKE) -C ~/tmp all

unregister	:
	ghc-pkg list --simple-output | xargs --max-args=1 echo | egrep '(hxt(-[a-z]+)?-|janus-library-)' | xargs --max-args=1 ghc-pkg --force unregister
	ghc-pkg list

.PHONY	: all global clean test

