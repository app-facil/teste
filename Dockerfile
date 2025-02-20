# Usa a imagem oficial do Ubuntu como base
FROM ubuntu:latest

# Atualiza o índice de pacotes e instala o SSH server, wget e unzip
RUN apt-get update && apt-get install -y openssh-server wget unzip

# Configura o SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Evita que o usuário seja desconectado após o login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Expõe a porta 22 para SSH
EXPOSE 22

# Instala o Ngrok
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /tmp/ngrok.zip
RUN unzip /tmp/ngrok.zip -d /usr/local/bin
RUN rm /tmp/ngrok.zip

# Adiciona o Ngrok ao PATH
ENV PATH="/usr/local/bin:${PATH}"

# Script para rodar o SSH e Ngrok em loop
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Comando principal
CMD ["/start.sh"]
