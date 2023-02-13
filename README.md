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
      - "BEANCOUNT_FILE=/fava/ledger.beancount"
      - "PYTHONPATH=/fava/py"
    volumes:
      - "./fava:/fava"
```

If you want to use custom importers, set `PYTHONPATH` to the location of your modules.
