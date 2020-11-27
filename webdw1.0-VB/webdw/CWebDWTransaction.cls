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
Rem WebDW������������
Rem Ŀ���ǶԿͻ��˵ķ����ṩһ���ں�̨������֧������
Rem �����Ȳ���һ�����ݿ������
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
Option Explicit
Option Base 1

'���ʵ��ò���,��Ҫ�ⲿ������
Private serverURL As String         '��̨���ʵ�URL,�����ṩ��������Ȩ�ޣ�ͨ��g_serverurl������
Public userid As String             '��½���û���
Public passwd As String             '�����ÿ���
Public opertype As String           '���ʵĲ�������
Public command As String            'Ҫִ�еľ���ָ��
Public beginPos As Long             '��ѯ����Ŀ�ʼ������Ĭ��Ϊ0,��ζ����������
Public readNum As Long              '��ѯ����ķ���������Ĭ��Ϊ1000
Public transId As String            '��֧�����������£�transId��ʾ�����

Public errString As String          '������Ϣ�洢�ַ���
Dim resultString As String          'ִ�к�ķ����ַ���

Dim myxmlhttp

'����������ִ��һ��SQL��䣬����һ����׼�Ľ���ַ���
'Ҫִ�е�sql����Լ���ز�����������public����
'ִ��֮ǰ�������ø����������ٵ��ô˷���
'�����Ƶ�Ŀ������Ϊһ������������������Ի󲻽�
'iret   ����״̬��0���� -1 ʧ��
Public Function ExecuteSelect(ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     serverURL = G_ServerURL    '��ȡG_ServerURL
     
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
    errString = "���ݿ���ʷ����쳣��" & Err.Description
     
End Function
'select�Ļص�����
Public Function Recv() As Object
    If myxmlhttp.readyState = 4 Then
        resultString = myxmlhttp.responseText
        Rem �жϷ��ص��ַ���������Exception�ַ�,����о���Ϊ�������쳣
        Rem ��һ�жϷ���δ����׼ȷ�ģ���ʱ���
        If InStr(1, resultString, "Exception") > 0 Then
            errString = resultString
        End If
    Else
        resultString = ""
        errString = myxmlhttp.statusText
    End If
End Function

'ִ��һ��Update�������Insert,����Delete����ķ���
Public Function ExecuteUpdate(ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     serverURL = G_ServerURL    '��ȡG_ServerURL
     
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
    errString = "���ݿ���ʷ����쳣��" & Err.Description
    MsgBox Err.Description, , "sqlca error:"

End Function

'��Ҫ���£��¹��ܣ��ڿͻ�������һ����̨����(��������)
'iret�Ƿ��ز���0 ���� -1 ʧ��
Public Function BeginTransaction(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
    If transId <> "" Then   '�����ǰ������ڣ����������̿�ʼ
        iret = -1
        errString = "Please Commit or Rollback Current Transaction First"
        Exit Function
    End If
    
    
     errString = ""
     serverURL = G_ServerURL    '��G_ServerURL��ȡ����
     
     Dim sURL As String
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
            transId = Mid(resultString, 1, ipos - 1)    '����transId��ֵ
        Else
            iret = -1
            errString = "Return DataFormat Error."
            BeginTransaction = ""
            transId = ""                                '����transId��ֵ
        End If
    End If
    
    Exit Function
    
errorHandle:
    iret = -1
    errString = "���ݿ���ʷ����쳣��" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function

'��Ҫ���£��¹��ܣ��ڿͻ�������һ����̨����(��������)
'iret�Ƿ��ز���0 ���� -1 ʧ��
Public Function AddCommand(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
     errString = ""
     serverURL = G_ServerURL        '��G_ServerURL��ȡ����
     
     Dim sURL As String
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&transid=" & transId & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
    errString = "���ݿ���ʷ����쳣��" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function

'��Ҫ���£��¹��ܣ��ڿͻ����ύһ����̨����(��������)
'iret�Ƿ��ز���0 ���� -1 ʧ��
Public Function Commit(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
     errString = ""
     serverURL = G_ServerURL    '��ȡG_serverurl
     
     Dim sURL As String
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&transid=" & transId & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
    errString = "���ݿ���ʷ����쳣��" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function


'��Ҫ���£��¹��ܣ��ڿͻ����ύһ����̨����(��������)
'iret�Ƿ��ز���0 ���� -1 ʧ��
Public Function Rollback(ByRef iret As Long) As String
    
    On Error GoTo errorHandle
    
     errString = ""
     serverURL = G_ServerURL       '��ȡG_ServerURL
     
     Dim sURL As String
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&transid=" & transId & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
    errString = "���ݿ���ʷ����쳣��" & Err.Description
    MsgBox Err.Description, , "sqlca error:"
End Function

'sqlca�ĳ�ʼ������
Private Sub Class_Initialize()

    serverURL = G_ServerURL     '��ʼ��ΪG_ServerURL
    userid = ""
    passwd = ""
    beginPos = 1
    readNum = 100
    
    'Set myxmlhttp = New XMLHTTP
    Set myxmlhttp = CreateObject("Microsoft.XMLHTTP")
End Sub

'�Ӻ�̨�������ϵõ�ָ���ļ�������ļ��������ݴ��ڵĶ���
'��һ���������������ݴ��ڵ������ݴ��ڶ���
'ֻ���������ܲ����޸ĵ�ʹ��PB�Զ����ɵ����ݴ��ڶ���
Public Function GetDWDefine(dwfileName As String, ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     serverURL = G_ServerURL    '��ȡG_ServerURL
     
     opertype = "getdwdefine"   '������ʽΪgetdwdefine,���ݴ��ڵ�������command����
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & dwfileName & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
            "&rand=" & Now()
      
     myxmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
    errString = "���ݿ���ʷ����쳣��" & Err.Description
End Function