# Usar a imagem base do Ubuntu
FROM ubuntu:latest

# Instalar pacotes necessários
RUN apt update && apt install -y openssh-server wget curl && rm -rf /var/lib/apt/lists/*

# Criar diretórios e configurar o SSH
RUN mkdir /var/run/sshd && echo 'root:root' | chpasswd

# Permitir login root via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Instalar o Ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && mv ngrok /usr/local/bin/

# Instalar o Apache para acessar pelo navegador
RUN apt install -y apache2 && echo "<h1>Bem-vindo ao Servidor</h1>" > /var/www/html/index.html

# Expor portas SSH e HTTP
EXPOSE 22 80

# Comando para iniciar os serviços e manter o container ativo
CMD service ssh start && service apache2 start && while true; do sleep 30; done
