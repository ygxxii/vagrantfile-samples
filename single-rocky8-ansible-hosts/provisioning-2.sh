#!/usr/bin/env bash

echo " ====== SSH: Allow PasswordAuthentication ====> "
sudo sed -i 's/^[# \t]*PasswordAuthentication\s\w\+/PasswordAuthentication yes/gI' /etc/ssh/sshd_config
# sudo systemctl restart sshd
