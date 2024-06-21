# 使用 Ubuntu 22.04 作为基础镜像
FROM ubuntu:22.04
ENV INSTALL_MODE=stable

ENV PANEL_BASE_DIR=/opt

ENV PANEL_PORT=8080
ENV DEBIAN_FRONTEND=noninteractive
ENV PANEL_USERNAME=ZHtwinkle

ENV PANEL_PASSWORD=ZHtwinkle162599
RUN apt-get update && apt-get install -y iproute2

# 拷贝init.sh脚本到/app目录
# 设置时区为亚洲/上海
ENV TZ=Asia/Shanghai

# 设置工作目录为/app
WORKDIR /app

# 复制必要的文件
COPY ./init.sh .

# 设置文件权限
RUN chmod +x ./init.sh

# 设置工作目录为根目录
WORKDIR /

# 创建 Docker 套接字的卷
VOLUME /var/run/docker.sock

# 启动
RUN curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh
RUN yes | sudo bash quick_start.sh
# CMD ["/bin/bash", "/app/init.sh"]
