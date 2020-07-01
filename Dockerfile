FROM centos:7

ENV MAVEN_VERSION 3.6.3
ENV JAVA_HOME /usr/lib/jvm/java-11-amazon-corretto

RUN yum update -y \
    && rpm --import https://yum.corretto.aws/corretto.key \
    && curl --silent --show-error --location --fail --retry 3 -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo \ 
    && yum install -y java-11-amazon-corretto-devel \
    && yum install -y gcc make rpm-build \
    && yum install -y centos-release-scl-rh \
    && yum --enablerepo=centos-sclo-rh-testing install -y rh-ruby27 rh-ruby27-ruby-devel \
    && scl enable rh-ruby27 bash \
    && yum clean all \
    && curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-maven.tar.gz \
        https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar xf /tmp/apache-maven.tar.gz -C /opt/ \
    && rm /tmp/apache-maven.tar.gz \
    && ln -s /opt/apache-maven-* /opt/apache-maven \
    && ln -sf /opt/apache-maven/bin/* /usr/bin/ \
    && /usr/bin/mvn --version \
    && yum install -y epel-release \
    && yum install -y jq \
    && chmod +x /usr/bin/jq \
    && jq --version \
    && groupadd --gid 3434 circleci \
    && useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci \
    && yum install -y sudo \
    && yum install -y git \
    && yum clean all \
    && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci

    USER circleci

    CMD ["/bin/sh"]
