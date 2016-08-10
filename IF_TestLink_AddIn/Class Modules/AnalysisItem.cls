VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AnalysisItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mTestSuiteName As String

Private mHigh As Integer
Private mMedium As Integer
Private mLow As Integer

Private mAuto As Integer
Private mManual As Integer

Private mAutoRate As Double

Public Property Get TestSuiteName() As String
    TestSuiteName = mTestSuiteName
End Property

Public Property Let TestSuiteName(ByVal SuiteName As String)
    mTestSuiteName = SuiteName
End Property

Public Property Get High() As Integer
    High = mHigh
End Property

Public Property Let High(ByVal priority As Integer)
    mHigh = priority
End Property

Public Property Get Medium() As Integer
    Medium = mMedium
End Property

Public Property Let Medium(ByVal priority As Integer)
    mMedium = priority
End Property

Public Property Get Low() As Integer
    Low = mLow
End Property

Public Property Let Low(ByVal priority As Integer)
    mLow = priority
End Property

Public Property Get Auto() As Integer
    Auto = mAuto
End Property

Public Property Let Auto(ByVal i As Integer)
    mAuto = i
End Property

Public Property Get Manual() As Integer
    Manual = mManual
End Property

Public Property Let Manual(ByVal i As Integer)
    mManual = i
End Property

Public Property Get AutoRate() As Double
    If total <> 0 Then
        AutoRate = CDbl(Auto) / CDbl(total)
    Else
        AutoRate = CDbl(0)
    End If
End Property

Public Property Get total() As Double
    total = High + Medium + Low
End Property

Private Sub Class_Initialize()
    High = 0
    Medium = 0
    Low = 0
    Auto = 0
    Manual = 0
End Sub
