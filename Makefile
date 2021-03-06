BUILDTIME = $(shell date -u --rfc-3339=seconds)
GITHASH = $(shell git describe --dirty --always --tags)
GITCOMMITNO = $(shell git rev-list --all --count)
SHORTBUILDTAG = $(GITCOMMITNO).$(GITHASH)
BUILDINFO = Build Time:$(BUILDTIME)
LDFLAGS = -X 'main.buildTag=$(SHORTBUILDTAG)' -X 'main.buildInfo=$(BUILDINFO)'
BINNAME = changeme

.PHONY: build

depend: deps
deps:
	go mod tidy
	go mod vendor

build:
	CGO_ENABLED=0 go build -ldflags "$(LDFLAGS)" -o ./bin/$(BINNAME) ./cmd/$(BINNAME)

docker-build:
	docker build -t $(BINNAME) .

run:
	CGO_ENABLED=0 go run -ldflags "$(LDFLAGS)" ./...

version: 
	@echo $(SHORTBUILDTAG)