unit mxFrameController;

interface

uses
  System.Classes,
  Vcl.Graphics,
  mxGradient,
  mxRegIniFile;

type
  TFrameControllerProperty = (fcpColor, fcpFocusColor, fcpDisabledColor, fcpReadOnlyColor, fcpReadOnlyColorOnFocus, fcpParentColor, fcpFlatButtonColor,
    fcpFlatButtons, fcpFrameColor, fcpFrameHotColor, fcpFrameHotTrack, fcpFrameHotStyle, fcpFrameSides, fcpFrameStyle, fcpFrameVisible,
    fcpFramingPreference, fcpAll);

  TFrameControllerPropertyConnection = fcpColor .. fcpFramingPreference;

  TFrameControllerNotifications = set of TFrameControllerPropertyConnection;

  TRzFrameController = class(TComponent)
  private
    FColor: TColor;
    FParentColor: Boolean;
    FFrameList: TList;
    FFlatButtonColor: TColor;
    FFlatButtons: Boolean;
    FDisabledColor: TColor;
    FReadOnlyColor: TColor;
    FReadOnlyColorOnFocus: Boolean;
    FFocusColor: TColor;
    FFrameColor: TColor;
    FFrameHotColor: TColor;
    FFrameHotTrack: Boolean;
    FFrameHotStyle: TFrameStyle;
    FFrameSides: TSides;
    FFrameStyle: TFrameStyle;
    FFrameVisible: Boolean;
    FFramingPreference: TFramingPreference;
    FUpdateCount: Integer;
    FRegIniFile: TRegIniFile;
    procedure ReadFrameFlatProp(Reader: TReader);
    procedure ReadFrameFocusStyleProp(Reader: TReader);
    procedure ReadEnumProp(Reader: TReader);
    function StoreColor: Boolean;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetNotifications(C: TComponent): TFrameControllerNotifications;
    procedure UpdateControlFrame(C: TComponent; FrameProperty: TFrameControllerProperty); virtual;
    procedure UpdateFrames(FrameProperty: TFrameControllerProperty); virtual;
    procedure SetColor(Value: TColor); virtual;
    procedure SetParentColor(Value: Boolean); virtual;
    procedure SetFlatButtonColor(Value: TColor); virtual;
    procedure SetFlatButtons(Value: Boolean); virtual;
    procedure SetDisabledColor(Value: TColor); virtual;
    procedure SetReadOnlyColor(Value: TColor); virtual;
    procedure SetReadOnlyColorOnFocus(Value: Boolean); virtual;
    procedure SetFocusColor(Value: TColor); virtual;
    procedure SetFrameColor(Value: TColor); virtual;
    procedure SetFrameHotColor(Value: TColor); virtual;
    procedure SetFrameHotTrack(Value: Boolean); virtual;
    procedure SetFrameHotStyle(Value: TFrameStyle); virtual;
    procedure SetFrameSides(Value: TSides); virtual;
    procedure SetFrameStyle(Value: TFrameStyle); virtual;
    procedure SetFrameVisible(Value: Boolean); virtual;
    procedure SetFramingPreference(Value: TFramingPreference); virtual;
    procedure SetRegIniFile(Value: TRegIniFile); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure UpdateControls;
    procedure AddControl(C: TComponent);
    procedure RemoveControl(C: TComponent);
    procedure Load(const Section: string);
    procedure Save(const Section: string);
  published
    property Color: TColor read FColor write SetColor stored StoreColor default clWindow;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor default clBtnFace;
    property ReadOnlyColor: TColor read FReadOnlyColor write SetReadOnlyColor default clInfoBk;
    property ReadOnlyColorOnFocus: Boolean read FReadOnlyColorOnFocus write SetReadOnlyColorOnFocus default False;
    property FlatButtonColor: TColor read FFlatButtonColor write SetFlatButtonColor default clBtnFace;
    property FlatButtons: Boolean read FFlatButtons write SetFlatButtons default True;
    property FocusColor: TColor read FFocusColor write SetFocusColor default clWindow;
    property FrameColor: TColor read FFrameColor write SetFrameColor default clBtnShadow;
    property FrameHotColor: TColor read FFrameHotColor write SetFrameHotColor default clBtnShadow;
    property FrameHotStyle: TFrameStyle read FFrameHotStyle write SetFrameHotStyle default fsFlatBold;
    property FrameHotTrack: Boolean read FFrameHotTrack write SetFrameHotTrack default False;
    property FrameSides: TSides read FFrameSides write SetFrameSides default sdAllSides;
    property FrameStyle: TFrameStyle read FFrameStyle write SetFrameStyle default fsFlat;
    property FrameVisible: Boolean read FFrameVisible write SetFrameVisible default False;
    property FramingPreference: TFramingPreference read FFramingPreference write SetFramingPreference default fpXPThemes;
    property ParentColor: Boolean read FParentColor write SetParentColor default False;
    property RegIniFile: TRegIniFile read FRegIniFile write SetRegIniFile;
  end;

const
  fccAll = [fcpColor, fcpFocusColor, fcpDisabledColor, fcpReadOnlyColor, fcpReadOnlyColorOnFocus, fcpParentColor, fcpFlatButtonColor, fcpFlatButtons,
    fcpFrameColor, fcpFrameHotColor, fcpFrameHotTrack, fcpFrameHotStyle, fcpFrameSides, fcpFrameStyle, fcpFrameVisible, fcpFramingPreference];

  fcpColorBit                   = $00000001;
  fcpFocusColorBit              = $00000002;
  fcpDisabledColorBit           = $00000004;
  fcpReadOnlyColorBit           = $00000008;
  fcpReadOnlyColorOnFocusBit    = $00000010;
  fcpParentColorBit             = $00000020;
  fcpFlatButtonColorBit         = $00000040;
  fcpFlatButtonsBit             = $00000080;
  fcpFrameColorBit              = $00000100;
  fcpFrameHotColorBit           = $00000200;
  fcpFrameHotTrackBit           = $00000400;
  fcpFrameHotStyleBit           = $00000800;
  fcpFrameSidesBit              = $00001000;
  fcpFrameStyleBit              = $00002000;
  fcpFrameVisibleBit            = $00004000;
  fcpFramingPreferenceBit       = $00008000;

implementation

uses
  System.TypInfo,
  System.SysUtils,
  Vcl.Controls;

constructor TRzFrameController.Create(AOwner: TComponent);
begin
  inherited;
  FUpdateCount := 0;
  FColor := clWindow;
  FParentColor := False;
  FFlatButtonColor := clBtnFace;
  FFlatButtons := True;
  FDisabledColor := clBtnFace;
  FReadOnlyColor := clInfoBk;
  FReadOnlyColorOnFocus := False;
  FFocusColor := clWindow;
  FFrameColor := clBtnShadow;
  FFrameHotColor := clBtnShadow;
  FFrameHotTrack := False;
  FFrameHotStyle := fsFlatBold;
  FFrameSides := sdAllSides;
  FFrameStyle := fsFlat;
  FFrameVisible := False;
  FFramingPreference := fpXPThemes;
end;

procedure TRzFrameController.DefineProperties(Filer: TFiler);
begin
  inherited;
  // Handle the fact that the FrameFlat and FrameFocusStyle properties were renamed to
  // FrameHotStyle and FrameHotStyle respectively in version 3.
  Filer.DefineProperty('FrameFlat', ReadFrameFlatProp, nil, False);
  Filer.DefineProperty('FrameFocusStyle', ReadFrameFocusStyleProp, nil, False);

  // Handle the fact that the FrameFlatStyle was published in version 2.x
  Filer.DefineProperty('FrameFlatStyle', ReadEnumProp, nil, False);
end;

procedure TRzFrameController.ReadEnumProp(Reader: TReader);
begin
  Reader.ReadIdent;
end;

procedure TRzFrameController.ReadFrameFlatProp(Reader: TReader);
begin
  FFrameHotTrack := Reader.ReadBoolean;
  if FFrameHotTrack then
  begin
    // If the FrameFlat property is stored, then init the FrameHotStyle property
    // and the FrameStyle property. These may be overridden when the rest of the
    // stream is read in. However, we need to re-init them here because the
    // default values of fsStatus and fsLowered have changed in RC3.
    FFrameStyle := fsStatus;
    FFrameHotStyle := fsLowered;
  end;
end;

procedure TRzFrameController.ReadFrameFocusStyleProp(Reader: TReader);
begin
  FFrameHotStyle := TFrameStyle(GetEnumValue(TypeInfo(TFrameStyle), Reader.ReadIdent));
end;

procedure TRzFrameController.Loaded;
begin
  inherited;
  UpdateControls;
end;

destructor TRzFrameController.Destroy;
begin
  if FFrameList <> nil then
  begin
    FFrameList.Free;
    FFrameList := nil;
  end;

  inherited;
end;

procedure TRzFrameController.Assign(Source: TPersistent);
begin
  if Source is TRzFrameController then
  begin
    BeginUpdate;
    try
      FColor := TRzFrameController(Source).Color;
      FDisabledColor := TRzFrameController(Source).DisabledColor;
      FReadOnlyColor := TRzFrameController(Source).ReadOnlyColor;
      FReadOnlyColorOnFocus := TRzFrameController(Source).ReadOnlyColorOnFocus;
      FFlatButtonColor := TRzFrameController(Source).FlatButtonColor;
      FFlatButtons := TRzFrameController(Source).FlatButtons;
      FFocusColor := TRzFrameController(Source).FocusColor;
      FFrameColor := TRzFrameController(Source).FrameColor;
      FFrameHotColor := TRzFrameController(Source).FrameHotColor;
      FFrameHotStyle := TRzFrameController(Source).FrameHotStyle;
      FFrameHotTrack := TRzFrameController(Source).FrameHotTrack;
      FFrameSides := TRzFrameController(Source).FrameSides;
      FFrameStyle := TRzFrameController(Source).FrameStyle;
      FFrameVisible := TRzFrameController(Source).FrameVisible;
      FFramingPreference := TRzFrameController(Source).FramingPreference;
      FParentColor := TRzFrameController(Source).ParentColor;
    finally
      EndUpdate;
    end;
  end
  else
    inherited;
end;

procedure TRzFrameController.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and (AComponent = FRegIniFile) then
    FRegIniFile := nil;
end;

procedure TRzFrameController.AddControl(C: TComponent);
begin
  if not Assigned(FFrameList) then
    FFrameList := TList.Create;

  if FFrameList.IndexOf(C) < 0 then
  begin
    FFrameList.Add(C);
    UpdateControlFrame(C, fcpAll);
  end;
end;

procedure TRzFrameController.RemoveControl(C: TComponent);
begin
  if FFrameList <> nil then
  begin
    FFrameList.Remove(C);
    if FFrameList.Count = 0 then
    begin
      FFrameList.Free;
      FFrameList := nil;
    end;
  end;
end;

procedure TRzFrameController.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TRzFrameController.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then
  begin
    FUpdateCount := 0;
    UpdateFrames(fcpAll);
  end;
end;

procedure TRzFrameController.UpdateControls;
begin
  UpdateFrames(fcpAll);
end;

function TRzFrameController.GetNotifications(C: TComponent): TFrameControllerNotifications;
var
  NotificationsSet: Cardinal;
begin
  if IsPublishedProp(C, 'FrameControllerNotifications') then
  begin
    NotificationsSet := GetOrdProp(C, 'FrameControllerNotifications');

    Result := [];
    if (NotificationsSet and fcpColorBit) = fcpColorBit then
      Result := Result + [fcpColor];
    if (NotificationsSet and fcpFocusColorBit) = fcpFocusColorBit then
      Result := Result + [fcpFocusColor];
    if (NotificationsSet and fcpDisabledColorBit) = fcpDisabledColorBit then
      Result := Result + [fcpDisabledColor];
    if (NotificationsSet and fcpReadOnlyColorBit) = fcpReadOnlyColorBit then
      Result := Result + [fcpReadOnlyColor];
    if (NotificationsSet and fcpReadOnlyColorOnFocusBit) = fcpReadOnlyColorOnFocusBit then
      Result := Result + [fcpReadOnlyColorOnFocus];
    if (NotificationsSet and fcpParentColorBit) = fcpParentColorBit then
      Result := Result + [fcpParentColor];
    if (NotificationsSet and fcpFlatButtonColorBit) = fcpFlatButtonColorBit then
      Result := Result + [fcpFlatButtonColor];
    if (NotificationsSet and fcpFlatButtonsBit) = fcpFlatButtonsBit then
      Result := Result + [fcpFlatButtons];
    if (NotificationsSet and fcpFrameColorBit) = fcpFrameColorBit then
      Result := Result + [fcpFrameColor];
    if (NotificationsSet and fcpFrameHotColorBit) = fcpFrameHotColorBit then
      Result := Result + [fcpFrameHotColor];
    if (NotificationsSet and fcpFrameHotTrackBit) = fcpFrameHotTrackBit then
      Result := Result + [fcpFrameHotTrack];
    if (NotificationsSet and fcpFrameHotStyleBit) = fcpFrameHotStyleBit then
      Result := Result + [fcpFrameHotStyle];
    if (NotificationsSet and fcpFrameSidesBit) = fcpFrameSidesBit then
      Result := Result + [fcpFrameSides];
    if (NotificationsSet and fcpFrameStyleBit) = fcpFrameStyleBit then
      Result := Result + [fcpFrameStyle];
    if (NotificationsSet and fcpFrameVisibleBit) = fcpFrameVisibleBit then
      Result := Result + [fcpFrameVisible];
    if (NotificationsSet and fcpFramingPreferenceBit) = fcpFramingPreferenceBit then
      Result := Result + [fcpFramingPreference];
  end
  else
    Result := fccAll;
end;

procedure TRzFrameController.UpdateControlFrame(C: TComponent; FrameProperty: TFrameControllerProperty);
var
  Ref: IFramingNotification;
  Notifications: TFrameControllerNotifications;

  procedure SetBooleanProp(C: TComponent; const PropName: string; Value: Boolean);
  begin
    if C <> nil then
    begin
      if IsPublishedProp(C, PropName) then
        SetOrdProp(C, PropName, Ord(Value));
    end;
  end;

  procedure SetStyleProp(C: TComponent; const PropName: string; Value: TFrameStyle);
  begin
    if C <> nil then
    begin
      if IsPublishedProp(C, PropName) then
        SetOrdProp(C, PropName, Ord(Value));
    end;
  end;

  procedure SetPreferenceProp(C: TComponent; const PropName: string; Value: TFramingPreference);
  begin
    if C <> nil then
    begin
      if IsPublishedProp(C, PropName) then
        SetOrdProp(C, PropName, Ord(Value));
    end;
  end;

  procedure SetColorProp(C: TComponent; const PropName: string; Value: TColor);
  begin
    if C <> nil then
    begin
      if IsPublishedProp(C, PropName) then
        SetOrdProp(C, PropName, Value);
    end;
  end;

  procedure SetFrameSidesProp(C: TComponent);
  begin
    if C <> nil then
    begin
      if IsPublishedProp(C, 'FrameSides') then
        SetSetProp(C, 'FrameSides', GetSetProp(Self, 'FrameSides'));
    end;
  end;

begin
  if not(C is TControl) then
    Exit;

  Notifications := GetNotifications(C);

  if Supports(C, IFramingNotification) then
  begin
    Ref := C as IFramingNotification;
    Ref.FramingChanged;
  end
  else // Use RTTI to update Custom Framing properties
  begin
    case FrameProperty of
      fcpAll:
        begin
          if fcpParentColor in Notifications then
            SetBooleanProp(C, 'ParentColor', FParentColor);

          if not FParentColor then
          begin
            if fcpColor in Notifications then
              SetColorProp(C, 'Color', FColor);
          end;

          if fcpDisabledColor in Notifications then
            SetColorProp(C, 'DisabledColor', FDisabledColor);
          if fcpReadOnlyColor in Notifications then
            SetColorProp(C, 'ReadOnlyColor', FReadOnlyColor);
          if fcpReadOnlyColorOnFocus in Notifications then
            SetBooleanProp(C, 'ReadOnlyColorOnFocus', FReadOnlyColorOnFocus);
          if fcpFocusColor in Notifications then
            SetColorProp(C, 'FocusColor', FFocusColor);
          if fcpFlatButtonColor in Notifications then
            SetColorProp(C, 'FlatButtonColor', FFlatButtonColor);
          if fcpFlatButtons in Notifications then
            SetBooleanProp(C, 'FlatButtons', FFlatButtons);
          if fcpFrameColor in Notifications then
            SetColorProp(C, 'FrameColor', FFrameColor);
          if fcpFrameHotColor in Notifications then
            SetColorProp(C, 'FrameHotColor', FFrameHotColor);
          if fcpFrameHotTrack in Notifications then
            SetBooleanProp(C, 'FrameHotTrack', FFrameHotTrack);
          if fcpFrameHotStyle in Notifications then
            SetStyleProp(C, 'FrameHotStyle', FFrameHotStyle);
          if fcpFrameSides in Notifications then
            SetFrameSidesProp(C);
          if fcpFrameStyle in Notifications then
            SetStyleProp(C, 'FrameStyle', FFrameStyle);
          if fcpFrameVisible in Notifications then
            SetBooleanProp(C, 'FrameVisible', FFrameVisible);
          if fcpFramingPreference in Notifications then
            SetPreferenceProp(C, 'FramingPreference', FFramingPreference);
        end;

      fcpColor:
        begin
          if fcpColor in Notifications then
            SetColorProp(C, 'Color', FColor);
        end;

      fcpFocusColor:
        begin
          if fcpFocusColor in Notifications then
            SetColorProp(C, 'FocusColor', FFocusColor);
        end;

      fcpDisabledColor:
        begin
          if fcpDisabledColor in Notifications then
            SetColorProp(C, 'DisabledColor', FDisabledColor);
        end;

      fcpReadOnlyColor:
        begin
          if fcpReadOnlyColor in Notifications then
            SetColorProp(C, 'ReadOnlyColor', FReadOnlyColor);
        end;

      fcpReadOnlyColorOnFocus:
        begin
          if fcpReadOnlyColorOnFocus in Notifications then
            SetBooleanProp(C, 'ReadOnlyColorOnFocus', FReadOnlyColorOnFocus);
        end;

      fcpParentColor:
        begin
          if fcpParentColor in Notifications then
            SetBooleanProp(C, 'ParentColor', FParentColor);
        end;

      fcpFlatButtonColor:
        begin
          if fcpFlatButtonColor in Notifications then
            SetColorProp(C, 'FlatButtonColor', FFlatButtonColor);
        end;

      fcpFlatButtons:
        begin
          if fcpFlatButtons in Notifications then
            SetBooleanProp(C, 'FlatButtons', FFlatButtons);
        end;

      fcpFrameColor:
        begin
          if fcpFrameColor in Notifications then
            SetColorProp(C, 'FrameColor', FFrameColor);
        end;

      fcpFrameHotColor:
        begin
          if fcpFrameHotColor in Notifications then
            SetColorProp(C, 'FrameHotColor', FFrameHotColor);
        end;

      fcpFrameHotTrack:
        begin
          if fcpFrameHotTrack in Notifications then
            SetBooleanProp(C, 'FrameHotTrack', FFrameHotTrack);
        end;

      fcpFrameHotStyle:
        begin
          if fcpFrameHotStyle in Notifications then
            SetStyleProp(C, 'FrameHotStyle', FFrameHotStyle);
        end;

      fcpFrameSides:
        begin
          if fcpFrameSides in Notifications then
            SetFrameSidesProp(C);
        end;

      fcpFrameStyle:
        begin
          if fcpFrameStyle in Notifications then
            SetStyleProp(C, 'FrameStyle', FFrameStyle);
        end;

      fcpFrameVisible:
        begin
          if fcpFrameVisible in Notifications then
            SetBooleanProp(C, 'FrameVisible', FFrameVisible);
        end;

      fcpFramingPreference:
        begin
          if fcpFramingPreference in Notifications then
            SetPreferenceProp(C, 'FramingPreference', FFramingPreference);
        end;
    end;
  end;
end; { = TRzFrameController.UpdateControlFrame = }

procedure TRzFrameController.UpdateFrames(FrameProperty: TFrameControllerProperty);
var
  I: Integer;
begin
  if FUpdateCount > 0 then
    Exit;

  if FFrameList <> nil then
  begin
    { For each component on the FFrameList ... }
    for I := 0 to FFrameList.Count - 1 do
    begin
      UpdateControlFrame(FFrameList[I], FrameProperty);
    end;
  end;
end;

procedure TRzFrameController.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    if FFocusColor = FColor then
      FFocusColor := Value;
    FColor := Value;
    FParentColor := False;
    UpdateFrames(fcpColor);
  end;
end;

function TRzFrameController.StoreColor: Boolean;
begin
  Result := not ParentColor;
end;

procedure TRzFrameController.SetParentColor(Value: Boolean);
begin
  if FParentColor <> Value then
  begin
    FParentColor := Value;
    UpdateFrames(fcpParentColor);
    if not FParentColor then
      UpdateFrames(fcpColor);
  end;
end;

procedure TRzFrameController.SetFlatButtonColor(Value: TColor);
begin
  if FFlatButtonColor <> Value then
  begin
    FFlatButtonColor := Value;
    UpdateFrames(fcpFlatButtonColor);
  end;
end;

procedure TRzFrameController.SetFlatButtons(Value: Boolean);
begin
  if FFlatButtons <> Value then
  begin
    FFlatButtons := Value;
    UpdateFrames(fcpFlatButtons);
  end;
end;

procedure TRzFrameController.SetDisabledColor(Value: TColor);
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    UpdateFrames(fcpDisabledColor);
  end;
end;

procedure TRzFrameController.SetReadOnlyColor(Value: TColor);
begin
  if FReadOnlyColor <> Value then
  begin
    FReadOnlyColor := Value;
    UpdateFrames(fcpReadOnlyColor);
  end;
end;

procedure TRzFrameController.SetReadOnlyColorOnFocus(Value: Boolean);
begin
  if FReadOnlyColorOnFocus <> Value then
  begin
    FReadOnlyColorOnFocus := Value;
    UpdateFrames(fcpReadOnlyColorOnFocus);
  end;
end;

procedure TRzFrameController.SetFocusColor(Value: TColor);
begin
  if FFocusColor <> Value then
  begin
    FFocusColor := Value;
    UpdateFrames(fcpFocusColor);
  end;
end;

procedure TRzFrameController.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    UpdateFrames(fcpFrameColor);
  end;
end;

procedure TRzFrameController.SetFrameHotColor(Value: TColor);
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor := Value;
    UpdateFrames(fcpFrameHotColor);
  end;
end;

procedure TRzFrameController.SetFrameHotTrack(Value: Boolean);
begin
  if FFrameHotTrack <> Value then
  begin
    FFrameHotTrack := Value;
    if FFrameHotTrack then
    begin
      FrameVisible := True;
      if not(csLoading in ComponentState) then
        FFrameSides := sdAllSides;
    end;
    UpdateFrames(fcpFrameHotTrack);
  end;
end;

procedure TRzFrameController.SetFrameHotStyle(Value: TFrameStyle);
begin
  if FFrameHotStyle <> Value then
  begin
    FFrameHotStyle := Value;
    UpdateFrames(fcpFrameHotStyle);
  end;
end;

procedure TRzFrameController.SetFrameSides(Value: TSides);
begin
  if FFrameSides <> Value then
  begin
    FFrameSides := Value;
    UpdateFrames(fcpFrameSides);
  end;
end;

procedure TRzFrameController.SetFrameStyle(Value: TFrameStyle);
begin
  if FFrameStyle <> Value then
  begin
    FFrameStyle := Value;
    UpdateFrames(fcpFrameStyle);
  end;
end;

procedure TRzFrameController.SetFrameVisible(Value: Boolean);
begin
  if FFrameVisible <> Value then
  begin
    FFrameVisible := Value;
    UpdateFrames(fcpFrameVisible);
  end;
end;

procedure TRzFrameController.SetFramingPreference(Value: TFramingPreference);
begin
  if FFramingPreference <> Value then
  begin
    FFramingPreference := Value;
    UpdateFrames(fcpFramingPreference);
  end;
end;

procedure TRzFrameController.Load(const Section: string);
begin
  if FRegIniFile = nil then
    raise ENoRegIniFile.Create(rsCannotLoadCustomFraming);

  BeginUpdate;
  try
    FColor := FRegIniFile.ReadInteger(Section, 'Color', clWindow);
    FFlatButtonColor := FRegIniFile.ReadInteger(Section, 'FlatButtonColor', clBtnFace);
    FFlatButtons := FRegIniFile.ReadBool(Section, 'FlatButtons', True);
    FDisabledColor := FRegIniFile.ReadInteger(Section, 'DisabledColor', clWindow);
    FReadOnlyColor := FRegIniFile.ReadInteger(Section, 'ReadOnlyColor', clInfoBk);
    FReadOnlyColorOnFocus := FRegIniFile.ReadBool(Section, 'ReadOnlyColorOnFocus', False);
    FFocusColor := FRegIniFile.ReadInteger(Section, 'FocusColor', clWindow);
    FFrameColor := FRegIniFile.ReadInteger(Section, 'FrameColor', clBtnShadow);
    FFrameHotColor := FRegIniFile.ReadInteger(Section, 'FrameHotColor', clBtnShadow);
    FFrameHotStyle := TFrameStyle(FRegIniFile.ReadInteger(Section, 'FrameHotStyle', Ord(fsFlatBold)));
    FFrameHotTrack := FRegIniFile.ReadBool(Section, 'FrameHotTrack', False);

    FFrameSides := [];
    if FRegIniFile.ReadBool(Section, 'FrameSides_Left', True) then
      FFrameSides := FFrameSides + [sdLeft];
    if FRegIniFile.ReadBool(Section, 'FrameSides_Top', True) then
      FFrameSides := FFrameSides + [sdTop];
    if FRegIniFile.ReadBool(Section, 'FrameSides_Right', True) then
      FFrameSides := FFrameSides + [sdRight];
    if FRegIniFile.ReadBool(Section, 'FrameSides_Bottom', True) then
      FFrameSides := FFrameSides + [sdBottom];

    FFrameStyle := TFrameStyle(FRegIniFile.ReadInteger(Section, 'FrameStyle', Ord(fsFlat)));
    FFrameVisible := FRegIniFile.ReadBool(Section, 'FrameVisible', False);
    FFramingPreference := TFramingPreference(FRegIniFile.ReadInteger(Section, 'FramingPreference', Ord(fpXPThemes)));

  finally
    EndUpdate;
  end;
end;

procedure TRzFrameController.Save(const Section: string);
begin
  if FRegIniFile = nil then
    raise ENoRegIniFile.Create(rsCannotSaveCustomFraming);

  FRegIniFile.WriteInteger(Section, 'Color', FColor);
  FRegIniFile.WriteInteger(Section, 'FlatButtonColor', FFlatButtonColor);
  FRegIniFile.WriteBool(Section, 'FlatButtons', FFlatButtons);
  FRegIniFile.WriteInteger(Section, 'DisabledColor', FDisabledColor);
  FRegIniFile.WriteInteger(Section, 'ReadOnlyColor', FReadOnlyColor);
  FRegIniFile.WriteBool(Section, 'ReadOnlyColorOnFocus', FReadOnlyColorOnFocus);
  FRegIniFile.WriteInteger(Section, 'FocusColor', FFocusColor);
  FRegIniFile.WriteInteger(Section, 'FrameColor', FFrameColor);
  FRegIniFile.WriteInteger(Section, 'FrameHotColor', FFrameHotColor);
  FRegIniFile.WriteInteger(Section, 'FrameHotStyle', Ord(FFrameHotStyle));
  FRegIniFile.WriteBool(Section, 'FrameHotTrack', FFrameHotTrack);

  FRegIniFile.WriteBool(Section, 'FrameSides_Left', sdLeft in FFrameSides);
  FRegIniFile.WriteBool(Section, 'FrameSides_Top', sdTop in FFrameSides);
  FRegIniFile.WriteBool(Section, 'FrameSides_Right', sdRight in FFrameSides);
  FRegIniFile.WriteBool(Section, 'FrameSides_Bottom', sdBottom in FFrameSides);

  FRegIniFile.WriteInteger(Section, 'FrameStyle', Ord(FFrameStyle));
  FRegIniFile.WriteBool(Section, 'FrameVisible', FFrameVisible);
  FRegIniFile.WriteInteger(Section, 'FramingPreference', Ord(FFramingPreference));
end;

procedure TRzFrameController.SetRegIniFile(Value: TRegIniFile);
begin
  if FRegIniFile <> Value then
  begin
    FRegIniFile := Value;
    if Value <> nil then
      Value.FreeNotification(Self);
  end;
end;

end.
