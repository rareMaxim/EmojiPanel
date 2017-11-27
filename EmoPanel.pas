unit EmoPanel;

interface

uses
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  System.UITypes,
  System.Generics.Collections,
  System.Classes,
  System.Types;

type
  TEmojiItem = class(TObject)
  private
    FImage: TBitmap;
    FFileName: string;
    FTag: string;
    FRect: TRectF;
  public
    constructor Create(const AFilename, ATag: string);
    destructor Destroy; override;
    property Image: TBitmap read FImage write FImage;
    property FileName: string read FFileName write FFileName;
    property Tag: string read FTag write FTag;
    property Rect: TRectF read FRect write FRect;
  end;

  TOnSelectEmoji = procedure(ASender: TObject; AEmoji: TEmojiItem) of object;

  TEmojiPanelCustom = class(TStyledControl)
  private
    FFillBackground: TBrush;
    FEmojis: TObjectList<TEmojiItem>;
    FEmoHeight: Single;
    FEmoWidth: Single;
    FIndent: Single;
    FMousePosition: TPointF;
    FOnSelectEmoji: TOnSelectEmoji;
    procedure SetFillBackground(const Value: TBrush);
    procedure BackgroundChanged(Sender: TObject);
  protected
    procedure Paint; override;
    procedure PaintBackground;
    procedure PaintEmojes;
    procedure PaintEmoSelector;
    procedure MouseMove(Shift: TShiftState; X: Single; Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); override;
    function GetEmojiByXY(APoint: TPointF; var AItem: TEmojiItem): Boolean;
  public
    procedure AddEmoji(const AFileName, ATag: string);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    property Background: TBrush read FFillBackground write SetFillBackground;
    property EmoHeight: Single read FEmoHeight write FEmoHeight;
    property EmoWidth: Single read FEmoWidth write FEmoWidth;
    property Indent: Single read FIndent write FIndent;
    property OnSelectEmoji: TOnSelectEmoji read FOnSelectEmoji write FOnSelectEmoji;
  end;

  TEmojiPanel = class(TEmojiPanelCustom)
  published
    property Background;
    property EmoHeight;
    property EmoWidth;
    property Indent;
    property OnSelectEmoji;


    property Action;
    property Align default TAlignLayout.None;
    property Anchors;
    property AutoTranslate default True;
    property CanFocus default True;
    property CanParentFocus;
    property ClipChildren default False;
    property ClipParent default False;

    property Cursor default crDefault;

    property DisableFocusEffect;
    property DragMode default TDragMode.dmManual;
    property EnableDragHighlight default True;
    property Enabled;

    property Height;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property Hint;
    property HitTest default True;

    property Locked default False;
    property Padding;

    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;

    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property StyleLookup;
    property TabOrder;
    property TabStop;

    property TouchTargetExpansion;
    property Visible;
    property Width;
    property ParentShowHint;
    property ShowHint;
    property OnApplyStyleLookup;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnKeyDown;
    property OnKeyUp;
    property OnCanFocus;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
  end;

procedure register;

implementation

uses
  System.Math,
  System.SysUtils;

procedure register;
begin
  RegisterComponents('SmilePanel', [TEmojiPanel]);
end;
{ TSmilePanel }

procedure TEmojiPanelCustom.AddEmoji(const AFileName, ATag: string);
begin
  FEmojis.Add(TEmojiItem.Create(AFileName, ATag));
end;

procedure TEmojiPanelCustom.BackgroundChanged(Sender: TObject);
begin
  Repaint;
end;

constructor TEmojiPanelCustom.Create(AOwner: TComponent);
begin
  inherited;
  ClipChildren := True;
  FEmojis := TObjectList<TEmojiItem>.Create;
  FFillBackground := TBrush.Create(TBrushKind.None, TAlphaColors.White);
  FFillBackground.OnChanged := BackgroundChanged;
  EmoHeight := 32;
  EmoWidth := 32;
  Indent := 10;
end;

destructor TEmojiPanelCustom.Destroy;
begin
  FFillBackground.Free;
  FEmojis.Free;
  inherited;
end;

function TEmojiPanelCustom.GetEmojiByXY(APoint: TPointF; var AItem: TEmojiItem): Boolean;
var
  LItem: TEmojiItem;
begin
  AItem := nil;
  Result := False;
  for LItem in FEmojis do
    if LItem.Rect.contains(APoint) then
    begin
      AItem := LItem;
      Result := True;
    end;
end;

procedure TEmojiPanelCustom.MouseMove(Shift: TShiftState; X, Y: Single);
begin
  inherited;
  FMousePosition := TPointF.Create(X, Y);
  Repaint;
end;

procedure TEmojiPanelCustom.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  LItem: TEmojiItem;
begin
  inherited;
  if (Button = TMouseButton.mbLeft) and (Assigned(OnSelectEmoji)) then
    if GetEmojiByXY(TPointF.Create(X, Y), LItem) then
      OnSelectEmoji(Self, LItem);
end;

procedure TEmojiPanelCustom.Paint;
begin
  inherited;
  PaintBackground;
  PaintEmoSelector;
  PaintEmojes;
end;

procedure TEmojiPanelCustom.PaintBackground;
var
  I: Integer;
  ClearColor: TAlphaColor;
begin
  if (csDesigning in ComponentState) {or Supports(self, IDesignerForm, DesignerForm)} then
    ClearColor := ((TAlphaColorRec.Deepskyblue) and (not TAlphaColorRec.Alpha)) or ($A0000000)
  else
    ClearColor := TAlphaColorRec.Null;
  if (FFillBackground.Kind = TBrushKind.None) or ((FFillBackground.Color and $FF000000 = 0) and (FFillBackground.Kind = TBrushKind.Solid)) then
  begin
    Canvas.Clear(ClearColor);
  end
  else
  begin
    Canvas.Clear(ClearColor);
    Canvas.FillRect(RectF(0, 0, Width, Height), 0, 0, AllCorners, 1, FFillBackground);
  end;
end;

procedure TEmojiPanelCustom.PaintEmojes;
var
  LRow, LCol: Integer;
  LEmoOnRow: Integer;
  LItem: TEmojiItem;
begin
  if FEmoWidth > Self.Width then
    Exit;
  LRow := 0;
  LCol := 0;
  LEmoOnRow := Floor(Width / (FEmoWidth + Indent)); //кол-во смайлов на строке
  for LItem in FEmojis do
  begin
    if LCol = LEmoOnRow then //если дошли до последнего смайла на строке
    begin
      Inc(LRow); //переходим на следующюю строку
      LCol := 0;  // и на первую позиию
    end;
    LItem.Rect := TRectF.Create(TPoint.Zero, (EmoWidth), (EmoHeight));  //размер
    LItem.Rect.SetLocation(LCol * (EmoWidth + Indent), LRow * (EmoHeight + Indent)); //позиция
    Canvas.DrawBitmap(LItem.Image, LItem.Image.BoundsF, LItem.Rect, 1); //отрисовуем
    Inc(LCol); //на следующую позицию
  end;
end;

procedure TEmojiPanelCustom.PaintEmoSelector;
var
  LItem: TEmojiItem;
  LTmpRect: TRectF;
begin
  if not GetEmojiByXY(FMousePosition, LItem) then // Получаем ємоджи по координате
    Exit;
  LTmpRect := LItem.Rect; // получаем размещение эмоджика
  LTmpRect.Inflate(Indent / 2, Indent / 2); // увеличиваем область выделения
  Canvas.Fill.Color := TAlphaColorRec.Darkgrey; // цвет
  Canvas.FillRect(LTmpRect, 2, 2, AllCorners, 1); // рисуем
end;

procedure TEmojiPanelCustom.SetFillBackground(const Value: TBrush);
begin
  FFillBackground.Assign(Value);
end;

{ TSmileItem }

constructor TEmojiItem.Create(const AFilename, ATag: string);
begin
  if not FileExists(AFilename) then
    raise EFileNotFoundException.Create(AFilename);
  FFileName := AFilename;
  FImage := TBitmap.CreateFromFile(FFileName);
  FTag := ATag;
end;

destructor TEmojiItem.Destroy;
begin
  FImage.Free;
  inherited;
end;

end.

