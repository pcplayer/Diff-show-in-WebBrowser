program Diff_WebBrowser;

uses
  Vcl.Forms,
  UFmMain in 'UFmMain.pas' {FmMain},
  Diff in 'Diff.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFmMain, FmMain);
  Application.Run;
end.
