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
ENV FACTORIO_HOST=/factorio/parent
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

# mkdir $FACTORIO_HOST
RUN mkdir $FACTORIO_HOST
# mkdir $FACTORIO_HOST/mods
RUN mkdir $FACTORIO_HOST/mods
# mkdir $FACTORIO_HOST/saves
RUN mkdir $FACTORIO_HOST/saves

# link FACTORIO_HOST/mods to FACTORIO_VOL/factorio/mods
RUN ln -s $FACTORIO_HOST/mods $FACTORIO_VOL/factorio/mods
# link FACTORIO_HOST/saves to FACTORIO_VOL/factorio/saves
RUN ln -s $FACTORIO_HOST/saves $FACTORIO_VOL/factorio/saves

# Copy the default server configuration
# COPY server-adminlist.json $FACTORIO_VOL/factorio/data/server-adminlist.json
# create symlink
RUN ln -s $FACTORIO_HOST/server-adminlist.json $FACTORIO_VOL/factorio/server-adminlist.json


# Expose necessary ports
EXPOSE 34197/udp
EXPOSE 27015/tcp

# Set the working directory
WORKDIR $FACTORIO_VOL

# Command to start the Factorio server
CMD ["./factorio/bin/x64/factorio", "--start-server", "./parent/saves/my-save.zip", "--server-settings", "./parent/server-settings.json", "--rcon-port", "27015", "--rcon-password", "entp_entp_entp"]
# dummy command
# CMD ["tail", "-f", "/dev/null"]