package com.webdw;

//Rem -------------------------------------------------
//Rem CWebDWEditMask����һ�������࣬
//Rem ��Ҫ������������¼��ʱ��ʽ����������
//Rem ���������ʱҲͬ�����и�ʽ��
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @��Ȩ���� ������ 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDWDisplayFormat extends Golbal{
	public void ReadMe(){
		System.out.println("CWebDWEditMask����һ��������");
		System.out.println(JWebDWInfo);
	}
	// '����һ�������ַ���������һ���༭�����ַ���
	// '���һ���Ѿ���ʽ���Ժ���ַ���
	public String GetFormatString(String inString, String sformat,
			long iDataType) {
		return "";
	}

	// '������Ĵ�����ֵ���ַ���������ָ����ʽ���и�ʽ��
	// '��һ�������������ֵ�����ݵ�����֧��
	// '����PB�Ĺ���
	// '#����1λ����
	// '0����1λ���֣��޶�Ӧλʱ��0����
	// '.С����
	// '�����ָ����
	// '�㷨���£�
	// '��С����Ϊ�磬��ͷ��ʼ����ԭ��ֵ���Ӧ�������־��
	// '�����ԭʼ����λ�� > ����λ�� ��ô ȡԭʼλ��
	// '���: ԭʼ����λ�� = ����λ������������Ϊ#
	// '�����ԭʼ����λ�� < ����λ������������=0 ����ô����0
	// '����������ж����˷ָ���ţ���#,0)���⣬��ô���طָ����
	public String GetFormateDecimal(String inString, String sformate) {
		return inString;
		// TODO:��Ҫ���б�Ҫ�Ĵ���Ǩ�ƣ���ʱ�����ⲿ�ֹ���
	}

}
