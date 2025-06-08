#!/usr/bin/env bash

echo " ====== EL 7: Set Timezone ====> "
sudo timedatectl set-timezone "Asia/Shanghai"

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
