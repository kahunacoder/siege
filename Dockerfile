ARG OS_VER=20.04
ARG OS_IMAGE=ubuntu

# build stage
FROM ${OS_IMAGE}:${OS_VER} AS builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git build-essential curl unzip automake zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists

# build openssl
ARG OPENSSL_VER="3.5.0"
ARG OPENSSL_REPO=https://github.com/openssl/openssl.git
RUN git clone -b openssl-${OPENSSL_VER} --depth 1 ${OPENSSL_REPO}
RUN cd /openssl && ./config && make depend && make -j && make install_sw

# build siege with openssl
ARG SIEGE_VER=v4.1.7
ARG SIEGE_REPO=https://github.com/JoeDog/siege.git
RUN git clone --depth 1 -b ${SIEGE_VER} ${SIEGE_REPO} && cd siege && utils/bootstrap && ./configure --with-ssl=/usr/local/bin/openssl && make && make install

FROM ${OS_IMAGE}:${OS_VER}
COPY --from=builder /usr/local/ /usr/local/
RUN echo "/usr/local/lib64" >> /etc/ld.so.conf.d/all-libs.conf && ldconfig
RUN openssl version -v -e


VOLUME /root
ENTRYPOINT ["/usr/local/bin/siege"]
CMD ["--help"]
# docker build -t siege:latest .
