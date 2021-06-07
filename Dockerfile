# python
FROM python:3.8.0-slim
RUN apt-get update \
&& apt-get clean
COPY requirements.txt /app/requirements.txt
WORKDIR app
RUN pip install --user -r requirements.txt
COPY . /app

# curl
FROM alpine:3.10
RUN apk add --no-cache curl
ENTRYPOINT ["/usr/bin/curl"]
