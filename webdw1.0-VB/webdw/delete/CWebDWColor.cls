VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWColor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW����ɫת������
Rem PB�еĶ������ɫ���룬��VB�ж������ɫ������������
Rem ������Ҫ����һ��ת��������������ʾ��ת��
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Const SYSCOLOR = 16777215                       '�����ɫֵ,256 * 256 * 256 - 1


'��������������һ��PB�������ɫ��������ϵͳ��ɫ��Ҳ���ܲ���ϵͳ��ɫ
'�����ϵͳ��ɫ������һ����ת��(���ת���ǻ��ڵ�ɫ�嶨���)
'�������ϵͳ��ɫ����ֱ�ӷ���
'�ж��Ƿ���ϵͳ��ɫ��������ֵ�Ƿ�С��255 * 256 * 256 + 255 * 256 + 255
'���û�з����������ж����У���ô����һ��Ĭ��ֵ
'pbColor    :�����PB��ɫֵ
'defColor   :�����Ĭ����ɫֵ
Public Function getVBColor(pbColor As Long, defColor As Long) As Long
    Dim iret As Long
    
    If pbColor <= SYSCOLOR Then
        getVBColor = pbColor
        Exit Function
    End If
    
    iret = defColor                         '����Ĭ����ɫ
    If pbColor = 1090519039 Then iret = vbWindowBackground    '�����windowsĬ�ϱ���ɫ
    If pbColor = 276856960 Then iret = vbApplicationWorkspace ' �����Ӧ�ù�����Ĭ�ϱ���ɫ
    If pbColor = 81324524 Then iret = vbButtonFace            ' ����ǰ�ť��ɫ
    If pbColor = 33554432 Then iret = vbWindowText            'window�ı�Ĭ����ɫ
    
    getVBColor = iret
End Function