# Runbook

## Start or Recreate the Stack

```bash
docker compose up -d --build
```

## View Status

```bash
docker compose ps
docker compose logs -f
```

## Restart One Service

```bash
docker compose restart proxy
docker compose restart app
docker compose restart db
```

## Check TLS Files

```bash
ls -l nginx/ssl
```

Expected files:

- `nginx.crt`
- `nginx.key`

## Check Health Quickly

```bash
curl -I http://localhost
curl -k https://localhost
docker compose ps
```

## Database Shell

```bash
docker exec -it epicbook-db mysql -u root -p
```

## Stop the Stack

```bash
docker compose down
```

Use `docker compose down -v` only if you intentionally want to remove persistent volumes.
