FROM circleci/golang:1.17
MAINTAINER David Gaussinel <dgaussinel@prestaconcept.net>

ARG SHFMT_VER=v3.4.2
USER root

RUN gpg --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

RUN cd $(mktemp -d) && go mod init tmp && go get mvdan.cc/sh/v3/cmd/shfmt@${SHFMT_VER}

ARG SC_VER=0.8.0
RUN curl -OL https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v${SC_VER}.linux.x86_64.tar.xz \
    && tar xJf shellcheck-v${SC_VER}.linux.x86_64.tar.xz \
    && mv shellcheck-v${SC_VER}/shellcheck /usr/bin/ \
    && rm -rf shellcheck-v${SC_VER}

ADD scripts/entry.sh /entry.sh

ENTRYPOINT ["sh", "/entry.sh"]
