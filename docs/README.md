# Rust Meets Elm
> Example application written in Rust and Elm

This is an example application built with Rust and Elm for the purposes of illustration of a multi-language/platform application baked into a single Docker image.

Rust is responsible for the backend endpoints and serving the application while Elm runs on the browser, taking care of the application UI.

Such structures make it quite easy to distribute your application since there are no additional files and Rust/Elm are quite awesome together.

## Endpoints

The root endpoint of the application is rendering the entrypoint for Elm, but is quite easy to have routing done differently.
There is also an API endpoint to have direct backend connnection with Rust.

* `:8000/` - root page, it renders the `dist/index.html`.
* `:8000/api/hello` - sample endpoint for testing purposes.

## Available commands
> All with Makefile

Couple make commands that ensure you can get around easily

```
help          Lists the available commands
docker-build  Builds the core docker image compiling source for Rust and Elm
docker-run    Runs the latest docker generated image
docker-test   Tests the latest docker generated image
docs-install  Installs documentation-related dependencies
docs          Starts a local server to show docs
test-all      Tests everything, EVERYTHING

```

## Folder Structure
> What is what

```
├── LICENSE - License file
├── Makefile - Frequent commands/Tasks
├── api - Rust application root folder
│   ├── Cargo.lock
│   ├── Cargo.toml
│   └── src
│       └── main.rs - Rust application entrypoint
├── docker - Docker build root folder
│   ├── Dockerfile
│   ├── .dockerignore - Ignore file for docker context
│   └── goss.yaml - Test declaration for the release docker image
├── docs
│   └── README.md - This file.
└── ui - Elm application root folder
    ├── dist
    │   ├── assets
    │   │   └── application.js - Elm application binary¹
    │   └── index.html - Static index.html file
    ├── elm.json
    └── src
        └── Application.elm - Elm application entrypoint
```

¹ Only present after build

### Docker Image

In order to deliver a sweet Rust http backend server and statically-served Elm user-interface we have to use a 3-way multi-stage build.

1. Build the backend api, targeting rust to `x86_64-unknown-linux-musl` (for Linux Alpine). -> `api binary`
2. Build the elm application `ui/dist/assets/application.js`
3. Blend the compiled binary and the static assets all into a extremelly small `alpine` image.

The resulting image has around 10MB.

The resulting image has the following structure:

```
home/
├── api - compiled binary
└── ui - user-interface related content
    ├── assets - compiled assets
    │   │── application.js - compiled Elm application
    │   └── ...
    └── index.html - static html file
```

When you access `localhost:8000/` it renders the `index.html` file.

#### Docker Testing

We're using `dgoss` to test the docker-image, see: https://github.com/aelsabbahy/goss/.

Check `docker/goss.yaml` for more info.

# Contributing

TODO: Add a contributing guide
