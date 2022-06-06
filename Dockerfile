FROM almalinux/almalinux
RUN dnf -y update; dnf clean all
RUN dnf -y install openssh-server passwd;
RUN systemctl enable sshd
# Dnf Install
RUN dnf install -y \
  sudo \
  which \
  unzip \
  vim \
  git \
  firewalld \
  cronie-noanacron \
  iproute \
  openssh-clients

RUN dnf -y install python36
RUN dnf -y install epel-release
RUN pip3 install --upgrade pip
RUN dnf install -y --enablerepo epel-playground ansible

# sshd_config
RUN sed -i'' -e's/^#PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PubkeyAuthentication yes$/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^PasswordAuthentication yes$/PasswordAuthentication no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PermitEmptyPasswords no$/PermitEmptyPasswords no/' /etc/ssh/sshd_config
# root pasword
RUN echo 'root:password' | chpasswd

## User Add
RUN useradd ansible
RUN echo 'ansible:password' | chpasswd
RUN echo "ansible ALL=NOPASSWD: ALL" >> /etc/sudoers

# host key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
# EntryPoint
# SSH key
RUN mkdir -m 700 /home/ansible/.ssh
RUN chown -R ansible:ansible /home/ansible/.ssh/

RUN touch /home/ansible/.ssh/authorized_keys  \
  && chmod 600 /home/ansible/.ssh/authorized_keys \
  && chown ansible:ansible /home/ansible/.ssh/authorized_keys

# Open ssh port
EXPOSE 22

# EntryPoint
ENTRYPOINT ["/sbin/init"]


