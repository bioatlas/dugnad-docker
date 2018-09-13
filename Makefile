PWD := $(shell pwd)

all: build up test
.PHONY: all

init:
	@test -d dugnad || git clone --depth=1 \
		https://github.com/mskyttner/dugnad
	cp requirements.txt config.yaml dugnad
	cp dugnad-Makefile dugnad/Makefile
#	cp plan.yaml dugnad/projects/plan.yaml

build: 
	docker build --tag bioatlas/dugnad:latest .

debug:
	docker run --rm -it \
		-p 8080:8080 -v $(PWD)/data:/code/data \
		bioatlas/dugnad:latest ash

up:
	docker run --name dugnad -d \
		-p 8080:8080 -v $(PWD)/data:/code/data \
		bioatlas/dugnad:latest
	docker logs -f dugnad &

test:
	firefox http://localhost:8080/ & 

clean:
	docker stop dugnad
	docker rm dugnad
