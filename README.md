关于[开源软件]WebDW1.0版本的封版说明

作者：刘峻松
Email: liujunsong@aliyun.com
日期：2020-11-27

《圣经》上有一篇《雅歌》，其中有一首是这样说的。

万物有时
生有时，死有时
相聚有时，分离有时
。。。
如此之类

现在经过了这么多年，是时候将WebDW1.0进行最终的封版，并从此相忘于江湖了。

WebDW1.0这个产品由5个产品组成，分别是服务器端+客户端构成；
服务器端由Java编写，通过Servlet方式向外部提供服务，主要是执行SQL语句的能力。这个产品做的太早了，最早的编码使用的是GBK，
而不是现在流行的UTF-8，现在升级到1.0版本以后，可能已经是改过来了。

客户端由多个语言编写，包括VB,JAVA,JS,FlEX
这几个项目原来在github上是独立的子项目，现在由于项目要彻底封版，所以为节约项目数量考虑，合并到一个项目空间里面来。

webdw1.0-VB 	VB版本的客户端（完成度比较高）
webdw1.0-JAVA 	JAVA版本的客户端（完成度比较高）
webdw1.0-JAVASCRIPT JS版本的客户端（简易版本）
webdw1.0-FLEX            FLEX版本的客户端（简易版本）

详细的使用手册将在后续提供。

这一项目设计为开源项目，任何人都可以根据自己的需要来自由使用这些代码和功能。

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
