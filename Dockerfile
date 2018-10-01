FROM python:2-alpine3.8

# build vips with pdf support from source

ARG VIPS_VERSION=8.7.0
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN apk update && apk add --no-cache \
	bash gettext \
	libffi-dev openssl-dev \
	autoconf \
    automake \
    libtool \
    zlib-dev \
    libxml2-dev \
    jpeg-dev \
    openjpeg-dev \
    tiff-dev \
    glib-dev \
    gdk-pixbuf-dev \
    sqlite \
    sqlite-dev \
    libjpeg-turbo-dev \
    libexif-dev \
    lcms2-dev \
    fftw-dev \
    giflib-dev \
    libpng-dev \
    libwebp-dev \
    orc-dev \
    poppler-dev \
    librsvg-dev \
    libgsf-dev \
    openexr-dev \
    gtk-doc \
	gcc \
	g++ \
	make \
	qpdf

RUN wget -O- ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | tar xzC /tmp
RUN cd /tmp/vips-${VIPS_VERSION} \
        && ./configure --prefix=/usr --disable-static --disable-debug \
        && make V=0 \
        && make install

# TODO: what is the best way to remove build deps?
# https://stackoverflow.com/questions/48596345/cannot-pecl-install-on-docker-alpine3-7



# add dugnad files incl translations, configs etc
RUN mkdir -p /code/data /code/static/plan
ADD dugnad /code/
ADD lang /code/lang
ADD plan.yaml /code/projects
WORKDIR /code
RUN chmod +x scripts/pdf2dzi.sh

# get python deps
RUN cd /code && \
	pip install --upgrade pip
RUN pip install --upgrade pip

RUN pip install -r requirements.txt && \
	make

VOLUME /code/data
EXPOSE 8080

CMD ["python", "dugnad.py"]
