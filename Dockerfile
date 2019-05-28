FROM circleci/golang:1.11.10
MAINTAINER David Gaussinel <dgaussinel@prestaconcept.net>

USER root
RUN apt-get update
RUN apt-get -y install haskell-platform

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

RUN cd $(mktemp -d) && go mod init tmp && go get mvdan.cc/sh/cmd/shfmt
USER circleci

RUN cabal update \
    && cabal install ShellCheck

ENV PATH="/home/circleci/.cabal/bin:${PATH}"

USER root

ADD scripts/entry.sh /entry.sh

ENTRYPOINT ["sh", "/entry.sh"]
