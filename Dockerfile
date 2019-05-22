FROM centos:7

ENV MAVEN_VERSION 3.6.1
ENV JAVA_HOME /usr/lib/jvm/java-11-amazon-corretto

RUN yum update -y \
    && yum install -y https://dl.bintray.com/jeanfelix/rpm/7/x86_64/java-11-amazon-corretto-devel-11.0.3.7-1.x86_64.rpm \
    && yum clean all \
    && curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-maven.tar.gz \
        https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar xf /tmp/apache-maven.tar.gz -C /opt/ \
    && rm /tmp/apache-maven.tar.gz \
    && ln -s /opt/apache-maven-* /opt/apache-maven \
    && ln -sf /opt/apache-maven/bin/* /usr/bin/ \
    && /usr/bin/mvn --version \
    && JQ_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/jq-latest" \
    && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/jq $JQ_URL \
    && chmod +x /usr/bin/jq \
    && jq --version \
    && groupadd --gid 3434 circleci \
    && useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci \
    && yum install -y sudo \
    && yum clean all \
    && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci

    USER circleci

    CMD ["/bin/sh"]