﻿unit mxGrafx;

interface

uses
  Winapi.Windows,
  System.Classes,
  Vcl.Controls;

procedure DrawParentImage(Control: TControl; DC: HDC; InvalidateParent: Boolean = False);

implementation

uses
  Winapi.Messages,
  Vcl.Forms;

procedure DrawParentImage(Control: TControl; DC: HDC; InvalidateParent: Boolean = False);
var
  SaveIndex: Integer;
  P: TPoint;
begin
  if Control.Parent = nil then
    Exit;
  SaveIndex := SaveDC(DC);
  GetViewportOrgEx(DC, P);

  SetViewportOrgEx(DC, P.X - Control.Left, P.Y - Control.Top, nil);
  IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth, Control.Parent.ClientHeight);

  if not(csDesigning in Control.ComponentState) then
  begin
    Control.Parent.Perform(WM_ERASEBKGND, DC, 0);
    Control.Parent.Perform(WM_PRINTCLIENT, DC, prf_Client);
  end
  else
  begin
    // Wrapping the following calls in a try..except is necessary to prevent
    // cascading access violations in the Form Designer (and ultimately the
    // shutting down of the IDE) in the Form Designer under the following
    // specific condition:
    // 1. Control on Form Designer supports Transparency (thus this procedure
    // is called).
    // 2. Control is selected in the Form Designer such that grab handles are
    // visible.
    // 3. User selects File|Close All Files, or Creates a New Application
    // (i.e. Anything that closes the current project).
    // 4. Cascading access violations are created inside the IDE Form Designer
    //
    // The same problem also occurs in Delphi 7 under Windows XP if you add a
    // Delphi32.exe.manifest to the Delphi\Bin folder. This will cause controls
    // such as TPanel to appear transparent when on the Form Designer. Repeating
    // the steps above, will result in the cascading access violations as
    // described above.

    try
      Control.Parent.Perform(wm_EraseBkgnd, DC, 0);
      Control.Parent.Perform(wm_PrintClient, DC, prf_Client);
    except
    end;
  end;

  RestoreDC(DC, SaveIndex);

  if InvalidateParent then
  begin
    if not(Control.Parent is TCustomControl) and not(Control.Parent is TCustomForm) and not(csDesigning in Control.ComponentState) then
    begin
      Control.Parent.Invalidate;
    end;
  end;
end;

end.
