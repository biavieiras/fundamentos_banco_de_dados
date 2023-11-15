
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

) on spotper_fg01

--bruna
create table faixa
(

) on spotper_fg01

--bia
create table faixa_playlist 
(

) on spotper_fg01


--bruna
create table composicao 
(
cod_composicao smallint not null,
descricao_compos  
) on spotper_fg02




--gui
create table gravadora
(
cod_gravad smallint not null



) on spotper_fg02