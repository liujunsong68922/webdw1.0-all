# webdw1.0-JAVA
这个版本是一个JAVA编写的客户端程序，在JAVA客户端上模拟实现了PowerBuilder的DataWindow的部分核心功能
需要和后台服务器配合进行使用。

安装过程如下：
1. cd jwebdw
2. mvn clean package
3. java -jar target\jwebdw-1.0.0.jar

这时就会出现一个JAVA的图形界面，选择其中的按钮功能进行功能演示。演示时需要访问本地的后台服务器。
http://localhost/myproj/Table

默认和服务器安装在同一台机器上，可以通过修改Global.java进行服务器地址的修改。
