
-- 3 filegroups
/* 

**O filegroup primário deve conter apenas o arquivo primário 
do banco de dados. 

**Um segundo filegroup deve conter dois arquivos e um terceiro 
deve conter apenas um arquivo.

**playlists, faixas e de relacionamento entre as duas devem ser 
alocadas no filegroup (tablespace), definido com apenas um
arquivo.


-- faixas do album x: fazer uma visao, usar o union
-- delete on cascade: sempre que deletar as faixas tem q deletar o album

*/

--1ª questão
create database SpotPer
on
	--fg primario contem apenas o arquivo primario do bd
	primary
	(
	name = 'SpotPer',
	filename = 'C:\FBD\SpotPer\spotper.mdf',
	size = 5120KB,
	filegrowth = 15%
	),

	--fg com somente um arquivo
	filegroup spotper_fg01
	(
	name = 'spotper_001',
	filename = 'D:\FBD\SpotPer\spotper_001.ndf',
	size = 1024KB,
	filegrowth = 15%
	)

	--fg com dois arquivos
	FILEGROUP spotper_fg02
	(
	NAME = 'spotper_002',
	filename = 'D:\FBD\SpotPer\spotper_002.ndf',
	size = 1024KB,
	filegrowth = 15%
	),

	(
	NAME = 'spotper_003',
	FILENAME = 'D:\FBD\SpotPer\spotper_003.ndf',
	SIZE = 1024KB,
	FILEGROWTH = 15%
	)

	log on --*verificar em qual filegroup colocar o log
	(
	name = 'spotper_log',
	filename = 'D:\FBD\SpotPer\spotper_log.ldf',
	size = 1024KB,
	filegrowth = 15%
	)


-- bia
create table playlist
(
cod_playlist int not null,
nome_playlist nvarchar(50) not null,
dt_criacao date not null,
----provavelmente errado-------
tempo_exec dec(10,10),
----------------------------
constraint PK_playlist primary key (cod_playlist)
) on spotper_fg01

--bia
create table periodo_musical
(
cod_pm smallint not null,
descricao_pm nvarchar(100) not null,
intervalo varchar(20),
constraint PK_cod_pm primary key (cod_pm)
) on spotper_fg02

--bruna
create table faixa
(

) on spotper_fg01


--bia
create table faixa_playlist 
(
id_playlist int not null,
cod_faixa not null,
constraint FK_cod_playlist foreign key(id_playlist) references playlist(cod_playlist)
on delete no action on update cascade
constraint FK_cod_faixa foreign key(cod_faixa) references playlist(num_faixa)
on delete no action on update cascade
) on spotper_fg01


--bruna
create table composicao 
(
cod_composicao smallint not null,
descricao_compos nvarchar(200) not null,
tipo_composicao varchar(10) not null

constraint PK_composicao primary key (cod_composicao)
constraint CK_tipo_composicao check (tipo_composicao in ('sinfonia', 'opera', 'sonata', 'concerto'))

) on spotper_fg02


--bruna
create table interprete
(
cod_interprete smallint not null,
nome_interprete nvarchar(50) not null,
tipo_interprete nvarchar(10) not null

constraint PK_cod_interprete check(cod_interprete in ('orquestra', 'trio', 'quarteto', 'ensemble', 'soprano', 'tenor'))

) on spotper_fg02


--bruna
create table faixa_interprete
(
cod_interprete smallint not null,
num_faixa smallint not null

constraint FK_cod_interprete foreign key (cod_interprete) 
references interprete (cod_interprete)

constraint FK_num_faixa foreign key (num_faixa)
references faixa (num_faixa)

)


--gui
create table gravadora
(
cod_gravad smallint not null,
nome nvarchar(100) not null,
cep varchar(11),
cidade nvarchar(50),
rua nvarchar(100),
end_site varchar(200)

CONSTRAINT gravadora_PK primary key (cod_gravad)

) on spotper_fg02


create table telefone 
(
    fone varchar(10) not null,
    tipo_fone varchar(50) not null 
    cod_gravadora smallint not null,
    
    CONSTRAINT fone_PK PRIMARY KEY (fone)

    CONSTRAINT telefone_CK CHECK (tipo_telefone IN ('celular', 'fixo'))
    
    CONSTRAINT telefone_FK_gravadora FOREIGN KEY (cod_gravadora)
    REFERENCES gravadora (cod_gravad)  ON UPDATE cascade ON DELETE CASCADE

    
) on spotper_fg02


create table album
(
    cod_album smallint not null,
    descricao_album nvarchar(150) not null,
    nome nvarchar(50) not null,
    tipo_compra nvarchar(50) not null,
    pr_compra decimal(7,2) not null,
    dt_compra date not null,
    dt_gravacao date not null,
    

    CONSTRAINT cod_album_PK PRIMARY KEY (cod_album)


) on spotper_fg02



