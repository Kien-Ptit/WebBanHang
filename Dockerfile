FROM tomcat:9.0

# Xoá ROOT mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR bạn vừa build ra
COPY dist/Banquanao.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
