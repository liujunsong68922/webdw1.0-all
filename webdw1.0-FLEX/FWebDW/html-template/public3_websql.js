	/* Create a new XMLHttpRequest object to talk to the Web server */
	var xmlHttp = false;
	
	/* this is the return value                        */
	var public_xmlHttpReturn = ""; 
	/*@cc_on @*/
	/*@if (@_jscript_version >= 5)
	try {
		xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
	try {
    	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
  	} catch (e2) {
    	xmlHttp = false;
  	}
	}
	@end @*/
	if (!xmlHttp && typeof XMLHttpRequest != 'undefined') {
		xmlHttp = new XMLHttpRequest();
	}
	
function public_webdw_callserver(strurl){
	public_webdw_do_callserver(strurl);
	return public_xmlHttpReturn;
}

function public_webdw_do_callserver(strurl){
	public_xmlHttpReturn = "";
  	//var url = strurl ;
   	xmlHttp.open("GET", strurl, false);
  	//alert("call server:"+strurl);
  	xmlHttp.onreadystatechange = public_websql_do_setReturnValue;
 		xmlHttp.send(null);		
}
/* This function is used to call a sql command   */
/* return the background value to caller         */
/* This function is belong to websql             */	

function public_websql_executeQuery(strSql,debugmode){
	public_websql_do_executeQuery(strSql,debugmode);	
	return public_xmlHttpReturn;
}

/* This function is used to execute a sql command   */
/* return the background value to caller         */
/* This function is belong to websql             */	

function public_websql_executeUpdate(strSql,debugmode){
	public_websql_do_executeUpdate(strSql,debugmode);	
	return public_xmlHttpReturn;
}
	
/* this function is used to execute a SQL Query  */
/* result is save in public_requestReturn value  */
function public_websql_do_executeQuery(strSql,debugmode){
	public_xmlHttpReturn = "";
  	var sql = strSql;
   	if ((sql == null) || (sql =="")) return;
  	var url = "/myproj/Table?city=" + Math.random() ;
  	url = url +"&opertype=1&command="+escape(sql);
   	xmlHttp.open("GET", url, false);
   	if(debugmode){
  		alert("call server");
  	}
  	xmlHttp.onreadystatechange = public_websql_do_setReturnValue;
 	xmlHttp.send(null);	
}

/* this function is used to execute a SQL Query  */
/* result is save in public_requestReturn value  */
function public_websql_do_executeUpdate(strSql,debugmode){
	public_xmlHttpReturn = "";
  	var sql = strSql;
   	if ((sql == null) || (sql =="")) return;
  	var url = "/myproj/Table?city=" + Math.random() ;
  	url = url +"&opertype=2&command="+sql;
   	xmlHttp.open("GET", url, false);
   	if(debugmode){
  		alert("call server");
  	}
  	xmlHttp.onreadystatechange = public_websql_do_setReturnValue;
 	xmlHttp.send(null);	
}
/* save the return value to a public value       */
function public_websql_do_setReturnValue(){
  if (xmlHttp.readyState == 4) {
    public_xmlHttpReturn = xmlHttp.responseText;
  }else{
	public_xmlHttpReturn ="";
  }
}
	
