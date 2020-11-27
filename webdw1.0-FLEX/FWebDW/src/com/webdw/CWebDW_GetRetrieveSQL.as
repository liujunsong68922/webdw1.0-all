package com.webdw
{
//Rem -------------------------------------------------
//Rem WebDW的的数据访问功能类
//Rem 输入：g_webdw
//Rem g_webdw是由CWebDW构建生成的
//Rem 生成以后，对于g_webdw的所有数据读取请求，全部集中在CWebDWReader中实现
//Rem 这样可以明确代码的功能划分，避免代码混乱
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDW_GetRetrieveSQL extends Golbal {
//	public override function ReadMe(){
//		trace("WebDW的的数据访问功能类");
//		trace(JWebDWInfo);
//	}
	private var local_webdw:WebDWSyntax = null;// 'local_webdw现在是一个局部变量了，而不是全局变量了

	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：g_webdw
	public function SetLocalWebDW():void {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取g_webdw的值
	// '输入:g_webdw
	// '输出:gg_webdw
	public function GetLocalWebDW():void{
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '对输入的字符串进行检查
	// '如果以"开头，以"结束,那么就删除掉前后的两个引号
	private function removeQuote(strIn:String):String {
		var ilen:int;
		ilen = Len(strIn);

		if (strIn==("")) {
			return "";
		}
		if (Left(strIn, 1)==("\"") && Right(strIn, 1)==("\"")) {
			return Mid(strIn, 2, ilen - 2);
		}
		return strIn;
	}

	// '得到label的总数
	private function getLableNum() :int{
		var id :int= 0;
		for (id = 1; id <= 100; id++) {
			if (local_webdw.text[id].Name==("")) {
				return id - 1;
			}
		}
		return id - 1;
	}

	// '从inString字符串中，根据元素的名称，得到这个元素的整体描述字符串
	// '查找的算法是：
	// '从原始字符串中开始查找，找到eleName，它的后面应该跟随一个(，标志这个元素的开始
	// '元素中可能嵌套定义内部元素，因此需要对找到的()进行计数
	// '返回的字符串，不再包括()
	// '查找的算法受限于webdw的具体表示，目前采用和PB7一致的表示方法
	// '按照初步设计，webdw应该可以支持PB7导出的DW的正常显示功能
	// '或者说，webdw和PB7是兼容的。
	// 'inString 总的字符串
	// 'eleName 元素名称
	// 'beginPos 开始检索位置
	// 'findPos 输出参数,表示找到的位置,没找到返回-1,要返回参数,所以用Integer类型
	private function getElementDesc( inString:String,  eleName:String,
			 beginPos:int,  findPos:MyInt):String {
		var iBeg:int;
		var leftPos:int;
		var iflag:int;

		var i:int;
		var s:String;

		findPos.intvalue = -1; // '初始化findPos的值，如果不改变，返回的就是-1

		iBeg = InStr(beginPos, inString, eleName);
		if (iBeg <= 0) {
			return ""; // '返回空字符串代表没有找到这个元素
		}

		leftPos = InStr(iBeg, inString, "("); // '得到左面括号的位置
		if (leftPos <= 0) {
			return ""; // '返回空字符串代表没有找到这个元素
		}

		iflag = 0; // '每找到一个(，iflag++,找到一个) iflag --
		for (i = leftPos + 1; i <= Len(inString); i++) {
			s = Mid(inString, i, 1); // '取当前字符串

			if (s==("(") || s==("")
					&& Mid(inString, i - 1, 1)==("~")) { // '如果是()，需要判断上个字符是否是~,如果是不操作
				continue;
			}

			if (s==("(")) {
				iflag = iflag + 1;
				continue; // '继续进行循环
			}

			if (s==(")")) { // '当前值为)时需要判断iflag的值
				if (iflag == 0) { // 'iflag=0，可以结束循环
					var s1:String = Mid(inString, leftPos, i - leftPos + 1);
					findPos.intvalue = leftPos; // '找到的位置是leftPos
					return s1;
				} else {
					iflag = iflag - 1; // '否则将iflag减去1
				}
			}
		}

		return "";
	}

	// '从元素表示的字符串里面，用括号包括起来的
	// '取出指定的属性的实际属性值
	// '如果找不到，则返回一个空字符串
	// 'retFlag是一个标志字符串，返回0代表找到了，返回-1代表没有这个指定名称的参数
	// 'eleString 只读
	// 'paraName 只读（大小写敏感）
	// 'begPos 开始查找点
	// 'defValue 找不到时候的默认值
	// 'retFlag 输出参数0代表成功结束-1代表失败
	// 'sep 结束的分割符号，遇到此符号代表结束

	private function getElementProp( eleString:String,  paraName:String,
			 begPos:int,  defValue:String,  retFlag:MyInt,  sep:String):String {
		var iBeg:int = 0;
		var iEnd:int = 0;
		var ipos:int = 0;
		var i:int = 0;
		var iflag:int = 0;
		var s:String = "";
		var svalue:String = "";

		retFlag.intvalue = -1;
		ipos = InStr(begPos, eleString, paraName + "=");// '找到属性名称的开始点
		if (ipos <= 0) {// '找不到，退出
			return defValue;// '返回默认值
		}

		iBeg = ipos + Len(paraName + "=");// 'iBeg代表值的开始点
		iflag = 0;
		for (i = iBeg; i <= Len(eleString); i++) {
			s = Mid(eleString, i, 1);

			if (s==("\"")) {// '如果当前字符串是引号，那么设置标志
				if (iflag == 0) {
					iflag = 1;
				} else {
					iflag = 0;
				}
				continue;
			}

			if (s==(sep)) {// '如果s是结束符号，需要根据iFlag来判断
				if (iflag == 0) {// '如果不在字符串内，那么就退出
					svalue = Mid(eleString, iBeg, i - iBeg);
					svalue = removeQuote(svalue);// '去掉开头和结尾的引号
					retFlag.intvalue = 0;// '标志成功结束
					return svalue;// '退出此功能
				}
			}

		}

		return defValue;// '返回默认值
	}

	// '功能描述：将输入的字符串切分成包含多个实际元素的array对象
	// '只获取其中的指定类型对象
	private function getAllElement( inString:String,  eletype:String):Array {
		var myarray:Array = new Array();
		var stext:String = "";
		var ipos :MyInt= new MyInt(0);

		// '分解dwString，将其中的元素取出，描述放入myarray中去

		stext = getElementDesc(inString, eletype + "(", 1, ipos);
		while (ipos.intvalue > 0) {
			myarray.add(stext); // '容器内加入sText
			stext = getElementDesc(inString, eletype + "(", ipos.intvalue + 1,
					ipos);
		}

		return myarray;
	}

	// '功能描述：从DW定义中，分解得到数据库检索用的Select语句
	// '为下一步执行SQL操作打下基础
	// '这个SQL语句可能会带有参数
	public function GetRetrieveSQL():String {

		var id :int= 0;
		var select_tablelist:String = "";// 'tabel 子句
		var select_columnlist:String = "";// 'column 子句
		var select_join :String= "";// 'join 条件子句
		var select_where :String= "";// 'where子句
		var select_orderby:String = "";// As String 'order by子句

		select_tablelist = "";
		for (id = 1; id <= 10; id++) {
			if (local_webdw.table.retrieve.pbselect.table[id]==("")) {
				break;
			}

			if (select_tablelist==("")) {
				select_tablelist = local_webdw.table.retrieve.pbselect.table[id];

			} else {
				select_tablelist = select_tablelist + ","
						+ local_webdw.table.retrieve.pbselect.table[id];// '拼装Table子句
			}

		}

		select_columnlist = "";
		for (id = 1; id <= 100; id++) {
			if (local_webdw.table.retrieve.pbselect.column[id]==("")) {
				break;
			}

			if (select_columnlist==("")) {
				select_columnlist = local_webdw.table.retrieve.pbselect.column[id];
			} else {
				select_columnlist = select_columnlist + ","
						+ local_webdw.table.retrieve.pbselect.column[id];
			}
		}

		select_join = "";
		for (id = 1; id <= 10; id++) {
			if (local_webdw.table.retrieve.pbselect.join[id].join_left
					==("")) {
				break;
			}

			if (select_join==("")) {
				select_join = "("
						+ local_webdw.table.retrieve.pbselect.join[id].join_left
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_op
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_right
						+ ")";
			} else {
				select_join = select_join
						+ " AND "
						+ "("
						+ local_webdw.table.retrieve.pbselect.join[id].join_left
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_op
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_right
						+ ")";
			}
		}

		select_where = select_join;
		for (id = 1; id <= 10; id++) {
			if (local_webdw.table.retrieve.pbselect.where[id].exp1==("")) {
				break;
			}

			if (select_where==("")) {
				select_where = "("
						+ local_webdw.table.retrieve.pbselect.where[id].exp1
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].op
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].exp2
						+ ") "
						+ local_webdw.table.retrieve.pbselect.where[id].logic;
			} else {
				select_where = select_where + " And " + "("
						+ local_webdw.table.retrieve.pbselect.where[id].exp1
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].op
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].exp2
						+ ") "
						+ local_webdw.table.retrieve.pbselect.where[id].logic;
			}
		}

		if (!select_where==("")) {
			select_where = " Where " + select_where;
		}
//	    '增加对order by 子句的支持，20090204
//	    select_orderby = ""
//	    For id = 1 To 10
//	        If local_webdw.table.retrieve.pbselect.order(id).Name = "" Then
//	            Exit For
//	        End If
//	        
//	        If select_orderby = "" Then
//	            If UCase(local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
//	                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
//	            Else
//	                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
//	            End If
//	        Else
//	            If UCase(local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
//	                select_orderby = select_orderby & " , " _
//	                            & local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
//	            Else
//	                select_orderby = select_orderby & " , " _
//	                            & local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
//	            End If
//	        End If
//	    Next

	    //'增加对order by 子句的支持，20090204
	    select_orderby = "";
	    for( id = 1;id<=10;id++){
	        if( local_webdw.table.retrieve.pbselect.order[id].Name==("")) {
	            break;
	        }
	        
	        if( select_orderby==("")){
	            if( UCase(local_webdw.table.retrieve.pbselect.order[id].Asc)==("YES")) {
	                select_orderby = local_webdw.table.retrieve.pbselect.order[id].Name + " ASC ";
	            }else{
	                select_orderby = local_webdw.table.retrieve.pbselect.order[id].Name + " DESC ";
	            }
	        }else{
	            if( UCase(local_webdw.table.retrieve.pbselect.order[id].Asc)==("YES")){
	                select_orderby = select_orderby + " , " 
	                            + local_webdw.table.retrieve.pbselect.order[id].Name + " ASC ";
	            }else{
	                select_orderby = select_orderby + " , " 
	                            + local_webdw.table.retrieve.pbselect.order[id].Name + " DESC ";
	            }
	        }
	    }
//	    If select_orderby > "" Then
//        select_orderby = " Order By " & select_orderby
//    End If

	    if( Len(select_orderby)>0){
	    	select_orderby = " Order By " + select_orderby;
	    }
	    
		var SQL:String = "Select " + select_columnlist + " from "
				+ select_tablelist + select_where+ select_orderby;
		SQL = Replace(SQL, "~\"", "");
		return SQL;
	}

}
}