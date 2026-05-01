# Reliability Tests

## 1. Cold Start

Command:

```bash
docker compose up -d --build
```

Expected result:

- `db`, `app`, and `proxy` become healthy
- the app is reachable through Nginx

## 2. HTTP to HTTPS Redirect

Command:

```bash
curl -I http://<host>
```

Expected result:

- `301` redirect to `https://<host>/`

## 3. HTTPS Response

Command:

```bash
curl -k https://<host>
```

Expected result:

- HTML response from the EpicBook app

## 4. Database Persistence

Test:

1. Insert a row in MySQL.
2. Restart the stack.
3. Query the row again.

Expected result:

- data remains because MySQL uses the `db-data` named volume

## 5. Proxy Restart

Command:

```bash
docker compose restart proxy
```

Expected result:

- app and db stay running
- proxy returns after a short interruption

## 6. Image Rollout

Test:

1. Build and push a new app image.
2. Update the deployed tag.
3. Redeploy.

Expected result:

- only the app container changes image
- database data remains intact
