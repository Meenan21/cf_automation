# python
FROM python:3.8.0-slim as builder
RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get clean
COPY requirements.txt /app/requirements.txt
WORKDIR app
RUN pip install --user -r requirements.txt
COPY . /app

# curl
FROM alpine:3.10
RUN apk add --no-cache curl
ENTRYPOINT ["/usr/bin/curl"]

#app
FROM python:3.8.0-slim as app
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app/main.py /app/main.py
WORKDIR app
ENV PATH=/root/.local/bin:$PATH
ENTRYPOINT uvicorn main:app --reload --host 0.0.0.0 --port 1234

FROM codefresh/cli
ADD runner-entrypoint.sh /runner-entrypoint.sh
ENTRYPOINT ["/runner-entrypoint.sh"]
