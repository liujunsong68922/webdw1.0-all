# webdw1.0-JAVASCRIPT
WebDW1.0的JavaScript客户端版本，与WebDW1.0-server配合使用。

jswebdw的V1.0版本开始开发时间是在2009年，当时的js技术还比较原始，甚至连jquery也属于比较新颖的技术，
当时第一版本实现时是直接采用原生的js代码实现的。

现在看到的这个js版本是2019年重新编写的，采用了ES6的语法，用class关键字进行代码封装和对象调用组合。
由于jswebdw的V2.0版本在同时进行开发，V1.0的版本只实现了设置数据窗口和数据检索两项基本功能，暂时不再继续深入开发。

后续推荐使用jswebdw V2.0版本，jswebdw V1.0版本停止更新。

目录说明：
/jswebdw 目录下是原始的，一个类一个文件的js模式代码
/jswebdw_v1.1 目录下是将同样属性的几个类进行分类组合合并，一个js文件里包含多个Class的模式代码

jswebdw和后台Servlet之间的通讯，采用jQuery作为工具组件，发起Ajax调用。
后台服务器地址分别配置在Golbal.js 和 WebDW_common_all.js 里面

下载以后可以直接将js文件就可以使用，jswebdw_index.html是一个演示文件。


