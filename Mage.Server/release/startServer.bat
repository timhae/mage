@ECHO OFF
java -Xms256m -Xmx512m -Djava.security.policy=./config/security.policy -Dlog4j.configuration=file:./config/log4j.properties -jar ./lib/mage-server-${project.version}.jar
pause
