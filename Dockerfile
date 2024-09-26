FROM eclipse-temurin:21

WORKDIR /build

RUN apt-get -yq update && \
  apt-get upgrade -yq && \
  apt-get -y --no-install-recommends \
  install \
    ant \
    ca-certificates \
    curl \
    sed \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

RUN curl -OL https://dlcdn.apache.org/flex/4.16.1/binaries/apache-flex-sdk-4.16.1-bin.tar.gz
RUN tar xvf apache-flex-sdk-4.16.1-bin.tar.gz
RUN mkdir -p apache-flex-sdk-4.16.1-bin/frameworks/libs/player/27.0

RUN curl -L \
  https://github.com/nexussays/playerglobal/raw/master/27.0/playerglobal.swc \
  -o apache-flex-sdk-4.16.1-bin/frameworks/libs/player/27.0/playerglobal.swc

RUN sed -i'' 's|{playerglobalHome}|libs/player|g' apache-flex-sdk-4.16.1-bin/frameworks/flex-config.xml

RUN cat apache-flex-sdk-4.16.1-bin/frameworks/flex-config.xml

COPY . /build/

ENV FLEX_HOME=/build/apache-flex-sdk-4.16.1-bin

CMD ant debug && \
  mv /build/target/CoC-debug.swf /build/artifacts/CoC-debug.swf
