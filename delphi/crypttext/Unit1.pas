unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Encryp;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    edtPassword: TEdit;
    Label2: TLabel;
    encbtn: TBitBtn;
    decbtn: TBitBtn;
    closebtn: TBitBtn;
    Panel4: TPanel;
    BitBtn4: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    BitBtn5: TBitBtn;
    Panel5: TPanel;
    Encryption1: TEncryption;
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure closebtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure encbtnClick(Sender: TObject);
    procedure decbtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
if OpenDialog1.Execute then
  Memo1.Lines.LoadFromFile(OpenDialog1.FileName);

end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
if SaveDialog1.Execute then
  Memo1.Lines.SavetoFile(SaveDialog1.FileName);

end;

procedure TForm1.closebtnClick(Sender: TObject);
begin
Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TForm1.encbtnClick(Sender: TObject);
begin
  Encryption1.Input  := Memo1.Lines.Text;
  Encryption1.Key    := edtPassword.Text;
  Encryption1.Action := atEncryption;
  Encryption1.Execute;
  Memo1.Lines.Text := Encryption1.Output;
end;

procedure TForm1.decbtnClick(Sender: TObject);
begin
  Encryption1.Input  := Memo1.Lines.Text;
  Encryption1.Key    := edtPassword.Text;
  Encryption1.Action := atDecryption;
  Encryption1.Execute;
  Memo1.Lines.Text := Encryption1.Output;
end;

end.
