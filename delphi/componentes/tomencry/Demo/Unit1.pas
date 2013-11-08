unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Encryp;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
    a: TEncryption;
begin
   a:= TEncryption.Create(self);
   a.input:=edit1.text;
   a.action:=atEncryption;
   a.execute;
   Label1.Caption:=a.output;
   a.input:=Label1.Caption;
   a.action:=atDecryption;
   a.execute;
   Label2.Caption:=a.output;
   a.Destroy;
end;

end.
