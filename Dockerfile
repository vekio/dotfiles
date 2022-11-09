FROM ubuntu:jammy

RUN yes | unminimize \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        sudo && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN groupadd alberto && \
    useradd -m -g alberto -G sudo alberto -p "$(openssl passwd -6 1234)" && \
    echo 'alberto ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER alberto

WORKDIR /home/alberto

CMD [ "bash" ]
