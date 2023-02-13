VERSION 0.6

ARG BEANCOUNT_VERSION=2.3.5
ARG FAVA_VERSION=1.23.1

build:
  FROM python:3

  RUN apt-get update \
   && apt-get install -y build-essential libxml2-dev libxslt1-dev

  RUN python -m venv /app

  ENV PATH "/app/bin:$PATH"
  RUN pip install --progress-bar=off --no-cache-dir --upgrade uvicorn[standard]
  RUN pip install --progress-bar=off --no-cache-dir --upgrade beancount==$BEANCOUNT_VERSION --use-pep517
  RUN pip install --progress-bar=off --no-cache-dir --upgrade fava[excel]==$FAVA_VERSION

  SAVE ARTIFACT /app

docker:
    FROM python:3-slim

    WORKDIR /app
    COPY +build/app .
    COPY ufava.py /app/bin/ufava

    ENV PATH "/app/bin:$PATH"
    ENV BEANCOUNT_FILES

    EXPOSE 5000
    ENTRYPOINT ["ufava"]

    SAVE IMAGE --push ghcr.io/kpine/fava:latest ghcr.io/kpine/fava:$FAVA_VERSION
