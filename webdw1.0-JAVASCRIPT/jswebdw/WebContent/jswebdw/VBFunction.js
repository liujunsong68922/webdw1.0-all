//将VB的函数定义成公用函数，供其他程序调用，暂时不考虑可能存在的命名冲突问题

/**
 * 这个类定义了许多VB方法的Java实现，避免重复书写代码
 * 
 * @author admin
 * 
 */
class VBFunction {
	//Constructor function
	constructor(){
		this.ReadMe="这个类定义了许多VB方法的Java/JavaScript实现，避免重复书写代码";
	}
}

	/**
	 * 提供与VB函数InStr相同的功能,VB的字符串返回,是从1开始的,所以将返回值加1返回
	 * 返回0代表找不到
	 * @param beginPos,有效位置从1开始
	 * @param string1
	 * @param findString
	 * @return
	 */
function InStr3(beginPos, string1, findString) {
		var ipos;
		if (string1 == null || string1=="") {
			return -1;
		}
		if (beginPos<1){
			beginPos=1;
		}
		ipos = string1.indexOf(findString, beginPos - 1);
		return ipos + 1;
	}

function 	InStr2(string1, findString) {
		return InStr3(0, string1, findString);
	}
	
function 	InStr(beginPos, string1, findString) {
		return InStr3(beginPos, string1, findString);
	}

	/**
	 * 提供与VB函数Len相同的功能
	 * 
	 * @param inStr
	 * @return
	 */
function 	Len(inStr) {
		if (inStr == null) {
			return 0;
		}
		return inStr.length;
	}

	/**
	 * 提供与VB函数Mid相同的功能,VB的字符串计算,下标从1开始.
	 * 
	 * @param str1
	 * @param pos
	 * @param length
	 * @return
	 */
function 	Mid3(str1,  pos,  length) {
		if (length <= 0) {
			return "";
		}
		return str1.substring(pos - 1, pos + length - 1);
	}

function 	Mid2( str1,  pos) {
		return str1.substring(pos - 1);
	}

function 	Mid(str1,  pos,  length) {
		return this.Mid3(str1,  pos,  length);
	}
	/**
	 * 提供与VB函数Left相同的功能,获得左面几个字符的数据
	 * 
	 * @param instr
	 * @param i
	 * @return
	 */
function 	Left(instr, i) {
		if (instr.length >= i) {
			return instr.substring(0, i);
		} else {
			return instr;
		}
	}

	/**
	 * 提供与VB函数Right相同的功能,获得右面几个字符的数据
	 * 
	 * @param instr
	 * @param i
	 * @return
	 */
function 	Right( instr,  i) {
		return instr.substring(instr.length - i);
	}

	// 得到指定Asc码对应的字符串
function 	Chr(i) {
		if (i == 9)
			return "\t";
		if (i == 13)
			return "\r";
		if (i == 10)
			return "\n";
		return "";
	}

	/**
	 * 将字符串转换成整数
	 * 
	 * @param s
	 * @return
	 */
	function 	toInt(s) {
		try {
			return parseInt(s);
		} catch ( e) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			return 0;
		}
	}

	/**
	 * 将字符串转换成数值
	 * 
	 * @param s
	 * @return
	 */
	function 	toDouble( s) {
		try {
			return parseFloat(s);
		} catch ( e) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			return 0;
		}
	}

	function 	UCase(inStr) {
		return inStr.toUpperCase();
	}

	function 	Split( inStr1,  sepStr) {
		// return inStr.split(sepStr);
		var arraynum = 0;
		var data = new Array(1000);
		var i = 0;
		var tempi = 0;
		tempi = InStr3(i, inStr1, sepStr);
		while (tempi > 0) {
			if (i == 0) {
				// 第一个元素,从1开始计算
				data[arraynum] = Mid(inStr1, 1, tempi - i - 1);
			} else {
				data[arraynum] = Mid(inStr1, i + sepStr.length, tempi - i
						- sepStr.length);
			}
			arraynum++;
			i = tempi;
			tempi = InStr(i+1, inStr1, sepStr);
		}
		if (i == 0) {
			data[arraynum] = inStr1;
		} else {
			data[arraynum] = Mid2(inStr1, i + sepStr.length);
		}
		arraynum++;
		var newdata = new Array(arraynum);
		for (i = 0; i < arraynum; i++) {
			newdata[i] = data[i];
		}
		return newdata;
	}

	/**
	 * 得到数组的最大下标
	 * 
	 * @param instr
	 * @return
	 */
	function 	UBound(instr) {
		return instr.length - 1;
	}

	/**
	 * 去掉字符串两面的空格
	 * 
	 * @param inStr
	 * @return
	 */
	function 	Trim(inStr) {
		return inStr.replace(/(^\s*)|(\s*$)/g,"");
	}



	/**
	 * 得到当前时间的表示
	 * 
	 * @return
	 */
	function 	Now() {
		return new Date().toString();
	}

	function 	RGB( r,  g,  b) {
		return r * 256 * 256 + g * 256 + b;
	}

	function 	Asc( s) {
		if (s == null) {
			s = " ";
		}
		if (s.length == 0) {
			s = " ";
		}
		return s.charAt(0);
	}

	/**
	 * 判断S1 > S2
	 * 
	 * @param s1
	 * @param s2
	 * @return
	 */
	function 	IsGreat( s1,  s2) {
		if (s1.length > 0 && s2.length > 0) {
			if (s1.charAt(0) > s2.charAt(0)) {
				return true;
			}
			if (s1.charAt(0) < s2.charAt(0)) {
				return false;
			}
			s1 = s1.substring(1);
			s2 = s2.substring(1);
			return IsGreat(s1, s2);
		}

		if (s1.length > 0 && s2.length == 0) {
			return true;
		}

		if (s1.length == 0 && s2.length > 0) {
			return false;
		}
		return true;
	}

	function 	IsNumeric(s1) {
		try {
			var d = parseFloat(s1);
			return true;
		} catch ( e) {
			return false;
		}
	}

	function 	Rnd(d) {
		return Math.random() * d;
	}
	
	//弹出一个类似VB的Windows标准对话框
//	static JFrame f1 = new JFrame();
//	static MessageJDialog d1 = null;
	function 	MessageBox2( title, info){
	
	}
	
	function 	MessageBox(sinfo){
		MessageBox("JWebDW0.3",sinfo);
	}

	function 	MsgBox3(stext, iButton, title){
		MessageBox2(title,stext);
	}
	
	/**
	 * 替换字符串中的内容
	 * 
	 * @param instr
	 * @param str1
	 * @param str2
	 * @return
	 */
	function 	Replace(instr, str1, str2) {
			var dataarray = Split(instr,str1);//调用自己定义的Split方法
			console.log(dataarray.length);
			var id = 0;
			var sret ="";
			for(id=0;id<dataarray.length;id++){
				if(sret==""){
					sret = dataarray[id];
				}else{
					sret = sret + str2 + dataarray[id];
					console.log("id "+ id+" :"+ sret);
				}
			}
			return sret;

		//return instr.split(str1).join(str2);
	}


