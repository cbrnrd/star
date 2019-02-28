CRYSTAL_BIN ?= $(shell which crystal)
SHARDS_BIN ?= $(shell which shards)
STAR_BIN ?= $(shell which star)
PREFIX ?= /usr/local

build:
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
	mkdir -p $(PREFIX)/bin
	cp ./bin/star $(PREFIX)/bin

reinstall: build
	cp -rf ./bin/star $(STAR_BIN)