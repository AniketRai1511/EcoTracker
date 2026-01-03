FROM tomcat:8.0-jre8

# Default ROOT app remove
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR as ROOT app
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]


