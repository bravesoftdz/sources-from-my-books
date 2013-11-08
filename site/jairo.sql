CREATE TABLE `tbusuario` (
  `nIDUsuario` SMALLINT  NOT NULL AUTO_INCREMENT,
  `sLogin` varchar(10)  NOT NULL,
  `sSenha` varchar(35)  NOT NULL,
  `sNomeUsuario` varchar(35)  NOT NULL,
  PRIMARY KEY(`nIDUsuario`)
)
ENGINE = MYISAM;

insert into tbusuario (sNomeUsuario, sLogin , sSenha) 
values ('Usuario Master', 'master',md5('minha senha') );



CREATE TABLE tbfornecedor (
  nIDFornecedor SMALLINT  NOT NULL AUTO_INCREMENT,
  sNomeFornecedor varchar(35)  NOT NULL,
  sEnderecoFornecedor varchar(60)  NOT NULL,
  nBanco numeric(3) ,
  nAgencia numeric(6) ,
  nConta numeric(10) ,
  PRIMARY KEY(nIDFornecedor)
)
ENGINE = MYISAM;



insert into tbfornecedor (
  sNomeFornecedor,
  sEnderecoFornecedor,
  nBanco ,
  nAgencia,
  nConta 
) 
values (
  'Fornecimento de Produtos  Eletronicos  Ltda ',
  'R. dos sumidos, 0 ',
  409,
  0477,
  00111141
);


insert into tbfornecedor (
  sNomeFornecedor,
  sEnderecoFornecedor,
  nBanco ,
  nAgencia,
  nConta 
) 
values (
  'Sisco no Olho SA',
  'R. dos sumidos, 0 ',
  409,
  0477,
  00111141
);
