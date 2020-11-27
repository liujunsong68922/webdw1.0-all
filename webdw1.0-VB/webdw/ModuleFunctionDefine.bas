Attribute VB_Name = "Module2FunctionDefine"
Rem ȫ���Եķ�������ģ��
Rem Ϊ�˼���Ĳ�κͽṹ����ȫ���Եķ���ת�Ƶ����ģ��������
Option Explicit

'��һ��targetControls�����У����ݸ����ؼ������������ؼ�
'����ؼ������ڣ��򷵻�Nothing
'��һ����ԭ����CWebDWUI_ParentDW��
'������ȡ��Ϊ���÷���
'֮����Ҫ�Լ�дһ�����������ԭ���Ǳ����������ʱ������ʾ
'�Լ����ǵ��ؼ����ƴ�Сд����ת��������
Public Function GF_GetObjectByName(targetControls As Variant, objName As String) As Control
    Dim obj As Control
    Dim vobj As Variant
    
    Set obj = Nothing
    
    If targetControls Is Nothing Then
        Set GF_GetObjectByName = Nothing
        Exit Function
    End If
    
    For Each vobj In targetControls
        If UCase(vobj.Name) = UCase(objName) Then
            Set obj = vobj
            Exit For
        End If
    Next
    
    Set GF_GetObjectByName = obj

End Function

Rem -------------------------------------------------
Rem WebDW����ɫת������
Rem PB�еĶ������ɫ���룬��VB�ж������ɫ������������
Rem ������Ҫ����һ��ת��������������ʾ��ת��
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @��Ȩ���� ������ 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------



'��������������һ��PB�������ɫ��������ϵͳ��ɫ��Ҳ���ܲ���ϵͳ��ɫ
'�����ϵͳ��ɫ������һ����ת��(���ת���ǻ��ڵ�ɫ�嶨���)
'�������ϵͳ��ɫ����ֱ�ӷ���
'�ж��Ƿ���ϵͳ��ɫ��������ֵ�Ƿ�С��255 * 256 * 256 + 255 * 256 + 255
'���û�з����������ж����У���ô����һ��Ĭ��ֵ
'pbColor    :�����PB��ɫֵ
'defColor   :�����Ĭ����ɫֵ
Public Function GF_GetVBColor(pbColor As Long, defColor As Long) As Long
    Dim iret As Long
    Const SYSCOLOR = 16777215                       '�����ɫֵ,256 * 256 * 256 - 1

    If pbColor <= SYSCOLOR Then
        GF_GetVBColor = pbColor
        Exit Function
    End If
    
    iret = defColor                         '����Ĭ����ɫ
    If pbColor = 1090519039 Then iret = vbWindowBackground    '�����windowsĬ�ϱ���ɫ
    If pbColor = 276856960 Then iret = vbApplicationWorkspace ' �����Ӧ�ù�����Ĭ�ϱ���ɫ
    If pbColor = 81324524 Then iret = vbButtonFace            ' ����ǰ�ť��ɫ
    If pbColor = 33554592 Then iret = vbWindowText            'window�ı�Ĭ����ɫ
    
    '�����Ǽ��̶ֹ��������ɫת��
    If pbColor = 536870912 Then iret = RGB(255, 255, 255)     '��ɫ
    
    GF_GetVBColor = iret
End Function

'��������������һ���ؼ����ϣ����м������Եõ��ؼ�ָ�������ű���
'�������ű���
'�������������Ŀ����Ϊ���ڵ���ʱ���ٴ������ű���
'Ҫ��ȷʹ�����ű�����Ҫ���������һ����ΪTextConvertRate���ı������
'�����һ�������������ʽҲ���ԣ������Ʊ���Ϊ"TextConvertRate"
'���������û����һԪ�أ���Ĭ��Ϊ4
Public Function GF_GetConvertRate(targetControls As Variant) As Double
    Dim convertRate As Double
    Dim TextConvertRate As Control
    
    Set TextConvertRate = GF_GetObjectByName(targetControls, "TextConvertRate")
    If TextConvertRate Is Nothing Then
        GF_GetConvertRate = 4
        Exit Function
    End If
    
    convertRate = TextConvertRate.text  '��ȡ����ֵ
    If convertRate <= 1 Or convertRate >= 10 Then
        convertRate = 4
    End If
    
    GF_GetConvertRate = convertRate
End Function

'����һ���ַ����﷨����,�����õ���Ӧ�����ݣ��������������
'��������κδ����򷵻�һ�����ַ���
'���������cwebdwUI_ParentDW.retrieveChildDW�б�����
Public Function GF_RetrieveBySyntax(dwSyntax As String) As String
    Dim iret As Long
    Dim temp_webdw As New CWebDW
    Dim temp_sqlca As New CWebDWTransaction
    Dim str_retrieve As String
    Dim sdata As String
    
    If temp_webdw.Create(dwSyntax) = -1 Then     '����ʧ�ܣ����ؿ��ַ���
        GF_RetrieveBySyntax = ""
        Exit Function
    End If
    
    str_retrieve = temp_webdw.GetRetrieveSQL()  '�õ������õ�SQL���
    
    If str_retrieve = "" Then
        GF_RetrieveBySyntax = ""
        Exit Function
    End If
    
    temp_sqlca.opertype = 1
    temp_sqlca.beginPos = 0
    temp_sqlca.readNum = 1000
    temp_sqlca.command = str_retrieve
    sdata = temp_sqlca.ExecuteSelect(iret)      'ִ��sql,�õ����ݽ��
    
    If iret = -1 Then
        GF_RetrieveBySyntax = ""
        Exit Function
    End If
    
    GF_RetrieveBySyntax = sdata                    '��������
        
End Function

'����һ���ַ�������������ַ����洢��Ҫ�õ������ݿⳤ��
'Ĭ�Ϻ�̨���ݿ�Ĵ洢����GBK�������Ƶı��뷽ʽ
'����ASCII�룬ռһλ�����ڷǱ�׼ASCII�룬ռ��λ
'��һ�����ں�̨���ݿ�ı��뷽ʽ�����ı�ʱ������Ҫ��д
Public Function GF_GetDBlength(sdata As String) As Long
    Dim i As Long
    Dim ilen As Long
    Dim stemp As String
    ilen = 0
    For i = 1 To Len(sdata)
        stemp = Mid(sdata, i, 1)
        If Asc(stemp) < 128 And Asc(stemp) > 0 Then
            ilen = ilen + 1
        Else
            ilen = ilen + 2
        End If
    Next
    GF_GetDBlength = ilen
End Function

'һ��ͨ�õĺ������൱��C�����е�if(,,)����
'��һ��������һ���߼��ж�
'������棬���صڶ�������
'����Ǽ٣����ص���������
Public Function GF_IF(ifClause As Boolean, YesValue As String, NoValue As String) As String
    If ifClause Then
        GF_IF = YesValue
    Else
        GF_IF = NoValue
    End If
End Function

'һ��ͨ�õĺ������൱��C�����е�if(,,)����
'��һ��������һ���߼��ж�
'������棬���صڶ�������
'����Ǽ٣����ص���������
Public Function GF_IF_Long(ifClause As Boolean, YesValue As Long, NoValue As Long) As Long
    If ifClause Then
        GF_IF_Long = YesValue
    Else
        GF_IF_Long = NoValue
    End If
End Function


