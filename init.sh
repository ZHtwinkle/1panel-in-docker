#!/bin/bash

# 首次启动环境变量
# 安装目录: PANEL_BASE_DIR
# 面板端口: PANEL_PORT
# 管理账户: PANEL_USERNAME
# 管理密码: PANEL_PASSWORD

function Fake_Systemctl()
{
    if [[ "$2" = "1panel" ]] || [[ "$2" = "1panel.service" ]]; then
        if [[ "$1" = "stop" ]]; then
            pkill -9 1panel
        elif [[ "$1" = "start" ]]; then
            pkill -0 1panel
            if [[ $? -ne 0 ]]; then
                /usr/bin/1panel > /tmp/1panel.log 2>&1 &
            fi
        elif [[ "$1" = "status" ]]; then
            pkill -0 1panel
            if [[ $? -ne 0 ]]; then
                echo "Active: inactive (dead)"
                exit 3
            else
                echo "Active: active (running)"
            fi
        fi
    else
        if [[ "$1" = "status" ]]; then
            echo "Active: active (running)"
        fi
    fi
}



cd /tmp/1panel-*
sed -i '1 a function read()\n{\n    return 0\n}\n' install.sh
bash install.sh
EOL
    chmod +x /tmp/install.sh
    if [[ -z "$PANEL_BASE_DIR" ]]; then
        export PANEL_BASE_DIR=/opt
    fi
    # 1Panel 官方安装命令
    # 来源：https://1panel.cn/docs/installation/online_installation/
    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o /tmp/quick_start.sh
    sed -i 's/install\.sh/\/tmp\/install.sh/' /tmp/quick_start.sh
    bash /tmp/quick_start.sh
    rm -rf /tmp/install.sh
    rm -rf /tmp/1panel-*
fi

if [[ ! -z "$1" ]]; then
    if [[ "$1" = "restart" ]] || [[ "$1" = "reload" ]];then
        Fake_Systemctl stop $2
        Fake_Systemctl start $2
    else
        Fake_Systemctl $1 $2
    fi
    exit 0
fi

if [[ -e "/var/run/crond.pid" ]]; then
    kill -0 $(cat /var/run/crond.pid) > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        rm -rf /var/run/crond.pid
    fi
fi
if [[ ! -e "/var/run/crond.pid" ]]; then
    /usr/sbin/cron
fi

Fake_Systemctl start 1panel

exec "/bin/bash"
