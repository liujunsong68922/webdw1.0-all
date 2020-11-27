// 'table属性定义
class WebDW_Table {
	
	constructor(){
		
		this.Columns = new Array(101);// WebDW_Table_Column[101]; // '最多100列
	
		this.retrieve = new WebDW_Table_Retrieve(); // '重新定义retrieve参数，定义成一个结构
	
		this.update = "";
		this.updatewhere = "";
		this.updatekeyinplace = "";

		for (var i = 0; i < 101; i++) {
			this.Columns[i] = new WebDW_Table_Column();
		}
	}


	 Clone() {

		var newOne = new WebDW_Table();

		for (var i = 0; i < 101; i++) {
			newOne.Columns[i] = this.Columns[i].Clone();
		}

		newOne.retrieve = this.retrieve.Clone();
		newOne.update = this.update;
		newOne.updatewhere = this.thupdatewhere;
		newOne.updatekeyinplace = this.updatekeyinplace;

		return newOne;
	}
}

// 'table内嵌的column属性定义
class WebDW_Table_Column {
	// Constructor
	constructor(){
		this.type = ""; // '数据类型
		this.update = ""; // '是否可以更新yes/no
		this.updatewhereclause = ""; // '是否是更新时的where条件yes/no
		this.key = ""; // '是否是主键
		this.Name = ""; // '字段名
		this.dbname = ""; // '数据库字段名
		this.values = ""; // '附加值，用来存储编辑风格时的信息
		this.validations = ""; // '编辑的校验字符串
}
	// clone function
	Clone() {

		var newOne = new WebDW_Table_Column();
		newOne.type = this.type; // '数据类型
		newOne.update = this.update; // '是否可以更新yes/no
		newOne.updatewhereclause = this.updatewhereclause; // '是否是更新时的where条件yes/no
		newOne.key = this.key; // '是否是主键
		newOne.Name = this.Name; // '字段名
		newOne.dbname = this.dbname; // '数据库字段名
		newOne.values = this.values; // '附加值，用来存储编辑风格时的信息
		newOne.validations = this.validations; // '编辑的校验字符串

		return newOne;
	}
}

class WebDW_Table_Retrieve {
	// Constructor
	constructor(){
		this. pbselect = new WebDW_Table_Retrive_PBSelect();
	}
	// Clone function
	Clone() {

		var newOne = new WebDW_Table_Retrieve();

		newOne.pbselect = this.pbselect.Clone();

		return newOne;
	}
}

// '表的连接定义
class WebDW_Table_Retrieve_PBSelect_Join {
	// Constructor
	constructor(){
		this. join_left = "";
		this. join_op = "";
		this. join_right = "";
	}

	// Clone function
	  Clone() {

		var newOne = new WebDW_Table_Retrieve_PBSelect_Join();

		newOne.join_left = this.join_left;
		newOne.join_op = this.join_op;
		newOne.join_right = this.join_right;

		return newOne;
	}
}

// '数据表检索的OrderBy条件定义
class WebDW_Table_Retrieve_PBSelect_Order {
	// Constructor
	constructor(){
		this. Name = "";// As this.'排序的列名称
		this. Asc = "";// As this.'是否是升序yes/no
	}
	
	// Clone function
	Clone() {

		var newOne = new WebDW_Table_Retrieve_PBSelect_Order();

		newOne.Name = this.Name;
		newOne.Asc = this.Asc;

		return newOne;
	}
}

// '表检索的where条件定义
class WebDW_Table_Retrieve_PBSelect_Where {
	// Constructor
	constructor(){
		this.exp1 = "";
		this.op = "";
		this.exp2 = "";
		this.logic = "";
	}
	
	// Clone function
	Clone() {

		var newOne = new WebDW_Table_Retrieve_PBSelect_Where();

		newOne.exp1 = this.exp1;
		newOne.op = this.op;
		newOne.exp2 = this.texp2;
		newOne.logic = this.logic;

		return newOne;
	}
}

// 'table的retrieve的pbselect元素属性定义
// '这一部分可能会根据需要来进行后续增加
// '会随着对于DW文件格式的理解深入而扩展
class WebDW_Table_Retrive_PBSelect {
	// Constructor
	constructor(){
	this.version = "";

	this.table = new Array(11);// String[11]; // '表名，最多容许10个表

	this.column = new Array(11);// String[101]; // '列名，最多容许100个列

	this. join = new Array(11);// WebDW_Table_Retrieve_PBSelect_Join[11];//
								// '表连接定义，最多10个连接

	this. where = new Array(11);// WebDW_Table_Retrieve_PBSelect_Where[11]; //
								// 'where条件定义，最多10个where条件

	this. order = new Array(11);// WebDW_Table_Retrieve_PBSelect_Order[11]; //
								// 'order
	// 条件设定,最多10个
		var i;
		for (i = 0; i < 11; i++) {
			this.table[i] = "";
		}
		for (i = 0; i < 101; i++) {
			this.column[i] = "";
		}
		for (i = 0; i < 11; i++) {
			this.join[i] = new WebDW_Table_Retrieve_PBSelect_Join();
		}
		for (i = 0; i < 11; i++) {
			this.where[i] = new WebDW_Table_Retrieve_PBSelect_Where();
		}
		for (i = 0; i < 11; i++) {
			this.order[i] = new WebDW_Table_Retrieve_PBSelect_Order();
		}


	}

	// Clone function
	 Clone() {
		var newOne = new WebDW_Table_Retrive_PBSelect();
		var i;
		for (i = 0; i < 11; i++) {
			newOne.table[i] = this.table[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = this.column[i];
		}
		for (i = 0; i < 11; i++) {
			newOne.join[i] = this.join[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.where[i] = this.where[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.order[i] = this.order[i].Clone();
		}

		return newOne;
	}
}