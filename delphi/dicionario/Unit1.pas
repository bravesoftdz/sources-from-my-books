unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons,
  Dicionario, Encryp;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Timer1: TTimer;
    Memo1: TMemo;
    Panel2: TPanel;
    Panel3: TPanel;
    btnOK: TBitBtn;
    Button1: TButton;
    Edit1: TEdit;
    Label2: TLabel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Sair: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button2: TButton;
    Label3: TLabel;
    Edit2: TEdit;
    Encryption1: TEncryption;
    Label4: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Salvar, Continua : Boolean;
    Path, Desencryptado, Encriptado : String;
    Total, Contagem, Tempo, TempoSalvar : Integer;
    procedure DesenCryptar(Inicio:String);
    procedure Prepara(Inicio:String);
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Prepara(Inicio:String);
var
  n : integer;
begin
    Continua := True;
    Memo1.Lines.Clear;
    for n := 0 to 3 do  Memo1.Lines.add('');
    Desencryptado := Edit1.Text;
    Encriptado     := Edit2.Text;
    btnOK.Caption := 'Parar';
    DesenCryptar(Inicio);
end;


procedure TForm1.DesenCryptar(Inicio:String);
  procedure SalvaArquivo(Posicao:String);
  var
   strs: TStringList;
  begin
   strs:= TStringList.Create;
   strs.Add(Edit1.Text);
   strs.Add(Edit2.Text);
   strs.Add(Posicao);
   strs.SaveToFile(Path+'status.txt');
   strs.Destroy;
  end;


  function DecriptCode(Texto, Pass:string):string;
  begin
    Encryption1.Input  := Texto;
    Encryption1.Key    := Pass;
    Encryption1.Action := atDecryption;
    Encryption1.Execute;
    Result := Encryption1.Output;
  end;

var
 Erro, Posicao, PosicaoNova, s : String;
 nposicao : integer;

begin
 Posicao := Inicio;
 if (Posicao <> '') then begin
  Erro := LocalizarPalavra(Posicao);
  if Erro = 'EOF' then ShowMessage('Fim do Arquivo!!!');
 end;
 nposicao := 0;
 AbreDicionario(Path+'passwords.txt');

  while Continua do begin
    PosicaoNova := '';
    Erro := LocalizarProxima(PosicaoNova);
    if Erro = 'EOF' then begin
      ShowMessage('Fim do Arquivo!!!');
      FechaDicionario;
      exit;
    end;

    if Erro <> mzOK then begin
      ShowMessage(Erro);
      FechaDicionario;
      exit;
    end;
    Posicao := '';
    Posicao := PosicaoNova;
    if CheckBox4.Checked then begin
      if nposicao >= 4000 then begin
          Memo1.Lines.Strings[2] := ('Posicao: '+Posicao);
          nposicao := 0;
      end;
      nposicao := nposicao+1;
    end;

    if salvar then begin
       SalvaArquivo(Posicao);
       salvar := false;
    end;

    Application.ProcessMessages;
    s := DecriptCode(Encriptado,Posicao);
    Contagem := Contagem+1;
    if s = Desencryptado then begin
       Continua := False;
       Timer1.Enabled := False;
       Memo1.Lines.Add('Senha:'+Posicao);
       ShowMessage('Senha:'+Posicao);
       btnOK.Caption := 'Iniciar';
    end;
  end;
  FechaDicionario;
end;


procedure TForm1.btnOKClick(Sender: TObject);
begin
  if btnOK.Caption = 'Iniciar' then
   Prepara('')
  else begin
    Continua := False;
    btnOK.Caption := 'Iniciar'
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Tempo := Tempo+1;
  if tempo = 10 then begin
    TempoSalvar := TempoSalvar+1;
    Tempo := 0;
  end;

  if TempoSalvar = 2 then begin
    TempoSalvar := 0;
    if CheckBox4.Checked then Salvar := True;
  end;

  if CheckBox4.Checked then begin
    if Tempo in [ 3, 6, 9] then begin
      Memo1.Lines.Strings[0] := 'Senhas por segundo: '+inttostr(Contagem);
      Total := Total+contagem;
      Memo1.Lines.Strings[1] := 'Total: '+inttostr(Total);
    end;
   contagem := 0;
  end;
end;

procedure TForm1.SairClick(Sender: TObject);
begin
Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Continua := False;
Application.Terminate;
end;

procedure TForm1.Button2Click(Sender: TObject);
  var
   strs: TStringList;
   sPosicao : String;
begin
   strs:= TStringList.Create;
   strs.LoadFromFile(Path+'status.txt');
   Edit1.Text := strs.Strings[3];
   Edit2.Text := strs.Strings[4];
   sPosicao := strs.Strings[5];
   strs.Destroy;
   Prepara(sPosicao);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  salvar := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Path := extractFilePath(Application.ExeName);
end;

end.
