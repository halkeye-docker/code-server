FROM linuxserver/code-server:4.14.0@sha256:8c76533b90b5380f8ee17668c1ba7acf5974a1ab4ffe64c015350d38fb3e810c
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

RUN \
  apt-get -y update && \
  LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  # Used to download binaries (implies the package "ca-certificates" as a dependency)
  curl \
  # Dev. Tooling packages (e.g. tools provided by this image installable through Alpine Linux Packages)
  git \
  make \
  build-essential \
  jq \
  zip \
  # python
  python3 \
  python3-pip \
  gpg \
  lsb-release \
  # Required for building Ruby
  libssl-dev libreadline-dev zlib1g-dev \
  # Required for some of the ruby gems that will be installed
  libyaml-dev libncurses5-dev libffi-dev libgdbm-dev \
  && \
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install ASDF to install custom tools
ARG ASDF_VERSION=0.11.3
RUN bash -c "git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v${ASDF_VERSION} && \
  echo 'legacy_version_file = yes' > $HOME/.asdfrc && \
  printf 'yarn\njsonlint' > $HOME/.default-npm-packages && \
  . $HOME/.asdf/asdf.sh && \
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git && \
  asdf install ruby 3.2.2 && \
  asdf global ruby 3.2.2 && \
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
  asdf install nodejs 18.15.0 && \
  asdf global nodejs 18.15.0 && \
  asdf plugin add java https://github.com/halcyon/asdf-java.git && \
  asdf install java zulu-17.42.19 && \
  asdf global java zulu-17.42.19"

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
