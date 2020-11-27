var xmlHttp;
var xmlHttpReturn; //定义Ajax调用以后产生的全局返回值存放位置
var xmlHttpReturn_error;

class CWebDWTransaction extends Golbal {
	// Constructor function
	constructor(){
		// 建立和全局对象之间的对应关系
		super();
		
		this.Golbal = golbal;
		this.ReadMe ="事务支持，后台服务访问类";
		// this.serverURL = ""; // '后台访问的URL,不再提供公共访问权限，通过g_serverurl来设置
		this.userid = ""; // '登陆用用户名
		this. passwd = ""; // '访问用口令
		this. opertype = ""; // '访问的操作类型
		this. command = ""; // '要执行的具体指令
		this. beginPos = 0; // '查询请求的开始行数，默认为0,意味着跳过行数
		this. readNum = 1000; // '查询请求的返回行数，默认为1000
		this. transid = ""; // '在支持事务的情况下，transId表示事务号
		this. errString = ""; // '错误信息存储字符串
		this. resultString = ""; // '执行后的返回字符串

		// call server
//		xmlHttp = new XMLHttpRequest(); // call object
//		this.xmlHttpReturn = xmlHttpReturn; // xml call return value
	}

	// '功能描述：执行一个SQL语句，返回一个标准的结果字符串
	// '这个方法是一个底层的实际调用过程，
	// '其他方法都是在这个方法的上面进行调用的
	// '标准返回一个字符串
	// '如果有错误，错误存储在errString里面
	
	// call server function
	callServer(opertypearg, iret) {// As String
		var surl = "";// As String

		this.errString = "";
		this.opertype = opertypearg;// '设置为查询操作
		var surl = this.Golbal.G_ServerURL + "?opertype=" + this.opertype + "&command="
		+ escape(this.command) + "&beginpos=" + this.beginPos + "&readnum=" + this.readNum
		+ "&userid=" + this.userid + "&passwd=" + this.passwd + "&transid="
		+ this.transid + "&rand=" + Math.random()*10;
		
		// log it to console
		console.log(surl);
		this.svalue="";
		$.ajax({
            type: "GET",
            url: surl,
            data: "",
            async:false,
            dataType: "text",
            success: function(data){
				console.log(data);
				xmlHttpReturn = data;
				if (data.indexOf("Exception") > 0) {
					iret.intvalue = -1;
					xmlHttpReturn =  "";
					xmlHttpReturn_error = data;
				} else {
					iret.intvalue = 0;
					//alert(iret.intvalue);
				}
			return xmlHttpReturn;
            }
		});
	}
		// call server
//		xmlHttp = new XMLHttpRequest();
//	   	xmlHttp.open("GET", surl, false);
//	   	//xmlHttp.responseType="text";
//	   	xmlHttp.onreadystatechange = function(){
//	   		alert(xmlHttp.readyState);
//			if (xmlHttp.readyState == 4 ) {
//				console.log("call end...");
//				this.xmlHttpReturn = xmlHttp.responseText;
//				var svalue = xmlHttp.responseText;
//				if (svalue.indexOf("Exception") > 0) {
//					iret.intvalue = -1;
//					this.errString = svalue;
//					svalue = "";
//				} else {
//					iret.intvalue = 0;
//				}
//				return svalue;
//			}else{
//				alert(xmlHttp.readyState);
//				this.xmlHttpReturn ="";
//				return "";
//			}	   		
//	   	};
//	   	console.log("call begin...");
//	   	
//	   	//caller will pending here.
//	   	xmlHttp.send(null);
//	
//	   	console.log("call end...,should not called.");

//	}

	// '重要更新：新功能，在客户端启动一个后台事务(虚拟事务)
	// 'iret是返回参数0 正常 -1 失败
	AddCommand(iret) {// As String
		if (this.transid == ("")) {// = "" Then
			iret.intvalue = -1;
			this.errString = "Please Start Transaction Frist";
			return "";
		}
		return this.callServer(this.Golbal.G_Transaction_Const.Trans_AddCommand, iret);
	}

	// '重要更新：新功能，在客户端启动一个后台事务(虚拟事务)
	// '返回字符串代表事务编号
	// 'iret是返回参数0 正常 -1 失败
	BeginTransaction(iret) {
		if (this.transid.length() > 0) {// Then
			iret.intvalue = -1;
			this.errString = "Please call Commit or Rollback First";
			return "";
		}

		var sret = "";
		var pos1 = 0;
		sret = this.callServer(this.Golbal.G_Transaction_Const.Trans_BeginTrans, iret);
		if (iret.intvalue == -1) {
			return "";
		}
		// '需要从BeginTransaction的返回结果中解析出事务编号来
		// '设置transId
		pos1 = InStr(sret, "" + Chr(13) + Chr(10) + "OK");
		if (pos1 > 0) {// Then
			this.transid = Left(sret, pos1 - 1);
			iret.intvalue = 0;
			return this.transid;
		} else {
			iret.intvalue = -1;
			return "";
		}
	}

	// '重要更新：新功能，在客户端提交一个后台事务(虚拟事务)
	// 'iret是返回参数0 正常 -1 失败
	Commit(iret) {

		if (this.transid == ("")) {
			iret.intvalue = -1;
			this.errString = "Please Call BeginTransaction Frist";
			return "";
		}

		var sret = this.callServer(Golbal.G_Transaction_Const.Trans_Commit, iret);
		this.transid = "";// '清除当前事务编号
		return sret;
	}

	startWith(str1, str2) {
		if (UCase(Left(str1, Len(str2))) == (UCase(str2))) {
			return true;
		} else {
			return false;
		}
	}

// '从输入的字符串中，解析最外边的一个括号，得到里面唯一的一个参数
// '如果这个参数用引号来包含，去掉两边的引号
// 'iret = 0 解析成功
// 'iret = -1 解析失败
	getOneInputArg(cmd, iret ) {
	    var pos1 = 0;// As Long '左括号
	    var pos2 =0;// As Long '右括号
	    var stemp ="";// As String '临时变量
	    
	    pos1 = InStr(cmd, "(");
	    
	    // 'pos2指向最右面的一个右括号
	    for( pos2 = Len(cmd);pos2 >= 1 ;pos2--){
	        if( Mid(cmd, pos2, 1) == (")")){
	            break;
	        }
	    }
	    
	    if( pos1 <= 0 || pos2 <= 0 || pos1 > pos2){
	        iret.intvalue = -1;
	        this.errString = "输入参数解析失败:" + cmd;
	        return "";
	    }
	    
	    stemp = Mid(cmd, pos1 + 1, pos2 - (pos1 + 1));
	    stemp = Trim(stemp);
	    
	    // '去掉前后的引号
	    if( Left(stemp, 1) == ( "\"") && Right(stemp, 1) == ( "\"") && Len(stemp) > 1){
	        stemp = Mid(stemp, 2, Len(stemp) - 2);
	    }
	    
	    iret.intvalue = 0;
	    return stemp;
	}	
	// '为了减少数据的依赖，以及减少过多的对外接口
	// '对于本地常量的设置和读取，采用一个统一的接口来实现
	// '例如对于command变量
	// '此方法添加于20090217日
	// '调用方式为eval("SetCommand(" + sql+")")就可以设置command变量，
	Eval(commandarg , iret ){
	    if( commandarg==("")){
	         iret.intvalue = 0;
	        return "";
	    }
	    
// '目前支持的动态执行方法为SetCommand,SetUserid,SetPasswd,SetBeginPos,SetReadNum,SetTransId
// '读取的动态执行方法为GetCommand,GetUserid,GetPasswd,GetBeginPos,GetReadNum,GetTransId
//	        
// '先处理对于Get方法的支持，所有的Get方法不需要额外传入参数的解析工作
	    if( this.startWith(commandarg,"GetCommand")){
	        iret.intvalue = 0;
	        return this.command;
	    }
	    
	    if(this.startWith(commandarg,"GetUserid")){
	        iret.intvalue = 0;
	        return userid;
	    }
	    
	    if(this.startWith(commandarg,"GetPasswd")){
	        iret.intvalue = 0;
	        return passwd;
	    }
	    
	    if(this.startWith(commandarg,"GetBeginPos")){
	        iret.intvalue = 0;
	        return beginPos;
	    }
	    
	    if(this.startWith(commandarg,"GetReadNum")){
	        iret.intvalue = 0;
	        return readNum;
	    }
	    
	    if(this.startWith(commandarg,"GetTransId")){
	        iret.intvalue = 0;
	        return transid;
	    }

	    
// '再提供对于Set方式的支持，Set方式支持时需要从传入命令中解析出传入的参数出来
// '传入的参数可能以双引号来包含，Set方法只传入一个参数,参数包含在括号内
	    var arg1 ="";
	    
	    if(this.startWith(commandarg,"SetCommand(")){
	        arg1 = this.getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            this.command = arg1;
	            return "OK";
	        }
	    }

	    if(this.startWith(commandarg,"SetUserid(")){
	        arg1 = this.getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            userid = arg1;
	            return "OK";
	        }
	    }

	    if(this.startWith(commandarg,"SetPasswd(")){
	        arg1 = this.getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            passwd = arg1;
	            return "OK";
	        }
	    }

	    if(this.startWith(commandarg,"SetBeginPos(")){
	        arg1 = this.getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            beginPos = toInt(arg1);
	            return "OK";
	        }
	    }    
	    
	    if(this.startWith(commandarg,"SetReadNum(")){
	        arg1 = this.getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            readNum = toInt(arg1);
	            return "OK";
	        }
	    }  	    
	
	    if(this.startWith(commandarg,"SetTransId(")){
	        arg1 = this.getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            transid = arg1;
	            return "OK";
	        }
	    } 
	    
	    
// '对于非GetSet方法，暂时仍然采用标准的函数方法来进行调用。
// '对于不能支持的命令类型，直接返回失败失败信息
// UnknownCommand:
	    iret.intvalue = -1;
	    errString = "Unknown Command: " + this.command;
	    return "";
	    
	}
	
// '功能描述：执行一个SQL语句，得到后台的指定数据表的数据列列表
// '具体支持情况要在后台来实现，前台仅负责向后面发送一个请求
// 'iret 返回状态，0正常 -1 失败
	ExecuteColumnList(iret ){
	    return callServer(this.Golbal.G_Transaction_Const.Trans_Oper_ColumnList, iret);
	}

// '功能描述：执行一个SQL语句，返回一个标准的结果字符串
// '要执行的sql语句以及相关参数是这个类的public变量
// '执行之前，先设置各个变量，再调用此方法
// '如此设计的目的是因为一个方法多个变量令人迷惑不解
// 'iret 返回状态，0正常 -1 失败
	ExecuteSelect(iret ){

	    // '增加一个额外的判断，确定SQL命令以Select开头,如果不是，直接退出
	    this.command = Trim(this.command);
	    
	    if(! Left(UCase(this.command), 6) == ("SELECT")) {
	        iret.intvalue = -1;
	        errString = "Error SQL Type:" + this.command;
	        return "";
	    }
	    
	    this.callServer(this.Golbal.G_Transaction_Const.Trans_Oper_Query, iret);
	    return xmlHttpReturn;
	}

// '功能描述：执行一个SQL语句，得到后台的数据表及视图的列表
// '具体支持情况要在后台来实现，前台仅负责向后面发送一个请求
// 'iret 返回状态，0正常 -1 失败
	ExecuteTableList(iret ){
	    return this.callServer(this.Golbal.G_Transaction_Const.Trans_Oper_TableList, iret);
	}
	
// '执行一个Update命令，或者Insert,或者Delete命令的方法
// '这一方法考虑在正式发布版本中废弃掉
	executeUpdate( iret ){
	    return this.callServer(this.Golbal.G_Transaction_Const.Trans_Oper_Exec, iret);
	}

// '从后台服务器上得到指定文件，这个文件代表数据窗口的定义
// '这一功能用来检索数据窗口的子数据窗口定义
// '只有这样才能不加修改的使用PB自动生成的数据窗口对象
	GetDWDefine( dwfileName,  iret){
	    this.command = dwfileName;
	    this.callServer(this.Golbal.G_Transaction_Const.Trans_GetDWDefine, iret);
	    return xmlHttpReturn;
	}

// '重要更新：新功能，在客户端提交一个后台事务(虚拟事务)
// 'iret是返回参数0 正常 -1 失败
	Rollback(iret){
	    
	    if( this.transid == ("")){
	        iret.intvalue = -1;
	        this.errString = "Please Call BeginTransaction Frist";
	        return "";
	    }
	    
	    var sret = callServer(Golbal.G_Transaction_Const.Trans_Rollback, iret);
	    transid = ""    ;// '清除当前事务编号
	    return sret;

	}


}