FROM python:3.11-slim

WORKDIR /app

COPY . /app

ENV TERM=xterm

# 安装必要的工具和依赖
RUN apt-get update && \
    apt-get install -y curl gnupg vim nano iputils-ping net-tools procps git && \
    apt-get install -y ffmpeg tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# 安装 Rust 和工具链
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 将 Rust 的路径添加到环境变量中
ENV PATH="/root/.cargo/bin:${PATH}"

# 克隆 biliup-rs 项目
RUN git clone https://github.com/biliup/biliup-rs.git /biliup-rs

# 进入到实际包目录，构建并安装
RUN cd /biliup-rs/biliup && cargo install --path .

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 设置时区
RUN apt-get update && \
    apt-get install -y ffmpeg tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

CMD ["python", "main.py"]

