program WatchAPI;

uses
  System.StartUpCopy,
  FMX.Forms,
  WatchAPI.UnitMain in 'WatchAPI.UnitMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
