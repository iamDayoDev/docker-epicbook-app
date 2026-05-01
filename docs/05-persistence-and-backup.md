# Persistence and Backup

## Persistent Data

The stack uses these persistent mounts:

- `db-data`: named volume for MySQL data at `/var/lib/mysql`
- `app-logs`: named volume mounted at `/app/logs`
- `./theepicbook/db:/docker-entrypoint-initdb.d:ro`: SQL seed files for first-time database initialization
- `./nginx/ssl:/etc/nginx/certs:ro`: TLS certificate and key
- `./logs/nginx:/var/log/nginx`: Nginx access and error logs

## Notes

- `db-data` is the main persistence layer.
- SQL files in `theepicbook/db` are loaded by the MySQL image only during first initialization of an empty data directory.
- The app currently logs to stdout/stderr; the `app-logs` volume is reserved but not actively written by the Node.js code.

## Backup Options

### Logical backup

```bash
docker exec epicbook-db sh -c 'mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"' > backup.sql
```

### Volume-level backup

```bash
docker run --rm -v docker-epicbook-app_db-data:/data -v ${PWD}:/backup alpine tar czf /backup/db-data.tar.gz /data
```

Adjust the named volume if Compose uses a different project name.
