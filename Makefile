LINTER_VERSION=v1.45.0
LINTER=./bin/golangci-lint
ifeq ($(OS),Windows_NT)
	LINTER=./bin/golangci-lint.exe
endif

.PHONY: all
all: clean setup lint test

.PHONY: lint
lint:
	$(LINTER) run -c ./.golangci-lint.yml
	@make tidy
	@if ! git diff --quiet; then \
		echo "'go mod tidy' resulted in changes or working tree is dirty:"; \
		git --no-pager diff; \
	fi

.PHONY: setup
setup:
	go mod download
	@if [ ! -f "./bin/golangci-lint" ]; then \
		curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s $(LINTER_VERSION); \
	fi

.PHONY: test
test:
	go test --race ./...

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: cover
cover:
	go test -race -coverprofile=cover.out -coverpkg=./... ./...
	go tool cover -html=cover.out -o cover.html

.PHONY: clean
clean:
	go clean -testcache
	@if [ -f "cover.html" ]; then \
		rm -f cover.html; \
	fi
	@if [ -f "cover.out" ]; then \
		rm -f cover.out; \
	fi
