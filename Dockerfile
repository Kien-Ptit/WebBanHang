# Dùng Tomcat 10 (Jakarta, hợp với jakarta.servlet.*)
FROM tomcat:10.1-jdk17-temurin

# Xoá ROOT mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy WAR bạn vừa build ra
COPY dist/Banquanao.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
