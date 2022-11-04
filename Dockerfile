FROM ubuntu:22.04
MAINTAINER Don Harbin (don.harbin@linaro.org)

ENV DEBIAN_FRONTEND noninteractive

################################################################################
# APT packages
################################################################################
RUN apt update

RUN apt -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install apt-utils

# https://trs.readthedocs.io/en/latest/install/install.html#installing-prerequisites
# However, to avoid making changes here, it's better to add 'sudo' support and
# then once running the docker image instead call 'make apt-prereqs'
RUN apt -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
	    acpica-tools \
	    adb \
	    autoconf \
	    automake \
	    bc \
	    bison \
	    build-essential \
	    ccache \
	    chrpath \
	    cpio \
	    cscope \
	    curl \
	    device-tree-compiler \
	    diffstat \
	    expect \
	    fastboot \
	    file \
	    flex \
	    ftp-upload \
	    gawk \
	    gdisk \
	    libattr1-dev \
	    libcap-dev \
	    libfdt-dev \
	    libftdi-dev \
	    libglib2.0-dev \
	    libgmp3-dev \
	    libhidapi-dev \
	    libmpc-dev \
	    libncurses5-dev \
	    libpixman-1-dev \
	    libssl-dev \
	    libtool \
	    lz4 \
	    make \
	    make \
	    mtools \
	    netcat \
	    ninja-build \
	    pip \
	    python3-cryptography \
	    python3-pip \
	    python3-pyelftools \
	    python3-serial \
	    python3-venv \
	    python-is-python3 \
	    qemu-system-aarch64 \
	    rsync \
	    sudo \
	    unzip \
	    uuid-dev \
	    wget \
	    xdg-utils \
	    xdg-utils \
	    xterm \
	    xz-utils \
	    zlib1g-dev \
	    zstd

# Add a few extra packages for Docker only, arguable they should be part of the
# complete TRS instructions
RUN apt -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
	    curl \
	    cpio \
	    git \
	    vim \
	    wget

################################################################################
# Repo
################################################################################
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

################################################################################
# User and group configuration
################################################################################
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

# Exchange 1000 to the user id of the current user
RUN useradd --shell /bin/bash -u $USER_UID -o -c "" -m $USERNAME
RUN echo "${USERNAME}:${USERNAME}" | chpasswd

################################################################################
# Locale configuration
################################################################################
RUN apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

################################################################################
# Sudo setup
################################################################################
RUN apt -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install sudo
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
RUN chmod 0440 /etc/sudoers.d/$USERNAME

################################################################################
# Clean up
################################################################################
RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


################################################################################
# Start user related configuration / TRS
################################################################################
ENV WORKSPACE=/home/dev/trs-workspace
RUN mkdir -p $WORKSPACE/build
WORKDIR $WORKSPACE

ADD trs-install.sh $WORKSPACE/trs-install.sh
RUN chown -R $USERNAME:$USERNAME $WORKSPACE

USER $USERNAME
ENV PATH="${PATH}:/home/${USERNAME}/.local/bin"


# Configure git so repo won't complain later on
RUN git config --global user.name "${USERNAME}"
RUN git config --global user.email "trs@linaro.org"

RUN chmod a+x $WORKSPACE/trs-install.sh
RUN ln -snf $HOME/yocto_cache/downloads $WORKSPACE/build/downloads
RUN ln -snf $HOME/yocto_cache/state-cache $WORKSPACE/build/state-cache

################################################################################
# SSH configuration
################################################################################
# Update password for ssh access and start up ssh
#####
#RUN apt update && apt install openssh-server sudo -y \
#&& echo 'root:password' | chpasswd \
#&& sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
#&& service ssh start

#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]
# ENTRYPOINT service bash
