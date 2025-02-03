FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 将当前目录内容复制到容器的 /app 目录
COPY . /app

# 设置环境变量 TERM
ENV TERM=xterm

# 安装必要的依赖
RUN apt-get update && \
    apt-get install -y curl gnupg vim nano iputils-ping net-tools procps git && \
    apt-get install -y ffmpeg tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# 安装 Rust 和工具链
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 将 Rust 的路径添加到环境变量中
ENV PATH="/root/.cargo/bin:${PATH}"

# 克隆 biliup-rs 项目到工作目录
RUN git clone https://github.com/biliup/biliup-rs.git /app/biliup-rs

# 在工作目录中执行 biliup-rs 的构建
RUN cd /app/biliup-rs && cargo install --path .

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 设置时区
RUN apt-get update && \
    apt-get install -y ffmpeg tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# 默认执行命令
CMD ["python", "main.py"]
