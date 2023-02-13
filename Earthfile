VERSION 0.6

build:
  FROM python:3

  RUN apt-get update \
   && apt-get install -y build-essential libxml2-dev libxslt1-dev

  RUN python -m venv /app

  ENV PATH "/app/bin:$PATH"
  RUN pip install --progress-bar=off --use-pep517 --upgrade beancount==2.3.5
  RUN pip install --progress-bar=off --upgrade fava[excel]==1.23.1

  SAVE ARTIFACT /app

docker:
    FROM python:3-slim

    WORKDIR /app
    COPY +build/app .

    ENV PATH "/app/bin:$PATH"
    ENV FAVA_HOST "0.0.0.0"
    ENV BEANCOUNT_FILE

    EXPOSE 5000
    ENTRYPOINT ["fava"]

    SAVE IMAGE --push ghcr.io/kpine/fava:latest
