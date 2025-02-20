# Usar a imagem base do Ubuntu
FROM ubuntu:latest

# Instalar pacotes necessários
RUN apt update && apt install -y openssh-server wget curl unzip apache2 jq

# Criar diretórios e configurar o SSH
RUN mkdir /var/run/sshd && echo 'root:root' | chpasswd

# Permitir login root via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Instalar o Ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && mv ngrok /usr/local/bin/

# Instalar Gotty (terminal web para acessar SSH pelo navegador)
RUN wget -O /usr/local/bin/gotty https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64 && \
    chmod +x /usr/local/bin/gotty

# Criar um painel básico no Apache informando os dados de acesso
RUN echo '<h1>Servidor SSH</h1><p>Use o terminal abaixo para acessar:</p><iframe src="/terminal" width="100%" height="500px"></iframe>' > /var/www/html/index.html

# Expor portas SSH, HTTP e Gotty
EXPOSE 22 80 8080

# Comando para iniciar os serviços e manter o container ativo
CMD service ssh start && \
    service apache2 start && \
    gotty -w -p 8080 ssh root@localhost & \
    ngrok http 80 --log=stdout & \
    while true; do sleep 30; done
