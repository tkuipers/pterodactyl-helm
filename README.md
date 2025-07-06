# Pterodactyl Helm Chart

This Helm chart deploys Pterodactyl Panel and Wings on Kubernetes using Docker-in-Docker (DinD) to enable game server hosting.

## Overview

Pterodactyl is a game server management panel that allows easy deployment and management of game servers. This Helm chart provides a Kubernetes-native way to deploy and manage both the Pterodactyl Panel (web UI) and Wings (game server daemon) components.

The chart uses a Docker-in-Docker approach for Wings, allowing it to create and manage game server containers within Kubernetes while maintaining compatibility with Pterodactyl's existing architecture.

## Components

This Helm chart includes:

- **Pterodactyl Panel**: The web interface and API
- **Wings**: The game server daemon that runs with privileged access to use Docker-in-Docker
- **MySQL/MariaDB**: Database for the Panel
- **Redis**: Cache and queue management
- **Queue Worker**: Background task processor
- **Game Server Port Exposure**: Service to expose game server ports

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Persistent volume provisioner support
- Ingress controller (like nginx-ingress)
- LoadBalancer support for game server ports

## Installation

1. Clone this repository
   ```bash
   git clone https://github.com/yourusername/pterodactyl-helm.git
   cd pterodactyl-helm
   ```

2. Customize the `values.yaml` file:
   ```bash
   # Edit values.yaml to match your environment
   vim values.yaml
   ```

3. Install the chart:
   ```bash
   helm install pterodactyl ./
   ```

## Configuration

Key configuration options in `values.yaml`:

### Global Settings
- `global.panelUrl`: Domain name for the Pterodactyl Panel

### Panel Settings
- `panel.image`: Container image settings
- `panel.env`: Environment variables for the Panel
- `panel.database`: Database connection details
- `panel.ingress`: Ingress configuration for web access

### Wings Settings
- `wings.securityContext`: Security settings (privileged: true is required for DinD)
- `wings.persistence`: Storage settings for Docker and game servers

### Database and Redis Settings
- `mysql`: MySQL/MariaDB configuration
- `redis`: Redis configuration

### Game Server Ports
- `gameServers.service`: Configuration for exposing game server ports

## Post-Installation Steps

After deployment:

1. Create the admin user:
   ```bash
   kubectl exec -it deployment/pterodactyl-panel -- php artisan p:user:make
   ```

2. Configure the Wings node in the Panel:
   - Add a new location in the admin area
   - Add a new node with:
     - FQDN: pterodactyl-wings.[NAMESPACE].svc.cluster.local
     - Port: 8080 (default)

3. Configure Wings:
   ```bash
   kubectl exec -it deployment/pterodactyl-wings -- wings configure
   ```

## Implementation Details

### Docker-in-Docker

This chart uses Docker-in-Docker to allow Wings to create and manage game server containers. This requires:

- Privileged containers
- Persistent storage for Docker and game server data

### Port Exposure

Game server ports are exposed through a LoadBalancer service with a defined port range. This allows direct connectivity to game servers.

## Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Ingress     │────▶│    Panel     │────▶│    MySQL     │
└──────────────┘     └──────────────┘     └──────────────┘
                           │
                           ▼
                    ┌──────────────┐     ┌──────────────┐
                    │    Redis     │◀───▶│Queue Worker  │
                    └──────────────┘     └──────────────┘
                           ▲
                           │
                           ▼
┌──────────────┐     ┌──────────────┐
│LoadBalancer  │◀───▶│    Wings     │
└──────────────┘     └──────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │Docker (DinD) │
                    └──────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │Game Servers  │
                    └──────────────┘
```

## Notes

- Wings runs in privileged mode, which has security implications in a Kubernetes environment
- Game server data is stored on persistent volumes
- Backup your database and persistent volumes regularly

## License

This Helm chart is provided under the MIT License. 