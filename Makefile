BIN = dive

all: clean build

run: build
	docker image ls | grep "dive-test" >/dev/null || docker build -t dive-test:latest .
	./build/$(BIN) dive-test

build:
	go build -o build/$(BIN)

release: test
	./.scripts/tag.sh
	goreleaser --rm-dist

install:
	go install ./...

test: build
	go test -cover -v ./...

lint: build
	golint -set_exit_status $$(go list ./...)

clean:
	rm -rf build
	rm -rf vendor
	go clean

.PHONY: build install test lint clean release
