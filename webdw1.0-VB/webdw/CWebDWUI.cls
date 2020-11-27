VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWUI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Rem -------------------------------------------------
Rem WebDW�û������������VB������
Rem ��Ҫ���ܣ���һ���ַ�������ת������Ӧ��ͼ�ν���
Rem ͼ�ν�����ַ������������������߼�������ȫ�ȼ۵�
Rem ��������������������ͼ�ν�����,��HTML���Է����һ��ͼ�λ�����
Rem ���а����ı�,ͼ�εȶ���Ԫ��(һ��ʼ����ֻ���ı�)
Rem ͨ��һ���ļ����ѽ�������ݿ���Թ�������
Rem ��һ�汾�Ľ������������ʽ�ϸ���PB7�����ݴ����ַ�����ʽ����ȡ
Rem ������DW_��ͷ�ķ������ṩ��PB Datawindow�ؼ����ƵĹ��ܺ͵��ýӿ�
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

'�����ǹ��ñ����Ķ���
Public errString As String                                  '���صĴ�����Ϣ�ַ���
Public sqlca As CWebDWTransaction                           '����֧�֣�SQL����֧�ֶ���

'�����˽�б����Ķ���
Private parentClassDW As CWebDWUI_ParentDW                  '����һ������
Private iret As Long                                        'ͨ�õķ���ֵ����

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

'��ĳ�ʼ������
Private Sub Class_Initialize()
    Set parentClassDW = New CWebDWUI_ParentDW       '���ø��ര�ڣ����󲿷ֹ����ɸ������
    
    Set parentClassDW.childDW = New CWebDWUI_ChildDW   '�ڸ������ݴ����ϣ�����һ�������ݴ���
    parentClassDW.childDW.SetParentDW Me            '���߸���������ݴ��ڣ�˭�����ְ�
    
    Set sqlca = parentClassDW.sqlca
End Sub

'����x,y��λ�����жϵ�ǰ�Ŀؼ�λ��
'��������κοؼ��ϣ�����nothing
'���򷵻ؿؼ�������
'Public Function GetCurrentObj(x As Single, y As Single, ByRef controlId As Long) As Control
    'GetCurrentObj = parentClassDW.GetCurrentObj(x, y, controlId)
'End Function


'��һ��targetControls�����У����ݸ����ؼ������������ؼ�
'����ؼ������ڣ��򷵻�Nothing
'Public Function GetObjectByName(objName As String) As Control
'    Set GetObjectByName = parentClassDW.GetObjectByName(objName)
'End Function

'����dataobject����dataobject������һ���ַ���������
'����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
'����ͨ�������������з���
Public Function DW_SetDataObject(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sUIDesc As String) As Long
    iret = parentClassDW.DW_SetDataObject(targetControlsArg, targetPictArg, sUIDesc)
    getParentErr iret
    DW_SetDataObject = iret
End Function

'����dataobject����dataobject������һ���ַ���������
'����һ����ʵ�ֵķ�������������в��ٴ���vscroll,hscroll��Щ����
'����ͨ�������������з���
Public Function DW_SetDataObjectByName(targetControlsArg As Variant, targetPictArg As PictureBox, _
                             sdwName As String) As Long
    iret = parentClassDW.DW_SetDataObjectByName(targetControlsArg, targetPictArg, sdwName)
    getParentErr iret
    DW_SetDataObjectByName = iret
End Function


'����DW�ķ���,begId������ʼ���Ƶ�һ��.begId>0
'targetControls: Ŀ��ؼ��ļ��� ����
'targetPict:    Ҫ���Ƶ�Ŀ��ͼƬ�� ����
Public Function DrawDW() As Long
    iret = parentClassDW.DrawDW
    getParentErr iret
    DrawDW = iret
End Function


'���ݴ��ڵļ������ܣ��ȼ۹���dw.Retrieve()
'ǰ���������Ѿ�������datawindow����
'args�Ǽ������õĲ�������������֮����TAB���ָ�
'20090116�Բ��������޸ģ�targetControls��targetPict������Ҫ�ⲿ����
Public Function DW_Retrieve(Optional args As String = "") As Long
    iret = parentClassDW.DW_Retrieve(args)
    getParentErr iret
    DW_Retrieve = iret
    
End Function


'���ø��������ݣ�����ʼ�����ݴ洢
'targetControls �ؼ��ļ���
'pictTarget     Ҫ��ͼ�Ŀؼ�
'indata         �������õ�����
'datastate      ��ѡ��,���ݵ�״̬,Ĭ��Ϊ"normal"
Public Function SetData(indata As String, _
                        Optional datastate As String = "normal") As Long
    iret = parentClassDW.SetData(indata, datastate)
    getParentErr iret
    SetData = iret
End Function

'����������ɾ����ǰ��
'����0 �ɹ�
'����-1 ��������
Public Function DW_DeleteRow(rowid As Long) As Long
    iret = parentClassDW.DW_DeleteRow(rowid)
    getParentErr iret
    DW_DeleteRow = iret
End Function

'�����������õ���ǰ��
'Ҫ�õ���ǰ�У���Ҫ���뵱ǰ���ڶ����ID��
Public Function DW_GetRow() As Long
    iret = parentClassDW.DW_GetRow
    getParentErr iret
    DW_GetRow = iret
End Function
'���õ�ǰ��
Public Function DW_SetRow(rowid As Long) As Long
    iret = parentClassDW.DW_SetRow(rowid)
    getParentErr iret
    DW_SetRow = iret
End Function

'���ݸ����ĵ�ǰ�ؼ������֣��жϵ�ǰ�����е����
'����-1����ʧ�ܣ�>=0�������
Public Function GetRowIdColumnId(currentControlName As String, _
                                    ByRef rowid As Long, ByRef colid As Long) As Long
    iret = parentClassDW.GetRowIdColumnId(currentControlName, rowid, colid)
    getParentErr iret
    GetRowIdColumnId = iret
    
End Function

'���ݸ�����columnname�����㷵�ص��б��(1 based)
'Public Function GetColumnIdByColumnName(colname As String) As Long
'    iret = parentClassDW.GetColumnIdByColumnName(colname)
'    getParentErr iret
'    GetColumnIdByColumnName = iret
'End Function

'��������,ֻ������PrimaryBuffer������
Public Function DW_SetItem(rowid As Long, colid As Long, sdata As String) As Long
    iret = parentClassDW.DW_SetItem(rowid, colid, sdata)
    getParentErr iret
    DW_SetItem = iret
End Function

'�õ����Ҫ�ύ����̨�ĸ������ݿ�������
'��������֮����chr(13)chr(10)���ָ�
'Ŀǰ��֧�ֵ����ĸ��²�������Ҫ��SQL����
Public Function DW_GetSQLPreview(ByRef iret1 As Long) As String
    Dim strsql As String
    strsql = parentClassDW.DW_GetSQLPreview(iret1)
    getParentErr iret1
    DW_GetSQLPreview = strsql
    
End Function

'ִ��Dw��Update����,��������
'����0�������óɹ�
'����-1�������÷�������
'��targetControls,targetPict���Ӳ�����ȥ��
Public Function DW_Update() As Long
    iret = parentClassDW.DW_Update
    getParentErr iret
    DW_Update = iret
End Function

'�õ���ǰDataWindow�ڵļ�¼����
'����-1����ʧ��
'�����������ֵ>=0
Public Function DW_RowCount() As Long
    iret = parentClassDW.DW_RowCount
    getParentErr iret
    DW_RowCount = iret
End Function

'�����ݴ����в���һ����¼������������¼�ĵ�ǰ�кţ��������������-1
'rowid����Ҫ������кţ����Ϊ0������������
Public Function DW_InsertRow(rowid As Long) As Long
    iret = parentClassDW.DW_InsertRow(rowid)
    getParentErr iret
    DW_InsertRow = iret
End Function

'���õ�ǰ���ı��������ʹ֮������Ӧ�ⲿ�¼�
Public Function SetTextBox(textArg As TextBox) As Long
    SetTextBox = parentClassDW.SetTextBox(textArg)
End Function

'���õ�ǰ�ĵ�ѡ�������ʹ֮������Ӧ�ⲿ�¼�
Public Function SetOptionButton(OptionButtonArg As OptionButton) As Long
    SetOptionButton = parentClassDW.SetOptionButton(OptionButtonArg)
End Function

'���õ�ǰ�ĸ�ѡ�����ʹ֮������Ӧ�ⲿ�¼�
Public Function SetCheckBox(checkArg As checkbox) As Long
    SetCheckBox = parentClassDW.SetCheckBox(checkArg)
End Function

'���õ�ǰ�����������ʹ֮������Ӧ�ⲿ�¼�
Public Function SetComboBox(comboArg As combobox) As Long
    SetComboBox = parentClassDW.SetComboBox(comboArg)
End Function

'���������ݴ��ڵ�ˢ�·���
Public Function DrawChildDW() As Long
    iret = parentClassDW.DrawChildDW
    getParentErr iret
    DrawChildDW = iret
End Function

'�õ�����Ĵ���
Private Function getParentErr(iret As Long) As Long
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
End Function

'���õ�ǰ���ı��������ʹ֮������Ӧ�ⲿ�¼�
Public Function SetChildTextBox(textArg As TextBox) As Long
    SetChildTextBox = parentClassDW.SetChildTextBox(textArg)
End Function

'�����ж����ַ���
Public Function SetColumnDefString(sColDefString As String) As Long
    SetColumnDefString = parentClassDW.SetColumnDefString(sColDefString)
End Function

'�õ������õ�select��䣬�����ݿ����
Public Function DW_GetSQLSelect() As String
    DW_GetSQLSelect = parentClassDW.DW_GetSQLSelect
End Function

'���ü����õ�Select���
Public Function DW_SetSQLSelect(strsql As String) As Long
    DW_SetSQLSelect = parentClassDW.DW_SetSQLSelect(strsql)
End Function

'���ݸ���dw�﷨����ת���������ܷ���Թ���
'�˷��������﷨��Σ���Ӱ��������ʾ
'���ת��ʧ�ܣ�����-1
Public Function DW_Create(dwSyntax As String) As Long
    Dim iret As Long
    iret = parentClassDW.DW_Create(dwSyntax)
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
        
    DW_Create = iret
End Function

'�õ����ݴ��ڵ��﷨��ʾ
'����iret 0 �����ɹ� -1 ����ʧ��
Public Function DW_GetSyntax(ByRef iret As Long) As String
    DW_GetSyntax = parentClassDW.DW_GetSyntax(iret)
End Function

'���ݸ�����SQL��䣬�Լ���Ӧ�����ݴ�������
'���õ�g_webdw��ȥ
'�Ӷ���ת�����õ�һ����Ӧ�����ݴ��ڶ��������
'iret����ֵ��0 ���� -1 ʧ��
'������Ϣ�����errstring��
'���������һ��Select����С�ͽ�����
Public Function DW_SyntaxFromSQL(strsql As String, stype As String, ByRef iret As Long) As String
    DW_SyntaxFromSQL = parentClassDW.DW_SyntaxFromSQL(strsql, stype, iret)
    If iret = -1 Then
        errString = parentClassDW.errString
    End If
End Function

'�����������õ���ǰ�������������������
'������Դ:local_webdw
'������������������ߵ�Xֵ����������ö��ŷָ����
'������Grid����Tabular�������ݴ��ڣ��������ķ���""
Public Function GetGridLineInfo() As String
    GetGridLineInfo = parentClassDW.GetGridLineInfo
End Function

'���������޸������ʾ���ֶ��п���
'newX �µ��ֶ�Xֵ
'oldX �ɵ��ֶ�Xֵ
'�޸�local_webdw����ֵ
Public Function SetGridWidth(newx As Long, oldx As Long) As Long
    SetGridWidth = parentClassDW.SetGridWidth(newx, oldx)
End Function

'�������ݴ����еĵ�ǰ����
'rowid �к�
'colid �к�
'����ֵ����ǰֵ
Public Function DW_GetItemString(rowid As Long, colid As Long) As String
    DW_GetItemString = parentClassDW.DW_GetItemString(rowid, colid)
End Function

Public Sub Picture_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    parentClassDW.Picture_MouseDown Button, Shift, X, Y
End Sub
Public Sub Picture_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    parentClassDW.Picture_MouseMove Button, Shift, X, Y
End Sub
Public Sub Picture_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    parentClassDW.Picture_MouseUp Button, Shift, X, Y
End Sub

Public Sub myTextBox_GotFocus()
    parentClassDW.myTextBox_GotFocus
End Sub

'���������ߵ���ɫ0-15��Ч
Public Function DW_SetGridLineColor(color As Long) As Long
    DW_SetGridLineColor = parentClassDW.DW_SetGridLineColor(color)
    errString = parentClassDW.errString
End Function

'��������صķ���
Public Function DW_SetSort(sorter As String) As Long
    DW_SetSort = parentClassDW.DW_SetSorter(sorter)
End Function

'��ȡ�����ֶ�
Public Function DW_GetSort() As String
    DW_GetSort = parentClassDW.DW_GetSorter()
End Function

'��������
Public Function DW_Sort() As Long
    DW_Sort = parentClassDW.DW_Sort
    errString = parentClassDW.errString
End Function