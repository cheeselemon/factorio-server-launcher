# Use a base image with the necessary dependencies
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y wget xz-utils

# Create a user for running the server
RUN useradd -ms /bin/bash factorio

# Set environment variables
ENV FACTORIO_VERSION=1.1.100
ENV FACTORIO_VOL=/factorio
ENV FACTORIO_HOME=/home/ubuntu/factorio
ENV SAVEFILE_NAME=my-save.zip

# Download and extract Factorio server
RUN wget https://www.factorio.com/get-download/$FACTORIO_VERSION/headless/linux64 -O /tmp/factorio.tar.xz \
  && mkdir $FACTORIO_VOL \
  && tar -xJf /tmp/factorio.tar.xz -C $FACTORIO_VOL \
  && rm /tmp/factorio.tar.xz \
  && chown -R factorio:factorio $FACTORIO_VOL

# Switch to the factorio user
USER factorio

# Copy the default server configuration
COPY server-config.json $FACTORIO_VOL/data/server-settings.json

# Expose necessary ports
EXPOSE 34197/udp
EXPOSE 27015/tcp

# Set the working directory
WORKDIR $FACTORIO_VOL

# Command to start the Factorio server
CMD ["./bin/x64/factorio", "--start-server", "${SAVEFILE_NAME}", "--server-settings", "./data/server-settings.json", "--rcon-port", "27015", "--rcon-password", "your_rcon_password"]