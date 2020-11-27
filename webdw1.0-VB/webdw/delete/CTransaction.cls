VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CTransaction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW的事务处理连接
Rem 目的是对客户端的访问提供一个在后台的事务支持特性
Rem 初期先采用一个数据库的连接
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit
Option Base 1

'访问调用参数,需要外部先设置
Public serverURL As String          '后台访问的URL
Public userid As String             '登陆用用户名
Public passwd As String             '访问用口令
Public opertype As String           '访问的操作类型
Public command As String            '要执行的具体指令
Public beginPos As Long             '查询请求的开始行数，默认为0,意味着跳过行数
Public readNum As Long              '查询请求的返回行数，默认为1000

Public errString As String          '错误信息存储字符串
Dim resultString As String          '执行后的返回字符串
Dim xmlhttp As New MSXML2.XMLHTTP60

'功能描述：执行一个SQL语句，返回一个标准的结果字符串
'要执行的sql语句以及相关参数是这个类的public变量
'执行之前，先设置各个变量，再调用此方法
'如此设计的目的是因为一个方法多个变量令人迷惑不解
'iret   返回状态，0正常 -1 失败
Public Function ExecuteSelect(ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     xmlhttp.open "GET", sURL, False    '用同步模式进行调用
     xmlhttp.send ""
     
     xmlhttp.onreadystatechange = Recv
     
     If errString > "" Then
        iret = -1
        ExecuteSelect = ""
     Else
        iret = 0
        ExecuteSelect = resultString
     End If
     
     Exit Function
     
errorHandle:
    iret = -1
    errString = "数据库访问发生异常：" & Err.Description
     
End Function
'select的回调方法
Public Function Recv() As Object
    If xmlhttp.readyState = 4 Then
        resultString = xmlhttp.responseText
    Else
        resultString = ""
        errString = xmlhttp.statusText
    End If
End Function

'执行一个Update命令，或者Insert,或者Delete命令的方法
Public Function executeUpdate(ByRef iret As Long) As String

End Function

