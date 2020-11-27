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
Rem 这个类用来增加多种语言显示的支持
Rem 为了国际化需要
Rem copyright 2009 liujunsong@yahoo.com.cn

'从一串给定的字符串中，根据指定的语言来进行选择，返回指定的部分描述
'如果找不到，就返回缺省的字符串描述
'allstr :  各种语言混合在一起的字符串格式为 语言名=显示内容chr(13)+chr(10)
'如果在原始内容中有回车符号，需要转义定义为\r\n
'在输出之前要进行字符串的再次替换，将\r\n转换为chr(13)+ chr(10)

Private Function GetSpecLang(allstr As String, lang As String, def As String)
    Dim langs() As String
    Dim i As Integer
    Dim svalue As String
    Dim sret As String
    
    '如果输入为空，返回默认值
    If allstr = "" Then
        GetSpecLang = Replace(def, "\r\n", "" & Chr(13) & Chr(10))
        Exit Function
    End If
    
    langs = Split(allstr, "" & Chr(13) & Chr(10))
    For i = 0 To UBound(langs)
        svalue = langs(i)
        If InStr(1, svalue, lang) = 1 Then
            sret = Mid(svalue, Len(lang) + 2) '语言名称后面是等号，再后面是显示内容
            sret = Replace(sret, "\r\n", "" & Chr(13) & Chr(10))
            GetSpecLang = sret
            Exit Function
        End If
    Next
    
    '没有找到，返回默认值
    GetSpecLang = Replace(def, "\r\n", "" & Chr(13) & Chr(10))
End Function

'得到按照全局语言定义来检索到的显示字符串，少了一个语言定义参数
Public Function GetCurrent(allstr As String, Optional def As String = "")
    GetCurrent = GetSpecLang(allstr, G_Lang, def)
End Function

'将输入的字符串按照指定规则进行组合，得到合适的字符串
'spinfo 简体中文信息
'eninfo 英文信息
Public Function SumAllLang(spinfo As String, eninfo As String) As String
    Dim sp As String
    Dim en As String
    sp = "simplechinese="
    en = "english="
    
    SumAllLang = sp & spinfo & Chr(13) & Chr(10) & en & eninfo
End Function

