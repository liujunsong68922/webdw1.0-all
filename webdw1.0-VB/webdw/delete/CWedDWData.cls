VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWedDWData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�ؼ���Ӧ�����ݴ洢��������
Rem �������ר����������ʵ�����ݵ�
Rem ����ͨ��һ���̶���ʽ���ַ��������г�ʼ��
Rem ���ݴ洢��CWebDWData��
Rem ����������ȷ����Ĺ��ܻ��֣�����������
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit
Option Base 1

Dim Columns() As String '�����ļ��ϣ����Է������ݣ�������DW����
Dim DataArray() As String   '�����еļ��ϣ����Է������ݣ�һ��һ���ַ������洢

'Dim lineState() As Long     'ÿһ�е����ݿ��Ӧ״̬0 ���� 1 �޸� 2 ɾ�� 3 ���� 4 ��Ч������DB��
Dim sorgData As String      '�����ԭʼ�����ַ������洢�ã����޸�
Public errString As String  '�������ʧ�ܣ�����Ĵ�����Ϣ��

'������������������ַ����ж�ȡ���ݣ����columnArray��lineArray
'����0 �ɹ�
'����-1 ʧ�ܣ�������Ϣ������errString��
Public Function ReadData(sindata As String) As Long
    Dim sDataArray As Variant   'ԭʼ���ݰ��зֽ�õ�������
    Dim vline As Variant        'ԭʼ����ÿһ��
    Dim sline As String         'ת�����ַ�����ԭʼ����ÿһ��
    Dim lineId As Long          'ԭʼ���ݵ��кţ�0�������⣬�����������
    
    Dim sdarray As Variant      '�м������ÿһ�зֽ�������е�����
    
    Dim colid As Long           '�е����
    Dim colNum As Long          '�е�����
    
    sorgData = sindata          '�洢ԭʼ����
    
    ReDim DataArray(1)          '�����ԭʼ����
    
    sDataArray = Split(sindata, "" & Chr(13) & Chr(10))     '���ûس����Ž��зֽ�
    lineId = 0                                              'ԭʼ���ݵ��к�
    For Each vline In sDataArray
        sline = vline                                       '����һ��,ת���ַ���
        If sline = "" Then                                  '�������У��˳�
            Exit For
        End If
        
        If lineId = 0 Then
            Columns = Split(sline, Chr(9))                 '��chr(9)���ֽ����,�浽columns����
            colNum = UBound(Columns) - LBound(Columns) + 1 '�е�����
        Else
            sdarray = Split(sline, Chr(9))                 '��chr(9)���ֽ���,�ֽ�ɶ��������
            
            If UBound(sdarray) = 0 Then
                Exit Function
            End If
            
            If UBound(sdarray) <> UBound(Columns) Then      '����������Ƿ��㹻
                ReadData = -1
                errString = "CWebDWData.ReadDataq���ݸ�ʽ����:��������������!��:" & lineId
                Exit Function
            End If
            
            ReDim Preserve DataArray(lineId * colNum + 1)     '���¶������ݴ�С������ԭ������
            
            For colid = 1 To colNum
                DataArray((lineId - 1) * colNum + colid) = sdarray(LBound(sdarray) - 1 + colid) '�е����ݴ洢
            Next
        End If
        
        lineId = lineId + 1
    Next
    
End Function
'�õ��е�����
Public Function GetRowCount() As Long
    Dim iTotalNum As Long
    iTotalNum = UBound(DataArray) - LBound(DataArray) + 1
    If getColumnNumber() > 0 Then
        GetRowCount = iTotalNum / getColumnNumber()
    Else
        GetRowCount = 0
    End If
End Function

'�õ��е�����
Public Function getColumnNumber() As Long
    getColumnNumber = UBound(Columns) - LBound(Columns) + 1
End Function

'�õ�ָ�����е�����
Public Function getItemString(row As Long, col As Long) As String
    Dim id As Long
    id = (row - 1) * getColumnNumber() + col
    
    If id > UBound(DataArray) Then
        getItemString = ""
    Else
        getItemString = DataArray(id)
    End If
        
End Function
'����ָ�����е�����
Public Function setItemString(row As Long, col As Long, sData As String) As String
    Dim id As Long
    id = (row - 1) * getColumnNumber() + col
    
    If id > UBound(DataArray) Then
        setItemString = "Err:setItemString:����Խ��!"
        Exit Function
    Else
        DataArray(id) = sData
        setItemString = ""
    End If

End Function
'�����е���ţ��õ��е�����
Public Function getColumnName(colid) As String
    If colid <= getColumnNumber Then
        getColumnName = Columns(colid + LBound(Columns) - 1)
    Else
        getColumnName = ""
    End If
End Function

Private Sub Class_Initialize()
    ReDim DataArray(1)
    ReDim Columns(1)
End Sub