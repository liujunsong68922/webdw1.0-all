VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWUI_ChildDW"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�����ݴ��ڵĽ��������࣬VB������
Rem ��Ҫ���ܣ�ר���������ƺ���ʾ�����ݴ���
Rem �󲿷ִ����CWebDWUI����,�����ʵ��ļ�
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2009-2010
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Public webdw As CWebDW                                      '����webdw��Ӧ���ļ���ȡ��(�����һ��ָ��)
Public errString As String                                  '���صĴ�����Ϣ�ַ���
Public webdwData As CWebDWData                              '����webdw�����ݶ�����

'------------����Ķ����ǽ����ϵĶ�̬Ԫ�ض�Ӧ���¼�����������
Private WithEvents myTextBox As TextBox             'myTextBox��һ��������ı������������ı����¼���Ӧ
Attribute myTextBox.VB_VarHelpID = -1
'------------���涯̬Ԫ�ض������

Public parentControlName As String                  '�����ݴ��ڵĿؼ�����
Public dataColumnName As String                      '����������

Private parentDW As CWebDWUI                        '���ø����ݴ��ڵľ��
Private parentClassDW As CWebDWUI_ParentDW          '���ø�������ݴ�����ľ�������಻�ٴ洢�������ظ�����

'��������������g_webdw��ֵ
'���룺gg_webdw
'�����g_webdw
Public Function SetWebDW()
    SetWebDW = parentClassDW.SetLocalWebDW
End Function

'������������ȡg_webdw��ֵ
'����:g_webdw
'���:gg_webdw
Public Function GetWebDW()
    GetWebDW = parentClassDW.GetLocalWebDW
End Function

'����ǩ�ķ���
'targetControls Ŀ�괰������û��ؼ��Ŀؼ�����
'pictTarget Ŀ��ͼƬ��
'lineNum    �к�0�������Ʊ�ͷ����������������к�
'leftpos    ����Ԫ�ص���ƫ���� leftpos <=0
'ͼ��������Դ: g_webdw
Private Function DrawLabel(targetControls As Variant, targetPict As PictureBox, convertRate As Double, _
                            lineNum As Long, Optional leftPos As Long = 0) As Long
    DrawLabel = parentClassDW.DrawLabel(lineNum, leftPos)
    
End Function

'���ı���ķ���
'targetControls Ŀ��ؼ�����
'pictTarget     Ҫ���Ƶ�ͼƬ��
'lineNum        �кţ���1��ʼ���ı���ֻ��detail������ƣ���������������
'leftpos        ��ƫ��������������ƫ��leftpos<0
Private Function DrawColumn(targetControls As Variant, targetPict As PictureBox, convertRate As Double, _
                            lineNum As Long, Optional leftPos As Long = 0) As Long
    DrawColumn = parentClassDW.DrawColumn(lineNum, leftPos)
End Function
'��ĳ�ʼ������
Private Sub Class_Initialize()
   
    Set parentClassDW = New CWebDWUI_ParentDW           '���ø���ָ�룬����һ���µĸ���
    Set webdw = parentClassDW.webdw
    Set webdwData = parentClassDW.webdwData
    
End Sub


'����dataobject����dataobject������һ���ַ���������
'����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
'����ͨ�������������з���
Public Function DW_SetDataObject(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sUIDesc As String, childFlag As Boolean) As Long
    
    DW_SetDataObject = parentClassDW.DW_SetDataObject(targetControlsArg, targetPictArg, sUIDesc, childFlag)
End Function

'����dataobject����dataobject������һ���ַ���������
'����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
'����ͨ�������������з���
Public Function DW_SetDataObjectByName(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sdwName As String) As Long
    Dim iret As Long
    iret = parentClassDW.DW_SetDataObjectByName(targetControlsArg, targetPictArg, sdwName)
    getParentErr iret
    DW_SetDataObjectByName = iret
End Function

'����DW�ķ���,begId������ʼ���Ƶ�һ��.begId>0
'targetControls: Ŀ��ؼ��ļ��� ����
'targetPict:    Ҫ���Ƶ�Ŀ��ͼƬ�� ����
Public Function DrawDW() As Long
    DrawDW = parentClassDW.DrawDW
        
End Function

'�ڽ����ϻ��ߵķ���
'ͨ���������֧���ڽ����Ͻ��л���
'leftpos ��ƫ���� leftpos<=0
Public Function DrawLine(targetControls As Variant, targetPict As PictureBox, _
                            convertRate As Double, lineNum As Long, _
                            Optional leftPos As Long = 0) As Long
    DrawLine = parentClassDW.DrawLine(lineNum, leftPos)
End Function



'���ݴ��ڵļ������ܣ��ȼ۹���dw.Retrieve()
'ǰ���������Ѿ�������datawindow����
'args�Ǽ������õĲ�������������֮����TAB���ָ�
'20090116�Բ��������޸ģ�targetControls��targetPict������Ҫ�ⲿ����
Public Function DW_Retrieve(Optional args As String = "") As Long
    DW_Retrieve = parentClassDW.DW_Retrieve(args)
End Function


'���ø��������ݣ�����ʼ�����ݴ洢
'targetControls �ؼ��ļ���
'pictTarget     Ҫ��ͼ�Ŀؼ�
'indata         �������õ�����
'datastate      ��ѡ��,���ݵ�״̬,Ĭ��Ϊ"normal"
Public Function SetData(indata As String, _
                        Optional datastate As String = "normal") As Long
    SetData = parentClassDW.SetData(indata, datastate)
End Function
'�����������õ���ǰ��
'Ҫ�õ���ǰ�У���Ҫ���뵱ǰ���ڶ����ID��
Public Function DW_GetRow() As Long
    DW_GetRow = parentClassDW.DW_GetRow
End Function
'���õ�ǰ��
Public Function DW_SetRow(rowid As Long) As Long
    DW_SetRow = parentClassDW.DW_SetRow(rowid)
    
End Function

'���ݸ����ĵ�ǰ�ؼ������֣��жϵ�ǰ�����е����
'����-1����ʧ�ܣ�>=0�������
Public Function GetRowIdColumnId(currentControlName As String, _
                                    ByRef rowid As Long, ByRef colid As Long) As Long
    GetRowIdColumnId = parentClassDW.GetRowIdColumnId(currentControlName, rowid, colid)
End Function

'���ݸ�����columnname�����㷵�ص��б��(1 based)
'Public Function GetColumnIdByColumnName(colname As String) As Long
'    GetColumnIdByColumnName = parentClassDW.GetColumnIdByColumnName(colname)
'End Function

'��������,ֻ������PrimaryBuffer������
Public Function SetItemString(rowid As Long, colid As Long, sData As String) As String
    webdwData.SetItemString rowid, colid, sData
End Function

'�õ����Ҫ�ύ����̨�ĸ������ݿ�������
'��������֮����chr(13)chr(10)���ָ�
'Ŀǰ��֧�ֵ����ĸ��²�������Ҫ��SQL����
Public Function DW_GetSQLPreview(ByRef iret As Long) As String
        
    DW_GetSQLPreview = parentClassDW.DW_GetSQLPreview(iret)
    
       
End Function

'ִ��Dw��Update����,��������
'����0�������óɹ�
'����-1�������÷�������
'��targetControls,targetPict���Ӳ�����ȥ��
Public Function DW_Update() As Long
    
    DW_Update = parentClassDW.DW_Update
    
End Function

'�õ���ǰDataWindow�ڵļ�¼����
'����-1����ʧ��
'�����������ֵ>=0
Public Function DW_RowCount() As Long
    
    DW_RowCount = parentClassDW.DW_RowCount
End Function

'�����ݴ����в���һ����¼������������¼�ĵ�ǰ�кţ��������������-1
'rowid����Ҫ������кţ����Ϊ0������������
Public Function DW_InsertRow(rowid As Long) As Long
    DW_InsertRow = parentClassDW.DW_InsertRow(rowid)
End Function

'���õ�ǰ���ı��������ʹ֮������Ӧ�ⲿ�¼�
Public Function SetTextBox(textArg As TextBox) As Long
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    iret = GetRowIdColumnId(textArg.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> parentClassDW.DW_GetRow Then
            parentClassDW.DW_SetRow (rowid)
            parentClassDW.DrawDW_ImageOnly
        End If
    End If

    Set myTextBox = textArg
    'myTextBox_Click
End Function

'�����ı����ϵ���ʱ�����õ�ǰ��
'δ������Ԫ�ض���ı༭��������е����ؼ�����
Private Sub myTextBox_Click()
    Dim iret As Long
    Dim rowid As Long
    Dim colid As Long
    
    'MsgBox "click"
    
    iret = GetRowIdColumnId(myTextBox.Name, rowid, colid)
    If iret = 0 Then
        If rowid <> parentClassDW.DW_GetRow Then
            parentClassDW.DW_SetRow rowid
        End If
    End If
    
End Sub


'���ø����ݴ��ڵľ��
Public Function SetParentDW(pui As CWebDWUI) As Long
    Set parentDW = pui
    SetParentDW = 0
End Function

Public Function GetItemString(rowid As Long, colid As Long)
    GetItemString = webdwData.GetItemString(rowid, colid)
End Function

Private Function drawImageOnly() As Long
    parentClassDW.DrawDW_ImageOnly
End Function


'�õ�����Ĵ���
Private Function getParentErr(iret As Long) As Long
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
End Function

'���ı�������˫����ʱ���������ڸ����ڵĵ�ǰ�е�ǰ�еĶ�Ӧ��ֵ
Private Sub myTextBox_DblClick()
    Dim dataColId As Long
    Dim selectdata As String
    
    Dim pcolId As Long
    Dim prowId As Long
    Dim rowid As Long
    '�����Ӵ��ڵĿؼ��Ͻ���˫���Ժ����ø����ݴ��ڵĶ�Ӧ���ݵ�����
    If Not parentDW Is Nothing And dataColumnName > "" Then
        dataColId = webdw.GetColumnIdByColumnName(dataColumnName) '�õ����������
            
        rowid = DW_GetRow() '�õ���ǰ��
        
        If dataColId > 0 And rowid > 0 Then
            selectdata = GetItemString(rowid, dataColId)    '�õ�ѡ�������
            
            parentDW.GetRowIdColumnId parentControlName, prowId, pcolId '��ȡ�����ڵ�����,����
            
            If prowId > 0 And pcolId > 0 And Len(selectdata) > 0 Then
                parentDW.DW_SetItem prowId, pcolId, selectdata   '���ø���������
                parentDW.DrawDW  '���»���
            End If
        End If
    End If

End Sub

