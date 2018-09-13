FROM macielbombonato/docker-builder:latest

LABEL maintainer "Maciel Escudero Bombonato <maciel.bombonato@gmail.com>"

WORKDIR /

USER root

# Update certificates
RUN update-ca-certificates

# Install gradle
RUN git config --global http.sslverify "false" \
 && wget --no-check-certificate https://services.gradle.org/distributions/gradle-4.7-bin.zip?_ga=2.231650783.1772064128.1527540661-637361431.1521740106 -O gradle-4.7-bin.zip \
 && unzip -d /opt gradle-4.7-bin.zip \
 && rm /gradle-4.7-bin.zip

ENV PATH $PATH:/opt/gradle-4.7/bin

# Cleaning
RUN apt-get clean --yes

# Create directory to host the application
WORKDIR /opt/app

# Copy sonar scanner to the image
COPY ./tools/sonar-scanner-3.2.0.1227 /opt/sonar-scanner
ENV PATH="/opt/sonar-scanner/bin:${PATH}"

# Copy jenkins agent runner to the image
COPY ./tools/run-jenkins-agent.sh /opt/slave/run-jenkins-agent.sh

CMD /opt/slave/run-jenkins-agent.sh
