# WordPress deployment and operations lab

Docker Compose deployment for WordPress, MySQL, phpMyAdmin, Nginx HTTPS reverse proxy, Prometheus, Grafana, cAdvisor, Loki, and Promtail.

## Prerequisites

- Docker Desktop with the Compose plugin
- OpenSSL available in PowerShell (`openssl version`)
- Ports 80, 443, and 3001 available on the host

## First-time setup (PowerShell)

Run these commands from the repository root:

```powershell
Copy-Item .env.example .env
New-Item -ItemType Directory -Force nginx/ssl
```

Edit `.env` and replace every `REPLACE_WITH_...` value with a unique strong password. For example, generate hex-only values with `openssl rand -hex 24`; use different values for the MySQL root, WordPress, metrics, and Grafana accounts. The MySQL metrics password must use only letters, numbers, underscores, and hyphens.

Create a local self-signed certificate (do not commit the private key):

```powershell
openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
  -keyout nginx/ssl/nginx-selfsigned.key `
  -out nginx/ssl/nginx-selfsigned.crt `
  -subj "/CN=localhost" `
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
```

Validate the Compose configuration and start the stack:

```powershell
docker compose config --quiet
docker compose up -d
docker compose ps
```

The first start may take a few minutes while Docker downloads images and initializes the database. Open `https://localhost` and accept the browser warning for the self-signed certificate.

## Service URLs and accounts

| Service | URL | Login |
|---|---|---|
| WordPress | <https://localhost> | Create the WordPress administrator during the initial setup |
| phpMyAdmin | <https://localhost/phpmyadmin/> | Use `MYSQL_USER` / `MYSQL_PASSWORD` from `.env`; root is available for administration |
| Grafana | <http://localhost:3001> | Username `admin`; password from `GF_SECURITY_ADMIN_PASSWORD` |
| Prometheus | Internal only | Open Grafana Explore using the provisioned Prometheus data source |
| Loki | Internal only | Open Grafana Explore using the provisioned Loki data source |

The database is not published to a host port. WordPress and phpMyAdmin reach it over the isolated backend network. Prometheus and Loki also remain internal to the Compose network.

## Monitoring

Grafana provisions Prometheus and Loki data sources and the **WordPress deployment lab** dashboard automatically. In Grafana, open **Dashboards → Deployment lab** to view container CPU/memory, Nginx request rate, and MySQL connected threads. Open **Explore**, choose **Prometheus**, then try:

```promql
up
container_memory_working_set_bytes
rate(nginx_http_requests_total[5m])
mysql_global_status_threads_connected
```

The `up` result should include `prometheus`, `cadvisor`, `nginx`, and `mysql`. cAdvisor supplies container metrics; the Nginx and MySQL exporters supply web server and database metrics. Build a Grafana dashboard from these queries for the demo.

## Centralized logs (LogQL)

Nginx access and error logs are written under `nginx/logs/` and collected by Promtail. In Grafana **Explore**, select Loki and run:

```logql
{job="nginx"}
{job="nginx"} |= " 404 "
{job="nginx"} |~ " 5[0-9]{2} "
```

Generate requests to the site (including a nonexistent URL for the 404 query) to produce fresh log lines. The last query matches server-error responses.

## Hardening included

- MySQL is not published to the host and is attached to an internal backend network.
- The application DB user is separate from MySQL root; the MySQL exporter uses a dedicated read-only metrics account.
- Nginx, Prometheus, Loki, and exporters have pinned image tags rather than `latest`.
- Nginx redirects HTTP to HTTPS, disables version disclosure, and sets security headers.
- The Nginx status endpoint listens on an internal-only container port.
- Grafana credentials are supplied through the ignored `.env`; TLS private keys, local certificates, and logs are excluded from Git.
- cAdvisor uses read-only host mounts because container monitoring requires host metadata. Do not expose its endpoint publicly.

A self-signed certificate encrypts local demo traffic but does not provide a publicly trusted identity. Do not reuse these demo credentials in production.

## Useful operations

```powershell
docker compose logs -f nginx wordpress db prometheus grafana loki promtail
docker compose down
```

`docker compose down` preserves named data volumes. Removing the MySQL volume permanently deletes the database; only do so when intentionally resetting the lab.

The MySQL exporter account is created by `mysql/init/01-create-exporter-user.sh` only when MySQL initializes a new data directory. If the database volume already existed before adding this account, create the `MYSQL_EXPORTER_USER` account manually in MySQL with `PROCESS`, `REPLICATION CLIENT`, and `SELECT` privileges, using the credentials in `.env`. Do not delete an existing database volume just to rerun initialization unless you have backed up its data.

## Report and demo evidence

The repository contains deployment configuration and a [report outline](docs/report-outline.md), not fabricated run results or screenshots. Before submission, complete a report of at least 10 pages with the student's details and actual screenshots showing:

1. Repository and meaningful commit history.
2. Compose services and network/volume structure.
3. WordPress setup and a successful database connection.
4. phpMyAdmin access and the WordPress database.
5. Nginx HTTPS and response security headers.
6. Prometheus targets in the `UP` state.
7. Grafana dashboard panels for container, Nginx, and MySQL metrics.
8. Loki receiving Nginx logs and at least three successful LogQL queries.
9. Hardening choices and relevant configuration evidence.
10. Successful startup/status of the complete Compose stack.

Only include screenshots captured from your own running deployment. Replace the placeholders in `.env.example` locally and never commit `.env`, passwords, or private keys.
