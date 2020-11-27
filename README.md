# webdw1.0-server
webdw1.0版本的后台通用服务器，提供前端执行SQL语句的标准功能，为多种不同客户端使用，使用JAVA语言编写。

由于这个软件的开发周期比较长了，一开始的时候选择的是比较原始的技术方案。
这个服务器是一个纯粹的Servlet方案，没有用到任何第三方框架，包括spring.

安装执行步骤如下：
1. cd myproj
2. mvn clean package
3. 把打包生成的myproj.war 文件放置在tomcat webapps目录下
4. 在本地创建一个webdw1.0的数据库，使用mysql
5. 手工执行dbsql目录下的sql命令，初始化数据库
6. 将webdwfile目录拷贝到C:\下
7. 启动tomcat,自动发布war包，后台使用的Servlet为 http://localhost/myproj/Table

后续建议使用WebDW V2.0版本的各项功能。
