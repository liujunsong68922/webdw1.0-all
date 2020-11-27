VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWData_DataBuffer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�ؼ���Ӧ�����ݴ洢����������ʹ�õ����ݴ洢������
Rem �������ר���������岻ͬ�����ݻ�����
Rem һ��DataWindow�����»�����:
Rem Primary! = 1 ��������������������ǽ�����ʾ�õĻ�����
Rem Filter! = 2  ���˻������������������Ź��˳�ȥ������
Rem Delete! = 3  ɾ�����ݻ�����������ɾ���������ȷŵ��������������
Rem ����������ȷ����Ĺ��ܻ��֣�����������
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Public BufferType As Integer    '�����������ͣ�1. Primary 2. Filter 3.Delete

Dim Columns() As String         '�����ļ��ϣ����Է������ݣ�������DW����
Dim DataArray() As String       '�����������ַ����������洢

Public errString As String      '�������ʧ�ܣ�����Ĵ�����Ϣ��

Public RowNumber As Long        '���ݵ�������
Public ColNumber As Long        '�е�����
Public ColLength As Long        'ÿһ�еĴ洢����

'���Ա��ʼ��
Public Function Init() As Integer
    ReDim Columns(1)
    ReDim DataArray(1000)
    errString = ""
    RowNumber = 0
    ColNumber = 0
    ColLength = 0
End Function


'������������������ַ����ж�ȡ���ݣ����columnArray��lineArray
'��һ�����е������������������Ƕ�Ӧ������
'���ﲻ����Nullֵ�����ݿ��ϵ�nullֵ��ת��Ϊ���ַ���

'����0 �ɹ�
'����-1 ʧ�ܣ�������Ϣ������errString��
'sindata    �������ݣ��ַ�����ʾ
'state      ����״̬��Ĭ��Ϊ"normal"
Public Function InitData(sindata As String, Optional state As String = "normal") As Long
    Init                        '�������ʼ���ķ���
    
    Dim sDataArray As Variant   'ԭʼ���ݰ��зֽ�õ�������
    Dim vline As Variant        'ԭʼ����ÿһ��
    Dim sline As String         'ת�����ַ�����ԭʼ����ÿһ��
    
    Dim sdarray As Variant      '�м������ÿһ�зֽ�������е�����
    
    Dim lineId As Long          'ԭʼ���ݵ��кţ�0�������⣬�����������
    Dim colid As Long           '�е����
    
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
            ColNumber = UBound(Columns) + 1                '�е�����,split���ص�������zero-based.
            ColLength = ColNumber * 2 + 1                  'ÿһ�еĳ��ȣ�����colnumber*2��1
        Else
            If Trim(sline) = "" Then                        '�������У��˳�ѭ��
                Exit For
            End If
            
            sdarray = Split(sline, Chr(9))                 '��chr(9)���ֽ���,�ֽ�ɶ��������
            
            If UBound(sdarray) <> UBound(Columns) Then     '����������Ƿ��㹻�����ݲ����򱨴���
                InitData = -1
                errString = "CWebDWData.ReadDataq���ݸ�ʽ����:��������������!��:" & lineId
                Exit Function
            End If
            
            RowNumber = lineId                              '�洢��ǰ����
            
            If UBound(DataArray) < RowNumber * ColLength Then
                ReDim Preserve DataArray(UBound(DataArray) + 1000)  'һ�η���1000���ռ䣬�����η���
            End If
            
            
            For colid = 1 To ColNumber
                '��nullֵ�����⴦��:����̨���ص�NULL���һ�����ַ���
                If UCase(sdarray(colid - 1)) = "NULL" Then
                    sdarray(colid - 1) = ""
                End If
            
                DataArray((lineId - 1) * ColLength + colid) = sdarray(colid - 1) '�е����ݴ洢
                DataArray((lineId - 1) * ColLength + ColNumber + colid) = _
                                                              sdarray(colid - 1) '�ٴ洢һ����Ϊ����
            Next
            DataArray(lineId * ColLength) = state      'initData������������״̬
            
        End If
        
        lineId = lineId + 1
    Next
End Function


'�õ�ָ�����е�����
'row �к�
'col �к�
'iret ����ֵ
Public Function GetItemString(row As Long, col As Long, ByRef iret As Long) As String
    '�ж��е�׼ȷ��
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        GetItemString = ""
        Exit Function
    End If
    
    '�ж��е�׼ȷ��
    If col < 1 Or col > ColNumber Then
        iret = -1
        errString = "Invalid col:" & col
        GetItemString = ""
        Exit Function
    End If
    
    '���ؽ������,GetItemStringֻ�ܷ��ص�ǰֵ��Ҫ�õ�ԭʼֵ��Ҫ������������
    iret = 0
    GetItemString = DataArray((row - 1) * ColLength + col)
    
End Function

'�õ������ָ�����е�����
'row �к�
'col �к�
'iret ����ֵ
Public Function GetOriginalItemString(row As Long, col As Long, ByRef iret As Long) As String
    '�ж��е�׼ȷ��
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        GetOriginalItemString = ""
        Exit Function
    End If
    
    '�ж��е�׼ȷ��
    If col < 1 Or col > ColNumber Then
        iret = -1
        errString = "Invalid col:" & col
        GetOriginalItemString = ""
        Exit Function
    End If
    
    '���ؽ������,GetOriginalItemStringֻ�ܷ���ԭʼֵ
    iret = 0
    GetOriginalItemString = DataArray((row - 1) * ColLength + ColNumber + col)
    
End Function

'�õ�ָ���е�״̬����
'��DataArray�ж�ȡ����Ӧ�е�colnumber + 1�ı����ʹ�����״̬
Public Function GetRowState(row As Long, ByRef iret As Long) As String
    '�ж��е�׼ȷ��
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        GetRowState = ""
        Exit Function
    End If
    
    iret = 0
    GetRowState = DataArray(row * ColLength)  '���ÿ��5�У���11�����ݾʹ�����״̬
End Function

'����ָ���е�״̬����
Public Function SetRowState(row As Long, state As String, ByRef iret As Long) As String
    '�ж��е�׼ȷ��
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" + row
        SetRowState = ""
        Exit Function
    End If
    
    iret = 0
    DataArray(row * ColLength) = state
    SetRowState = ""

End Function


'����ָ�����е�����,����ֵ����
Public Function SetItemString(row As Long, col As Long, sdata As String) As Long
    
    '�ж��е�׼ȷ��
    If row < 1 Or row > RowNumber Then
        errString = "Invalid row:" & row
        SetItemString = -1
        Exit Function
    End If
    
    '�ж��е�׼ȷ��
    If col < 1 Or col > ColNumber Then
        errString = "Invalid col:" & col
        SetItemString = -1
        Exit Function
    End If
    
    DataArray((row - 1) * ColLength + col) = sdata        'ֻ�����õ�ǰֵ����ʷ�����޷�����
    
    If DataArray(row * ColLength) = "normal" Then         'ֻ�е���ǰ״̬Ϊnormalʱ���޸�Ϊ����
        DataArray(row * ColLength) = "modify"             '��һ��״̬Ϊ����
    End If
    
    SetItemString = 0
End Function

'����ָ�����е�ԭʼ����,����ֵ����
Public Function SetOriginalItemString(row As Long, col As Long, sdata As String, _
                                ByRef iret As Long) As String
    '�ж��е�׼ȷ��
    If row < 1 Or row > RowNumber Then
        iret = -1
        errString = "Invalid row:" & row
        SetOriginalItemString = ""
        Exit Function
    End If
    
    '�ж��е�׼ȷ��
    If col < 1 Or col > ColNumber Then
        iret = -1
        errString = "Invalid col:" & col
        SetOriginalItemString = ""
        Exit Function
    End If
    
    iret = 0
    DataArray((row - 1) * ColLength + ColNumber + col) = sdata         '������ʷ����
    
    iret = 0
    SetOriginalItemString = ""
End Function


'�����е���ţ��õ��е�����
Public Function GetColumnName(colid) As String
    If colid <= ColNumber And colid >= 0 Then
        GetColumnName = Columns(colid - 1)
    Else
        GetColumnName = ""
    End If
End Function

'��ĳ�ʼ��
Private Sub Class_Initialize()
    Init    '�������ʼ���ķ���
End Sub

'������������DataArray�в���һ�м�¼�����м�¼���ַ�������ʾ
'rowid:Ҫ����ĵ�ǰ�кţ������Ժ���һ�����ݽ�������ǰ�У����rowid=0�������׷��
'sline:���ַ�����ʾ��һ�м�¼
'����ֵ��>0 ���������Ժ���кţ�-1����ʧ�ܣ�������Ϣ��errString��
Public Function InsertRow(insertid As Long, sline As String) As Long
    Dim data() As String
    Dim colid As Long
    Dim rowid As Long
    
    If insertid < 0 Or insertid > RowNumber Then
        InsertRow = -1
        errString = "Invalid rowid:" + rowid
        Exit Function
    End If
    
    data = Split(sline, Chr(9))
    
    If UBound(data) <> ColNumber - 1 Then
        InsertRow = -1
        errString = "�����������к�Ҫ�󲻷���:" + sline
        Exit Function
    End If
    
    '�ж��Ƿ���Ҫ��չ�洢����
    If UBound(DataArray) < (RowNumber + 1) * ColLength Then
        ReDim Preserve DataArray(UBound(DataArray) + 1000)  'һ�η���1000���ռ䣬�����η���
    End If

    RowNumber = RowNumber + 1
    
    If insertid > 0 Then
        '���ƶ���������,����ƶ�һ��,������״̬
        For rowid = RowNumber - 1 To insertid + 1 Step -1
            For colid = 1 To ColLength
                DataArray(rowid * ColLength + colid) = DataArray((rowid - 1) * ColLength + colid)
            Next
        Next
        rowid = insertid
    Else
        rowid = RowNumber
    End If
    
    For colid = 1 To ColNumber
        DataArray((rowid - 1) * ColLength + colid) = ""     '��ʼ��
    Next
    
    '���Ʋ�����һ�е�����
    For colid = 1 To ColNumber
        DataArray((rowid - 1) * ColLength + colid) = data(colid - 1)
    Next
    DataArray(rowid * ColLength) = "new"                    'Ĭ������£�����Ϊnew,��������ܻ��޸����ֵ
    InsertRow = rowid
    
End Function

'�����������ӵ�ǰ�����ݼ�����ɾ��һ�м�¼
'������¼��ǰ�ƶ�һ����¼
'����0 ɾ���ɹ�
'����-1 ɾ��ʧ��
Public Function DeleteRow(delRowId As Long) As Long
    '�ж�delrowid�ĺϷ���
    If delRowId <= 0 Or delRowId > RowNumber Then
        DeleteRow = -1
        errString = "invalid delete row:" + delRowId
        Exit Function
    End If
    
    Dim colid As Long       '�к�
    Dim rowid As Long       '�к�
    
    For rowid = delRowId To RowNumber - 1
        For colid = 1 To ColLength
            '������һ�е�����,�����ƶ�״̬
            DataArray((rowid - 1) * ColLength + colid) = DataArray(rowid * ColLength + colid)
        Next
    Next
    
    rowid = RowNumber
    For colid = 1 To ColLength                          '���һ�е��������,������״̬
        DataArray((rowid - 1) * ColLength + colid) = ""
    Next
    
    RowNumber = RowNumber - 1                               '��������1
    DeleteRow = 0
End Function

'��ĳһ�б�ʾ��һ����׼���ַ���������֮����chr(9)�ָ�
'����кŷǷ������ؿ��ַ���
Public Function GetRowString(rowid As Long) As String
    If rowid <= 0 Or rowid > RowNumber Then
        GetRowString = ""
        errString = "Invalid row:" + rowid
        Exit Function
    End If
    
    Dim colid As Long   '�к�
    Dim sret As String  '�����ַ���
    sret = ""
    For colid = 1 To ColNumber
        If colid < ColNumber Then
            sret = sret & DataArray((rowid - 1) * ColLength + colid) & Chr(9)
        Else
            sret = sret & DataArray((rowid - 1) * ColLength + colid)
        End If
    Next
    
    '�����ַ���
    GetRowString = sret
End Function

'��ĳһ�е�ԭʼ���ݱ�ʾ��һ����׼���ַ���������֮����chr(9)�ָ�
'����кŷǷ������ؿ��ַ���
Public Function GetOriginalRowString(rowid As Long) As String
    If rowid <= 0 Or rowid > RowNumber Then
        GetOriginalRowString = ""
        errString = "Invalid row:" + rowid
        Exit Function
    End If
    
    Dim colid As Long   '�к�
    Dim sret As String  '�����ַ���
    sret = ""
    For colid = 1 To ColNumber
        If colid < ColNumber Then
            sret = sret & DataArray((rowid - 1) * ColLength + ColNumber + colid) & Chr(9)
        Else
            sret = sret & DataArray((rowid - 1) * ColLength + ColNumber + colid)
        End If
    Next
    
    '�����ַ���
    GetOriginalRowString = sret
End Function



'�õ�column()���ַ�����ʾ,��һ���������������ʼ������dw
Public Function GetColumnString() As String
    Dim sret As String
    Dim colid As Long
    For colid = 1 To ColNumber
        If colid < ColNumber Then
            sret = sret & Columns(colid - 1) & Chr(9)
        Else
            sret = sret & Columns(colid - 1)
        End If
    Next
    GetColumnString = sret
    
End Function

'�����е����ݶ���ϳ�һ���ַ�������
Public Function GetAllData() As String
    Dim sret As String
    Dim rowid As Long
    
    sret = ""
    For rowid = 1 To RowNumber
        If sret = "" Then
            sret = GetRowString(rowid)
        Else
            sret = sret & Chr(13) & Chr(10) & GetRowString(rowid)
        End If
    Next
    GetAllData = sret
    
End Function

'����������������е����ݣ���������Ϣ
Public Function ResetData() As Long
    
    ReDim DataArray(1000)
    RowNumber = 0
    
End Function

'�õ������еĸ���SQL������
Public Function GetAllUpdateSQL(stablename As String, ByRef iret As Long) As String
    Dim rowid As Long
    Dim strsql As String
    Dim sql1 As String
    
    strsql = ""
    For rowid = 1 To RowNumber
        sql1 = GetUpdateSql(stablename, rowid, iret)
        If iret = -1 Then
            GetAllUpdateSQL = ""
            Exit Function
        End If
        
        If sql1 <> "" Then
            If strsql = "" Then
                strsql = sql1
            Else
                strsql = strsql & Chr(13) & Chr(10) & sql1
            End If
        End If
    Next
    
    GetAllUpdateSQL = strsql
    
    
End Function


'�õ�ָ��һ�е�Update SQL���
'����� new,����һ��Insert���(����primarybuffer��)
'����� modify,����һ��Update���(����primarybuffer��)
'����� modify,normal ,����һ��Delete���(����deleteBuffer��)
'sTableName     Ҫ���µ����ݱ�����
'rowid          Ҫ���µ��к�
'iret           ���ر�־λ 0 ���� -1 ��������
Public Function GetUpdateSql(stablename As String, rowid As Long, ByRef iret As Long) As String
    Dim state As String
    Dim strSet As String
    Dim strWhere As String
    
    'part1 primarybuffer�Ĵ���,����״̬����Update��Insert
    If BufferType = 1 Then
        state = GetRowState(rowid, iret)
        If iret = -1 Then
            GetUpdateSql = ""
            Exit Function
        End If
        
        '������������
        If state = "new" Then
            GetUpdateSql = GenerateInsertSQL(stablename, rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
            
            Exit Function
        End If
        
        '������������
        If state = "modify" Then
            strSet = GetSetClause(rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
            
            strWhere = GetWhereClause(rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
            
            GetUpdateSql = "Update " & stablename & strSet & strWhere
            Exit Function
        End If
        
        GetUpdateSql = ""                       '����״̬�²�����SQL���,ֱ�ӷ���
        Exit Function
    End If
    
    'part2 filterBuffer�Ĵ���                   'Ŀǰ�ݲ�����
    If BufferType = 2 Then
        iret = 0
        GetUpdateSql = ""                       'Ŀǰ�ݲ�����
    End If
    
    'part3 deleteBuffer�Ĵ���
    If BufferType = 3 Then
        state = GetRowState(rowid, iret)        '�����ǰ״̬��new,������
        If state <> "new" Then
        
            strWhere = GetWhereClause(rowid, iret)
            If iret = -1 Then
                GetUpdateSql = ""
                Exit Function
            End If
                
            GetUpdateSql = "Delete " & stablename & strWhere
            Exit Function
        End If
    End If
    
    GetUpdateSql = ""

End Function

'����Insert����ķ���
'��ʱֻ���ǵ�����ά������
'����Ĳ�����ʽ����
Private Function GenerateInsertSQL(stablename As String, rowid As Long, ByRef iret As Long) As String
    If BufferType <> 1 Then
        iret = -1
        errString = "Wrong Buffer Type for Insert:" & BufferType
        GenerateInsertSQL = ""
        Exit Function
    End If
    
    If stablename = "" Then
        iret = -1
        errString = "Empty tableName"
        GenerateInsertSQL = ""
        Exit Function
    End If
        
    
    Dim state As String
    state = GetRowState(rowid, iret)
    
    Dim scollist As String
    Dim strsql As String
    Dim colid As Long
    
    If iret = -1 Then       '��ȡ��״̬��������
        GenerateInsertSQL = ""
        Exit Function
    End If
    
    If state <> "new" Then                                  '�����½�״̬
        iret = -1
        errString = "Wrong Row State for Insert:" & state
        GenerateInsertSQL = ""
        Exit Function
    Else                                                    '���½�״̬
        scollist = GetColumnList()
        If scollist = "" Then
            iret = -1
            errString = "Empty Column List"
            GenerateInsertSQL = ""
            Exit Function
        End If
        strsql = "Insert Into " & stablename & "(" & scollist & ") Values("
        
        For colid = 1 To ColNumber
            If colid < ColNumber Then
                strsql = strsql & "'" & GetItemString(rowid, colid, iret) & "',"
            Else
                strsql = strsql & "'" & GetItemString(rowid, colid, iret) & "')"
            End If
            
            If iret = -1 Then                               '�����ж�
                GenerateInsertSQL = ""
                Exit Function
            End If
        Next
            
        GenerateInsertSQL = strsql
    End If
End Function

'�õ��е��б�,����id����,���ֶ�֮���ö��ŷָ�
Private Function GetColumnList() As String
    Dim colid As Long
    Dim slist As String
    slist = ""
    For colid = 0 To ColNumber - 1
        If colid < ColNumber - 1 Then
            slist = slist & Columns(colid) & " , "
        Else
            slist = slist & Columns(colid)
        End If
    Next
    
    GetColumnList = slist
End Function

'����rowid,���ɸ��º�ɾ��ʱ����Ҫ��Where�־�
Private Function GetWhereClause(rowid As Long, iret As Long) As String
    Dim strWhere As String
    Dim colid As Long
    Dim sdata As String
    Dim colwhere As String
    
    strWhere = ""
    For colid = 0 To ColNumber - 1
        sdata = GetOriginalItemString(rowid, colid + 1, iret)
        If iret = -1 Then
            GetWhereClause = ""
            Exit Function
        End If
        
        If sdata = "" Then      '���ַ�������ֵ����
            colwhere = Columns(colid) & " is null "
        Else
            colwhere = Columns(colid) & " = '" & sdata & "'"
        End If
        
        If strWhere = "" Then
            strWhere = colwhere
        Else
            strWhere = strWhere & " AND " & colwhere
        End If
        
    Next
    If strWhere <> "" Then
        GetWhereClause = " Where " & strWhere
    Else
        GetWhereClause = ""
    End If
End Function

'����rowid,���ɸ��º�ɾ��ʱ����Ҫ��Where�־�
Private Function GetSetClause(rowid As Long, iret As Long) As String
    Dim strSet As String
    Dim colid As Long
    Dim sdata As String
    
    strSet = " Set "
    For colid = 0 To ColNumber - 1
        sdata = GetItemString(rowid, colid + 1, iret)
        If iret = -1 Then
            GetSetClause = ""
            Exit Function
        End If
        
        If colid = 0 Then
            strSet = strSet & Columns(colid) & " = " & "'" & sdata & "' "
        Else
            strSet = strSet & " , " & Columns(colid) & " = " & "'" & sdata & "' "
        End If
    Next
    
    GetSetClause = strSet
End Function

'������������������������-1����û�ҵ�
'���ص�����Ŵ�1��ʼ����������ź�����ŵ����⣬��Ҫ���¹滮��ͳһ����
'���ڴ����е����
Public Function GetColIdByName(colname As String) As Long
    Dim colid As Long
    For colid = 0 To ColNumber - 1
        If UCase(Columns(colid)) = UCase(colname) Then
            GetColIdByName = colid + 1
            Exit Function
        End If
    Next
    GetColIdByName = -1
End Function

'���ݸ�������������������������
'sorter���������������
'sorter�ĸ�ʽΪ #1 A , #2 D(��ʱ�������������������Ҫ��)
'�����������һ��ʽ�����˳�
'������֮�䰴�ն��Ž��зָ���û��AD����Ĭ��ΪA(����)
'�������������ֵ�ͣ�������ֵ�����жϱȽ�
'���������������ֵ�ͣ������ַ��������жϱȽ�
'��ʱ��֧�����ڣ�ʱ���͵�����Ƚ�
Public Function Sort(sorter As String) As Long
    If sorter = "" Then
        Sort = 0
        Exit Function
    End If
    
    Dim rowid As Long
    Dim minrowid As Long
    For rowid = 1 To RowNumber
        minrowid = Sort_GetMinLine(sorter, rowid, RowNumber)   '�õ��ӵ�ǰ�п�ʼ��С���к�
        
        If minrowid = -1 Then                                   '������С��ʧ��
            Sort = -1                                           '����ʧ��
            Exit Function
        End If
        
        If minrowid > rowid Then                                '�ǵ�ǰ��
            Sort_SwapLine rowid, minrowid                       '��������
        End If
    Next
    
    Sort = 0
End Function

'�н����Ĺ���
'��Ҫ����������
'�����е����ݽ��н���
Private Function Sort_SwapLine(row1 As Long, row2 As Long) As Long
    '�����ж������������ȷ��
    '����������������ô�Ͳ����в�����
    If Not (row1 > 0 And row1 <= RowNumber And row2 > 0 And row2 <= RowNumber) Then
        Sort_SwapLine = -1
        Exit Function
    End If
    
    Dim colid As Long
    Dim stemp As String
    For colid = 1 To ColLength
        stemp = DataArray((row1 - 1) * ColLength + colid)
        DataArray((row1 - 1) * ColLength + colid) = DataArray((row2 - 1) * ColLength + colid)
        DataArray((row2 - 1) * ColLength + colid) = stemp
    Next
End Function

'���ݸ����������������壬��beginrow��endrow���в��ң��ҵ���С��һ����¼�ų���
'����0�������ݴ���,���ڵ�������
Private Function Sort_GetMinLine(sorter As String, beginrow As Long, endrow As Long) As Long
    If Not (beginrow > 0 And beginrow <= RowNumber And endrow > 0 And endrow <= RowNumber And beginrow <= endrow) Then
        Sort_GetMinLine = -1
        Exit Function
    End If
    
    Dim rowid As Long
    Dim irow As Long
    
    irow = beginrow
    For rowid = beginrow + 1 To endrow
        irow = Sort_Compare(sorter, irow, rowid)
        If irow = -1 Then
            Sort_GetMinLine = -1
            Exit Function
        End If
    Next
    
    Sort_GetMinLine = irow
End Function

'���ݸ����������������壬�Ƚ�rowid1,rowid2�����ݣ�
'����rowid1,rowid2�����ݽ�С���Ǹ�����
'��һ��������rowid1,rowid2���ǺϷ�������
'����-1�����Ƚ�ʧ�ܣ���������
Private Function Sort_Compare(sorter As String, row1 As Long, row2 As Long) As Long
    If sorter = "" Then
        Sort_Compare = -1
        errString = "Compare argument is empty"
        Exit Function
    End If
    
    Dim sorts() As String
    Dim sortid As Long
    Dim sortcolid As Long           '�����ֶ����
    Dim sortcoltype As String       '�����ֶ�����A ���� D ����,�����ַ�һ�ɰ�������
    Dim coldatatype As String       '�е��������Ͷ���
    Dim pos1 As Long                '#��λ��
    Dim pos2 As Long                '�ո��λ��
    Dim sdata1 As String
    Dim sdata2 As String
    
    sorts = Split(sorter, ",")  'һ�����������зֳɶ����������
    For sortid = 0 To UBound(sorts)
        pos1 = InStr(sorts(sortid), "#")
        If pos1 <= 0 Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        pos2 = InStr(pos1, sorts(sortid), " ") '�ҵ���һ���ո��λ��
        If pos2 <= 0 Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        If pos2 = pos1 + 1 Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        sortcolid = Mid(sorts(sortid), pos1 + 1, pos2 - (pos1 + 1))
        sortcoltype = UCase(Trim(Mid(sorts(sortid), pos2 + 1)))
        
        If sortcolid < 1 Or sortcolid > ColNumber Then
            Sort_Compare = -1
            errString = "Compare argument error"
            Exit Function
        End If
        
        If sortcoltype = "" Then
            sortcoltype = "A"
        ElseIf sortcoltype <> "A" And sortcoltype <> "D" Then
            Sort_Compare = -1
            errString = "Comapre argument error"
        End If
        
        '�ж�sortcolid���������ͣ�������ַ�����ֱ�ӱȽ�
        '�������ֵ�ͣ�ת������ֵ���бȽ�
        '�����ͬ����ô�Ϳ���ֱ�ӷ����˳������������һ��ѭ�����Ƚ���һ���еĴ�С
        sdata1 = DataArray((row1 - 1) * ColLength + sortcolid)
        sdata2 = DataArray((row2 - 1) * ColLength + sortcolid)
        
        Dim v1 As Double
        Dim v2 As Double
        If IsNumeric(sdata1) And IsNumeric(sdata2) Then '�������������ֵ�͵����ݣ���Ƚ�
            v1 = sdata1
            v2 = sdata2
            If v1 > v2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row2
                    Exit Function
                Else
                    Sort_Compare = row1
                    Exit Function
                End If
            ElseIf v1 < v2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row1
                    Exit Function
                Else
                    Sort_Compare = row2
                    Exit Function
                End If
            End If
            '������ȣ�����ѭ��
        Else
            '������ֵ��ֱ�ӱȽ�
            If sdata1 > sdata2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row2
                    Exit Function
                Else
                    Sort_Compare = row1
                    Exit Function
                End If
            ElseIf sdata1 < sdata2 Then
                If sortcoltype = "A" Then
                    Sort_Compare = row1
                    Exit Function
                Else
                    Sort_Compare = row2
                    Exit Function
                End If
            End If
            '������ȣ�����ѭ��
        End If
    Next
    Sort_Compare = row1     '������ȣ����ص�һ��
End Function