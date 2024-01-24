# fava-docker

Example `docker-compose.yaml`:

```yaml
services:
  fava:
    image: ghcr.io/kpine/fava:latest
    restart: unless-stopped
    environment:
      - "TZ=America/Los_Angeles"
      - "BEANCOUNT_FILE=/fava/ledger.beancount"
    volumes:
      - "./fava:/fava"
```
