program demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
