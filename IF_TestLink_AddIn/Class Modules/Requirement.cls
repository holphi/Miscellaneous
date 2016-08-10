VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Requirement"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mReqId As String

Private mTitle As String

Private mScope As String

Private mStatus As String

Private mReqType As String

Private mReleaseNum As String

Public Property Get ID() As String
    ID = mReqId
End Property

Public Property Let ID(ByVal ReqID As String)
    mReqId = ReqID
End Property

Public Property Get ReleaseNum() As String
    ReleaseNum = mReleaseNum
End Property

Public Property Let ReleaseNum(ByVal RelNum As String)
    mReleaseNum = RelNum
End Property

Public Property Get Title() As String
    Title = mTitle
End Property

Public Property Let Title(ByVal Title As String)
    mTitle = Title
End Property

Public Property Get Scope() As String
    Scope = mScope
End Property

Public Property Let Scope(ByVal Scope As String)
    mScope = Scope
End Property

Public Property Get Status() As String
    Status = mStatus
End Property

Public Property Let Status(ByVal Status As String)

    'Change to lower case
    Status = LCase(Status)
    
    Select Case Status
        Case "draft"
            mStatus = "D"
        Case "review"
            mStatus = "R"
        Case "rework"
            mStatus = "W"
        Case "finish"
            mStatus = "F"
        Case "implemented"
            mStatus = "I"
        Case "valid"
            mStatus = "V"
        Case "not testable"
            mStatus = "N"
        Case "obsolete"
            mStatus = "O"
        Case Else
            mStatus = "D"
    End Select
    
End Property

Public Property Get ReqType() As String
    ReqType = mReqType
End Property

Public Property Let ReqType(ByVal ReqType As String)

    'Change to lower case
    ReqType = LCase(ReqType)
    
    Select Case ReqType
        Case "informational"
            mReqType = "1"
        Case "feature"
            mReqType = "2"
        Case "use case"
            mReqType = "3"
        Case "user interface"
            mReqType = "4"
        Case "not functional"
            mReqType = "5"
        Case "constraint"
            mReqType = "6"
        Case "system function"
            mReqType = "7"
        Case Else
            mReqType = "1"
    End Select
    
End Property

Private Sub Class_Initialize()

    ID = vbNullString
    Title = vbNullString
    Scope = vbNullString
    Status = vbNullString
    ReqType = vbNullString
    ReleaseNum = vbNullString
    
End Sub
