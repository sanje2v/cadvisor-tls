ARG CADVISOR_VERSION=0.47.2
ARG STUNNEL_VERSION=5.72

FROM gcr.io/cadvisor/cadvisor:v$CADVISOR_VERSION as stunnel-build-stage

ARG STUNNEL_VERSION

WORKDIR /

RUN apk update && apk add build-base openssl-dev

RUN wget https://www.stunnel.org/downloads/stunnel-${STUNNEL_VERSION}.tar.gz
RUN tar -xvf stunnel-${STUNNEL_VERSION}.tar.gz

WORKDIR /stunnel-${STUNNEL_VERSION}

RUN ./configure --enable-static=no --enable-shared=no --prefix=/stunnel/install
RUN make -j4 && make install


FROM gcr.io/cadvisor/cadvisor:v$CADVISOR_VERSION

RUN apk update && apk add openssl

COPY --from=stunnel-build-stage /stunnel/install /usr/local

COPY ./stunnel.conf /etc/stunnel/

EXPOSE 8081/tcp

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT /entrypoint.sh
