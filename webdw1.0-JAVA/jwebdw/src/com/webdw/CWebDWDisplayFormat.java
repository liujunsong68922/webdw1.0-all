package com.webdw;

//Rem -------------------------------------------------
//Rem CWebDWEditMask类是一个掩码类，
//Rem 主要功能是在数据录入时格式化数据输入
//Rem 在数据输出时也同样进行格式化
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDWDisplayFormat extends Golbal{
	public void ReadMe(){
		System.out.println("CWebDWEditMask类是一个掩码类");
		System.out.println(JWebDWInfo);
	}
	// '给定一个输入字符串，加上一个编辑风格的字符串
	// '输出一个已经格式化以后的字符串
	public String GetFormatString(String inString, String sformat,
			long iDataType) {
		return "";
	}

	// '将输入的代表数值的字符串，按照指定格式进行格式化
	// '这一方法用来获得数值型数据的掩码支持
	// '按照PB的规则，
	// '#代表1位数字
	// '0代表1位数字，无对应位时用0补足
	// '.小数点
	// '，带分割符号
	// '算法如下：
	// '以小数点为界，从头开始计算原数值与对应的掩码标志。
	// '如果：原始数据位数 > 掩码位数 那么 取原始位数
	// '如果: 原始数据位数 = 掩码位数，而且掩码为#
	// '如果：原始数据位数 < 掩码位数，而且掩码=0 ，那么返回0
	// '如果：掩码中定义了分割符号（除#,0)以外，那么返回分割符号
	public String GetFormateDecimal(String inString, String sformate) {
		return inString;
		// TODO:需要进行必要的代码迁移，暂时忽略这部分功能
	}

}
