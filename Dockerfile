FROM ubuntu:latest

# Instalar OpenSSH Server e Node.js (para rodar o Wetty)
RUN apt update && apt install -y openssh-server curl && \
    mkdir /var/run/sshd && \
    echo 'root:s3nh@forte' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    apt install -y nodejs npm && \
    npm install -g wetty

# Expor portas: 22 (SSH) e 3000 (Web SSH)
EXPOSE 22 3000

# Iniciar OpenSSH e Wetty
CMD service ssh start && wetty -p 3000 --ssh-host localhost --ssh-user root
