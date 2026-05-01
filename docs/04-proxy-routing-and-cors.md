# Proxy Routing and CORS

## Routing

The Nginx proxy has two listeners:

- Port `80`: returns `200` for `/healthz` and redirects all other traffic to HTTPS.
- Port `443`: terminates TLS and proxies requests to `app:8080`.

The HTTPS server forwards these headers to the app:

- `Host`
- `X-Real-IP`
- `X-Forwarded-For`
- `X-Forwarded-Proto`

## TLS

Nginx reads the certificate and key from:

- `/etc/nginx/certs/nginx.crt`
- `/etc/nginx/certs/nginx.key`

Those container paths come from the host bind mount `./nginx/ssl:/etc/nginx/certs:ro`.

## CORS

There is no explicit CORS policy in the current Nginx config or Express app. The deployment is intended to work as a same-origin web app behind the proxy.

If a separate frontend or browser client must call this app cross-origin, CORS headers need to be added intentionally.
