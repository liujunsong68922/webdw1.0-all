VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWData"
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

Public PrimaryBuffer As New CWebDWData_DataBuffer   '��Buffer����
Public FilterBuffer As New CWebDWData_DataBuffer    '����Buffer����
Public DeleteBuffer As New CWebDWData_DataBuffer    'ɾ��Buffer����

Public errString As String      '�������ʧ�ܣ�����Ĵ�����Ϣ��
Private data_filter As String   '���ݵĹ�����������
Private data_sorter As String   '���ݵ�������������

'������������������ַ����ж�ȡ���ݣ����columnArray��lineArray
'����0 �ɹ�
'����-1 ʧ�ܣ�������Ϣ������errString��
'sindata    ��������
'state      ����״̬,��ѡ�Ĭ��Ϊnormal
Public Function InitData(sindata As String, Optional state As String = "normal") As Long
    PrimaryBuffer.InitData sindata, state
    
    Dim sColumn As String                   'sColumnȡsindata��һ��,�����ж���
    sColumn = PrimaryBuffer.GetColumnString
    
    FilterBuffer.InitData sColumn
    DeleteBuffer.InitData sColumn
    
End Function

'����������������е����ݣ�ֻ���������Ľṹ
Public Function ResetData() As Long
    
    PrimaryBuffer.ResetData
    FilterBuffer.ResetData
    DeleteBuffer.ResetData
    
End Function

'����������ɾ��һ��
'���崦����ʽ�ǣ���primarybuffer��ɾ��һ�У���������ǰ��
'����һ�в��뵽deletebuffer��ȥ�������һ��

Public Function DeleteRow(rowid As Long) As Long
    Dim sdata As String
    Dim newrowid As Long
    Dim colid As Long
    Dim iret As Long
    
    sdata = ""
    
    If rowid > 0 And rowid <= PrimaryBuffer.RowNumber Then
        
        '���Ƶ�ǰ����
        sdata = PrimaryBuffer.GetRowString(rowid)
        newrowid = DeleteBuffer.InsertRow(0, sdata)
        
        '�����������ݵ�ԭʼ����
        For colid = 1 To PrimaryBuffer.ColNumber
            sdata = PrimaryBuffer.GetOriginalItemString(rowid, colid, iret)
            If iret = -1 Then
                DeleteRow = -1
                Exit Function
            End If
            DeleteBuffer.SetOriginalItemString newrowid, colid, sdata, iret
            
            If iret = -1 Then
                DeleteRow = -1
                Exit Function
            End If
            
            sdata = PrimaryBuffer.GetRowState(rowid, iret)
            DeleteBuffer.SetRowState newrowid, sdata, iret
        Next
        
        'ɾ��ԭbuffer������
        PrimaryBuffer.DeleteRow (rowid)
    End If

End Function

'��primarybuffer�в���һ��,��һ�еı��Ϊnew
Public Function InsertRow(rowid As Long, sdata As String) As Long
    Dim iret As Long
    iret = PrimaryBuffer.InsertRow(rowid, sdata)
    InsertRow = iret
    If iret = -1 Then
        errString = PrimaryBuffer.errString
    End If
End Function

'�õ��е�����
Public Function GetRowCount(Optional BufferType As Integer = 1) As Long
    Select Case BufferType
        Case 1
            GetRowCount = PrimaryBuffer.RowNumber
        Case 2
            GetRowCount = FilterBuffer.RowNumber
        Case 3
            GetRowCount = DeleteBuffer.RowNumber
        Case Else
            GetRowCount = 0
    End Select
End Function

'�õ��е�����
Public Function GetColumnNumber(Optional BufferType As Integer = 1) As Long
    Select Case BufferType
        Case 1
            GetColumnNumber = PrimaryBuffer.ColNumber
        Case 2
            GetColumnNumber = FilterBuffer.ColNumber
        Case 3
            GetColumnNumber = DeleteBuffer.ColNumber
        Case Else
            GetColumnNumber = 0
    End Select
    
End Function

'��������:�õ�ָ�����е�����
'row:�к�
'col:�к�
'buffertype: ��ѡ��buffer���ͣ�Ĭ��Ϊ��������
Public Function GetItemString(row As Long, col As Long, Optional BufferType As Integer = 1) As String
    Dim iret As Long
    Dim sret As String
    
    '���ݲ�ͬ��buffertype�����в�ͬ����ĵ���
    Select Case BufferType
        Case 1
            sret = PrimaryBuffer.GetItemString(row, col, iret)
        Case 2
            sret = FilterBuffer.GetItemString(row, col, iret)
        Case 3
            sret = DeleteBuffer.GetItemString(row, col, iret)
    End Select
    
    GetItemString = sret
        
End Function

'��������������ָ�����е�����
'row: �к�
'col: �к�
'buffertype ��ѡ�Ĭ��Ϊ1
Public Function SetItemString(row As Long, col As Long, sdata As String, _
                                Optional BufferType As Integer = 1) As Long
    
    Dim iret As Long
    
    If BufferType = 1 Then
        iret = PrimaryBuffer.SetItemString(row, col, sdata)
        If iret = -1 Then
            errString = PrimaryBuffer.errString
        End If
    End If
    If BufferType = 2 Then
        iret = FilterBuffer.SetItemString(row, col, sdata)
        If iret = -1 Then
            errString = FilterBuffer.errString
        End If
    End If
    If BufferType = 3 Then
        iret = DeleteBuffer.SetItemString(row, col, sdata)
        If iret = -1 Then
            errString = DeleteBuffer.errString
        End If
    End If
    
    SetItemString = iret
        
End Function

Private Sub Class_Initialize()
    '���ʼ��ʱ������������ͬbuffer�����ͱ���
    PrimaryBuffer.BufferType = 1        '1������������
    FilterBuffer.BufferType = 2         '2�������˻�����
    DeleteBuffer.BufferType = 3         '3����ɾ��������
    data_filter = ""                    'Ĭ�������û�����ݵĹ�������
    
End Sub

'����DataBuffer�ĵ�ǰ״̬���õ�Ҫ���µ�SQL��䣬
'�˴����ص��Ƕ���SQL��䣬�����һ��String��
'���SQL���֮����chr(13)chr(10)�����зָ�
'���һ�в������س�����
'��PrimaryBuffer��DeleteBuffer�м������ݣ�FilterBuffer���漰
'sTableName     ���ݱ�����
'iret           ���ر�־λ0 ���� -1 ʧ��
Public Function GetUpdateSql(stablename As String, ByRef iret As Long) As String

    Dim sql1 As String
    Dim sql2 As String
    
    sql1 = PrimaryBuffer.GetAllUpdateSQL(stablename, iret)
    If iret = -1 Then
        GetUpdateSql = ""
        Exit Function
    End If
    
    sql2 = DeleteBuffer.GetAllUpdateSQL(stablename, iret)
    If iret = -1 Then
        GetUpdateSql = ""
        Exit Function
    End If
    
    If sql1 <> "" Then
        GetUpdateSql = sql1 & Chr(13) & Chr(10) & sql2
    Else
        GetUpdateSql = sql2
    End If
End Function

'�ڳɹ�����Update�Ժ���д���
'���DeleteBuffer
'��primaryBuffer�е�modify��״̬��Ϊnormal
Public Function AfterUpdate() As Long
    
    '���DeleteBuffer
    DeleteBuffer.Init
    
    Dim rowid As Long
    Dim iret As Long
    For rowid = 1 To PrimaryBuffer.RowNumber
        PrimaryBuffer.SetRowState rowid, "normal", iret
    Next
        
End Function

'�õ����е��ַ���
Public Function GetAllData() As String
    GetAllData = PrimaryBuffer.GetAllData()
End Function

'�õ��е����
Public Function GetColIdByName(colname As String) As Long
    GetColIdByName = PrimaryBuffer.GetColIdByName(colname)
End Function

'�õ�ָ���е�״̬����
'��DataArray�ж�ȡ����Ӧ�е�colnumber + 1�ı����ʹ�����״̬
Public Function GetRowState(row As Long, ByRef iret As Long) As String
    GetRowState = PrimaryBuffer.GetRowState(row, iret)
End Function

'�õ���ǰ��������ݹ�������
Public Function GetDataFilter() As String
    GetDataFilter = data_filter
End Function

'���õ�ǰ�����ݹ�������
'����0�������óɹ�
Public Function SetDataFilter(Filter As String) As Long
    data_filter = Filter
    SetDataFilter = 0
End Function

'�˹�����Ҫһ���﷨��������֧�֣�������ÿһ�еķ���ֵ�Ƿ���Boolean�͵�
'�������Ƿ�Ҫ��������˻�����֮��
'�����һ������Ҫ�ȴ�VB�Ľ���������Ժ����ʵ��
'��ʱ������
'���ֱ��ʹ��VB�ṩ�Ľ�������δ�������޷����������������������
'�����Ļ���Ҫ�ܺܶ��������
Public Function Filter() As Long
    'TODO:�����һ����
End Function

'�����������õ���ǰ���ݴ������õ�������������
Public Function GetDataSorter() As String
    GetDataSorter = data_sorter
End Function

'�����������������ݴ��ڵ�ǰ��������������
'����0�������óɹ�
Public Function SetDataSorter(sorter As String) As Long
    data_sorter = sorter
    SetDataSorter = 0
End Function

'���������������������������ʽ����������
Public Function Sort() As Long
    Sort = PrimaryBuffer.Sort(data_sorter)
    errString = PrimaryBuffer.errString
End Function
