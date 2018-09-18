unit regPlatform;

interface

procedure Register;

const
  csPalettePage = 'Masterpiece';

implementation

uses
  System.Classes,
  mxGradientPanel;

procedure Register;
begin
  RegisterComponents(csPalettePage, [TGradientPanel]);
end;

end.
