#!/bin/sh

 echo "Control Node Preparation ..."
 sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
 sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

 dnf update -y
 dnf install -y epel-release wget
 dnf makecache --refresh
  dnf install -y python39 python39-pip git bind-utils vim bash-completion libX11
 wget http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
 rpm -i sshpass-1.09-4.el8.x86_64.rpm

 sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
 systemctl restart sshd

 export PATH="/usr/local/bin:$PATH"
 source  ~/.bash_profile

 python3 -m pip install  ansible

 PASS=$(echo "control" | openssl passwd -1 -stdin)
 useradd -p "$PASS" master
 cat <<EOF > /etc/sudoers.d/student
 master	ALL=NOPASSWD: ALL
 EOF

 cat <<EOF > /etc/hosts
 192.168.30.200 control.clevory.local
 192.168.30.201 node01.clevory.local
 192.168.30.202 node02.clevory.local
 EOF

 su - ansible -c "ssh-keygen -b 2048 -t rsa -f /home/ansible/.ssh/id_rsa -q -P \"\""
 su - ansible -c "ssh-keyscan  node01.clevory.local 2>/dev/null >> home/ansible/.ssh/known_hosts"
 su - ansible -c "ssh-keyscan  node02.clevory.local 2>/dev/null >> home/ansible/.ssh/known_hosts"
 su - ansible -c "echo 'ansible' |sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible1.clevory.local"
 su - ansible -c "echo 'ansible' |sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible2.clevory.local"
 su - ansible -c "git clone https://github.com/samrhim/rhce8-live.git"
