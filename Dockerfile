# Ví dụ Dockerfile
FROM tomcat:9.0-jdk17-temurin

# Xoá ROOT cũ
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR bạn build ra
COPY dist/Banquanao.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
