# Usar a imagem base do Ubuntu
FROM ubuntu:latest

# Instalar pacotes necessários
RUN apt update && apt install -y openssh-server wget && rm -rf /var/lib/apt/lists/*

# Criar diretórios e configurar o SSH
RUN mkdir /var/run/sshd && echo 'root:root' | chpasswd

# Permitir login root via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Instalar o Ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && mv ngrok /usr/local/bin/

# Expor a porta SSH
EXPOSE 22

# Comando para iniciar o SSH e o Ngrok
CMD service ssh start && ngrok tcp 22
