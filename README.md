# Wikimedia Italia OSM tiles

Custom OSM tiles for Wikimedia Italia.

## Server setup

Instructions for Debian Trixie.
podman has been preferred to docker, as it is included in the Debian repositories and it is better integrated with both systemd and cockpit.

### System dependencies

```bash
sudo apt install podman passt aardvark-dns cockpit cockpit-podman pcp
```

### Monitoring

Enable Cockpit and PCP for system monitoring:

```bash
sudo systemctl enable --now cockpit.socket pmcd pmlogger
```

Cockpit will be available at `https://your-server:9090`.

### Podman configuration

Enable rootless Podman for your user:

```bash
loginctl enable-linger $(whoami)
systemctl --user enable --now podman.socket
```

#### Binding to privileged ports

Rootless Podman cannot bind to ports 80/443 by default. To allow it:

```bash
sudo sysctl -w net.ipv4.ip_unprivileged_port_start=80
echo 'net.ipv4.ip_unprivileged_port_start=80' | sudo tee /etc/sysctl.d/50-unprivileged-ports.conf
```

## Initialization

Download `planet-latest.osm.pbf` into `data/init/`.
Populate `data/hiking/` with the `.tif` raster files and contour data required by the hiking style
(see [INSTALL.md](https://github.com/osmItalia/openstreetmap-hiking/blob/master/INSTALL.md)).

Copy the example env file and configure it:

```bash
cp env.example .env
```

Set the ACME email, domain name, and Postgres credentials in `.env`.
Set `DOCKER_SOCK` to your Podman socket path:

```bash
echo "DOCKER_SOCK=$(podman info --format '{{.Host.RemoteSocket.Path}}')" >> .env
```

### Prepare data directories

```bash
mkdir -p data/{postgres,tiles,hiking,cache,init,external,traefik}
touch data/traefik/acme.json && chmod 600 data/traefik/acme.json
podman unshare chown -R 999:999 data/postgres
```

### Build and import

```bash
podman compose build
podman compose --profile init build
podman compose --profile init run --rm import
podman compose --profile init down
```

## Run

```bash
podman compose up -d
```
