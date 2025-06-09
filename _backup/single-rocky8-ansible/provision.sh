#!/usr/bin/env bash

echo " ====== Linux: Set Timezone ====> "
timedatectl set-timezone "Asia/Shanghai"

echo " ====== DNF: Enable Extras & PowerTools REPO ====> "
dnf config-manager --set-enabled extras powertools

echo " ====== DNF: Config Rocky Linux 8 REPO mirror ====> "
sed -e 's|^\(mirrorlist\s*=\s*\)|#\1|g' \
    -e 's|^#\s*\(baseurl\s*=\s*\)http://dl.rockylinux.org/\$contentdir|\1https://mirrors.aliyun.com/rockylinux|g' \
    -i.default \
    /etc/yum.repos.d/Rocky-AppStream.repo \
    /etc/yum.repos.d/Rocky-BaseOS.repo \
    /etc/yum.repos.d/Rocky-Extras.repo \
    /etc/yum.repos.d/Rocky-PowerTools.repo
dnf --disablerepo=* --enablerepo=appstream,baseos,extras,powertools makecache

echo " ====== DNF: Install EPEL REPO ====> "
dnf -y install epel-release

echo " ====== DNF: Config EPEL REPO Mirror ====> "
sed -e 's|^metalink=|#metalink=|g' \
    -e 's|^#baseurl=https\?://download.*/pub/epel/|baseurl=https://mirrors.aliyun.com/epel/|g' \
    -i.default \
    /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo
dnf config-manager --set-disabled "epel-modular*"
dnf config-manager --set-disabled "epel-testing-modular*"
dnf --disablerepo=* --enablerepo=epel makecache
