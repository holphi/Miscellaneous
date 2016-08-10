Attribute VB_Name = "CommonUtil"
Option Base 0
Option Explicit

Public Sub CreateNewTestSuite()
    
    If Application.Workbooks.count = 0 Then
        MsgBox "Please create a blank workbook first!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If

    Dim TestSuiteName As String
    TestSuiteName = Trim(InputBox("Please input the test suite name:", "New Test suite:"))
    
    'User choose cancel
    If TestSuiteName = "" Then
        Exit Sub
    End If
        
    'Loop worksheets in current workbook, check whether there exists duplicate worksheet name
    Dim i As Integer
    For i = 1 To Application.ActiveWorkbook.Sheets.count
        If ActiveWorkbook.Sheets(i).Name = TestSuiteName Then
            MsgBox "Duplicate worksheet name!", vbOKOnly + vbCritical
            Exit Sub
        End If
    Next
    
    Call CreateTestSuiteWorkSheet(TestSuiteName)
    
End Sub

'Analyse all requirements
Public Sub AnalyzeAllRequirements()
    
    If Application.Workbooks.count = 0 Then
        MsgBox "No active workbook found!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If

    If Not HasReqCollWorksheetOpened Then
        MsgBox "No requirement worksheet opened in current workbook!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If
    
    Dim ws As Worksheet
    Dim reqAnalysisResult As New Collection
    
    For Each ws In ActiveWorkbook.Worksheets
        
        If IsValidReqCollWorksheet(ws) Then
            
            Dim rowIndex As Integer
            rowIndex = 2
            
            While ws.Cells(rowIndex, 1).Value <> vbNullString And ws.Cells(rowIndex, 2).Value <> vbNullString
                
                Dim reqItem As ReqAnalysisItem
                Set reqItem = New ReqAnalysisItem
                
                reqItem.ReqID = Trim(ws.Cells(rowIndex, 1))
                reqItem.ReqTitle = Trim(ws.Cells(rowIndex, 2))
                reqItem.BelongsTo = Trim(ws.Name)
                reqItem.Status = Trim(ws.Cells(rowIndex, 4))
                reqItem.ReqType = Trim(ws.Cells(rowIndex, 5))
                
                reqItem.TotalTC = GetAssociatedTCCount(reqItem.ReqID)
                
                rowIndex = rowIndex + 1
                
                Call reqAnalysisResult.Add(reqItem)

            Wend
            
        End If
        
    Next
    
    Call GenReqCollAnalysisRpt(reqAnalysisResult)
    
End Sub

Private Function GetAssociatedTCCount(ByVal ReqID As String) As Integer

    Dim count As Integer
    count = 0
    
    Dim ws As Worksheet
    For Each ws In ActiveWorkbook.Worksheets
        
        If IsValidTestSuiteWorksheet(ws) Then
                    
            Dim rowIndex As Integer
            rowIndex = 1
            
            While ws.Cells(rowIndex, 1).Value <> vbNullString And ws.Cells(rowIndex, 2).Value <> vbNullString
                Dim requirements As String
                requirements = ws.Cells(rowIndex, 9)
                
                If InStr(requirements, ReqID) <> 0 Then
                    count = count + 1
                End If
                
                rowIndex = rowIndex + 1
            Wend
            
        End If
    
    Next
    
    GetAssociatedTCCount = count
    
End Function

Public Sub CreateNewRequirementColl()
    
    If Application.Workbooks.count = 0 Then
        MsgBox "Please create a blank workbook first!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If

    Dim requirementCollName As String
    requirementCollName = Trim(InputBox("Please input collection name:", "New requirement collection:"))
    
    'User choose cancel
    If requirementCollName = "" Then
        Exit Sub
    End If
        
    'Loop worksheets in current workbook, check whether there exists duplicate worksheet name
    Dim i As Integer
    For i = 1 To Application.ActiveWorkbook.Sheets.count
        If ActiveWorkbook.Sheets(i).Name = requirementCollName Then
            MsgBox "Duplicate worksheet name!", vbOKOnly + vbCritical
            Exit Sub
        End If
    Next
    
    Call CreateReqWorksheet(requirementCollName)
    
End Sub

'
Private Function CreateTestSuiteWorkSheet(ByVal SuiteName As String) As Worksheet
    
    Dim ws_new As Worksheet, ws_template As Worksheet
    
    'Disable screen updating
    Application.ScreenUpdating = False
    
    Set ws_new = ActiveWorkbook.Sheets.Add(after:=ActiveWorkbook.ActiveSheet)
    ws_new.Name = SuiteName
        
    'Copy template title
    Set ws_template = ThisWorkbook.Sheets("Template")
    ws_template.Range("A1:I1").Copy
        
    ws_new.Range("A1").PasteSpecial Paste:=xlPasteColumnWidths, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
    ws_new.Paste
    ws_new.Activate
        
    'Copy options for priority
    ws_template.Range("A4:A6").Copy
    
    ws_new.Range("AY1").Select
    ws_new.Paste
    
    ws_new.Columns("AY:AY").Hidden = True
    
    'Add data validation for priority column
    With ws_new.Range("G2:G2048").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, Operator:=xlBetween, Formula1:="=$AY$1:$AY$3"
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = True
        .ShowError = True
    End With
    
    'Copy options for exec type
    ws_template.Range("B4:B5").Copy
    
    ws_new.Range("AZ1").Select
    ws_new.Paste
    
    ws_new.Columns("AZ:AZ").Hidden = True
    
    'Add data validation for exec type column
    With ws_new.Range("H2:H2048").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, Operator:=xlBetween, Formula1:="=$AZ$1:$AZ$2"
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = True
        .ShowError = True
    End With
        
    'Freeze the first row
    With ActiveWindow
        .SplitColumn = 0
        .SplitRow = 1
        .FreezePanes = True
    End With
        
    'Enable screen updating
    Application.ScreenUpdating = True
        
    Set CreateTestSuiteWorkSheet = ws_new
        
End Function

Private Function CreateReqWorksheet(ByVal reqColl As String)

    Dim ws_new As Worksheet, ws_template As Worksheet
    
    'Disable screen updating
    Application.ScreenUpdating = False
    
    Set ws_new = ActiveWorkbook.Sheets.Add(after:=ActiveWorkbook.ActiveSheet)
    ws_new.Name = reqColl
        
    Set ws_template = ThisWorkbook.Sheets("Template")
    ws_template.Range("K1:P1").Copy
        
    ws_new.Range("A1").PasteSpecial Paste:=xlPasteColumnWidths, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
    ws_new.Paste
    ws_new.Activate
    
    'Copy options for status
    ws_template.Range("K4:K11").Copy
    
    ws_new.Range("AY1").Select
    ws_new.Paste
    
    ws_new.Columns("AY:AY").Hidden = True
    
    'Add data validation for status column
    With ws_new.Range("D2:D2048").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, Operator:=xlBetween, Formula1:="=$AY$1:$AY$8"
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = True
        .ShowError = True
    End With
    
    'Copy options for type
    ws_template.Range("L4:L10").Copy
    
    ws_new.Range("AZ1").Select
    ws_new.Paste
    
    ws_new.Columns("AZ:AZ").Hidden = True
    
    'Add data validation for exec type column
    With ws_new.Range("E2:E2048").Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, Operator:=xlBetween, Formula1:="=$AZ$1:$AZ$7"
        .IgnoreBlank = True
        .InCellDropdown = True
        .ShowInput = True
        .ShowError = True
    End With
        
    'Freeze the first row
    With ActiveWindow
        .SplitColumn = 0
        .SplitRow = 1
        .FreezePanes = True
    End With
        
    'Enable screen updating
    Application.ScreenUpdating = True
        
    Set CreateReqWorksheet = ws_new
    
End Function

Public Sub ImportTestSuite()

End Sub

Public Sub ExportCurrentReqColl()

    If Application.Workbooks.count = 0 Then
        MsgBox "No active workbook found!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If
    
    Dim ws As Worksheet
    
    Set ws = ActiveWorkbook.ActiveSheet
        
    If Not IsValidReqCollWorksheet(ws) Then
        MsgBox "Current worksheet is not a valid requirements worksheet!", vbOKOnly + vbCritical, "Error:"
        Exit Sub
    End If
        
    Dim rowIndex As Integer, count As Integer
    rowIndex = 2: count = 0
    
    'Loop current worksheet and generate requirement collection
    Dim req_coll As New Collection
    
    While ws.Cells(rowIndex, 1).Value <> vbNullString And ws.Cells(rowIndex, 2).Value <> vbNullString
        
        Dim req As Requirement
        Set req = New Requirement
        
        'ReqID
        req.ID = Trim(ws.Cells(rowIndex, 1))
        'Title
        req.Title = Trim(ws.Cells(rowIndex, 2))
        'Scope
        req.Scope = Trim(ws.Cells(rowIndex, 3))
        'Status
        req.Status = Trim(ws.Cells(rowIndex, 4))
        'Type
        req.ReqType = Trim(ws.Cells(rowIndex, 5))
        'Release Num
        req.ReleaseNum = Trim(ws.Cells(rowIndex, 6))
        
        rowIndex = rowIndex + 1
        
        Call req_coll.Add(req)
        
    Wend
    
    If req_coll.count = 0 Then
        MsgBox "0 requirement found! Please add requirements before exporting to xml file", vbOKOnly + vbCritical, "Error:"
        Exit Sub
    End If
    
    Dim fileSaveName As Variant
    
    Dim ws_name As String
    ws_name = ws.Name
    
    Dim initFileName As String
    initFileName = ws_name + ".xml"
    
    'Prompt SaveAs dialog where users could set output filename
    fileSaveName = Application.GetSaveAsFilename(InitialFileName:=initFileName, fileFilter:="Xml Files (*.xml), *.xml")
    If fileSaveName = False Then
        'User cancels saving operation, then quit sub
        Exit Sub
    End If
    
    fileSaveName = CStr(fileSaveName)
    
    Call WriteReqCollData(ws_name, req_coll, fileSaveName)
    
End Sub

'Loop current requirements worksheet and export an xml file can be identified by Testlink
Private Sub WriteReqCollData(ByVal ws_name As String, ByRef req_coll As Collection, ByVal exportPath As String)
    
    Dim xmlDoc As DOMDocument
    Dim xmlNode As IXMLDOMNode
    Dim xmlElement As IXMLDOMElement
    Dim xmlAttribute As IXMLDOMElement
    Dim xmlRootElement As IXMLDOMElement
    
    'Create a new XML document
    Set xmlDoc = New DOMDocument
    'Create a new root node
    Set xmlNode = xmlDoc.createProcessingInstruction("xml", "version='1.0' encoding='UTF-8'")
    Set xmlNode = xmlDoc.InsertBefore(xmlNode, xmlDoc.ChildNodes.item(0))
    
    'Create root element
    Set xmlRootElement = xmlDoc.createElement("requirements")
    
    Call xmlRootElement.setAttribute("name", ws_name)
    
    Set xmlDoc.DocumentElement = xmlRootElement
    
    Dim order As Integer
    order = 0
    
    Dim req As Requirement
    
    For Each req In req_coll
    
        Dim xmlReqNode As IXMLDOMNode
        Dim xmlReqElement As IXMLDOMElement
        
        Dim xmlInnerTxt As IXMLDOMCDATASection
        
        Set xmlReqNode = xmlDoc.createNode(NODE_ELEMENT, "requirement", "")
                
        'Create a new node for requirement id
        Dim xmlDocIdNode As IXMLDOMNode
        Set xmlDocIdNode = xmlDoc.createNode(NODE_ELEMENT, "docid", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(req.ID)
        Call xmlDocIdNode.appendChild(xmlInnerTxt)
        Call xmlReqNode.appendChild(xmlDocIdNode)
        
        'Create a new node for requirement title
        Dim xmlTitleNode As IXMLDOMNode
        Set xmlTitleNode = xmlDoc.createNode(NODE_ELEMENT, "title", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(req.Title)
        Call xmlTitleNode.appendChild(xmlInnerTxt)
        Call xmlReqNode.appendChild(xmlTitleNode)
        
        'Create a new node for node order
        Dim xmlNodeOrderNode As IXMLDOMNode
        Set xmlNodeOrderNode = xmlDoc.createNode(NODE_ELEMENT, "node_order", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(CStr(order))
        Call xmlNodeOrderNode.appendChild(xmlInnerTxt)
        Call xmlReqNode.appendChild(xmlNodeOrderNode)
        
        'Create a new node for scope
        Dim xmlDescriptionNode As IXMLDOMNode
        Set xmlDescriptionNode = xmlDoc.createNode(NODE_ELEMENT, "description", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(FormatContent(req.Scope))
        Call xmlDescriptionNode.appendChild(xmlInnerTxt)
        Call xmlReqNode.appendChild(xmlDescriptionNode)
        
        'Create a new node for status
        Dim xmlStatusNode As IXMLDOMNode
        Set xmlStatusNode = xmlDoc.createNode(NODE_ELEMENT, "status", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(req.Status)
        Call xmlStatusNode.appendChild(xmlInnerTxt)
        Call xmlReqNode.appendChild(xmlStatusNode)
        
        'Create a new node for type
        Dim xmlTypeNode As IXMLDOMNode
        Set xmlTypeNode = xmlDoc.createNode(NODE_ELEMENT, "type", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(req.ReqType)
        Call xmlTypeNode.appendChild(xmlInnerTxt)
        Call xmlReqNode.appendChild(xmlTypeNode)
        
        'Create a new node for expected coverage
        Dim xmlExpCoverageNode As IXMLDOMNode
        Set xmlExpCoverageNode = xmlDoc.createNode(NODE_ELEMENT, "expected_coverage", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(CStr(1))
        Call xmlExpCoverageNode.appendChild(xmlInnerTxt)
        Call xmlReqNode.appendChild(xmlExpCoverageNode)
        
        'Create a new node for custom fields (Release Num)
        'Create custom_fields
        Dim xmlCustomFieldsNode As IXMLDOMNode
        Set xmlCustomFieldsNode = xmlDoc.createNode(NODE_ELEMENT, "custom_fields", "")
        'Create custom_field
        Dim xmlCustomFieldNode As IXMLDOMNode
        Set xmlCustomFieldNode = xmlDoc.createNode(NODE_ELEMENT, "custom_field", "")
        'Create field name
        Dim xmlFieldNameNode As IXMLDOMNode
        Set xmlFieldNameNode = xmlDoc.createNode(NODE_ELEMENT, "name", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection("ReleaseNumber")
        Call xmlFieldNameNode.appendChild(xmlInnerTxt)
        Call xmlCustomFieldNode.appendChild(xmlFieldNameNode)
        'Create field value
        Dim xmlFieldValueNode As IXMLDOMNode
        Set xmlFieldValueNode = xmlDoc.createNode(NODE_ELEMENT, "value", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(req.ReleaseNum)
        Call xmlFieldValueNode.appendChild(xmlInnerTxt)
        Call xmlCustomFieldNode.appendChild(xmlFieldValueNode)
        'Append custom_field
        Call xmlCustomFieldsNode.appendChild(xmlCustomFieldNode)
        'Append node custom_fields to requirement
        Call xmlReqNode.appendChild(xmlCustomFieldsNode)
        
        Call xmlRootElement.appendChild(xmlReqNode)
        
        'Increase order
        order = order + 1
    Next
    
    Call xmlDoc.Save(exportPath)
    
    MsgBox "Done! " + CStr(req_coll.count) + " requirement(s) were exported!", vbInformation + vbOKOnly, "Message:"
        
End Sub

Public Sub ExportCurrentTestSuite()

    If Application.Workbooks.count = 0 Then
        MsgBox "No active workbook found!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If
    
    Dim ws As Worksheet
    
    Set ws = ActiveWorkbook.ActiveSheet
        
    If Not IsValidTestSuiteWorksheet(ws) Then
        MsgBox "Current worksheet is not a valid test suite worksheet!", vbOKOnly + vbCritical, "Error:"
        Exit Sub
    End If
        
    Dim rowIndex As Integer, count As Integer
    rowIndex = 2: count = 0
    
    'Loop current worksheet and generate test suite collection
    Dim tc_Coll As New Collection

    While ws.Cells(rowIndex, 1).Value <> vbNullString And ws.Cells(rowIndex, 2).Value <> vbNullString
    
        Dim TC As TestCase
        
        Set TC = New TestCase
        
        'tc.InternalID = ws.Cells(rowIndex, 1)
        TC.Name = ws.Cells(rowIndex, 2)
        TC.Summary = ws.Cells(rowIndex, 3)
        If Trim(ws.Cells(rowIndex, 4)) <> "" Then
            TC.Preconditions = ws.Cells(rowIndex, 4)
        End If
        TC.Steps = ws.Cells(rowIndex, 5)
        TC.ExpectedResults = ws.Cells(rowIndex, 6)
        TC.priority = ws.Cells(rowIndex, 7)
        TC.ExecutionType = ws.Cells(rowIndex, 8)
        TC.requirements = ws.Cells(rowIndex, 9)
        
        rowIndex = rowIndex + 1
        
        tc_Coll.Add TC
        
    Wend
    
    If tc_Coll.count = 0 Then
        MsgBox "0 test case found! Please add test cases before exporting to xml file", vbOKOnly + vbCritical, "Error:"
        Exit Sub
    End If
    
    Dim binding_Req As Boolean
    binding_Req = True
    
    If Not HasReqCollWorksheetOpened Then
        If MsgBox("No Requirments worksheet found! Exported result will not contain requirement nodes. Continue?", vbYesNo + vbExclamation, "Warning:") = vbNo Then
            Exit Sub
        End If
        binding_Req = False
    End If
    
    Dim ws_name As String
    ws_name = ws.Name
    
    Dim initFileName As String
    initFileName = ws_name + ".xml"
    
    Dim fileSaveName As Variant
    'Prompt SaveAs dialog where users could set output filename
    fileSaveName = Application.GetSaveAsFilename(InitialFileName:=initFileName, fileFilter:="Xml Files (*.xml), *.xml")
    If fileSaveName = False Then
        'User cancels saving operation, then quit sub
        Exit Sub
    End If
    
    fileSaveName = CStr(fileSaveName)
    
    Call WriteTestSuiteData(ws_name, tc_Coll, fileSaveName, binding_Req)
    
End Sub

Private Function FormatContent(ByVal strContent As String) As String

    If strContent = vbNullString Or strContent = "" Then
        FormatContent = ""
        Exit Function
    End If
    
    Dim strItems() As String
    strItems() = Split(strContent, Chr(10))
    
    Dim i As Integer
    Dim strResult As String
    strResult = ""
    For i = 0 To UBound(strItems)
        strResult = strResult + "<p>" + strItems(i) + "</p>"
    Next
    
    FormatContent = strResult
    
End Function

'Loop current worksheet and export an xml file can be identified by Testlink
Private Sub WriteTestSuiteData(ByVal ws_name As String, ByRef tc_Coll As Collection, ByVal exportPath As String, ByVal binding_Req As Boolean)
    
    'If user choose binding requirements when generating test suite result
    Dim reqColl As Collection
    Set reqColl = Nothing
    
    If binding_Req Then
        Set reqColl = RetrieveAllRequirements()
    End If
    
    Dim TC As TestCase
    
    Dim xmlDoc As DOMDocument
    Dim xmlNode As IXMLDOMNode
    Dim xmlElement As IXMLDOMElement
    Dim xmlAttribute As IXMLDOMElement
    Dim xmlRootElement As IXMLDOMElement
    
    'Create a new XML document
    Set xmlDoc = New DOMDocument
    'Create a new root node
    Set xmlNode = xmlDoc.createProcessingInstruction("xml", "version='1.0' encoding='UTF-8'")
    Set xmlNode = xmlDoc.InsertBefore(xmlNode, xmlDoc.ChildNodes.item(0))
    
    'Create root element
    Set xmlRootElement = xmlDoc.createElement("testcases")
    
    Call xmlRootElement.setAttribute("name", ws_name)
    
    Set xmlDoc.DocumentElement = xmlRootElement
    
    For Each TC In tc_Coll
    
        Dim xmlTCNode As IXMLDOMNode
        Dim xmlTCElement As IXMLDOMElement
        
        Dim xmlInnerTxt As IXMLDOMCDATASection
        
        Set xmlTCNode = xmlDoc.createNode(NODE_ELEMENT, "testcase", "")
                
        'Create a new node for summary
        Dim xmlSummaryNode As IXMLDOMNode
        Set xmlSummaryNode = xmlDoc.createNode(NODE_ELEMENT, "summary", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(TC.Summary)
        Call xmlSummaryNode.appendChild(xmlInnerTxt)
        Call xmlTCNode.appendChild(xmlSummaryNode)
        
        
        'Create a new node for preconditions
        If TC.Preconditions <> vbNullString Then
            Dim xmlPreConditionNode As IXMLDOMNode
            Set xmlPreConditionNode = xmlDoc.createNode(NODE_ELEMENT, "preconditions", "")
            Set xmlInnerTxt = xmlDoc.createCDATASection(FormatContent(TC.Preconditions))
            Call xmlPreConditionNode.appendChild(xmlInnerTxt)
            Call xmlTCNode.appendChild(xmlPreConditionNode)
        End If
        
        'Create a new node for steps
        Dim xmlStepsNode, xmlStepNumNode, xmlStepNode, xmlActionsNode, xmlResultsNode As IXMLDOMNode
        Set xmlStepsNode = xmlDoc.createNode(NODE_ELEMENT, "steps", "")
        Set xmlStepNode = xmlDoc.createNode(NODE_ELEMENT, "step", "")
        Set xmlStepNumNode = xmlDoc.createNode(NODE_ELEMENT, "step_number", "")
        Set xmlActionsNode = xmlDoc.createNode(NODE_ELEMENT, "actions", "")
        Set xmlResultsNode = xmlDoc.createNode(NODE_ELEMENT, "expectedresults", "")
        
        'Set step number
        Set xmlInnerTxt = xmlDoc.createCDATASection("1")
        Call xmlStepNumNode.appendChild(xmlInnerTxt)
        'Set actions
        Set xmlInnerTxt = xmlDoc.createCDATASection(FormatContent(TC.Steps))
        Call xmlActionsNode.appendChild(xmlInnerTxt)
        'Set expected results
        Set xmlInnerTxt = xmlDoc.createCDATASection(FormatContent(TC.ExpectedResults))
        Call xmlResultsNode.appendChild(xmlInnerTxt)
        
        'Append step_num, actions & expected results to step node
        Call xmlStepNode.appendChild(xmlStepNumNode)
        Call xmlStepNode.appendChild(xmlActionsNode)
        Call xmlStepNode.appendChild(xmlResultsNode)
        
        'Append step node to steps node
        Call xmlStepsNode.appendChild(xmlStepNode)
        'Append stpes node to tc node
        Call xmlTCNode.appendChild(xmlStepsNode)
        
        'Create a new node for priority
        Dim xmlPriorityNode As IXMLDOMNode
        Set xmlPriorityNode = xmlDoc.createNode(NODE_ELEMENT, "importance", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(TC.priority)
        Call xmlPriorityNode.appendChild(xmlInnerTxt)
        Call xmlTCNode.appendChild(xmlPriorityNode)
        
        'Create a new node for execution type
        Dim xmlExecTypeNode As IXMLDOMNode
        Set xmlExecTypeNode = xmlDoc.createNode(NODE_ELEMENT, "execution_type", "")
        Set xmlInnerTxt = xmlDoc.createCDATASection(TC.ExecutionType)
        Call xmlExecTypeNode.appendChild(xmlInnerTxt)
        Call xmlTCNode.appendChild(xmlExecTypeNode)
        
        If binding_Req = True And Not TC.requirements = "" Then
            
            Dim xmlReqCollNode As IXMLDOMNode
            Set xmlReqCollNode = xmlDoc.createNode(NODE_ELEMENT, "requirements", "")
            
            Dim reqItems() As String
            reqItems() = Split(TC.requirements, Chr(10))
            
            Dim i As Integer
            
            For i = 0 To UBound(reqItems)
                
                Dim ReqID As String
                ReqID = reqItems(i)
                
                'Query correct id and title
                Dim req As Requirement
                
                For Each req In reqColl
                    
                    If ReqID = req.ID Then
                    
                        'Add Requirement node
                        Dim xmlReqNode As IXMLDOMNode
                        Set xmlReqNode = xmlDoc.createNode(NODE_ELEMENT, "requirement", "")
                        
                        'Add doc id
                        Dim xmlDocIdNode As IXMLDOMNode
                        Set xmlDocIdNode = xmlDoc.createNode(NODE_ELEMENT, "doc_id", "")
                        Set xmlInnerTxt = xmlDoc.createCDATASection(req.ID)
                        Call xmlDocIdNode.appendChild(xmlInnerTxt)
                        Call xmlReqNode.appendChild(xmlDocIdNode)
                        
                        'Add title
                        Dim xmlTitleNode As IXMLDOMNode
                        Set xmlTitleNode = xmlDoc.createNode(NODE_ELEMENT, "title", "")
                        Set xmlInnerTxt = xmlDoc.createCDATASection(req.Title)
                        Call xmlTitleNode.appendChild(xmlInnerTxt)
                        Call xmlReqNode.appendChild(xmlTitleNode)
                                                    
                        'Append to requirements node
                        Call xmlReqCollNode.appendChild(xmlReqNode)
                        
                        Exit For
    
                    End If
                
                Next
            Next
            
            'If current test case has valid associated requirements
            If xmlReqCollNode.HasChildNodes Then
                Call xmlTCNode.appendChild(xmlReqCollNode)
            End If
            
        End If
        
        xmlRootElement.appendChild xmlTCNode
        
        Set xmlTCElement = xmlTCNode
        
        'Create an attribute for internal id
        If TC.InternalID <> vbNullString Then
            Call xmlTCElement.setAttribute("internalid", TC.InternalID)
        End If
        'Create an attribute for external id
        If TC.ExternalID <> vbNullString Then
            Call xmlTCElement.setAttribute("externalid", TC.ExternalID)
        End If
        
        'Create an attribute for name
        Call xmlTCElement.setAttribute("name", TC.Name)
        
    Next
    
    Call xmlDoc.Save(exportPath)
    
    MsgBox "Done! " + CStr(tc_Coll.count) + " test case(s) were exported!", vbInformation + vbOKOnly, "Message:"
    
End Sub

'Check whether current test suite worksheet is a correct worksheet
Private Function IsValidTestSuiteWorksheet(ByRef ws As Worksheet) As Boolean

    If Trim(ws.Range("A1").Value) = "ID" And Trim(ws.Range("B1").Value) = "Name" And Trim(ws.Range("C1").Value) = "Summary" And Trim(ws.Range("D1").Value) = "Preconditions" And _
      Trim(ws.Range("E1").Value) = "Steps" And Trim(ws.Range("F1").Value) = "Expected Results" And Trim(ws.Range("G1").Value) = "Priority" And Trim(ws.Range("H1").Value) = "Execution Type" Then
       IsValidTestSuiteWorksheet = True
    Else
        IsValidTestSuiteWorksheet = False
    End If
    
End Function

'Check whether current requirement coll worksheet is a correct worksheet
Private Function IsValidReqCollWorksheet(ByRef ws As Worksheet) As Boolean

    If Trim(ws.Range("A1").Value) = "Req. ID" And Trim(ws.Range("B1").Value) = "Title" And Trim(ws.Range("C1").Value) = "Scope" And Trim(ws.Range("D1").Value) = "Status" And Trim(ws.Range("E1").Value) = "Type" Then
        IsValidReqCollWorksheet = True
    Else
        IsValidReqCollWorksheet = False
    End If
    
End Function

'Retrieve current workbook, check if there has requirement coll worksheet opened.
Private Function HasReqCollWorksheetOpened() As Boolean
    
    If Application.Workbooks.count = 0 Then
        HasReqCollWorksheetOpened = False
        Exit Function
    End If
    
    Dim ws As Worksheet
    
    For Each ws In ActiveWorkbook.Sheets
        If IsValidReqCollWorksheet(ws) Then
            HasReqCollWorksheetOpened = True
            Exit Function
        End If
    Next
    
    HasReqCollWorksheetOpened = False
    
End Function

'Retrieve current workbook, check if there has test suite worksheet opened.
Private Function HasTestSuiteWorksheetOpened() As Boolean
    
    If Application.Workbooks.count = 0 Then
        HasTestSuiteWorksheetOpened = False
        Exit Function
    End If
    
    Dim ws As Worksheet
    
    For Each ws In ActiveWorkbook.Sheets
        If IsValidTestSuiteWorksheet(ws) Then
            HasTestSuiteWorksheetOpened = True
            Exit Function
        End If
    Next
    
    HasTestSuiteWorksheetOpened = False
    
End Function

Private Function RetrieveAllRequirements() As Collection

    Dim req_coll As Collection
    Set req_coll = New Collection
    
    If Application.Workbooks.count = 0 Then
        Exit Function
    End If
    
    Dim ws As Worksheet
    
    For Each ws In ActiveWorkbook.Sheets
        
        If IsValidReqCollWorksheet(ws) Then
            
            Dim rowIndex As Integer
            rowIndex = 2
            
            While ws.Cells(rowIndex, 1).Value <> vbNullString And ws.Cells(rowIndex, 2).Value <> vbNullString
                Dim req As Requirement
                Set req = New Requirement
                
                'ReqID
                req.ID = Trim(ws.Cells(rowIndex, 1))
                'Title
                req.Title = Trim(ws.Cells(rowIndex, 2))
                
                rowIndex = rowIndex + 1
                
                Call req_coll.Add(req)
            Wend
        
        End If
        
    Next
    
    Set RetrieveAllRequirements = req_coll
    
End Function

Public Sub AnalyzeAllTestSuites()
    
    If Application.Workbooks.count = 0 Then
        MsgBox "No active workbook found!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If
    
    If Not HasTestSuiteWorksheetOpened Then
        MsgBox "No test suite worksheet opened in current workbook!", vbCritical + vbOKOnly, "Error:"
        Exit Sub
    End If
    
    'Start analysing all test suite worksheets of current workbook
    
    Dim ws As Worksheet
    Dim analysisResult As New Collection
    
    For Each ws In ActiveWorkbook.Worksheets
        
        If IsValidTestSuiteWorksheet(ws) Then
        
            Dim analysItem As analysisItem
            
            Set analysItem = New analysisItem
            
            'Set test suite name
            analysItem.TestSuiteName = ws.Name
            
            Dim rowIndex As Integer
            rowIndex = 2
            
            While ws.Cells(rowIndex, 1).Value <> vbNullString And ws.Cells(rowIndex, 2).Value <> vbNullString
            
                Dim priority As String
                
                priority = Trim(ws.Cells(rowIndex, 7).Value)
                
                Select Case priority
                    Case "High"
                        analysItem.High = analysItem.High + 1
                    Case "Medium"
                        analysItem.Medium = analysItem.Medium + 1
                    Case "Low"
                        analysItem.Low = analysItem.Low + 1
                    Case Else
                        analysItem.Medium = analysItem.Medium + 1
                End Select
                
                Dim execType As String
                execType = Trim(ws.Cells(rowIndex, 8).Value)
                
                Select Case execType
                    Case "Automated"
                        analysItem.Auto = analysItem.Auto + 1
                    Case "Manual"
                        analysItem.Manual = analysItem.Manual + 1
                    Case Else
                        analysItem.Manual = analysItem.Manual + 1
                End Select
                
                rowIndex = rowIndex + 1
            
            Wend
            
            Call analysisResult.Add(analysItem)
        
        End If
        
    Next
    
    Call GenTestSuiteAnalysisRpt(analysisResult)
    
End Sub

Private Sub GenTestSuiteAnalysisRpt(ByRef analysisResult As Collection)
    
    Dim ws_name As String
    ws_name = "Test Suite Analysis Report"
        
    Application.ScreenUpdating = False
        
    Dim ws As Worksheet
    'Loop workbook to check whether there already have a analysis result worksheet
    Dim found As Boolean
    found = False
    For Each ws In ActiveWorkbook.Sheets
        If ws.Name = ws_name Then
            found = True
            ws.Activate
            ws.Range("A6:I44").Select
            Call Selection.ClearContents
            Exit For
        End If
    Next
        
    'If doesn't have Analysis result worksheet, then create a new one
    If Not found Then
        Dim ws_template As Worksheet
        Set ws = ActiveWorkbook.Sheets.Add(after:=ActiveWorkbook.ActiveSheet)
        ws.Name = ws_name
        Set ws_template = ThisWorkbook.Sheets("Template")
        ws_template.Range("Q1:Y47").Copy
        ws.Range("A1").PasteSpecial Paste:=xlPasteColumnWidths, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
        ws.Paste
        ws.Activate
    End If
    
    Dim item As analysisItem
    
    Dim rowIndex As Integer
    rowIndex = 6
    
    For Each item In analysisResult
        
        'Test suite name
        ws.Cells(rowIndex, 1).Value = item.TestSuiteName
        'High
        ws.Cells(rowIndex, 3).Value = item.High
        'Medium
        ws.Cells(rowIndex, 4).Value = item.Medium
        'Low
        ws.Cells(rowIndex, 5).Value = item.Low
        'Auto
        ws.Cells(rowIndex, 6).Value = item.Auto
        'Manual
        ws.Cells(rowIndex, 7).Value = item.Manual
        'AutoRate
        ws.Cells(rowIndex, 8).Value = item.AutoRate
        'Total
        ws.Cells(rowIndex, 9).Value = item.total
        
        rowIndex = rowIndex + 1
        
    Next
        
    Application.ScreenUpdating = False
    
End Sub

Private Sub GenReqCollAnalysisRpt(ByRef analysisResult As Collection)
    
    Dim ws_name As String
    ws_name = "Requirements Analysis Report"
        
    Application.ScreenUpdating = False
        
    Dim ws As Worksheet
    'Loop workbook to check whether there already have a analysis result worksheet
    Dim found As Boolean
    found = False
    For Each ws In ActiveWorkbook.Sheets
        If ws.Name = ws_name Then
            found = True
            ws.Activate
            ws.Range("A5:G104").Select
            Call Selection.ClearContents
            Exit For
        End If
    Next
        
    'If doesn't have Analysis result worksheet, then create a new one
    If Not found Then
        Dim ws_template As Worksheet
        Set ws = ActiveWorkbook.Sheets.Add(after:=ActiveWorkbook.ActiveSheet)
        ws.Name = ws_name
        Set ws_template = ThisWorkbook.Sheets("Template")
        ws_template.Range("AA50:AG149").Copy
        ws.Range("A1").PasteSpecial Paste:=xlPasteColumnWidths, Operation:=xlNone, SkipBlanks:=False, Transpose:=False
        ws.Paste
        ws.Activate
    End If
    
    Dim item As ReqAnalysisItem
    
    Dim rowIndex As Integer
    rowIndex = 5
    
    For Each item In analysisResult
        
        'Requirement ID
        ws.Cells(rowIndex, 1).Value = item.ReqID
        'Requirement Title
        ws.Cells(rowIndex, 3).Value = item.ReqTitle
        'Belongs To
        ws.Cells(rowIndex, 4).Value = item.BelongsTo
        'Status
        ws.Cells(rowIndex, 5).Value = item.Status
        'Requirement Type
        ws.Cells(rowIndex, 6).Value = item.ReqType
        'Total TC
        ws.Cells(rowIndex, 7).Value = item.TotalTC
        
        rowIndex = rowIndex + 1
        
    Next
        
    Application.ScreenUpdating = False
    
End Sub


Public Sub ShowHelp()
    Call HelpForm.Show
End Sub

Public Sub ShowFriendlyError()
    MsgBox "Not implemented yet! Please stay tuned!", vbCritical + vbOKOnly, "Error:"
End Sub
