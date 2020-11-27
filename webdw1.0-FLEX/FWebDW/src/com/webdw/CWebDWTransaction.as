package com.webdw
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	
	import mx.controls.Alert;

	
public class CWebDWTransaction extends Golbal {
//	public void ReadMe(){
//		System.out.println("事务支持，后台服务访问类");
//		System.out.println(JWebDWInfo);
//	}
	// '访问调用参数,需要外部先设置
	private var serverURL:String = ""; // '后台访问的URL,不再提供公共访问权限，通过g_serverurl来设置

	public var userid:String = ""; // '登陆用用户名

	public var passwd:String = ""; // '访问用口令

	public var opertype:String = ""; // '访问的操作类型

	public var command:String = ""; // '要执行的具体指令

	public var beginPos:int = 0; // '查询请求的开始行数，默认为0,意味着跳过行数

	public var readNum:int = 1000; // '查询请求的返回行数，默认为1000

	public var transid:String = ""; // '在支持事务的情况下，transId表示事务号

	public var errString:String = ""; // '错误信息存储字符串

	public var resultString:String = ""; // '执行后的返回字符串

	private var requestlocked :Boolean = false; //同步请求锁
	
	private var timerNum:int = 0; //计时器的循环计数变量
	
	private function timeFunc():void{
		timerNum = timerNum + 1;
	}
	
	
	// '功能描述：执行一个SQL语句，返回一个标准的结果字符串
	// '要执行的sql语句以及相关参数是这个类的public变量
	// '执行之前，先设置各个变量，再调用此方法
	// '如此设计的目的是因为一个方法多个变量令人迷惑不解
	// 'iret 返回状态，0正常 -1 失败
//	public String ExecuteSelect(MyInt iret,int i) {
//
//		String sURL = "";
//
//		errString = "";
//		serverURL = Golbal.G_ServerURL;// '读取G_ServerURL
//
//		// '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
//		sURL = serverURL + "?opertype=" + opertype + "&command=" + command
//				+ "&beginpos=" + beginPos + "&readnum=" + readNum + "&userid="
//				+ userid + "&passwd=" + passwd + "&rand=" + Now();
//		try {
//			//MyInt iret = new MyInt(0);
//			String svalue = callServer(sURL,iret);
//
//			return svalue;
//		} catch (Exception e) {
//			e.printStackTrace();
//			iret.intvalue = -1;
//			errString = "数据库访问发生异常" + e;
//			return "";
//		}
//
//	}

//	private String CallServer(String surl) throws Exception {
//		URL url = new URL(surl);
//		URLConnection conn = url.openConnection();
//
//		System.out.println("getting inputStream finished");
//
//		BufferedReader in = new BufferedReader(new InputStreamReader(conn
//				.getInputStream()));
//		String s = null;
//		String svalue = "";
//		int i = 0, j = 0;
//		while ((s = in.readLine()) != null) {
//			if (!s.equals("OK")) {
//				if (svalue.equals("")) {
//					svalue = s;
//				} else {
//					svalue = svalue + "\r\n" + s;
//				}
//			}
//		}
//		in.close();
//		// String svalue = (String) objectinputstream.readObject();
//
//		System.out.println(svalue);
//		return svalue;
//	}
          private var _countriesService:URLLoader;
          private var _statesService:URLLoader;
//          private function initializeHandler(event:Event):void {
//              _countriesService = new URLLoader();
//              _countriesService.addEventListener(Event.COMPLETE, countriesCompleteHandler);
//              _countriesService.load(new URLRequest("http://www.rightactionscript.com/states/xml/countries.xml"));
//              _statesService = new URLLoader();
//              _statesService.addEventListener(Event.COMPLETE, statesCompleteHandler);
//              XML.ignoreWhitespace = true;
//           }
//           private function countriesCompleteHandler(event:Event):void {
//           var xml:XML = new XML(_countriesService.data);
//           country.dataProvider = xml.children();
//           }
           private function statesCompleteHandler(event:Event):void {
              //var xml:XML = new XML(_statesService.data);
              //state.dataProvider = xml.children();
              requestlocked = false;
              resultString = _statesService.data
           }
//           private function changeHandler(event:Event):void {
//              var request:URLRequest = new URLRequest("http://www.rightactionscript.com/states/xml/states.php");
//              var parameters:URLVariables = new URLVariables();
//              parameters.country = country.value;
//              request.data = parameters;
//              _statesService.load(request);
//           }


	// '功能描述：执行一个SQL语句，返回一个标准的结果字符串
	// '这个方法是一个底层的实际调用过程，
	// '其他方法都是在这个方法的上面进行调用的
	// '标准返回一个字符串
	// '如果有错误，错误存储在errString里面
	private function callServer( opertypearg:String,  iret:MyInt):String {// As String
		var surl:String = "";// As String
		errString = "";
		opertype = opertypearg;// '设置为查询操作
		//Alert.show("Call callServer");
		//return "";
		// '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
		surl = Golbal.G_ServerURL + "?opertype=" + opertype + "&command="
				//+ URLEncoder.encode(command) 
				+command
				+ "&beginpos=" + beginPos + "&readnum=" + readNum
				+ "&userid=" + userid + "&passwd=" + passwd + "&transid="
				+ transid + "&rand=" + Rnd(10);
		//trace(surl);
		//Alert.show("URL:"+surl);
		try {
              //_countriesService = new URLLoader();
              //_countriesService.addEventListener(Event.COMPLETE, countriesCompleteHandler);
              //_countriesService.load(new URLRequest(surl));
   
//              _statesService = new URLLoader();
//              Alert.show("1");
//              _statesService.dataFormat=URLLoaderDataFormat.TEXT;
//              _statesService.load(new URLRequest(surl));
//              Alert.show("2");
//              requestlocked = true;
//              _statesService.addEventListener(Event.COMPLETE, statesCompleteHandler);
//			  _statesService.addEventListener(Event.DEACTIVATE,statesCompleteHandler);
//			  
//			  //flash.utils.setTimeout(timeFunc,1000,null);
//			  //timerNum =0;
//			  var t1 :int= flash.utils.getTimer();
//			  var t2 :int= flash.utils.getTimer();
//			  while(t2 < t1 + 1000 * 10 && requestlocked ){
//			  	t2 = flash.utils.getTimer();
//			  	//Alert.show("请等待...");
//			  }
			//Alert.show("Total:"+_statesService.bytesTotal);
			//Alert.show("getting inputStream finished");
			
			//试图调用javascript来和后台进行交互访问
			var funcname:String = "public_webdw_callserver";
            var retvalue:String = ExternalInterface.call(funcname,surl);

			var svalue:String = retvalue;
			//Alert.show("ret value:"+svalue);
			if(svalue == null){
				svalue ="";
			}
			if (svalue.indexOf("Exception") > 0) {
				iret.intvalue = -1;
				errString = svalue;
				svalue = "";
			} else {
				iret.intvalue = 0;
			}
			return svalue;
		} catch(e:Error) {
			//e.printStackTrace();
			iret.intvalue = -1;
			errString = e.toString();
			//MessageBox(e.toString());
			Alert.show(e.message);
			throw e;
			//return "";
		}
		return "";
	}

	// '重要更新：新功能，在客户端启动一个后台事务(虚拟事务)
	// 'iret是返回参数0 正常 -1 失败
	public function AddCommand(iret:MyInt):String {// As String
		if (transid==("")) {// = "" Then
			iret.intvalue = -1;
			errString = "Please Start Transaction Frist";
			return "";
		}
		return callServer(Golbal.G_Transaction_Const.Trans_AddCommand, iret);
	}

	// '重要更新：新功能，在客户端启动一个后台事务(虚拟事务)
	// '返回字符串代表事务编号
	// 'iret是返回参数0 正常 -1 失败
	public function BeginTransaction(iret:MyInt):String {
		if (Len(transid) > 0) {// Then
			iret.intvalue = -1;
			errString = "Please call Commit or Rollback First";
			return "";
		}

		var sret:String = "";
		var pos1:int = 0;
		sret = callServer(Golbal.G_Transaction_Const.Trans_BeginTrans, iret);
		if (iret.intvalue == -1) {
			return "";
		}
		// '需要从BeginTransaction的返回结果中解析出事务编号来
		// '设置transId
		pos1 = InStr2(sret, "" + Chr(13) + Chr(10) + "OK");
		if (pos1 > 0) {// Then
			transid = Left(sret, pos1 - 1);
			iret.intvalue = 0;
			return transid;
		} else {
			iret.intvalue = -1;
			return "";
		}
	}

	// '重要更新：新功能，在客户端提交一个后台事务(虚拟事务)
	// 'iret是返回参数0 正常 -1 失败
	public function Commit(iret:MyInt):String {

		if (transid==("")) {
			iret.intvalue = -1;
			errString = "Please Call BeginTransaction Frist";
			return "";
		}

		var sret:String = callServer(Golbal.G_Transaction_Const.Trans_Commit, iret);
		transid = "";// '清除当前事务编号
		return sret;
	}

	private function startWith( str1:String,  str2:String):Boolean {
		if (UCase(Left(str1, Len(str2)))==(UCase(str2))) {
			return true;
		} else {
			return false;
		}
	}

//	'从输入的字符串中，解析最外边的一个括号，得到里面唯一的一个参数
//	'如果这个参数用引号来包含，去掉两边的引号
//	'iret = 0 解析成功
//	'iret = -1 解析失败
	private function getOneInputArg(cmd:String, iret:MyInt ) :String {
	    var pos1:int = 0;// As Long    '左括号
	    var pos2:int =0;//As Long    '右括号
	    var stemp:String ="";// As String '临时变量
	    
	    pos1 = InStr2(cmd, "(");
	    
	    //'pos2指向最右面的一个右括号
	    for( pos2 = Len(cmd);pos2 >= 1 ;pos2--){
	        if( Mid(cmd, pos2, 1)==(")")){
	            break;
	        }
	    }
	    
	    if( pos1 <= 0 || pos2 <= 0 || pos1 > pos2){
	        iret.intvalue = -1;
	        errString = "输入参数解析失败:" + cmd;
	        return "";
	    }
	    
	    stemp = Mid(cmd, pos1 + 1, pos2 - (pos1 + 1));
	    stemp = Trim(stemp);
	    
	    //'去掉前后的引号
	    if( Left(stemp, 1)==( "\"") && Right(stemp, 1)==( "\"") && Len(stemp) > 1){
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
	public function Eval( commandarg :String,iret:MyInt ):String{
	    if( commandarg==("")){
	         iret.intvalue = 0;
	        return "";
	    }
	    
// '目前支持的动态执行方法为SetCommand,SetUserid,SetPasswd,SetBeginPos,SetReadNum,SetTransId
// '读取的动态执行方法为GetCommand,GetUserid,GetPasswd,GetBeginPos,GetReadNum,GetTransId
//	        
// '先处理对于Get方法的支持，所有的Get方法不需要额外传入参数的解析工作
	    if( startWith(commandarg,"GetCommand")){
	        iret.intvalue = 0;
	        return command;
	    }
	    
	    if(startWith(commandarg,"GetUserid")){
	        iret.intvalue = 0;
	        return userid;
	    }
	    
	    if(startWith(commandarg,"GetPasswd")){
	        iret.intvalue = 0;
	        return passwd;
	    }
	    
	    if(startWith(commandarg,"GetBeginPos")){
	        iret.intvalue = 0;
	        return ""+beginPos;
	    }
	    
	    if(startWith(commandarg,"GetReadNum")){
	        iret.intvalue = 0;
	        return ""+readNum;
	    }
	    
	    if(startWith(commandarg,"GetTransId")){
	        iret.intvalue = 0;
	        return transid;
	    }

	    
//	    '再提供对于Set方式的支持，Set方式支持时需要从传入命令中解析出传入的参数出来
//	    '传入的参数可能以双引号来包含，Set方法只传入一个参数,参数包含在括号内
	    var arg1:String ="";
	    
	    if(startWith(commandarg,"SetCommand(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            command = arg1;
	            return "OK";
	        }
	    }

	    if(startWith(commandarg,"SetUserid(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            userid = arg1;
	            return "OK";
	        }
	    }

	    if(startWith(commandarg,"SetPasswd(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            passwd = arg1;
	            return "OK";
	        }
	    }

	    if(startWith(commandarg,"SetBeginPos(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            beginPos = toInt(arg1);
	            return "OK";
	        }
	    }    
	    
	    if(startWith(commandarg,"SetReadNum(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            readNum = toInt(arg1);
	            return "OK";
	        }
	    }  	    
	
	    if(startWith(commandarg,"SetTransId(")){
	        arg1 = getOneInputArg(commandarg, iret);
	        if( iret.intvalue == -1){
	        	return "";
	        }else{
	            transid = arg1;
	            return "OK";
	        }
	    } 
	    
	    
//	    '对于非GetSet方法，暂时仍然采用标准的函数方法来进行调用。
//	    '对于不能支持的命令类型，直接返回失败失败信息
//	UnknownCommand:
	    iret.intvalue = -1;
	    errString = "Unknown Command: " + command;
	    return "";
	    
	}
	
//	'功能描述：执行一个SQL语句，得到后台的指定数据表的数据列列表
//	'具体支持情况要在后台来实现，前台仅负责向后面发送一个请求
//	'iret   返回状态，0正常 -1 失败
	public function ExecuteColumnList(iret:MyInt ):String{
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_ColumnList, iret);
	}

//	'功能描述：执行一个SQL语句，返回一个标准的结果字符串
//	'要执行的sql语句以及相关参数是这个类的public变量
//	'执行之前，先设置各个变量，再调用此方法
//	'如此设计的目的是因为一个方法多个变量令人迷惑不解
//	'iret   返回状态，0正常 -1 失败
	public function ExecuteSelect(iret:MyInt ):String{

	    //'增加一个额外的判断，确定SQL命令以Select开头,如果不是，直接退出
	    command = Trim(command);
	    
	    if(! Left(UCase(command), 6)==("SELECT")) {
	        iret.intvalue = -1;
	        errString = "Error SQL Type:" + command;
	        return "";
	    }
	    
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_Query, iret);
	}

//	'功能描述：执行一个SQL语句，得到后台的数据表及视图的列表
//	'具体支持情况要在后台来实现，前台仅负责向后面发送一个请求
//	'iret   返回状态，0正常 -1 失败
	public function ExecuteTableList(iret:MyInt ):String{
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_TableList, iret);
	}
	
//	'执行一个Update命令，或者Insert,或者Delete命令的方法
//	'这一方法考虑在正式发布版本中废弃掉
	private function executeUpdate(iret:MyInt ):String{
	    return callServer(Golbal.G_Transaction_Const.Trans_Oper_Exec, iret);
	}

//	'从后台服务器上得到指定文件，这个文件代表数据窗口的定义
//	'这一功能用来检索数据窗口的子数据窗口定义
//	'只有这样才能不加修改的使用PB自动生成的数据窗口对象
	public function GetDWDefine( dwfileName:String, iret:MyInt):String{
	    command = dwfileName;
	    //Alert.show("URL:"+Golbal.G_ServerURL);
	    //Alert.show("getdwdefine:"+Golbal.G_Transaction_Const.Trans_GetDWDefine);
	    try{
	    var sret:String= callServer(Golbal.G_Transaction_Const.Trans_GetDWDefine, iret);
		//Alert.show("return"+sret);
		return sret;
	    }catch(e:Error){
	    	Alert.show("Error in GetDWDefine:"+e.getStackTrace());
	    }
	    return "";
	}

//	'重要更新：新功能，在客户端提交一个后台事务(虚拟事务)
//	'iret是返回参数0 正常 -1 失败
	public function Rollback(iret:MyInt):String{
	    
	    if( transid==("")){
	        iret.intvalue = -1;
	        errString = "Please Call BeginTransaction Frist";
	        return "";
	    }
	    
	    var sret:String = callServer(Golbal.G_Transaction_Const.Trans_Rollback, iret);
	    transid = ""    ;//        '清除当前事务编号
	    return sret;

	}


}

}