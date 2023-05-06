VERSION 0.6

build-base:
  FROM python:3

  RUN apt-get update \
   && apt-get install -y build-essential libxml2-dev libxslt1-dev

  RUN python -m venv /app

  ARG BEANCOUNT_VERSION=2.3.5

  ENV PATH "/app/bin:$PATH"
  RUN pip install --progress-bar=off --no-cache-dir --upgrade uvicorn[standard]==0.22 pdfminer.six==20221105
  RUN pip install --progress-bar=off --no-cache-dir --upgrade beancount==$BEANCOUNT_VERSION --use-pep517

  SAVE ARTIFACT /app

build-fava-frontend:
  FROM node:lts-bullseye

  ARG --required FAVA_VERSION
  WORKDIR fava
  RUN git clone https://github.com/beancount/fava . \
   && git checkout $FAVA_VERSION
  RUN cd frontend && npm ci
  RUN cd frontend && npm run build

  SAVE ARTIFACT /fava /build

build-fava-dist:
  FROM python:3

  RUN python -m pip install tox twine

  ARG FAVA_VERSION
  COPY (+build-fava-frontend/build --FAVA_VERSION=$FAVA_VERSION) /build

  WORKDIR /build
  RUN tox -e build-dist

  SAVE ARTIFACT dist/fava-*.whl /dist/

build-fava-dev:
  FROM +build-base

  ARG --required FAVA_VERSION
  COPY (+build-fava-dist/dist --FAVA_VERSION=$FAVA_VERSION) /tmp

  RUN pip install --progress-bar=off --no-cache-dir --upgrade /tmp/*.whl
  SAVE ARTIFACT /app

build-fava:
  FROM +build-base

  ARG --required FAVA_VERSION
  RUN pip install --progress-bar=off --no-cache-dir --upgrade fava[excel]==$FAVA_VERSION

  SAVE ARTIFACT /app

docker:
    FROM python:3-slim

    ARG FAVA_VERSION=1.24.4

    WORKDIR /app
    COPY (+build-fava/app --FAVA_VERSION=$FAVA_VERSION) .
    COPY ufava.py /app/bin/ufava

    ENV PATH "/app/bin:$PATH"
    ENV BEANCOUNT_FILES

    EXPOSE 5000
    ENTRYPOINT ["ufava"]

    SAVE IMAGE --push ghcr.io/kpine/fava:latest ghcr.io/kpine/fava:$FAVA_VERSION

docker-dev:
  FROM python:3-slim

  ARG --required FAVA_COMMIT

  WORKDIR /app
  COPY (+build-fava-dev/app --FAVA_VERSION=$FAVA_COMMIT) .
  COPY ufava.py /app/bin/ufava

  ENV PATH "/app/bin:$PATH"
  ENV BEANCOUNT_FILES

  EXPOSE 5000
  ENTRYPOINT ["ufava"]

  SAVE IMAGE --push ghcr.io/kpine/fava:dev-$FAVA_COMMIT
