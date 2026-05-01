# Health Checks and Depends On

## Service Ordering

- `proxy` waits for `app` to become healthy.
- `app` waits for `db` to become healthy.

This improves startup ordering, but it does not replace runtime monitoring or restarts after a later failure.

## Health Checks

### Proxy

- Command: `wget -q -O /dev/null http://127.0.0.1/healthz || exit 1`
- Interval: `30s`
- Timeout: `5s`
- Retries: `3`

Nginx serves `/healthz` on port `80` and returns `200 ok`.

### App

- Command: fetch `http://127.0.0.1:8080/`
- Interval: `30s`
- Timeout: `10s`
- Retries: `5`

The app is considered healthy when the home page responds successfully.

### Database

- Command: `mysqladmin ping -h 127.0.0.1 -u root -p$$MYSQL_ROOT_PASSWORD --silent`
- Interval: `15s`
- Timeout: `5s`
- Retries: `10`

MySQL is considered healthy when it accepts local connections.
