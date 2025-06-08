#!/usr/bin/env bash

echo " ====== EL 7: Set Timezone ====> "
sudo timedatectl set-timezone "Asia/Shanghai"

echo " ====== YUM: Enable Extras REPO ====> "
sudo yum-config-manager --enable extras

echo " ====== YUM: Config CentOS 7 REPO mirror ====> "
sudo sed -e 's|^\(mirrorlist\s*=\s*\)|#\1|g' \
    -e 's|^#\(baseurl\s*=\s*\)http://mirror.centos.org|\1https://mirrors.aliyun.com/centos-vault|g' \
    -i.default \
    /etc/yum.repos.d/CentOS-Base.repo
yum makecache

echo " ====== YUM: Install EPEL REPO ====> "
sudo yum -y install epel-release

echo " ====== YUM: Config EPEL REPO Mirror ====> "
sudo sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.*/pub/epel/|baseurl=https://mirrors.aliyun.com/epel-archive/|g' \
    -i.default \
    /etc/yum.repos.d/epel{,-testing}.repo
yum --disablerepo=* --enablerepo=epel makecache

echo " ====== YUM: Install Packages ====> "
sudo yum -y install \
    bind-utils `# nslookup & dig` \
    net-tools `# netstat & ifconfig` \
    lrzsz `# rz & sz` \
    bash-completion `# Tab auto completion` \
    mlocate `# locate` \
    unzip \
    lsof \
    tree \
    yum-utils \
    yum-cron \
    jq

echo " ====== YUM: Install Docker REPO From Mirror ====> "
# sudo yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --add-repo=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo

echo " ====== YUM: Import Docker REPO GPG Key ====> "
if ! sudo rpm --import https://download.docker.com/linux/centos/gpg;
then
    sudo rpm --import https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
fi

echo " ====== YUM: Config Docker REPO Mirror ====> "
sudo sed -e 's|^\(baseurl\s*=\s*\)https://download.docker.com|\1https://mirrors.tuna.tsinghua.edu.cn/docker-ce|g' \
    -i.default \
    /etc/yum.repos.d/docker-ce.repo
# sudo yum-config-manager --add-repo=http://mirrors.cloud.aliyuncs.com/docker-ce/linux/centos/docker-ce.repo
# sudo sed -e 's|^\(baseurl\s*=\s*\)https://download.docker.com|\1http://mirrors.cloud.aliyuncs.com/docker-ce|g' \
#     -e 's|https://mirrors.aliyun.com/docker-ce|http://mirrors.cloud.aliyuncs.com/docker-ce|g' \
#     -i.default \
#     /etc/yum.repos.d/docker-ce.repo
yum --disablerepo=* --enablerepo=docker-ce-stable makecache

echo " ====== YUM: Install Docker & Docker Compose v2 ====> "
sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    runc

sudo yum -y install lvm2 \
            device-mapper-persistent-data \
            yum-utils \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-compose-plugin

echo " ====== Docker: Config ====> "
sudo mkdir -p /etc/docker
[[ -f /etc/docker/daemon.json ]] && sudo mv /etc/docker/daemon.json /etc/docker/daemon.json."$(date +%Y.%m%d.%H%M%S)".bak
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://docker.m.daocloud.io"
  ],
  "live-restore": true,
  "storage-driver": "overlay2",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3" 
  },
  "metrics-addr" : "127.0.0.1:9323",
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 10,
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo " ====== Linux: Add user vagrant to group docker ====> "
if id "vagrant" >/dev/null 2>&1; then
    sudo usermod -aG docker "vagrant"
fi

echo " ====== Docker: Export API port ====> "
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee -a /etc/systemd/system/docker.service.d/execstart.conf <<"EOF"
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock -H tcp://0.0.0.0:2375
EOF
sudo systemctl daemon-reload

echo " ====== systemd: (re)start docker.service ====> "
sudo systemctl enable docker
sudo systemctl restart docker
sudo systemctl status docker --no-pager -l
