package com.webdw;

/**
 * WebDW�﷨�����Java���� ��VB������ֲ����
 * 
 * @author admin
 * 
 */

class WebDW_DataWindow {
	String unit = "";

	String timer_interval = "";

	int color = 0;

	String processiong = "";

	String HTMLDW = "";

	String print_documentname = "";

	int print_orientation = 0;

	int print_margin_left = 0;

	int print_margin_right = 0;

	int print_margin_top = 0;

	int print_margin_bottom = 0;

	int print_paper_source = 0;

	int print_paper_size = 0;

	String print_prompt = "";

	String print_buttons = "";

	String print_preview_buttons = "";

	String grid_lines = "";

	public WebDW_DataWindow Clone() {
		WebDW_DataWindow newOne = new WebDW_DataWindow();
		newOne.unit = this.unit;
		newOne.timer_interval = this.timer_interval;
		newOne.color = this.color;
		newOne.processiong = processiong;
		newOne.HTMLDW = HTMLDW;
		newOne.print_documentname = print_documentname;
		newOne.print_orientation = print_orientation;
		newOne.print_margin_left = print_margin_left;
		newOne.print_margin_right = print_margin_right;
		newOne.print_margin_top = print_margin_top;
		newOne.print_margin_bottom = print_margin_bottom;
		newOne.print_paper_source = print_paper_source;
		newOne.print_paper_size = print_paper_size;
		newOne.print_prompt = print_prompt;
		newOne.print_buttons = print_buttons;
		newOne.print_preview_buttons = print_preview_buttons;
		newOne.grid_lines = grid_lines;

		return newOne;
	}
}

// 'header���Զ���
class WebDW_Header {
	int height = 0;

	int color = 0;

	public WebDW_Header Clone() {
		WebDW_Header newOne = new WebDW_Header();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'summary���Զ���
class WebDW_Summary {
	int height = 0;

	int color = 0;

	public WebDW_Summary Clone() {

		WebDW_Summary newOne = new WebDW_Summary();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'footer���Զ���
class WebDW_Footer {
	int height = 0;

	int color = 0;

	public WebDW_Footer Clone() {
		WebDW_Footer newOne = new WebDW_Footer();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'detail���Զ���
class WebDW_Detail {
	int height = 0;

	int color = 0;

	public WebDW_Detail Clone() {
		WebDW_Detail newOne = new WebDW_Detail();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'table��Ƕ��column���Զ���
class WebDW_Table_Column {
	String type = ""; // '��������

	String update = ""; // '�Ƿ���Ը���yes/no

	String updatewhereclause = ""; // '�Ƿ��Ǹ���ʱ��where����yes/no

	String key = ""; // '�Ƿ�������

	String Name = ""; // '�ֶ���

	String dbname = ""; // '���ݿ��ֶ���

	String values = ""; // '����ֵ�������洢�༭���ʱ����Ϣ

	String validations = ""; // '�༭��У���ַ���

	public WebDW_Table_Column Clone() {

		WebDW_Table_Column newOne = new WebDW_Table_Column();

		newOne.type = type; // '��������

		newOne.update = update; // '�Ƿ���Ը���yes/no

		newOne.updatewhereclause = updatewhereclause; // '�Ƿ��Ǹ���ʱ��where����yes/no

		newOne.key = key; // '�Ƿ�������

		newOne.Name = Name; // '�ֶ���

		newOne.dbname = dbname; // '���ݿ��ֶ���

		newOne.values = values; // '����ֵ�������洢�༭���ʱ����Ϣ

		newOne.validations = validations; // '�༭��У���ַ���

		return newOne;
	}
}

// '������Ӷ���
class WebDW_Table_Retrieve_PBSelect_Join {
	String join_left = "";

	String join_op = "";

	String join_right = "";

	public WebDW_Table_Retrieve_PBSelect_Join() {

	}

	public WebDW_Table_Retrieve_PBSelect_Join Clone() {

		WebDW_Table_Retrieve_PBSelect_Join newOne = new WebDW_Table_Retrieve_PBSelect_Join();

		newOne.join_left = join_left;

		newOne.join_op = join_op;

		newOne.join_right = join_right;

		return newOne;
	}
}

// '�������where��������
class WebDW_Table_Retrieve_PBSelect_Where {
	String exp1 = "";

	String op = "";

	String exp2 = "";

	String logic = "";

	public WebDW_Table_Retrieve_PBSelect_Where() {

	}

	public WebDW_Table_Retrieve_PBSelect_Where Clone() {

		WebDW_Table_Retrieve_PBSelect_Where newOne = new WebDW_Table_Retrieve_PBSelect_Where();

		newOne.exp1 = exp1;

		newOne.op = op;

		newOne.exp2 = exp2;

		newOne.logic = logic;

		return newOne;
	}
}

// '���ݱ������OrderBy��������
class WebDW_Table_Retrieve_PBSelect_Order {
	String Name = "";// As String '�����������

	String Asc = "";// As String '�Ƿ�������yes/no

	public WebDW_Table_Retrieve_PBSelect_Order Clone() {

		WebDW_Table_Retrieve_PBSelect_Order newOne = new WebDW_Table_Retrieve_PBSelect_Order();

		newOne.Name = Name;

		newOne.Asc = Asc;

		return newOne;
	}
}

// 'table��retrieve��pbselectԪ�����Զ���
// '��һ���ֿ��ܻ������Ҫ�����к�������
// '�����Ŷ���DW�ļ���ʽ������������չ
class WebDW_Table_Retrive_PBSelect {
	String version = "";

	String table[] = new String[11]; // '�������������10����

	String column[] = new String[101]; // '�������������100����

	WebDW_Table_Retrieve_PBSelect_Join join[] = new WebDW_Table_Retrieve_PBSelect_Join[11];// '�����Ӷ��壬���10������

	WebDW_Table_Retrieve_PBSelect_Where where[] = new WebDW_Table_Retrieve_PBSelect_Where[11]; // 'where�������壬���10��where����

	WebDW_Table_Retrieve_PBSelect_Order order[] = new WebDW_Table_Retrieve_PBSelect_Order[11]; // 'order

	// �����趨,���10��

	/*
	 * ���캯������ʼ��
	 */
	public WebDW_Table_Retrive_PBSelect() {
		int i;
		for (i = 0; i < 11; i++) {
			table[i] = "";
		}
		for (i = 0; i < 101; i++) {
			column[i] = "";
		}
		for (i = 0; i < 11; i++) {
			join[i] = new WebDW_Table_Retrieve_PBSelect_Join();
		}
		for (i = 0; i < 11; i++) {
			where[i] = new WebDW_Table_Retrieve_PBSelect_Where();
		}
		for (i = 0; i < 11; i++) {
			order[i] = new WebDW_Table_Retrieve_PBSelect_Order();
		}

	}

	public WebDW_Table_Retrive_PBSelect Clone() {
		WebDW_Table_Retrive_PBSelect newOne = new WebDW_Table_Retrive_PBSelect();
		int i;
		for (i = 0; i < 11; i++) {
			newOne.table[i] = table[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = column[i];
		}
		for (i = 0; i < 11; i++) {
			newOne.join[i] = join[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.where[i] = where[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.order[i] = order[i].Clone();
		}

		return newOne;
	}
}

// 'table.retrieveԪ�ض��壬����ֻ��һ��pbselectԪ��
class WebDW_Table_Retrieve {
	WebDW_Table_Retrive_PBSelect pbselect = new WebDW_Table_Retrive_PBSelect();

	public WebDW_Table_Retrieve Clone() {

		WebDW_Table_Retrieve newOne = new WebDW_Table_Retrieve();

		newOne.pbselect = pbselect.Clone();

		return newOne;
	}
}

// 'table���Զ���
class WebDW_Table {
	WebDW_Table_Column Columns[] = new WebDW_Table_Column[101]; // '���100��

	WebDW_Table_Retrieve retrieve = new WebDW_Table_Retrieve(); // '���¶���retrieve�����������һ���ṹ

	String update = "";

	String updatewhere = "";

	String updatekeyinplace = "";

	/**
	 * ���캯��,��ʼ������
	 * 
	 */
	public WebDW_Table() {
		for (int i = 0; i < 101; i++) {
			Columns[i] = new WebDW_Table_Column();
		}
	}

	public WebDW_Table Clone() {

		WebDW_Table newOne = new WebDW_Table();

		for (int i = 0; i < 101; i++) {
			newOne.Columns[i] = Columns[i].Clone();
		}

		newOne.retrieve = retrieve.Clone();

		newOne.update = update;

		newOne.updatewhere = updatewhere;

		newOne.updatekeyinplace = updatekeyinplace;

		return newOne;
	}
}

// 'WebDW�õ����ڲ�Font���壬
// '���Font���Զ�text��column��Ч
// '20081225������

class WebDW_Font {
	String face = "";

	int height = 0;

	int weight = 0;

	int family = 0;

	int pitch = 0;

	int charset = 0;

	int italic = 0;

	int underline = 0;

	int strikethrough = 0;

	public WebDW_Font Clone() {

		WebDW_Font newOne = new WebDW_Font();

		newOne.face = face;

		newOne.height = height;

		newOne.weight = weight;

		newOne.family = family;

		newOne.pitch = pitch;

		newOne.charset = charset;

		newOne.italic = italic;

		newOne.underline = underline;

		newOne.strikethrough = strikethrough;

		return newOne;
	}
}

// '�����жԵ�ѡ��ť���֧�ֶ��壬����Column��һ������
class WebDW_Column_RadioButtons {
	int Columns = 0; // '��ѡŦ��ʾ�е�����

	public WebDW_Column_RadioButtons Clone() {

		WebDW_Column_RadioButtons newOne = new WebDW_Column_RadioButtons();

		newOne.Columns = Columns;

		return newOne;
	}
}

// '�����ж�ѡ����֧�ֶ��壬����Column��һ������
class WebDW_Column_CheckBox {
	String text = ""; // '��ʾ�ڽ����ϵ��ַ���

	String on = ""; // 'ѡ��ʱ������ֵ

	String off = ""; // 'δѡ��ʱ������ֵ

	String scale1 = ""; // '���岻��,scale��vb�����֣�����

	String threed = ""; // '3D��ʾ���

	public WebDW_Column_CheckBox Clone() {

		WebDW_Column_CheckBox newOne = new WebDW_Column_CheckBox();

		newOne.text = text; // '��ʾ�ڽ����ϵ��ַ���

		newOne.on = on; // 'ѡ��ʱ������ֵ

		newOne.off = off; // 'δѡ��ʱ������ֵ

		newOne.scale1 = scale1; // '���岻��,scale��vb�����֣�����

		newOne.threed = threed; // '3D��ʾ���
		return newOne;
	}
}

// '�����ж�����ѡ����֧�ֶ��壬����Column��һ������
class WebDW_Column_ComboBox {
	int limit = 0; // '���ƣ����岻��

	String allowedit = ""; // '�Ƿ���Ա༭ yes /no

	String case1 = ""; // '��Сд,����Ϊcase1

	String useasborder = ""; // '�Ƿ���ʾ��ͷ yes/no

	public WebDW_Column_ComboBox Clone() {

		WebDW_Column_ComboBox newOne = new WebDW_Column_ComboBox();

		newOne.limit = limit; // '���ƣ����岻��

		newOne.allowedit = allowedit; // '�Ƿ���Ա༭ yes /no

		newOne.case1 = case1; // '��Сд,����Ϊcase1

		newOne.useasborder = useasborder; // '�Ƿ���ʾ��ͷ yes/no
		return newOne;
	}
}

// '�����ж��������ݴ��ڵ�֧�֣�����Column��һ������
// '20090125�մ�����ʮ�����
class WebDW_Column_DDDW {
	String Name = ""; // '���ݴ��ڵ����֣�δ��������ַ��������������ݴ���

	String DisplayColumn = ""; // '��ʾ�е����֣���һ���������ݴ�����

	String DataColumn = ""; // '�����е����֣�����һ��������ԭ���ݴ���

	int PercentWidth = 0; // '�ٷֱȱ�ʾ����ʾ���

	int Lines = 0;

	int limit = 0;

	String allowedit = "";

	String useasborder = "";

	String case1 = "";

	String vscrollbar = ""; // '�Ƿ���ʾ��������

	public WebDW_Column_DDDW Clone() {

		WebDW_Column_DDDW newOne = new WebDW_Column_DDDW();

		newOne.Name = Name; // '���ݴ��ڵ����֣�δ��������ַ��������������ݴ���

		newOne.DisplayColumn = DisplayColumn; // '��ʾ�е����֣���һ���������ݴ�����

		newOne.DataColumn = DataColumn; // '�����е����֣�����һ��������ԭ���ݴ���

		newOne.PercentWidth = PercentWidth; // '�ٷֱȱ�ʾ����ʾ���

		newOne.Lines = Lines;

		newOne.limit = limit;

		newOne.allowedit = allowedit;

		newOne.useasborder = useasborder;

		newOne.case1 = case1;

		newOne.vscrollbar = vscrollbar; // '�Ƿ���ʾ��������

		return newOne;
	}
}

// '
// 'column��֧�����Զ��壬
// '�������ļ��ж��뵽����ṹ��
// '��������ṹ����ͼ��ʾ
// '���������������ļ��ж������ͬ,����ؼ�����һ��
// '������ȫ��Сд
class WebDW_Column {
	String band = "";

	int id = 0;

	int alignment = 0;

	int tabsequence = 0;

	int border = 0;

	int color = 0;

	int x = 0;

	int y = 0;

	int height = 0;

	int width = 0;

	String format = "";

	String Name = "";

	String tag = "";

	int edit_limit = 0;

	String edit_case = "";

	String edit_focusrectangle = "";

	String edit_autoselect = "";

	String edit_autohscroll = "";

	WebDW_Font font = new WebDW_Font(); // '���¶���Font�ṹ��ʹ������ṹ��ʹ��

	int background_mode = 0;

	int background_color = 0;

	WebDW_Column_RadioButtons radiobuttons = new WebDW_Column_RadioButtons(); // '��ѡ��ť��֧�ֶ���20090124

	WebDW_Column_CheckBox checkbox = new WebDW_Column_CheckBox(); // 'ѡ��ť��֧�ֶ���20090124

	WebDW_Column_ComboBox combobox = new WebDW_Column_ComboBox(); // '�����б���֧�ֶ���20090124

	WebDW_Column_DDDW dddw = new WebDW_Column_DDDW(); // '�������ݴ��ڵ�֧�ֶ���20090125

	public WebDW_Column Clone() {

		WebDW_Column newOne = new WebDW_Column();
		newOne.band = band;

		newOne.id = id;

		newOne.alignment = alignment;

		newOne.tabsequence = tabsequence;

		newOne.border = border;

		newOne.color = color;

		newOne.x = x;

		newOne.y = y;

		newOne.height = height;

		newOne.width = width;

		newOne.format = format;

		newOne.Name = Name;

		newOne.tag = tag;

		newOne.edit_limit = edit_limit;

		newOne.edit_case = edit_case;

		newOne.edit_focusrectangle = edit_focusrectangle;

		newOne.edit_autoselect = edit_autoselect;

		newOne.edit_autohscroll = edit_autohscroll;

		newOne.font = font.Clone(); // '���¶���Font�ṹ��ʹ������ṹ��ʹ��

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		newOne.radiobuttons = radiobuttons.Clone(); // '��ѡ��ť��֧�ֶ���20090124

		newOne.checkbox = checkbox.Clone(); // 'ѡ��ť��֧�ֶ���20090124

		newOne.combobox = combobox.Clone(); // '�����б���֧�ֶ���20090124

		newOne.dddw = dddw.Clone(); // '�������ݴ��ڵ�֧�ֶ���20090125

		return newOne;
	}
}

// 'text��֧�����Զ���
// '�������ļ��ж��뵽����ṹ��
// '��������ṹ����ͼ��ʾ
// '���������������ļ��ж������ͬ������ؼ�����һ��
// '������ȫ��Сд
class WebDW_Text {
	String band = "";

	int alignment = 0;

	String text = "";

	int border = 0;

	int color = 0;

	int x = 0;

	int y = 0;

	int height = 0;

	int width = 0;

	String Name = "";

	WebDW_Font font = new WebDW_Font(); // '�¶����font����

	int background_mode = 0;

	int background_color = 0;

	public WebDW_Text Clone() {

		WebDW_Text newOne = new WebDW_Text();

		newOne.band = band;

		newOne.alignment = alignment;

		newOne.text = text;

		newOne.border = border;

		newOne.color = color;

		newOne.x = x;

		newOne.y = y;

		newOne.height = height;

		newOne.width = width;

		newOne.Name = Name;

		newOne.font = font.Clone(); // '�¶����font����

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		return newOne;
	}
}

// '���������ݶ�������
class WebDW_Line {
	String band = "";

	int x1 = 0;

	int y1 = 0;

	int x2 = 0;

	int y2 = 0;

	String Name = "";

	String pen_style = "";

	String pen_width = "";

	String pen_color = "";

	String background_mode = "";

	String background_color = "";

	public WebDW_Line Clone() {
		WebDW_Line newOne = new WebDW_Line();

		newOne.band = band;

		newOne.x1 = x1;

		newOne.y1 = y1;

		newOne.x2 = x2;

		newOne.y2 = y2;

		newOne.Name = Name;

		newOne.pen_style = pen_style;

		newOne.pen_width = pen_width;

		newOne.pen_color = pen_color;

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		return newOne;
	}
}

public class WebDWSyntax {
	public void ReadMe() {
		System.out.println("WebDW���û������ļ���ʾ�����ú�PB7.0���ݵĽ����ʽ����");
		System.out.println(Golbal.JWebDWInfo);
	}

	WebDW_DataWindow datawindow = new WebDW_DataWindow();

	WebDW_Header header = new WebDW_Header();

	WebDW_Summary summary = new WebDW_Summary();

	WebDW_Footer footer = new WebDW_Footer();

	WebDW_Detail detail = new WebDW_Detail();

	WebDW_Table table = new WebDW_Table();

	WebDW_Text text[] = new WebDW_Text[101];

	WebDW_Column column[] = new WebDW_Column[101];

	WebDW_Line lineinfo[] = new WebDW_Line[101];

	String column_dddw_syntax[] = new String[101];

	String column_dddw_data[] = new String[101];

	String SelectSQL = "";

	/**
	 * ��ʼ���Ĺ��캯��
	 * 
	 */
	public WebDWSyntax() {
		int i = 0;
		for (i = 0; i < 101; i++) {
			text[i] = new WebDW_Text();
		}
		for (i = 0; i < 101; i++) {
			column[i] = new WebDW_Column();
		}
		for (i = 0; i < 101; i++) {
			lineinfo[i] = new WebDW_Line();
		}
		for (i = 0; i < 101; i++) {
			column_dddw_syntax[i] = "";
		}
		for (i = 0; i < 101; i++) {
			column_dddw_data[i] = "";
		}
	}

	public WebDWSyntax Clone() {
		WebDWSyntax newOne = new WebDWSyntax();

		newOne.datawindow = datawindow.Clone();

		newOne.header = header.Clone();

		newOne.summary = summary.Clone();

		newOne.footer = footer.Clone();

		newOne.detail = detail.Clone();

		newOne.table = table.Clone();

		int i = 0;
		for (i = 0; i < 101; i++) {
			newOne.text[i] = text[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = column[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.lineinfo[i] = lineinfo[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_syntax[i] = column_dddw_syntax[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_data[i] = column_dddw_data[i];
		}
		return newOne;
	}
	
	/**
	 * Warning:Test only,Donot Use This Function in Program!!!
	 * @return
	 */
	public int getColumnNumber(){
		for(int i=1;i<=100;i++){
			if (column[i].Name.length()==0){
				return i-1;
			}
		}
		return 100;
	}
}
