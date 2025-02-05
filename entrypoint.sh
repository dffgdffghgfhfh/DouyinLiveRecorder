#!/bin/sh
python /app/main.py &
tail -f /dev/null  # 让 Docker 进程一直运行
