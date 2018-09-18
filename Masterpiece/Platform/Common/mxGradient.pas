unit mxGradient;

interface

uses
  Winapi.Windows,
  System.Classes,
  Vcl.Themes,
  Vcl.Controls,
  Vcl.Graphics;

type
  IFramingNotification = interface
    ['{64B1C9EA-C954-428A-95C4-4EA2EB0F1E16}']
    procedure FramingChanged;
  end;

type
  TSmoothFactor = 1..8;

  TDWordColor = record
    ColorFract: Word;
    Color: Byte;
    Pad: Byte;
  end;

  TDWordWord = record
    FractPart: Word;
    WordPart: Word;
  end;

  TAlignmentVertical = (avTop, avCenter, avBottom);
  TFrameStyle = (fsNone, fsFlat, fsGroove, fsBump, fsLowered, fsButtonDown, fsRaised, fsButtonUp, fsStatus, fsPopup, fsFlatBold, fsFlatRounded);
  TFrameStyles = fsNone .. fsFlatBold;
  TSide = (sdLeft, sdTop, sdRight, sdBottom);
  TSides = set of TSide;
  TVisualStyle = (vsClassic, vsWinXP, vsGradient);
  TGradientColorStyle = (gcsSystem, gcsMSOffice, gcsCustom);
  TGradientDirection = (gdDiagonalUp, gdDiagonalDown, gdHorizontalEnd, gdHorizontalCenter, gdHorizontalBox, gdVerticalEnd, gdVerticalCenter, gdVerticalBox,
    gdSquareBox, gdBigSquareBox);
  TGridStyle = (gsDots, gsDottedLines, gsSolidLines);
  TFramingPreference = (fpCustomFraming, fpXPThemes);

  TFrameControllerProperty = (fcpColor, fcpFocusColor, fcpDisabledColor, fcpReadOnlyColor, fcpReadOnlyColorOnFocus, fcpParentColor, fcpFlatButtonColor,
    fcpFlatButtons, fcpFrameColor, fcpFrameHotColor, fcpFrameHotTrack, fcpFrameHotStyle, fcpFrameSides, fcpFrameStyle, fcpFrameVisible,
    fcpFramingPreference, fcpAll);

const
  sdAllSides = [sdLeft, sdTop, sdRight, sdBottom];
  DrawTextWordWrap: array [Boolean] of Word = (0, dt_WordBreak);
  DrawTextAlignments: array [TAlignment] of Word = (dt_Left, dt_Right, dt_Center);

  ULFrameColor: array[TFrameStyles] of TColor = (clWindow,             // fsNone
                                                 cl3DDkShadow,         // fsFlat
                                                 clBtnShadow,          // fsGroove
                                                 clBtnHighlight,       // fsBump
                                                 clBtnShadow,          // fsLowered
                                                 clNone,               // fsButtonDown
                                                 cl3DDkShadow,         // fsRaised
                                                 clNone,               // fsButtonUp
                                                 clBtnShadow,          // fsStatus
                                                 clBtnHighlight,       // fsPopup
                                                 clBtnShadow);        // fsFlatBold

  LRFrameColor: array[TFrameStyles] of TColor = (clWindow,             // fsNone
                                                 cl3DDkShadow,         // fsFlat
                                                 clBtnHighlight,       // fsGroove
                                                 clBtnShadow,          // fsBump
                                                 clBtnHighlight,       // fsLowered
                                                 clNone,               // fsButtonDown
                                                 clBtnFace,            // fsRaised
                                                 clNone,               // fsButtonUp
                                                 clBtnHighlight,       // fsStatus
                                                 clBtnShadow,          // fsPopup
                                                 clBtnShadow );        // fsFlatBold

type
  TXPColorScheme = (xpcsBlue, xpcsGreen, xpcsSilver);

function ActiveStyleSystemColor(C: TColor): TColor;
function ActiveStyleColor(SC: TStyleColor): TColor;
function ActiveStyleFontColor(SF: TStyleFont): TColor;
procedure ColorToHSL(C: TColor; var H, S, L: Byte);
function LighterColor(C: TColor; Adjustment: Byte): TColor;
function AdjustColor(C: TColor; Adjustment: Integer): TColor;
function BlendColors(ForeColor, BackColor: TColor; Alpha: Byte): TColor;
function DarkerColor(C: TColor; Adjustment: Byte): TColor;
function HSLtoColor(H, S, L: Byte): TColor;
function DrawString(Canvas: TCanvas; const S: string; var Bounds: TRect; Flags: UINT): Integer;
procedure DrawStringCentered(Canvas: TCanvas; const S: string; Bounds: TRect);
function DrawSides(Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Sides: TSides): TRect;
function DrawBevel(Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Width: Integer; Sides: TSides): TRect;
function DrawRoundedFlatBorder(Canvas: TCanvas; Bounds: TRect; Color: TColor; Sides: TSides): TRect;
function DrawCtl3DBorderSides(Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides): TRect;
function DrawButtonBorderSides(Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides): TRect;
function DrawBorderSides(Canvas: TCanvas; Bounds: TRect; Style: TFrameStyle; Sides: TSides): TRect;
procedure GetGradientPanelColors(ColorStyle: TGradientColorStyle; var StartColor, StopColor: TColor);
function GetGradientPanelFrameColor(ColorStyle: TGradientColorStyle): TColor;
function DrawInnerOuterBorders(Canvas: TCanvas; Bounds: TRect; BorderOuter, BorderInner: TFrameStyle; BorderWidth: Integer; BorderSides: TSides;
  BevelWidth: Integer; BorderColor, BorderHighlight, BorderShadow: TColor; FlatColor: TColor; FlatColorAdjustment: Integer; Color, ParentColor: TColor;
  Transparent: Boolean; SoftInnerFlatBorder: Boolean = False): TRect;
procedure PaintGradient(Canvas: TCanvas; Bounds: TRect; GradDir: TGradientDirection; ColorStart, ColorStop: TColor; SmoothFactor: TSmoothFactor = 1);
procedure PaintGradientEx(Canvas: TCanvas; Bounds: TRect; GradDir: TGradientDirection; ColorStart, ColorStop: TColor; SmoothFactor: TSmoothFactor = 1);
procedure InvalidateControls(Container: TWinControl);
function GetXPColorScheme: TXPColorScheme;
function RotateFont(Font: TFont; Angle: Integer): HFont;

var
  CurrentXPColorScheme: TXPColorScheme;

const
  // Office Color Constants under Blue XP Color Scheme
  xpOfficeBlue_Selection_FrameColor: TColor                     = $00800000;
  xpOfficeBlue_Selection_ColorStart: TColor                     = $00C2EEFF;
  xpOfficeBlue_Selection_ColorStop: TColor                      = $00A0D9FF;
  xpOfficeBlue_Panel_ColorStart: TColor                         = $00FFEFE3;
  xpOfficeBlue_Panel_ColorStop: TColor                          = $00EABB99;
  xpOfficeBlue_Panel_FrameColor: TColor                         = $00BF7F57;
  xpOfficeBlue_GroupBar_ColorStart: TColor                      = $00E7A27B;
  xpOfficeBlue_GroupBar_ColorStop: TColor                       = $00D67563;

  xpOfficeBlue_CategoryGroup_CaptionBackColor                   = clWhite;
  xpOfficeBlue_CategoryGroup_CaptionBackColorStart              = clWhite;
  xpOfficeBlue_CategoryGroup_CaptionBackColorStop               = $00F7D3C6;
  xpOfficeBlue_CategoryGroup_CaptionFontColor                   = $00A53C00;
  xpOfficeBlue_CategoryGroup_CaptionFontHotColor                = $00FF8E42;
  xpOfficeBlue_CategoryGroup_CaptionButtonColor                 = $00FCFCFC;
  xpOfficeBlue_CategoryGroup_CaptionButtonBorderColor           = $00D9BAB3;
  xpOfficeBlue_CategoryGroup_CaptionDividerColor                = $00C56A31;
  xpOfficeBlue_CategoryGroup_GroupColor                         = $00F7DFD6;
  xpOfficeBlue_CategoryGroup_GroupBorderColor                   = clWhite;
  xpOfficeBlue_CategoryGroup_ItemFontColor                      = $00C65D21;
  xpOfficeBlue_CategoryGroup_ItemFontHotColor                   = $00FF8E42;

  xpOfficeBlue_CategoryGroupSpecial_CaptionBackColor            = $00C56A31;
  xpOfficeBlue_CategoryGroupSpecial_CaptionBackColorStart       = $00BE500F;
  xpOfficeBlue_CategoryGroupSpecial_CaptionBackColorStop        = $00CE5D29;
  xpOfficeBlue_CategoryGroupSpecial_CaptionFontColor            = clWhite;
  xpOfficeBlue_CategoryGroupSpecial_CaptionFontHotColor         = $00F7DFD6;
  xpOfficeBlue_CategoryGroupSpecial_CaptionButtonColor          = $00C35E2F;
  xpOfficeBlue_CategoryGroupSpecial_CaptionButtonBorderColor    = $00DE9A6A;
  xpOfficeBlue_CategoryGroupSpecial_CaptionDividerColor         = $00C56A31;
  xpOfficeBlue_CategoryGroupSpecial_GroupColor                  = $00FFF3EF;
  xpOfficeBlue_CategoryGroupSpecial_GroupBorderColor            = clWhite;

  // Office Color Constants under Green XP Color Scheme
  xpOfficeGreen_Selection_FrameColor: TColor                    = $00385D3F;
  xpOfficeGreen_Selection_ColorStart: TColor                    = $00C2EEFF;
  xpOfficeGreen_Selection_ColorStop: TColor                     = $00A0D9FF;
  xpOfficeGreen_Panel_ColorStart: TColor                        = $00EDFFFF;
  xpOfficeGreen_Panel_ColorStop: TColor                         = $0092C7B8;
  xpOfficeGreen_Panel_FrameColor: TColor                        = $0077A17F;
  xpOfficeGreen_GroupBar_ColorStart: TColor                     = $00ADD9CC;
  xpOfficeGreen_GroupBar_ColorStop: TColor                      = $0084BDA5;

  xpOfficeGreen_CategoryGroup_CaptionBackColor                  = $00B8E7E0;
  xpOfficeGreen_CategoryGroup_CaptionBackColorStart             = $00D5F3F1;
  xpOfficeGreen_CategoryGroup_CaptionBackColorStop              = $00B8E7E0;
  xpOfficeGreen_CategoryGroup_CaptionFontColor                  = $001C674B;
  xpOfficeGreen_CategoryGroup_CaptionFontHotColor               = $001D9272;
  xpOfficeGreen_CategoryGroup_CaptionButtonColor                = $00FCFCFC;
  xpOfficeGreen_CategoryGroup_CaptionButtonBorderColor          = $00BED5CA;
  xpOfficeGreen_CategoryGroup_CaptionDividerColor               = $0070A093;
  xpOfficeGreen_CategoryGroup_GroupColor                        = $00ECF6F6;
  xpOfficeGreen_CategoryGroup_GroupBorderColor                  = clWhite;
  xpOfficeGreen_CategoryGroup_ItemFontColor                     = $002D6656;
  xpOfficeGreen_CategoryGroup_ItemFontHotColor                  = $001D9272;

  xpOfficeGreen_CategoryGroupSpecial_CaptionBackColor           = $0070A093;
  xpOfficeGreen_CategoryGroupSpecial_CaptionBackColorStart      = $004E9682;
  xpOfficeGreen_CategoryGroupSpecial_CaptionBackColorStop       = $0067A896;
  xpOfficeGreen_CategoryGroupSpecial_CaptionFontColor           = clWhite;
  xpOfficeGreen_CategoryGroupSpecial_CaptionFontHotColor        = $00A9D6C8;
  xpOfficeGreen_CategoryGroupSpecial_CaptionButtonColor         = $004FA382;
  xpOfficeGreen_CategoryGroupSpecial_CaptionButtonBorderColor   = $0081B7A9;
  xpOfficeGreen_CategoryGroupSpecial_CaptionDividerColor        = $0070A093;
  xpOfficeGreen_CategoryGroupSpecial_GroupColor                 = $00ECF6F6;
  xpOfficeGreen_CategoryGroupSpecial_GroupBorderColor           = clWhite;

  // Office Color Constants under Silver XP Color Scheme
  xpOfficeSilver_Selection_FrameColor: TColor                   = $006F4B4B;
  xpOfficeSilver_Selection_ColorStart: TColor                   = $00C2EEFF;
  xpOfficeSilver_Selection_ColorStop: TColor                    = $00A0D9FF;
  xpOfficeSilver_Panel_ColorStart: TColor                       = $00FFF9F9;
  xpOfficeSilver_Panel_ColorStop: TColor                        = $00D0BCBD;
  xpOfficeSilver_Panel_FrameColor: TColor                       = $00B19F9F;
  xpOfficeSilver_GroupBar_ColorStart: TColor                    = $00D4C8C4;
  xpOfficeSilver_GroupBar_ColorStop: TColor                     = $00C8B3B1;

  xpOfficeSilver_CategoryGroup_CaptionBackColor                 = $00E0D7D6;
  xpOfficeSilver_CategoryGroup_CaptionBackColorStart            = $00FCFBFB;
  xpOfficeSilver_CategoryGroup_CaptionBackColorStop             = $00E0D7D6;
  xpOfficeSilver_CategoryGroup_CaptionFontColor                 = $003D3D3F;
  xpOfficeSilver_CategoryGroup_CaptionFontHotColor              = $007C7C7E;
  xpOfficeSilver_CategoryGroup_CaptionButtonColor               = $00FCFCFC;
  xpOfficeSilver_CategoryGroup_CaptionButtonBorderColor         = $00D1C5C3;
  xpOfficeSilver_CategoryGroup_CaptionDividerColor              = $00BFB4B2;
  xpOfficeSilver_CategoryGroup_GroupColor                       = $00F5F1F0;
  xpOfficeSilver_CategoryGroup_GroupBorderColor                 = clWhite;
  xpOfficeSilver_CategoryGroup_ItemFontColor                    = $003D3D3F;
  xpOfficeSilver_CategoryGroup_ItemFontHotColor                 = $007C7C7E;

  xpOfficeSilver_CategoryGroupSpecial_CaptionBackColor          = $00AB9594;
  xpOfficeSilver_CategoryGroupSpecial_CaptionBackColorStart     = $00A58D8C;
  xpOfficeSilver_CategoryGroupSpecial_CaptionBackColorStop      = $00C7B6B4;
  xpOfficeSilver_CategoryGroupSpecial_CaptionFontColor          = clWhite;
  xpOfficeSilver_CategoryGroupSpecial_CaptionFontHotColor       = $00E0D7D6;
  xpOfficeSilver_CategoryGroupSpecial_CaptionButtonColor        = $0096746E;
  xpOfficeSilver_CategoryGroupSpecial_CaptionButtonBorderColor  = $00DEC7C1;
  xpOfficeSilver_CategoryGroupSpecial_CaptionDividerColor       = $00BFB4B2;
  xpOfficeSilver_CategoryGroupSpecial_GroupColor                = $00F5F1F0;
  xpOfficeSilver_CategoryGroupSpecial_GroupBorderColor          = clWhite;


implementation

uses
  System.Math,
  System.TypInfo,
  System.Win.Registry,
  System.SysUtils,
  Vcl.GraphUtil;

function UsingSystemStyle: Boolean;
begin
  Result := StyleServices.IsSystemStyle;
end;

function ActiveStyleSystemColor(C: TColor): TColor;
begin
  Result := C;
  if not UsingSystemStyle then
    Result := StyleServices.GetSystemColor(C);
end;

function ActiveStyleColor(SC: TStyleColor): TColor;
begin
  Result := clNone;
  if not UsingSystemStyle then
    Result := StyleServices.GetStyleColor(SC);
end;

function ActiveStyleFontColor(SF: TStyleFont): TColor;
begin
  Result := clNone;
  if not UsingSystemStyle then
    Result := StyleServices.GetStyleFontColor(SF);
end;

procedure ColorToHSL(C: TColor; var H, S, L: Byte);
var
  Dif, CCmax, CCmin, RC, GC, BC, TempH, TempS, TempL: Double;
begin
  { Convert RGB color to Hue, Saturation and Luminance }
  { Convert Color to RGB color value. This is necessary if Color specifies
    a system color such as clHighlight }
  C := ColorToRGB(C);

  { Determine a percent (as a decimal) for each colorant }
  RC := GetRValue(C) / 255;
  GC := GetGValue(C) / 255;
  BC := GetBValue(C) / 255;

  if RC > GC then
    CCmax := RC
  else
    CCmax := GC;
  if BC > CCmax then
    CCmax := BC;

  if RC < GC then
    CCmin := RC
  else
    CCmin := GC;

  if BC < CCmin then
    CCmin := BC;

  { Calculate Luminance }
  TempL := (CCmax + CCmin) / 2.0;

  if CCmax = CCmin then
  begin
    TempS := 0;
    TempH := 0;
  end
  else
  begin
    Dif := CCmax - CCmin;

    { Calculate Saturation }
    if TempL < 0.5 then
      TempS := Dif / (CCmax + CCmin)
    else
      TempS := Dif / (2.0 - CCmax - CCmin);

    { Calculate Hue }
    if RC = CCmax then
      TempH := (GC - BC) / Dif
    else if GC = CCmax then
      TempH := 2.0 + (BC - RC) / Dif
    else
      TempH := 4.0 + (RC - GC) / Dif;

    TempH := TempH / 6;
    if TempH < 0 then
      TempH := TempH + 1;
  end;

  H := Round(240 * TempH);
  S := Round(240 * TempS);
  L := Round(240 * TempL);
end;

function ColorHue(C: TColor): Byte;
var
  S, L: Byte;
begin
  ColorToHSL(C, Result, S, L);
end;

function ColorSaturation(C: TColor): Byte;
var
  H, L: Byte;
begin
  ColorToHSL(C, H, Result, L);
end;

function ColorLuminance(C: TColor): Byte;
var
  H, S: Byte;
begin
  ColorToHSL(C, H, S, Result);
end;

function HSLtoColor(H, S, L: Byte): TColor;
var
  HN, SN, LN, RD, GD, BD, V, M, SV, Fract, VSF, Mid1, Mid2: Double;
  R, G, B: Byte;
  Sextant: Integer;
begin
  { Hue, Saturation, and Luminance must be normalized to 0..1 }

  HN := H / 239;
  SN := S / 240;
  LN := L / 240;

  if LN < 0.5 then
    V := LN * (1.0 + SN)
  else
    V := LN + SN - LN * SN;
  if V <= 0 then
  begin
    RD := 0.0;
    GD := 0.0;
    BD := 0.0;
  end
  else
  begin
    M := LN + LN - V;
    SV := (V - M) / V;
    HN := HN * 6.0;
    Sextant := Trunc(HN);
    Fract := HN - Sextant;
    VSF := V * SV * Fract;
    Mid1 := M + VSF;
    Mid2 := V - VSF;

    case Sextant of
      0:
        begin
          RD := V;
          GD := Mid1;
          BD := M;
        end;

      1:
        begin
          RD := Mid2;
          GD := V;
          BD := M;
        end;

      2:
        begin
          RD := M;
          GD := V;
          BD := Mid1;
        end;

      3:
        begin
          RD := M;
          GD := Mid2;
          BD := V;
        end;

      4:
        begin
          RD := Mid1;
          GD := M;
          BD := V;
        end;

      5:
        begin
          RD := V;
          GD := M;
          BD := Mid2;
        end;

    else
      begin
        RD := V;
        GD := Mid1;
        BD := M;
      end;
    end;
  end;

  if RD > 1.0 then
    RD := 1.0;
  if GD > 1.0 then
    GD := 1.0;
  if BD > 1.0 then
    BD := 1.0;
  R := Round(RD * 255);
  G := Round(GD * 255);
  B := Round(BD * 255);
  Result := RGB(R, G, B);
end;

function DarkerColor(C: TColor; Adjustment: Byte): TColor;
var
  H, S, L: Byte;
begin
  ColorToHSL(C, H, S, L);
  Result := HSLtoColor(H, S, Max(L - Adjustment, 0));
end;

function LighterColor(C: TColor; Adjustment: Byte): TColor;
var
  H, S, L: Byte;
begin
  ColorToHSL(C, H, S, L);
  Result := HSLtoColor(H, S, Min(L + Adjustment, 255));
end;

function AdjustColor(C: TColor; Adjustment: Integer): TColor;
begin
  Result := C;
  if Adjustment < 0 then
    Result := DarkerColor(C, -Adjustment)
  else if Adjustment > 0 then
    Result := LighterColor(C, Adjustment);
end;

function BlendColors(ForeColor, BackColor: TColor; Alpha: Byte): TColor;
var
  ForeRed, ForeGreen, ForeBlue: Byte;
  BackRed, BackGreen, BackBlue: Byte;
  BlendRed, BlendGreen, BlendBlue: Byte;
  AlphaValue: Single;
begin
  AlphaValue := Alpha / 255;

  ForeColor := ColorToRGB(ForeColor);
  ForeRed := GetRValue(ForeColor);
  ForeGreen := GetGValue(ForeColor);
  ForeBlue := GetBValue(ForeColor);

  BackColor := ColorToRGB(BackColor);
  BackRed := GetRValue(BackColor);
  BackGreen := GetGValue(BackColor);
  BackBlue := GetBValue(BackColor);

  BlendRed := Round(AlphaValue * ForeRed + (1 - AlphaValue) * BackRed);
  BlendGreen := Round(AlphaValue * ForeGreen + (1 - AlphaValue) * BackGreen);
  BlendBlue := Round(AlphaValue * ForeBlue + (1 - AlphaValue) * BackBlue);

  Result := RGB(BlendRed, BlendGreen, BlendBlue);
end;

function XorColors(ForeColor, BackColor: TColor): TColor;
var
  R, G, B: Byte;
  FC, BC: TColor;
begin
  FC := ColorToRGB(ForeColor);
  BC := ColorToRGB(BackColor);
  R := GetRValue(FC) xor GetRValue(BC);
  G := GetGValue(FC) xor GetGValue(BC);
  B := GetBValue(FC) xor GetBValue(BC);
  Result := RGB(R, G, B);
end;

function DrawString(Canvas: TCanvas; const S: string; var Bounds: TRect; Flags: UINT): Integer;
begin
  Result := DrawText(Canvas.Handle, PChar(S), -1, Bounds, Flags);
end;

procedure DrawStringCentered(Canvas: TCanvas; const S: string; Bounds: TRect);
begin
  DrawText(Canvas.Handle, PChar(S), -1, Bounds, dt_Center or dt_VCenter or dt_SingleLine);
end;

function DrawSides(Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Sides: TSides): TRect;
begin
  if ULColor <> clNone then
  begin
    Canvas.Pen.Color := ULColor;
    if sdLeft in Sides then
    begin
      Canvas.MoveTo(Bounds.Left, Bounds.Top);
      Canvas.LineTo(Bounds.Left, Bounds.Bottom);
    end;

    if sdTop in Sides then
    begin
      Canvas.MoveTo(Bounds.Left, Bounds.Top);
      Canvas.LineTo(Bounds.Right, Bounds.Top);
    end;
  end;

  if LRColor <> clNone then
  begin
    Canvas.Pen.Color := LRColor;
    if sdRight in Sides then
    begin
      Canvas.MoveTo(Bounds.Right - 1, Bounds.Top);
      Canvas.LineTo(Bounds.Right - 1, Bounds.Bottom);
    end;

    if sdBottom in Sides then
    begin
      Canvas.MoveTo(Bounds.Left, Bounds.Bottom - 1);
      Canvas.LineTo(Bounds.Right, Bounds.Bottom - 1);
    end;
  end;

  if sdLeft in Sides then
    Inc(Bounds.Left);
  if sdTop in Sides then
    Inc(Bounds.Top);
  if sdRight in Sides then
    Dec(Bounds.Right);
  if sdBottom in Sides then
    Dec(Bounds.Bottom);

  Result := Bounds;
end;

function DrawBevel(Canvas: TCanvas; Bounds: TRect; ULColor, LRColor: TColor; Width: Integer; Sides: TSides): TRect;
var
  I: Integer;
begin
  Canvas.Pen.Width := 1;
  for I := 1 to Width do { Loop through width of bevel }
  begin
    Bounds := DrawSides(Canvas, Bounds, ULColor, LRColor, Sides);
  end;
  Result := Bounds;
end;

function DrawRoundedFlatBorder(Canvas: TCanvas; Bounds: TRect; Color: TColor; Sides: TSides): TRect;
var
  X1, X2, Y1, Y2: Integer;
begin
  Canvas.Pen.Color := Color;

  if sdLeft in Sides then
  begin
    if sdTop in Sides then
      Y1 := 2
    else
      Y1 := 0;
    if sdBottom in Sides then
      Y2 := 2
    else
      Y2 := 0;
    Canvas.MoveTo(Bounds.Left, Bounds.Top + Y1);
    Canvas.LineTo(Bounds.Left, Bounds.Bottom - Y2);
  end;

  if sdTop in Sides then
  begin
    if sdLeft in Sides then
      X1 := 2
    else
      X1 := 0;
    if sdRight in Sides then
      X2 := 2
    else
      X2 := 0;
    Canvas.MoveTo(Bounds.Left + X1, Bounds.Top);
    Canvas.LineTo(Bounds.Right - X2, Bounds.Top);
  end;

  if sdRight in Sides then
  begin
    if sdTop in Sides then
      Y1 := 2
    else
      Y1 := 0;
    if sdBottom in Sides then
      Y2 := 2
    else
      Y2 := 0;
    Canvas.MoveTo(Bounds.Right - 1, Bounds.Top + Y1);
    Canvas.LineTo(Bounds.Right - 1, Bounds.Bottom - Y2);
  end;

  if sdBottom in Sides then
  begin
    if sdLeft in Sides then
      X1 := 2
    else
      X1 := 0;
    if sdRight in Sides then
      X2 := 2
    else
      X2 := 0;
    Canvas.MoveTo(Bounds.Left + X1, Bounds.Bottom - 1);
    Canvas.LineTo(Bounds.Right - X2, Bounds.Bottom - 1);
  end;

  if (sdLeft in Sides) and (sdTop in Sides) then
    Canvas.Pixels[Bounds.Left + 1, Bounds.Top + 1] := Color;
  if (sdTop in Sides) and (sdRight in Sides) then
    Canvas.Pixels[Bounds.Right - 2, Bounds.Top + 1] := Color;
  if (sdRight in Sides) and (sdBottom in Sides) then
    Canvas.Pixels[Bounds.Right - 2, Bounds.Bottom - 2] := Color;
  if (sdLeft in Sides) and (sdBottom in Sides) then
    Canvas.Pixels[Bounds.Left + 1, Bounds.Bottom - 2] := Color;

  if sdLeft in Sides then
    Inc(Bounds.Left, 2);
  if sdTop in Sides then
    Inc(Bounds.Top, 2);
  if sdRight in Sides then
    Dec(Bounds.Right, 2);
  if sdBottom in Sides then
    Dec(Bounds.Bottom, 2);

  Result := Bounds;
end;

function DrawCtl3DBorderSides(Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides): TRect;
const
  Colors: array [1 .. 4, Boolean] of TColor = ((cl3DLight, clBtnShadow), (cl3DDkShadow, clBtnHighlight), (clBtnHighlight, cl3DDkShadow),
    (clBtnShadow, cl3DLight));
begin
  Bounds := DrawBevel(Canvas, Bounds, ActiveStyleSystemColor(Colors[1, Lowered]), ActiveStyleSystemColor(Colors[2, Lowered]), 1, Sides);
  Result := DrawBevel(Canvas, Bounds, ActiveStyleSystemColor(Colors[3, Lowered]), ActiveStyleSystemColor(Colors[4, Lowered]), 1, Sides);
end;

function DrawButtonBorderSides(Canvas: TCanvas; Bounds: TRect; Lowered: Boolean; Sides: TSides): TRect;
const
  Colors: array [1 .. 4, Boolean] of TColor = ((clBtnHighlight, clBtnText), (cl3DDkShadow, clBtnText), (cl3DLight, clBtnShadow), (clBtnShadow, clBtnShadow));
  StyleColors: array [1 .. 4, Boolean] of TColor = ((clBtnHighlight, cl3DDkShadow), (cl3DDkShadow, cl3DDkShadow), (cl3DLight, clBtnShadow),
    (clBtnShadow, clBtnShadow));
begin
  if UsingSystemStyle then
  begin
    Bounds := DrawBevel(Canvas, Bounds, Colors[1, Lowered], Colors[2, Lowered], 1, Sides);
    Result := DrawBevel(Canvas, Bounds, Colors[3, Lowered], Colors[4, Lowered], 1, Sides);
  end
  else // VCL Styles
  begin
    Bounds := DrawBevel(Canvas, Bounds, ActiveStyleSystemColor(StyleColors[1, Lowered]), ActiveStyleSystemColor(StyleColors[2, Lowered]), 1, Sides);

    Result := DrawBevel(Canvas, Bounds, ActiveStyleSystemColor(StyleColors[3, Lowered]), ActiveStyleSystemColor(StyleColors[4, Lowered]), 1, Sides);
  end;
end;

function DrawBorderSides(Canvas: TCanvas; Bounds: TRect; Style: TFrameStyle; Sides: TSides): TRect;
var
  ULColor, LRColor: TColor;
  R: TRect;
begin
  ULColor := ActiveStyleSystemColor(ULFrameColor[Style]);
  LRColor := ActiveStyleSystemColor(LRFrameColor[Style]);

  { Draw the Frame }
  if Style <> fsNone then
  begin
    if Style in [fsFlat, fsStatus, fsPopup] then
      Bounds := DrawSides(Canvas, Bounds, ULColor, LRColor, Sides)
    else if Style in [fsFlatBold] then
      Bounds := DrawBevel(Canvas, Bounds, ULColor, LRColor, 2, Sides)
    else if Style in [fsLowered, fsRaised] then
      Bounds := DrawCtl3DBorderSides(Canvas, Bounds, Style = fsLowered, Sides)
    else if Style in [fsButtonDown, fsButtonUp] then
      Bounds := DrawButtonBorderSides(Canvas, Bounds, Style = fsButtonDown, Sides)
    else
    begin
      { Style must be fsGroove or fsBump }
      R := Bounds;
      { Fill in the gaps created by offsetting the rectangle }
      { Upper Right Gap }
      if sdRight in Sides then
        Canvas.Pixels[R.Right - 1, R.Top] := LRColor;
      if (sdTop in Sides) and not(sdRight in Sides) then
        Canvas.Pixels[R.Right - 1, R.Top] := ULColor;

      { Lower Left Gap }
      if sdBottom in Sides then
        Canvas.Pixels[R.Left, R.Bottom - 1] := LRColor;
      if (sdLeft in Sides) and not(sdBottom in Sides) then
        Canvas.Pixels[R.Left, R.Bottom - 1] := ULColor;

      { Upper Left Gaps }
      if (sdTop in Sides) and not(sdLeft in Sides) then
        Canvas.Pixels[R.Left, R.Top + 1] := LRColor;
      if not(sdTop in Sides) and (sdLeft in Sides) then
        Canvas.Pixels[R.Left + 1, R.Top] := LRColor;

      { Lower Right Gaps }
      if (sdBottom in Sides) and not(sdRight in Sides) then
        Canvas.Pixels[R.Right - 1, R.Bottom - 2] := ULColor;
      if not(sdBottom in Sides) and (sdRight in Sides) then
        Canvas.Pixels[R.Right - 2, R.Bottom - 1] := ULColor;

      Inc(R.Left);
      Inc(R.Top);
      DrawSides(Canvas, R, LRColor, LRColor, Sides);
      OffsetRect(R, -1, -1);
      DrawSides(Canvas, R, ULColor, ULColor, Sides);
      if sdLeft in Sides then
        Inc(Bounds.Left, 2);
      if sdTop in Sides then
        Inc(Bounds.Top, 2);
      if sdRight in Sides then
        Dec(Bounds.Right, 2);
      if sdBottom in Sides then
        Dec(Bounds.Bottom, 2);
    end;
  end;
  Result := Bounds;
end;

procedure GetGradientPanelColors(ColorStyle: TGradientColorStyle; var StartColor, StopColor: TColor);
begin
  if (ColorStyle = gcsMSOffice) and StyleServices.Enabled then
  begin
    // Determine the current XP color scheme and set colors appropriately
    case CurrentXPColorScheme of
      xpcsBlue:
        begin
          StartColor := xpOfficeBlue_Panel_ColorStart;
          StopColor := xpOfficeBlue_Panel_ColorStop;
        end;

      xpcsGreen:
        begin
          StartColor := xpOfficeGreen_Panel_ColorStart;
          StopColor := xpOfficeGreen_Panel_ColorStop;
        end;

      xpcsSilver:
        begin
          StartColor := xpOfficeSilver_Panel_ColorStart;
          StopColor := xpOfficeSilver_Panel_ColorStop;
        end;
    end;
  end
  else
  begin
    StartColor := ActiveStyleSystemColor(clWindow);
    StopColor := DarkerColor(ActiveStyleSystemColor(clBtnFace), 10);
  end;
end;

function GetGradientPanelFrameColor(ColorStyle: TGradientColorStyle): TColor;
begin
  if (ColorStyle = gcsMSOffice) and StyleServices.Enabled then
  begin
    // Determine the current XP color scheme and set colors appropriately

    case CurrentXPColorScheme of
      xpcsBlue:
        Result := xpOfficeBlue_Panel_FrameColor;

      xpcsGreen:
        Result := xpOfficeGreen_Panel_FrameColor;

      xpcsSilver:
        Result := xpOfficeSilver_Panel_FrameColor;

    else
      Result := clBtnShadow;
    end;
  end
  else
  begin
    Result := LighterColor(ActiveStyleSystemColor(clBtnShadow), 30);
  end;
end;

function DrawInnerOuterBorders(Canvas: TCanvas; Bounds: TRect; BorderOuter, BorderInner: TFrameStyle; BorderWidth: Integer; BorderSides: TSides;
  BevelWidth: Integer; BorderColor, BorderHighlight, BorderShadow: TColor; FlatColor: TColor; FlatColorAdjustment: Integer; Color, ParentColor: TColor;
  Transparent: Boolean; SoftInnerFlatBorder: Boolean = False): TRect;
var
  TempR: TRect;
  C: TColor;
begin
  Result := Bounds;

  { Outer Border }
  if BorderOuter in [fsFlat, fsFlatBold, fsFlatRounded] then
  begin
    C := AdjustColor(FlatColor, FlatColorAdjustment);
    if BorderOuter = fsFlat then
      Result := DrawBevel(Canvas, Result, C, C, 1, BorderSides)
    else if BorderOuter = fsFlatBold then
      Result := DrawBevel(Canvas, Result, C, C, 2, BorderSides)
    else
    begin
      if not Transparent then
      begin
        TempR := DrawBevel(Canvas, Result, ParentColor, ParentColor, 1, BorderSides);
        if (BorderWidth > 0) or (BorderInner <> fsNone) then
          DrawBevel(Canvas, TempR, BorderColor, BorderColor, 1, BorderSides)
        else
          DrawBevel(Canvas, TempR, Color, Color, 1, BorderSides);
      end
      else // Transparent
      begin
        if (BorderWidth > 0) or (BorderInner <> fsNone) then
        begin
          TempR := Result;
          InflateRect(TempR, -1, -1);
          DrawBevel(Canvas, TempR, BorderColor, BorderColor, 1, BorderSides);
        end;
      end;
      Result := DrawRoundedFlatBorder(Canvas, Result, C, BorderSides);
    end;
  end
  else if BorderOuter = fsPopup then
    Result := DrawBevel(Canvas, Result, BorderHighlight, BorderShadow, BevelWidth, BorderSides)
  else if BorderOuter = fsStatus then
    Result := DrawBevel(Canvas, Result, BorderShadow, BorderHighlight, BevelWidth, BorderSides)
  else
    Result := DrawBorderSides(Canvas, Result, BorderOuter, BorderSides);

  { Space between borders }
  if BorderWidth > 0 then
    Result := DrawBevel(Canvas, Result, BorderColor, BorderColor, BorderWidth, BorderSides);

  { Inner Border }
  if BorderInner in [fsFlat, fsFlatBold, fsFlatRounded] then
  begin
    C := AdjustColor(FlatColor, FlatColorAdjustment);
    if BorderInner = fsFlat then
    begin
      if not SoftInnerFlatBorder then
        Result := DrawBevel(Canvas, Result, C, C, 1, BorderSides)
      else
      begin
        Canvas.Pen.Color := C;
        // Left side
        Canvas.MoveTo(Result.Left, Result.Top + 1);
        Canvas.LineTo(Result.Left, Result.Bottom - 1);
        // Top side
        Canvas.MoveTo(Result.Left + 1, Result.Top);
        Canvas.LineTo(Result.Right - 1, Result.Top);
        // Right side
        Canvas.MoveTo(Result.Right - 1, Result.Top + 1);
        Canvas.LineTo(Result.Right - 1, Result.Bottom - 1);
        // Bottom side
        Canvas.MoveTo(Result.Left + 1, Result.Bottom - 1);
        Canvas.LineTo(Result.Right - 1, Result.Bottom - 1);

        InflateRect(Result, -1, -1);
      end;
    end
    else if BorderInner = fsFlatBold then
      Result := DrawBevel(Canvas, Result, C, C, 2, BorderSides)
    else
    begin
      if not Transparent then
      begin
        TempR := DrawBevel(Canvas, Result, BorderColor, BorderColor, 1, BorderSides);
        DrawBevel(Canvas, TempR, Color, Color, 1, BorderSides);
      end
      else // Transparent
        DrawBevel(Canvas, Result, BorderColor, BorderColor, 1, BorderSides);
      Result := DrawRoundedFlatBorder(Canvas, Result, C, BorderSides);
    end;
  end
  else if BorderInner = fsPopup then
    Result := DrawBevel(Canvas, Result, BorderHighlight, BorderShadow, BevelWidth, BorderSides)
  else if BorderInner = fsStatus then
    Result := DrawBevel(Canvas, Result, BorderShadow, BorderHighlight, BevelWidth, BorderSides)
  else
    Result := DrawBorderSides(Canvas, Result, BorderInner, BorderSides);

end;

{
  FillGrad
  Make a gradient the Width or Height of a Windows Brush
  If AX = -1, build a bottom to top gradient, ColorFinal @ bottom
  If AX > 0, build right-edge to AX to left-edge gradient, ColorFinal @ AX
  If AY = -1, built a right to left gradient, ColorFinal @ right
  If AY > 0, build bottom-edge to AY to top-edge gradient, ColorFinal @ AY
  Either AX or AY must be zero, FillGrad constructs Horizontal OR Vertical
  gradients.
  The Windows brush is used for gradients because it will dither a 64 bit
  brush for 8 bit or 4 bit color systems that approximates a 24 bit Palatte.
}

procedure FillGrad(DC: HDC; AX, AY, L: Integer; ColorStart, ColorStop: TColor; SmoothFactor: TSmoothFactor);
label
  fgLoop;
var
  C, CI, CF, CPrev: TColor;
  BlueInc, GreenInc, RedInc: TColor;
  BlueDWord: TDWordColor;
  GreenDWord: TDWordColor;
  RedDWord: TDWordColor;
  BlueInt: Integer absolute BlueDWord;
  GreenInt: Integer absolute GreenDWord;
  RedInt: Integer absolute RedDWord;
  EndX, EndY, N, X, Y: Integer;
  R: TRect;
  Brush: HBrush;
  BGradX: Boolean;
  Q, Q0: Integer; { Quality (ie speed) }
begin
  X := 0;
  Y := 0;
  EndX := 0;
  EndY := 0;

  if (AX <> 0) then
  begin { Do X grad }
    AY := 0; { Just in case; do EITHER X or Y grad }
    BGradX := True;
    if (AX < 0) then
      X := L
    else
      X := AX + 1;
    EndX := 1;
  end
  else
  begin
    BGradX := False;
    if (AY < 0) then
      Y := L
    else
      Y := AY + 1;
    EndY := 1;
  end;
  CI := ColorStart;
  CF := ColorStop; { Start color is at top, or left; or outside edges }
  Q0 := SmoothFactor;
  if (Q0 > 8) then
    Q0 := 1 + 255 div Q0;
  Dec(Q0);
  if (Q0 < 0) then
    Q0 := 0;

fgLoop:
  if BGradX then
    N := X - EndX
  else
    N := Y - EndY;
  Inc(N);
  RedInt := Integer(GetRValue(CF)) shl 16; { Setup color differences }
  GreenInt := Integer(GetGValue(CF)) shl 16;
  BlueInt := Integer(GetBValue(CF)) shl 16;

  if (N > 0) then
  begin
    RedInc := ((Integer(GetRValue(CI)) shl 16) - RedInt) div N;
    GreenInc := ((Integer(GetGValue(CI)) shl 16) - GreenInt) div N;
    BlueInc := ((Integer(GetBValue(CI)) shl 16) - BlueInt) div N;
  end
  else
  begin
    RedInc := 0;
    GreenInc := 0;
    BlueInc := 0;
  end;
  C := CF;
  if BGradX then
  begin
    { Fill an 8 pixel high row }
    R.Top := 0;
    R.Bottom := 8;
    repeat
      R.Right := X;
      CPrev := C;
      Q := Q0;
      repeat
        Inc(BlueInt, BlueInc);
        Inc(GreenInt, GreenInc);
        Inc(RedInt, RedInc);

{$IFDEF WIN64}
        C := RGB(RedDWord.Color, GreenDWord.Color, BlueDWord.Color);
{$ELSE}
        C := BlueInt;
        asm                          { Lot quicker than RGBColor }
          MOV EAX,C
          MOV AH,GreenDWord.Color
          MOV AL,RedDWord.Color
          MOV C,EAX
        end
        ;
{$ENDIF}
        Dec(X);
        Dec(Q);
      until ((C <> CPrev) and (Q < 0)) or (X < EndX);

      R.Left := X;
      Brush := CreateSolidBrush(CPrev); { Dithered brush for 16|256 clr systems }
      FillRect(DC, R, Brush);
      DeleteObject(Brush);
    until (X < EndX);
  end
  else
  begin
    { Fill an 8 pixel wide column }
    R.Left := 0;
    R.Right := 8;
    repeat
      R.Bottom := Y;
      CPrev := C;
      Q := Q0;
      repeat
        Inc(BlueInt, BlueInc);
        Inc(GreenInt, GreenInc);
        Inc(RedInt, RedInc);

{$IFDEF WIN64}
        C := RGB(RedDWord.Color, GreenDWord.Color, BlueDWord.Color);
{$ELSE}
        C := BlueInt;
        asm
          MOV EAX,C
          MOV AH,GreenDWord.Color
          MOV AL,RedDWord.Color
          MOV C,EAX
        end
        ;
{$ENDIF}
        Dec(Y);
        Dec(Q);
      until ((C <> CPrev) and (Q < 0)) or (Y < EndY);
      R.Top := Y;
      Brush := CreateSolidBrush(CPrev); { Dithered brush for 16|256 clr systems }
      FillRect(DC, R, Brush);
      DeleteObject(Brush);
    until (Y < EndY);
  end;
  CI := ColorStop;
  CF := ColorStart;

  if AX > 0 then
  begin
    { Do other GradX portion of inside-to-edges gradient }
    EndX := AX + 2;
    X := L;
    AX := 0;
    goto fgLoop;
  end;

  if (AY > 0) then
  begin
    { Do other GradY portion }
    EndY := AY + 2;
    Y := L;
    AY := 0;
    goto fgLoop;
  end;
end;

{
  BitFillBlit
  Make copies of the w x h bitmap in aDC located at X0,Y0. Fill the W0 x H0 rectange located at X0,Y0 with the copies.
  Using a binary fill pattern, each succeeding BitBlt copies twice as many pixels.
  BitBlt #1 copies one bitmap in Y direction.
  BitBlt #2 copies two bitmaps X direction.
  BitBlt #3 copies four bitmaps Y direction.
  BitBlt #4 copies eight bitmaps X direction.
  and so on ...
  The last BitBlt in Y or X copies just enough pixels to fill the remaining space. }

procedure BitFillBlit(DC: HDC; X0, Y0, W0, H0, W, H: Integer; ROP: DWord);
var
  HH, WW, XD, YD: Integer;
  YDir: Boolean;
begin
  YDir := H < H0; { True means copY in Y direction }
  while (H < H0) or (W < W0) do
  begin
    HH := H;
    WW := W;
    if YDir then
    begin { Copy to space below }
      XD := X0;
      YD := Y0 + HH;
      Inc(H, HH);
      if (H > H0) then
      begin
        HH := H0 - YD;
        H := H0;
      end;
      YDir := not(W < W0);
    end
    else
    begin { Copy to space at right }
      XD := X0 + WW;
      YD := Y0;
      Inc(W, WW);
      if (W > W0) then
      begin
        WW := W0 - XD;
        W := W0;
      end;
      YDir := (H < H0);
    end;
    BitBlt(DC, XD, YD, WW, HH, DC, X0, Y0, ROP);
  end;
end;

{
  FillGradRect
  ONLY the upper left quadrant is generated.  A call to BitMirrorBlit must be
  made to complete the other three quadrants.
  Square fill if AX0 and AY0 are 0
  Horz rect fill if AX0 > 0 and AY0 = 0
  Vert rect fill if AX0 = 0 and AY0 > 0
  BigSquare fill if AX0 and AY0 both > 0
}
procedure FillGradRect(DC: HDC; AX, AY, AX0, AY0: Integer; ColorStart, ColorStop: TColor; SmoothFactor: TSmoothFactor);
var
  C, CI, CF, CPrev: TColor;

  BlueDWord: TDWordColor;
  GreenDWord: TDWordColor;
  RedDWord: TDWordColor;
  BlueInt: Integer absolute BlueDWord;
  GreenInt: Integer absolute GreenDWord;
  RedInt: Integer absolute RedDWord;
  BlueInc, GreenInc, RedInc: Integer;

  XInc, YInc: Integer;
  XDWord: TDWordWord;
  X: Integer absolute XDWord;
  YDWord: TDWordWord;
  Y: Integer absolute YDWord;
  N: Integer;
  R, H, V: TRect;
  Brush: HBrush;
  Q, Q0: Integer; { Quality (i.e. speed) }
begin
  if (ColorStart = ColorStop) or (AX <= 4) or (AY <= 4) then
  begin
    Brush := CreateSolidBrush(ColorStart);
    R := Rect(0, 0, AX + 1, AY + 1);
    FillRect(DC, R, Brush);
    DeleteObject(Brush);
    Exit;
  end;

  CI := ColorStart;
  CF := ColorStop; { Start color is at top, or left; or outside edges }
  Q0 := SmoothFactor;

  if (Q0 > 8) then
    Q0 := 1 + 256 div Q0;
  Dec(Q0);
  if (Q0 < 0) then
    Q0 := 0;
  AX := (AX - 1) shr 1;
  H.Right := AX + 1;
  V.Left := AX + 1;
  AY := (AY - 1) shr 1;
  V.Bottom := AY + 1;
  H.Top := AY + 1;
  Dec(AX, AX0);
  Dec(AY, AY0);
  N := AX;
  if (AY > N) then
    N := AY;
  Inc(N);

  RedInt := Integer(GetRValue(CF)) shl 16; { Setup color differences }
  GreenInt := Integer(GetGValue(CF)) shl 16;
  BlueInt := Integer(GetBValue(CF)) shl 16;

  RedInc := ((Integer(GetRValue(CI)) shl 16) - RedInt) div N;
  GreenInc := ((Integer(GetGValue(CI)) shl 16) - GreenInt) div N;
  BlueInc := ((Integer(GetBValue(CI)) shl 16) - BlueInt) div N;

  X := AX shl 16;
  Y := AY shl 16;
  XInc := X div N;
  YInc := Y div N;

  C := CF;
  repeat
    H.Bottom := H.Top;
    V.Top := H.Top;
    V.Right := V.Left;
    CPrev := C;
    Q := Q0;
    repeat
      Inc(BlueInt, BlueInc);
      Inc(GreenInt, GreenInc);
      Inc(RedInt, RedInc);
      Dec(X, XInc);
      Dec(Y, YInc);

{$IFDEF WIN64}
      C := RGB(RedDWord.Color, GreenDWord.Color, BlueDWord.Color);
{$ELSE}
      C := BlueInt;
      asm
        MOV EAX,C
        MOV AH,GreenDWord.Color
        MOV AL,RedDWord.Color
        MOV C,EAX
      end
      ;
{$ENDIF}
      Dec(Q);
    until ((C <> CPrev) and (Q < 0)) or ((XDWord.WordPart > $7FFF) and (YDWord.WordPart > $7FFF));

    if (XDWord.WordPart <= $7FFF) or (YDWord.WordPart <= $7FFF) then
    begin
      Brush := CreateSolidBrush(CPrev);
      H.Left := XDWord.WordPart;
      V.Left := XDWord.WordPart;
      H.Top := YDWord.WordPart;

      if H.Top <> H.Bottom then
        FillRect(DC, H, Brush);

      if V.Left <> V.Right then
        FillRect(DC, V, Brush);

      DeleteObject(Brush);
    end;
  until (XDWord.WordPart > $7FFF) and (YDWord.WordPart > $7FFF);

end;

{
  BoxBitMirrorBlit

  Create a copy of the bitmap in the upper left quadrant. First make a copy below the original, mirroring in Y.
  Then copy both images to the right, mirroring in X.  For 256 color palettes, gradient fills copy better if the
  W0 and H0 dimensions are odd. The left edge and bottom edge are NOT copied if W0 and H0 are odd. Try a square box
  gradient in rectangles with odd and even dimensions to see the difference.
}
procedure BoxBitMirrorBlit(DC: HDC; X0, Y0, W0, H0: Integer; ROP: DWord);
var
  AdjW, H, W: Integer;
begin
  W := W0 shr 1;
  H := H0 shr 1;
  if (W mod 2) = 0 then
    AdjW := 0
  else
    AdjW := 1; { Special if W0 an odd # }

  StretchBlt(DC, X0, Y0 + H0 - 1, W + 1, -H, DC, X0, Y0, W, H, ROP);
  StretchBlt(DC, X0 + W0 - 1, Y0, -W - AdjW, H0, DC, X0, Y0, W - AdjW, H0, ROP);
end;

{
  FillGradDiag

  Make a diagonal gradient
  If AW is positive, gradient goes up from lower left to upper right.
  If AW is negative, gradient goes down from upper left to lower right.
}
procedure FillGradDiag(DC: HDC; AW, AH: Integer; ColorStart, ColorStop: TColor; SmoothFactor: TSmoothFactor);
var
  C, CI, CF, CPrev: TColor;
  BlueDWord: TDWordColor;
  GreenDWord: TDWordColor;
  RedDWord: TDWordColor;

  BlueInt: Integer absolute BlueDWord;
  GreenInt: Integer absolute GreenDWord;
  RedInt: Integer absolute RedDWord;
  BlueInc, GreenInc, RedInc: Integer;

  XInc, YInc: Integer;
  XDWord: TDWordWord;
  X: Integer absolute XDWord;
  YDWord: TDWordWord;
  Y: Integer absolute YDWord;
  N: Integer;
  P: array [1 .. 4] of TPoint;
  Brush, BrushOld: HBrush;
  Q, Q0: Integer; { Quality (i.e. speed) }
begin
  if AW > 0 then
  begin
    CF := ColorStart;
    CI := ColorStop;
    X := 0;
  end
  else
  begin
    X := (-AW) shl 16;
    CI := ColorStart;
    CF := ColorStop;
  end;
  Q0 := SmoothFactor;
  if (Q0 > 8) then
    Q0 := 1 + 255 div Q0;
  Dec(Q0);
  if (Q0 < 0) then
    Q0 := 0;
  N := Trunc(Sqrt(Sqr(AW) + Sqr(AH)));

  Inc(N);

  RedInt := Integer(GetRValue(CF)) shl 16; { Setup color differences }
  GreenInt := Integer(GetGValue(CF)) shl 16;
  BlueInt := Integer(GetBValue(CF)) shl 16;

  RedInc := ((Integer(GetRValue(CI)) shl 16) - RedInt) div N;
  GreenInc := ((Integer(GetGValue(CI)) shl 16) - GreenInt) div N;
  BlueInc := ((Integer(GetBValue(CI)) shl 16) - BlueInt) div N;

  { Draw the bottom triangle first (either Lower-Right or Lower-Left) }

  N := N shr 1;
  if AW > 0 then
    XInc := (AW shl 16) div N
  else
    XInc := (-X) div N;
  Y := AH shl 16;
  YInc := Y div N;

  C := CF;
  P[1].X := XDWord.WordPart;
  P[2].X := XDWord.WordPart;
  P[2].Y := AH;
  P[3].X := XDWord.WordPart;
  P[3].Y := AH;
  P[4].Y := AH;

  repeat
    CPrev := C;
    Q := Q0;
    repeat
      Inc(BlueInt, BlueInc);
      Inc(GreenInt, GreenInc);
      Inc(RedInt, RedInc);
      Inc(X, XInc);
      Dec(Y, YInc);

{$IFDEF WIN64}
      C := RGB(RedDWord.Color, GreenDWord.Color, BlueDWord.Color);
{$ELSE}
      C := BlueInt;
      asm
        MOV EAX,C
        MOV AH,GreenDWord.Color
        MOV AL,RedDWord.Color
        MOV C,EAX
      end
      ;
{$ENDIF}
      Dec(Q);
    until ((C <> CPrev) and (Q < 0)) or (YDWord.WordPart > $7FFF);

    if YDWord.WordPart <= $7FFF then
    begin
      P[1].Y := YDWord.WordPart;
      P[4].X := XDWord.WordPart;
      if (P[1].Y < P[2].Y) or (P[4].X <> P[3].X) then
      begin
        Brush := CreateSolidBrush(CPrev);
        BrushOld := SelectObject(DC, Brush);
        Winapi.Windows.Polygon(DC, P, 4);
        SelectObject(DC, BrushOld);
        DeleteObject(Brush);
        P[2].Y := P[1].Y;
        P[3].X := P[4].X;
      end;
    end;
  until (YDWord.WordPart > $7FFF);

  { Fill remaining portion of lower triangle }
  { This is necessary so that upper triangle portion starts and correct spot }
  P[1].Y := 0;
  if AW > 0 then
    P[4].X := AW
  else
    P[4].X := 0;
  if (P[1].Y < P[2].Y) or (P[4].X <> P[3].X) then
  begin
    Brush := CreateSolidBrush(CPrev);
    BrushOld := SelectObject(DC, Brush);
    Winapi.Windows.Polygon(DC, P, 4);
    SelectObject(DC, BrushOld);
    DeleteObject(Brush);
    P[2].Y := P[1].Y;
    P[3].X := P[4].X;
  end;

  { Draw the top triangle next (either the Upper-Left or Upper-Right) }

  if (AW > 0) then
    X := 0
  else
    X := (-AW) shl 16;
  Y := AH shl 16;

  repeat
    CPrev := C;
    Q := Q0;
    repeat
      Inc(BlueInt, BlueInc);
      Inc(GreenInt, GreenInc);
      Inc(RedInt, RedInc);
      Inc(X, XInc);
      Dec(Y, YInc);

{$IFDEF WIN64}
      C := RGB(RedDWord.Color, GreenDWord.Color, BlueDWord.Color);
{$ELSE}
      C := BlueInt;
      asm
        MOV EAX,C
        MOV AH,GreenDWord.Color
        MOV AL,RedDWord.Color
        MOV C,EAX
      end
      ;
{$ENDIF}
      Dec(Q);
    until ((C <> CPrev) and (Q < 0)) or (YDWord.WordPart > $7FFF);

    if YDWord.WordPart <= $7FFF then
    begin
      P[1].X := XDWord.WordPart;
      P[4].Y := YDWord.WordPart;
      if (P[1].X <> P[2].X) or (P[4].Y < P[3].Y) then
      begin
        Brush := CreateSolidBrush(CPrev);
        BrushOld := SelectObject(DC, Brush);
        Winapi.Windows.Polygon(DC, P, 4);
        SelectObject(DC, BrushOld);
        DeleteObject(Brush);
        P[2].X := P[1].X;
        P[3].Y := P[4].Y;
      end;
    end;
  until (YDWord.WordPart > $7FFF);

  // Fill in remaining part of upper triangle
  P[1].X := XDWord.WordPart;
  if AW > 0 then
    P[4].Y := AW
  else
    P[4].Y := 0;
  if (P[1].X <> P[2].X) or (P[4].Y < P[3].Y) then
  begin
    Brush := CreateSolidBrush(CPrev);
    BrushOld := SelectObject(DC, Brush);
    Winapi.Windows.Polygon(DC, P, 4);
    SelectObject(DC, BrushOld);
    DeleteObject(Brush);
    P[2].X := P[1].X;
    P[3].Y := P[4].Y;
  end;

end;

procedure PaintGradientEx(Canvas: TCanvas; Bounds: TRect; GradDir: TGradientDirection; ColorStart, ColorStop: TColor; SmoothFactor: TSmoothFactor = 1);
var
  FBitmap: TBitmap;
  Width, Height: Integer;
begin
  ColorStart := ColorToRGB(ColorStart);
  ColorStop := ColorToRGB(ColorStop);

  FBitmap := TBitmap.Create;
  try
    Width := Abs(Bounds.Right - Bounds.Left);
    Height := Abs(Bounds.Bottom - Bounds.Top);
    if (Width = 0) or (Height = 0) then
      Exit;

    FBitmap.Width := Width;
    FBitmap.Height := Height;

    FBitmap.Canvas.Pen.Width := 1;
    FBitmap.Canvas.Pen.Style := psClear;
    FBitmap.Canvas.Pen.Mode := pmCopy;
    FBitmap.Canvas.Brush.Style := bsSolid;

    case GradDir of
      gdHorizontalEnd:
        begin
          FillGrad(FBitmap.Canvas.Handle, 0, -1, Height, ColorStart, ColorStop, SmoothFactor);
          BitFillBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, 8, Height, SRCCOPY);
        end;

      gdHorizontalCenter:
        begin
          FillGrad(FBitmap.Canvas.Handle, 0, Height div 2, Height, ColorStart, ColorStop, SmoothFactor);
          BitFillBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, 8, Height, SRCCOPY);
        end;

      gdHorizontalBox:
        begin
          FBitmap.Canvas.Brush.Color := ColorStart;
          FBitmap.Canvas.FillRect(Rect(0, 0, Width, Height));
          FillGradRect(FBitmap.Canvas.Handle, Width, Height, Width shr 2, 0, ColorStart, ColorStop, SmoothFactor);
          BoxBitMirrorBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, SRCCOPY);
        end;

      gdVerticalEnd:
        begin
          FillGrad(FBitmap.Canvas.Handle, -1, 0, Width, ColorStart, ColorStop, SmoothFactor);
          BitFillBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, Width, 8, SRCCOPY);
        end;

      gdVerticalCenter:
        begin
          FillGrad(FBitmap.Canvas.Handle, Width div 2, 0, Width, ColorStart, ColorStop, SmoothFactor);
          BitFillBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, Width, 8, SRCCOPY);
        end;

      gdVerticalBox:
        begin
          FillGradRect(FBitmap.Canvas.Handle, Width, Height, 0, Height shr 2, ColorStart, ColorStop, SmoothFactor);
          BoxBitMirrorBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, SRCCOPY);
        end;

      gdSquareBox:
        begin
          FBitmap.Canvas.Brush.Color := ColorStart;
          FBitmap.Canvas.FillRect(Rect(0, 0, Width, Height));
          FillGradRect(FBitmap.Canvas.Handle, Width, Height, 0, 0, ColorStart, ColorStop, SmoothFactor);
          BoxBitMirrorBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, SRCCOPY);
        end;

      gdBigSquareBox:
        begin
          FillGradRect(FBitmap.Canvas.Handle, Width, Height, Width shr 2, Height shr 2, ColorStart, ColorStop, SmoothFactor);
          BoxBitMirrorBlit(FBitmap.Canvas.Handle, 0, 0, Width, Height, SRCCOPY);
        end;

      gdDiagonalUp:
        begin
          if ColorStart = ColorStop then
          begin
            FBitmap.Canvas.Brush.Color := ColorStart;
            FBitmap.Canvas.Rectangle(0, 0, Width, Height);
          end
          else
            FillGradDiag(FBitmap.Canvas.Handle, Width, Height, ColorStart, ColorStop, SmoothFactor);
        end;

      gdDiagonalDown:
        begin
          if ColorStart = ColorStop then
          begin
            FBitmap.Canvas.Brush.Color := ColorStart;
            FBitmap.Canvas.Rectangle(0, 0, Width, Height);
          end
          else
            FillGradDiag(FBitmap.Canvas.Handle, -Width, Height, ColorStart, ColorStop, SmoothFactor);
        end;
    end;

    Canvas.Draw(Bounds.Left, Bounds.Top, FBitmap);
  finally
    FBitmap.Free;
  end;
end;

procedure PaintGradient(Canvas: TCanvas; Bounds: TRect; GradDir: TGradientDirection; ColorStart, ColorStop: TColor; SmoothFactor: TSmoothFactor = 1);
begin
  if (GradDir = gdHorizontalEnd) or (GradDir = gdVerticalEnd) then
  begin
    if GradDir = gdHorizontalEnd then
      GradientFillCanvas(Canvas, ColorStart, ColorStop, Bounds, gdVertical)
    else
      GradientFillCanvas(Canvas, ColorStart, ColorStop, Bounds, gdHorizontal);
  end
  else
    PaintGradientEx(Canvas, Bounds, GradDir, ColorStart, ColorStop, SmoothFactor);
end;

procedure InvalidateControls(Container: TWinControl);
var
  I: Integer;
begin
  for I := 0 to Container.ControlCount - 1 do
  begin
    if IsPublishedProp(Container.Controls[I], 'Transparent') then
    begin
      if GetOrdProp(Container.Controls[I], 'Transparent') = 1 then
        Container.Controls[I].Invalidate;
    end;
  end;
end;

function GetXPColorScheme: TXPColorScheme;
var
  R: TRegIniFile;
  ColorName: string;
begin
  Result := xpcsBlue;
  R := TRegIniFile.Create('\Software\Microsoft\Windows\CurrentVersion');
  try
    ColorName := UpperCase(R.ReadString('ThemeManager', 'ColorName', ''));
    if ColorName = 'HOMESTEAD' then
      Result := xpcsGreen
    else if ColorName = 'METALLIC' then
      Result := xpcsSilver;
  finally
    R.Free;
  end;
end;

function RotateFont(Font: TFont; Angle: Integer): HFont;
var
  LogFont: TLogFont;
begin
  FillChar(LogFont, SizeOf(LogFont), #0);
  with LogFont do
  begin
    lfHeight := Font.Height;
    lfWidth := 0;
    lfEscapement := Angle * 10; { Escapement must be in 10th of degrees }
    lfOrientation := 0;
    if fsBold in Font.Style then
      lfWeight := fw_Bold
    else
      lfWeight := fw_Normal;
    lfItalic := Byte(fsItalic in Font.Style);
    lfUnderline := Byte(fsUnderline in Font.Style);
    lfStrikeOut := Byte(fsStrikeOut in Font.Style);
    lfCharSet := Font.Charset;
    lfOutPrecision := Out_Default_Precis;
    lfClipPrecision := Clip_Default_Precis;
    lfQuality := Default_Quality;
    case Font.Pitch of
      fpVariable:
        lfPitchAndFamily := Variable_Pitch;

      fpFixed:
        lfPitchAndFamily := Fixed_Pitch;

    else
      lfPitchAndFamily := Default_Pitch;
    end;
    StrPCopy(lfFaceName, Font.Name);
  end; { with }
  Result := CreateFontIndirect(LogFont);
end;

end.
