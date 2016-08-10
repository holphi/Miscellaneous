VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ReqAnalysisItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mReqId As String
Private mReqTitle As String
Private mBelongsTo As String
Private mStatus As String
Private mReqType As String
Private mTotalTC As Integer

Public Property Get ReqID() As String
    ReqID = mReqId
End Property

Public Property Let ReqID(ByVal RequirementId As String)
    mReqId = RequirementId
End Property

Public Property Get ReqTitle() As String
    ReqTitle = mReqTitle
End Property

Public Property Let ReqTitle(ByVal Title As String)
    mReqTitle = Title
End Property

Public Property Get BelongsTo() As String
    BelongsTo = mBelongsTo
End Property

Public Property Let BelongsTo(ByVal SheetName As String)
    mBelongsTo = SheetName
End Property

Public Property Get Status() As String
    Status = mStatus
End Property

Public Property Let Status(ByVal myStatus As String)
    mStatus = myStatus
End Property

Public Property Get ReqType() As String
    ReqType = mReqType
End Property

Public Property Let ReqType(ByVal myReqType As String)
    mReqType = myReqType
End Property

Public Property Get TotalTC() As Integer
    TotalTC = mTotalTC
End Property

Public Property Let TotalTC(ByVal total As Integer)
    mTotalTC = total
End Property

Private Sub Class_Initialize()
    ReqID = ""
    ReqTitle = ""
    BelongsTo = ""
    TotalTC = 0
    Status = "NOT SPECIFIED"
    ReqType = "NOT SPECIFIED"
End Sub



