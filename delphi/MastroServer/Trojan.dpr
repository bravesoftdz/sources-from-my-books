
program Trojan;

uses
  Forms,
  main in 'main.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.HelpFile := 'sysprog';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
