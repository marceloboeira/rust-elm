########## Global Arguments ############
ARG RUST_VERSION=nightly-2019-06-08
ARG RUST_SOURCE=api
ARG RUST_API_ROOT=/home/api
ARG RUST_TARGET=x86_64-unknown-linux-musl
ARG RUST_TARGET_FOLDER=$RUST_API_ROOT/target/$RUST_TARGET/release
ARG RUST_TARGET_BIN=$RUST_TARGET_FOLDER/api

ARG ELM_VERSION=0.19
ARG ELM_SOURCE=ui
ARG ELM_ROOT=/home/api
ARG ELM_TARGET_FOLDER=$ELM_ROOT/dist
ARG ELM_TARGET_FILE=$ELM_TARGET_FOLDER/assets/application.js

ARG ALPINE_VERSION=3.9.4
ARG RELEASE_HOME=/home/api
ARG RELEASE_ASSETS=$RELEASE_HOME/ui
ARG PORT=8000

############ Rust Build  ###############
FROM ekidd/rust-musl-builder:$RUST_VERSION AS rust-build

ARG RUST_VERSION
ARG RUST_SOURCE
ARG RUST_API_ROOT
ARG RUST_TARGET
ARG RUST_TARGET_FOLDER
ARG RUST_TARGET_BIN

# Re-own home
# https://github.com/emk/rust-musl-builder#making-static-releases-with-travis-ci-and-github
RUN sudo chown -R rust:rust /home

# Install and cache dependencies layers
# Rather than copying everything every time, re-use cached dependency layers
# to install/build deps only when Cargo.* files change.
RUN USER=root cargo new "$RUST_API_ROOT" --bin
WORKDIR $RUST_API_ROOT
COPY $RUST_SOURCE/Cargo.lock $RUST_API_ROOT/Cargo.lock
COPY $RUST_SOURCE/Cargo.toml $RUST_API_ROOT/Cargo.toml
RUN cargo build --bins --release --target $RUST_TARGET

# Load real sources
RUN rm $RUST_API_ROOT/src/*.rs
COPY $RUST_SOURCE/src $RUST_API_ROOT/src

# Delete dummy compiled binary
RUN rm $RUST_TARGET_FOLDER/deps/api*

# Rebuild with real sources
RUN cargo build --bins --release --target $RUST_TARGET

############ Elm Build  ################
FROM codesimple/elm:$ELM_VERSION AS elm-build

ARG ELM_VERSION
ARG ELM_SOURCE
ARG ELM_ROOT
ARG ELM_TARGET_FOLDER
ARG ELM_TARGET_FILE

WORKDIR $ELM_ROOT
COPY $ELM_SOURCE .
RUN elm make src/Application.elm --output $ELM_TARGET_FILE --optimize

########## API Release Image ###############
FROM alpine:$ALPINE_VERSION AS api

ARG ALPINE_VERSION
ARG RELEASE_HOME
ARG RELEASE_ASSETS
ARG RUST_TARGET_BIN
ARG ELM_TARGET_FOLDER
ARG PORT

LABEL maintainer="me+docker@marceloboeira.com"

WORKDIR $RELEASE_HOME

# Copy Rust artifacts
COPY --from=rust-build $RUST_TARGET_BIN .

# Copy Elm artifacts
COPY --from=elm-build $ELM_TARGET_FOLDER $RELEASE_ASSETS/

# Add release folder to the Path
ENV PATH $RELEASE_HOME:$PATH

# Expose HTTP Port
EXPOSE $PORT

CMD ["api"]
