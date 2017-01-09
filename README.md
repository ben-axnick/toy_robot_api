# Toy Robot API

This project provides an endpoint for running Toy Robot Commands.  It utilizes
a Docker container and is deployed into Convox, an open-source, internal
Heroku.

## Status

[![Build Status](https://travis-ci.org/bentheax/toy_robot_api.svg?branch=master)](https://travis-ci.org/bentheax/toy_robot_api)
[![Code Climate](https://codeclimate.com/github/bentheax/toy_robot_api/badges/gpa.svg)](https://codeclimate.com/github/bentheax/toy_robot_api)
[![Test Coverage](https://codeclimate.com/github/bentheax/toy_robot_api/badges/coverage.svg)](https://codeclimate.com/github/bentheax/toy_robot_api/coverage)

## API Docs

Provided as a Swagger
[template file](https://toy-robot-api.pickaxe.me/assets/swagger.yaml).
Website provided via
[Swagger UI](http://petstore.swagger.io/?url=https://toy-robot-api.pickaxe.me/assets/swagger.yaml#/default)

## Running

```
make run
```

## Testing

```
make test
```

## Usage

See `swagger.yml` for details of the API.
