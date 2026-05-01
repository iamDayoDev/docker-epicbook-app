# Logging Layout

## Container Logging

All three services use Docker's `json-file` logging driver with rotation:

- `max-size: 10m`
- `max-file: 3`

This applies to:

- `proxy`
- `app`
- `db`

## Nginx Logs

Nginx also writes file logs to the host bind mount `./logs/nginx`:

- `access.log`
- `error.log`

The access log uses a JSON-style format with request, status, upstream, timing, referrer, user agent, and host fields.

## App and Database Logs

- App logs are available with `docker compose logs app`
- Database logs are available with `docker compose logs db`

The current Node.js app does not implement a separate file logger.
