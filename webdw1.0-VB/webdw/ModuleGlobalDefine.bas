Attribute VB_Name = "Module1GlobalDefine"
Rem -------------------------------------------------
Rem ModualGlobalDefine��һ��ȫ�ֱ����Ķ���ģ��,
Rem �Լ���Щ�����ĳ�ʼ�����ܶ����ģ��
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Public G_ServerURL As String            'g_serverURL�����̨���ݿ��������
Public GG_empty_webdw As WebDWSyntax    'GG_empty_webdw��ȫ���Եı�������ʾ�ն���
Public G_Lang As String                 'ȫ���Ե�������ʾѡ��

Public Type LangDef
    Lang_SimpleChinese As String        '�������Ķ���
    Lang_English As String              'Ӣ�Ķ���
    Lang_French As String               '���Ķ���
    Lang_Japanese As String             '���Ķ���
End Type

Public G_LangDef As LangDef             '����ȫ�ֳ��������Զ���

Public Type EditMaskDataTypeDef
    EditMask_Date As Long
    EditMask_Time As Long
    EditMask_DateTime As Long
    EditMask_Decimal As Long
    EditMask_Numeric As Long
    EditMask_String As Long
End Type

Public G_EditMaskDataType As EditMaskDataTypeDef '����ȫ�ֵ�����������������

'������������ʼ��ϵͳ�õ���ȫ�ֱ�������
Public Function InitGlobalVariable() As Long
    G_ServerURL = "http://localhost/myproj/Table" '����Ĭ������
    
    '��ȫ�����Գ�����ֵ
    G_LangDef.Lang_English = "english"
    G_LangDef.Lang_French = "french"
    G_LangDef.Lang_Japanese = "japanese"
    G_LangDef.Lang_SimpleChinese = "simplechinese"
    
    G_Lang = G_LangDef.Lang_SimpleChinese   'Ĭ��Ϊ����������ʾ

    '��ȫ�������������õ�������������ֵ
    G_EditMaskDataType.EditMask_Date = 1
    G_EditMaskDataType.EditMask_Time = 2
    G_EditMaskDataType.EditMask_DateTime = 3
    G_EditMaskDataType.EditMask_Decimal = 4
    G_EditMaskDataType.EditMask_Numeric = 5
    G_EditMaskDataType.EditMask_String = 6
End Function

