VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TestCase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mInternalID As String

Private mExternalID As String

Private mName As String

Private mSummary As String

Private mPreconditions As String

Private mSteps As String

Private mExpectedResults As String

Private mPriority As String

Private mExecType As String

Private mRequirements As String

Public Property Get InternalID() As String
    InternalID = mInternalID
End Property

Public Property Let InternalID(ByVal InternalID As String)
    mInternalID = InternalID
End Property

Public Property Get ExternalID() As String
    ExternalID = mExternalID
End Property

Public Property Let ExternalID(ByVal ExternalID As String)
    mExternalID = ExternalID
End Property

Public Property Get Name() As String
    Name = mName
End Property

Public Property Let Name(ByVal Name As String)
    mName = Name
End Property

Public Property Get Summary() As String
    Summary = mSummary
End Property

Public Property Let Summary(ByVal Summary As String)
    mSummary = Summary
End Property

Public Property Get Steps() As String
    Steps = mSteps
End Property

Public Property Let Steps(ByVal Steps As String)
    mSteps = Steps
End Property

Public Property Get Preconditions() As String
    Preconditions = mPreconditions
End Property

Public Property Let Preconditions(ByVal Preconditions As String)
    mPreconditions = Preconditions
End Property

Public Property Get ExpectedResults() As String
    ExpectedResults = mExpectedResults
End Property

Public Property Let ExpectedResults(ByVal ExpectedResults As String)
    mExpectedResults = ExpectedResults
End Property

Public Property Get priority() As String
    priority = mPriority
End Property

Public Property Let priority(ByVal priority As String)

    'Change to lower case
    priority = LCase(priority)
    
    Select Case priority
        Case "low"
            mPriority = "1"
        Case "medium"
            mPriority = "2"
        Case "high"
            mPriority = "3"
        Case Else
            mPriority = "2"
    End Select

End Property

Public Property Get ExecutionType() As String
    ExecutionType = mExecType
End Property

Public Property Let ExecutionType(ByVal execType As String)

    'Change to lower case
    execType = LCase(execType)
    
    Select Case execType
        Case "manual"
            mExecType = "1"
        Case "automated"
            mExecType = "2"
        Case Else
            mExecType = "1"
    End Select

End Property

Public Property Get requirements() As String
    requirements = mRequirements
End Property

Public Property Let requirements(ByVal requirements As String)
    mRequirements = requirements
End Property

Private Sub Class_Initialize()

    InternalID = vbNullString
    ExternalID = vbNullString
    Summary = ""
    Name = ""
    Preconditions = vbNullString
    Steps = ""
    ExpectedResults = ""
    priority = ""
    ExecutionType = ""
    requirements = vbNullString
    
End Sub
