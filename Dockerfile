FROM ubuntu:22.04

#  Set up for non-root user "don"
#####
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1001

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
#
# Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && echo $USERNAME:password | chpasswd \
# Add packages
#####
    && apt-get update \
    && apt-get install -y vim \
    iputils-ping \
    net-tools \
    build-essential \
    python3-pip \
    repo \
    && repo version \
# Create working directory
#####
    && mkdir /home/dev/trs-workspace \
    && cd /home/dev/trs-workspace \
# Update password for ssh access and start up ssh
#####
    && apt update && apt install openssh-server sudo -y \
    && echo 'root:password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && service ssh start


EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
# ENTRYPOINT service bash

