FROM python:2-alpine

#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
#RUN apk update && apk upgrade

RUN apk update && apk add --no-cache \
	imagemagick \
	libev-dev \
	gettext \
	build-base libffi-dev openssl-dev \
	bash

RUN mkdir -p /code/data /code/static/plan
ADD dugnad /code/
ADD lang /code/lang

WORKDIR /code

# get python libs
RUN cd /code && \
	pip install --upgrade pip
RUN pip install --upgrade pip

# set up dugnad config
#RUN pip install virtualenv && \
#	virtualenv ve && \
#	. ve/bin/activate && \
#	pip install -r requirements.txt && \
#	make

RUN pip install -r requirements.txt && \
	make


RUN chmod +x scripts/pdf2dzi.sh

VOLUME /code/data
EXPOSE 8080
#CMD [". /code/ve/bin/activate && bash -c "scripts/pdf2dzi.sh /code/data/plan.pdf /code/static/plan" && python", "dugnad.py"]

CMD ["python", "dugnad.py"]
