FROM python:3.7.7-alpine3.10


# RUN apk add --no-cache build-base gcc
RUN apk add --no-cache git bash jq curl
RUN pip install --upgrade pip
RUN pip install flake8==3.7.9  flake8-json==19.8.0 requests==2.23.0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
