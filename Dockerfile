FROM python:3.11-slim

WORKDIR /opt

COPY . /opt

ENV TERM=xterm

RUN apt-get update && \
    apt-get install -y curl gnupg vim nano iputils-ping net-tools procps && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && \
    apt-get install -y ffmpeg tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

FROM node:lts as webui
ARG repo_url=https://github.com/biliup/biliup
ARG branch_name=master
RUN set -eux; \
	git clone --depth 1 --branch "$branch_name" "$repo_url"; \
	cd biliup; \
	npm install; \
	npm run build

#CMD ["python", "main.py"]
