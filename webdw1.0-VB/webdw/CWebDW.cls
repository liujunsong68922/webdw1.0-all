VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDW"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem CWebDW是一个没有具体实现过程的中转类
Rem 它的设计目的是屏蔽对于CWebDWUI_FromString和CWebDWUI_ToString的访问
Rem 所有的访问针对CWebDW来进行就可以
Rem CWebDW对应的数据结构是WebDWSyntax
Rem CWebDW操作的数据源是GG_WebDW

Option Explicit
Public dwString As String       '这个变量存储要解析的字符串,未来可用来比较,只读
Public errString As String      '解析失败以后的错误信息存储在这里

'----------本地对象类封装开始---------
Dim reader As New CWebDW_Create                 '定义一个读取功能类
Dim writer As New CWebDW_GetSyntaxString        '定义一个输出字符串类
Dim sqlGener As New CWebDW_GetRetrieveSQL       '定义一个得到数据窗口输出Select的类
Dim synGener As New CWebDW_SyntaxFromSQL        '定义一个从select变成语法的类
'----------本地对象类封装结束---------

Private local_webdw As WebDWSyntax  'local_webdw现在是一个局部变量了，而不是全局变量了

'功能描述：设置g_webdw的值
'输入：gg_webdw
'输出：local_webdw
Public Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'功能描述：读取local_webdw的值
'输入:local_webdw
'输出:gg_webdw
Public Function GetLocalWebDW()
    GG_webdw = local_webdw
End Function

'这个是一个主要的对外公开的解析方法
'输入一个字符串,把它解析成一个webdw结构的数据
'并存储在g_webdw中
'字符串存储在dwString中备用
'返回0代表成功
'如果解析失败,返回-1代表有错误(一般不会)
'不存储字符串,也不存储webdw
'错误信息存储在errString中
Public Function Create(inString As String) As Long
    Dim iret As Long
    iret = reader.Create(inString)
    
    dwString = inString
    
    '更新本地的local_webdw数据,从reader中读取
    reader.GetLocalWebDW
    SetLocalWebDW
    
    If iret = -1 Then
        errString = reader.errString
    End If
    Create = iret
End Function


'在读入g_webdw以后，得到表示所有列名称的字符串表示
'各列之间用chr(9)分割，顺序按照column定义的顺序
'这个数据用来初始化webdwdata的数据集合
'操作前提是local_webdw已经有数据了
Public Function GetColumnDefineString() As String
    Dim strcol As String
    Dim colid As Long
    strcol = ""
    For colid = 1 To 100    'g_webdw定义中最多100个列，此处不可读取column，必须读取table.column
        If local_webdw.table.Columns(colid).Name = "" Then
            Exit For
        End If
        
        If strcol = "" Then
            strcol = strcol & local_webdw.table.Columns(colid).Name
        Else
            strcol = strcol & Chr(9) & local_webdw.table.Columns(colid).Name
        End If
    Next
            
    GetColumnDefineString = strcol  '返回字符串
End Function

'功能描述：将local_webdw转换成一个指定格式的字符串
'以后要修改生成的字符串，只需要修改g_webdw的数据就可以了
'这一方法对应于PB的describe("dw_1.syntax")
Public Function GetSyntaxString(ByRef iret As Long) As String
    GetLocalWebDW
    writer.SetLocalWebDW
    GetSyntaxString = writer.GetSyntaxString(iret)
    If iret = -1 Then
        errString = writer.errString
    End If
End Function


'功能描述：从DW定义中，分解得到数据库检索用的Select语句
'为下一步执行SQL操作打下基础
'这个SQL语句可能会带有参数
Public Function GetRetrieveSQL() As String
    GetLocalWebDW
    sqlGener.SetLocalWebDW
    GetRetrieveSQL = sqlGener.GetRetrieveSQL()
End Function


'根据给定的SQL语句，以及对应的数据窗口类型
'设置到g_webdw中去
'从而再转换，得到一个对应的数据窗口对象出来。
'iret返回值，0 正常 -1 失败
'错误信息存放在errstring中
'这个方法是一个Select语句的小型解析器
Public Function SyntaxFromSQL(strsql As String, stype As String, ByRef iret As Long) As String
    SyntaxFromSQL = synGener.SyntaxFromSQL(strsql, stype, iret)
    If iret = -1 Then
        errString = synGener.errString
        Exit Function
    End If
    
    synGener.GetLocalWebDW
    SetLocalWebDW
End Function

'设置ColumnDefineString
Public Function SetColumnDefineString(colDefString As String) As Long
    synGener.colDefString = colDefString
End Function

'根据给定的columnname，计算返回的列编号(1 based)
'访问local_webdw来计算得到
Public Function GetColumnIdByColumnName(colname As String) As Long
    Dim colid As Long
    For colid = 1 To 100
        If UCase(colname) = UCase(local_webdw.table.Columns(colid).Name) Then
            GetColumnIdByColumnName = colid
            Exit Function
        End If
    Next
    GetColumnIdByColumnName = -1
End Function

'得到界面的最大宽度，用这个宽度来设置横向滚动条的位置等信息
Public Function getMaxWidth() As Long
    Dim i As Long
    Dim imax As Long
    imax = 0
    '循环读取label的最大宽度
    For i = 1 To 100
        If local_webdw.text(i).Name = "" Then
            Exit For
        End If
        
        If local_webdw.text(i).X + local_webdw.text(i).width > imax Then
            imax = local_webdw.text(i).X + local_webdw.text(i).width
        End If
    Next
    
    '循环读取text的最大宽度
    For i = 1 To 100
        If local_webdw.column(i).Name = "" Then
            Exit For
        End If
        
        If local_webdw.column(i).X + local_webdw.column(i).width > imax Then
            imax = local_webdw.column(i).X + local_webdw.column(i).width
        End If
    Next
    
    '循环读取line的最大右坐标
    For i = 1 To 100
        If local_webdw.lineinfo(i).Name = "" Then
            Exit For
        End If
        
        If local_webdw.lineinfo(i).x1 > imax Then imax = local_webdw.lineinfo(i).x1
        If local_webdw.lineinfo(i).x2 > imax Then imax = local_webdw.lineinfo(i).x2
    Next
    
    getMaxWidth = imax
End Function



