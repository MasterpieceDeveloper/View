unit mxDesignEditors.AlignProperty;

interface

type
  TRzAlignChangedEvent = procedure(Sender: TObject; AlignValue: TAlign) of object;

  TRzAlignDropDown = class(TRzPanel)
  private
    FAlignValue: TAlign;
    FOnAlignChanged: TRzAlignChangedEvent;
    FFooter: TRzPanel;
    FGrid: TRzPanel;
    FTopPanel: TRzPanel;
    FBottomPanel: TRzPanel;
    FLeftPanel: TRzPanel;
    FRightPanel: TRzPanel;
    FClientPanel: TRzPanel;
    FNonePanel: TRzPanel;
    FCustomPanel: TRzPanel;
    procedure InitPanel(Panel: TRzPanel; Align: TAlign);
    procedure UnselectPanel(Panel: TRzPanel);
    procedure SelectPanel(Panel: TRzPanel);
    procedure MouseEnterHandler(Sender: TObject);
    procedure MouseLeaveHandler(Sender: TObject);
    procedure SetAlignValue(Value: TAlign);
    procedure PanelClickHandler(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property AlignValue: TAlign read FAlignValue write SetAlignValue;
    property OnAlignChanged: TRzAlignChangedEvent read FOnAlignChanged write FOnAlignChanged;
  end;

  TRzAlignProperty = class(TEnumProperty, ICustomPropertyDrawing, ICustomPropertyDrawing80, IProperty80)
  private
    FDropDown: TRzAlignDropDown;
    FHost: IPropertyHost;
    FDrawingPropertyValue: Boolean;
    function PaintAlignGlyph(const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean): TRect;
    procedure KeyPressHandler(Sender: TObject; var Key: Char);
    procedure AlignChangedHandler(Sender: TObject; AlignValue: TAlign);
  public
    destructor Destroy; override;
    function GetAttributes: TPropertyAttributes; override;

    // ICustomPropertyDrawing
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean);

    // ICustomPropertyDrawing80
    function PropDrawNameRect(const ARect: TRect): TRect;
    function PropDrawValueRect(const ARect: TRect): TRect;

    // IProperty80
    procedure Edit(const Host: IPropertyHost; DblClick: Boolean); reintroduce; overload;
  end;

implementation

end.

