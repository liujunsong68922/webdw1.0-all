package com.webdw ;

import com.webdw.*;

/**
 * 自己提供的对于int数据类型的封装,用来实现VB的ByRef调用
 * 
 * @author admin
 * 
 */
public class MyInt extends Golbal{
	public void ReadMe(){
		System.out.println("自己提供的对于int数据类型的封装,用来实现VB的ByRef调用");
		System.out.println(JWebDWInfo);
	}
	public int intvalue = 0;

	public MyInt(int i) {
		intvalue = i;
	}
}
