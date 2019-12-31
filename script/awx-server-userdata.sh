#!/bin/bash

# Define o hostname da instância
hostname ${hostname}
export HOSTNAME=${hostname}
echo "127.0.0.1 ${hostname} localhost localhost.localdomain" > /etc/hosts

# Update system - instala softwares utilizado pelo awx
apt-add-repository -y ppa:ansible/ansible
apt update -y &&
apt -y install gcc \
               python-dev \
               apt-transport-https \
               ansible\
               ca-certificates \
               curl \
               gnupg-agent \
               software-properties-common \
               htop unzip python-pip \
               build-essential nodejs \
               npm --no-install-recommends &&

    rm -rf /var/lib/apt/lists/* &&
    npm install npm --global &&

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt update -y
apt -y install docker-ce docker-ce-cli containerd.io
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo -H -u ubuntu bash -c "pip install setuptools wheel docker docker-compose"

# Inicia o docker e coloca ele para inicio automatico depois de reboot
/etc/init.d/docker start
update-rc.d docker enable 2
usermod -aG docker ubuntu

# Instalação do AWX
sudo -H -u ubuntu bash -c "git clone https://github.com/ansible/awx.git /home/ubuntu/awx"
cd /home/ubuntu/awx/installer && 
sed -i "s/awxsecret/$SECRET_KEY`openssl rand -hex 32`/g" inventory &&
sed -i 's/^#project_data_dir/project_data_dir/' inventory &&
sudo -H -u ubuntu bash -c "ansible-playbook -i inventory install.yml"

