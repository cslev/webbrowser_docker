FROM debian:bullseye
LABEL maintainer="cslev <cslev@gmx.com>"

#packages needed for FF 74.0
ENV DEPS  lsb-release \
          libatk1.0-0 \
          libc6 \
          libcairo-gobject2 \
          libcairo2 \
          libdbus-1-3 \
          libdbus-glib-1-2 \
          libfontconfig1 \
          libfreetype6 \
          libgcc1 \
          libgdk-pixbuf2.0-0 \
          libglib2.0-0 \
          libgtk-3-0 \
          libpango-1.0-0 \
          libpangocairo-1.0-0 \
          libpangoft2-1.0-0 \
          libstdc++6 \
          libx11-6 \
          libx11-xcb1 \
          libxcb-shm0 \
          libxcb1 \
          libxcomposite1 \
          libxcursor1 \
          libxdamage1 \
          libxext6 \
          libxfixes3 \
          libxi6 \
          libxrender1 \
          libxt6 \
          tar \
          bzip2 \
          wget \
          ca-certificates \
          net-tools \
          x11-apps \
          ethtool \
          procps \
          nano \
          xterm \
          curl \
          #for find_veth_docker
          iproute2 \
          #for VNC
          x11vnc \
          xvfb \
          libasound2 \
          libegl1 \
          libpci3 \
          sudo \
	  iputils-ping \
          dnsutils 


COPY source /webbrowser
WORKDIR /webbrowser

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    dpkg-reconfigure debconf --frontend=noninteractive && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $DEPS && \
    #firefox
    wget -q https://ftp.mozilla.org/pub/firefox/releases/109.0/linux-x86_64/en-US/firefox-109.0.tar.bz2 && \
    tar -xjf firefox-109.0.tar.bz2 && \
    mkdir -p /usr/lib/firefox && \
    ln -s /webbrowser/firefox/firefox /usr/lib/firefox/firefox && \
    rm -rf firefox-109.0.tar.bz2 && \
    # #chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y google-chrome-stable && \
    rm -rf google-chrome-stable_current_amd64.deb && \
    # #brave
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|tee /etc/apt/sources.list.d/brave-browser-release.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y brave-browser && \
    #[DONE]
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mv bashrc_template /root/.bashrc && \
    source /root/.bashrc


# RUN useradd --no-log-init --create-home --shell /bin/bash user -p "$(openssl passwd -6 user)" && \
#     adduser user sudo && \
#     chown -R user:user /webbrowser
# USER user
# WORKDIR /home/user
RUN echo "exec xterm" > ~/.xinitrc && chmod +x ~/.xinitrc 

# We start the script automatically
ENTRYPOINT ["x11vnc", "-create", "-forever"] 
