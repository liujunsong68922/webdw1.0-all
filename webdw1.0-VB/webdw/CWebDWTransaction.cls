VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWTransaction"
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
Private serverURL As String         '后台访问的URL,不再提供公共访问权限，通过g_serverurl来设置
Public userid As String             '登陆用用户名
Public passwd As String             '访问用口令
Public opertype As String           '访问的操作类型
Public command As String            '要执行的具体指令
Public beginPos As Long             '查询请求的开始行数，默认为0,意味着跳过行数
Public readNum As Long              '查询请求的返回行数，默认为1000
Public transId As String            '在支持事务的情况下，transId表示事务号

Public errString As String          '错误信息存储字符串
Dim resultString As String          '执行后的返回字符串

Dim myxmlhttp

'功能描述：执行一个SQL语句，返回一个标准的结果字符串
'要执行的sql语句以及相关参数是这个类的public变量
'执行之前，先设置各个变量，再调用此方法
'如此设计的目的是因为一个方法多个变量令人迷惑不解
'iret   返回状态，0正常 -1 失败
Public Function ExecuteSelect(ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     serverURL = G_ServerURL    '读取G_ServerURL
     
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '用同步模式进行调用
     myxmlhttp.send ""
     
     myxmlhttp.onreadystatechange = Recv
     
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
    If myxmlhttp.readyState = 4 Then
        resultString = myxmlhttp.responseText
        Rem 判断返回的字符串中有无Exception字符,如果有就认为发生了异常
        Rem 这一判断方法未必是准确的，暂时如此
        If InStr(1, resultString, "Exception") > 0 Then
            errString = resultString
        End If
    Else
        resultString = ""
        errString = myxmlhttp.statusText
    End If
End Function

'执行一个Update命令，或者Insert,或者Delete命令的方法
Public Function ExecuteUpdate(ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     serverURL = G_ServerURL    '读取G_ServerURL
     
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '用同步模式进行调用
     myxmlhttp.send ""
     
     myxmlhttp.onreadystatechange = Recv
     
     If errString > "" Then
        iret = -1
        ExecuteUpdate = ""
     Else
        iret = 0
        ExecuteUpdate = resultString
     End If
     
     Exit Function
     
errorHandle:
    iret = -1
    errString = "数据库访问发生异常：" & Err.Description
    MsgBox Err.Description, , "sqlca error:"

End Function

'重要更新：新功能，在客户端启动一个后台事务(虚拟事务)
'iret是返回参数0 正常 -1 失败
Public Function BeginTransaction(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
    If transId <> "" Then   '如果当前事务存在，则不允许立刻开始
        iret = -1
        errString = "Please Commit or Rollback Current Transaction First"
        Exit Function
    End If
    
    
     errString = ""
     serverURL = G_ServerURL    '从G_ServerURL读取变量
     
     Dim sURL As String
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '用同步模式进行调用
     myxmlhttp.send ""
     
     myxmlhttp.onreadystatechange = Recv
    
    Dim ipos As Long
    
    If errString > "" Then
        iret = -1
        BeginTransaction = ""
        transId = ""
        Exit Function
    Else
        ipos = InStr(resultString, "" & Chr(13) & Chr(10))
        If ipos > 0 Then
            BeginTransaction = Mid(resultString, 1, ipos - 1)
            transId = Mid(resultString, 1, ipos - 1)    '设置transId的值
        Else
            iret = -1
            errString = "Return DataFormat Error."
            BeginTransaction = ""
            transId = ""                                '设置transId的值
        End If
    End If
    
    Exit Function
    
errorHandle:
    iret = -1
    errString = "数据库访问发生异常：" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function

'重要更新：新功能，在客户端启动一个后台事务(虚拟事务)
'iret是返回参数0 正常 -1 失败
Public Function AddCommand(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
     errString = ""
     serverURL = G_ServerURL        '从G_ServerURL读取数据
     
     Dim sURL As String
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&transid=" & transId & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '用同步模式进行调用
     myxmlhttp.send ""
     
     myxmlhttp.onreadystatechange = Recv
    
    Dim ipos As Long
    
    If errString > "" Then
        iret = -1
        AddCommand = ""
        Exit Function
    Else
        iret = 0
        AddCommand = ""
    End If
    
    Exit Function
    
errorHandle:
    iret = -1
    errString = "数据库访问发生异常：" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function

'重要更新：新功能，在客户端提交一个后台事务(虚拟事务)
'iret是返回参数0 正常 -1 失败
Public Function Commit(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
     errString = ""
     serverURL = G_ServerURL    '读取G_serverurl
     
     Dim sURL As String
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&transid=" & transId & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '用同步模式进行调用
     myxmlhttp.send ""
     
     myxmlhttp.onreadystatechange = Recv
    
    Dim ipos As Long
    
    If errString > "" Then
        iret = -1
        Commit = ""
        Exit Function
    Else
        iret = 0
        Commit = ""
    End If
    
    Exit Function
    
errorHandle:
    iret = -1
    errString = "数据库访问发生异常：" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function


'重要更新：新功能，在客户端提交一个后台事务(虚拟事务)
'iret是返回参数0 正常 -1 失败
Public Function Rollback(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
     errString = ""
     serverURL = G_ServerURL       '读取G_ServerURL
     
     Dim sURL As String
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&transid=" & transId & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '用同步模式进行调用
     myxmlhttp.send ""
     
     myxmlhttp.onreadystatechange = Recv
    
    Dim ipos As Long
    
    If errString > "" Then
        iret = -1
        Rollback = ""
        Exit Function
    Else
        iret = 0
        Rollback = ""
    End If
    
    Exit Function
    
errorHandle:
    iret = -1
    errString = "数据库访问发生异常：" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function

'sqlca的初始化方法
Private Sub Class_Initialize()

    serverURL = G_ServerURL     '初始化为G_ServerURL
    userid = ""
    passwd = ""
    beginPos = 1
    readNum = 100
    
    'Set myxmlhttp = New XMLHTTP
    Set myxmlhttp = CreateObject("Microsoft.XMLHTTP")
End Sub

'从后台服务器上得到指定文件，这个文件代表数据窗口的定义
'这一功能用来检索数据窗口的子数据窗口定义
'只有这样才能不加修改的使用PB自动生成的数据窗口对象
Public Function GetDWDefine(dwfileName As String, ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     serverURL = G_ServerURL    '读取G_ServerURL
     
     opertype = "getdwdefine"   '命令形式为getdwdefine,数据窗口的名字在command里面
     '构建要执行的sql命令，加一个rand参数是为了解决缓存的问题
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & dwfileName & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '用同步模式进行调用
     myxmlhttp.send ""
     
     myxmlhttp.onreadystatechange = Recv
     
     If errString > "" Then
        iret = -1
        GetDWDefine = ""
     Else
        iret = 0
        GetDWDefine = resultString
     End If
     
     Exit Function
     
errorHandle:
    iret = -1
    errString = "数据库访问发生异常：" & Err.Description
End Function
