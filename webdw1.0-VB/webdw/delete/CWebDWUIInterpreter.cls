VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CWebDWUIInterpreter"
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
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------

Option Explicit

Dim myControls(1 To 10000) As Control                       'myControls�����������Զ������Ŀؼ��ļ���
                                                            '�����ؼ���ʵ��������ַ��form�ϣ�
                                                            '�����ŵ�ֻ��һ���ؼ������ָ��

Dim controlSeg As Long                                      '�൱��һ���ؼ������У�ÿ����һ���Զ���һ
Public webdw As CWebDW                                      '����webdw��Ӧ���ļ���ȡ��
Public webdwReader As CWebDWReader                          '����webdwReader�Ķ�ȡ�����
Public webdwData As CWedDWData                              '����webdw�����ݶ�����
Public beginRowId As Long                                   '��������ʾ�Ŀ�ʼ�У�Ĭ��Ϊ1
Public errString As String                                  '���صĴ�����Ϣ�ַ���


'����ǩ�ķ���
'targetControls Ŀ�괰������û��ؼ��Ŀؼ�����
'pictTarget Ŀ��ͼƬ��
'lineNum    �к�0�������Ʊ�ͷ����������������к�
'ͼ��������Դ: g_webdw
Private Function DrawLabel(targetControls As Variant, targetPict As PictureBox, lineNum As Long) As Long
    Dim id As Long
    Dim sname As String
    Dim obj As Control
    Dim top As Long
    
    For id = 1 To 100
        If g_webdw.text(id).name = "" Then
            DrawLabel = 0
            Exit Function
        End If
        
        If lineNum = 0 And g_webdw.text(id).band <> "header" Then   '����ͷ����band��Ϊheader,�˳�
            GoTo ContinueNext
        End If
        
        If lineNum > 0 And g_webdw.text(id).band <> "detail" Then   '����ϸ�ڣ�band��Ϊdetail,�˳�
            GoTo ContinueNext
        End If
        
        '�ȼ����ǩ��topֵ���Դ����ж��Ƿ���Ҫ�����������󲢻���֮
        If g_webdw.text(id).band = "header" Then top = g_webdw.text(id).y
        If g_webdw.text(id).band = "detail" Then top = g_webdw.text(id).y _
                        + g_webdw.header.height _
                        + g_webdw.detail.height * (lineNum - beginRowId)
                    
        '����topֵ�����жϣ�������ֵ������targetPict�ķ�Χ������������ѭ��
        If top <= 0 Or top > targetPict.height Then
            GoTo ContinueNext
        End If
        
        controlSeg = controlSeg + 1
        sname = targetPict.name & "_" & lineNum _
                    & "_" & g_webdw.text(id).name
        
        Set obj = targetControls.Add("VB.Label", sname, targetPict)
        Set myControls(controlSeg) = obj                    '�洢���ڿؼ�������
         
        
        With obj
            .top = top
            .Left = g_webdw.text(id).x
            .width = g_webdw.text(id).width
            .height = g_webdw.text(id).height
            .BorderStyle = 0
            .alignment = g_webdw.text(id).alignment
            .Caption = g_webdw.text(id).text
        End With
        obj.Visible = True
    
ContinueNext:
    Next
End Function

'���ı���ķ���
'targetControls Ŀ��ؼ�����
'pictTarget     Ҫ���Ƶ�ͼƬ��
'lineNum        �кţ���1��ʼ���ı���ֻ��detail������ƣ���������������
Private Function DrawColumn(targetControls As Variant, targetPict As PictureBox, lineNum As Long) As Long
    Dim id As Long
    Dim sname As String
    Dim obj As Control
    Dim top As Long
    Dim iborder As Long
    Dim svalue As String
    
    For id = 1 To 100
        If g_webdw.column(id).name = "" Then    '����Ϊ�գ��˳�ִ��
            DrawColumn = 0
            Exit Function
        End If
        
        If lineNum = 0 Then                     '�ؼ�������ͷ�����ƣ�����ѭ��
            GoTo ContinueNext
        End If
        
        '�ȼ����ǩ��topֵ���Դ����ж��Ƿ���Ҫ�����������󲢻���֮
         top = g_webdw.column(id).y + g_webdw.header.height _
                + g_webdw.detail.height * (lineNum - beginRowId)
        
        If top <= 0 Or top > targetPict.height Then
            GoTo ContinueNext
        End If
        
        controlSeg = controlSeg + 1
        sname = targetPict.name & "_" & lineNum _
                    & "_" & g_webdw.column(id).name
        
        svalue = webdwData.getItemString(lineNum, id)
        
         Set obj = targetControls.Add("VB.TextBox", sname, targetPict)
         Set myControls(controlSeg) = obj                    '�洢���ڿؼ�������
        
        
         If g_webdw.column(id).border > 0 Then
            iborder = 1
         Else
            iborder = 0
         End If
         With obj
             .top = top
             .Left = g_webdw.column(id).x
             .width = g_webdw.column(id).width
             .height = g_webdw.column(id).height
             .BorderStyle = iborder
             .alignment = g_webdw.column(id).alignment
             .text = svalue
        End With
         obj.Visible = True
ContinueNext:
    Next
End Function
'��ĳ�ʼ������
Private Sub Class_Initialize()
    '��ʼ��ʱ����controlSegֵ
    controlSeg = 0
    Set webdw = New CWebDW                              '����webdw�Ĵ洢����
    Set webdwReader = New CWebDWReader                  '����webdw�Ķ�ȡ����
    Set webdwData = New CWedDWData                      '����webdw�����ݶ���
End Sub


'�Ӵ���ɾ�������Ѿ������İ�ť
Private Function DeleteAllControl(targetControls As Variant) As Integer
    Dim i As Integer
    For i = 1 To 10000
        If Not (myControls(i) Is Nothing) Then            '����ж���һ����ȫ���жϣ��Ա����쳣�������
            targetControls.Remove (myControls(i).name)
            Set myControls(i) = Nothing
        End If
    Next
    controlSeg = 0                                         '��λ���ж���
End Function


'����x,y��λ�����жϵ�ǰ�Ŀؼ�λ��
'��������κοؼ��ϣ�����nothing
'���򷵻ؿؼ�������
Public Function GetCurrentObj(x As Single, y As Single, ByRef controlId As Long) As Control
    Dim i As Long
    Dim curObj As Object
    Dim d1 As Double
    Dim d2 As Double
    Dim oldid As Long
    oldid = controlId
    
    For i = 1 To 10000
        Set curObj = myControls(i)
        If curObj Is Nothing Then
            GoTo ContinueNext
        End If
        
        If x > curObj.Left - 20 And x < curObj.Left + curObj.width + 20 _
         And y > curObj.top - 20 And y < curObj.top + curObj.height + 20 Then
            'TODO:��ȷ���ж��û�Ҫ����ĵ������Ǹ���ť�ؼ�
            '��һ���������Ժ����������
         Set GetCurrentObj = curObj
         controlId = i
         Exit Function
        End If
        
ContinueNext:
    Next i
    Set GetCurrentObj = Nothing
    controlId = 0
End Function

'��������������һ���ؼ�id��
'�ж��Ƿ��������༭������ǣ�ȡ�ñ༭�����ݲ�����,���ñ�־Ϊ0
'������ǣ����ؿ��ַ���,���ñ�־Ϊ-1

'Public Function GetDdlbList(controlId As Long, ByRef iflag As Long) As String
'    Dim id As Long
'    Dim colName As String
'    Dim colid As Long
'
'    iflag = -1
'    GetDdlbList = ""
'    If myControls(controlId) Is Nothing Then
'        Exit Function
'    End If
'
'    id = controlId - webdw.getLableNum()
'    colName = g_webdw.column(id).name
'
'    For colid = 1 To 100
'        If g_webdw.table.columns(colid).name = colName Then
'            GetDdlbList = g_webdw.table.columns(colid).values
'            iflag = 0
'            Exit Function
'        End If
'    Next
'
'End Function
'����sData��������ݴ���
'Private Function FillData(targetControls As Variant, pictTarget As PictureBox, sData As String) As Long
'    Dim sDataArray As Variant
'    Dim vline As Variant
'    Dim sline As String
'    Dim lineId As Long
'    Dim colarray As Variant
'    Dim sdarray As Variant
'    Dim sdd As Variant
'    Dim sdd1 As String
'    Dim controlName As String
'    Dim obj As Control
'    Dim id As Long
'    Dim allcol() As String
'
'    sDataArray = Split(sData, "" & Chr(13) & Chr(10)) '���ûس����Ž��зֽ�
'    lineId = 0
'    For Each vline In sDataArray
'        sline = vline                                      '����һ��
'        If lineId = 0 Then
'             allcol = Split(sline, Chr(9))             '��chr(9)���ֽ����
'        Else
'             sdarray = Split(sline, Chr(9))              '��chr(9)���ֽ���
'            id = 0
'            For Each sdd In sdarray
'                sdd1 = sdd                                  '�е�����
'                controlName = pictTarget.name & "_" & lineId _
'                            & "_" & allcol(id)
'                id = id + 1
'                Set obj = targetControls(controlName)
'                If Not obj Is Nothing Then
'                    obj.text = sdd1
'                End If
'            Next
'        End If
'
'        lineId = lineId + 1
'    Next
'
'End Function
'��ʼ��DW�ķ�����������������ڳ���ʼʱ��ʼ��ָ�������ݴ���
'���ݴ���ʵ������һ��PictureBox�ؼ�
'���ó��������PictureBox������б�Ҫ�Ļ�ͼ����������
'targetControls : Ŀ�괰�壬�����û��ؼ��Ŀؼ�����
'targetPict     : Ŀ��picturebox,��������һ��picturebox�Ͻ��л�ͼ
'vscroll        : targetPict��Ӧ��vscrollbar�����vscrollbar��ʾ��ǰ�Ŀ�ʼ��(beginRowId)
'sUIDesc        : sUIDesc�����û�������ַ�����ʾ
'sData          : sData�������������ݱ�ʾ

Public Function initDW(targetControls As Variant, targetPict As PictureBox, _
                        vscroll As VScrollBar, convertRate As Double, _
                       sUIDesc As String, sData As String) As Long
    Dim iret As Long
    Dim totalHeight As Long
    Dim rowid As Long
    Dim colid As Long
    Dim controlName As String
    Dim obj As Control
    
    'step1:��ʼ�������ʾ,��ʼ������Ժ󣬽�����Ϣ�洢��g_webdw������
    iret = webdw.convertDW(sUIDesc)
    
    If iret = -1 Then                   '����������󣬽ػ�����׳������쳣?��
        initDW = -1
        errString = webdw.errString
        Exit Function
    End If
    
    'step2:��ʼ�����ݱ�ʾ����ʼ����Ϻ�ʵ�����ݴ洢��webdwData�����ˣ�����ͨ������������
    iret = webdwData.ReadData(sData)
    
    If iret = -1 Then                   '����������󣬽ػ�����׳������쳣?��
        initDW = -1
        errString = webdwData.errString
        Exit Function
    End If
    
    'step3:�����߼��߶ȣ�������Ҫ����VscrollBar������
    totalHeight = g_webdw.header.height _
                + g_webdw.detail.height * webdwData.GetRowCount() _
                + g_webdw.footer.height
    totalHeight = totalHeight / convertRate         '�����߼�ת������
    
    If totalHeight > targetPict.height Then       '����߼��߶ȴ��������߶ȣ������ù�����
        vscroll.Min = 0
        vscroll.Max = (totalHeight - targetPict.height) / g_webdw.detail.height * convertRate
        vscroll.SmallChange = 1                                        '����¼
        vscroll.LargeChange = targetPict.height / g_webdw.detail.height * convertRate '��ҳ
        vscroll.Value = 0
        vscroll.Enabled = True
    Else
        vscroll.Enabled = False
        vscroll.Max = 0
        vscroll.Min = 0
        vscroll.Value = 0
    End If
'    beginRowId = vscroll.Value + 1                  '��ʼ�д����������������+1
'
'    '��ʼ����ͼ������
'
'    For rowid = 0 To webdwData.GetRowCount()
'        iret = DrawLabel(targetControls, targetPict, rowid)
'        iret = DrawColumn(targetControls, targetPict, rowid)
'    Next rowid
    DrawDW targetControls, targetPict, 1            '�ӵ�һ�п�ʼ����
    
End Function

'����DW�ķ���,begId������ʼ���Ƶ�һ��.
Public Function DrawDW(targetControls As Variant, targetPict As PictureBox, begId As Long) As Long
    Dim rowid As Long
    Dim iret As Long
    
    'step1 ����beginRowId
    beginRowId = begId
    
    'step2 ɾ�����пؼ�
    DeleteAllControl targetControls
    
    'step3 ���»���
    For rowid = 0 To webdwData.GetRowCount()
        iret = DrawLabel(targetControls, targetPict, rowid)
        iret = DrawColumn(targetControls, targetPict, rowid)
    Next rowid
    
    
End Function
