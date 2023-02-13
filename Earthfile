VERSION 0.6

build:
  FROM python:3

  RUN apt-get update \
   && apt-get install -y build-essential libxml2-dev libxslt1-dev curl git

  RUN python -m venv /app

  WORKDIR /src/beancount
  RUN git clone --branch=2.3.5 --single-branch --depth=1 https://github.com/beancount/beancount .

  ENV PATH "/app/bin:$PATH"
  RUN CFLAGS=-s pip install --use-pep517 -U .
  RUN pip install fava[excel]

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
