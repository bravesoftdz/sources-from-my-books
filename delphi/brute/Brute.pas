unit Brute;
{
Brute by Master_Zion
}
interface
const
numeros: String = '0123456789';
strMinuscula: String = 'abcdefghijklmnopqrstuvwxzy';
strMaiuscula: String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

function BruteForce(Caracteres, Posicao:String):String;




implementation

function BruteForce(Caracteres, Posicao:String):String;
var
I, N , N2: Integer;
V1:Boolean;
S:String;

function Ultima(Letras:String):String;
begin
Result:=copy(Letras, Length(Letras), 1);
end;

begin
  V1:=False;
  N:=1;
  S:='';
  while not V1 do begin
   if copy(Posicao, N-1, 1) <> Ultima(Caracteres)then begin
    I:=pos(Copy(Posicao, N-1, 1), Caracteres);
    Result:=copy(Posicao, 1, N-1)+Copy(Caracteres,I+1,1)+copy(Posicao, N+1,Length(Caracteres));
    V1:=True;
   end;

   if copy(Posicao, N-1, 1) = Ultima(Caracteres) then begin
     if copy(Posicao, N+1, 1) <> Ultima(Caracteres) then begin
       for N2 := 0 to N-1 do Result:=Result+Copy(Caracteres,0,1);
       I:=pos(Copy(Posicao, N+1, 1), Caracteres);
       Result:=Result+Copy(Caracteres,I+1,1)+copy(Posicao, N+2,Length(Caracteres));
       V1:=True;
     end;


      for N2 := 1 to Length(Posicao) do begin
       S:=S+Ultima(Caracteres);
      end;

       if (Caracteres = S) then begin
         for N2 := 0 to Length(Posicao)+1 do begin
            Result:=Result+Copy(Caracteres,0,1);
         end;
         V1:=True;
       end;
   end;
    N:=N+1;
  end;
end;

end.
