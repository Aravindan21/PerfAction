FROM alpine:3.11

LABEL Author="NaveenKumar Namachivayam"
LABEL Website="https://qainsights.com"
LABEL Description="Apache JMeter Dockerfile for GitHub Actions with JMeter Plugins"

ENV JMETER_VERSION "5.5"
ENV JMETER_HOME "/opt/apache/apache-jmeter-${JMETER_VERSION}"
ENV JMETER_BIN "${JMETER_HOME}/bin"
ENV PATH "$PATH:$JMETER_BIN"
ENV JMETER_CMD_RUNNER_VERSION "2.3"
ENV JMETER_PLUGIN_MANAGER_VERSION "1.7"
ENV JMETER_PLUGIN_WEBDRIVER_VERSION "3.3"

COPY entrypoint.sh /entrypoint.sh
COPY jmeter-plugin-install.sh /jmeter-plugin-install.sh

# Downloading JMeter
RUN apk --no-cache add curl ca-certificates openjdk8-jre && \
    curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz --output /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    tar -zxvf /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    mkdir -p /opt/apache && \
    mv apache-jmeter-${JMETER_VERSION} /opt/apache && \
    rm /tmp/apache-jmeter-${JMETER_VERSION}.tgz && \
    rm -rf /var/cache/apk/* && \
    chmod a+x /entrypoint.sh && \
    chmod a+x /jmeter-plugin-install.sh
    
    apt install xvfb
    curl -sS -o – https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
    bash -c “echo ‘deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main’ >> /etc/apt/sources.list.d/google-chrome.list”
    apt-get update
    apt-get install google-chrome-stable
    google-chrome –version 
    wget https://chromedriver.storage.googleapis.com/99.0.4844.51/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip
    mv chromedriver /usr/bin/chromedriver
    chown root:root /usr/bin/chromedriver
    chmod +x /usr/bin/chromedriver 
    wget https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.1.0/selenium-server-4.1.2.jar
    mv selenium-server-4.1.2.jar selenium-server.jar
    xvfb-run java -Dwebdriver.chrome.driver=/usr/bin/chromedriver -jar selenium-server.jar

# Downloading CMD Runner
RUN /jmeter-plugin-install.sh

ENTRYPOINT [ "/entrypoint.sh" ]
