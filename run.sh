docker run -d \
  --name factorio \
  -p 34197:34197/udp \
  -p 27015:27015/tcp \
  -v /home/ubuntu/factorio-data:/factorio/parent \
  -e FACTORIO_HOME=/home/ubuntu/factorio \
  factorio
