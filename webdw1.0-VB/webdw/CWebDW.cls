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
Rem CWebDW��һ��û�о���ʵ�ֹ��̵���ת��
Rem �������Ŀ�������ζ���CWebDWUI_FromString��CWebDWUI_ToString�ķ���
Rem ���еķ������CWebDW�����оͿ���
Rem CWebDW��Ӧ�����ݽṹ��WebDWSyntax
Rem CWebDW����������Դ��GG_WebDW

Option Explicit
Public dwString As String       '��������洢Ҫ�������ַ���,δ���������Ƚ�,ֻ��
Public errString As String      '����ʧ���Ժ�Ĵ�����Ϣ�洢������

'----------���ض������װ��ʼ---------
Dim reader As New CWebDW_Create                 '����һ����ȡ������
Dim writer As New CWebDW_GetSyntaxString        '����һ������ַ�����
Dim sqlGener As New CWebDW_GetRetrieveSQL       '����һ���õ����ݴ������Select����
Dim synGener As New CWebDW_SyntaxFromSQL        '����һ����select����﷨����
'----------���ض������װ����---------

Private local_webdw As WebDWSyntax  'local_webdw������һ���ֲ������ˣ�������ȫ�ֱ�����

'��������������g_webdw��ֵ
'���룺gg_webdw
'�����local_webdw
Public Function SetLocalWebDW()
    local_webdw = GG_webdw
End Function

'������������ȡlocal_webdw��ֵ
'����:local_webdw
'���:gg_webdw
Public Function GetLocalWebDW()
    GG_webdw = local_webdw
End Function

'�����һ����Ҫ�Ķ��⹫���Ľ�������
'����һ���ַ���,����������һ��webdw�ṹ������
'���洢��g_webdw��
'�ַ����洢��dwString�б���
'����0�����ɹ�
'�������ʧ��,����-1�����д���(һ�㲻��)
'���洢�ַ���,Ҳ���洢webdw
'������Ϣ�洢��errString��
Public Function Create(inString As String) As Long
    Dim iret As Long
    iret = reader.Create(inString)
    
    dwString = inString
    
    '���±��ص�local_webdw����,��reader�ж�ȡ
    reader.GetLocalWebDW
    SetLocalWebDW
    
    If iret = -1 Then
        errString = reader.errString
    End If
    Create = iret
End Function


'�ڶ���g_webdw�Ժ󣬵õ���ʾ���������Ƶ��ַ�����ʾ
'����֮����chr(9)�ָ˳����column�����˳��
'�������������ʼ��webdwdata�����ݼ���
'����ǰ����local_webdw�Ѿ���������
Public Function GetColumnDefineString() As String
    Dim strcol As String
    Dim colid As Long
    strcol = ""
    For colid = 1 To 100    'g_webdw���������100���У��˴����ɶ�ȡcolumn�������ȡtable.column
        If local_webdw.table.Columns(colid).Name = "" Then
            Exit For
        End If
        
        If strcol = "" Then
            strcol = strcol & local_webdw.table.Columns(colid).Name
        Else
            strcol = strcol & Chr(9) & local_webdw.table.Columns(colid).Name
        End If
    Next
            
    GetColumnDefineString = strcol  '�����ַ���
End Function

'������������local_webdwת����һ��ָ����ʽ���ַ���
'�Ժ�Ҫ�޸����ɵ��ַ�����ֻ��Ҫ�޸�g_webdw�����ݾͿ�����
'��һ������Ӧ��PB��describe("dw_1.syntax")
Public Function GetSyntaxString(ByRef iret As Long) As String
    GetLocalWebDW
    writer.SetLocalWebDW
    GetSyntaxString = writer.GetSyntaxString(iret)
    If iret = -1 Then
        errString = writer.errString
    End If
End Function


'������������DW�����У��ֽ�õ����ݿ�����õ�Select���
'Ϊ��һ��ִ��SQL�������»���
'���SQL�����ܻ���в���
Public Function GetRetrieveSQL() As String
    GetLocalWebDW
    sqlGener.SetLocalWebDW
    GetRetrieveSQL = sqlGener.GetRetrieveSQL()
End Function


'���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
'���õ�g_webdw��ȥ
'�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
'iret����ֵ��0 ���� -1 ʧ��
'������Ϣ�����errstring��
'���������һ��Select����С�ͽ�����
Public Function SyntaxFromSQL(strsql As String, stype As String, ByRef iret As Long) As String
    SyntaxFromSQL = synGener.SyntaxFromSQL(strsql, stype, iret)
    If iret = -1 Then
        errString = synGener.errString
        Exit Function
    End If
    
    synGener.GetLocalWebDW
    SetLocalWebDW
End Function

'����ColumnDefineString
Public Function SetColumnDefineString(colDefString As String) As Long
    synGener.colDefString = colDefString
End Function

'���ݸ�����columnname�����㷵�ص��б��(1 based)
'����local_webdw������õ�
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

'�õ�����������ȣ���������������ú����������λ�õ���Ϣ
Public Function getMaxWidth() As Long
    Dim i As Long
    Dim imax As Long
    imax = 0
    'ѭ����ȡlabel��������
    For i = 1 To 100
        If local_webdw.text(i).Name = "" Then
            Exit For
        End If
        
        If local_webdw.text(i).X + local_webdw.text(i).width > imax Then
            imax = local_webdw.text(i).X + local_webdw.text(i).width
        End If
    Next
    
    'ѭ����ȡtext��������
    For i = 1 To 100
        If local_webdw.column(i).Name = "" Then
            Exit For
        End If
        
        If local_webdw.column(i).X + local_webdw.column(i).width > imax Then
            imax = local_webdw.column(i).X + local_webdw.column(i).width
        End If
    Next
    
    'ѭ����ȡline�����������
    For i = 1 To 100
        If local_webdw.lineinfo(i).Name = "" Then
            Exit For
        End If
        
        If local_webdw.lineinfo(i).x1 > imax Then imax = local_webdw.lineinfo(i).x1
        If local_webdw.lineinfo(i).x2 > imax Then imax = local_webdw.lineinfo(i).x2
    Next
    
    getMaxWidth = imax
End Function


