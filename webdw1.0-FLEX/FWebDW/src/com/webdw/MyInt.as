package com.webdw
{
/**
 * 自己提供的对于int数据类型的封装,用来实现VB的ByRef调用
 * 
 * @author admin
 * 
 */
public class MyInt extends Golbal{
//	public function ReadMe():void{
//		trace("自己提供的对于int数据类型的封装,用来实现VB的ByRef调用");
//		trace(JWebDWInfo);
//	}
	public var intvalue:int = 0;

	public function MyInt( i:int) {
		intvalue = i;
	}
}
}