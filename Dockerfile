
FROM python:3.11-slim

WORKDIR /app

COPY . /app

ENV TERM=xterm

# 安装基础工具和 Node.js
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# 安装常用调试和管理工具：vim（vi）、nano、ping、ifconfig、top、free、wget
RUN apt-get update && \
    apt-get install -y vim nano iputils-ping net-tools procps wget

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 安装 ffmpeg、tzdata，并设置时区
RUN apt-get update && \
    apt-get install -y ffmpeg tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

CMD ["python", "main.py"]
