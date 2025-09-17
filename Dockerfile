FROM ubuntu:14.04

LABEL maintainer="franz.developer@proton.me"

# docker build -t my-firebird-2.5.9 .
# docker run -d --name firebird259 -v ./db:/firebird/data -p 3050:3050 my-firebird-2.5.9 (agregar persistencia y definir uso de recursos "CPU y RAM")
# docker exec -it firebird259 /bin/bash

ENV PREFIX=/usr/local/firebird
ENV VOLUME=/firebird
ENV DEBIAN_FRONTEND=noninteractive
ENV FBURL=https://github.com/FirebirdSQL/firebird/releases/download/R2_5_9/Firebird-2.5.9.27139-0.tar.bz2
ENV DBPATH=/firebird/data

# Install build dependencies
RUN apt-get update && apt-get install -qy --no-install-recommends \
    bzip2 ca-certificates curl g++ gcc libicu52 libicu-dev libncurses5-dev make \
 && mkdir -p /home/firebird \
 && cd /home/firebird \
 && curl -L -o firebird-source.tar.bz2 "${FBURL}" \
 && tar --strip=1 -xf firebird-source.tar.bz2 \
 && ./configure \
      --prefix=${PREFIX} --with-fbbin=${PREFIX}/bin --with-fbsbin=${PREFIX}/bin \
      --with-fblib=${PREFIX}/lib --with-fbinclude=${PREFIX}/include \
      --with-fbdoc=${PREFIX}/doc --with-fbudf=${PREFIX}/UDF \
      --with-fbsample=${PREFIX}/examples --with-fbsample-db=${PREFIX}/examples/empbuild \
      --with-fbhelp=${PREFIX}/help --with-fbintl=${PREFIX}/intl \
      --with-fbmisc=${PREFIX}/misc --with-fbplugins=${PREFIX} \
      --with-fblog=${VOLUME}/log --with-fbglock=/var/firebird/run \
      --with-fbconf=${VOLUME}/etc --with-fbmsg=${PREFIX} \
      --with-fbsecure-db=${VOLUME}/system --with-system-icu \
 && make && make silent_install \
 && cd / && rm -rf /home/firebird \
 && find ${PREFIX} -name .debug -prune -exec rm -rf {} \; \
 && apt-get purge -qy --auto-remove libncurses5-dev bzip2 curl gcc g++ make libicu-dev \
 && rm -rf /var/lib/apt/lists/*

VOLUME ["/firebird"]

EXPOSE 3050

CMD ["/usr/local/firebird/bin/fbguard"]
