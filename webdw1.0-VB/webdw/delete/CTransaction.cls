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
Public serverURL As String          '��̨���ʵ�URL
Public userid As String             '��½���û���
Public passwd As String             '�����ÿ���
Public opertype As String           '���ʵĲ�������
Public command As String            'Ҫִ�еľ���ָ��
Public beginPos As Long             '��ѯ����Ŀ�ʼ������Ĭ��Ϊ0,��ζ����������
Public readNum As Long              '��ѯ����ķ���������Ĭ��Ϊ1000

Public errString As String          '������Ϣ�洢�ַ���
Dim resultString As String          'ִ�к�ķ����ַ���
Dim xmlhttp As New MSXML2.XMLHTTP60

'����������ִ��һ��SQL��䣬����һ����׼�Ľ���ַ���
'Ҫִ�е�sql����Լ���ز�����������public����
'ִ��֮ǰ�������ø����������ٵ��ô˷���
'�����Ƶ�Ŀ������Ϊһ������������������Ի󲻽�
'iret   ����״̬��0���� -1 ʧ��
Public Function ExecuteSelect(ByRef iret As Long) As String
     On Error GoTo errorHandle
     Dim sURL As String
     
     errString = ""
     '����Ҫִ�е�sql�����һ��rand������Ϊ�˽�����������
     sURL = serverURL & _
            "?opertype=" & opertype & _
            "&command=" & command & _
            "&beginpos=" & beginPos & _
            "&readnum=" & readNum & _
            "&userid=" & userid & _
            "&passwd=" & passwd & _
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
Public Function Recv() As Object
    If xmlhttp.readyState = 4 Then
        resultString = xmlhttp.responseText
    Else
        resultString = ""
        errString = xmlhttp.statusText
    End If
End Function

'ִ��һ��Update�������Insert,����Delete����ķ���
Public Function executeUpdate(ByRef iret As Long) As String

End Function
