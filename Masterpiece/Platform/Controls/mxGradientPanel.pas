unit mxGradientPanel;

interface

uses
  Winapi.Messages,
  Winapi.Windows,
  System.Classes,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Vcl.Controls,
  mxGradient,
  mxFrameController;

type
  TCustomGradientPanel = class;

  TPanelDockManager = class(TDockTree)
  private
    FPanel: TCustomGradientPanel;
    FOldWndProc: TWndMethod;
    procedure WindowProcHook(var Msg: TMessage);
  protected
    FFont: TFont;
    FCloseFont: TFont;
    FGrabberSize: Integer;
    procedure AdjustDockRect(Control: TControl; var ARect: TRect); override;
    procedure DrawVertTitle(Canvas: TCanvas; const Caption: string; Bounds: TRect);
    procedure PaintDockFrame(Canvas: TCanvas; Control: TControl; const ARect: TRect); override;
  public
    constructor Create(DockSite: TWinControl); override;
    destructor Destroy; override;
  end;

  TCustomGradientPanel = class(TCustomPanel, IFramingNotification)
  private
    FInAlignControls: Boolean;
    FAlignmentVertical: TAlignmentVertical;
    FBorderInner: TFrameStyle;
    FBorderOuter: TFrameStyle;
    FBorderSides: TSides;
    FBorderColor: TColor;
    FBorderHighlight: TColor;
    FBorderShadow: TColor;
    FFlatColor: TColor;
    FFlatColorAdjustment: Integer;
    FPaintClientArea: Boolean;
    FPanelColor: TColor;
    FVisualStyle: TVisualStyle;
    FGradientColorStyle: TGradientColorStyle;
    FGradientColorStart: TColor;
    FGradientColorStop: TColor;
    FGradientDirection: TGradientDirection;
    FGridColor: TColor;
    FGridStyle: TGridStyle;
    FGridXSize: Word;
    FGridYSize: Word;
    FShowGrid: Boolean;
    FTransparent: Boolean;
    FTextMargin: Integer;
    FTextMarginVertical: Integer;
    FWordWrap: Boolean;
    FShowDockClientCaptions: Boolean;
    FEnabledList: TStringList;
    FOnPaint: TNotifyEvent;
    procedure ReadFrameSidesProp(Reader: TReader);
    procedure ReadThemeAwareProp(Reader: TReader);
    procedure ReadUseGradientsProp(Reader: TReader);
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure WMWindowPosChanged(var Msg: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMThemeChanged(var Msg: TMessage); message WM_THEMECHANGED;
    procedure CMColorChanged(var Msg: TMessage); message CM_COLORCHANGED;
    procedure CMStyleChanged(var Msg: TMessage); message CM_STYLECHANGED;
    procedure UpdatePanelColor;
  protected
    FFrameController: TRzFrameController;
    FFrameControllerNotifications: TFrameControllerNotifications;
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    function CursorPosition: TPoint; virtual;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure FixClientRect(var Rect: TRect; ShrinkByBorder: Boolean); virtual;
    procedure AdjustClientRect(var Rect: TRect); override;
    function GetClientRect: TRect; override;
    function GetControlRect: TRect; virtual;
    function InvalidateMarginSize: TPoint; virtual;
    procedure EnableChildControls(Enabled: Boolean); virtual;
    procedure GetGradientColors(var StartColor, StopColor: TColor); virtual;
    procedure GetGradientFrameColor(var FrameColor: TColor; var FrameColorAdjustment: Integer); virtual;
    procedure DrawCaption(Rect: TRect); virtual;
    procedure DrawGrid(Rect: TRect); virtual;
    procedure Paint; override;
    procedure FramingChanged; virtual;
    function CreateDockManager: IDockManager; override;
    procedure SetAlignmentVertical(Value: TAlignmentVertical); virtual;
    procedure SetBorderColor(Value: TColor); virtual;
    procedure SetBorderInner(Value: TFrameStyle); virtual;
    procedure SetBorderOuter(Value: TFrameStyle); virtual;
    procedure SetBorderSides(Value: TSides); virtual;
    procedure SetBorderHighlight(Value: TColor); virtual;
    procedure SetBorderShadow(Value: TColor); virtual;
    procedure SetFlatColor(Value: TColor); virtual;
    procedure SetFlatColorAdjustment(Value: Integer); virtual;
    procedure SetFrameController(Value: TRzFrameController); virtual;
    procedure SetGradientColorStyle(Value: TGradientColorStyle); virtual;
    procedure SetGradientColorStart(Value: TColor); virtual;
    procedure SetGradientColorStop(Value: TColor); virtual;
    procedure SetGradientDirection(Value: TGradientDirection); virtual;
    procedure SetGridColor(Value: TColor); virtual;
    procedure SetGridStyle(Value: TGridStyle); virtual;
    procedure SetGridXSize(Value: Word); virtual;
    procedure SetGridYSize(Value: Word); virtual;
    procedure SetPaintClientArea(Value: Boolean); virtual;
    procedure SetShowGrid(Value: Boolean); virtual;
    procedure SetTransparent(Value: Boolean); virtual;
    procedure SetTextMargin(Value: Integer); virtual;
    procedure SetTextMarginVertical(Value: Integer); virtual;
    procedure SetWordWrap(Value: Boolean); virtual;
    procedure SetVisualStyle(Value: TVisualStyle); virtual;
    property AlignmentVertical: TAlignmentVertical read FAlignmentVertical write SetAlignmentVertical default avCenter;
    property BorderInner: TFrameStyle read FBorderInner write SetBorderInner default fsNone;
    property BorderOuter: TFrameStyle read FBorderOuter write SetBorderOuter default fsRaised;
    property BorderSides: TSides read FBorderSides write SetBorderSides default [sdLeft, sdTop, sdRight, sdBottom];
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBtnFace;
    property BorderHighlight: TColor read FBorderHighlight write SetBorderHighlight default clBtnHighlight;
    property BorderShadow: TColor read FBorderShadow write SetBorderShadow default clBtnShadow;
    property FlatColor: TColor read FFlatColor write SetFlatColor default clBtnShadow;
    property FlatColorAdjustment: Integer read FFlatColorAdjustment write SetFlatColorAdjustment default 30;
    property FrameControllerNotifications: TFrameControllerNotifications read FFrameControllerNotifications write FFrameControllerNotifications default fccAll;
    property FrameController: TRzFrameController read FFrameController write SetFrameController;
    property GradientColorStyle: TGradientColorStyle read FGradientColorStyle write SetGradientColorStyle default gcsSystem;
    property GradientColorStart: TColor read FGradientColorStart write SetGradientColorStart default clWhite;
    property GradientColorStop: TColor read FGradientColorStop write SetGradientColorStop default clBtnFace;
    property GradientDirection: TGradientDirection read FGradientDirection write SetGradientDirection default gdHorizontalEnd;
    property GridColor: TColor read FGridColor write SetGridColor default clBtnShadow;
    property GridStyle: TGridStyle read FGridStyle write SetGridStyle default gsDots;
    property GridXSize: Word read FGridXSize write SetGridXSize default 8;
    property GridYSize: Word read FGridYSize write SetGridYSize default 8;
    property PaintClientArea: Boolean read FPaintClientArea write SetPaintClientArea default True;
    property TextMargin: Integer read FTextMargin write SetTextMargin default 0;
    property TextMarginVertical: Integer read FTextMarginVertical write SetTextMarginVertical default 0;
    property ShowGrid: Boolean read FShowGrid write SetShowGrid default False;
    property ShowDockClientCaptions: Boolean read FShowDockClientCaptions write FShowDockClientCaptions default True;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
    property VisualStyle: TVisualStyle read FVisualStyle write SetVisualStyle default vsWinXP;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default True;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure SetGridSize(XSize, YSize: Integer);
  end;

  TGradientPanel = class(TCustomGradientPanel)
  public
    property Canvas;
    property DockManager;
  published
    property Align;
    property Alignment;
    property AlignmentVertical;
    property Anchors;
    property AutoSize;
    property BevelWidth;
    property BiDiMode;
    property BorderInner;
    property BorderOuter;
    property BorderSides;
    property BorderColor;
    property BorderHighlight;
    property BorderShadow;
    property BorderWidth;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment;
    property Font;
    property FrameControllerNotifications;
    property FrameController;
    property FullRepaint;
    property GradientColorStyle;
    property GradientColorStart;
    property GradientColorStop;
    property GradientDirection;
    property GridColor;
    property GridStyle;
    property GridXSize;
    property GridYSize;
    property Locked;
    property PaintClientArea;
    property TextMargin;
    property TextMarginVertical;
    property Padding;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowDockClientCaptions;
    property ShowGrid;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Transparent;
    property UseDockManager default True;
    property Visible;
    property VisualStyle;
    property WordWrap;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

implementation

uses
  Vcl.Themes,
  mxGrafx;

type
  TTextControl = class(TControl)
  end;

  { TPanelDockManager }

constructor TPanelDockManager.Create(DockSite: TWinControl);
begin
  inherited;
  FPanel := DockSite as TCustomGradientPanel;
  FGrabberSize := 14;

  FFont := TFont.Create;
  FFont.Name := 'Verdana';
  FFont.Size := 8;

  FCloseFont := TFont.Create;
  FCloseFont.Name := 'Marlett';
  FCloseFont.Size := 8;

  if not(csDesigning in DockSite.ComponentState) then
  begin
    FOldWndProc := DockSite.WindowProc;
    DockSite.WindowProc := WindowProcHook;
  end;

end;

destructor TPanelDockManager.Destroy;
begin
  if @FOldWndProc <> nil then
  begin
    DockSite.WindowProc := FOldWndProc;
    FOldWndProc := nil;
  end;

  FFont.Free;
  FCloseFont.Free;
  inherited;
end;

procedure TPanelDockManager.WindowProcHook(var Msg: TMessage);
begin
  // This allows us to change the color of the caption bar on focus changes.
  if (Msg.Msg = wm_Command) or (Msg.Msg = wm_MouseActivate) then
    DockSite.Invalidate;

  if Assigned(FOldWndProc) then
    FOldWndProc(Msg);
end;

procedure TPanelDockManager.AdjustDockRect(Control: TControl; var ARect: TRect);
begin
  // Allocate room for the caption on the left if docksite is horizontally
  // oriented, otherwise allocate room for the caption on the top.
  if FPanel.Align in [alTop, alBottom] then
    Inc(ARect.Left, FGrabberSize)
  else
    Inc(ARect.Top, FGrabberSize);
end;

procedure TPanelDockManager.DrawVertTitle(Canvas: TCanvas; const Caption: string; Bounds: TRect);
var
  R, TempRct: TRect;
  Center: TPoint;
  Flags: Word;
  OldTextAlign: Integer;

  function TextAligned(A: Integer): Boolean;
  begin
    Result := (Flags and A) = A;
  end;

begin
  with Canvas do
  begin
    OldTextAlign := GetTextAlign(Canvas.Handle);
    R := Bounds;

    Flags := dt_ExpandTabs or DrawTextAlignments[taLeftJustify];

    Center.X := R.Right - 2;
    Center.Y := R.Bottom - 3;
    SetTextAlign(Canvas.Handle, ta_Left or ta_Baseline);

    Font.Handle := RotateFont(FFont, 90);
    Canvas.Font.Color := clCaptionText;

    TempRct := R;
    TextRect(TempRct, Center.X, Center.Y, Caption);

    SetTextAlign(Canvas.Handle, OldTextAlign);
  end;
end;

procedure TPanelDockManager.PaintDockFrame(Canvas: TCanvas; Control: TControl; const ARect: TRect);
var
  R: TRect;
  S: string;
begin
  if not FPanel.ShowDockClientCaptions then
    inherited
  else
  begin
    S := TTextControl(Control).Text;
    Canvas.Font := FFont;

    if Control is TWinControl then
    begin
      if TWinControl(Control).Focused then
      begin
        Canvas.Brush.Color := clActiveCaption;
        Canvas.Font.Color := clCaptionText;
      end
      else
      begin
        Canvas.Brush.Color := clInactiveCaption;
        Canvas.Font.Color := clInactiveCaptionText;
      end;
    end
    else
    begin
      Canvas.Brush.Color := clActiveCaption;
      Canvas.Font.Color := clCaptionText;
    end;

    if FPanel.Align in [alTop, alBottom] then
    begin
      R := Rect(ARect.Left, ARect.Top, ARect.Left + FGrabberSize, ARect.Bottom);
      DrawVertTitle(Canvas, S, R);

      // Draw the Close X
      Canvas.Font.Name := FCloseFont.Name;
      R := Rect(ARect.Left + 1, ARect.Top + 1, ARect.Left + FGrabberSize - 2, ARect.Top + 12);
      Canvas.TextRect(R, R.Left, R.Top, 'r');
    end
    else
    begin
      R := Rect(ARect.Left, ARect.Top, ARect.Right, ARect.Top + FGrabberSize);
      Canvas.TextRect(R, R.Left + 2, R.Top, S);

      // Draw the Close X
      Canvas.Font.Name := FCloseFont.Name;
      R := Rect(ARect.Right - FGrabberSize - 1, ARect.Top + 1, ARect.Right - 2, ARect.Top + 12);
      Canvas.TextRect(R, R.Left, R.Top, 'r');
    end;
  end;
end;

{ TCustomGradientPanel }

constructor TCustomGradientPanel.Create(AOwner: TComponent);
begin
  inherited;
  { Prevent Caption from being set to default name }
  ControlStyle := ControlStyle - [csSetCaption];
  // Delphi 7 sets the csParentBackground style and removes the csOpaque style when Themes are available, which causes
  // all kinds of other problems, so we restore these.
  ControlStyle := ControlStyle - [csParentBackground] + [csOpaque];
  FFrameController := nil;
  FFrameControllerNotifications := fccAll;

  FPaintClientArea := True;
  FBorderSides := [sdLeft, sdTop, sdRight, sdBottom];
  FBorderColor := clBtnFace;
  FBorderHighlight := clBtnHighlight;
  FBorderShadow := clBtnShadow;
  FBorderOuter := fsRaised;
  FFlatColor := clBtnShadow;
  FFlatColorAdjustment := 30;
  BevelOuter := bvNone;
  FAlignmentVertical := avCenter;
  FInAlignControls := False;

  FShowGrid := False;
  FGridColor := clBtnShadow;
  FGridStyle := gsDots;
  FGridXSize := 8;
  FGridYSize := 8;

  FTextMargin := 0;
  FTextMarginVertical := 0;
  FWordWrap := True;

  FVisualStyle := vsWinXP;
  FGradientColorStyle := gcsSystem;
  FGradientColorStart := clWhite;
  FGradientColorStop := clBtnFace;
  FGradientDirection := gdHorizontalEnd;
  FShowDockClientCaptions := True;
  FEnabledList := TStringList.Create;
  FPanelColor := clBtnFace;
end;

destructor TCustomGradientPanel.Destroy;
begin
  if FFrameController <> nil then
    FFrameController.RemoveControl(Self);

  FEnabledList.Free;
  inherited;
end;

procedure TCustomGradientPanel.DefineProperties(Filer: TFiler);
begin
  inherited;
  // Handle the fact that the FrameSides property was published in version 2.x
  Filer.DefineProperty('FrameSides', ReadFrameSidesProp, nil, False);
  // Handle the fact that the ThemeAware property was published in verison 3.x
  Filer.DefineProperty('ThemeAware', ReadThemeAwareProp, nil, False);
  // Handle the fact that the UseGradients property was replaced with the VisualStyle property
  Filer.DefineProperty('UseGradients', ReadUseGradientsProp, nil, False);
end;


procedure TCustomGradientPanel.ReadFrameSidesProp(Reader: TReader);
begin
  Reader.ReadValue;
  while True do
  begin
    if Reader.ReadStr = '' then
      Break;
  end;
end;

procedure TCustomGradientPanel.ReadThemeAwareProp(Reader: TReader);
begin
  Reader.ReadBoolean;
end;

procedure TCustomGradientPanel.ReadUseGradientsProp(Reader: TReader);
var
  UseGradients: Boolean;
begin
  UseGradients := Reader.ReadBoolean;
  if UseGradients then
    VisualStyle := vsGradient;
end;

procedure TCustomGradientPanel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FFrameController) then
    FFrameController := nil;
end;

procedure TCustomGradientPanel.Loaded;
begin
  inherited;
{$IFDEF VCL160_OR_HIGHER}
  UpdatePanelColor;
{$ENDIF}
end;

function TCustomGradientPanel.CursorPosition: TPoint;
begin
  GetCursorPos(Result);
  Result := ScreenToClient(Result);
end;

procedure TCustomGradientPanel.AlignControls(AControl: TControl; var Rect: TRect);
begin
  FixClientRect(Rect, False);
  inherited;
end;

procedure TCustomGradientPanel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  // The following code handles situations where the panel is aligned alRight
  // or alBottom and there is another control also aligned alRight or alBottom
  // adjacent to this control.  If the size of this panel is changed the order
  // of all the controls aligned in the same direction will get re-ordered.

  if Align = alBottom then
  begin
    if AHeight <> Height then
      ATop := Top - (AHeight - Height);
  end
  else if Align = alRight then
  begin
    if AWidth <> Width then
      ALeft := Left - (AWidth - Width);
  end;

  inherited;
end;

procedure TCustomGradientPanel.FixClientRect(var Rect: TRect; ShrinkByBorder: Boolean);

  procedure AdjustRect(var R: TRect; Sides: TSides; N: Integer);
  begin
    if sdLeft in Sides then
      Inc(R.Left, N);
    if sdTop in Sides then
      Inc(R.Top, N);
    if sdRight in Sides then
      Dec(R.Right, N);
    if sdBottom in Sides then
      Dec(R.Bottom, N);
  end;

begin
  if ShrinkByBorder then
    InflateRect(Rect, -BorderWidth, -BorderWidth);

  if FBorderOuter = fsFlat then
    AdjustRect(Rect, FBorderSides, 1)
  else if FBorderOuter in [fsStatus, fsPopup] then
    AdjustRect(Rect, FBorderSides, BevelWidth)
  else if FBorderOuter in [fsGroove .. fsButtonUp, fsFlatBold, fsFlatRounded] then
    AdjustRect(Rect, FBorderSides, 2);

  if FBorderInner = fsFlat then
    AdjustRect(Rect, FBorderSides, 1)
  else if FBorderInner in [fsStatus, fsPopup] then
    AdjustRect(Rect, FBorderSides, BevelWidth)
  else if FBorderInner in [fsGroove .. fsButtonUp, fsFlatBold, fsFlatRounded] then
    AdjustRect(Rect, FBorderSides, 2);
end;

procedure TCustomGradientPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  if DockSite then
    FixClientRect(Rect, False);
end;

function TCustomGradientPanel.GetClientRect: TRect;
begin
  Result := inherited GetClientRect;
end;

procedure TCustomGradientPanel.WMWindowPosChanged(var Msg: TWMWindowPosChanged);
var
  R, CR: TRect;
begin
  if FullRepaint or (Caption <> '') then
    Invalidate
  else
  begin

    R := Rect(0, 0, Width, Height);
    CR := R;
    FixClientRect(CR, True);

    if Msg.WindowPos^.cx <> R.Right then
    begin
      R.Left := CR.Right - InvalidateMarginSize.X;
      R.Top := 0;
      InvalidateRect(Handle, @R, True);
    end;

    if Msg.WindowPos^.cy <> R.Bottom then
    begin
      R.Left := 0;
      R.Top := CR.Bottom - InvalidateMarginSize.Y;
      InvalidateRect(Handle, @R, True);
    end;
  end;
  inherited;
end;

procedure TCustomGradientPanel.GetGradientColors(var StartColor, StopColor: TColor);
begin
  if FGradientColorStyle <> gcsCustom then
  begin
    GetGradientPanelColors(FGradientColorStyle, StartColor, StopColor);
  end
  else
  begin
    StartColor := FGradientColorStart;
    StopColor := FGradientColorStop;
  end;
end;

procedure TCustomGradientPanel.GetGradientFrameColor(var FrameColor: TColor; var FrameColorAdjustment: Integer);
begin
  if (FVisualStyle = vsGradient) and (FGradientColorStyle <> gcsCustom) then
  begin
    FrameColor := GetGradientPanelFrameColor(FGradientColorStyle);
    FrameColorAdjustment := 0;
  end
  else
  begin
    FrameColor := FFlatColor;
    FrameColorAdjustment := FFlatColorAdjustment;
  end;
end;

procedure TCustomGradientPanel.DrawCaption(Rect: TRect);
var
  TextRct: TRect;
  H: Integer;
  Flags: Longint;
{$IFDEF VCL160_OR_HIGHER}
  C: TColor;
  Details: TThemedElementDetails;
{$ENDIF}
begin
  if Caption <> '' then
  begin
    Canvas.Font := Self.Font;

    InflateRect(Rect, -FTextMargin, -FTextMarginVertical);

    TextRct := Rect;
    Flags := dt_CalcRect or dt_ExpandTabs or dt_VCenter or DrawTextWordWrap[WordWrap] or DrawTextAlignments[Alignment];

    if StyleServices.IsSystemStyle then
    begin
      H := DrawString(Canvas, Caption, TextRct, Flags);
    end
    else // VCL Styles
    begin
{$IFDEF VCL160_OR_HIGHER}
      Details := StyleServices.GetElementDetails(tpPanelBackground);
      if not StyleServices.GetElementColor(Details, ecTextColor, C) or (C = clNone) then
        C := Font.Color;
      StyleServices.DrawText(Canvas.Handle, Details, Caption, TextRct, TTextFormatFlags(Flags), C);
      H := TextRct.Bottom - TextRct.Top;

{$ELSE}
      // To eliminate warnings in earlier versions of Delphi -- this code will not be called
      H := 0;
{$ENDIF}
    end;

    case FAlignmentVertical of
      avTop:
        begin
          if Rect.Top + H < Rect.Bottom then
            Rect.Bottom := Rect.Top + H;
        end;

      avCenter:
        begin
          Rect.Top := ((Rect.Bottom + Rect.Top) - H) div 2;
          if Rect.Top + H < Rect.Bottom then
            Rect.Bottom := Rect.Top + H;
        end;

      avBottom:
        begin
          if Rect.Bottom - H - 1 > Rect.Top then
            Rect.Top := Rect.Bottom - H - 1;
        end;
    end;

    Canvas.Brush.Style := bsClear;

    Flags := dt_ExpandTabs or dt_VCenter or DrawTextWordWrap[WordWrap] or DrawTextAlignments[Alignment];

    if StyleServices.IsSystemStyle then
    begin
      if not Enabled then
        Canvas.Font.Color := clGrayText;

      DrawString(Canvas, Caption, Rect, Flags);
    end
    else // VCL Styles
    begin
{$IFDEF VCL160_OR_HIGHER}
      if not StyleServices.GetElementColor(Details, ecTextColor, C) or (C = clNone) then
        C := Font.Color;
      if not Enabled then
        C := StyleServices.GetSystemColor(clGrayText);
      StyleServices.DrawText(Canvas.Handle, Details, Caption, Rect, TTextFormatFlags(Flags), C);
{$ENDIF}
    end;
  end;
end; { = TRzCustomPanel.DrawCaption = }

function TCustomGradientPanel.GetControlRect: TRect;
begin
  Result := Rect(0, 0, Width, Height);
end;

function TCustomGradientPanel.InvalidateMarginSize: TPoint;
begin
  Result := Point(1, 1);
end;

procedure TCustomGradientPanel.DrawGrid(Rect: TRect);
var
  X, Y, XCount, YCount: Integer;
  GC: TColor;

  procedure DrawHorzLine(X1, X2, Y: Integer);
  var
    X: Integer;
  begin
    if FGridStyle = gsSolidLines then
    begin
      Canvas.MoveTo(X1, Y);
      Canvas.LineTo(X2, Y);
    end
    else
    begin
      X := X1 + 1;
      Canvas.MoveTo(X, Y);
      while X < X2 do
      begin
        Canvas.Pixels[X, Y] := GC;
        Inc(X, 2);
      end;
    end;
  end;

  procedure DrawVertLine(X, Y1, Y2: Integer);
  var
    Y: Integer;
  begin
    if FGridStyle = gsSolidLines then
    begin
      Canvas.MoveTo(X, Y1);
      Canvas.LineTo(X, Y2);
    end
    else
    begin
      Y := Y1 + 1;
      Canvas.MoveTo(X, Y);
      while Y < Y2 do
      begin
        Canvas.Pixels[X, Y] := GC;
        Inc(Y, 2);
      end;

    end;
  end;

begin { = TRzCustomPanel.DrawGrid = }
  if FGridXSize > 0 then
    XCount := (Rect.Right - Rect.Left) div FGridXSize
  else
    XCount := 0;
  if FGridYSize > 0 then
    YCount := (Rect.Bottom - Rect.Top) div FGridYSize
  else
    YCount := 0;

  GC := ActiveStyleSystemColor(FGridColor);

  Canvas.Pen.Color := GC;
  case FGridStyle of
    gsDots:
      begin
        for X := 1 to XCount do
        begin
          for Y := 1 to YCount do
            Canvas.Pixels[Rect.Left - 1 + X * FGridXSize, Rect.Top - 1 + Y * FGridYSize] := GC;
        end;
      end;

    gsDottedLines, gsSolidLines:
      begin
        for X := 1 to XCount do
          DrawVertLine(Rect.Left - 1 + X * FGridXSize, Rect.Top, Rect.Bottom);

        for Y := 1 to YCount do
          DrawHorzLine(Rect.Left, Rect.Right, Rect.Top - 1 + Y * FGridYSize);
      end;
  end;
end; { = TRzCustomPanel.DrawGrid = }

procedure TCustomGradientPanel.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  if FTransparent and PaintClientArea then
  begin
    if (Parent <> nil) and Parent.DoubleBuffered then
      PerformEraseBackground(Self, Msg.DC);
    DrawParentImage(Self, Msg.DC, True);
    // Do not call inherited -- prevents TWinControl.WMEraseBkgnd from
    // erasing background. Set Msg.Result to 1 to indicate background is painted
    // by the control.
    Msg.Result := 1;
  end
  else
    inherited;
end;

type
  TWinControlAccess = class(TWinControl);

procedure TCustomGradientPanel.Paint;
var
  R, SaveRect: TRect;
  StartColor, StopColor, PanelColor, FrameColor, ParentColor, BdrColor, BdrHighlight, BdrShadow: TColor;
  FrameColorAdjustment: Integer;
  RoundCorners: Boolean;
{$IFDEF VCL160_OR_HIGHER}
  C: TColor;
  Style: TCustomStyleServices;
  Details: TThemedElementDetails;
{$ENDIF}
begin
  R := GetControlRect;

  if StyleServices.IsSystemStyle or (VisualStyle = vsClassic) then
  begin
    GetGradientFrameColor(FrameColor, FrameColorAdjustment);
    if Parent <> nil then
      ParentColor := TWinControlAccess(Parent).Color
    else
      ParentColor := clBtnFace;
    BdrColor := FBorderColor;
    BdrHighlight := FBorderHighlight;
    BdrShadow := FBorderShadow;
    PanelColor := Color;
  end
  else // VCL Styles
  begin
{$IFDEF VCL160_OR_HIGHER}
    Style := StyleServices;

    FrameColor := Style.GetSystemColor(FFlatColor);
    FrameColorAdjustment := FFlatColorAdjustment;

    Details := Style.GetElementDetails(tpPanelBackground);
    if Style.GetElementColor(Details, ecFillColor, C) and (C <> clNone) then
      PanelColor := C
    else
      PanelColor := Color;
    ParentColor := PanelColor;

    Details := Style.GetElementDetails(tpPanelBevel);
    if Style.GetElementColor(Details, ecEdgeHighLightColor, C) and (C <> clNone) then
      BdrHighlight := C
    else
      BdrHighlight := FBorderHighlight;

    if Style.GetElementColor(Details, ecEdgeShadowColor, C) and (C <> clNone) then
      BdrShadow := C
    else
      BdrShadow := FBorderShadow;

    BdrColor := Style.GetSystemColor(FBorderColor);

{$ELSE}
    // To eliminate warnings in earlier versions of Delphi -- this code will not be called
    FrameColor := clNone;
    FrameColorAdjustment := 0;
    PanelColor := clNone;
    ParentColor := clNone;
    BdrColor := clNone;
    BdrHighlight := clNone;
    BdrShadow := clNone;
{$ENDIF}
  end;

  R := DrawInnerOuterBorders(Canvas, R, FBorderOuter, FBorderInner, BorderWidth, FBorderSides, BevelWidth, BdrColor, BdrHighlight, BdrShadow, FrameColor,
    FrameColorAdjustment, PanelColor, ParentColor, FTransparent);

  if not FTransparent and PaintClientArea then
  begin
    // Adjust inside border rectangle if round border
    // RoundCorners := ( BorderOuter = fsFlatRounded ) and ( BorderInner in [ fsNone, fsFlatRounded ] );
    RoundCorners := ((BorderOuter = fsFlatRounded) and (BorderInner = fsNone) and (BorderWidth = 0)) or ((BorderInner = fsFlatRounded));

    if RoundCorners then
    begin
      SaveRect := R;
      if sdLeft in BorderSides then
        Dec(R.Left);
      if sdTop in BorderSides then
        Dec(R.Top);
      if sdRight in BorderSides then
        Inc(R.Right);
      if sdBottom in BorderSides then
        Inc(R.Bottom);
    end;

    case FVisualStyle of
      vsClassic, vsWinXP:
        begin
          Canvas.Brush.Color := PanelColor;
          Canvas.FillRect(R);
        end;

      vsGradient:
        begin
          GetGradientColors(StartColor, StopColor);
          PaintGradient(Canvas, R, FGradientDirection, StartColor, StopColor);
        end;
    end;

    // Restore round corners by setting the corner color pixel back to flat color
    if RoundCorners then
    begin
      ParentColor := AdjustColor(FrameColor, FrameColorAdjustment);
      if (sdLeft in BorderSides) and (sdTop in BorderSides) then
        Canvas.Pixels[R.Left, R.Top] := ParentColor;
      if (sdTop in BorderSides) and (sdRight in BorderSides) then
        Canvas.Pixels[R.Right - 1, R.Top] := ParentColor;
      if (sdRight in BorderSides) and (sdBottom in BorderSides) then
        Canvas.Pixels[R.Right - 1, R.Bottom - 1] := ParentColor;
      if (sdLeft in BorderSides) and (sdBottom in BorderSides) then
        Canvas.Pixels[R.Left, R.Bottom - 1] := ParentColor;
      R := SaveRect;
    end;
  end;

  if FShowGrid then
    DrawGrid(R);

  Canvas.Brush.Style := bsClear;
  DrawCaption(R);
  Canvas.Brush.Style := bsSolid;

  if Assigned(FOnPaint) then
    FOnPaint(Self);

end; { = TRzCustomPanel.Paint = }

procedure TCustomGradientPanel.FramingChanged;
begin
  if FFrameController.FrameVisible then
  begin
    if fcpFrameStyle in FFrameControllerNotifications then
      FBorderOuter := FFrameController.FrameStyle;
    if fcpFrameSides in FFrameControllerNotifications then
      FBorderSides := FFrameController.FrameSides;
    if fcpFrameColor in FFrameControllerNotifications then
    begin
      FFlatColor := FFrameController.FrameColor;
      FFlatColorAdjustment := 0;
    end;
    if fcpColor in FFrameControllerNotifications then
      Color := FFrameController.Color;
    if fcpParentColor in FFrameControllerNotifications then
      ParentColor := FFrameController.ParentColor;

    if fcpColor in FFrameControllerNotifications then
    begin
      FBorderHighlight := LighterColor(Color, 100);
      FBorderShadow := DarkerColor(Color, 50);
    end;

    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetAlignmentVertical(Value: TAlignmentVertical);
begin
  if FAlignmentVertical <> Value then
  begin
    FAlignmentVertical := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetBorderSides(Value: TSides);
begin
  if FBorderSides <> Value then
  begin
    FBorderSides := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetBorderColor(Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetBorderHighlight(Value: TColor);
begin
  if FBorderHighlight <> Value then
  begin
    FBorderHighlight := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetBorderShadow(Value: TColor);
begin
  if FBorderShadow <> Value then
  begin
    FBorderShadow := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetBorderInner(Value: TFrameStyle);
begin
  if FBorderInner <> Value then
  begin
    FBorderInner := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetBorderOuter(Value: TFrameStyle);
begin
  if FBorderOuter <> Value then
  begin
    FBorderOuter := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetFlatColor(Value: TColor);
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetFlatColorAdjustment(Value: Integer);
begin
  if FFlatColorAdjustment <> Value then
  begin
    FFlatColorAdjustment := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetFrameController(Value: TRzFrameController);
begin
  if FFrameController <> nil then
    FFrameController.RemoveControl(Self);
  FFrameController := Value;
  if Value <> nil then
  begin
    Value.AddControl(Self);
    Value.FreeNotification(Self);
  end;
end;

procedure TCustomGradientPanel.SetGradientColorStyle(Value: TGradientColorStyle);
begin
  if FGradientColorStyle <> Value then
  begin
    FGradientColorStyle := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetGradientColorStart(Value: TColor);
begin
  if FGradientColorStart <> Value then
  begin
    FGradientColorStart := Value;
    Invalidate;
    InvalidateControls(Self);
  end;
end;

procedure TCustomGradientPanel.SetGradientColorStop(Value: TColor);
begin
  if FGradientColorStop <> Value then
  begin
    FGradientColorStop := Value;
    Invalidate;
    InvalidateControls(Self);
  end;
end;

procedure TCustomGradientPanel.SetGradientDirection(Value: TGradientDirection);
begin
  if FGradientDirection <> Value then
  begin
    FGradientDirection := Value;
    Invalidate;
    InvalidateControls(Self);
  end;
end;

procedure TCustomGradientPanel.SetGridColor(Value: TColor);
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetGridStyle(Value: TGridStyle);
begin
  if FGridStyle <> Value then
  begin
    FGridStyle := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetGridXSize(Value: Word);
begin
  if FGridXSize <> Value then
  begin
    FGridXSize := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetGridYSize(Value: Word);
begin
  if FGridYSize <> Value then
  begin
    FGridYSize := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetGridSize(XSize, YSize: Integer);
begin
  SetGridXSize(XSize);
  SetGridYSize(YSize);
end;

procedure TCustomGradientPanel.SetPaintClientArea(Value: Boolean);
begin
  if FPaintClientArea <> Value then
  begin
    FPaintClientArea := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetTextMargin(Value: Integer);
begin
  if FTextMargin <> Value then
  begin
    FTextMargin := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetTextMarginVertical(Value: Integer);
begin
  if FTextMarginVertical <> Value then
  begin
    FTextMarginVertical := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetShowGrid(Value: Boolean);
begin
  if FShowGrid <> Value then
  begin
    FShowGrid := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetTransparent(Value: Boolean);
var
  I: Integer;
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    if FTransparent then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
    for I := 0 to ControlCount - 1 do
      Controls[I].Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetVisualStyle(Value: TVisualStyle);
begin
  if FVisualStyle <> Value then
  begin
    FVisualStyle := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Invalidate;
  end;
end;

procedure TCustomGradientPanel.CMMouseEnter(var Msg: TMessage);
begin
  if csDesigning in ComponentState then
    Exit;

  inherited;
end;

procedure TCustomGradientPanel.CMMouseLeave(var Msg: TMessage);
begin
  inherited;
end;

procedure TCustomGradientPanel.EnableChildControls(Enabled: Boolean);
var
  I, Idx: Integer;
begin
  if not Enabled then
  begin
    FEnabledList.Clear;

    for I := 0 to ControlCount - 1 do
    begin
      if Controls[I].Enabled then
        FEnabledList.AddObject('1', Controls[I])
      else
        FEnabledList.AddObject('0', Controls[I]);
    end;

    for I := 0 to ControlCount - 1 do
      Controls[I].Enabled := False;
  end
  else
  begin
    for I := 0 to ControlCount - 1 do
    begin
      Idx := FEnabledList.IndexOfObject(Controls[I]);
      if Idx <> -1 then
      begin
        if FEnabledList[Idx] = '1' then
          Controls[I].Enabled := True;
      end
      else
        Controls[I].Enabled := True;
    end;
  end;
end;

procedure TCustomGradientPanel.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;
  Repaint;

  EnableChildControls(Enabled);
end;

function TCustomGradientPanel.CreateDockManager: IDockManager;
begin
  if (DockManager = nil) and DockSite and UseDockManager then
    Result := TPanelDockManager.Create(Self)
  else
    Result := DockManager;
  DoubleBuffered := DoubleBuffered or (Result <> nil);
end;

procedure TCustomGradientPanel.WMThemeChanged(var Msg: TMessage);
begin
  inherited;
  // Update CurrentXPColorScheme global variable
  CurrentXPColorScheme := GetXPColorScheme;
end;

procedure TCustomGradientPanel.CMColorChanged(var Msg: TMessage);
begin
  inherited;
  if StyleServices.IsSystemStyle then
    FPanelColor := Color;
end;

procedure TCustomGradientPanel.CMStyleChanged(var Msg: TMessage);
begin
  inherited;
  UpdatePanelColor;
end;

procedure TCustomGradientPanel.UpdatePanelColor;
begin
  if StyleServices.IsSystemStyle then
    Color := FPanelColor
  else
    Color := ActiveStyleSystemColor(clBtnFace);
end;

end.
