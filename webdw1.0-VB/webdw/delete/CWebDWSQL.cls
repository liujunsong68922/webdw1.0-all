VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWSQL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�����ݿ���ʹ���
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
'webdwsql�ķ��ʽṹ����

Public serverURL As String          '������SQL���ʵ����URL,��http://localhost:8001/myproj/Table
Public opertype As String           '���ʵĲ�������
Public command As String            'Ҫִ�еľ���ָ��
Public beginPos As Long             '��ѯ����Ŀ�ʼ������Ĭ��Ϊ0,��ζ����������
Public readNum As Long              '��ѯ����ķ���������Ĭ��Ϊ1000

Public errString As String              '������Ϣ�洢�ַ���
Dim resultString As String
Dim xmlhttp As New MSXML2.XMLHTTP60

'����������ִ��һ��SQL��䣬����һ����׼�Ľ���ַ���
'Ҫִ�е�sql����Լ���ز�����������public����
'ִ��֮ǰ�������ø����������ٵ��ô˷���
'�����Ƶ�Ŀ������Ϊһ������������������Ի󲻽�
'iret   ����״̬��0���� -1 ʧ��
Private Function ExecuteSelect(ByRef iret As Long) As String
     Dim sURL As String
     
     On Error GoTo errorHandle
     errString = ""
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&rand=" & Now()
      
     xmlhttp.open "GET", sURL, False    '��ͬ��ģʽ���е���
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
    errString = "���ݿ���ʷ����쳣��" & Err.Description
End Function
'select�Ļص�����
Private Function Recv() As Object
    If xmlhttp.readyState = 4 Then
        resultString = xmlhttp.responseText
    Else
        resultString = ""
        errString = xmlhttp.statusText
    End If
End Function
