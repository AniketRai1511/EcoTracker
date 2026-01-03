FROM tomcat:8.0-jre8

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your ROOT.war
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Disable AJP connector
RUN sed -i '/AJP\/1.3/d' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]


