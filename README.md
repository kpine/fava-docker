# fava-docker

Example `docker-compose.yaml`:

```yaml
services:

  fava:
    container_name: fava
    image: ghcr.io/kpine/fava:latest
    init: true
    restart: unless-stopped
    environment:
      - "TZ=America/Los_Angeles"
      - "BEANCOUNT_FILES=/fava/ledger.beancount"
    volumes:
      - "./fava:/fava"
```

## development
```
$ nix develop
```
