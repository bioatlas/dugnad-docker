DUGNAD_VERSION := 0.1.1

PWD := $(shell pwd)

all: build up test
.PHONY: all

init:
	@test -d dugnad || (wget \
		https://github.com/umeldt/dugnad/archive/v${DUGNAD_VERSION}.tar.gz && \
		tar xzf v${DUGNAD_VERSION}.tar.gz && mv dugnad-${DUGNAD_VERSION} dugnad && \
		rm v${DUGNAD_VERSION}.tar.gz)
	cp requirements.txt config.yaml dugnad
	cp plan.yaml dugnad/projects/plan.yaml

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
	-docker exec -it dugnad bash -c 'scripts/pdf2dzi.sh /code/data/plan.pdf /code/static/plan'
	docker logs -f dugnad &

test:
	xdg-open http://localhost:8080/ & 

clean:
	docker stop dugnad
	docker rm dugnad
