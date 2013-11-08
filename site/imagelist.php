<?php   
 include("Image/Remote.php");
 include("cima.php");



 $phpfile = "php/index.php"; 
 $topdir = "/var/www/";
 $phpfile = "php/imagelist.php";
 $ls = "ls ";
 $cmd = $ls . $topdir . $pasta;
 $ultimo = exec($cmd, $arquivos);

 echo "<center><font size='+1'>Minhas imagens legais</font></center><br><br>";
 
 if ($pasta <> "") {
    echo "Exibindo (" . $pasta  . ")<br><hr>";
 }  else {
    echo "Exibindo (/)<br><hr>";
 } 


 echo "<table border=0>";
 for($n=0; $n < count($arquivos); $n++) {
   echo "<tr>";

   if (is_dir( $topdir . $pasta  . "/" .  $arquivos[$n])) {
      echo "<td><img src='/icons/dir.gif'></td>";
      echo "<td><a href='http://localhost:80/" . $phpfile. "?pasta=" . $pasta . "/" . $arquivos[$n] . "'>";
      echo $arquivos[$n];
      echo "</a></td><td></td>";

   } else {

   
      // Obtem o tamanho da imagem.
      $url = "http://localhost:80" . $pasta . "/" . $arquivos[$n];
      $i = new Image_Remote($url);
      if (PEAR::isError($i)) {
        echo "<td><img src='/icons/f.gif'> </td><td>" . $arquivos[$n] . "</td><td></td>" ;  
    } else {
         echo "<td><img src='/icons/image2.gif'></td>";
         echo "<td><a href='" . $url . "'>" . $arquivos[$n] . "</a></td>";
         $Tamanho = $i->getImageSize();
         echo "<td>" . $Tamanho[0] . "x" . $Tamanho[1] . "</td>";
      }
      
   }

     echo "</tr>\n"; 
 }
 echo "</table>";


include("baixo.php");

?>

