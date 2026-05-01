# Environment Variables and Ports

## Environment Variables

The stack reads these variables from `.env`:

- `MYSQL_DATABASE`: MySQL schema name.
- `MYSQL_USER`: application database user.
- `MYSQL_PASSWORD`: password for `MYSQL_USER`.
- `MYSQL_ROOT_PASSWORD`: MySQL root password.
- `APP_IMAGE`: optional remote image name for the `app` service.
- `APP_TAG`: optional remote image tag for the `app` service.

`DB_URL` is not stored directly in `.env`. `docker-compose.yml` builds it as:

```text
mysql://${MYSQL_USER}:${MYSQL_PASSWORD}@db:3306/${MYSQL_DATABASE}
```

## Ports

- `80:80`: Nginx HTTP listener. Redirects normal traffic to HTTPS.
- `443:443`: Nginx HTTPS listener.
- `8080`: internal Node.js app port on the private Docker network.
- `3306`: internal MySQL port on the private Docker network.

Only ports `80` and `443` are exposed to clients.
