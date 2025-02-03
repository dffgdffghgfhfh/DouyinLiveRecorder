FROM python:3.11-slim

#VOLUME /opt/config
COPY . /opt/data
WORKDIR /opt/data
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

CMD ["python", "main.py"]


