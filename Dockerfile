FROM centos:8.1.1911

LABEL author="Mirko Hering <mirko@jmhering.net>"

ENV  MYSQL_REPO=http://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm \
     CMAKE_DOWNLOAD=https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1-Linux-x86_64.sh \
     FIND_MYSQL_URL=https://raw.githubusercontent.com/Icinga/icinga2/master/third-party/cmake/FindMySQL.cmake

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install MySQL client libs and dev tools
RUN rpm -Uvh ${MYSQL_REPO}}
RUN yum -y erase MariaDB-devel.x86_64
RUN yum -y install @'Development Tools' mysql-libs mysql mysql-devel python2-devel boost-devel\
    && yum clean all

# Install current version of CMake
RUN curl -L -o /tmp/install-cmake.sh ${CMAKE_DOWNLOAD} && chmod +x /tmp/install-cmake.sh \
    && chmod +x /tmp/install-cmake.sh \
    && /tmp/install-cmake.sh --skip-license \
    && ls -al /share/ \
    && ln -s /usr/bin/sh /bin/sh

