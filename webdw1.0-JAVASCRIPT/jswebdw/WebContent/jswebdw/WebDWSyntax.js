class WebDWSyntax {
	
	constructor(){
		this.ReadMe="WebDW的用户界面文件表示，采用和PB7.0兼容的界面格式定义";
		
		this. datawindow = new WebDW_DataWindow();
	
		this. header = new WebDW_Header();
	
		this. summary = new WebDW_Summary();
	
		this. footer = new WebDW_Footer();
	
		this. detail = new WebDW_Detail();
	
		this. table = new WebDW_Table();
	
		this. text = new Array(101);// WebDW_Text[101];
	
		this. column = new Array(101);// WebDW_Column[101];
	
		this. lineinfo = new Array(101);// WebDW_Line[101];
	
		this. column_dddw_syntax = new Array(101);// new String[101];
	
		this. column_dddw_data = new Array(101);// new String[101];
	
		this. SelectSQL = "";

	/**
	 * 初始化的构造函数
	 * 
	 */

		var i = 0;
		for (i = 0; i < 101; i++) {
			this.text[i] = new WebDW_Text();
		}
		for (i = 0; i < 101; i++) {
			this.column[i] = new WebDW_Column();
		}
		for (i = 0; i < 101; i++) {
			this.lineinfo[i] = new WebDW_Line();
		}
		for (i = 0; i < 101; i++) {
			this.column_dddw_syntax[i] = "";
		}
		for (i = 0; i < 101; i++) {
			this.column_dddw_data[i] = "";
		}
	}
	
	// Clone function
	Clone() {
		var newOne = new WebDWSyntax();

		newOne.datawindow = this.datawindow.Clone();

		newOne.header = this.header.Clone();

		newOne.summary = this.summary.Clone();

		newOne.footer = this.footer.Clone();

		newOne.detail = this.detail.Clone();

		newOne.table = this.table.Clone();
		
		newOne.SelectSQL = this.SelectSQL;
		
		var i = 0;
		for (i = 0; i < 101; i++) {
			newOne.text[i] = this.text[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = this.column[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.lineinfo[i] = this.lineinfo[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_syntax[i] = this.column_dddw_syntax[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_data[i] = this.column_dddw_data[i];
		}
		return newOne;
	}
	
	/**
	 * Warning:Test only,Donot Use This Function in Program!!!
	 * 
	 * @return
	 */
	getColumnNumber(){
		for(var i=1;i<=100;i++){
			if (this.column[i].Name.length()==0){
				return i-1;
			}
		}
		return 100;
	}
}
