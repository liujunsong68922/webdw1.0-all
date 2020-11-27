VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CMultiLang"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem ������������Ӷ���������ʾ��֧��
Rem Ϊ�˹��ʻ���Ҫ
Rem copyright 2009 liujunsong@yahoo.com.cn

'��һ���������ַ����У�����ָ��������������ѡ�񣬷���ָ���Ĳ�������
'����Ҳ������ͷ���ȱʡ���ַ�������
'allstr :  �������Ի����һ����ַ�����ʽΪ ������=��ʾ����chr(13)+chr(10)
'�����ԭʼ�������лس����ţ���Ҫת�嶨��Ϊ\r\n
'�����֮ǰҪ�����ַ������ٴ��滻����\r\nת��Ϊchr(13)+ chr(10)

Private Function GetSpecLang(allstr As String, lang As String, def As String)
    Dim langs() As String
    Dim i As Integer
    Dim svalue As String
    Dim sret As String
    
    '�������Ϊ�գ�����Ĭ��ֵ
    If allstr = "" Then
        GetSpecLang = Replace(def, "\r\n", "" & Chr(13) & Chr(10))
        Exit Function
    End If
    
    langs = Split(allstr, "" & Chr(13) & Chr(10))
    For i = 0 To UBound(langs)
        svalue = langs(i)
        If InStr(1, svalue, lang) = 1 Then
            sret = Mid(svalue, Len(lang) + 2) '�������ƺ����ǵȺţ��ٺ�������ʾ����
            sret = Replace(sret, "\r\n", "" & Chr(13) & Chr(10))
            GetSpecLang = sret
            Exit Function
        End If
    Next
    
    'û���ҵ�������Ĭ��ֵ
    GetSpecLang = Replace(def, "\r\n", "" & Chr(13) & Chr(10))
End Function

'�õ�����ȫ�����Զ���������������ʾ�ַ���������һ�����Զ������
Public Function GetCurrent(allstr As String, Optional def As String = "")
    GetCurrent = GetSpecLang(allstr, G_Lang, def)
End Function

'��������ַ�������ָ�����������ϣ��õ����ʵ��ַ���
'spinfo ����������Ϣ
'eninfo Ӣ����Ϣ
Public Function SumAllLang(spinfo As String, eninfo As String) As String
    Dim sp As String
    Dim en As String
    sp = "simplechinese="
    en = "english="
    
    SumAllLang = sp & spinfo & Chr(13) & Chr(10) & en & eninfo
End Function
