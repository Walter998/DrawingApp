program LineDrawing;

uses
  Vcl.Forms,
  ScreenHandler in 'ScreenHandler.pas' {formMainForm},
  XMLHandler in 'XMLHandler.pas',
  User_defined in 'User_defined.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMainForm, formMainForm);
  Application.Run;
end.
