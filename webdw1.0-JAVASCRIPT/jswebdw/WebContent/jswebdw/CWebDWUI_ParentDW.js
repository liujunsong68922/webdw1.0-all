//Rem -------------------------------------------------
//Rem WebDW用户界面解析器，VB功能类
//Rem 这个类有两个子类
//Rem CWebDWUI 和 CWebDWChildDW
//Rem 主要功能：将一个字符串描述转换成相应的图形界面
//Rem 图形界面和字符串的描述，两者在逻辑上是完全等价的
//Rem 这个功能类似于浏览器的图形解释器,把HTML语言翻译成一个图形化界面
//Rem 其中包括文本,图形等多种元素(一开始可能只有文本)
//Rem 通过一定的技术把界面和数据库可以关联起来
//Rem 第一版本的界面解析器，格式严格按照PB7的数据窗口字符串格式来获取
//Rem 所有以DW_开头的方法，提供和PB Datawindow控件类似的功能和调用接口
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

class CWebDWUI_ParentDW{
	// constructor function
	constructor(){
		this.ReadMe = "WebDW用户界面解析器";
		
		this.errString = "";// '返回的错误信息字符串

		this.controlSeg = 0;// '相当于一个控件的序列，每增加一个自动加一

		this.myControls = new Array(10001);// JComponent[10001];//
											// 'myControls代表界面上自动创建的控件的集合

		// '上述控件的实际物理地址在form上，
		// '这里存放的只是一个控件对象的指针
		// '-------------------------------本地组合类定义------------------------------------------------------
		this.webdw = null;// '定义webdw对应的文件读取类

		this.webdwData = null;// '定义webdw的数据对象类

		this.sqlca = null;// '事务支持？SQL访问支持对象

		this.childDW = null;// '子数据窗口的类定义

		this.displayformate = null;// '数据显示格式化

		this.gridLineColor = 0;// '表格线的颜色定义

		// '------------下面的定义是界面上的对应元素定义，这个定义在setdataobject中设置
		this.targetControls;// 

		// '这个容器，表示所有的控件集合容器对象,在SetDataObject中初始化设置,20090116日添加
		this.targetPict;// '这个代表要进行绘制的PictureBox,20090116日添加

		this.VScroll_Page;// '表示一页内变化的VScrollBar,最大翻动到一页

		this.VScroll_Line;// '表示行变化的VScrollBar,一次最少翻动一行

		this.HScroll_Page;// '表示页面左右翻动的HscrollBar，一次翻动半页

		// Dim ImagePoint As Image '指示当前行用的图标,可以用底色图片来表示当前行
		this.childPict;// '子数据窗口绘制用的窗口

		// '------------界面元素的定义完毕

		// '------------下面的定义是界面上的动态元素对应的事件处理器定义
		// Private WithEvents myTextBox As TextBox
		// 'myTextBox是一个虚拟的文本框，用来定义文本框事件响应
		// Private WithEvents myOptionButton As OptionButton
		// 'myOptionButton是一个虚拟的选择按钮，定义选择按钮响应
		// Private WithEvents myCheckBox As checkbox
		// 'myCheckBox是一个虚拟的检查框，定义选择按钮响应
		// Private WithEvents myComboBox As combobox 'myComboBox是一个虚拟的下拉框，定义响应事件
		// '------------界面动态元素定义完毕
		this.currentRow = 0;// '界面当前行定义

		this.local_webdw = null;// 'local_webdw现在是一个局部变量了，而不是全局变量了

		this.langsupport = null;// '多语言支持对象定义

		this.autoCommit = false;// '自动事务支持的标志位true 自动 false 手工

		this.iret = new MyInt(0);//

		/** *****************下面是子数据窗口专用的变量 */
		this.parentControlName = "";// '父数据窗口的控件名称

		this.dataColumnName = "";// '数据列名称

		this.parentDW = null;// '设置父数据窗口的句柄

		// '初始化时设置controlSeg值
		this.controlSeg = 0;
		this.webdw = new CWebDW();// '设置webdw的语法对象
		this.webdwData = new CWebDWData();// '设置webdw的数据对象
		this.sqlca = new CWebDWTransaction();// '事务管理对象
		// gridLineColor = QBColor(8);// '默认为灰色线条
		this.langsupport = new CMultiLang();// '多语言支持对象类定义
		this.displayformate = new CWebDWDisplayFormat();// '数据显示格式化对象

		this.autoCommit = false;// '默认为非自动事务，需要手工启动事务并提交

		this.Golbal = golbal;
		// initAllObjectPoint();
	}
	


	// '功能描述：设置local_webdw的值
	// '输入：gg_webdw
	// '输出：local_webdw
	SetLocalWebDW() {
		this.local_webdw = this.Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取local_webdw的值
	// '输入:local_webdw
	// '输出:gg_webdw
	GetLocalWebDW() {
		this.Golbal.GG_webdw = this.local_webdw.Clone();
	}

	// '关闭当前的数据窗口
	CloseDW() {
		if (targetPict != null) {// Is Nothing Then
			targetPict.setVisible(False);
		}

		if (VScroll_Page != null) {// Is Nothing Then
			VScroll_Page.setVisible(False);
		}

		if (HScroll_Page != null) {// Then
			HScroll_Page.setVisible(False);
		}

		if (VScroll_Line != null) {// Is Nothing Then
			VScroll_Line.setVisible(False);
		}
		return 0;

	}

	// '调用子数据窗口的刷新方法
	DrawChildDW() {
		if (!(childDW == null)) {
			childDW.DrawDW();
		}
		return 0;
	}

// DrawColumn( lineNum) {
// return DrawColumn(lineNum, 0);
// }

	// '画文本框的方法
	// 'lineNum 行号，从1开始，文本框只在detail区域绘制，不考虑其他区域
	// 'leftpos 左偏移量，对象向左偏移leftpos<0
	DrawColumn( lineNum, leftPos) {

		var id = 0;
		var sname = "";
		var obj = null;
		var top = 0;
		var iborder = 0;
		var svalue = "";
		var stf = new MyFont();// 字体支持
		var beginRowid = 0;
		var convertRate = 4;
		var rowstate = "";

		// beginRowid = VScroll_Line.getValue() + 1;
		beginRowid = 1;
		
		convertRate = GF_GetConvertRate(this.targetControls);
		rowstate = this.webdwData.GetRowState(lineNum, this.iret);
		console.log("rowstate:"+rowstate);
		if (this.iret.intvalue == -1) {// Then
			console.log("iret is -1");
			console.log(this.webdwData.errString);
			return -1;
		}

		for (id = 1; id <= 100; id++) {
			if (this.local_webdw.column[id].Name==("")) {// '列名为空，退出本列的执行，继续循环
				continue;
			}

			if (lineNum == 0) {// '控件不可在头部绘制，跳出循环
				continue;
			}

			// '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
			top = (this.local_webdw.column[id].y * convertRate)
					+ (this.local_webdw.header.height * convertRate)
					+ (this.local_webdw.detail.height * convertRate)
					* (lineNum - beginRowid);

			// if (top <= 0 || top > this.targetPict.getHeight()) {
			// continue;
			// }

			// if (top >= 0 && top <= this.local_webdw.header.height *
			// convertRate
			// && !(this.local_webdw.column[id].band==("header"))) {
			// continue;
			// }

			// '判断对象的偏移，看是否要创建
// if (((this.local_webdw.column[id].x + this.local_webdw.column[id].width)
// * convertRate + leftPos < 0)
// || (this.local_webdw.column[id].x * convertRate + leftPos >
// targetPict.Width)) {
// continue;
// }

			sname = this.targetPict.getAttribute("name") + "__" + lineNum + "__"
					+ this.local_webdw.column[id].Name;

			svalue = this.webdwData.GetItemString(lineNum, id);// '得到原始信息数据
			console.log("svalue="+svalue);
			console.log("sname="+sname);
			// 根据是否是子窗口来判断
			if (InStr(this.targetPict.getAttribute("name"), "PictureChild") <= 0) {
				obj = new WebDW_DymaTextField("", sname, this.targetControls,
						this.targetPict);
			} else {
				obj = new ChildDW_DymaTextField("", sname, this.targetControls,
						this.targetPict);

			}

			this.controlSeg = this.controlSeg + 1;
			this.myControls[this.controlSeg] = obj;

			iborder = GF_IF_Long( this.local_webdw.column[id].border > 0,
					1, 0);// '是否有边框

			// log("left:" + ((this.local_webdw.column[id].x * convertRate +
			// leftPos))
			// + " top:" + top + " width:"
			// + (this.local_webdw.column[id].width * convertRate) + " height:"
			// + (this.local_webdw.column[id].height * convertRate));
			obj.setBounds(
					 ((this.local_webdw.column[id].x * convertRate + leftPos)),
					 (top),
					 (this.local_webdw.column[id].width * convertRate),
					 (this.local_webdw.column[id].height * convertRate));
// if (iborder > 0) {
// obj.setBorder(BorderFactory.createEtchedBorder());
// } else {
// obj.setBorder(null);
// }

// obj
// .setHorizontalAlignment(GF_GetAlignType(this.local_webdw.column[id].alignment));
			// TODO:数据格式化的工作待完成
			// If this.local_webdw.column[id].format <> "[general]" And
			// IsNumeric(svalue) Then
			// .text = displayformate.GetFormateDecimal(svalue,
			// this.local_webdw.column[id].format) '显示当前数据的未格式化内容
			// End If

			// TODO: JLabel的背景色似乎不能设置
			if (this.local_webdw.column[id].background_mode == 2) {// Then
				// '不是透明显示模式，取标签颜色
				// Color c1 = GF_GetJavaColor( GF_GetVBColor(
				// this.local_webdw.column[id].background_color,
				// 256 * 256 * 256 - 1));
				// obj.setBackground(c1);
// System.out.println(obj.getBackground().getRed());
// System.out.println(obj.getBackground().getGreen());
// System.out.println(obj.getBackground().getBlue());
// obj.validate();
// obj.repaint();
			} else {
				// obj.setOpaque(true);
			}
			// TODO:前景色目前也不生效，以后再详细调试
			// Color c2 = GF_GetJavaColor( GF_GetVBColor(
			// this.local_webdw.column[id].color, 256 * 256 * 256 - 1));
			// obj.setForeground(c2);

			// '增加对字体的支持
// stf.Bold(this.local_webdw.column[id].font.weight > 500);
// stf.Italic(this.local_webdw.column[id].font.italic > 0);
// stf.Name(this.local_webdw.column[id].font.face);
// stf.Size( (this.local_webdw.column[id].font.height * -1
// * convertRate / 0.15));
//
// obj.setFont(stf.stf);
			obj.setText(svalue);

// if ((this.local_webdw.column[id].tabsequence == 32766)
// && (!rowstate==("new"))) {
// obj.Locked(true);
// }
// obj.setVisible(true);

			// 'Add by Liujunsong 2009-1-23 增加对Edit Style的支持
			// '如果这一列指定了显示格式，那么在界面上将数据进行格式化输出
			// '如果这一列指定需要将编码转换成名称，那么就在显示时进行转换
			// '先考虑增加列表转换的支持

			// '增加单选按钮的支持20090123
			// Dim valuestring As String
			var valuestring = "";
			valuestring = this.local_webdw.table.Columns[id].values;// '得到values表示

			// valuestring = this.local_webdw.table.Columns(id).values
			// '得到values表示
			//	        
			// '--------------------------单选框编辑风格支持开始-----------------------------
			var radioobj;
			var frameObj;
			var bg;
			var value=new Array();
			var radioid = 0;
			var radioValue = "";
			var radioDisplay = "";
			var tabpos;
			// If valuestring > "" And _
			// this.local_webdw.column[id].radiobuttons.Columns > 0 Then
			// '是单选按钮编辑风格
			// '如果是单选钮风格，需要先创建一个包含它的容器出来
			if (valuestring.length > 0
					&& this.local_webdw.column[id].radiobuttons.Columns > 0) {
				sname = targetPict.getName() + "__" + lineNum + "__"
						+ this.local_webdw.column[id].Name + "__" + "Frame";
				// Set frameObj = targetControls.Add("VB.Frame", sname,
				// targetPict)
				frameObj = new MyJPanel(sname, targetControls, targetPict);

				controlSeg = controlSeg + 1;
				myControls[controlSeg] = frameObj;
				frameObj.setBounds(obj.getX(), obj.getY(), obj.getWidth()
						- (10 * convertRate), obj.getHeight());

				frameObj.setBackground(obj.getBackground());
				frameObj.setVisible(true);
				obj.setVisible(false);

				bg = new ButtonGroup();
				//	                
				// '然后再在这个容器的基础上来创建选择按钮
				value = Split(valuestring, "/");
				for (radioid = 0; radioid <= UBound(value); radioid++) {
					if (value[radioid].length == 0) {
						break;
					}

					tabpos = InStr(1, value[radioid], Chr(9));// 'value中Tab键的位置
					if (tabpos > 0) {
						radioDisplay = Left(value[radioid], tabpos - 1);
						radioValue = Mid(value[radioid], tabpos + 1,
								Len(value[radioid]) - tabpos);
					} else {
						radioDisplay = "";
						radioValue = "";
						break;// '数据格式错误，跳过这个列的显示
					}
					//	                    
					sname = targetPict.Name + "__" + lineNum + "__"
							+ this.local_webdw.column[id].Name + "__" + radioValue;

					radioobj = new WebDW_DymaRadioButton(radioDisplay, sname,
							targetControls, frameObj);
					bg.add(radioobj);

					radioobj.Tag = radioValue;// '把对应值放在tag属性里面
					radioobj.setBounds( (10 * convertRate),
							((30 + 60 * radioid) * convertRate),
							(obj.getWidth() - 40 * convertRate),
							(50 * convertRate));
					radioobj.setBackground(obj.getBackground());
					radioobj.setForeground(obj.getForeground());
					radioobj.setVisible(true);
					// '根据当前字段的数据，与radioobj代表的数据比较，如果相同，就设置选中状态
					radioobj.Value(radioValue==(svalue));
					//	                    
					// '增加对tabsequence的支持20090206
					if ((this.local_webdw.column[id].tabsequence == 32766)
							&& !(rowstate==("new"))) {
						radioobj.Enabled(false);
					}
				}
			}
			// '------------------------单选框编辑风格结束----------------------------------------
			//	        
			// '------------------------选择框编辑风格开始----------------------------------------
			// Dim myCheckBox As checkbox
			var myCheckBox;
			if (valuestring.length > 0
					&& this.local_webdw.column[id].checkbox.text.length > 0) {
				sname = targetPict.Name + "__" + lineNum + "__"
						+ this.local_webdw.column[id].Name + "__CheckBox";

				// '对象名之所以重新定义一个，是因为和obj重名了
				myCheckBox = new WebDW_DymaCheckBox(
						local_webdw.column[id].checkbox.text, sname,
						targetControls, targetPict);
				controlSeg = controlSeg + 1;
				myControls[controlSeg] = myCheckBox;// '存储对于控件的指针
				//	            
				myCheckBox.Top(obj.Top);
				myCheckBox.Left(obj.Left);
				myCheckBox.Width(obj.Width);
				myCheckBox.Height(obj.Height);

				myCheckBox.Value(GF_IF_Long(this.local_webdw.column[id].checkbox.on
						==(svalue), 1, 0) == 1);

				myCheckBox.setBackground(obj.getBackground());
				myCheckBox.setForeground(obj.getForeground());
				// '增加对tabsequence的支持

				if ((this.local_webdw.column[id].tabsequence == 32766)
						&& !(rowstate==("new"))) {
					myCheckBox.Enabled(false);
				}
				obj.setVisible(false);
			}
			// '------------------------选择框编辑风格结束----------------------------------------
			//	        
			// '------------------------下拉列表框编辑风格结束----------------------------------------

			var myComboBox;
			var combovalues = new Array(1);
			var combostring;
			var combotabpos;
			var combo_display;
			var combo_value;
			var combo_id;

			if ((valuestring.length > 0 && (this.local_webdw.column[id].combobox.allowedit
					.length > 0))) {
				sname = targetPict.Name + "__" + lineNum + "__"
						+ this.local_webdw.column[id].Name + "__ComboBox";
				myComboBox = new WebDW_DymaComboBox(sname, targetControls,
						targetPict);
				controlSeg = controlSeg + 1;
				myControls[controlSeg] = myComboBox;
				myComboBox.Left(obj.Left);
				myComboBox.Top(obj.Top);
				myComboBox.Width(obj.Width);
				myComboBox.Height(obj.Height);
				myComboBox.setBackground(obj.getBackground());
				myComboBox.setForeground(obj.getForeground());

				combovalues = Split(valuestring, "/");
				for (combo_id = 0; combo_id <= UBound(combovalues); combo_id++) {
					if (combovalues[combo_id]==("")) {
						break;// Exit For
					}

					combotabpos = InStr(1, combovalues[combo_id], Chr(9));
					if (combotabpos > 0) {
						combo_display = Mid(combovalues[combo_id], 1,
								combotabpos - 1);
						combo_value = Mid(combovalues[combo_id],
								combotabpos + 1);
						myComboBox.addItem(combo_display);// combo_id
						if (combo_value==(svalue)) {// = svalue Then
							// '如果数值相同，则设置ListIndex
							myComboBox.setSelectedItem(combo_display);

						}
					}

				}
				// '增加对tabsequence的支持20090206
				if ((this.local_webdw.column[id].tabsequence == 32766)
						&& !(rowstate==("new"))) {
					myComboBox.Enabled(false);
				}
				obj.setVisible(false);
			}

			// '------------------------下拉列表框编辑风格结束----------------------------------------
			//	        
			// '------------------------下拉数据窗口编辑风格的支持------------------------------------

			if (this.local_webdw.column[id].dddw.Name.length > 0
					&& this.local_webdw.column[id].dddw.DataColumn.length > 0
					&& this.local_webdw.column[id].dddw.DisplayColumn.length > 0
					&& this.local_webdw.column_dddw_syntax[id].length > 0
					&& this.local_webdw.column_dddw_data[id].length > 0) {
				// '在下拉数据窗口中，按照制定的列进行检索，如果找到此值，设置其界面显示
				childDW.DW_SetDataObject(targetControls, childPict, targetPict,
						local_webdw.column_dddw_syntax[id], false, true);
				childDW.webdwData.InitData(this.local_webdw.column_dddw_data[id]);
				var rowid;
				var sourcecolid;
				var displayColId;
				sourcecolid = childDW.webdwData
						.GetColIdByName(this.local_webdw.column[id].dddw.DataColumn);
				displayColId = childDW.webdwData
						.GetColIdByName(this.local_webdw.column[id].dddw.DisplayColumn);
				if (sourcecolid > 0 && displayColId > 0) {
					for (rowid = 1; rowid <= childDW.DW_RowCount(); rowid++) {
						if (childDW.webdwData.GetItemString(rowid, sourcecolid)
								==(svalue)) {
							obj.Text(childDW.webdwData.GetItemString(rowid,
									displayColId));
							break;
						}
					}
				}

				// '如果子窗口的下拉滚动条出现，设为不可见(这是一个临时性的措施，以后再调整)
				if (childDW != null) {// Is Nothing Then
					childDW.CloseDW();
				}
			}

			// End If
			// '------------------------下拉数据窗口编辑风格的支持结束---------------------------------

			// continueNext:
		}
		return 0;
	}

// DrawLabel( lineNum) {
// return DrawLabel(lineNum, 0);
// }

	// '画标签的方法
	// 'targetControls 目标窗体或者用户控件的控件集合
	// 'pictTarget 目标图片框
	// 'lineNum 行号0代表绘制表头，其他代表具体的行号
	// 'leftpos 所有元素的左偏移量 leftpos <=0
	// '图形数据来源: g_webdw
	DrawLabel( lineNum, leftPos) {
		console.log("drawlabel");
		var id = 0;
		var sname = "";
		var obj = null;
		var top = 0;
		var beginRowid = 0;
		var convertRate = 0;

		// beginRowid = VScroll_Line.getValue() + 1;
		beginRowid = 1;
		convertRate = GF_GetConvertRate(this.targetControls);

		for (id = 1; id <= 100; id++) {
			if (this.local_webdw.text[id].Name==("")) {
				console.log("draw label:exit 1")
				return 0;
			}

			if (lineNum == 0 && (!this.local_webdw.text[id].band==("header"))) {// '绘制头部，band不为header,退出
				console.log("continue 1")
				continue;
			}

			if (lineNum > 0 && (!this.local_webdw.text[id].band==("detail"))) {// '绘制细节，band不为detail,退出
				console.log("continue 2")
				continue;
			}

			// '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
			if (this.local_webdw.text[id].band==("header")) {
				top = (this.local_webdw.text[id].y * convertRate);
			}
			if (this.local_webdw.text[id].band==("detail")) {
				top = (this.local_webdw.text[id].y * convertRate)
						+ (this.local_webdw.header.height * convertRate)
						+ (this.local_webdw.detail.height * convertRate)
						* (lineNum - beginRowid);
			}
			console.log("top="+top);
			// '根据top值进行判断，如果这个值超过了targetPict的范围，就跳出本次循环
// if (top <= 0 || top > targetPict.getHeight()) {
// continue;
// }

// if (top >= 0 && top <= this.local_webdw.header.height * convertRate
// && (!local_webdw.text[id].band==("header"))) {
// continue;
// }

			// '为了避免创建无效的控件，仅创建在当前界面可见范围内的控件出来
			// '行号的判断在DrawDW中进行
			// '此处仅判断width是否超标

// if ((this.local_webdw.text[id].x + this.local_webdw.text[id].width)
// * convertRate + leftPos < 0
// || (this.local_webdw.text[id].x * convertRate + leftPos) > targetPict
// .getWidth()) {
// continue;
// }

			sname = this.targetPict.getAttribute("name") + "_" + lineNum + "_"
					+ this.local_webdw.text[id].Name;
			// '创建控件
			obj = new MyJLabel("", sname, this.targetControls, this.targetPict);
			console.log("create new MyJLabel object. name='"+sname+"'");
			this.controlSeg = this.controlSeg + 1;
			this.myControls[this.controlSeg] = obj;// '存储对于控件的引用
			obj.setBounds(
					((this.local_webdw.text[id].x) * convertRate + leftPos),
					(top),
					(this.local_webdw.text[id].width * convertRate),
					(this.local_webdw.text[id].height * convertRate));
			// obj.setBorder(null);
			// obj.setHorizontalAlignment(GF_GetAlignType(this.local_webdw.text[id].alignment));

			// '增加对颜色的支持20081219日添加
			// obj.setOpaque(false);
			// TODO: JLabel的背景色似乎不能设置
			if (this.local_webdw.text[id].background_mode == 2) {// Then
				// '不是透明显示模式，取标签颜色
				// Color c1 = GF_GetJavaColor( GF_GetVBColor(
				// this.local_webdw.text[id].background_color,
				// 256 * 256 * 256 - 1));
				// obj.setBackground(c1);
				// System.out.println(obj.getBackground().getRed());
				// System.out.println(obj.getBackground().getGreen());
				// System.out.println(obj.getBackground().getBlue());
			// obj.validate();
			// obj.repaint();
			} else {
			// obj.setOpaque(true);
			}
			// TODO:前景色目前也不生效，以后再详细调试
			// Color c2 = GF_GetJavaColor( GF_GetVBColor(
			// this.local_webdw.text[id].color, 256 * 256 * 256 - 1));
			// obj.setForeground(c2);

			// '增加对字体的支持20081219日添加
// var stf = new MyFont();
// stf.Bold(this.local_webdw.text[id].font.weight > 500);
// stf.Italic(this.local_webdw.text[id].font.italic > 0);
// stf.Name(this.local_webdw.text[id].font.face);
// stf
// .Size( (this.local_webdw.text[id].font.height * -1
// * convertRate / 0.18));
// obj.setFont(stf.stf);

			// 设置内容,将标签定义中的\r\n转成<BR>以回车显示
			// 这种换行的方式不是很舒服,暂时先这么处理一下了
			obj.setText(Replace(this.local_webdw.text[id].text, "\r\n", "<BR>")
					);
			// obj.setVisible(true);
		}
		return 0;
	}

// DrawLine( lineNum) {
// return DrawLine(lineNum, 0);
// }

	// '在界面上画线的方法
	// '通过这个方法支持在界面上进行画线
	// 'leftpos 左偏移量 leftpos<=0
	DrawLine( lineNum, leftPos) {
		var id = 0;// As Long
		var sname = "";// As String
		// Dim obj As Control
		// Dim top As Long
		// Dim beginRowid As Long
		// Dim convertRate As Double
		//	    
		// beginRowid = VScroll_Line.value + 1
		// convertRate = GF_GetConvertRate(this.targetControls)
		//	    
		// For id = 1 To 100
		// If this.local_webdw.lineinfo(id).Name = "" Then
		// DrawLine = 0
		// Exit Function
		// End If
		//	        
		// If lineNum = 0 And this.local_webdw.lineinfo(id).band <> "header"
		// Then
		// '绘制头部，band不为header,退出
		// GoTo continueNext
		// End If
		//	        
		// If lineNum > 0 And this.local_webdw.lineinfo(id).band <> "detail"
		// Then
		// '绘制细节，band不为detail,退出
		// GoTo continueNext
		// End If
		//	        
		// '先计算标签的top值，以此来判断是否需要继续创建对象并绘制之
		// If this.local_webdw.lineinfo(id).band = "header" Then top =
		// this.local_webdw.lineinfo(id).y1
		// If this.local_webdw.lineinfo(id).band = "detail" Then
		// top = this.local_webdw.lineinfo(id).y1 _
		// + this.local_webdw.header.height _
		// + this.local_webdw.detail.height * (lineNum - beginRowid)
		// End If
		//	                    
		// '根据top值进行判断，如果这个值超过了targetPict的范围，就跳出本次循环
		// If top <= 0 Or top * convertRate > targetPict.height Then
		// GoTo continueNext
		// End If
		//	        
		// If top >= 0 And top <= this.local_webdw.header.height And
		// this.local_webdw.lineinfo(id).band <> "header" Then
		// GoTo continueNext
		// End If
		//	        
		// '根据x1,x2判断是否要划线出来
		// If this.local_webdw.lineinfo(id).x1 * convertRate + leftPos < 0 And _
		// this.local_webdw.lineinfo(id).x2 * convertRate + leftPos < 0 Then
		// GoTo continueNext
		// End If
		//	        
		// If this.local_webdw.lineinfo(id).x1 * convertRate + leftPos >
		// targetPict.width And _
		// this.local_webdw.lineinfo(id).x2 * convertRate + leftPos >
		// targetPict.width Then
		// GoTo continueNext
		// End If
		//	        
		// sname = targetPict.Name & "_" & lineNum _
		// & "_" & this.local_webdw.lineinfo(id).Name
		// controlSeg = controlSeg + 1
		// Set obj = targetControls.Add("VB.Line", sname, targetPict)
		// Set myControls(controlSeg) = obj '存储对于控件的引用
		//	        
		// With obj
		// .y1 = top * convertRate
		// .x1 = this.local_webdw.lineinfo(id).x1 * convertRate + leftPos '加上偏移量
		// .x2 = this.local_webdw.lineinfo(id).x2 * convertRate + leftPos '加上偏移量
		// .y2 = (this.local_webdw.lineinfo(id).y2 + top -
		// this.local_webdw.lineinfo(id).y1) * convertRate
		// End With
		// obj.Visible = True
		//	    
		// continueNext:
		// Next
		//
		// End Function
		return 0;
	}

	DrawGridLine() {
		// TODO:迁移代码实现
		return 0;
	}

	DrawDW_ImageOnly() {
		// TODO:迁移代码实现
		return 0;
	}

	// '绘制DW的方法,begId代表开始绘制的一行.begId>0
	// 'targetControls: 目标控件的集合 输入
	// 'targetPict: 要绘制的目标图片框 输入
	DrawDW() {

		// '先判断是否成功调用了SetDataObject方法
		if (this.targetControls == null || this.targetPict == null){
			// || VScroll_Line == null) {
			// DrawDW = -1
			errString = "Please Call SetDataObject First";
			return -1;
		}

		var rowid = 0;// As Long
		var iret = 0;// As Long
		var i = 0;// As Long
		var childid = 0;// As Long
		var linetop = 0;// As Long
		var beginRowid = 0;// As Long '开始行数
		var convertRate = 1;// As Double '转换比例
		var leftPos = 0;// As Long '左偏移量，根据vscrollbar来计算

		// 'step1 从界面上读取横向滚动条和纵向滚动条
		// beginRowid = VScroll_Line.getValue() + 1;// '开始点是当前的Value+1

		convertRate = GF_GetConvertRate(this.targetControls); // '从界面上得到转换比例
		// leftPos = (HScroll_Page.getValue() * targetPict.getWidth() * -0.5);//
		// '左偏移量
		leftPos = 0;
		
		// 'step2 删除所有控件
		for (i = 10000; i >= 1; i--) {
			if (!(this.myControls[i] == null)) {// '这个判断是一个安全性判断，以避免异常情况发生
				// this.targetControls.remove(this.myControls[i]);
				this.targetControls[i] = null; // 设置当前位置的对象为空对象
				// this.targetPict.remove(this.myControls[i]);
				// this.myControls[i].remove();
				this.myControls[i] = null;
			}
		}
		// this.targetPict.repaint(); // 刷新一下界面,把已经删除的控件从界面上刷掉
		this.controlSeg = 0;// '复位序列对象

		// 'step3绘制表头
		iret = this.DrawLabel(0, leftPos);
		iret = this.DrawColumn(0, leftPos);
		iret = this.DrawLine(0, leftPos);

		// 'step4 重新绘制表体
		console.log("RowCount:"+this.webdwData.GetRowCount());
		beginRowid = 1;
		for (rowid = beginRowid; rowid <= this.webdwData.GetRowCount(); rowid++) {
			linetop = this.local_webdw.header.height + this.local_webdw.detail.height
					* (rowid - beginRowid);
// if (linetop * convertRate > targetPict.getHeight()) {//
// '如果行的开头已经超过了targetPict，停止绘制
// break;
// }
			console.log("rowid="+rowid+"begin draw row");
			console.log("call DrawLabel.....");
			iret = this.DrawLabel(rowid, leftPos);// '绘制这一行的Label
			console.log("call DrawColumn.....");
			iret = this.DrawColumn(rowid, leftPos);// '绘制这以行的Column
			console.log("call DrawLine.....");
			iret = this.DrawLine(rowid, leftPos);// '绘制这一行的Line
		}

		// 'step5.绘制targetPict的底色
		// targetPict.BackColor = GF_GetVBColor( _
		// this.local_webdw.datawindow.color, 256# * 256 * 256 - 1)

		// 'step6.根据当前行，在前面设置一个图标
		this.DrawDW_ImageOnly();

		// 'step7.如果是grid风格，则执行绘制表格线的方法
		this.DrawGridLine();
		return 0;
	}

	// '更新以后修正数据状态
	AfterUpdate() {
		return webdwData.AfterUpdate();
	}

	// '添加命令
	DW_AddCommand(iret) {
		var sret =this.sqlca.AddCommand(iret);
		errString =this.sqlca.errString;
		return sret;
	}

	// '启动事务
	DW_BeginTransaction( iret) {
		var sret =this.sqlca.BeginTransaction(iret);
		errString =this.sqlca.errString;
		return sret;
	}

	// '提交事务
	DW_Commit( iret) {
		var sret =this.sqlca.Commit(iret);
		errString =this.sqlca.errString;
		return sret;
	}

	// '根据给定dw语法进行转换，如果转换成功，设置本地的g_webdw数据
	// '如果转换失败，返回-1
	DW_Create( dwSyntax) {
		var iret = 0;// As Long
		iret = webdw.Create(dwSyntax);

		if (iret == -1) {
			errString = webdw.errString;
			local_webdw = new WebDWSyntax();
			return -1;
		} else {
			webdw.GetLocalWebDW();
			SetLocalWebDW();
			return 0;
		}

	}

	// '功能描述：删除当前行
	// '返回0 成功
	// '返回-1 发生错误
	DW_DeleteRow( rowid) {
		// '逻辑判断，调用前先初始化数据窗口控件
		if (targetControls == null || targetPict == null) {
			// DW_DeleteRow = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		// '如果传入参数小于等于0，直接退出
		if (rowid <= 0) {
			return 0;
		}
		var iret = 0;// As Long
		iret = webdwData.DeleteRow(rowid);

		// '删除数据时发生错误，退出
		if (iret == -1) {
			// DW_DeleteRow = -1
			errString = webdwData.errString;
			return -1;
		}

		// '设置滚动条的最大值
		if (VScroll_Line.getMaximum() > 0) {
			VScroll_Line.setMaximum(VScroll_Line.getMaximum() - 1);
		}

		// '如果界面的当前行已经溢出，重新设置，如果数据为空，当前行为0
		if (currentRow > webdwData.GetRowCount()) {
			currentRow = webdwData.GetRowCount();
		}

		DrawDW();// '刷新数据

		return 0;
	}

	// '------------------------------------------------------------------------------------------------
	// '---------------------------------this.sqlca相关的方法定义结束
	// --------------------------------
	// '------------------------------------------------------------------------------------------------
	// '返回当前的事务状态定义
	// '1代表true 0 代表false
	DW_GetAutoCommit() {
		if (autoCommit) {
			return 1;
		} else {
			return 0;
		}
	}

	// '检索数据窗口中的当前数据
	// 'rowid 行号
	// 'colid 列号
	// '返回值：当前值
	DW_GetItemString( rowid, colid) {
		return webdwData.GetItemString(rowid, colid);
	}

	// '功能描述：得到当前行
	// '要得到当前行，需要传入当前所在对象的ID号
	DW_GetRow() {
		// '先判断targetControls和targetPict已经正常赋值
		if (targetControls == null || targetPict == null) {
			// DW_GetRow = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		return currentRow;
	}

	// '得到sqlca对应的ServerURL
	DW_GetServerURL() {
		return G_ServerURL;
	}

	// '得到最近要提交到后台的更新数据库的命令集合
	// '多条命令之间用chr(13)chr(10)来分隔
	// '目前仅支持单表的更新操作所需要的SQL命令
	DW_GetSQLPreview( iret) {

		// 'step1 检查是否进行了初始化
		// '先判断targetControls和targetPict已经正常赋值
		if (targetControls == null || targetPict == null) {
			// W_GetSQLPreview = ""
			iret.intvalue = -1;
			errString = "Please Call SetDataObject First.";
			return "";
		}

		var stable = "";// As String '数据表名称

		if (!local_webdw.table.retrieve.pbselect.table[2]==("")) {// '目前仅支持单表，如果是多表，退出
			iret.intvalue = 0;
			return "";
		}

		if (this.local_webdw.table.retrieve.pbselect.table[1]==("")) {// '如果第一个表名为空，退出
			iret.intvalue = -1;
			// DW_GetSQLPreview = ""
			errString = "ERROR: no table define";
			return "";
		}
		stable = this.local_webdw.table.retrieve.pbselect.table[1];
		stable = Replace(stable, "~" + "\"", ""); // '得到表名，替换掉其中的~"

		return webdwData.GetUpdateSql(stable, iret);

	}

	// '得到当前的Select语句定义
	// '先判断根目录下的SelectSql变量
	// '如果为空，取webdwdata返回的SQL命令
	DW_GetSQLSelect() {
		var webdw = this.webdw;
		
		var strsql = "";// As String

		if (this.local_webdw.SelectSQL==("")) {
			strsql = this.webdw.GetRetrieveSQL();
		} else {
			strsql = this.local_webdw.SelectSQL;
		}

		return strsql;
	}

	// '得到数据窗口的语法表示
	// '返回iret 0 代表成功 -1 代表失败
	DW_GetSyntax( iret) {
		var sret = webdw.GetSyntaxString(iret);
		if (iret.intvalue == -1) {
			errString = webdw.errString;
		}
		return sret;
	}

	// '在数据窗口中插入一条记录，返回这条记录的当前行号，如果出错，返回-1
	// 'rowid代表要插入的行号，如果为0代表在最后插入
	DW_InsertRow( rowid) {
		// 'step1 判断是否初始化
		if (targetControls == null || targetPict == null) {
			// DW_InsertRow = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		var emptystring = "";// As String
		var colid = 0;// As Long
		var colNum = 0;// As Long
		colNum = webdwData.GetColumnNumber();
		emptystring = "";
		for (colid = 1; colid <= colNum; colid++) {
			if (emptystring==("")) {
				emptystring = " ";
			} else {
				emptystring = emptystring + Chr(9) + "";
			}
		}

		var iret = 0;// As Long
		iret = webdwData.InsertRow(rowid, emptystring);

		if (iret == -1) {
			errString = webdwData.errString;
		} else {
			VScroll_Line.setMaximum(VScroll_Line.getMaximum() + 1);
		}

		DrawDW();
		return iret;
	}

	DW_Retrieve() {
		return this.DW_Retrieve2("");
	}

	// '数据窗口的检索功能，等价功能dw.Retrieve()
	// '前提条件是已经设置了datawindow对象
	// 'args是检索调用的参数，各个参数之间用TAB键分割
	// '20090116对参数进行修改，targetControls和targetPict不再需要外部传入
	DW_Retrieve2( args) {
		var targetControls = this.targetControls;
		var targetPict = this.targetPict;
		var sqlca = this.sqlca;
		var iret = this.iret;
		
		// '先判断targetControls和targetPict已经正常赋值
		if (targetControls == null || targetPict == null) {
			// DW_Retrieve = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		var strsql = "";// As String
		var sdata = "";// As String
		var argArray = new Array(1);// String[1];// As Variant
		var arg = "";// As Variant
		var sarg = "";// As String
		var argid = 0;// As Long
		// var iret=0;// As Long

		// 'strsql = webdwReader.GetRetrieveSQL() '得到检索用的SQL语句
		strsql = this.DW_GetSQLSelect();
		console.log("strsql="+strsql);

		// '替换各个自定义变量
		argArray = Split(args, "" + Chr(9));
		argid = 1;
		for (argid = 1; argid <= argArray.length; argid++) {
			sarg = argArray[argid - 1];
			strsql = Replace(strsql, ":arg" + argid, sarg);
		}

		// 'sqlca.beginPos = 0
		// 'sqlca.readNum = 1000
		// sqlca.Eval("SetCommand(" + strsql + ")", iret);
		sqlca.command = strsql;
		sdata =this.sqlca.ExecuteSelect(iret);// '执行sql,得到数据结果

		if (iret.intvalue == -1) {
			// DW_Retrieve = -1
			this.errString =this.sqlca.errString;
			return -1;
		}
		// '利用新数据，初始化数据窗口
		console.log("sData="+sdata);
		this.SetData(sdata);
		
		var i = this.DrawDW();
		return i;
	}

	// '回滚事务'iret是返回参数0 正常 -1 失败
	DW_Rollback( iret) {
		var sret =this.sqlca.Rollback(iret);
		errString =this.sqlca.errString;
		return sret;
	}

	//	
	// '得到当前DataWindow内的记录总数
	// '返回-1代表失败
	// '正常情况返回值>=0
	DW_RowCount() {
		// 'step1 判断是否初始化
		if (targetControls == null || targetPict == null) {
			// DW_RowCount = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}
		return webdwData.GetRowCount();
	}

	// '设置当前的事务状态定义
	// '1 自动事务
	// '0 手工事务
	DW_SetAutoCommit( flag) {
		// Dim iret As Long
		var transid = "";

		transid =this.sqlca.Eval("GetTransId", iret);

		if (flag == 1) {// Then '要设置为自动事务
			if (!autoCommit) {// Then '当前状态为非自动事务
				if (!transid==("")) {// Then '当前存在事务
					sqlca.Rollback(iret);// '回滚当前事务
				}
				autoCommit = true;// '设置为自动事务
			}
		} else { // '要设置为手工事务
			if (autoCommit) {// '当前为自动事务
				if (!transid==("")) {// '当前存在事务
					sqlca.Rollback(iret);// '回滚当前事务
				}
				autoCommit = false;// '设置为手工事务
			}
		}
		return 0;
	}

	// DW_SetDataObject(List targetControlsArg, MyJPanel
	// targetPictArg,
	// MyJPanel parentPict,var sUIDesc) {
	// return DW_SetDataObject(targetControlsArg, targetPictArg,
	// parentPict,sUIDesc, true);
	// }

	// '设置dataobject对象，dataobject对象用一个字符串来描述
	// '这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
	// '而是通过其名称来进行访问
	// 'childflag 是否检索子数据窗口的标志位 true 检索 false 不检索子窗口
	DW_SetDataObject(targetControlsArg,	targetPictArg, parentPict, sUIDesc,
			childFlag, createflag) {
		// try {
			var convertRate = 0;// As Double
			// 'step1: 设置对象的连接
			// '首先把对象和界面上的控件连接起来
			// '确保这些对象是实际存在的
			// '为了简化程序的结构，目前暂不考虑动态生成这些所有控件
			//	    
			// 'step1.设置targetControls和targetPict这两个变量
			if (targetControlsArg == null) {
				this.errString = "Cannot set targetControls";
				throw new Exception("error");
			}

			if (targetPictArg == null) {
				this.errString = "Cannot set targetPict";
				throw new Exception("error");
			}

			if (parentPict == null) {
				this.errString = "Cannot set parentPict";
				throw new Exception("error");
			}
			this.targetControls =  targetControlsArg;
			this.targetPict = targetPictArg;
			// targetPict.Refresh();

			// 'step1.2 set vscroll_page
// VScroll_Page = GF_GetObjectByName(this.targetControls,
// this.targetPict.getName + "_Vscroll_Page");
// if (VScroll_Page == null) {
// if (!createflag) {
// errString = "Cannot find Vscroll_Page";
// throw new Exception("error");
// } else {
// VScroll_Page = new WebDW_DymaVscroll_Page(targetPict.Name
// + "_Vscroll_Page", targetControls, parentPict);
// VScroll_Page.Left(targetPict.Top + targetPict.Width + 20);
// VScroll_Page.Top(targetPict.Top);
// VScroll_Page.Width(20);
// VScroll_Page.Height(targetPict.Height - 20);
// VScroll_Page.setVisible(true);
// }
// }

			// 'step1.3 set vscroll_line
// VScroll_Line = GF_GetObjectByName(targetControls,
// targetPict.getName() + "_Vscroll_Line");
// if (VScroll_Line == null) {
// if (!createflag) {
// errString = "Cannot find Vscroll_Line";
// throw new Exception("error");
// } else {
// VScroll_Line = new WebDW_DymaVscroll_Line(targetPict.Name
// + "_Vscroll_Line", targetControls, parentPict);
// VScroll_Line.Left(targetPict.Top + targetPict.Width);
// VScroll_Line.Top(targetPict.Top);
// VScroll_Line.Width(20);
// VScroll_Line.Height(targetPict.Height - 20);
// VScroll_Line.setVisible(true);
// }
// }

			// 'step1.4 set hscroll_page
// HScroll_Page = GF_GetObjectByName(targetControls,
// targetPict.getName() + "_HScroll_Page");
// if (HScroll_Page == null) {
// if (!createflag) {
// errString = "Cannot find HScroll_Page";
// throw new Exception("error");
// } else {
// HScroll_Page = new WebDW_DymaHscroll_Page(targetPict.Name
// + "_HScroll_Page", targetControls, parentPict);
// HScroll_Page.Left(targetPict.Left);
// HScroll_Page.Top(targetPict.Top + targetPict.Height);
// HScroll_Page.Width(targetPict.Width);
// HScroll_Page.Height(20);
// HScroll_Page.setVisible(true);
// }
//
// }

			// //'step1.5 set ImagePoint，代表当前行标示的图标
			// Set ImagePoint = GF_GetObjectByName(targetControls,
			// targetPict.getName() + "_ImagePoint")
			// If ImagePoint Is Nothing Then
			// errString = "Cannot find ImagePoint"
			// GoTo SETDATAOBJECTERROR
			// End If

			// 'step1.6 set ChildPict，代表子数据窗口
// childPict = GF_GetObjectByName(targetControls,
// "PictureChild");
// if (childPict == null && childFlag) {
// errString = "ChildFlag Is True ,While Cannot find PictureChild";
// throw new Exception("error");
// }

			// 'step1.7 得到界面定义文件和界面元素之间的转换比例定义
			convertRate = GF_GetConvertRate(this.targetControls);

			// 'step2:初始化界面表示,初始化完毕以后，界面信息存储在g_webdw里面了
			var iret = 0;
			var columnString = "";// As String
			iret = this.webdw.Create(sUIDesc);

			if (iret == -1) {// '如果发生错误，截获错误，抛出错误（异常?）
				errString = webdw.errString;
				throw new Exception("error");
			}

			// '如果初始化成功，那么需要通过公用变量GG_webdw来进行数据传输
			this.webdw.GetLocalWebDW();// '设置gg_webdw的数值
			this.SetLocalWebDW();// '设置本地g_webdw的数值

			// '调用方法，如果存在下拉式数据窗口，配置读取信息
			if (childFlag) {// Then
				this.retrieveChildDW();// '检索所有的子窗口
			}
			// 'step3:初始化数据存储，初始化完毕后，实际数据存储在webdwData里面了，可以通过方法来访问
			columnString = this.webdw.GetColumnDefineString();
			iret = this.webdwData.InitData(columnString);// '用列字符串来进行初始化,否则插入时不能成功

			if (iret == -1) {// '如果发生错误，截获错误，抛出错误（异常?）
				errString = webdwData.errString;
				throw new Exception("error");
			}

			// 'step4:设置VscrollBar,HscrollBar
// VScroll_Line.Max(0);// .Max = 0
// VScroll_Line.Min(0);// .Min = 0
// VScroll_Line.Value(0);// value = 0
// VScroll_Line.setVisible(true);// .Visible = True
//
// VScroll_Page.Max(0);// .Max = 0
// VScroll_Page.Min(0);// .Min = 0
// VScroll_Page.Value(0);// .value = 0
// VScroll_Page.setVisible(false);// .Visible = False

			// '根据最大宽度来设置hscroll的属性
			var maxwidth = 0;// As Long
			maxwidth = (this.webdw.getMaxWidth() * convertRate);
			if (maxwidth <= this.targetPict.Width) {
				// HScroll_Page.setEnabled(false);
// HScroll_Page.Min(0);// .Min = 0
// HScroll_Page.Max(0);// .Max = 0
// HScroll_Page.SmallChange(1);
// HScroll_Page.LargeChange(1);
// HScroll_Page.Value(0);// .value = 0
// HScroll_Page.setEnabled(false);// .Enabled = False
			} else {
				// HScroll_Page.setEnabled(false);
// HScroll_Page.Min(0);
// HScroll_Page.Value(0);
// HScroll_Page.Max( ((maxwidth - targetPict.getWidth()) * 2
// / targetPict.getWidth() + 2));
// HScroll_Page.SmallChange(1);// .SmallChange = 1
// HScroll_Page.LargeChange(2);// .largechange = 2
// HScroll_Page.setEnabled(true);// .Enabled = True
			}

			// 'step 5绘制图形出来
			this.currentRow = 0;
			this.DrawDW();// '从第一行开始绘制

			return 0;
		// } catch(e) {
			// e.printStackTrace();
		// alert(e);
		// initAllObjectPoint();
		// return -1;
		// }
		// SETDATAOBJECTERROR: '错误处理代码
		// initAllObjectPoint '初始化所有对象指针为Nothing
		// DW_SetDataObject = -1 '发生错误

	}

	// '一个新增加的接口,功能和DW_SetDataObject类似
	// '区别在于一个传入的是一个字符串
	// '一个传入的是数据窗口的名字，从后台直接检索这个文件再进行初始化调用
	DW_SetDataObjectByName( targetControlsArg,
			 targetPictArg,  parentPict,  sdwName,
			 childFlag,  createFlag) {
		var sUIDefine = "";// As String
		sUIDefine = this.GetDWSyntaxByName(sdwName);

		if(sUIDefine==""){
			sUIDefine = xmlHttp.responseText;
		}
		console.log("sUIDefine:"+sUIDefine);
		
		if (sUIDefine=="") {
			// DW_SetDataObjectByName = -1
			errString = "Cannot find DW Deine:" + sdwName;
			return -1;
		}

		return this.DW_SetDataObject(targetControlsArg, targetPictArg, parentPict,
				sUIDefine, childFlag, createFlag);

	}

	// '设置网格线的颜色，调用VB的QBColor方法,可用颜色0-15
	// '传入其他参数，不予处理
	DW_SetGridLineColor( color) {
		if (color >= 0 && color < 16) {
			// gridLineColor = QBColor(color)
			// TODO: Add QBColor Function
			return 0;
		} else {
			// DW_SetGridLineColor = -1
			errString = "Wrong Argument";
			return -1;
		}
	}

	// '设置数据,只能设置PrimaryBuffer的数据
	DW_SetItem( rowid, colid, sdata) {

		var iret = 0;// As Long
		var strinfo = "";// As String
		var coltype = "";// As String
		var stemp = "";// As String
		var sCNinfo = "";// As String
		var sENinfo = "";// As String
		var ColLength = 0;// As Long
		var ipos = 0;// As Long
		var ipos2 = 0;// As Long

		// '此处增加输入数据的校验功能，以确保要设置的数据符合原始的定义要求
		// '只有在输入数据满足这些要求的情况下，才真正设置数据，否则不进行数据的设置

		// 'step1:输入字段长度的校验问题
		// '增加一个字段长度的判断
		// '如果输入的长度已经超过了数据库可以容纳的长度，那么就提示错误信息
		// '让用户有机会自己来修正错误
		if (this.local_webdw.column[colid].edit_limit > 0) {// Then '如果存在输入限制
			if (GF_GetDBlength(sdata) > this.local_webdw.column[colid].edit_limit) {// Then
				sCNinfo = "输入项超过数据库许可:" + sdata + "\\r\\n" + "最大长度:"
						+ this.local_webdw.column[colid].edit_limit + "\\r\\n"
						+ "当前长度:" + GF_GetDBlength(sdata);
				sENinfo = "Item too large for Database store:" + sdata
						+ "\\r\\n" + "Max length:"
						+ this.local_webdw.column[colid].edit_limit + "\\r\\n"
						+ "Current length:" + GF_GetDBlength(sdata);
				strinfo = langsupport.SumAllLang(sCNinfo, sENinfo);
				strinfo = langsupport.GetCurrent(strinfo);

				MsgBox(strinfo, 1, "WebDW Error");
				return -1;
			}

		} else {
			// '如果输入的限制为0,那么要判断是否是字符型,如果是字符型,取其数据类型中定义的长度来进行长度限制判断
			coltype = this.local_webdw.table.Columns[colid].type;// '得到数据类型
			if (InStr(coltype, "char") > 0) {// Then
				ipos = InStr(coltype, "(");
				if (ipos > 0) {// Then
					ColLength = toInt(Mid(coltype, ipos + 1, Len(coltype)
							- ipos - 1));// '字符串的宽度定义,同数据库中的长度定义,pb自动生成维护
					if (GF_GetDBlength(sdata) > ColLength) {// Then
						sCNinfo = "输入项超过数据库许可:" + sdata + "\\r\\n" + "最大长度:"
								+ ColLength + "\\r\\n" + "当前长度:"
								+ GF_GetDBlength(sdata);
						sENinfo = "Item too large for Database store:" + sdata
								+ "\\r\\n" + "Max length:" + ColLength
								+ "\\r\\n" + "Current length:"
								+ GF_GetDBlength(sdata);
						strinfo = langsupport.SumAllLang(sCNinfo, sENinfo);
						strinfo = langsupport.GetCurrent(strinfo);

						MsgBox(strinfo, 0, "WebDW Error");
						return -1;
					}
				}
			}
		}

		// 'step2:输入数据的数据类型校验问题
		// '如果数据类型是数值型，检查输入的数据是否是数值型
		coltype = this.local_webdw.table.Columns[colid].type;// '数据类型
		// '如果数据类型是数值型
		if ((InStr(coltype, "number") > 0) || (InStr(coltype, "int") > 0)
				|| (InStr(coltype, "long") > 0)
				|| (InStr(coltype, "decimal") > 0)) {// Then
			if (!IsNumeric(sdata)) {// Then
				sCNinfo = "数据类型不匹配:" + sdata + "\\r\\n" + "所需数据类型:" + coltype;
				sENinfo = "Item not match data type:" + sdata + "\\r\\n"
						+ "Require DataType:" + coltype;

				strinfo = langsupport.SumAllLang(sCNinfo, sENinfo);
				strinfo = langsupport.GetCurrent(strinfo);
				MsgBox(strinfo, 0, "WebDW Error");
				return -1;
			}
		}

		// '如果数据类型是long型,而输入数据带有小数点后的数字,则提示不支持小数位
		if (coltype==("long") || coltype==("int")
				|| coltype==("integer") || coltype==("smallint")) {// Then
			ipos = InStr(sdata, ".");
			if (ipos > 0) {// Then
				stemp = Mid(sdata, ipos + 1);
				stemp = Trim(stemp);
				if (stemp.length > 0) {// <> "" Then
					sCNinfo = "数据类型不匹配:" + sdata + "\\r\\n" + "所定义数据类型不支持小数位:"
							+ coltype;
					sENinfo = "DataType mismatch:" + sdata + "\\r\\n"
							+ "long datatype requied:" + coltype;

					strinfo = langsupport.SumAllLang(sCNinfo, sENinfo);
					strinfo = langsupport.GetCurrent(strinfo);

					MsgBox(strinfo, 0, "WebDW Error");
					return -1;
				}
			}
		}

		var datatype_jingdu = 0;// As Long '数据类型定义精度
		var data_jingdu = 0;// As Long '输入数据精度
		// '输入数据类型是decimal型,输入数据带有小数位,而且小数点后数据精度超过了定义,则给出提示,但不直接退出
		if (InStr(coltype, "decimal") > 0) {// Then
			ipos = InStr(coltype, "(");
			ipos2 = InStr(coltype, ")");
			if (ipos > 0 && ipos2 > 0) {// Then
				datatype_jingdu = toInt(Mid(coltype, ipos + 1, ipos2 - ipos - 1));
				ipos = InStr(sdata, ".");
				if (ipos > 0) {// Then
					stemp = Mid(sdata, ipos + 1);
					stemp = Trim(stemp);
					data_jingdu = Len(stemp);

					if (data_jingdu > datatype_jingdu) {// Then
						sCNinfo = "数据精度溢出:" + sdata + "\\r\\n数据库精度: "
								+ datatype_jingdu + "\\r\\n数据精度: "
								+ data_jingdu;
						sENinfo = "data decimal over:" + sdata
								+ "\\r\\n db need:" + datatype_jingdu
								+ "\\r\\n input data decimal:" + data_jingdu;

						strinfo = langsupport.SumAllLang(sCNinfo, sENinfo);
						strinfo = langsupport.GetCurrent(strinfo);

						MsgBox(strinfo, 0, "WebDW Warning:");

					}
				}
			}
		}

		iret = toInt(webdwData.SetItemString(rowid, colid, sdata));
		if (iret == -1) {
			errString = webdwData.errString;
		}

		return iret;
	}

	// '设置当前行
	DW_SetRow( rowid) {
		if (rowid > 0 && rowid <= DW_RowCount()) {
			currentRow = rowid;
			return 1;// '返回1代表成功
		} else {
			return -1;// '返回-1代表失败
		}
	}

	// '设置服务器地址
	DW_SetServerURL( surl) {
		G_ServerURL = surl;
		return 0;
	}

	// '设置数据窗口检索用的Select语句
	DW_SetSQLSelect( strsql) {
		local_webdw.SelectSQL = strsql;
		return 0;
	}

	// '根据给定的SQL语句，以及对应的数据窗口类型
	// '设置到g_webdw中去
	// '从而再转换，得到一个对应的数据窗口对象出来。
	// 'iret返回值，0 正常 -1 失败
	// '错误信息存放在errstring中
	// '这个方法是一个Select语句的小型解析器
	DW_SyntaxFromSQL( strsql, stype, iret) {
		var sret = webdw.SyntaxFromSQL(strsql, stype, iret);
		errString = webdw.errString;
		return sret;
	}

	// '执行Dw的Update方法,更新数据
	// '返回0代表调用成功
	// '返回-1代表调用发生错误
	// '将targetControls,targetPict都从参数中去掉
	DW_Update() {

		// 'step1 判断是否初始化
		if (targetControls == null || targetPict == null) {
			// DW_Update = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		var strsql = "";// As String
		var sdata = "";// As String
		// var iret =0 ;// As Long

		// 'step1 得到UpdateSQL
		strsql = DW_GetSQLPreview(iret);

		if (iret.intvalue == -1) {
			return -1;
		}

		// 'step2 提交SQL命令
		// '此处需要进行修正，数据窗口不可直接提交
		// '必须通过sqlca的commit方法提交，
		//	    
		// '如果设置为自动事务，那么就自动启动事务，增加命令，并且提交
		var cmds = new Array(1);// String[1];// ) As String
		var cmdid = 0;// As Long
		var transid = "";// As String

		transid =this.sqlca.Eval("GetTransid", iret);

		cmds = Split(strsql, "" + Chr(13) + Chr(10));

		if (autoCommit) {
			if (transid.length > 0) {// '如果已经有事务，先提交之
				sqlca.Commit(iret);
			}

			sqlca.BeginTransaction(iret);// '启动事务
			if (iret.intvalue == -1) {
				// DW_Update = -1
				errString =this.sqlca.errString;
				return -1;
			}

			for (cmdid = 0; cmdid <= UBound(cmds); cmdid++) {
				sqlca.Eval("Setcommand(" + cmds[cmdid] + ")", iret);// '添加命令
				sqlca.AddCommand(iret);
			}

			sqlca.Commit(iret);// '提交事务
			if (iret.intvalue == -1) {
				// DW_Update = -1
				errString =this.sqlca.errString;
				return -1;
			}
			// '更新数据库成功以后，应当把数据的状态改掉
			// '调用webdwdata中的方法
			// '目前下面的流程都走不到，需要进行修改
			webdwData.AfterUpdate();

		} else {// '手工事务状态，必须transId>""，否则拒绝操作
			if (transid==("")) {// Then
				// DW_Update = -1
				errString = "Please Call BeginTransaction First";
				return -1;
			}

			for (cmdid = 0; cmdid <= UBound(cmds); cmdid++) {
				sqlca.Eval("Setcommand(" + cmds[cmdid] + ")", iret);// '添加命令
				sqlca.AddCommand(iret);
			}
			// '必须在程序上显式提交事务方可
		}

		return 0;// '正常退出

	}

	// '20090217日增加的eval功能
	// '对于通用的GetSet方法，为了解决接口过多的问题
	// '不再一一提供GetSet方法，而是集中在一个Eval方法中进行提供
	// '这样就把sqlca提供的方法全部采用转发来实现
	// '未来可能在Eval函数中增加更多的外部接口
	// 'iret是返回的标志位
	// '0正常
	// '-1 失败
	Eval( command, iret) {

		if (command==("")) {
			iret.intvalue = 0;
			return "";
		}

		var newcommand = "";

		// '如果command以SQLCA开头，则转发到sqlca对象去执行
		if (UCase(Left(command, Len("sqlca.")))==(UCase("sqlca."))) {
			newcommand = Mid(command, Len("sqlca.") + 1);// '切分得到要转发给sqlca执行的命令
			var sret =this.sqlca.Eval(newcommand, iret);
			errString =this.sqlca.errString;
			return sret;
		}

		// '如果command以Data开头，那么转发到webdwdata去执行
		if (UCase(Left(command, Len("data.")))==(UCase("data."))) {
			newcommand = Mid(command, Len("data.") + 1);// '切分要转发给webdwdata执行的命令
			var sret = webdwData.Eval(newcommand, iret);
			errString = webdwData.errString;
			return sret;
		}

		iret.intvalue = -1;
		errString = "Unknown Command:" + command;
		return "";

	}

	// '给定一个数据窗口的名称
	// '从后台检索它的定义
	// '返回""代表没有找到
	GetDWSyntaxByName(dwname) {
		// Dim iret As Long
		var strdefine = "";// As String

		strdefine =this.sqlca.GetDWDefine(dwname, this.iret);// '检索对象定义,对象名称作为参数传入
		if (this.iret.intvalue == -1) {
			this.errString =this.sqlca.errString;
			return "";
		} else {
			return strdefine;
		}
		
	}

	// '功能描述：得到当前界面的网格线竖线描述
	// '数据来源:local_webdw
	// '数据输出：将所有竖线的X值组合起来，用逗号分割，返回
	// '仅用于Grid风格和Tabular风格的数据窗口，其他风格的返回""
	GetGridLineInfo() {
		// TODO:完成代码迁移工作
		return "";
	}

	// '根据给定的当前控件的名字，判断当前所在列的序号
	// '返回-1代表失败，>=0代表序号
	GetRowIdColumnId( currentControlName,  rowid, colid) {
		if (currentControlName==("")) {
			return -1;
		}
		var pos1 = 0;// As Long
		var pos2 = 0;// As Long
		var pos3 = 0;// As Long
		pos1 = InStr(1, currentControlName, "__");// '第一个双下划线的位置
		if (pos1 <= 0) {// Then
			return -1;
		}

		pos2 = InStr(pos1 + 1, currentControlName, "__");// '第二个双下划线的位置
		if (pos2 <= 0) {// Then
			return -1;
		}

		pos3 = InStr(pos2 + 1, currentControlName, "__");// '第三个双下划线的位置（可能没有)

		rowid.intvalue = toInt(Mid(currentControlName, pos1 + 2, pos2 - pos1
				- 2));// '得到行号

		var columnName = "";// As String
		if (pos3 > 0) {
			columnName = Mid(currentControlName, pos2 + 2, pos3 - pos2 - 2);// '得到列名
		} else {
			columnName = Mid(currentControlName, pos2 + 2);// '得到列名
		}

		colid.intvalue = webdw.GetColumnIdByColumnName(columnName);// '得到列号
		return 0;
	}

	// '功能描述：初始化所有指向界面元素的对象指针为Nothing
	// '如果调用SetDataObject失败，则初始化所有对象指针
	// '在类初始化时也调用这一方法
	initAllObjectPoint() {
		// '初始化各个界面对象的指针指向为Nothing
		targetControls = null;
		targetPict = null;
		VScroll_Line = null;
		VScroll_Page = null;
		HScroll_Page = null;
		// ImagePoint = null;
		return 0;
	}

	// '设置列定义字符串的方法
	// '这个列定义字符串表示了列名称和数据类型和长度定义
	// 'webdwdata用这个字符串来初始化存储结构
	SetColumnDefString (sColDefString) {
		return webdw.SetColumnDefineString(sColDefString);
	}

	// '输入:g_webdw
	// '输出:g_webdw
	// '处理：如果存在子数据窗口，检索每个子窗口的定义和数据，填充g_webdw
	retrieveChildDW() {
		var colid;// As Long
		var childDWDefine;//
		var childDWData;//
		var iret = new MyInt(0);// As Long

		// '暂时先不考虑子数据窗口的嵌套问题，目前只检索一层子数据窗口
		for (colid = 1; colid <= 100; colid++) {
			childDWDefine = "";
			childDWData = "";
			if (this.local_webdw.column[colid].dddw.Name.length > 0) {// Then
				childDWDefine =this.sqlca.GetDWDefine(
						local_webdw.column[colid].dddw.Name, iret);// '检索对象定义

				if (iret.intvalue == 0) {// Then '检索对象定义成功
					childDWData = GF_RetrieveBySyntax(childDWDefine);
					local_webdw.column_dddw_syntax[colid] = childDWDefine;// '存储子窗口语法定义
					local_webdw.column_dddw_data[colid] = childDWData;// '存储子窗口数据定义
				}
			}
		}
		return iret.intvalue;
	}

	SetData( indata) {
		return SetData(indata, "normal");
	}

	// '利用给定的数据，来初始化数据存储
	// 'targetControls 控件的集合
	// 'pictTarget 要绘图的控件
	// 'indata 重新设置的数据
	// 'datastate 可选项,数据的状态,默认为"normal"
	SetData( indata,  datastate) {
		var targetControls = this.targetControls;
		var webdwData = this.webdwData;
		
		var iret = 0;// As Long
		var convertRate = 0;// As Double
		var largechange = 0;// As Long

		// '增加判断，如果没有初始化，则不执行
		if (targetControls == null) {
			// SetData = -1
			errString = "Please Call SetDataObject() first!";
			return -1;
		}
		convertRate = GF_GetConvertRate(this.targetControls);// '得到转换比例

		iret = webdwData.InitData(indata, datastate);

		if (iret == -1) {
			errString = webdwData.errString;
			return -1;
		}

// if (webdwData.GetRowCount() > 0) {
// VScroll_Line.Max(webdwData.GetRowCount() - 1);
// VScroll_Line.Min(0);// .Min = 0
// VScroll_Line.SmallChange(1);// .SmallChange = 1
// largechange = ((targetPict.getHeight()
// - this.local_webdw.header.height * convertRate -
// this.local_webdw.footer.height
// * convertRate) / (this.local_webdw.detail.height * convertRate));
// if (largechange < 1) {
// VScroll_Line.LargeChange(1);// .largechange = 1
// } else {
// VScroll_Line.LargeChange(largechange);
// }
// VScroll_Line.setEnabled(true);// .Enabled = True
// } else {
// VScroll_Line.Max(0);
// VScroll_Line.Min(0);// = 0
// VScroll_Line.Value(0);// value = 0
// VScroll_Line.setEnabled(false);// .Enabled = False
// }

		if (webdwData.GetRowCount() > 0 && this.currentRow == 0) {// Then
			this.currentRow = 1;
		}// End If

		if (this.webdwData.GetRowCount() == 0) {// Then
			this.currentRow = 0;
		}
		return 0;
	}
// '设置父数据窗口的句柄
	SetParentDW(pui) {
		this.parentDW = pui;
		return 0;
	}
	
}	
	
class WebDW_DymaVscroll_Page {
		WebDW_DymaVscroll_Page( name, targetControls,parent) {
			// //super(name, targetControls, parent);
			this.setOrientation(1);
// this.addAdjustmentListener(new AdjustmentListener() {
// adjustmentValueChanged( e) {
// DrawDW();
// }
// });
		}
	}

class MyJScrollBar{
	constructor(){
		
	}
}

	class WebDW_DymaVscroll_Line extends MyJScrollBar {
		WebDW_DymaVscroll_Line( name, targetControls,parent) {
			// super(name, targetControls, parent);
			this.setOrientation(1);
// this.addAdjustmentListener(new AdjustmentListener() {
// adjustmentValueChanged(AdjustmentEvent e) {
// DrawDW();
// }
// });
		}
	}

	class WebDW_DymaHscroll_Page extends MyJScrollBar {
		 WebDW_DymaHscroll_Page( name,  targetControls,	parent) {
			// super(name, targetControls, parent);
			this.setOrientation(0);
// this.addAdjustmentListener(new AdjustmentListener() {
// adjustmentValueChanged(AdjustmentEvent e) {
// MyJScrollBar bar = e.getSource();
// bar.Refresh();
// if (bar.isEnabled()) {
// System.out.println("Hscroll value" + bar.Value);
// System.out.println("Hscroll max" + bar.Max);
// System.out.println("HScroll LargerChange:"
// + bar.LargeChange);
// System.out.println("extent: ");
// DrawDW();
// }
// }
// });
		}
	}



	class ChildDW_DymaTextField extends MyJTextField {
		setCurrentRow() {
			var rowid = new MyInt(0);
			var colid = new MyInt(0);
			var iret = GetRowIdColumnId(Name, rowid, colid);// '得到当前行，当前列
			if (iret == 0) {
				iret = DW_SetRow(rowid.intvalue);
				// If iret = -1 Then
				// 'myTextBox.tag = "reenter" '设置重入标志
				// 'myTextBox.text = DW_GetItemString(rowid, colid)
				// 'myTextBox.tag = ""
				// End If
			}

		}

		ChildDW_DymaTextField (stext,  name, targetControlsArg, parent) {
			// super(stext, name, targetControlsArg, parent);
// this.addActionListener(new ActionListener() {
// actionPerformed(ActionEvent e) {
// // 如果是单击,判断是否是子数据窗口
// // setCurrentRow();
// }
// });

			// this.addKeyListener(new KeyListener() {
			// keyTyped(KeyEvent e) {
			// }
			//
			// keyPressed(KeyEvent e) {
			// }
			//
			// keyReleased(KeyEvent e) {
			// setCurrentRow();
			// }
			// });

// this.addMouseListener(new MouseAdapter() {
// mouseClicked(MouseEvent e) {
// System.out.println("ChildDW mouse Click.");
// // setCurrentRow();
// // '当文本框上面双击的时候，设置所在父窗口的当前行当前列的对应数值
//
// int dataColId = 0;// As Long
// var selectdata = "";// As String
//
// MyInt rowid = new MyInt(0);
// MyInt colid = new MyInt(0);
// var iret = GetRowIdColumnId(Name, rowid, colid);// '得到当前行，当前列
// if (iret==-1){
// return;
// }
//					
// MyInt pcolId = new MyInt(0);// As Long
// MyInt prowId = new MyInt(0);// As Long
// // int rowid = 0;// As Long
// // '当在子窗口的控件上进行双击以后，设置父数据窗口的对应内容的数据
// if (parentDW != null && dataColumnName.length > 0) {// > ""
// // Then
// dataColId = webdw
// .GetColumnIdByColumnName(dataColumnName);// '得到数据列序号
//
// // rowid = DW_GetRow();// '得到当前行
//
// if (dataColId > 0 && rowid.intvalue > 0) {// Then
// selectdata = DW_GetItemString(rowid.intvalue, dataColId);// '得到选择的数据
//
// parentDW.GetRowIdColumnId(parentControlName,
// prowId, pcolId);// '读取父窗口的数据,行列
//
// if (prowId.intvalue > 0 && pcolId.intvalue > 0
// && Len(selectdata) > 0) {// Then
// parentDW.DW_SetItem(prowId.intvalue,
// pcolId.intvalue, selectdata);// '设置父窗口数据
// parentDW.DrawDW();// '重新绘制
// }
// }
// }
// }
// });
		}
	}


	class WebDW_DymaComboBox extends MyJComboBox {
		WebDW_DymaComboBox( name,  targetControls,
				 parent) {
			// super(name, targetControls, parent);
			// '当点击选择框时，更新相应字段内容

// this.addActionListener(new ActionListener() {
// actionPerformed( e) {
// var iret = 0;// As Long
// var rowid = new MyInt(0);// As Long
// var colid = new MyInt(0);// As Long
// var svalue = "";// As String '这个控件代表的属性值
// var pos1 = 0;// As Long
// var pos2 = 0;// As Long
// var pos3 = 0;// As Long
// var allData = new Array(1);//String[1];
//
// iret = GetRowIdColumnId(Name, rowid, colid);
// if (iret == 0) {// Then
//
// allData = Split(
// local_webdw.table.Columns[colid.intvalue].values,
// "/");
// Refresh();
// if (ListIndex >= 0) {// Then
// svalue = allData[ListIndex];
// pos1 = InStr(1, svalue, Chr(9));
// if (pos1 > 0) {// Then
// DW_SetItem(rowid.intvalue, colid.intvalue, Mid(
// svalue, pos1 + 1));
// }
// } else {
//
// }
// }
// }
// });
		}
	}

	class WebDW_DymaRadioButton extends MyJRadioButton {
// DymaRadioButton_radioListerner() {
// stateChanged(e) {
// // '单击单选按钮的操作
// var iret = 0;// As Long
// var rowid = new MyInt(0);// As Long
// var colid = new MyInt(0);// As Long
// Refresh();
// if (!Value) {
// return;
// }
// System.out.println("You enter radiobutton:" + Name
// + " Tag is:" + Tag);
// iret = GetRowIdColumnId(Name, rowid, colid);// '得到行号和列号
// if (iret == 0) {// Then
// DW_SetItem(rowid.intvalue, colid.intvalue, Tag);// '从tag里面取出值，设置变量
// }
//
// }
// }

		WebDW_DymaRadioButton(s1, name,	targetControls,parent) {
			// super(s1, name, targetControls, parent);
// this.addChangeListener(new DymaRadioButton_radioListerner() {
// });
		}
	}


	class WebDW_DymaCheckBox extends MyJCheckBox {
// class DymaCheckBox_checkListerner implements ChangeListener {
// stateChanged(ChangeEvent e) {
// // '单击选择框按钮的操作
// // 'MsgBox "change", , myTextBox.name
// var iret = 0;// As Long
// MyInt rowid = new MyInt(0);// As Long
// MyInt colid = new MyInt(0);// As Long
//
// iret = GetRowIdColumnId(Name, rowid, colid);// '得到行号和列号
// if (iret == 0) {// Then
// Refresh();
// System.out.println("You enter checkbox listener. ");
// if (Value) {// = 1 Then '选中状态
// DW_SetItem(rowid.intvalue, colid.intvalue,
// local_webdw.column[colid.intvalue].checkbox.on);
// } else {// '未选中状态
// DW_SetItem(rowid.intvalue, colid.intvalue,
// local_webdw.column[colid.intvalue].checkbox.off);
// }
// }
//
// }
// }

		WebDW_DymaCheckBox (s1,  name, targetControls, parent) {
		}
		
		
	}
	class WebDW_DymaTextField extends MyJTextField{
		
		constructor (s1,  name, targetControls, parent) {
			super (s1,  name, targetControls, parent);
		}
	}
