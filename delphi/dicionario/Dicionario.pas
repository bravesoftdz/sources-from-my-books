unit Dicionario;
{
Dicionario by Master_Zion
}
interface
uses SysUtils;
  function AbreDicionario(Arquivo:String):String;
  function FechaDicionario:String;
  function LocalizarProxima(var Proxima:String):String;
  function LocalizarPalavra(const Palavra:String):String;

const mzOK :String='ok';  
var
  fArquivo : TextFile;

implementation


function IniciaArquivo:String;
begin
 result := 'Erro desconhecido';
   try
     Reset(fArquivo);
     result := mzOK;
   except
     on E : Exception  do  Result:= 'ERRO!!!  '+E.Message;
   end;
end;

function AbreDicionario(Arquivo:String):String;
begin
 if FileExists(Arquivo) then begin
   AssignFile(fArquivo, Arquivo);
   Result := IniciaArquivo;
 end
 else
   result := 'Arquivo não encontrado!!!';
end;

function FechaDicionario:String;
begin
 result := 'Erro desconhecido';
   try
      Close(fArquivo);
     result := mzOK;
   except
     on E : Exception  do  Result:= 'ERRO!!!  '+E.Message;
   end;
end;


function LocalizarProxima(var Proxima:String):String;
begin
   if Eof(fArquivo) then begin
     Proxima := '';
     result := 'EOF';
     exit;
   end;
   Readln(fArquivo, Proxima);
   Result := mzOK;
end;

function LocalizarPalavra(const Palavra:String):String;
var
 s, Linha : String;
begin
   s := IniciaArquivo;
   if (s <> mzOK) then begin
     Result := s;
     exit;
   end;

   while (Linha <> Palavra) do begin
     if Eof(fArquivo) then begin
       result := 'EOF';
       exit;
     end;
     Readln(fArquivo, Linha);
   end;
end;

end.
