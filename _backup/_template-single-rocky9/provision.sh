#!/usr/bin/env bash

echo " ====== Linux: Set Timezone ====> "
timedatectl set-timezone "Asia/Shanghai"

echo " ====== DNF: Enable REPO ===> "
dnf config-manager --set-enabled extras crb

echo " ====== DNF: Config Rocky Linux 9 REPO mirror ====> "
sed -e 's|^\(mirrorlist\s*=\s*\)|#\1|g' \
    -e 's|^#\s*\(baseurl\s*=\s*\)http://dl.rockylinux.org/\$contentdir|\1https://mirrors.aliyun.com/rockylinux|g' \
    -i.default \
    /etc/yum.repos.d/rocky-addons.repo \
    /etc/yum.repos.d/rocky-devel.repo \
    /etc/yum.repos.d/rocky-extras.repo \
    /etc/yum.repos.d/rocky.repo
dnf --disablerepo=* --enablerepo=appstream,baseos,extras,crb makecache

echo " ====== DNF: Install EPEL REPO ====> "
dnf -y install epel-release

echo " ====== DNF: Config EPEL REPO Mirror ====> "
sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.*/pub/epel/|baseurl=https://mirrors.aliyun.com/epel/|g' \
    -i.default \
    /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo
dnf --disablerepo=* --enablerepo=epel makecache

echo " ====== DNF: Install Packages ====> "
dnf -y install \
    bind-utils `# nslookup & dig`\
    net-tools `# netstat & ifconfig` \
    lrzsz `# rz & sz` \
    bash-completion `# Tab auto completion` \
    mlocate `# locate` \
    unzip \
    lsof \
    tree \
    yum-utils \
    jq
