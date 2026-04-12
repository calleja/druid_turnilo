## preface on .yaml files
- Use yaml validators like yamllint
- Use descriptive keys
- yaml is a markdown 
- Docker Compose files are typically in a yaml format
- oficial docker page: https://docs.docker.com/compose/intro/compose-application-model/
- to start all the services defined in the docker compose file, run > docker compose up
- list all services along with their current states: > docker compose ps

## Plan: Add Turnilo Container to Druid Docker Compose

Add a `turnilo` service to the existing `docker-compose.yml` that builds from the `docker-turnilo/Dockerfile` and connects to the Druid broker via Docker Compose networking. No new Dockerfile or compose file is needed.

### Why this approach

- **`docker-turnilo/` over `turnilo/`**: The `docker-turnilo/Dockerfile` is purpose-built for connecting to a running Druid broker — its `run.sh` already reads the `DRUID_BROKER_URL` env var. The `turnilo/Dockerfile` is for building Turnilo from source (dev workflow), which is unnecessary here.
- **Add to existing `docker-compose.yml` rather than standalone `docker run`**: All services in the same compose file share a default network, so Turnilo can reach the broker by its service name (`broker`). No manual network plumbing needed.
- **No new Dockerfile needed**: The existing one in `docker-turnilo/` does everything required.

---

### Steps

**Phase 1: Add Turnilo service to docker-compose.yml**

1. Add the following service block to the `services:` section of `docker-compose.yml`:
   - `build: ./docker-turnilo` — builds from the existing Dockerfile
   - `container_name: turnilo`
   - `ports: "9091:9090"` — maps host port 9091 to container port 9090 (matching the README examples, avoids conflicts with Druid ports)
   - `environment: DRUID_BROKER_URL=http://broker:8082` — Docker Compose DNS resolves `broker` to the broker container automatically
   - `depends_on: [broker]` — ensures broker starts before Turnilo

That's it. No new files.

**Phase 2 (optional): Upgrade Turnilo version if compatibility issues arise**

2. The current Dockerfile installs Turnilo **1.33.1** on **Node 14** (both EOL). Druid is **36.0.0**. If runtime errors or missing features appear, update `docker-turnilo/Dockerfile`:
   - Base image: `node:14.15` → `node:18`
   - Install: `turnilo@1.33.1` → `turnilo` (latest)

---

### Relevant Files
- `docker-compose.yml` — add turnilo service block
- `docker-turnilo/Dockerfile` — existing, no changes needed initially
- `docker-turnilo/run.sh` — entrypoint, handles `DRUID_BROKER_URL` (no changes needed)

### Verification
1. `docker compose up -d --build turnilo` — build and start the Turnilo container
2. `docker compose logs turnilo` — should show `About to execute: turnilo --druid http://broker:8082`
3. Open **http://localhost:9091** — Turnilo UI should load and display data cubes from Druid
4. If Turnilo loads but shows no data, verify broker health: `curl http://localhost:8082/status`

### Further Considerations
1. **Turnilo version compatibility**: Turnilo 1.33.1 with Druid 36.0.0 may have API gaps. If issues surface, upgrading the Dockerfile to install the latest Turnilo on Node 18 is a one-line fix in the Dockerfile. Recommend trying as-is first.
