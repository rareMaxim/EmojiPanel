unit Main;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  EmoPanel,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.ScrollBox,
  FMX.Memo, FMX.Layouts;

type
  TForm5 = class(TForm)
    emjpnl1: TEmojiPanel;
    mmo1: TMemo;
    spl1: TSplitter;
    vrtscrlbx1: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses
  System.IOUtils;
{$R *.fmx}

procedure TForm5.FormCreate(Sender: TObject);
var
  LFile: string;
  x: string;
begin
{$IF Defined(MSWINDOWS)}
  for LFile in TDirectory.GetFiles('..\..\..\smiles\') do
{$ELSE IF Defined(ANDROID)}
    for LFile in TDirectory.GetFiles(TPath.Combine(TPath.GetPublicPath, 'smiles')) do 
{$ENDIF}
    begin
      mmo1.lines.add(LFile);
      emjpnl1.AddEmoji(LFile, '');
    end;
end;

end.

