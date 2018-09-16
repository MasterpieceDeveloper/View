unit mxSharedRes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, cxStyles, cxControls, cxGridBandedTableView,
  cxCustomPivotGrid, cxClasses, ImgList, ActnList, cxGrid, cxVGrid, cxGraphics, cxLookAndFeelPainters, dxAlertWindow, cxGridExportLink, Spring.Collections,
  cxGridCustomView, cxTLExportLink, cxTL, System.ImageList;

type
  TSupportedExportType = (exExcel, exXLSX, exHTML, exXML, exText);

  TSharedRes = class(TDataModule)
    ImageList: TcxImageList;
    cxStyleRepository: TcxStyleRepository;
    stlBackgroundGrid: TcxStyle;
    stlBandBackgroundGrid: TcxStyle;
    stlBandHeaderGrid: TcxStyle;
    stlContentEven: TcxStyle;
    stlContentOddGrid: TcxStyle;
    stlFilterBoxGrid: TcxStyle;
    stlFooterGrid: TcxStyle;
    stlGroupGrid: TcxStyle;
    stlGroupByBoxGrid: TcxStyle;
    stlHeaderGrid: TcxStyle;
    stlInactiveGrid: TcxStyle;
    stlIncSearch: TcxStyle;
    stlIndicatorGrid: TcxStyle;
    stlPreviewGrid: TcxStyle;
    stlSelectionGrid: TcxStyle;
    cxStyle17: TcxStyle;
    cxStyle18: TcxStyle;
    cxStyle19: TcxStyle;
    cxStyle20: TcxStyle;
    cxStyle21: TcxStyle;
    cxStyle22: TcxStyle;
    cxStyle23: TcxStyle;
    cxStyle24: TcxStyle;
    cxStyle25: TcxStyle;
    cxStyle26: TcxStyle;
    cxStyle27: TcxStyle;
    cxStyle28: TcxStyle;
    cxStyle29: TcxStyle;
    cxStyle30: TcxStyle;
    cxStyle31: TcxStyle;
    cxStyle32: TcxStyle;
    cxStyleOutgoing: TcxStyle;
    cxStyle33: TcxStyle;
    cxStyle34: TcxStyle;
    cxStyle35: TcxStyle;
    cxStyle36: TcxStyle;
    cxStyle37: TcxStyle;
    cxStyle38: TcxStyle;
    cxStyle39: TcxStyle;
    cxStyle40: TcxStyle;
    cxStyle41: TcxStyle;
    cxStyle42: TcxStyle;
    cxStyle43: TcxStyle;
    cxStyle44: TcxStyle;
    cxStyle45: TcxStyle;
    cxStyle46: TcxStyle;
    cxStyle47: TcxStyle;
    cxStyle48: TcxStyle;
    cxStyle49: TcxStyle;
    cxStyle50: TcxStyle;
    cxStyle51: TcxStyle;
    stlBackgroundVG: TcxStyle;
    stlCategoryVG: TcxStyle;
    stlContentVG: TcxStyle;
    stlHeaderVG: TcxStyle;
    stlInactiveVG: TcxStyle;
    stlIncSearchVG: TcxStyle;
    stlSelectionVG: TcxStyle;
    stsColor: TcxGridBandedTableViewStyleSheet;
    stsBW: TcxGridBandedTableViewStyleSheet;
    stsPivotGrid: TcxPivotGridStyleSheet;
    stsPivotColor: TcxPivotGridStyleSheet;
    stsPivotBW: TcxPivotGridStyleSheet;
    sheetVerticalGrid: TcxVerticalGridStyleSheet;
    stlContentGrid: TcxStyle;
    ImageList32Ext: TcxImageList;
    cxSmallImages: TcxImageList;
    imgAlertButtons: TcxImageList;
    imgCommandsSize: TcxImageList;
    AlertManager: TdxAlertWindowManager;
    styleBarCaption: TcxStyle;
    styleRibbonMenu: TcxStyle;
    styleRibbonMenuHidden: TcxStyle;
    styleRibbonSubMenu: TcxStyle;
    styleRibbonSubMenuHidden: TcxStyle;
    ImageList32: TcxImageList;
    ComponentIcons: TcxImageList;
  private
    FImagesIndex: IDictionary<string, Integer>; // Индекс. Значение - имя в директории. Data - индекс изображения
    FCommandImageFileName: TStringList;
  private
    function ImageListAdd(const AImageKey, AFileName: string): Integer; overload;
    function ImageListAdd(const AImageKey: string; APicture: TPicture): Integer; overload;
    function ImageListAdd(const AImageKey: string; AIcon: TIcon): Integer; overload;
    procedure ExportCxGrid(AGrid: TcxGrid; AExportType: TSupportedExportType; AExpand, SaveAll: Boolean; const AFileName: string);
    procedure ExportPivotGrid(AGrid: TcxCustomPivotGrid; AExportType: TSupportedExportType; AExpand: Boolean; const AFileName: string);
    procedure ExportTreeList(AGrid: TcxCustomTreeList; AExportType: TSupportedExportType; AExpand: Boolean; const AFileName: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Загружает картинку в ImageList, возвращает ImageIndex загруженной картинки
    // Key - ключ, по которому потом будет производиться поиск картинки
    // ImageFileName - полное имя файла, в котором находтся картинка, в формате bmp.
    function ImageIndex(const AKey, AImageFileName: string): Integer;
    // Возвращает индекс картинки. Если картинки еще не было загружено - загружает из директории.
    // Если имя не найдено в директории или файл не существует - возвращает 0 (т.е. ссылку на пустую картинку)
    // ImageName - имя картинки в терминах сервиса Directory. Эта строка станет ключом.
    function ImageIndexFromDirectory(const AImageName: string): Integer; overload;
    // здесь индексатором выступает строка на усмотрение заказчика на хранение его картинки в общем ImageList. Его ClassName например.
    function ImageIndexFromPicture(const AKey: string; APicture: TPicture): Integer;
    function ImageIndexFromIcon(const AKey: string; AIcon: TIcon): Integer;

    procedure ImageManagerDebugExport(const ADirectoryName: string; AImageList: TCustomImageList);
    procedure AddSharedImages(AList: TCustomActionList);
    procedure SaveLog;
    // Экспорт cxGrid в различные форматы
    function ExportGrid(AGrid: TcxControl; AExportType: TSupportedExportType; AExpand, SaveAll: Boolean; AOpen: Boolean = True): string;
    property CommandImageFileName: TStringList read FCommandImageFileName;
  end;

var
  SharedRes: TSharedRes;

type
  TGetGridExportClass = function(AGridView: TcxCustomGridView): TcxGridCustomExportClass;
var
  OnGetGridExportClass: TGetGridExportClass = nil;

type
  TGetFileFullName = function(APath: string): string;
var
  OnGetFileFullName: TGetFileFullName = nil;

implementation

{$R *.dfm}

uses
  ShellAPI, ActiveX, cxExportPivotGridLink, dxGDIPlusClasses;

{ TSharedRes }

procedure TSharedRes.AddSharedImages(AList: TCustomActionList);
var
  Images: TCustomImageList;
  Bitmap: TBitmap;
  Action: TAction;
  I: Integer;
begin
  Images := AList.Images;
  if not Assigned(Images) then
    Exit;
  Bitmap := TBitmap.Create;
  try
    for I := 0 to AList.ActionCount - 1 do
    begin
      Action := AList[I] as TAction;
      if Action.ImageIndex = -1 then
        Continue;
      if not Images.GetBitmap(Action.ImageIndex, Bitmap) then
        Continue;
      Action.ImageIndex := ImageList.Count;
      ImageList.AddMasked(Bitmap, Bitmap.Canvas.Pixels[0, 0]);
    end;
  finally
    Bitmap.Free;
  end;
end;

constructor TSharedRes.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
//  ImageList.BeginUpdate;
//  ImageList32.BeginUpdate;
  FImagesIndex := TCollections.CreateDictionary<string, Integer>;
  FCommandImageFileName := TStringList.Create;
  for I := 0 to FImagesIndex.Count - 1 do
    FCommandImageFileName.Add('static image № ' + IntToStr(I))
end;

destructor TSharedRes.Destroy;
begin
  FCommandImageFileName.Free;
  inherited Destroy;
end;

procedure TSharedRes.ExportCxGrid(AGrid: TcxGrid; AExportType: TSupportedExportType; AExpand, SaveAll: Boolean; const AFileName: string);
begin
  case AExportType of
    exHTML:
      ExportGridToHTML(AFileName, AGrid, AExpand, SaveAll);
    exXML:
      ExportGridToXML(AFileName, AGrid, AExpand, SaveAll);
    exText:
      ExportGridToText(AFileName, AGrid, AExpand, SaveAll);
    exExcel, exXLSX:
    begin
//      cxGridExportLink.OnGetGridExportClass := OnGetGridExportClass;
      try
        case AExportType of
          exExcel:
            ExportGridToExcel(AFileName, AGrid, AExpand, SaveAll);
          exXLSX:
            ExportGridToXLSX(AFileName, AGrid, AExpand, SaveAll);
        end;
      finally
//        cxGridExportLink.OnGetGridExportClass := nil;
      end;
    end;
  end;
end;

procedure TSharedRes.ExportPivotGrid(AGrid: TcxCustomPivotGrid; AExportType: TSupportedExportType; AExpand: Boolean; const AFileName: string);
begin
  case AExportType of
    exHTML:
     cxExportPivotGridToHTML(AFileName, AGrid, AExpand);
    exXML:
      cxExportPivotGridToXML(AFileName, AGrid, AExpand);
    exText:
      ; //cxExportPivotGridToText(AFileName, AGrid, AExpand);
    exXLSX:
      cxExportPivotGridToXLSX(AFileName, AGrid, AExpand);
    exExcel:
      cxExportPivotGridToExcel(AFileName, AGrid, AExpand);
  end;
end;

procedure TSharedRes.ExportTreeList(AGrid: TcxCustomTreeList; AExportType: TSupportedExportType; AExpand: Boolean; const AFileName: string);
begin
  case AExportType of
    exHTML:
     cxExportTLToHTML(AFileName, AGrid, AExpand);
    exXML:
      cxExportTLToXML(AFileName, AGrid, AExpand);
    exText:
      ; //cxExportTLToText(AFileName, AGrid, AExpand);
    exXLSX:
      cxExportTLToXLSX(AFileName, AGrid, AExpand);
    exExcel:
      cxExportTLToExcel(AFileName, AGrid, AExpand);
  end;
end;

function TSharedRes.ExportGrid(AGrid: TcxControl; AExportType: TSupportedExportType; AExpand, SaveAll: Boolean; AOpen: Boolean = True): string;

  function GetTemporaryFileName(Prfx: string; FileExt: string = ''): string;
  var
    GUID: TGUID;
    buf: array [0 .. MAX_PATH] of char;
    TmpFile: String;
    BufSize: DWORD;
  begin
    CoCreateGuid(GUID);
    TmpFile := Prfx + GUIDToString(GUID);
    TmpFile := StringReplace(TmpFile, '{', '', [rfReplaceAll]);
    TmpFile := StringReplace(TmpFile, '}', '', [rfReplaceAll]);
    TmpFile := StringReplace(TmpFile, '-', '', [rfReplaceAll]);
    BufSize := MAX_PATH;
    GetTempPath(BufSize, @buf[0]);
    Result := buf + TmpFile;
    if FileExt <> '' then
      Result := Result + FileExt
    else
      Result := Result + '.tmp';
  end;

const
  csFileExts: array[TSupportedExportType] of string = ('.xls', '.xlsx', '.html', '.xml', '.txt');
begin
  Screen.Cursor := crHourGlass;
  try
    Result := GetTemporaryFileName('', csFileExts[AExportType]);

    if AGrid is TcxGrid  then
      ExportCxGrid(AGrid as TcxGrid, AExportType, AExpand, SaveAll, Result)
    else if AGrid is TcxCustomPivotGrid  then
      ExportPivotGrid(AGrid as TcxCustomPivotGrid, AExportType, AExpand, Result)
    else if AGrid is TcxCustomTreeList then
      ExportTreeList(AGrid as TcxCustomTreeList, AExportType, AExpand, Result);

    if AOpen then
    begin
      ShellExecute(Application.Handle, nil, PChar(Result), nil, nil, SW_SHOWNORMAL);
      DeleteFile(Result);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

type
  TdxPNGImageAccess = class(TdxPNGImage);

function TSharedRes.ImageListAdd(const AImageKey, AFileName: string): Integer;

  procedure AssignPngToBmp(const AFileName: string; ABitmap: TBitmap);
  var
    dxPNGImage: TdxPNGImage;
  begin
    dxPNGImage := TdxPNGImage.Create;
    try
      dxPNGImage.LoadFromFile(AFileName);
      TdxPNGImageAccess(dxPNGImage).AssignTo(ABitmap);
    finally
      dxPNGImage.Free;
    end;
  end;

var
  Bitmap: TBitmap;
  ShortFileName: string;
  NewFileName: string;
  P: Integer;
begin
  NewFileName := AFileName;
  ShortFileName := ChangeFileExt(AFileName, '');

  P := Pos('_16x16', ShortFileName);
  if P = 0 then
    P := Pos('_32x32', ShortFileName);
  if P > 0 then
    Delete(ShortFileName, P, Length('_32x32'));

  NewFileName := ShortFileName + '_16x16.png';
  if not FileExists(NewFileName) then // если нет png берем bmp
    NewFileName := AFileName;

  if FileExists(AFileName) then
  begin
    Bitmap := TBitmap.Create;
    try
      // v.binkovskiy 03.03.2015 18:19:51
      // ImageList.AddMasked вызовет Change, в cxTreeList это приведет к повторному вызову ImageListAdd
      // поэтому сразу кладем в кеш имя/индекс
      Result := ImageList.Count;

      FImagesIndex.Add(AImageKey, Result);
      FCommandImageFileName.Add(AFileName);

      if SameText(ExtractFileExt(NewFileName), '.png') then
        AssignPngToBmp(NewFileName, Bitmap)
      else
        Bitmap.LoadFromFile(NewFileName);

      Bitmap.SetSize(16, 16);
      ImageList.AddMasked(Bitmap, Bitmap.Canvas.Pixels[0, 0]);
      Assert(Result = ImageList.Count-1);

      NewFileName := ShortFileName + '_32x32.png';
      if FileExists(NewFileName) then
        AssignPngToBmp(NewFileName, Bitmap)
      else
        Bitmap.SetSize(32, 32);
      ImageList32.AddMasked(Bitmap, Bitmap.Canvas.Pixels[0, 0]);
    finally
      Bitmap.Free;
    end;
  end
  else
  begin
    Result := 0;
    FImagesIndex.Add(AImageKey, Result);
    FCommandImageFileName.Add('not found ' + AImageKey);
  end;
end;

function TSharedRes.ImageListAdd(const AImageKey: string; APicture: TPicture): Integer;
var
  Bitmap: TBitmap;
begin
  if APicture.Width + APicture.Height > 0 then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Assign(APicture);
      // v.binkovskiy 03.03.2015 18:19:51
      // ImageList.AddMasked вызовет Change, в cxTreeList это приведет к повторному вызову ImageListAdd
      // поэтому сразу кладем в кеш имя/индекс
      Result := ImageList.Count;
      FImagesIndex.Add(AImageKey, Result);
      FCommandImageFileName.Add('direct ' + AImageKey);
      ImageList.AddMasked(Bitmap, Bitmap.Canvas.Pixels[0, 0]);
      ImageList32.AddMasked(Bitmap, Bitmap.Canvas.Pixels[0, 0]);
    finally
      Bitmap.Free;
    end;
  end
  else
  begin
    Result := 0;
    FImagesIndex.Add(AImageKey, Result);
    FCommandImageFileName.Add('direct ' + AImageKey);
  end;
end;

function TSharedRes.ImageListAdd(const AImageKey: string; AIcon: TIcon): Integer;
var
  Bitmap: TBitmap;
begin
  if AIcon.Width + AIcon.Height > 0 then
  begin
  // v.binkovskiy 28.07.2015 18:16:16
  // ImageList.AddIcon (возможно, как AddMasked, не проверял) вызовет Change, в cxTreeList это приведет к повторному вызову ImageListAdd
  // поэтому сразу кладем в кеш имя/индекс
    Result := ImageList.Count;
    FImagesIndex.Add(AImageKey, Result);
    FCommandImageFileName.Add('direct ' + AImageKey);
    ImageList.AddIcon(AIcon);

    // количество в ImageList's должно быть одинаково, но не знаю как изменить размер иконки, по быстрому на пустом битмапе
    Bitmap := TBitmap.Create;
    try
      Bitmap.SetSize(32, 32);
      ImageList32.AddMasked(Bitmap, Bitmap.Canvas.Pixels[0, 0]);
    finally
      Bitmap.Free;
    end;
  end
  else
  begin
    Result := 0;
    FImagesIndex.Add(AImageKey, Result);
    FCommandImageFileName.Add('direct ' + AImageKey);
  end;
end;

procedure TSharedRes.SaveLog;
const
  csFileName = 'd:\CommandsIcons.txt';
begin
  FCommandImageFileName.SaveToFile(csFileName);
end;

function TSharedRes.ImageIndex(const AKey, AImageFileName: string): Integer;
begin
  if not FImagesIndex.TryGetValue(AKey, Result) then
    Result := ImageListAdd(AKey, AImageFileName);
end;

function TSharedRes.ImageIndexFromPicture(const AKey: string; APicture: TPicture): Integer;
begin
  if not FImagesIndex.TryGetValue(AKey, Result) then
    Result := ImageListAdd(AKey, APicture);
end;

function TSharedRes.ImageIndexFromIcon(const AKey: string; AIcon: TIcon): Integer;
begin
  if not FImagesIndex.TryGetValue(AKey, Result) then
    Result := ImageListAdd(AKey, AIcon);
end;

function TSharedRes.ImageIndexFromDirectory(const AImageName: string): Integer;
var
  DirectoryPath: string;
  ImageKey: string;
  P: Integer;
begin
  DirectoryPath := AImageName;
  ImageKey := AImageName;

  if Pos('/', DirectoryPath) = 0 then
    DirectoryPath := '/Images/16x16/' + DirectoryPath
  else
  begin
    P := Pos('_16x16', ImageKey);
    if P = 0 then
      P := Pos('_32x32', ImageKey);
    if P > 0 then
      Delete(ImageKey, P, Length('_32x32'));
  end;

  if not FImagesIndex.TryGetValue(ImageKey, Result) then
    if Assigned(OnGetFileFullName) then
      Result := ImageListAdd(ImageKey, OnGetFileFullName(DirectoryPath))
    else
      Result := 0;                     
end;

procedure TSharedRes.ImageManagerDebugExport(const ADirectoryName: string; AImageList: TCustomImageList);
var
  I: Integer;
  B: TBitmap;
begin
  ForceDirectories(ADirectoryName);
  for I := 0 to SharedRes.ImageList.Count - 1 do
  begin
    B := TBitmap.Create;
    try
      AImageList.GetBitmap(I, B);
      B.SaveToFile(ADirectoryName + '\' + IntToStr(I) + '.bmp');
    finally
      B.Free;
    end;
  end;
end;

initialization

begin
  SharedRes := TSharedRes.Create(nil);
end;

finalization

begin
  FreeAndNil(SharedRes);
end;

end.