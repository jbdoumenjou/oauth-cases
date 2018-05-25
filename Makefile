.PHONY: all

EXECUTABLE := server
REPO := jbdoumenjou

default: clean build

clean:
	rm -f ${EXECUTABLE}

build:
	go build -o ${EXECUTABLE}

image: build
	docker build -t ${REPO}/oauth2.v3:1.0.0 .