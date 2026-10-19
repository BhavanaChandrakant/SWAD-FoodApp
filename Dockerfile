FROM tomcat:10.1-jdk21-temurin

# Remove Tomcat's default homepage
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy SWAD JSP pages, CSS, images and libraries
COPY src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

# Copy Java source files temporarily for compilation
COPY src/main/java/ /tmp/swad-src/

# Compile the Java application for Tomcat 10.1
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
    && find /tmp/swad-src -type f -name '*.java' > /tmp/sources.txt \
    && javac -encoding UTF-8 \
       -cp '/usr/local/tomcat/lib/*:/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/*' \
       -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
       @/tmp/sources.txt \
    && rm -rf /tmp/swad-src /tmp/sources.txt \
    && sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml

EXPOSE 10000

CMD ["catalina.sh", "run"]