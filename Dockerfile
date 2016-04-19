FROM debian:latest

MAINTAINER Dmitrii Zolotov <dzolotov@herzen.spb.ru>

ENV JAVA_HOME /jdk
ENV JRE_HOME  $JAVA_HOME/jre
ENV PATH $PATH:$JAVA_HOME/bin
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_VERSION 8
ENV JCE_VERSION 8
ENV JAVA_UPDATE 77
ENV JAVA_BUILD 03

RUN apt-get update && apt-get install -y curl unzip && \
    (curl -L -k -b "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/server-jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz | gunzip -c | tar x) \
    && mv /jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} /jdk && cd /tmp && \
    curl -O https://letsencrypt.org/certs/isrgrootx1.der && \
    curl -O https://letsencrypt.org/certs/letsencryptauthorityx1.der && \
    keytool -importcert -alias isrgrootx1 -keystore /jdk/jre/lib/security/cacerts -storepass changeit -noprompt -file /tmp/isrgrootx1.der && \
    keytool -importcert -alias letsencryptauthorityx1 -keystore /jdk/jre/lib/security/cacerts -storepass changeit -noprompt -file /tmp/letsencryptauthorityx1.der && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN cd /tmp && rm *.der && curl -L -O -k -b "oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jce/${JCE_VERSION}/jce_policy-${JCE_VERSION}.zip \
 && unzip jce_policy-${JCE_VERSION}.zip \
 && mv UnlimitedJCEPolicyJDK${JAVA_VERSION}/*.jar /jdk/jre/lib/security/ \
 && rm -fR jce_policy-${JCE_VERSION}.zip UnlimitedJCEPolicyJDK${JAVA_VERSION}



