#!/usr/bin/env python3

import os

from fava.application import create_app
import uvicorn

env_filenames = os.environ.get("BEANCOUNT_FILES")
if not env_filenames:
    raise RuntimeError("No files specified")

app = create_app(env_filenames.split())

# 'critical', 'error', 'warning', 'info', 'debug', 'trace'.
log_level = os.environ.get("LOG_LEVEL", "info")

if __name__ == "__main__":
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=5000,
        log_level=log_level,
        interface="wsgi",
        proxy_headers=True,
    )
