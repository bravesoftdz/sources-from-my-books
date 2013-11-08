<?php
include("cima.php");



$db = "jairo";
$user = "root";
$pass = "";
$host = "localhost";

$bd = "tbusuario";
mysql_connect($host,$user,$pass);
mysql_select_db($db);

$nome=$_REQUEST["nome"];
$senha=$_REQUEST["senha"];

$sForm='<form action="restrito.php" method="get" target="_self">
Usuario<br>
<input name="nome" type="text"> <br>

Senha<br>
<input name="senha" type="password"><br>

Cliente<br>
<input name="cliente" type="text"><br>

<br>
<input type="submit" name="Submit" value="Verificar">
</form>
<br>
<br>
';

$bDebug=False;


if (($nome == '') or ($senha == '') )
{
  echo ($sForm);
}
else
{
  $squery="select nIDUsuario  from tbusuario where sLogin = '$nome' and sSenha = md5('$senha') ";

  if ( $bDebug ) {    $sForm=$sForm . $squery ; }

  $query = mysql_query($squery);
  $row_data = mysql_fetch_object($query);

  $nIDUsuario =  $row_data->nIDUsuario;

  if ( !$nIDUsuario )
  {
   echo ('<br> Usuario ou senha invalida!<br>');
   echo ($sForm);
  } else {
   if ( $bDebug ) {echo   ($squery) . "<br>"; }
   $squery="select sNomeUsuario from tbusuario where nIDUsuario = " . $nIDUsuario;


   $query = mysql_query($squery);
   $row_data = mysql_fetch_object($query);

   echo "<br> Bem vindo <h1>" . $row_data->sNomeUsuario . "</h1> <br> ";
   if ( $bDebug ) {echo   ($squery) . "<br>"; }



   $cliente=$_REQUEST["cliente"];

   $squery="select * from tbfornecedor where sNomeFornecedor like '" . $cliente  . "%'";
   $query = mysql_query($squery);

   if (!$query) {
      die('Invalid query: ' . mysql_error());
   }
   if ( $bDebug ) {echo   ($squery) . "<br>"; }



   $num_col = mysql_num_fields($query);
   echo "<table border=size=1>" ;
   echo "<tr>" ;

   for ($col=0;$col<$num_col;$col++) {
     echo "<td>" .  mysql_field_name($query, $linha) . "</td>" ;
   }
   echo "</tr>" ;


   $row_data = mysql_fetch_array($query);
   $num_row  = mysql_num_rows($query);
  for ($row=0;$row<$num_row;$row++) {
      echo "<tr>" ;
      for ($col=0;$col<$num_col;$col++) {
        echo "<td>" .  $row_data[$col] . "</td>" ;
      }  // for col
      echo "</tr>" ;
      $row_data=mysql_fetch_array($query);
  }


   echo "</table>" ;


  } // if usuario


} // nome e senha

include("baixo.php");
?>