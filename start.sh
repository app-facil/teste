#!/bin/bash

# Inicia o SSH
service ssh start

# Inicia o Ngrok e expõe a porta 22
ngrok tcp 22 --log=stdout &

# Mantém o script em execução para evitar que o container seja interrompido
tail -f /dev/null
