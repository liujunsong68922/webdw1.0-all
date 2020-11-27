package com.webdw.ui;

import java.awt.Font;


/**
 * ����Java��������Ĳ�����VB��ͬ �����Ҫ�Զ���һ��Font�������ʹ֮���Ա�ͨ����Get Set�෽�� ���ٴ���Ǩ�ƵĹ�����
 * 
 * @author liujunsong
 * 
 */
public class MyFont extends com.webdw.Golbal {
	public Font stf = null;// new Font("Serif", Font.PLAIN, 24);// StdFont

	public MyFont() {
		//stf = new Font("����", Font.PLAIN, 24);
		stf = new Font("Serif", Font.PLAIN, 24);
	}
	



	public boolean Bold=false;
	/*
	 * ����Bold����Set����
	 */
	public void Bold(boolean isbold) {
		// ����������Ҫ���õ���ͬ��ֱ���˳�
		if (stf.isBold() == isbold) {
			return;
		}

		// �Ƚ���������Ϊ�Ǵ���
		if (stf.isBold()) {
			stf = new Font(stf.getFamily(), stf.getStyle() - Font.BOLD, stf
					.getSize());
		}

		if (isbold) {
			stf = new Font(stf.getFamily(), stf.getStyle() + Font.BOLD, stf
					.getSize());
		}
		refresh();
	}
	public boolean  Italic=false;
	/*
	 * ����Italic����Set����
	 */
	public void Italic(boolean isItalic) {
		// ����������Ҫ���õ���ͬ��ֱ���˳�
		if (stf.isItalic() == isItalic) {
			return;
		}

		// �Ƚ���������Ϊ�Ǵ���
		if (stf.isItalic()) {
			stf = new Font(stf.getFamily(), stf.getStyle() - Font.ITALIC, stf
					.getSize());
		}

		if (isItalic) {
			stf = new Font(stf.getFamily(), stf.getStyle() + Font.ITALIC, stf
					.getSize());
		}
		refresh();
	}

	/*
	 * �����������ƣ�Java�������window��һ�£��Ժ��ٴ��� ��һ������Ҫ��ϸ��飬�������岻֧��
	 */
	public String Name="";
	public void Name(String facename) {
		// System.out.println("inface:"+facename);
		// System.out.println("decode face:"+Font.decode(facename).getFamily());
		// System.out.println("decode name:"+Font.decode(facename).getName());

		// stf = new Font(Font.decode(facename).getFamily(), stf.getStyle()
		// + Font.ITALIC, stf.getSize());

	}

	public int Size=0;
	public void Size(int size) {
		// System.out.println("size is: " + size);
		stf = new Font(stf.getFamily(), stf.getStyle(), size);
		refresh();
	}

	public void ReadMe() {
		System.out.println("MyFont");
		System.out.println(JWebDWInfo);
	}
	
	private void refresh(){
		Bold = stf.isBold();
		Italic = stf.isItalic();
		Name = stf.getFamily();
		Size = stf.getSize();
	}
}
