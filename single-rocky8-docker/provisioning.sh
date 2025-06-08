#!/usr/bin/env bash

echo " ====== Linux: Set Timezone ====> "
sudo timedatectl set-timezone "Asia/Shanghai"

echo " ====== DNF: Enable Extras & PowerTools REPO ====> "
sudo dnf config-manager --set-enabled extras powertools

echo " ====== DNF: Config Rocky Linux 8 REPO mirror ====> "
sudo sed -e 's|^\(mirrorlist\s*=\s*\)|#\1|g' \
    -e 's|^#\s*\(baseurl\s*=\s*\)http://dl.rockylinux.org/\$contentdir|\1https://mirrors.aliyun.com/rockylinux|g' \
    -i.default \
    /etc/yum.repos.d/Rocky-AppStream.repo \
    /etc/yum.repos.d/Rocky-BaseOS.repo \
    /etc/yum.repos.d/Rocky-Extras.repo \
    /etc/yum.repos.d/Rocky-PowerTools.repo
dnf --disablerepo=* --enablerepo=appstream,baseos,extras,powertools makecache

echo " ====== DNF: Install EPEL REPO ====> "
sudo dnf -y install epel-release

echo " ====== DNF: Config EPEL REPO Mirror ====> "
sudo sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.*/pub/epel/|baseurl=https://mirrors.aliyun.com/epel/|g' \
    -i.default \
    /etc/yum.repos.d/epel{,-testing}.repo
sudo dnf config-manager --set-disabled "epel-modular*"
sudo dnf config-manager --set-disabled "epel-testing-modular*"
dnf --disablerepo=* --enablerepo=epel makecache

echo " ====== DNF: Install Packages ====> "
sudo dnf -y install \
    bind-utils `# nslookup & dig` \
    net-tools `# netstat & ifconfig` \
    lrzsz `# rz & sz` \
    bash-completion `# Tab auto completion` \
    mlocate `# locate` \
    unzip \
    lsof \
    tree \
    yum-utils \
    jq

echo " ====== DNF: Install Docker REPO From Mirror ====> "
# sudo yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --add-repo=https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo

echo " ====== DNF: Import Docker REPO GPG Key ====> "
if ! sudo rpm --import https://download.docker.com/linux/centos/gpg;
then
    sudo rpm --import https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/gpg
fi

echo " ====== DNF: Config Docker REPO Mirror ====> "
sudo sed -e 's|^\(baseurl\s*=\s*\)https://download.docker.com|\1https://mirrors.tuna.tsinghua.edu.cn/docker-ce|g' \
    -i.default \
    /etc/yum.repos.d/docker-ce.repo
# sudo yum-config-manager --add-repo=http://mirrors.cloud.aliyuncs.com/docker-ce/linux/centos/docker-ce.repo
# sudo sed -e 's|^\(baseurl\s*=\s*\)https://download.docker.com|\1http://mirrors.cloud.aliyuncs.com/docker-ce|g' \
#     -e 's|https://mirrors.aliyun.com/docker-ce|http://mirrors.cloud.aliyuncs.com/docker-ce|g' \
#     -i.default \
#     /etc/yum.repos.d/docker-ce.repo
yum --disablerepo=* --enablerepo=docker-ce-stable makecache

echo " ====== DNF: Install Docker & Docker Compose v2 ====> "
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
