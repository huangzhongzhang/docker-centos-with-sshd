FROM daocloud.io/centos:7
MAINTAINER HZZ <https://www.huangzz.xyz>
WORKDIR /root
ENV TZ=Asia/Shanghai

RUN \
    set -x;ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    yum -y install kde-l10n-Chinese && \
    yum -y reinstall glibc-common && \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 &&\
    export LC_ALL=zh_CN.utf8 && \
    yum install openssh-server -y && \
    yum clean all && \
    mkdir /var/run/sshd && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key && \
    echo "root:12345678"|chpasswd && \
    sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd;
EXPOSE 22
CMD /usr/sbin/sshd -D
