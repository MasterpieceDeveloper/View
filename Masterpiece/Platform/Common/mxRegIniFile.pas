unit mxRegIniFile;

interface

uses
  System.Classes,
  System.Win.Registry,
  System.SysUtils,
  System.IniFiles;

type
  ENoRegIniFile = class(Exception);

  TPathType = (ptIniFile, ptRegistry);
  TRegKey = (hkeyClassesRoot, hkeyCurrentUser, hkeyLocalMachine, hkeyUsers, hkeyPerformanceData, hkeyCurrentConfig, hkeyDynData);
  TRegAccessKey = (keyQueryValue, keySetValue, keyCreateSubKey, keyEnumerateSubKeys, keyNotify, keyCreateLink, keyRead, keyWrite, keyExecute, keyAllAccess);
  TRegAccess = set of TRegAccessKey;
  TSpecialFolder = (sfNone, sfUserAppDataRoaming, sfUserAppDataLocal, sfUserDocuments, sfProgramData);
  TIniFileEncoding = (feDefault, feUTF8, feUnicode);

  TRegIniFile = class(TComponent)
  private
    FPath: string;
    FPathType: TPathType;
    FRegKey: TRegKey;
    FRegAccess: TRegAccess;
    FSpecialFolder: TSpecialFolder;
    FFileEncoding: TIniFileEncoding;
    FRefreshStorage: Boolean;
    FAutoUpdateIniFile: Boolean;
    FIni: TMemIniFile;
    FReg: TRegistryIniFile;
  protected
    procedure CheckAccess;
    procedure SetPath(const Value: string); virtual;
    procedure SetPathType(Value: TPathType); virtual;
    procedure SetRegKey(Value: TRegKey); virtual;
    procedure SetRegAccess(Value: TRegAccess); virtual;
    procedure SetSpecialFolder(Value: TSpecialFolder); virtual;
    procedure SetFileEncoding(Value: TIniFileEncoding); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateIniFile;
    function SectionExists(const Section: string): Boolean;
    function ValueExists(const Section, Name: string): Boolean;
    function ReadBool(const Section, Name: string; Default: Boolean): Boolean;
    procedure WriteBool(const Section, Name: string; Value: Boolean);
    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
    procedure WriteDate(const Section, Name: string; Value: TDateTime);
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime);
    function ReadFloat(const Section, Name: string; Default: Double): Double;
    procedure WriteFloat(const Section, Name: string; Value: Double);
    function ReadInteger(const Section, Name: string; Default: Longint): Longint;
    procedure WriteInteger(const Section, Name: string; Value: Longint);
    function ReadString(const Section, Name, Default: string): string;
    procedure WriteString(const Section, Name, Value: string);
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
    procedure WriteTime(const Section, Name: string; Value: TDateTime);
    function ReadBinaryStream(const Section, Name: string; Value: TStream): Integer;
    procedure WriteBinaryStream(const Section, Name: string; Value: TStream);
    procedure ReadSection(const Section: string; Strings: TStrings);
    procedure ReadSections(Strings: TStrings);
    procedure ReadSectionValues(const Section: string; Strings: TStrings);
    procedure EraseSection(const Section: string);
    procedure DeleteKey(const Section, Name: string);
  published
    property AutoUpdateIniFile: Boolean read FAutoUpdateIniFile write FAutoUpdateIniFile default True;
    property FileEncoding: TIniFileEncoding read FFileEncoding write SetFileEncoding default feDefault;
    property Path: string read FPath write SetPath;
    property PathType: TPathType read FPathType write SetPathType default ptIniFile;
    property RegKey: TRegKey read FRegKey write SetRegKey default hkeyCurrentUser;
    property RegAccess: TRegAccess read FRegAccess write SetRegAccess default [keyAllAccess];
    property SpecialFolder: TSpecialFolder read FSpecialFolder write SetSpecialFolder default sfNone;
  end;

resourcestring
  rsCannotLoadCustomFraming = 'Cannot load Custom Framing settings - no TRegIniFile component specified';
  rsCannotSaveCustomFraming = 'Cannot save Custom Framing settings - no TRzRegIniFile component specified';

implementation

uses
  Winapi.Windows,
  Winapi.ShlObj;

var
  ShellGetSpecialFolderPath: function(hwndOwner: HWND; lpszPath: PChar; nFolder: Integer; fCreate: BOOL): BOOL; stdcall;

function GetSpecialFolderPath(CSIDL: Integer): string; overload;
var
  Path: array [0 .. MAX_PATH] of Char;
  ShellModule: THandle;
begin
  Result := '';

  if (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion >= 5) then
  begin
    // Only call SHGetSpecialFolderPath if running in Win2000 or higher
    ShellModule := LoadLibrary('Shell32');
    try
      if ShellModule <> 0 then
      begin
{$IFDEF UNICODE}
        @ShellGetSpecialFolderPath := GetProcAddress(ShellModule, 'SHGetSpecialFolderPathW');
{$ELSE}
        @ShellGetSpecialFolderPath := GetProcAddress(ShellModule, 'SHGetSpecialFolderPathA');
{$ENDIF}
        if Assigned(ShellGetSpecialFolderPath) then
        begin
          if ShellGetSpecialFolderPath(0, Path, CSIDL, False) then
            Result := IncludeTrailingPathDelimiter(Path);
        end;
      end;
    finally
      if ShellModule <> 0 then
        FreeLibrary(ShellModule);
    end;
  end;
end;

function GetSpecialFolderPath(Folder: TSpecialFolder; SubDir: string): string; overload;
begin
  case Folder of
    sfNone:
      Result := '';

    sfUserAppDataRoaming:
      Result := GetSpecialFolderPath(CSIDL_APPDATA);

    sfUserAppDataLocal:
      Result := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA);

    sfUserDocuments:
      Result := GetSpecialFolderPath(CSIDL_PERSONAL);

    sfProgramData:
      Result := GetSpecialFolderPath(CSIDL_COMMON_APPDATA);
  end;

  if Result <> '' then
  begin
    Result := Result + SubDir;
    ForceDirectories(Result);
    Result := IncludeTrailingPathDelimiter(Result);
  end;
end;

const
  HKEYS: array [TRegKey] of HKEY = (HKEY_CLASSES_ROOT, HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE, HKEY_USERS, HKEY_PERFORMANCE_DATA, HKEY_CURRENT_CONFIG,
    HKEY_DYN_DATA);
  KeyAccess: array [TRegAccessKey] of LongWord = (KEY_QUERY_VALUE, KEY_SET_VALUE, KEY_CREATE_SUB_KEY, KEY_ENUMERATE_SUB_KEYS, KEY_NOTIFY, KEY_CREATE_LINK,
    KEY_READ, KEY_WRITE, KEY_EXECUTE, KEY_ALL_ACCESS);

constructor TRegIniFile.Create(AOwner: TComponent);
begin
  inherited;

  FPathType := ptIniFile;
  FSpecialFolder := sfNone;
  FFileEncoding := feDefault;

  FRegAccess := [keyAllAccess];
  FRegKey := hkeyCurrentUser;

  FRefreshStorage := True;
  FAutoUpdateIniFile := True;
end;

destructor TRegIniFile.Destroy;
begin
  if not FAutoUpdateIniFile and (FIni <> nil) then
    FIni.UpdateFile;

  if FIni <> nil then
    FreeAndNil(FIni);
  if FReg <> nil then
    FreeAndNil(FReg);
  inherited;
end;

procedure TRegIniFile.CheckAccess;
var
  S, P: string;
  Access: LongWord;
  K: TRegAccessKey;
begin
  if FRefreshStorage then
  begin
    if FIni <> nil then
      FreeAndNil(FIni);
    if FReg <> nil then
      FreeAndNil(FReg);

    S := FPath;
    case FPathType of
      ptIniFile:
        begin
          if FSpecialFolder <> sfNone then
          begin
            P := ExtractFilePath(S);
            P := GetSpecialFolderPath(FSpecialFolder, P);
            if P <> '' then
            begin
              if S = '' then
                S := P + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini')
              else
                S := P + ChangeFileExt(ExtractFileName(S), '.ini');
            end;
          end;

          if S = '' then
            S := ChangeFileExt(ParamStr(0), '.ini')
          else if ExtractFilePath(S) = '' then
            S := ExtractFilePath(ParamStr(0)) + ChangeFileExt(S, '.ini');

{$IFDEF UNICODE}
          case FFileEncoding of
            feDefault:
              FIni := TMemIniFile.Create(S);
            feUTF8:
              FIni := TMemIniFile.Create(S, TEncoding.UTF8);
            feUnicode:
              FIni := TMemIniFile.Create(S, TEncoding.Unicode);
          end;
{$ELSE}
          FIni := TMemIniFile.Create(S);
{$ENDIF}
        end;

      ptRegistry:
        begin
          Access := 0;
          for K := keyQueryValue to keyAllAccess do
          begin
            if K in FRegAccess then
              Access := Access or KeyAccess[K];
          end;
          FReg := TRegistryIniFile.Create('', Access);
          FReg.RegIniFile.RootKey := HKEYS[FRegKey];
          FReg.RegIniFile.OpenKey(S, True);
        end;
    end;

    FPath := S;
  end;
  FRefreshStorage := False;
end;

function TRegIniFile.SectionExists(const Section: string): Boolean;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.SectionExists(Section)
  else
    Result := FReg.SectionExists(Section);
end;

function TRegIniFile.ValueExists(const Section, Name: string): Boolean;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ValueExists(Section, Name)
  else
    Result := FReg.ValueExists(Section, Name);
end;

function TRegIniFile.ReadBool(const Section, Name: string; Default: Boolean): Boolean;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadBool(Section, Name, Default)
  else
    Result := FReg.ReadBool(Section, Name, Default);
end;

procedure TRegIniFile.WriteBool(const Section, Name: string; Value: Boolean);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteBool(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteBool(Section, Name, Value);
end;

function TRegIniFile.ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadDate(Section, Name, Default)
  else
    Result := FReg.ReadDate(Section, Name, Default);
end;

procedure TRegIniFile.WriteDate(const Section, Name: string; Value: TDateTime);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteDate(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteDate(Section, Name, Value);
end;

function TRegIniFile.ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadDateTime(Section, Name, Default)
  else
    Result := FReg.ReadDateTime(Section, Name, Default);
end;

procedure TRegIniFile.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteDateTime(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteDateTime(Section, Name, Value);
end;

function TRegIniFile.ReadFloat(const Section, Name: string; Default: Double): Double;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadFloat(Section, Name, Default)
  else
    Result := FReg.ReadFloat(Section, Name, Default);
end;

procedure TRegIniFile.WriteFloat(const Section, Name: string; Value: Double);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteFloat(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteFloat(Section, Name, Value);
end;

function TRegIniFile.ReadInteger(const Section, Name: string; Default: Longint): Longint;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadInteger(Section, Name, Default)
  else
    Result := FReg.ReadInteger(Section, Name, Default);
end;

procedure TRegIniFile.WriteInteger(const Section, Name: string; Value: Longint);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteInteger(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteInteger(Section, Name, Value);
end;

function TRegIniFile.ReadString(const Section, Name, Default: string): string;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadString(Section, Name, Default)
  else
    Result := FReg.ReadString(Section, Name, Default);
end;

procedure TRegIniFile.WriteString(const Section, Name, Value: string);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteString(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteString(Section, Name, Value);
end;

function TRegIniFile.ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadTime(Section, Name, Default)
  else
    Result := FReg.ReadTime(Section, Name, Default);
end;

procedure TRegIniFile.WriteTime(const Section, Name: string; Value: TDateTime);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteTime(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteTime(Section, Name, Value);
end;

function TRegIniFile.ReadBinaryStream(const Section, Name: string; Value: TStream): Integer;
begin
  CheckAccess;
  if FPathType = ptIniFile then
    Result := FIni.ReadBinaryStream(Section, Name, Value)
  else
    Result := FReg.ReadBinaryStream(Section, Name, Value);
end;

procedure TRegIniFile.WriteBinaryStream(const Section, Name: string; Value: TStream);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.WriteBinaryStream(Section, Name, Value);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.WriteBinaryStream(Section, Name, Value);
end;

procedure TRegIniFile.ReadSection(const Section: string; Strings: TStrings);
begin
  CheckAccess;
  if FPathType = ptIniFile then
    FIni.ReadSection(Section, Strings)
  else
    FReg.ReadSection(Section, Strings);
end;

procedure TRegIniFile.ReadSections(Strings: TStrings);
begin
  CheckAccess;
  if FPathType = ptIniFile then
    FIni.ReadSections(Strings)
  else
    FReg.ReadSections(Strings);
end;

procedure TRegIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
  Reg: TRegistry;
  FullKey: string;

  procedure ProcessValueName(const ValueName: string);
  var
    I, N, BinSize: Integer;
    S, HexStr, FmtStr: string;
    BinData, HexData: Pointer;
    P: PChar;
  begin
    FmtStr := '%s=%s';
    if ValueName = '' then
      S := Format(FmtStr, ['Default', Reg.ReadString(ValueName)])
    else
    begin
      case Reg.GetDataType(ValueName) of
        rdUnknown:
          S := Format(FmtStr, [ValueName, 'Unknown Data Type']);

        rdString, rdExpandString:
          begin
            S := Format(FmtStr, [ValueName, Reg.ReadString(ValueName)]);
          end;

        rdInteger:
          begin
            N := Reg.ReadInteger(ValueName);
            FmtStr := '%s=%d';
            S := Format(FmtStr, [ValueName, N]);
          end;

        rdBinary:
          begin
            BinSize := Reg.GetDataSize(ValueName);
            GetMem(BinData, BinSize);
            GetMem(HexData, BinSize * 2);
            try
              Reg.ReadBinaryData(ValueName, BinData^, BinSize);
              BinToHex(BinData, PChar(HexData), BinSize);
              P := HexData;
              HexStr := '';
              I := 0;
              while I < BinSize do
              begin
                HexStr := HexStr + P[I * 2] + P[I * 2 + 1] + ' ';
                Inc(I);
              end;

              S := Format(FmtStr, [ValueName, HexStr]);
            finally
              FreeMem(BinData, BinSize);
              FreeMem(HexData, BinSize * 2);
            end;
          end;
      end;
    end;
    Strings.Add(S);
  end; { = ProcessValueName = }

  procedure ProcessKey(const Key: string);
  var
    I: Integer;
    ValueNames: TStringList;
    RegKeyInfo: TRegKeyInfo;
  begin
    if Reg.OpenKey(Key, False) then
    begin
      ValueNames := TStringList.Create;
      ValueNames.Sorted := True;
      try
        Reg.GetKeyInfo(RegKeyInfo);

        Reg.GetValueNames(ValueNames);
        for I := 0 to ValueNames.Count - 1 do
          ProcessValueName(ValueNames[I]);
      finally
        ValueNames.Free;
      end;
    end;
    Reg.CloseKey;
  end; { = ProcessKey = }

begin { = TRzRegIniFile.ReadSectionValues = }
  CheckAccess;
  if FPathType = ptIniFile then
    FIni.ReadSectionValues(Section, Strings)
  else
  begin
    // Cannot use FReg.ReadSectionValues( Section, Strings ) b/c TRegistryIniFile.ReadSectionValues simply uses
    // ReadString to read each value. This is fine for an INI file, but for the Registry, if a value is not a string
    // value (e.g. a DWORD), then an exception is raised.

    Reg := TRegistry.Create;
    Strings.BeginUpdate;
    Strings.Clear;
    try
      Reg.RootKey := HKEYS[FRegKey];

      if FPath[Length(FPath)] = '\' then
        FullKey := FPath + Section
      else
        FullKey := FPath + '\' + Section;
      if Reg.OpenKey(FullKey, False) then
      begin
        Reg.CloseKey;
        ProcessKey(FullKey);
      end;
    finally
      Strings.EndUpdate;
      Reg.Free;
    end;
  end;
end; { = TRzRegIniFile.ReadSectionValues = }

procedure TRegIniFile.EraseSection(const Section: string);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.EraseSection(Section);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.EraseSection(Section);
end;

procedure TRegIniFile.DeleteKey(const Section, Name: string);
begin
  CheckAccess;
  if FPathType = ptIniFile then
  begin
    FIni.DeleteKey(Section, Name);
    if AutoUpdateIniFile then
      UpdateIniFile;
  end
  else
    FReg.DeleteKey(Section, Name);
end;

procedure TRegIniFile.SetPath(const Value: string);
begin
  if FPath <> Value then
  begin
    FPath := Value;
    FRefreshStorage := True;
  end;
end;

procedure TRegIniFile.SetPathType(Value: TPathType);
begin
  if FPathType <> Value then
  begin
    FPathType := Value;
    FRefreshStorage := True;
  end;
end;

procedure TRegIniFile.SetRegKey(Value: TRegKey);
begin
  if FRegKey <> Value then
  begin
    FRegKey := Value;
    FRefreshStorage := True;
  end;
end;

procedure TRegIniFile.SetRegAccess(Value: TRegAccess);
begin
  if FRegAccess <> Value then
  begin
    FRegAccess := Value;
    FRefreshStorage := True;
  end;
end;

procedure TRegIniFile.SetSpecialFolder(Value: TSpecialFolder);
begin
  if FSpecialFolder <> Value then
  begin
    FSpecialFolder := Value;
    FRefreshStorage := True;
  end;
end;

procedure TRegIniFile.SetFileEncoding(Value: TIniFileEncoding);
begin
  if FFileEncoding <> Value then
  begin
    FFileEncoding := Value;
    FRefreshStorage := True;
  end;
end;

procedure TRegIniFile.UpdateIniFile;
begin
  if FPathType = ptIniFile then
  begin
{$IFDEF UNICODE}
    // Need to reset the FIni.Encoding property because during the load, the
    // TMemIniFile class may have reset it to a different format because it
    // misintrpreted the BOM.
    case FFileEncoding of
      feDefault:
        FIni.Encoding := TEncoding.Default;
      feUTF8:
        FIni.Encoding := TEncoding.UTF8;
      feUnicode:
        FIni.Encoding := TEncoding.Unicode;
    end;
{$ENDIF}
    FIni.UpdateFile;
  end;
end;

end.
