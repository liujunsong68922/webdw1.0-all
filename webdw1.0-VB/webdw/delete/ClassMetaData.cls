VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ClassMetaData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem CopyRight Mr.Liu Junsong 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Rem ����������ṩ���ݿ��Ԫ����
Rem ��������Ա������Ԫ����
Rem �����׼ȷ����˵ֻ��һ���ӿڶ���
Rem �����ʵ��Ҫ�����ڷ������˵ĺ�̨������ʵ��
Rem Ŀǰ�Ȳ���һ��αװʵ�ֵķ�ʽ��ʵ�֣���������ԭ��

Option Explicit

'�õ����ݿ���������ݱ�����ͼ���б�
'����ֵ�����һ���ַ�����������
'����ֵ�������ݱ�������
'����ʵ���Ժ������ϸʵ��
Public Function getTableList(table() As String, maxNum As Integer) As Integer
    
    Dim sret As String              'ִ��sql�õ������ݽ��
        
    Rem ������ģ��ʵ�֣���ʵ���벻����
    table(1) = "T_Book"
    table(2) = "T_Test"
    getTableList = 2
    Rem ģ��ʵ�ֽ���

End Function

'�������ݱ����ƣ��õ����������Ƶ��б�
'����ֵ�����һ���ַ�����������
'����ֵ���������е�����
'����ʵ���Ժ������ϸʵ��

Public Function getColumnList(cols() As String, tablename As String) As Integer
    Rem ������ģ��ʵ�֣���ʵ���벻����
    If tablename = "T_Book" Then
        cols(1) = "book_id"
        cols(2) = "book_name"
        getColumnList = 2
        Exit Function
    End If
    
    If tablename = "T_Test" Then
        cols(1) = "test_id"
        cols(2) = "test_name"
        getColumnList = 2
        Exit Function
    End If
    
    Rem ģ��ʵ�ֽ���
End Function