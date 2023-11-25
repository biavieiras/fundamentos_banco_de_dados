

-- 1ª questão
/*
o banco de dados
deve possuir três filegroups (tablespaces) e o arquivo de log. O filegroup primário
deve conter apenas o arquivo primário do banco de dados. Um segundo filegroup
deve conter dois arquivos e um terceiro deve conter apenas um arquivo. 

*/

create database SpotPerTest
on
	--fg primario contem apenas o arquivo primario do bd
	primary
	(
	name = 'SpotPer',
	filename = 'D:\SpotPerTest\spotper.mdf',
	size = 5120KB,
	filegrowth = 15%
	),

	--fg com somente um arquivo
	filegroup spotper_fg01
	(
	name = 'spotper_001',
	filename = 'D:\SpotPerTest\spotper_001.ndf',
	size = 1024KB,
	filegrowth = 15%
	),

	--fg com dois arquivos
	FILEGROUP spotper_fg02
	(
	NAME = 'spotper_002',
	filename = 'D:\SpotPerTest\spotper_002.ndf',
	size = 1024KB,
	filegrowth = 15%
	),

	(
	NAME = 'spotper_003',
	FILENAME = 'D:\SpotPerTest\spotper_003.ndf',
	SIZE = 1024KB,
	FILEGROWTH = 15%
	)

	log on --*verificar em qual filegroup colocar o log
	(
	name = 'spotper_log',
	filename = 'D:\SpotPerTest\spotper_log.ldf',
	size = 1024KB,
	filegrowth = 15%
	)
