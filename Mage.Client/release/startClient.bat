@ECHO OFF
IF NOT EXIST "C:\Program Files\Java\jre7\bin\" GOTO NOJAVADIR
set JAVA_HOME="C:\Program Files\Java\jre7\"
set CLASSPATH=%JAVA_HOME%/bin;%CLASSPATH%
set PATH=%JAVA_HOME%/bin;%PATH%
:NOJAVADIR
start javaw -Xms256M -Xmx2G -Dfile.encoding=UTF-8 -jar .\lib\mage-client-${project.version}.jar
