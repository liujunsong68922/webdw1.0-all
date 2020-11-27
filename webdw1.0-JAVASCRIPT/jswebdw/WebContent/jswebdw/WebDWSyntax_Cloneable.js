/**
 * This class is designed to support field clone function. It is designed only
 * used in WebDWSyntax class and its subclass.
 * Author: Mr.Liu Junsong
 * E_main:liujunsong@aliyun.com
 * Date:2018/12/1
 */
class WebDWSyntax_Cloneable{
	/**
	 * empty constructor
	 */
	constructor(){
		this._testonlyvariable ="THIS IS THE TEST VALUE ONLY.";
	}
	
	/**
	 * give the field name ,return field value (maybe undefined) through call
	 * the eval function. This is truly a dangerous command.
	 */
	getFieldValue(field){
		var retValue = eval("this."+field);

		return retValue;
	}
	/**
	 * set the value to the field,if the field donot exist,then js will create
	 * it automatically.
	 */
	setFieldValue(field,value){
		var valuetype = typeof(value);
		
		switch (valuetype)
		{
			case "number": eval("this."+field+" = "+value );break;
			case "boolean": eval("this."+field+" = "+value);break;
			// Warning: the string value cannot contains "'" at some time, or it
			// will fail.There are some problem in this method
			// so this function only can be used in limit condition.
			// NEVER USE IT in large scale.
			case "string": eval("this."+field+" = '"+value+"'" );break;
			case "object": break;
			case "function": break;
			case "undefined": break;
		}
	}
	

	/**
	 * clone field's value ,according the fields array,which contains all field
	 * name srcObj: the source object tarObj: the target object fields: the
	 * field name array
	 */
	F_Clone(srcObj,tarObj,fields){
		for(var i=0;i<fields.length;i++){
			// get the field value from source object
			var fieldValue = srcObj.getFieldValue(fields[i]);
			// clone this value to target object
			tarObj.setFieldValue(fields[i],fieldValue);
			
		}
		
	}
}