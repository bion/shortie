# Shortie

A web service for url-shortening.

## Setup

To run the service locally, run the following on the command line from
the project's root directory:

```bash
rvm install 2.4.1 && cd . # if ruby-v2.4.1 not installed
gem install bundler
bundle
rake db:setup
rails s
```

## Tests

Run the test suite from the command line to ensure everything is
working properly:

```bash
rspec
```

## Usage

### Creation

URLs are shortened using a JSON API available at `/api/links`. Here is
a simple example of creating a shortened link
using [curl](https://curl.haxx.se/) from the command line:

```bash
curl \
  -X POST \
  -d '{"link": { "original_url": "https://theguardian.com/us" }}' \
  -H 'Content-Type: application/json' \
  localhost:3000/api/links

# => { "short_url": "http://localhost:3000/l/2a18d2" }
```

The only required parameter for `link` is `original_url`. The
shortened link will expire in seven days by default unless otherwise
specified (see below).

### Consumption

Shortened links can be resolved to the original URL by pasting them
directly into a web-browser or looking them up using the JSON API.

Here is a simple example of resolving a shortened link
using [curl](https://curl.haxx.se/) from the command line:

```bash
curl -H 'Content-Type: application/json' localhost:3000/api/links/us-guardian
# => { "original_url": "https://theguardian.com/us" }
```

### Errors

If the link is not successfully created an error status code will be
returned and an error message will be presented under the key `errors`
in the response JSON.

### Options

#### `short_name`

Allows the request to specify the shortened URL path. E.g.

```bash
curl \
  -X POST \
  -d '{"link": { "original_url": "https://theguardian.com/us", "short_name": "us-guardian" }}' \
  -H 'Content-Type: application/json' \
  localhost:3000/api/links

# => { "short_url": "http://localhost:3000/l/us-guardian" }
```

#### `expiration_type`

Values can be `none` or `days`. If `none` the shortened URL will not
expire. If `days`, `expiration_units` may specify a number of days
until the link expires.

#### `expiration_units`

See `expiration_type`.
