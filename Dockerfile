FROM python:2-alpine

RUN apk update && apk add --no-cache \
	imagemagick \
	libev-dev \
	gettext \
	build-base libffi-dev openssl-dev

RUN mkdir -p /code/data
ADD dugnad /code/
ADD lang /code/lang

WORKDIR code

# get python libs
RUN cd /code && \
	pip install --upgrade pip
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# set up dugnad config
RUN pip install virtualenv && \
	virtualenv ve && \
	. ve/bin/activate && \
	make

VOLUME /code/data
EXPOSE 8080
CMD ["python", "dugnad.py"]
