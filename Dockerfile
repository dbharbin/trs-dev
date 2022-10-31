FROM ubuntu:22.04

#  Set up for non-root user "don"
#####
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1001

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME 
    #
    # Add sudo support. Omit if you don't need to install software after connecting.
RUN apt-get update \
    && apt-get install -y sudo 

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME 
RUN chmod 0440 /etc/sudoers.d/$USERNAME 
RUN echo $USERNAME:password | chpasswd

# Add packages
#####
RUN apt-get update
RUN apt-get install -y vim \
    iputils-ping \
    net-tools \
    build-essential \
    python3-pip \
    repo

RUN repo version

# Get the TRS latest source code
#####
RUN mkdir /home/dev/trs-workspace
RUN cd trs-workspace
RUN repo init -u https://gitlab.com/Linaro/trusted-reference-stack/trs-manifest.git
RUN repo sync -j3
RUN export PATH=$PATH:/home/dev/.local/bin

# Update password for ssh access and start up ssh
#####
RUN apt update && apt install openssh-server sudo -y
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN service ssh start


EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
# ENTRYPOINT service bash

