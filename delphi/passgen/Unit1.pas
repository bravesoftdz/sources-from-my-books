unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Spin;


const
     Caracteres : String = #0+#1+#13+#10+''''+'!@#$€¼£éÉËëÇçáÁÀàéÉèãÃõÕÏïŸÿœÂ¿ÐØ©~`-%^&*()_+|}{":?><,./;[]\=-';

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    btnDel: TButton;
    btnAdd: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Button3: TButton;
    Button4: TButton;
    ListBox2: TListBox;
    Label1: TLabel;
    Label3: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Label4: TLabel;
    LabelDir: TLabel;
    Label2: TLabel;
    LabelArq: TLabel;
    SpinEdit1: TSpinEdit;
    Label5: TLabel;
    LabelFim: TLabel;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    SpinEdit2: TSpinEdit;
    Bevel2: TBevel;
    CheckBox2: TCheckBox;
    Panel7: TPanel;
    Animate1: TAnimate;
    Label7: TLabel;
    LabelTotal: TLabel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    ContinuaLista : Boolean;
    contpalavra : Integer;
    Erros, ArquivoSaida : TStringList;
    Extensao : String;
     { Private declarations }
  public
         { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.Button1Click(Sender: TObject);
    procedure ListaDir(Diretorio:String);
      procedure VarreArquivo(Arquivo:String);
          procedure VarreLinha(Linha:String);
            procedure AdicionaPalavra(Palavra:String);
              function RemoveCaracter(Palavra:String):String;
              var
               Texto:String;
               Caracter:char;
               n : integer;
              begin
                Texto := Palavra;
                for n := 0 to length(Caracteres)-1 do begin
                  caracter := Caracteres[n];
                  while Pos(Caracter, Texto) > 0 do delete(Texto, Pos(Caracter, Texto), 1);
                end;
                Result := Texto
              end;
            var
             N : Integer;
             bNovo : Boolean;
             Saida: String;
            begin
              bNovo := True;
              if CheckBox1.Checked then
                Saida := lowercase(Palavra)
              else
                Saida := Palavra;
              if (Saida = '') then exit;

              // Apagando caracteres indesejaveis
              if not CheckBox2.Checked then Saida := trim(RemoveCaracter(Saida));

              if (Saida = '') or (length(Saida) <= SpinEdit2.Value) then exit;
              for n := 0 to ArquivoSaida.Count-1 do
                if (ArquivoSaida.Strings[n] = Saida) then begin
                  bNovo := False;
                  break;
                end;
              if bNovo then begin
                 ArquivoSaida.Add(Saida);
                 contpalavra := contpalavra+1;
              end;
            end;
          var
            Palavra, sTemp : String;
            nTemp : Integer;
          begin
            sTemp := Linha;
            while (sTemp <> '') do begin
              if Extensao = 'INI' then begin
                nTemp := pos('=',sTemp);
                if (nTemp = 0) then begin
                  Application.ProcessMessages;
                  palavra := sTemp;
                  sTemp := '';
                end
                else begin
                  Palavra := trim(copy(sTemp, 0, nTemp-1));
                  delete(sTemp,1,nTemp);
                end;
              end
              else begin
                nTemp := pos(' ',sTemp);
                if (nTemp = 0) then begin
                  Application.ProcessMessages;
                  palavra := sTemp;
                  sTemp := '';
                end
                else begin
                  Palavra := trim(copy(sTemp, 0, nTemp));
                  delete(sTemp,1,nTemp);
                end;
              end;
              if (length(Palavra) <= SpinEdit1.Value) then  AdicionaPalavra(Palavra);
            end;

          end;
      var
       fArquivo: textfile;
       Linha: String;
      begin
         try
           AssignFile(fArquivo, Arquivo);
           Reset(fArquivo);
           while not Eof(fArquivo) do begin
              Readln(fArquivo, Linha);
              Application.ProcessMessages;
              if (Linha <> '') then VarreLinha(Linha);
           end;
          CloseFile(fArquivo);
         except
           on E : Exception  do Erros.Add(Arquivo+' '+E.Message+' '+E.ClassName);
           end;
      end;

    var
      SR: TSearchRec;
      Arquivo, sTemp: String;
      nTemp, N : Integer;

    begin
      FindFirst(Diretorio+'\*.*', faAnyFile, SR);
      while not (Arquivo = SR.Name) and ContinuaLista do begin
          if (SR.Attr = faDirectory) or (SR.Attr = faDirectory+faHidden) or (SR.Attr = faDirectory+faSysFile) or (SR.Attr = faDirectory+faSysFile+faHidden) then begin
            if (SR.Name <> '.') and (SR.Name <> '..') and ContinuaLista then begin
            // Faz Recursividade em Diretórios

              if ((Sr.Name  <> '.') and (Sr.Name  <> '..') ) then
              try
                sTemp := concat(Diretorio,'\',Sr.Name);
                LabelDir.Caption := sTemp;
                ListaDir(sTemp);
              except      end;
              Application.ProcessMessages;
            end;
          end
          else  begin
            // Pega os Arquivos
            sTemp := concat(Diretorio,'\',Sr.Name);
            LabelArq.Caption := sTemp;
            LabelDir.Caption := Diretorio;
            nTemp := Length(sTemp);
            Extensao := uppercase(copy(sTemp, nTemp-2,nTemp));
            for n:= 0 to ListBox2.Items.Count -1 do
               if Extensao = ListBox2.Items.Strings[n] then
                 VarreArquivo(sTemp);

         end;
        Arquivo:=SR.Name;
        FindNext(SR);
      end;
    end;

var
 n : integer;
begin
  contpalavra := 0;
  ArquivoSaida := TStringList.Create;
  Erros := TStringList.Create;

  Animate1.Active := True;
  ContinuaLista := True;
  for n := 0 to ListBox1.Items.Count-1 do  begin
    ListaDir(ListBox1.Items.Strings[n]);
  end;
  ArquivoSaida.SaveToFile(ExtractFilePath(Application.ExeName)+'passwords.txt');
  Erros.SaveToFile(ExtractFilePath(Application.ExeName)+'Erros.txt');
  Animate1.Active := False;
  ArquivoSaida.Destroy;
  Erros.Destroy;
  LabelFim.Caption := '';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  LabelFim.Caption := 'Finalizando....';
  Animate1.Active := False;
  ContinuaLista := False;
end;

procedure TForm1.btnAddClick(Sender: TObject);
 var
  Caminho : String;
begin
  if InputQuery('Insira um caminho','Caminho ex: C:, C:\WINDOWS',Caminho) then ListBox1.Items.Add(Uppercase(Caminho));
end;

procedure TForm1.btnDelClick(Sender: TObject);
begin
  if (ListBox1.ItemIndex <> -1) then ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TForm1.Button4Click(Sender: TObject);
 var
  Caminho : String;
begin
  if InputQuery('Insira um caminho','Caminho ex: C:\',Caminho) then ListBox2.Items.Add(Uppercase(Caminho));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if (ListBox2.ItemIndex <> -1) then ListBox2.Items.Delete(ListBox2.ItemIndex);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   LabelTotal.Caption := inttostr(contpalavra);
end;

end.
