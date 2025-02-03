FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 将当前目录内容复制到容器的 /app 目录
COPY . /app

# 设置环境变量 TERM
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
