CRYSTAL_BIN ?= $(shell which crystal)
SHARDS_BIN ?= $(shell which shards)
STAR_BIN ?= $(shell which star)
PREFIX ?= /usr/local
VERSION ?= $(shell cat src/star/constants.cr | grep VERSION | cut -d '"' -f 2)


build:
	$(shell mkdir -p ./bin)
	$(CRYSTAL_BIN) build --release -o bin/star src/star/main.cr $(CRFLAGS)

clean:
	rm -f ./bin/star
	
rm:
	rm -f $(PREFIX)/bin/star

test:
	$(CRYSTAL_BIN) spec --verbose

spec: test

deps:
	$(SHARDS_BIN)

install: deps build
	echo $(PREFIX)
	@mkdir -p bin
	cp ./bin/star $(PREFIX)/bin

reinstall: build
	cp -rf ./bin/star $(STAR_BIN)

release: deps build
	cd bin
	tar czvf star_$(VERSION)_release.tar.gz bin/*
	cd ..

	$(CRYSTAL_BIN) build --release src/star/main.cr $(CRFLAGS) --cross-compile --target "x86_64-unknown-linux-gnu" -o bin/star_x86_64-unknown-linux-gnu > bin/build_linux.sh
	$(CRYSTAL_BIN) build --release src/star/main.cr $(CRFLAGS) --cross-compile --target "x86_64-apple-darwin10" -o bin/star_x86_64-apple-darwin10 > bin/build_darwin.sh
	cd bin
	tar czvf star_$(VERSION)_object_files.tar.gz bin/*.o bin/*.sh
	