# Use a base image with the necessary dependencies
FROM frolvlad/alpine-glibc:alpine-3.12

# Install dependencies
RUN apk update 
RUN apk add --update --no-cache --no-progress bash binutils curl file gettext jq libintl pwgen shadow su-exec

# Create a user for running the server
RUN useradd -ms /bin/bash factorio

# Set environment variables
ENV FACTORIO_VERSION=stable
ENV FACTORIO_VOL=/factorio
ENV FACTORIO_HOME=/home/ubuntu/factorio
ENV SAVEFILE_NAME=my-save.zip

# Download and extract Factorio server
RUN wget https://www.factorio.com/get-download/$FACTORIO_VERSION/headless/linux64 -O /tmp/factorio.tar.xz \
  && mkdir $FACTORIO_VOL

# Debug: List the contents of the tarball
RUN tar -tvf /tmp/factorio.tar.xz

# Extract the tarball
RUN tar -xJf /tmp/factorio.tar.xz -C $FACTORIO_VOL \
  && rm /tmp/factorio.tar.xz \
  && chown -R factorio:factorio $FACTORIO_VOL

# Debug: List the contents of the /factorio directory after extraction
RUN ls -l $FACTORIO_VOL

# Switch to the factorio user
USER factorio

# Copy the default server configuration
# COPY server-config.json $FACTORIO_VOL/data/server-settings.json

# Expose necessary ports
EXPOSE 34197/udp
EXPOSE 27015/tcp

# Set the working directory
WORKDIR $FACTORIO_VOL

# Command to start the Factorio server
CMD ["./factorio/bin/x64/factorio", "--start-server", "./parent/my-save.zip", "--server-settings", "./parent/server-settings.json", "--rcon-port", "27015", "--rcon-password", "your_rcon_password"]
# dummy command
# CMD ["tail", "-f", "/dev/null"]