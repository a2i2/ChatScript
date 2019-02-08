FROM ubuntu:16.04

# Set default locale.
ENV LANG C.UTF-8

# Install system packages/dependencies.
RUN apt-get --yes update && apt-get --yes install libcurl3

# Clean up to reduce image size.
RUN rm -rf /var/lib/apt/lists/*

# Copy ChatScript server files.
COPY . /opt/ChatScript
RUN chmod +x /opt/ChatScript/BINARIES/LinuxChatScript64

# Create entry point script.
RUN { \
echo '#!/bin/bash'; \
echo 'set -e'; \
echo 'cd /opt/ChatScript'; \
echo './BINARIES/LinuxChatScript64 $@'; \
} > /entrypoint-chatscript.sh \
&& chmod +x /entrypoint-chatscript.sh

# Build bot data.
WORKDIR /opt/ChatScript
RUN /opt/ChatScript/BINARIES/LinuxChatScript64 local build0=files0.txt

# Set runtime properties.
EXPOSE 1024
ENTRYPOINT ["/entrypoint-chatscript.sh"]
