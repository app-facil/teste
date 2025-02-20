FROM ubuntu:latest

# Atualizar e instalar pacotes necessários
RUN apt update && apt install -y openssh-server nodejs npm curl && \
    mkdir /var/run/sshd && \
    echo 'root:1234' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    npm install -g wetty

# Expor portas do SSH e do Wetty
EXPOSE 22 3000

# Iniciar SSH e Wetty ao rodar o container
CMD service ssh start && wetty -p 3000 --ssh-host localhost --ssh-user root
