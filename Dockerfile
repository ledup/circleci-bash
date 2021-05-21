FROM circleci/golang:1.15.2
MAINTAINER David Gaussinel <dgaussinel@prestaconcept.net>

ARG SHFMT_VER=v3.3.0
USER root
RUN apt-get update && apt-get -y install haskell-platform && rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

RUN cd $(mktemp -d) && go mod init tmp && go get mvdan.cc/sh/v3/cmd/shfmt@${SHFMT_VER}

ARG SC_VER=0.7.2
RUN cabal update \
    && cabal install --force-reinstalls ShellCheck-${SC_VER} \
    && mv /root/.cabal/bin/shellcheck /usr/bin/shellcheck \
    && rm -rf /root/.cabal

ADD scripts/entry.sh /entry.sh

ENTRYPOINT ["sh", "/entry.sh"]
