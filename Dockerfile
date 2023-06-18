FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y git cmake g++

# Install build dependencies.
# See also `apt-cache showsrc awesome | grep -E '^(Version|Build-Depends)'`.
RUN apt-get install -y \
  asciidoctor cmake debhelper-compat imagemagick libcairo2-dev libdbus-1-dev \
  libgdk-pixbuf2.0-dev libglib2.0-dev liblua5.3-dev libpango1.0-dev libstartup-notification0-dev \
  libx11-xcb-dev libxcb-cursor-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-randr0-dev \
  libxcb-shape0-dev libxcb-util0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb-xrm-dev \
  libxcb-xtest0-dev libxdg-basedir-dev libxkbcommon-dev libxkbcommon-x11-dev lua-busted \
  libxcb-xfixes0-dev lua-discount lua-ldoc lua-lgi lua5.3 x11proto-core-dev xmlto

# luarocks.
RUN apt-get install -y luarocks

# Install ldoc for building docs.
RUN luarocks install ldoc && \
    luarocks install lua-discount

RUN cd /root && \
    git clone https://github.com/awesomeWM/awesome.git awesome-git

COPY Packaging.cmake /root/awesome-git/

RUN cd /root/awesome-git && \
    make package