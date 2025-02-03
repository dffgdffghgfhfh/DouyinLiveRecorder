FROM python:3.11-slim

WORKDIR /app

COPY . /app

ENV TERM=xterm

RUN apt-get update && \
    apt-get install -y curl gnupg vim nano iputils-ping net-tools procps git && \
    curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y ffmpeg tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# 安装 Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 克隆并构建 biliup-rs
RUN git clone https://github.com/biliup/biliup-rs.git /biliup-rs && \
    cd /biliup-rs && \
    cargo install --path .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]



