FROM tomcat:8.0
ADD ./webapp/target/*.war /usr/local/tomcat/webapps
ADD ./tomcat/conf/tomcat-users.xml /usr/local/tomcat/conf
EXPOSE 8080
CMD ["catalina.sh", "run"]
