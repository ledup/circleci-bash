FROM circleci/golang:1.10.2
MAINTAINER David Gaussinel <dgaussinel@prestaconcept.net>

USER root

RUN apt-get -y install haskell-platform 

RUN go get -u mvdan.cc/sh/cmd/shfmt

USER circleci

RUN cabal update \
    && cabal install ShellCheck

ENV PATH="/home/circleci/.cabal/bin:${PATH}"

