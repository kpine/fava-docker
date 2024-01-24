#!/usr/bin/env python3

import os
from pathlib import Path

from fava.application import create_app
import uvicorn

# from https://github.com/beancount/fava/blob/a4b17962ec4439785046e861dbba42b3a7a65ec1/src/fava/cli.py#L27-L40
def add_env_filenames(filenames: tuple[str, ...]) -> set[str]:
    """Read filenames from BEANCOUNT_FILE environment variable."""

    env_filename = os.environ.get("BEANCOUNT_FILE")
    if not env_filename:
        # deprecated
        if not (env_filename := os.environ.get("BEANCOUNT_FILES")):
            return set(filenames)

    env_names = env_filename.split(os.pathsep)
    for name in env_names:
        if not Path(name).is_absolute():
            raise RuntimeError("Paths in BEANCOUNT_FILE need to be absolute")

    return set(filenames + tuple(env_names))

env_filenames = add_env_filenames(())
if not env_filenames:
    raise RuntimeError("No files specified")

app = create_app(env_filenames)

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
