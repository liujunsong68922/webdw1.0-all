package com.webdw;

import java.util.*;
import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import javax.swing.event.*;

//import java.awt.font.*;
//import java.awt.Font;
import java.awt.Color;
import java.awt.Container;
import com.webdw.ui.*;

//Rem -------------------------------------------------
//Rem WebDW�û������������VB������
//Rem ���������������
//Rem CWebDWUI �� CWebDWChildDW
//Rem ��Ҫ���ܣ���һ���ַ�������ת������Ӧ��ͼ�ν���
//Rem ͼ�ν�����ַ������������������߼�������ȫ�ȼ۵�
//Rem ��������������������ͼ�ν�����,��HTML���Է����һ��ͼ�λ�����
//Rem ���а����ı�,ͼ�εȶ���Ԫ��(һ��ʼ����ֻ���ı�)
//Rem ͨ��һ���ļ����ѽ�������ݿ���Թ�������
//Rem ��һ�汾�Ľ������������ʽ�ϸ���PB7�����ݴ����ַ�����ʽ����ȡ
//Rem ������DW_��ͷ�ķ������ṩ��PB Datawindow�ؼ����ƵĹ��ܺ͵��ýӿ�
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @��Ȩ���� ������ 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDWUI_ParentDW extends Golbal {
	public void ReadMe() {
		System.out.println("WebDW�û����������");
		System.out.println(JWebDWInfo);
	}

	public String errString = "";// '���صĴ�����Ϣ�ַ���

	public int controlSeg = 0;// '�൱��һ���ؼ������У�ÿ����һ���Զ���һ

	private JComponent myControls[] = new JComponent[10001];// 'myControls����������Զ������Ŀؼ��ļ���

	// '�����ؼ���ʵ�������ַ��form�ϣ�
	// '�����ŵ�ֻ��һ���ؼ������ָ��
	// '-------------------------------��������ඨ��------------------------------------------------------
	public CWebDW webdw = null;// '����webdw��Ӧ���ļ���ȡ��

	public CWebDWData webdwData = null;// '����webdw�����ݶ�����

	public CWebDWTransaction sqlca = null;// '����֧�֣�SQL����֧�ֶ���

	public CWebDWUI_ChildDW childDW = null;// '�����ݴ��ڵ��ඨ��

	public CWebDWDisplayFormat displayformate = null;// '������ʾ��ʽ��

	public int gridLineColor = 0;// '����ߵ���ɫ����

	// '------------����Ķ����ǽ����ϵĶ�ӦԪ�ض��壬���������setdataobject������
	ArrayList targetControls;// 

	// '�����������ʾ���еĿؼ�������������,��SetDataObject�г�ʼ������,20090116�����
	MyJPanel targetPict;// '�������Ҫ���л��Ƶ�PictureBox,20090116�����

	MyJScrollBar VScroll_Page;// '��ʾһҳ�ڱ仯��VScrollBar,��󷭶���һҳ

	MyJScrollBar VScroll_Line;// '��ʾ�б仯��VScrollBar,һ�����ٷ���һ��

	MyJScrollBar HScroll_Page;// '��ʾҳ�����ҷ�����HscrollBar��һ�η�����ҳ

	// Dim ImagePoint As Image 'ָʾ��ǰ���õ�ͼ��,�����õ�ɫͼƬ����ʾ��ǰ��
	MyJPanel childPict;// '�����ݴ��ڻ����õĴ���

	// '------------����Ԫ�صĶ������

	// '------------����Ķ����ǽ����ϵĶ�̬Ԫ�ض�Ӧ���¼�����������
	// Private WithEvents myTextBox As TextBox 'myTextBox��һ��������ı������������ı����¼���Ӧ
	// Private WithEvents myOptionButton As OptionButton
	// 'myOptionButton��һ�������ѡ��ť������ѡ��ť��Ӧ
	// Private WithEvents myCheckBox As checkbox 'myCheckBox��һ������ļ��򣬶���ѡ��ť��Ӧ
	// Private WithEvents myComboBox As combobox 'myComboBox��һ������������򣬶�����Ӧ�¼�
	// '------------���涯̬Ԫ�ض������
	private int currentRow = 0;// '���浱ǰ�ж���

	private WebDWSyntax local_webdw = null;// 'local_webdw������һ���ֲ������ˣ�������ȫ�ֱ�����

	private CMultiLang langsupport = null;// '������֧�ֶ�����

	private boolean autoCommit = false;// '�Զ�����֧�ֵı�־λtrue �Զ� false �ֹ�

	private MyInt iret = new MyInt(0);//

	/** *****************�����������ݴ���ר�õı��� */
	public String parentControlName = "";// '�����ݴ��ڵĿؼ�����

	public String dataColumnName = "";// '����������

	public CWebDWUI parentDW = null;// '���ø����ݴ��ڵľ��

	/**
	 * ���캯��
	 * 
	 */
	public CWebDWUI_ParentDW() {
		// '��ʼ��ʱ����controlSegֵ
		controlSeg = 0;
		webdw = new CWebDW();// '����webdw���﷨����
		webdwData = new CWebDWData();// '����webdw�����ݶ���
		sqlca = new CWebDWTransaction();// '����������
		// gridLineColor = QBColor(8);// 'Ĭ��Ϊ��ɫ����
		langsupport = new CMultiLang();// '������֧�ֶ����ඨ��
		displayformate = new CWebDWDisplayFormat();// '������ʾ��ʽ������

		autoCommit = false;// 'Ĭ��Ϊ���Զ�������Ҫ�ֹ����������ύ

		// '��ʼ������Ԫ��ָ��Ϊ��
		initAllObjectPoint();
	}

	// '��������������local_webdw��ֵ
	// '���룺gg_webdw
	// '�����local_webdw
	public void SetLocalWebDW() {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '������������ȡlocal_webdw��ֵ
	// '����:local_webdw
	// '���:gg_webdw
	public void GetLocalWebDW() {
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '�رյ�ǰ�����ݴ���
	public int CloseDW() {
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

	// '���������ݴ��ڵ�ˢ�·���
	public int DrawChildDW() {
		if (!(childDW == null)) {
			childDW.DrawDW();
		}
		return 0;
	}

	public int DrawColumn(int lineNum) {
		return DrawColumn(lineNum, 0);
	}

	// '���ı���ķ���
	// 'lineNum �кţ���1��ʼ���ı���ֻ��detail������ƣ���������������
	// 'leftpos ��ƫ��������������ƫ��leftpos<0
	public int DrawColumn(int lineNum, int leftPos) {

		int id = 0;
		String sname = "";
		MyJTextField obj = null;
		int top = 0;
		int iborder = 0;
		String svalue = "";
		MyFont stf = new MyFont();// ����֧��
		int beginRowid = 0;
		double convertRate = 4;
		String rowstate = "";

		beginRowid = VScroll_Line.getValue() + 1;
		convertRate = GF_GetConvertRate(targetControls);
		rowstate = webdwData.GetRowState(lineNum, iret);
		if (iret.intvalue == -1) {// Then
			return -1;
		}

		for (id = 1; id <= 100; id++) {
			if (local_webdw.column[id].Name.equals("")) {// '����Ϊ�գ��˳����е�ִ�У�����ѭ��
				continue;
			}

			if (lineNum == 0) {// '�ؼ�������ͷ�����ƣ�����ѭ��
				continue;
			}

			// '�ȼ����ǩ��topֵ���Դ����ж��Ƿ���Ҫ�����������󲢻���֮
			top = (int) (local_webdw.column[id].y * convertRate)
					+ (int) (local_webdw.header.height * convertRate)
					+ (int) (local_webdw.detail.height * convertRate)
					* (lineNum - beginRowid);

			if (top <= 0 || top > targetPict.getHeight()) {
				continue;
			}

			if (top >= 0 && top <= local_webdw.header.height * convertRate
					&& !(local_webdw.column[id].band.equals("header"))) {
				continue;
			}

			// '�ж϶����ƫ�ƣ����Ƿ�Ҫ����
			if (((local_webdw.column[id].x + local_webdw.column[id].width)
					* convertRate + leftPos < 0)
					|| (local_webdw.column[id].x * convertRate + leftPos > targetPict.Width)) {
				continue;
			}

			sname = targetPict.getName() + "__" + lineNum + "__"
					+ local_webdw.column[id].Name;

			svalue = webdwData.GetItemString(lineNum, id);// '�õ�ԭʼ��Ϣ����

			// �����Ƿ����Ӵ������ж�
			if (InStr(targetPict.Name, "PictureChild") <= 0) {
				obj = new WebDW_DymaTextField("", sname, targetControls,
						targetPict);
			} else {
				obj = new ChildDW_DymaTextField("", sname, targetControls,
						targetPict);

			}

			controlSeg = controlSeg + 1;
			myControls[controlSeg] = obj;

			iborder = (int) GF_IF_Long((int) local_webdw.column[id].border > 0,
					1, 0);// '�Ƿ��б߿�

			// log("left:" + ((local_webdw.column[id].x * convertRate +
			// leftPos))
			// + " top:" + top + " width:"
			// + (local_webdw.column[id].width * convertRate) + " height:"
			// + (local_webdw.column[id].height * convertRate));
			obj.setBounds(
					(int) ((local_webdw.column[id].x * convertRate + leftPos)),
					(int) (top),
					(int) (local_webdw.column[id].width * convertRate),
					(int) (local_webdw.column[id].height * convertRate));
			if (iborder > 0) {
				obj.setBorder(BorderFactory.createEtchedBorder());
			} else {
				obj.setBorder(null);
			}

			obj
					.setHorizontalAlignment(GF_GetAlignType(local_webdw.column[id].alignment));
			// TODO:���ݸ�ʽ���Ĺ��������
			// If local_webdw.column[id].format <> "[general]" And
			// IsNumeric(svalue) Then
			// .text = displayformate.GetFormateDecimal(svalue,
			// local_webdw.column[id].format) '��ʾ��ǰ���ݵ�δ��ʽ������
			// End If

			// TODO: JLabel�ı���ɫ�ƺ���������
			if (local_webdw.column[id].background_mode == 2) {// Then
				// '����͸����ʾģʽ��ȡ��ǩ��ɫ
				// Color c1 = GF_GetJavaColor((int) GF_GetVBColor(
				// local_webdw.column[id].background_color,
				// 256 * 256 * 256 - 1));
				// obj.setBackground(c1);
				System.out.println(obj.getBackground().getRed());
				System.out.println(obj.getBackground().getGreen());
				System.out.println(obj.getBackground().getBlue());
				obj.validate();
				obj.repaint();
			} else {
				// obj.setOpaque(true);
			}
			// TODO:ǰ��ɫĿǰҲ����Ч���Ժ�����ϸ����
			// Color c2 = GF_GetJavaColor((int) GF_GetVBColor(
			// local_webdw.column[id].color, 256 * 256 * 256 - 1));
			// obj.setForeground(c2);

			// '���Ӷ������֧��
			stf.Bold(local_webdw.column[id].font.weight > 500);
			stf.Italic(local_webdw.column[id].font.italic > 0);
			stf.Name(local_webdw.column[id].font.face);
			stf.Size((int) (local_webdw.column[id].font.height * -1
					* convertRate / 0.15));

			obj.setFont(stf.stf);
			obj.setText(svalue);

			if ((local_webdw.column[id].tabsequence == 32766)
					&& (!rowstate.equals("new"))) {
				obj.Locked(true);
			}
			obj.setVisible(true);

			// 'Add by Liujunsong 2009-1-23 ���Ӷ�Edit Style��֧��
			// '�����һ��ָ������ʾ��ʽ����ô�ڽ����Ͻ����ݽ��и�ʽ�����
			// '�����һ��ָ����Ҫ������ת�������ƣ���ô������ʾʱ����ת��
			// '�ȿ��������б�ת����֧��

			// '���ӵ�ѡ��ť��֧��20090123
			// Dim valuestring As String
			String valuestring = "";
			valuestring = local_webdw.table.Columns[id].values;// '�õ�values��ʾ

			// valuestring = local_webdw.table.Columns(id).values '�õ�values��ʾ
			//	        
			// '--------------------------��ѡ��༭���֧�ֿ�ʼ-----------------------------
			WebDW_DymaRadioButton radioobj;
			MyJPanel frameObj;
			ButtonGroup bg;
			String value[];
			int radioid = 0;
			String radioValue = "";
			String radioDisplay = "";
			int tabpos;
			// If valuestring > "" And _
			// local_webdw.column[id].radiobuttons.Columns > 0 Then '�ǵ�ѡ��ť�༭���
			// '����ǵ�ѡť�����Ҫ�ȴ���һ������������������
			if (valuestring.length() > 0
					&& local_webdw.column[id].radiobuttons.Columns > 0) {
				sname = targetPict.getName() + "__" + lineNum + "__"
						+ local_webdw.column[id].Name + "__" + "Frame";
				// Set frameObj = targetControls.Add("VB.Frame", sname,
				// targetPict)
				frameObj = new MyJPanel(sname, targetControls, targetPict);

				controlSeg = controlSeg + 1;
				myControls[controlSeg] = frameObj;
				frameObj.setBounds(obj.getX(), obj.getY(), obj.getWidth()
						- (int) (10 * convertRate), obj.getHeight());

				frameObj.setBackground(obj.getBackground());
				frameObj.setVisible(true);
				obj.setVisible(false);

				bg = new ButtonGroup();
				//	                
				// 'Ȼ��������������Ļ�����������ѡ��ť
				value = Split(valuestring, "/");
				for (radioid = 0; radioid <= UBound(value); radioid++) {
					if (value[radioid].length() == 0) {
						break;
					}

					tabpos = InStr(1, value[radioid], Chr(9));// 'value��Tab����λ��
					if (tabpos > 0) {
						radioDisplay = Left(value[radioid], tabpos - 1);
						radioValue = Mid(value[radioid], tabpos + 1,
								Len(value[radioid]) - tabpos);
					} else {
						radioDisplay = "";
						radioValue = "";
						break;// '���ݸ�ʽ������������е���ʾ
					}
					//	                    
					sname = targetPict.Name + "__" + lineNum + "__"
							+ local_webdw.column[id].Name + "__" + radioValue;

					radioobj = new WebDW_DymaRadioButton(radioDisplay, sname,
							targetControls, frameObj);
					bg.add(radioobj);

					radioobj.Tag = radioValue;// '�Ѷ�Ӧֵ����tag��������
					radioobj.setBounds((int) (10 * convertRate),
							(int) ((30 + 60 * radioid) * convertRate),
							(int) (obj.getWidth() - 40 * convertRate),
							(int) (50 * convertRate));
					radioobj.setBackground(obj.getBackground());
					radioobj.setForeground(obj.getForeground());
					radioobj.setVisible(true);
					// '���ݵ�ǰ�ֶε����ݣ���radioobj��������ݱȽϣ������ͬ��������ѡ��״̬
					radioobj.Value(radioValue.equals(svalue));
					//	                    
					// '���Ӷ�tabsequence��֧��20090206
					if ((local_webdw.column[id].tabsequence == 32766)
							&& !(rowstate.equals("new"))) {
						radioobj.Enabled(false);
					}
				}
			}
			// '------------------------��ѡ��༭������----------------------------------------
			//	        
			// '------------------------ѡ���༭���ʼ----------------------------------------
			// Dim myCheckBox As checkbox
			WebDW_DymaCheckBox myCheckBox;
			if (valuestring.length() > 0
					&& local_webdw.column[id].checkbox.text.length() > 0) {
				sname = targetPict.Name + "__" + lineNum + "__"
						+ local_webdw.column[id].Name + "__CheckBox";

				// '������֮�������¶���һ��������Ϊ��obj������
				myCheckBox = new WebDW_DymaCheckBox(
						local_webdw.column[id].checkbox.text, sname,
						targetControls, targetPict);
				controlSeg = controlSeg + 1;
				myControls[controlSeg] = myCheckBox;// '�洢���ڿؼ���ָ��
				//	            
				myCheckBox.Top(obj.Top);
				myCheckBox.Left(obj.Left);
				myCheckBox.Width(obj.Width);
				myCheckBox.Height(obj.Height);

				myCheckBox.Value(GF_IF_Long(local_webdw.column[id].checkbox.on
						.equals(svalue), 1, 0) == 1);

				myCheckBox.setBackground(obj.getBackground());
				myCheckBox.setForeground(obj.getForeground());
				// '���Ӷ�tabsequence��֧��

				if ((local_webdw.column[id].tabsequence == 32766)
						&& !(rowstate.equals("new"))) {
					myCheckBox.Enabled(false);
				}
				obj.setVisible(false);
			}
			// '------------------------ѡ���༭������----------------------------------------
			//	        
			// '------------------------�����б��༭������----------------------------------------

			WebDW_DymaComboBox myComboBox;
			String combovalues[] = new String[1];
			String combostring;
			int combotabpos;
			String combo_display;
			String combo_value;
			int combo_id;

			if ((valuestring.length() > 0 && (local_webdw.column[id].combobox.allowedit
					.length() > 0))) {
				sname = targetPict.Name + "__" + lineNum + "__"
						+ local_webdw.column[id].Name + "__ComboBox";
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
					if (combovalues[combo_id].equals("")) {
						break;// Exit For
					}

					combotabpos = InStr(1, combovalues[combo_id], Chr(9));
					if (combotabpos > 0) {
						combo_display = Mid(combovalues[combo_id], 1,
								combotabpos - 1);
						combo_value = Mid(combovalues[combo_id],
								combotabpos + 1);
						myComboBox.addItem(combo_display);// combo_id
						if (combo_value.equals(svalue)) {// = svalue Then
							// '�����ֵ��ͬ��������ListIndex
							myComboBox.setSelectedItem(combo_display);

						}
					}

				}
				// '���Ӷ�tabsequence��֧��20090206
				if ((local_webdw.column[id].tabsequence == 32766)
						&& !(rowstate.equals("new"))) {
					myComboBox.Enabled(false);
				}
				obj.setVisible(false);
			}

			// '------------------------�����б��༭������----------------------------------------
			//	        
			// '------------------------�������ݴ��ڱ༭����֧��------------------------------------

			if (local_webdw.column[id].dddw.Name.length() > 0
					&& local_webdw.column[id].dddw.DataColumn.length() > 0
					&& local_webdw.column[id].dddw.DisplayColumn.length() > 0
					&& local_webdw.column_dddw_syntax[id].length() > 0
					&& local_webdw.column_dddw_data[id].length() > 0) {
				// '���������ݴ����У������ƶ����н��м���������ҵ���ֵ�������������ʾ
				childDW.DW_SetDataObject(targetControls, childPict, targetPict,
						local_webdw.column_dddw_syntax[id], false, true);
				childDW.webdwData.InitData(local_webdw.column_dddw_data[id]);
				int rowid;
				int sourcecolid;
				int displayColId;
				sourcecolid = childDW.webdwData
						.GetColIdByName(local_webdw.column[id].dddw.DataColumn);
				displayColId = childDW.webdwData
						.GetColIdByName(local_webdw.column[id].dddw.DisplayColumn);
				if (sourcecolid > 0 && displayColId > 0) {
					for (rowid = 1; rowid <= childDW.DW_RowCount(); rowid++) {
						if (childDW.webdwData.GetItemString(rowid, sourcecolid)
								.equals(svalue)) {
							obj.Text(childDW.webdwData.GetItemString(rowid,
									displayColId));
							break;
						}
					}
				}

				// '����Ӵ��ڵ��������������֣���Ϊ���ɼ�(����һ����ʱ�ԵĴ�ʩ���Ժ��ٵ���)
				if (childDW != null) {// Is Nothing Then
					childDW.CloseDW();
				}
			}

			// End If
			// '------------------------�������ݴ��ڱ༭����֧�ֽ���---------------------------------

			// continueNext:
		}
		return 0;
	}

	public int DrawLabel(int lineNum) {
		return DrawLabel(lineNum, 0);
	}

	// '����ǩ�ķ���
	// 'targetControls Ŀ�괰������û��ؼ��Ŀؼ�����
	// 'pictTarget Ŀ��ͼƬ��
	// 'lineNum �к�0������Ʊ�ͷ���������������к�
	// 'leftpos ����Ԫ�ص���ƫ���� leftpos <=0
	// 'ͼ��������Դ: g_webdw
	public int DrawLabel(int lineNum, int leftPos) {
		int id = 0;
		String sname = "";
		MyJLabel obj = null;
		int top = 0;
		int beginRowid = 0;
		double convertRate = 0;

		beginRowid = VScroll_Line.getValue() + 1;
		convertRate = GF_GetConvertRate(targetControls);

		for (id = 1; id <= 100; id++) {
			if (local_webdw.text[id].Name.equals("")) {
				return 0;
			}

			if (lineNum == 0 && (!local_webdw.text[id].band.equals("header"))) {// '����ͷ����band��Ϊheader,�˳�
				continue;
			}

			if (lineNum > 0 && (!local_webdw.text[id].band.equals("detail"))) {// '����ϸ�ڣ�band��Ϊdetail,�˳�
				continue;
			}

			// '�ȼ����ǩ��topֵ���Դ����ж��Ƿ���Ҫ�����������󲢻���֮
			if (local_webdw.text[id].band.equals("header")) {
				top = (int) (local_webdw.text[id].y * convertRate);
			}
			if (local_webdw.text[id].band.equals("detail")) {
				top = (int) (local_webdw.text[id].y * convertRate)
						+ (int) (local_webdw.header.height * convertRate)
						+ (int) (local_webdw.detail.height * convertRate)
						* (lineNum - beginRowid);
			}

			// '����topֵ�����жϣ�������ֵ������targetPict�ķ�Χ������������ѭ��
			if (top <= 0 || top > targetPict.getHeight()) {
				continue;
			}

			if (top >= 0 && top <= local_webdw.header.height * convertRate
					&& (!local_webdw.text[id].band.equals("header"))) {
				continue;
			}

			// 'Ϊ�˱��ⴴ����Ч�Ŀؼ����������ڵ�ǰ����ɼ���Χ�ڵĿؼ�����
			// '�кŵ��ж���DrawDW�н���
			// '�˴����ж�width�Ƿ񳬱�

			if ((local_webdw.text[id].x + local_webdw.text[id].width)
					* convertRate + leftPos < 0
					|| (local_webdw.text[id].x * convertRate + leftPos) > targetPict
							.getWidth()) {
				continue;
			}

			sname = targetPict.getName() + "_" + lineNum + "_"
					+ local_webdw.text[id].Name;
			// '�����ؼ�
			obj = new MyJLabel("", sname, targetControls, targetPict);
			controlSeg = controlSeg + 1;
			myControls[controlSeg] = obj;// '�洢���ڿؼ�������
			obj.setBounds(
					(int) ((local_webdw.text[id].x) * convertRate + leftPos),
					(int) (top),
					(int) (local_webdw.text[id].width * convertRate),
					(int) (local_webdw.text[id].height * convertRate));
			// obj.setBorder(null);
			obj
					.setHorizontalAlignment(GF_GetAlignType(local_webdw.text[id].alignment));

			// '���Ӷ���ɫ��֧��20081219�����
			obj.setOpaque(false);
			// TODO: JLabel�ı���ɫ�ƺ���������
			if (local_webdw.text[id].background_mode == 2) {// Then
				// '����͸����ʾģʽ��ȡ��ǩ��ɫ
				// Color c1 = GF_GetJavaColor((int) GF_GetVBColor(
				// local_webdw.text[id].background_color,
				// 256 * 256 * 256 - 1));
				// obj.setBackground(c1);
				// System.out.println(obj.getBackground().getRed());
				// System.out.println(obj.getBackground().getGreen());
				// System.out.println(obj.getBackground().getBlue());
				obj.validate();
				obj.repaint();
			} else {
				obj.setOpaque(true);
			}
			// TODO:ǰ��ɫĿǰҲ����Ч���Ժ�����ϸ����
			// Color c2 = GF_GetJavaColor((int) GF_GetVBColor(
			// local_webdw.text[id].color, 256 * 256 * 256 - 1));
			// obj.setForeground(c2);

			// '���Ӷ������֧��20081219�����
			MyFont stf = new MyFont();
			stf.Bold(local_webdw.text[id].font.weight > 500);
			stf.Italic(local_webdw.text[id].font.italic > 0);
			stf.Name(local_webdw.text[id].font.face);
			stf
					.Size((int) (local_webdw.text[id].font.height * -1
							* convertRate / 0.18));
			obj.setFont(stf.stf);

			// ��������,����ǩ�����е�\r\nת��<BR>�Իس���ʾ
			// ���ֻ��еķ�ʽ���Ǻ����,��ʱ����ô����һ����
			obj.setText("<HTML>"
					+ Replace(local_webdw.text[id].text, "\r\n", "<BR>")
					+ "</HTML>");
			obj.setVisible(true);
		}
		return 0;
	}

	public int DrawLine(int lineNum) {
		return DrawLine(lineNum, 0);
	}

	// '�ڽ����ϻ��ߵķ���
	// 'ͨ���������֧���ڽ����Ͻ��л���
	// 'leftpos ��ƫ���� leftpos<=0
	public int DrawLine(int lineNum, int leftPos) {
		int id = 0;// As Long
		String sname = "";// As String
		// Dim obj As Control
		// Dim top As Long
		// Dim beginRowid As Long
		// Dim convertRate As Double
		//	    
		// beginRowid = VScroll_Line.value + 1
		// convertRate = GF_GetConvertRate(targetControls)
		//	    
		// For id = 1 To 100
		// If local_webdw.lineinfo(id).Name = "" Then
		// DrawLine = 0
		// Exit Function
		// End If
		//	        
		// If lineNum = 0 And local_webdw.lineinfo(id).band <> "header" Then
		// '����ͷ����band��Ϊheader,�˳�
		// GoTo continueNext
		// End If
		//	        
		// If lineNum > 0 And local_webdw.lineinfo(id).band <> "detail" Then
		// '����ϸ�ڣ�band��Ϊdetail,�˳�
		// GoTo continueNext
		// End If
		//	        
		// '�ȼ����ǩ��topֵ���Դ����ж��Ƿ���Ҫ�����������󲢻���֮
		// If local_webdw.lineinfo(id).band = "header" Then top =
		// local_webdw.lineinfo(id).y1
		// If local_webdw.lineinfo(id).band = "detail" Then
		// top = local_webdw.lineinfo(id).y1 _
		// + local_webdw.header.height _
		// + local_webdw.detail.height * (lineNum - beginRowid)
		// End If
		//	                    
		// '����topֵ�����жϣ�������ֵ������targetPict�ķ�Χ������������ѭ��
		// If top <= 0 Or top * convertRate > targetPict.height Then
		// GoTo continueNext
		// End If
		//	        
		// If top >= 0 And top <= local_webdw.header.height And
		// local_webdw.lineinfo(id).band <> "header" Then
		// GoTo continueNext
		// End If
		//	        
		// '����x1,x2�ж��Ƿ�Ҫ���߳���
		// If local_webdw.lineinfo(id).x1 * convertRate + leftPos < 0 And _
		// local_webdw.lineinfo(id).x2 * convertRate + leftPos < 0 Then
		// GoTo continueNext
		// End If
		//	        
		// If local_webdw.lineinfo(id).x1 * convertRate + leftPos >
		// targetPict.width And _
		// local_webdw.lineinfo(id).x2 * convertRate + leftPos >
		// targetPict.width Then
		// GoTo continueNext
		// End If
		//	        
		// sname = targetPict.Name & "_" & lineNum _
		// & "_" & local_webdw.lineinfo(id).Name
		// controlSeg = controlSeg + 1
		// Set obj = targetControls.Add("VB.Line", sname, targetPict)
		// Set myControls(controlSeg) = obj '�洢���ڿؼ�������
		//	        
		// With obj
		// .y1 = top * convertRate
		// .x1 = local_webdw.lineinfo(id).x1 * convertRate + leftPos '����ƫ����
		// .x2 = local_webdw.lineinfo(id).x2 * convertRate + leftPos '����ƫ����
		// .y2 = (local_webdw.lineinfo(id).y2 + top -
		// local_webdw.lineinfo(id).y1) * convertRate
		// End With
		// obj.Visible = True
		//	    
		// continueNext:
		// Next
		//
		// End Function
		return 0;
	}

	public int DrawGridLine() {
		// TODO:Ǩ�ƴ���ʵ��
		return 0;
	}

	public int DrawDW_ImageOnly() {
		// TODO:Ǩ�ƴ���ʵ��
		return 0;
	}

	// '����DW�ķ���,begId����ʼ���Ƶ�һ��.begId>0
	// 'targetControls: Ŀ��ؼ��ļ��� ����
	// 'targetPict: Ҫ���Ƶ�Ŀ��ͼƬ�� ����
	public int DrawDW() {

		// '���ж��Ƿ�ɹ�������SetDataObject����
		if (targetControls == null || targetPict == null
				|| VScroll_Line == null) {
			// DrawDW = -1
			errString = "Please Call SetDataObject First";
			return -1;
		}

		int rowid = 0;// As Long
		int iret = 0;// As Long
		int i = 0;// As Long
		int childid = 0;// As Long
		int linetop = 0;// As Long
		int beginRowid = 0;// As Long '��ʼ����
		double convertRate = 5;// As Double 'ת������
		int leftPos = 0;// As Long '��ƫ����������vscrollbar������

		// 'step1 �ӽ����϶�ȡ��������������������
		beginRowid = VScroll_Line.getValue() + 1;// '��ʼ���ǵ�ǰ��Value+1
		convertRate = GF_GetConvertRate(targetControls); // '�ӽ����ϵõ�ת������
		leftPos = (int) (HScroll_Page.getValue() * targetPict.getWidth() * -0.5);// '��ƫ����

		// 'step2 ɾ�����пؼ�
		for (i = 10000; i >= 1; i--) {
			if (!(myControls[i] == null)) {// '����ж���һ����ȫ���жϣ��Ա����쳣�������
				targetControls.remove(myControls[i]);
				targetPict.remove(myControls[i]);
				myControls[i] = null;
			}
		}
		targetPict.repaint(); // ˢ��һ�½���,���Ѿ�ɾ���Ŀؼ��ӽ�����ˢ��
		controlSeg = 0;// '��λ���ж���

		// 'step3���Ʊ�ͷ
		iret = DrawLabel(0, leftPos);
		iret = DrawColumn(0, leftPos);
		iret = DrawLine(0, leftPos);

		// 'step4 ���»��Ʊ���
		for (rowid = beginRowid; rowid <= webdwData.GetRowCount(); rowid++) {
			linetop = local_webdw.header.height + local_webdw.detail.height
					* (rowid - beginRowid);
			if (linetop * convertRate > targetPict.getHeight()) {// '����еĿ�ͷ�Ѿ�������targetPict��ֹͣ����
				break;
			}

			iret = DrawLabel(rowid, leftPos);// '������һ�е�Label
			iret = DrawColumn(rowid, leftPos);// '���������е�Column
			iret = DrawLine(rowid, leftPos);// '������һ�е�Line
		}

		// 'step5.����targetPict�ĵ�ɫ
		// targetPict.BackColor = GF_GetVBColor( _
		// local_webdw.datawindow.color, 256# * 256 * 256 - 1)

		// 'step6.���ݵ�ǰ�У���ǰ������һ��ͼ��
		DrawDW_ImageOnly();

		// 'step7.�����grid�����ִ�л��Ʊ���ߵķ���
		DrawGridLine();
		return 0;
	}

	// '�����Ժ���������״̬
	public int AfterUpdate() {
		return webdwData.AfterUpdate();
	}

	// '�������
	public String DW_AddCommand(MyInt iret) {
		String sret = sqlca.AddCommand(iret);
		errString = sqlca.errString;
		return sret;
	}

	// '��������
	public String DW_BeginTransaction(MyInt iret) {
		String sret = sqlca.BeginTransaction(iret);
		errString = sqlca.errString;
		return sret;
	}

	// '�ύ����
	public String DW_Commit(MyInt iret) {
		String sret = sqlca.Commit(iret);
		errString = sqlca.errString;
		return sret;
	}

	// '���ݸ���dw�﷨����ת�������ת���ɹ������ñ��ص�g_webdw����
	// '���ת��ʧ�ܣ�����-1
	public int DW_Create(String dwSyntax) {
		int iret = 0;// As Long
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

	// '����������ɾ����ǰ��
	// '����0 �ɹ�
	// '����-1 ��������
	public int DW_DeleteRow(int rowid) {
		// '�߼��жϣ�����ǰ�ȳ�ʼ�����ݴ��ڿؼ�
		if (targetControls == null || targetPict == null) {
			// DW_DeleteRow = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		// '����������С�ڵ���0��ֱ���˳�
		if (rowid <= 0) {
			return 0;
		}
		int iret = 0;// As Long
		iret = webdwData.DeleteRow(rowid);

		// 'ɾ������ʱ���������˳�
		if (iret == -1) {
			// DW_DeleteRow = -1
			errString = webdwData.errString;
			return -1;
		}

		// '���ù����������ֵ
		if (VScroll_Line.getMaximum() > 0) {
			VScroll_Line.setMaximum(VScroll_Line.getMaximum() - 1);
		}

		// '�������ĵ�ǰ���Ѿ�������������ã��������Ϊ�գ���ǰ��Ϊ0
		if (currentRow > webdwData.GetRowCount()) {
			currentRow = webdwData.GetRowCount();
		}

		DrawDW();// 'ˢ������

		return 0;
	}

	// '------------------------------------------------------------------------------------------------
	// '--------------------------------- sqlca��صķ����������
	// --------------------------------
	// '------------------------------------------------------------------------------------------------
	// '���ص�ǰ������״̬����
	// '1����true 0 ����false
	public int DW_GetAutoCommit() {
		if (autoCommit) {
			return 1;
		} else {
			return 0;
		}
	}

	// '�������ݴ����еĵ�ǰ����
	// 'rowid �к�
	// 'colid �к�
	// '����ֵ����ǰֵ
	public String DW_GetItemString(int rowid, int colid) {
		return webdwData.GetItemString(rowid, colid);
	}

	// '�����������õ���ǰ��
	// 'Ҫ�õ���ǰ�У���Ҫ���뵱ǰ���ڶ����ID��
	public int DW_GetRow() {
		// '���ж�targetControls��targetPict�Ѿ�������ֵ
		if (targetControls == null || targetPict == null) {
			// DW_GetRow = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		return currentRow;
	}

	// '�õ�sqlca��Ӧ��ServerURL
	public String DW_GetServerURL() {
		return G_ServerURL;
	}

	// '�õ����Ҫ�ύ����̨�ĸ������ݿ�������
	// '��������֮����chr(13)chr(10)���ָ�
	// 'Ŀǰ��֧�ֵ���ĸ��²�������Ҫ��SQL����
	public String DW_GetSQLPreview(MyInt iret) {

		// 'step1 ����Ƿ�����˳�ʼ��
		// '���ж�targetControls��targetPict�Ѿ�������ֵ
		if (targetControls == null || targetPict == null) {
			// W_GetSQLPreview = ""
			iret.intvalue = -1;
			errString = "Please Call SetDataObject First.";
			return "";
		}

		String stable = "";// As String '���ݱ�����

		if (!local_webdw.table.retrieve.pbselect.table[2].equals("")) {// 'Ŀǰ��֧�ֵ�������Ƕ���˳�
			iret.intvalue = 0;
			return "";
		}

		if (local_webdw.table.retrieve.pbselect.table[1].equals("")) {// '�����һ������Ϊ�գ��˳�
			iret.intvalue = -1;
			// DW_GetSQLPreview = ""
			errString = "ERROR: no table define";
			return "";
		}
		stable = local_webdw.table.retrieve.pbselect.table[1];
		stable = Replace(stable, "~" + "\"", ""); // '�õ��������滻�����е�~"

		return webdwData.GetUpdateSql(stable, iret);

	}

	// '�õ���ǰ��Select��䶨��
	// '���жϸ�Ŀ¼�µ�SelectSql����
	// '���Ϊ�գ�ȡwebdwdata���ص�SQL����
	public String DW_GetSQLSelect() {
		String strsql = "";// As String

		if (local_webdw.SelectSQL.equals("")) {
			strsql = webdw.GetRetrieveSQL();
		} else {
			strsql = local_webdw.SelectSQL;
		}

		return strsql;
	}

	// '�õ����ݴ��ڵ��﷨��ʾ
	// '����iret 0 ����ɹ� -1 ����ʧ��
	public String DW_GetSyntax(MyInt iret) {
		String sret = webdw.GetSyntaxString(iret);
		if (iret.intvalue == -1) {
			errString = webdw.errString;
		}
		return sret;
	}

	// '�����ݴ����в���һ����¼������������¼�ĵ�ǰ�кţ������������-1
	// 'rowid����Ҫ������кţ����Ϊ0������������
	public int DW_InsertRow(int rowid) {
		// 'step1 �ж��Ƿ��ʼ��
		if (targetControls == null || targetPict == null) {
			// DW_InsertRow = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		String emptystring = "";// As String
		int colid = 0;// As Long
		int colNum = 0;// As Long
		colNum = webdwData.GetColumnNumber();
		emptystring = "";
		for (colid = 1; colid <= colNum; colid++) {
			if (emptystring.equals("")) {
				emptystring = " ";
			} else {
				emptystring = emptystring + Chr(9) + "";
			}
		}

		int iret = 0;// As Long
		iret = webdwData.InsertRow(rowid, emptystring);

		if (iret == -1) {
			errString = webdwData.errString;
		} else {
			VScroll_Line.setMaximum(VScroll_Line.getMaximum() + 1);
		}

		DrawDW();
		return iret;
	}

	public int DW_Retrieve() {
		return DW_Retrieve("");
	}

	// '���ݴ��ڵļ������ܣ��ȼ۹���dw.Retrieve()
	// 'ǰ���������Ѿ�������datawindow����
	// 'args�Ǽ������õĲ�������������֮����TAB���ָ�
	// '20090116�Բ��������޸ģ�targetControls��targetPict������Ҫ�ⲿ����
	public int DW_Retrieve(String args) {

		// '���ж�targetControls��targetPict�Ѿ�������ֵ
		if (targetControls == null || targetPict == null) {
			// DW_Retrieve = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		String strsql = "";// As String
		String sdata = "";// As String
		String argArray[] = new String[1];// As Variant
		String arg = "";// As Variant
		String sarg = "";// As String
		int argid = 0;// As Long
		// int iret=0;// As Long

		// 'strsql = webdwReader.GetRetrieveSQL() '�õ������õ�SQL���
		strsql = DW_GetSQLSelect();

		// '�滻�����Զ������
		argArray = Split(args, "" + Chr(9));
		argid = 1;
		for (argid = 1; argid <= argArray.length; argid++) {
			sarg = argArray[argid - 1];
			strsql = Replace(strsql, ":arg" + argid, sarg);
		}

		// 'sqlca.beginPos = 0
		// 'sqlca.readNum = 1000
		sqlca.Eval("SetCommand(" + strsql + ")", iret);
		sdata = sqlca.ExecuteSelect(iret);// 'ִ��sql,�õ����ݽ��

		if (iret.intvalue == -1) {
			// DW_Retrieve = -1
			errString = sqlca.errString;
			return -1;
		}
		// '���������ݣ���ʼ�����ݴ���
		SetData(sdata);
		int i = DrawDW();
		return i;
	}

	// '�ع�����'iret�Ƿ��ز���0 ���� -1 ʧ��
	public String DW_Rollback(MyInt iret) {
		String sret = sqlca.Rollback(iret);
		errString = sqlca.errString;
		return sret;
	}

	//	
	// '�õ���ǰDataWindow�ڵļ�¼����
	// '����-1����ʧ��
	// '�����������ֵ>=0
	public int DW_RowCount() {
		// 'step1 �ж��Ƿ��ʼ��
		if (targetControls == null || targetPict == null) {
			// DW_RowCount = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}
		return webdwData.GetRowCount();
	}

	// '���õ�ǰ������״̬����
	// '1 �Զ�����
	// '0 �ֹ�����
	public int DW_SetAutoCommit(int flag) {
		// Dim iret As Long
		String transid = "";

		transid = sqlca.Eval("GetTransId", iret);

		if (flag == 1) {// Then 'Ҫ����Ϊ�Զ�����
			if (!autoCommit) {// Then '��ǰ״̬Ϊ���Զ�����
				if (!transid.equals("")) {// Then '��ǰ��������
					sqlca.Rollback(iret);// '�ع���ǰ����
				}
				autoCommit = true;// '����Ϊ�Զ�����
			}
		} else { // 'Ҫ����Ϊ�ֹ�����
			if (autoCommit) {// '��ǰΪ�Զ�����
				if (!transid.equals("")) {// '��ǰ��������
					sqlca.Rollback(iret);// '�ع���ǰ����
				}
				autoCommit = false;// '����Ϊ�ֹ�����
			}
		}
		return 0;
	}

	// public int DW_SetDataObject(List targetControlsArg, MyJPanel
	// targetPictArg,
	// MyJPanel parentPict,String sUIDesc) {
	// return DW_SetDataObject(targetControlsArg, targetPictArg,
	// parentPict,sUIDesc, true);
	// }

	// '����dataobject����dataobject������һ���ַ���������
	// '����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
	// '����ͨ�������������з���
	// 'childflag �Ƿ���������ݴ��ڵı�־λ true ���� false �������Ӵ���
	public int DW_SetDataObject(java.util.List targetControlsArg,
			MyJPanel targetPictArg, MyJPanel parentPict, String sUIDesc,
			boolean childFlag, boolean createflag) {
		try {
			double convertRate = 0;// As Double
			// 'step1: ���ö��������
			// '���ȰѶ���ͽ����ϵĿؼ���������
			// 'ȷ����Щ������ʵ�ʴ��ڵ�
			// 'Ϊ�˼򻯳���Ľṹ��Ŀǰ�ݲ����Ƕ�̬������Щ���пؼ�
			//	    
			// 'step1.����targetControls��targetPict����������
			if (targetControlsArg == null) {
				errString = "Cannot set targetControls";
				throw new Exception("error");
			}

			if (targetPictArg == null) {
				errString = "Cannot set targetPict";
				throw new Exception("error");
			}

			if (parentPict == null) {
				errString = "Cannot set parentPict";
				throw new Exception("error");
			}
			targetControls = (ArrayList) targetControlsArg;
			targetPict = targetPictArg;
			targetPict.Refresh();

			// 'step1.2 set vscroll_page
			VScroll_Page = (MyJScrollBar) GF_GetObjectByName(targetControls,
					targetPict.getName() + "_Vscroll_Page");
			if (VScroll_Page == null) {
				if (!createflag) {
					errString = "Cannot find Vscroll_Page";
					throw new Exception("error");
				} else {
					VScroll_Page = new WebDW_DymaVscroll_Page(targetPict.Name
							+ "_Vscroll_Page", targetControls, parentPict);
					VScroll_Page.Left(targetPict.Top + targetPict.Width + 20);
					VScroll_Page.Top(targetPict.Top);
					VScroll_Page.Width(20);
					VScroll_Page.Height(targetPict.Height - 20);
					VScroll_Page.setVisible(true);
				}
			}

			// 'step1.3 set vscroll_line
			VScroll_Line = (MyJScrollBar) GF_GetObjectByName(targetControls,
					targetPict.getName() + "_Vscroll_Line");
			if (VScroll_Line == null) {
				if (!createflag) {
					errString = "Cannot find Vscroll_Line";
					throw new Exception("error");
				} else {
					VScroll_Line = new WebDW_DymaVscroll_Line(targetPict.Name
							+ "_Vscroll_Line", targetControls, parentPict);
					VScroll_Line.Left(targetPict.Top + targetPict.Width);
					VScroll_Line.Top(targetPict.Top);
					VScroll_Line.Width(20);
					VScroll_Line.Height(targetPict.Height - 20);
					VScroll_Line.setVisible(true);
				}
			}

			// 'step1.4 set hscroll_page
			HScroll_Page = (MyJScrollBar) GF_GetObjectByName(targetControls,
					targetPict.getName() + "_HScroll_Page");
			if (HScroll_Page == null) {
				if (!createflag) {
					errString = "Cannot find HScroll_Page";
					throw new Exception("error");
				} else {
					HScroll_Page = new WebDW_DymaHscroll_Page(targetPict.Name
							+ "_HScroll_Page", targetControls, parentPict);
					HScroll_Page.Left(targetPict.Left);
					HScroll_Page.Top(targetPict.Top + targetPict.Height);
					HScroll_Page.Width(targetPict.Width);
					HScroll_Page.Height(20);
					HScroll_Page.setVisible(true);
				}

			}

			// //'step1.5 set ImagePoint������ǰ�б�ʾ��ͼ��
			// Set ImagePoint = GF_GetObjectByName(targetControls,
			// targetPict.getName() + "_ImagePoint")
			// If ImagePoint Is Nothing Then
			// errString = "Cannot find ImagePoint"
			// GoTo SETDATAOBJECTERROR
			// End If

			// 'step1.6 set ChildPict�����������ݴ���
			childPict = (MyJPanel) GF_GetObjectByName(targetControls,
					"PictureChild");
			if (childPict == null && childFlag) {
				errString = "ChildFlag Is True ,While Cannot find PictureChild";
				throw new Exception("error");
			}

			// 'step1.7 �õ����涨���ļ��ͽ���Ԫ��֮���ת����������
			convertRate = GF_GetConvertRate(targetControls);

			// 'step2:��ʼ�������ʾ,��ʼ������Ժ󣬽�����Ϣ�洢��g_webdw������
			int iret = 0;
			String columnString = "";// As String
			iret = webdw.Create(sUIDesc);

			if (iret == -1) {// '����������󣬽ػ�����׳������쳣?��
				errString = webdw.errString;
				throw new Exception("error");
			}

			// '�����ʼ���ɹ�����ô��Ҫͨ�����ñ���GG_webdw���������ݴ���
			webdw.GetLocalWebDW();// '����gg_webdw����ֵ
			SetLocalWebDW();// '���ñ���g_webdw����ֵ

			// '���÷����������������ʽ���ݴ��ڣ����ö�ȡ��Ϣ
			if (childFlag) {// Then
				retrieveChildDW();// '�������е��Ӵ���
			}
			// 'step3:��ʼ�����ݴ洢����ʼ����Ϻ�ʵ�����ݴ洢��webdwData�����ˣ�����ͨ������������
			columnString = webdw.GetColumnDefineString();
			iret = webdwData.InitData(columnString);// '�����ַ��������г�ʼ��,�������ʱ���ܳɹ�

			if (iret == -1) {// '����������󣬽ػ�����׳������쳣?��
				errString = webdwData.errString;
				throw new Exception("error");
			}

			// 'step4:����VscrollBar,HscrollBar
			VScroll_Line.Max(0);// .Max = 0
			VScroll_Line.Min(0);// .Min = 0
			VScroll_Line.Value(0);// value = 0
			VScroll_Line.setVisible(true);// .Visible = True

			VScroll_Page.Max(0);// .Max = 0
			VScroll_Page.Min(0);// .Min = 0
			VScroll_Page.Value(0);// .value = 0
			VScroll_Page.setVisible(false);// .Visible = False

			// '���������������hscroll������
			int maxwidth = 0;// As Long
			maxwidth = (int) (webdw.getMaxWidth() * convertRate);
			if (maxwidth <= targetPict.getWidth()) {
				// HScroll_Page.setEnabled(false);
				HScroll_Page.Min(0);// .Min = 0
				HScroll_Page.Max(0);// .Max = 0
				HScroll_Page.SmallChange(1);
				HScroll_Page.LargeChange(1);
				HScroll_Page.Value(0);// .value = 0
				HScroll_Page.setEnabled(false);// .Enabled = False
			} else {
				// HScroll_Page.setEnabled(false);
				HScroll_Page.Min(0);
				HScroll_Page.Value(0);
				HScroll_Page.Max((int) ((maxwidth - targetPict.getWidth()) * 2
						/ targetPict.getWidth() + 2));
				HScroll_Page.SmallChange(1);// .SmallChange = 1
				HScroll_Page.LargeChange(2);// .largechange = 2
				HScroll_Page.setEnabled(true);// .Enabled = True
			}

			// 'step 5����ͼ�γ���
			currentRow = 0;
			DrawDW();// '�ӵ�һ�п�ʼ����

			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			initAllObjectPoint();
			return -1;
		}
		// SETDATAOBJECTERROR: '���������
		// initAllObjectPoint '��ʼ�����ж���ָ��ΪNothing
		// DW_SetDataObject = -1 '��������

	}

	// 'һ�������ӵĽӿ�,���ܺ�DW_SetDataObject����
	// '��������һ���������һ���ַ���
	// 'һ������������ݴ��ڵ����֣��Ӻ�ֱ̨�Ӽ�������ļ��ٽ��г�ʼ������
	public int DW_SetDataObjectByName(java.util.List targetControlsArg,
			MyJPanel targetPictArg, MyJPanel parentPict, String sdwName,
			boolean childFlag, boolean createFlag) {
		String sUIDefine = "";// As String
		sUIDefine = GetDWSyntaxByName(sdwName);

		if (sUIDefine.equals("")) {
			// DW_SetDataObjectByName = -1
			errString = "Cannot find DW Deine:" + sdwName;
			return -1;
		}

		return DW_SetDataObject(targetControlsArg, targetPictArg, parentPict,
				sUIDefine, childFlag, createFlag);

	}

	// '���������ߵ���ɫ������VB��QBColor����,������ɫ0-15
	// '�����������������账��
	public int DW_SetGridLineColor(int color) {
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

	// '��������,ֻ������PrimaryBuffer������
	public int DW_SetItem(int rowid, int colid, String sdata) {

		int iret = 0;// As Long
		String strinfo = "";// As String
		String coltype = "";// As String
		String stemp = "";// As String
		String sCNinfo = "";// As String
		String sENinfo = "";// As String
		int ColLength = 0;// As Long
		int ipos = 0;// As Long
		int ipos2 = 0;// As Long

		// '�˴������������ݵ�У�鹦�ܣ���ȷ��Ҫ���õ����ݷ���ԭʼ�Ķ���Ҫ��
		// 'ֻ������������������ЩҪ�������£��������������ݣ����򲻽������ݵ�����

		// 'step1:�����ֶγ��ȵ�У������
		// '����һ���ֶγ��ȵ��ж�
		// '�������ĳ����Ѿ����������ݿ�������ɵĳ��ȣ���ô����ʾ������Ϣ
		// '���û��л����Լ�����������
		if (local_webdw.column[colid].edit_limit > 0) {// Then '���������������
			if (GF_GetDBlength(sdata) > local_webdw.column[colid].edit_limit) {// Then
				sCNinfo = "����������ݿ����:" + sdata + "\\r\\n" + "��󳤶�:"
						+ local_webdw.column[colid].edit_limit + "\\r\\n"
						+ "��ǰ����:" + GF_GetDBlength(sdata);
				sENinfo = "Item too large for Database store:" + sdata
						+ "\\r\\n" + "Max length:"
						+ local_webdw.column[colid].edit_limit + "\\r\\n"
						+ "Current length:" + GF_GetDBlength(sdata);
				strinfo = langsupport.SumAllLang(sCNinfo, sENinfo);
				strinfo = langsupport.GetCurrent(strinfo);

				MsgBox(strinfo, 1, "WebDW Error");
				return -1;
			}

		} else {
			// '������������Ϊ0,��ôҪ�ж��Ƿ����ַ���,������ַ���,ȡ�����������ж���ĳ��������г��������ж�
			coltype = local_webdw.table.Columns[colid].type;// '�õ���������
			if (InStr(coltype, "char") > 0) {// Then
				ipos = InStr(coltype, "(");
				if (ipos > 0) {// Then
					ColLength = toInt(Mid(coltype, ipos + 1, Len(coltype)
							- ipos - 1));// '�ַ����Ŀ�ȶ���,ͬ���ݿ��еĳ��ȶ���,pb�Զ�����ά��
					if (GF_GetDBlength(sdata) > ColLength) {// Then
						sCNinfo = "����������ݿ����:" + sdata + "\\r\\n" + "��󳤶�:"
								+ ColLength + "\\r\\n" + "��ǰ����:"
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

		// 'step2:�������ݵ���������У������
		// '���������������ֵ�ͣ��������������Ƿ�����ֵ��
		coltype = local_webdw.table.Columns[colid].type;// '��������
		// '���������������ֵ��
		if ((InStr(coltype, "number") > 0) || (InStr(coltype, "int") > 0)
				|| (InStr(coltype, "long") > 0)
				|| (InStr(coltype, "decimal") > 0)) {// Then
			if (!IsNumeric(sdata)) {// Then
				sCNinfo = "�������Ͳ�ƥ��:" + sdata + "\\r\\n" + "������������:" + coltype;
				sENinfo = "Item not match data type:" + sdata + "\\r\\n"
						+ "Require DataType:" + coltype;

				strinfo = langsupport.SumAllLang(sCNinfo, sENinfo);
				strinfo = langsupport.GetCurrent(strinfo);
				MsgBox(strinfo, 0, "WebDW Error");
				return -1;
			}
		}

		// '�������������long��,���������ݴ���С����������,����ʾ��֧��С��λ
		if (coltype.equals("long") || coltype.equals("int")
				|| coltype.equals("integer") || coltype.equals("smallint")) {// Then
			ipos = InStr(sdata, ".");
			if (ipos > 0) {// Then
				stemp = Mid(sdata, ipos + 1);
				stemp = Trim(stemp);
				if (stemp.length() > 0) {// <> "" Then
					sCNinfo = "�������Ͳ�ƥ��:" + sdata + "\\r\\n" + "�������������Ͳ�֧��С��λ:"
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

		int datatype_jingdu = 0;// As Long '�������Ͷ��徫��
		int data_jingdu = 0;// As Long '�������ݾ���
		// '��������������decimal��,�������ݴ���С��λ,����С��������ݾ��ȳ����˶���,�������ʾ,����ֱ���˳�
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
						sCNinfo = "���ݾ������:" + sdata + "\\r\\n���ݿ⾫��: "
								+ datatype_jingdu + "\\r\\n���ݾ���: "
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

	// '���õ�ǰ��
	public int DW_SetRow(int rowid) {
		if (rowid > 0 && rowid <= DW_RowCount()) {
			currentRow = rowid;
			return 1;// '����1����ɹ�
		} else {
			return -1;// '����-1����ʧ��
		}
	}

	// '���÷�������ַ
	public int DW_SetServerURL(String surl) {
		G_ServerURL = surl;
		return 0;
	}

	// '�������ݴ��ڼ����õ�Select���
	public int DW_SetSQLSelect(String strsql) {
		local_webdw.SelectSQL = strsql;
		return 0;
	}

	// '���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
	// '���õ�g_webdw��ȥ
	// '�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
	// 'iret����ֵ��0 ���� -1 ʧ��
	// '������Ϣ�����errstring��
	// '���������һ��Select����С�ͽ�����
	public String DW_SyntaxFromSQL(String strsql, String stype, MyInt iret) {
		String sret = webdw.SyntaxFromSQL(strsql, stype, iret);
		errString = webdw.errString;
		return sret;
	}

	// 'ִ��Dw��Update����,��������
	// '����0������óɹ�
	// '����-1������÷�������
	// '��targetControls,targetPict���Ӳ�����ȥ��
	public int DW_Update() {

		// 'step1 �ж��Ƿ��ʼ��
		if (targetControls == null || targetPict == null) {
			// DW_Update = -1
			errString = "Please Call SetDataObject First.";
			return -1;
		}

		String strsql = "";// As String
		String sdata = "";// As String
		// int iret =0 ;// As Long

		// 'step1 �õ�UpdateSQL
		strsql = DW_GetSQLPreview(iret);

		if (iret.intvalue == -1) {
			return -1;
		}

		// 'step2 �ύSQL����
		// '�˴���Ҫ�������������ݴ��ڲ���ֱ���ύ
		// '����ͨ��sqlca��commit�����ύ��
		//	    
		// '�������Ϊ�Զ�������ô���Զ���������������������ύ
		String cmds[] = new String[1];// ) As String
		int cmdid = 0;// As Long
		String transid = "";// As String

		transid = sqlca.Eval("GetTransid", iret);

		cmds = Split(strsql, "" + Chr(13) + Chr(10));

		if (autoCommit) {
			if (transid.length() > 0) {// '����Ѿ����������ύ֮
				sqlca.Commit(iret);
			}

			sqlca.BeginTransaction(iret);// '��������
			if (iret.intvalue == -1) {
				// DW_Update = -1
				errString = sqlca.errString;
				return -1;
			}

			for (cmdid = 0; cmdid <= UBound(cmds); cmdid++) {
				sqlca.Eval("Setcommand(" + cmds[cmdid] + ")", iret);// '�������
				sqlca.AddCommand(iret);
			}

			sqlca.Commit(iret);// '�ύ����
			if (iret.intvalue == -1) {
				// DW_Update = -1
				errString = sqlca.errString;
				return -1;
			}
			// '�������ݿ�ɹ��Ժ�Ӧ�������ݵ�״̬�ĵ�
			// '����webdwdata�еķ���
			// 'Ŀǰ��������̶��߲�������Ҫ�����޸�
			webdwData.AfterUpdate();

		} else {// '�ֹ�����״̬������transId>""������ܾ�����
			if (transid.equals("")) {// Then
				// DW_Update = -1
				errString = "Please Call BeginTransaction First";
				return -1;
			}

			for (cmdid = 0; cmdid <= UBound(cmds); cmdid++) {
				sqlca.Eval("Setcommand(" + cmds[cmdid] + ")", iret);// '�������
				sqlca.AddCommand(iret);
			}
			// '�����ڳ�������ʽ�ύ���񷽿�
		}

		return 0;// '�����˳�

	}

	// '20090217�����ӵ�eval����
	// '����ͨ�õ�GetSet������Ϊ�˽���ӿڹ��������
	// '����һһ�ṩGetSet���������Ǽ�����һ��Eval�����н����ṩ
	// '�����Ͱ�sqlca�ṩ�ķ���ȫ������ת����ʵ��
	// 'δ��������Eval���������Ӹ�����ⲿ�ӿ�
	// 'iret�Ƿ��صı�־λ
	// '0����
	// '-1 ʧ��
	public String Eval(String command, MyInt iret) {

		if (command.equals("")) {
			iret.intvalue = 0;
			return "";
		}

		String newcommand = "";

		// '���command��SQLCA��ͷ����ת����sqlca����ȥִ��
		if (UCase(Left(command, Len("sqlca."))).equals(UCase("sqlca."))) {
			newcommand = Mid(command, Len("sqlca.") + 1);// '�зֵõ�Ҫת����sqlcaִ�е�����
			String sret = sqlca.Eval(newcommand, iret);
			errString = sqlca.errString;
			return sret;
		}

		// '���command��Data��ͷ����ôת����webdwdataȥִ��
		if (UCase(Left(command, Len("data."))).equals(UCase("data."))) {
			newcommand = Mid(command, Len("data.") + 1);// '�з�Ҫת����webdwdataִ�е�����
			String sret = webdwData.Eval(newcommand, iret);
			errString = webdwData.errString;
			return sret;
		}

		iret.intvalue = -1;
		errString = "Unknown Command:" + command;
		return "";

	}

	// '����һ�����ݴ��ڵ�����
	// '�Ӻ�̨�������Ķ���
	// '����""����û���ҵ�
	public String GetDWSyntaxByName(String dwname) {
		// Dim iret As Long
		String strdefine = "";// As String

		strdefine = sqlca.GetDWDefine(dwname, iret);// '����������,����������Ϊ��������
		if (iret.intvalue == -1) {
			errString = sqlca.errString;
			return "";
		} else {
			return strdefine;
		}
	}

	// '�����������õ���ǰ�������������������
	// '������Դ:local_webdw
	// '������������������ߵ�Xֵ����������ö��ŷָ����
	// '������Grid����Tabular�������ݴ��ڣ��������ķ���""
	public String GetGridLineInfo() {
		// TODO:��ɴ���Ǩ�ƹ���
		return "";
	}

	// '���ݸ����ĵ�ǰ�ؼ������֣��жϵ�ǰ�����е����
	// '����-1����ʧ�ܣ�>=0�������
	public int GetRowIdColumnId(String currentControlName, MyInt rowid,
			MyInt colid) {
		if (currentControlName.equals("")) {
			return -1;
		}
		int pos1 = 0;// As Long
		int pos2 = 0;// As Long
		int pos3 = 0;// As Long
		pos1 = InStr(1, currentControlName, "__");// '��һ��˫�»��ߵ�λ��
		if (pos1 <= 0) {// Then
			return -1;
		}

		pos2 = InStr(pos1 + 1, currentControlName, "__");// '�ڶ���˫�»��ߵ�λ��
		if (pos2 <= 0) {// Then
			return -1;
		}

		pos3 = InStr(pos2 + 1, currentControlName, "__");// '������˫�»��ߵ�λ�ã�����û��)

		rowid.intvalue = toInt(Mid(currentControlName, pos1 + 2, pos2 - pos1
				- 2));// '�õ��к�

		String columnName = "";// As String
		if (pos3 > 0) {
			columnName = Mid(currentControlName, pos2 + 2, pos3 - pos2 - 2);// '�õ�����
		} else {
			columnName = Mid(currentControlName, pos2 + 2);// '�õ�����
		}

		colid.intvalue = webdw.GetColumnIdByColumnName(columnName);// '�õ��к�
		return 0;
	}

	// '������������ʼ������ָ�����Ԫ�صĶ���ָ��ΪNothing
	// '�������SetDataObjectʧ�ܣ����ʼ�����ж���ָ��
	// '�����ʼ��ʱҲ������һ����
	private int initAllObjectPoint() {
		// '��ʼ��������������ָ��ָ��ΪNothing
		targetControls = null;
		targetPict = null;
		VScroll_Line = null;
		VScroll_Page = null;
		HScroll_Page = null;
		// ImagePoint = null;
		return 0;
	}

	// '�����ж����ַ����ķ���
	// '����ж����ַ�����ʾ�������ƺ��������ͺͳ��ȶ���
	// 'webdwdata������ַ�������ʼ���洢�ṹ
	public int SetColumnDefString(String sColDefString) {
		return webdw.SetColumnDefineString(sColDefString);
	}

	// '����:g_webdw
	// '���:g_webdw
	// '����������������ݴ��ڣ�����ÿ���Ӵ��ڵĶ�������ݣ����g_webdw
	private int retrieveChildDW() {
		int colid;// As Long
		String childDWDefine;//
		String childDWData;//
		MyInt iret = new MyInt(0);// As Long

		// '��ʱ�Ȳ����������ݴ��ڵ�Ƕ�����⣬Ŀǰֻ����һ�������ݴ���
		for (colid = 1; colid <= 100; colid++) {
			childDWDefine = "";
			childDWData = "";
			if (local_webdw.column[colid].dddw.Name.length() > 0) {// Then
				childDWDefine = sqlca.GetDWDefine(
						local_webdw.column[colid].dddw.Name, iret);// '����������

				if (iret.intvalue == 0) {// Then '����������ɹ�
					childDWData = GF_RetrieveBySyntax(childDWDefine);
					local_webdw.column_dddw_syntax[colid] = childDWDefine;// '�洢�Ӵ����﷨����
					local_webdw.column_dddw_data[colid] = childDWData;// '�洢�Ӵ������ݶ���
				}
			}
		}
		return iret.intvalue;
	}

	public int SetData(String indata) {
		return SetData(indata, "normal");
	}

	// '���ø��������ݣ�����ʼ�����ݴ洢
	// 'targetControls �ؼ��ļ���
	// 'pictTarget Ҫ��ͼ�Ŀؼ�
	// 'indata �������õ�����
	// 'datastate ��ѡ��,���ݵ�״̬,Ĭ��Ϊ"normal"
	public int SetData(String indata, String datastate) {
		int iret = 0;// As Long
		double convertRate = 0;// As Double
		int largechange = 0;// As Long

		// '�����жϣ����û�г�ʼ������ִ��
		if (targetControls == null) {
			// SetData = -1
			errString = "Please Call SetDataObject() first!";
			return -1;
		}
		convertRate = GF_GetConvertRate(targetControls);// '�õ�ת������

		iret = webdwData.InitData(indata, datastate);

		if (iret == -1) {
			errString = webdwData.errString;
			return -1;
		}

		if (webdwData.GetRowCount() > 0) {
			VScroll_Line.Max(webdwData.GetRowCount() - 1);
			VScroll_Line.Min(0);// .Min = 0
			VScroll_Line.SmallChange(1);// .SmallChange = 1
			largechange = (int) ((targetPict.getHeight()
					- local_webdw.header.height * convertRate - local_webdw.footer.height
					* convertRate) / (local_webdw.detail.height * convertRate));
			if (largechange < 1) {
				VScroll_Line.LargeChange(1);// .largechange = 1
			} else {
				VScroll_Line.LargeChange(largechange);
			}
			VScroll_Line.setEnabled(true);// .Enabled = True
		} else {
			VScroll_Line.Max(0);
			VScroll_Line.Min(0);// = 0
			VScroll_Line.Value(0);// value = 0
			VScroll_Line.setEnabled(false);// .Enabled = False
		}

		if (webdwData.GetRowCount() > 0 && currentRow == 0) {// Then
			currentRow = 1;
		}// End If

		if (webdwData.GetRowCount() == 0) {// Then
			currentRow = 0;
		}
		return 0;
	}
//	 '���ø����ݴ��ڵľ��
	public int SetParentDW(CWebDWUI pui) {
		parentDW = pui;
		return 0;
	}
	
	class WebDW_DymaVscroll_Page extends MyJScrollBar {
		public WebDW_DymaVscroll_Page(String name, ArrayList targetControls,
				Container parent) {
			super(name, targetControls, parent);
			this.setOrientation(1);
			this.addAdjustmentListener(new AdjustmentListener() {
				public void adjustmentValueChanged(AdjustmentEvent e) {
					DrawDW();
				}
			});
		}
	}

	class WebDW_DymaVscroll_Line extends MyJScrollBar {
		public WebDW_DymaVscroll_Line(String name, ArrayList targetControls,
				Container parent) {
			super(name, targetControls, parent);
			this.setOrientation(1);
			this.addAdjustmentListener(new AdjustmentListener() {
				public void adjustmentValueChanged(AdjustmentEvent e) {
					DrawDW();
				}
			});
		}
	}

	class WebDW_DymaHscroll_Page extends MyJScrollBar {
		public WebDW_DymaHscroll_Page(String name, ArrayList targetControls,
				Container parent) {
			super(name, targetControls, parent);
			this.setOrientation(0);
			this.addAdjustmentListener(new AdjustmentListener() {
				public void adjustmentValueChanged(AdjustmentEvent e) {
					MyJScrollBar bar = (MyJScrollBar) e.getSource();
					bar.Refresh();
					if (bar.isEnabled()) {
						System.out.println("Hscroll value" + bar.Value);
						System.out.println("Hscroll max" + bar.Max);
						System.out.println("HScroll LargerChange:"
								+ bar.LargeChange);
						System.out.println("extent: ");
						DrawDW();
					}
				}
			});
		}
	}

	class WebDW_DymaTextField extends MyJTextField {
		private void updateTextData() {
			System.out.println("enter.");
			Refresh();
			// 'Ϊ�����ظ�������Ч���ܵ��ã����tag="reenter"����ɶҲ����
			if (Tag.equals("reenter")) {
				Tag = "";
				return;
			}
			MyInt rowid = new MyInt(0);
			MyInt colid = new MyInt(0);
			int iret = GetRowIdColumnId(Name, rowid, colid);// '�õ���ǰ�У���ǰ��
			if (iret == 0) {
				iret = DW_SetItem(rowid.intvalue, colid.intvalue, Text);// '��������
				// If iret = -1 Then
				// 'myTextBox.tag = "reenter" '���������־
				// 'myTextBox.text = DW_GetItemString(rowid, colid)
				// 'myTextBox.tag = ""
				// End If
			}
		}

		private void setCurrentRow() {
			MyInt rowid = new MyInt(0);
			MyInt colid = new MyInt(0);
			int iret = GetRowIdColumnId(Name, rowid, colid);// '�õ���ǰ�У���ǰ��
			if (iret == 0) {
				iret = DW_SetRow(rowid.intvalue);
				// If iret = -1 Then
				// 'myTextBox.tag = "reenter" '���������־
				// 'myTextBox.text = DW_GetItemString(rowid, colid)
				// 'myTextBox.tag = ""
				// End If
			}

		}

		public WebDW_DymaTextField(String stext, String name,
				ArrayList targetControlsArg, Container parent) {
			super(stext, name, targetControlsArg, parent);
			this.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					// ����ǵ���,�ж��Ƿ��������ݴ���
					setCurrentRow();
				}
			});

			this.addKeyListener(new KeyListener() {
				public void keyTyped(KeyEvent e) {
				}

				public void keyPressed(KeyEvent e) {
				}

				public void keyReleased(KeyEvent e) {
					setCurrentRow();
					updateTextData();
				}
			});

			this.addMouseListener(new MouseAdapter() {
				/* (non-Javadoc)
				 * @see java.awt.event.MouseAdapter#mouseClicked(java.awt.event.MouseEvent)
				 */
				public void mouseClicked(MouseEvent e) {
					// setCurrentRow();

					// '�����ı����ϵ���ʱ�����õ�ǰ��
					// 'δ������Ԫ�ض���ı༭��������е����ؼ�����
					int iret = 0;// As Long
					MyInt rowid = new MyInt(0);// As Long
					MyInt colid = new MyInt(0);// As Long
					String sdata = "";// As String
					Refresh();
					iret = GetRowIdColumnId(Name, rowid, colid);
					if (iret == 0) {// Then
						if (rowid.intvalue != currentRow) {// Then
							currentRow = rowid.intvalue;
						}
					}

					sdata = DW_GetItemString(rowid.intvalue, colid.intvalue);
					if ((!local_webdw.column[colid.intvalue].format
							.equals("[general]") && IsNumeric(sdata))) {// Then
						Tag = "reenter";
						Text(sdata);// '��ʾ��ǰ���ݵ�δ��ʽ������
						Tag = "";
					}

					// '�����ǰ���趨�ı༭����ǵ������ݴ���
					if (local_webdw.column[colid.intvalue].dddw.Name.length() > 0
							&& local_webdw.column[colid.intvalue].dddw.DataColumn
									.length() > 0
							&& local_webdw.column[colid.intvalue].dddw.DisplayColumn
									.length() > 0
							&& local_webdw.column_dddw_syntax[colid.intvalue]
									.length() > 0
							&& local_webdw.column_dddw_data[colid.intvalue]
									.length() > 0) {

						// '����һ���ж��������ж�tabsequance����ֵ
						if (Locked) {// Then
							// GoTo end_of_sub
						} else {

							// '��ʱ���ټ��������ݴ��ڵ�����
							iret = childDW
									.DW_SetDataObject(
											targetControls,
											childPict,
											targetPict,
											local_webdw.column_dddw_syntax[colid.intvalue],
											False, True);
							if (iret == -1) {// Then
								MsgBox(childDW.errString, 0,
										"childdw setdataobject error");
								return;
							}
							iret = childDW
									.SetData(local_webdw.column_dddw_data[colid.intvalue]);
							if (iret == -1) {// Then
								MsgBox(childDW.errString, 0,
										"childdw setdata error");
								return;
							}

							childDW.parentControlName ( Name);// '���ø����ڵĿؼ�����
							childDW.dataColumnName ( local_webdw.column[colid.intvalue].dddw.DataColumn);// '��������������

							childPict.Left(Left);
							childPict.Top(Top + Height);
							childPict.setVisible(True);
							childPict.Tag(Name);// '��childpict��tag�ֶ���ʱ�洢�����ڵĵ�ǰ�ؼ���
							childDW.DrawDW();

							// Dim obj As vscrollbar

							MyJScrollBar obj = (MyJScrollBar) GF_GetObjectByName(
									targetControls, childPict.Name
											+ "_VScroll_Line");
							if (obj != null) {// Not obj Is Nothing Then
								obj.Left(childPict.Left + childPict.Width);
								obj.Top(childPict.Top);
							}

							// 'myTextBox.Enabled = False
						}
					}
				}
			});
		}
	}

	class ChildDW_DymaTextField extends MyJTextField {
		private void setCurrentRow() {
			MyInt rowid = new MyInt(0);
			MyInt colid = new MyInt(0);
			int iret = GetRowIdColumnId(Name, rowid, colid);// '�õ���ǰ�У���ǰ��
			if (iret == 0) {
				iret = DW_SetRow(rowid.intvalue);
				// If iret = -1 Then
				// 'myTextBox.tag = "reenter" '���������־
				// 'myTextBox.text = DW_GetItemString(rowid, colid)
				// 'myTextBox.tag = ""
				// End If
			}

		}

		public ChildDW_DymaTextField(String stext, String name,
				ArrayList targetControlsArg, Container parent) {
			super(stext, name, targetControlsArg, parent);
			this.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					// ����ǵ���,�ж��Ƿ��������ݴ���
					//setCurrentRow();
				}
			});

			// this.addKeyListener(new KeyListener() {
			// public void keyTyped(KeyEvent e) {
			// }
			//
			// public void keyPressed(KeyEvent e) {
			// }
			//
			// public void keyReleased(KeyEvent e) {
			// setCurrentRow();
			// }
			// });

			this.addMouseListener(new MouseAdapter() {
				public void mouseClicked(MouseEvent e) {
					System.out.println("ChildDW mouse Click.");
					// setCurrentRow();
					// '���ı�������˫����ʱ���������ڸ����ڵĵ�ǰ�е�ǰ�еĶ�Ӧ��ֵ

					int dataColId = 0;// As Long
					String selectdata = "";// As String

					MyInt rowid = new MyInt(0);
					MyInt colid = new MyInt(0);
					int iret = GetRowIdColumnId(Name, rowid, colid);// '�õ���ǰ�У���ǰ��
					if (iret==-1){
						return;
					}
					
					MyInt pcolId = new MyInt(0);// As Long
					MyInt prowId = new MyInt(0);// As Long
					//int rowid = 0;// As Long
					// '�����Ӵ��ڵĿؼ��Ͻ���˫���Ժ����ø����ݴ��ڵĶ�Ӧ���ݵ�����
					if (parentDW != null && dataColumnName.length() > 0) {// > ""
						// Then
						dataColId = webdw
								.GetColumnIdByColumnName(dataColumnName);// '�õ����������

						//rowid = DW_GetRow();// '�õ���ǰ��

						if (dataColId > 0 && rowid.intvalue > 0) {// Then
							selectdata = DW_GetItemString(rowid.intvalue, dataColId);// '�õ�ѡ�������

							parentDW.GetRowIdColumnId(parentControlName,
									prowId, pcolId);// '��ȡ�����ڵ�����,����

							if (prowId.intvalue > 0 && pcolId.intvalue > 0
									&& Len(selectdata) > 0) {// Then
								parentDW.DW_SetItem(prowId.intvalue,
										pcolId.intvalue, selectdata);// '���ø���������
								parentDW.DrawDW();// '���»���
							}
						}
					}
				}
			});
		}
	}

	class WebDW_DymaComboBox extends MyJComboBox {
		public WebDW_DymaComboBox(String name, ArrayList targetControls,
				Container parent) {
			super(name, targetControls, parent);
			// '�����ѡ���ʱ��������Ӧ�ֶ�����

			this.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					int iret = 0;// As Long
					MyInt rowid = new MyInt(0);// As Long
					MyInt colid = new MyInt(0);// As Long
					String svalue = "";// As String '����ؼ����������ֵ
					int pos1 = 0;// As Long
					int pos2 = 0;// As Long
					int pos3 = 0;// As Long
					String allData[] = new String[1];

					iret = GetRowIdColumnId(Name, rowid, colid);
					if (iret == 0) {// Then

						allData = Split(
								local_webdw.table.Columns[colid.intvalue].values,
								"/");
						Refresh();
						if (ListIndex >= 0) {// Then
							svalue = allData[ListIndex];
							pos1 = InStr(1, svalue, Chr(9));
							if (pos1 > 0) {// Then
								DW_SetItem(rowid.intvalue, colid.intvalue, Mid(
										svalue, pos1 + 1));
							}
						} else {

						}
					}
				}
			});
		}
	}

	class WebDW_DymaRadioButton extends MyJRadioButton {
		class DymaRadioButton_radioListerner implements ChangeListener {
			public void stateChanged(ChangeEvent e) {
				// '������ѡ��ť�Ĳ���
				int iret = 0;// As Long
				MyInt rowid = new MyInt(0);// As Long
				MyInt colid = new MyInt(0);// As Long
				Refresh();
				if (!Value) {
					return;
				}
				System.out.println("You enter radiobutton:" + Name
						+ "  Tag is:" + Tag);
				iret = GetRowIdColumnId(Name, rowid, colid);// '�õ��кź��к�
				if (iret == 0) {// Then
					DW_SetItem(rowid.intvalue, colid.intvalue, Tag);// '��tag����ȡ��ֵ�����ñ���
				}

			}
		}

		public WebDW_DymaRadioButton(String s1, String name,
				ArrayList targetControls, Container parent) {
			super(s1, name, targetControls, parent);
			this.addChangeListener(new DymaRadioButton_radioListerner() {
			});
		}
	}

	class WebDW_DymaCheckBox extends MyJCheckBox {
		class DymaCheckBox_checkListerner implements ChangeListener {
			public void stateChanged(ChangeEvent e) {
				// '����ѡ���ť�Ĳ���
				// 'MsgBox "change", , myTextBox.name
				int iret = 0;// As Long
				MyInt rowid = new MyInt(0);// As Long
				MyInt colid = new MyInt(0);// As Long

				iret = GetRowIdColumnId(Name, rowid, colid);// '�õ��кź��к�
				if (iret == 0) {// Then
					Refresh();
					System.out.println("You enter checkbox listener. ");
					if (Value) {// = 1 Then 'ѡ��״̬
						DW_SetItem(rowid.intvalue, colid.intvalue,
								local_webdw.column[colid.intvalue].checkbox.on);
					} else {// 'δѡ��״̬
						DW_SetItem(rowid.intvalue, colid.intvalue,
								local_webdw.column[colid.intvalue].checkbox.off);
					}
				}

			}
		}

		public WebDW_DymaCheckBox(String s1, String name,
				ArrayList targetControls, Container parent) {

			super(s1, name, targetControls, parent);
			this.addChangeListener(new DymaCheckBox_checkListerner());
		}
	}

}
