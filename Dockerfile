# Usa a imagem oficial do Ubuntu como base
FROM ubuntu:latest

# Atualiza o índice de pacotes e instala o SSH server e wget
RUN apt-get update && apt-get install -y openssh-server wget

# Configura o SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Instala o Ngrok
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -O /tmp/ngrok.zip
RUN unzip /tmp/ngrok.zip -d /usr/local/bin
RUN rm /tmp/ngrok.zip

# Expõe a porta 22 para SSH
EXPOSE 22

# Comando para rodar o SSH server e Ngrok
CMD service ssh start && ngrok tcp 22 --log=stdout
