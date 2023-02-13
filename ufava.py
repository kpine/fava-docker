#!/usr/bin/env python3

import uvicorn
import os

from fava.application import app

env_filenames = os.environ.get("BEANCOUNT_FILES")
if not env_filenames:
    raise RuntimeError("No files specified")

app.config["BEANCOUNT_FILES"] = env_filenames.split()

uvicorn.run(
    "fava.application:app",
    host="0.0.0.0",
    port=5000,
    log_level="info",
    interface="wsgi",
    proxy_headers=True,
)
