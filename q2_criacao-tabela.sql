
-- Questão 02)
/*
As tabelas referentes aos conjuntos de playlists, faixas e de relacionamento entre
as duas devem ser alocadas no filegroup (tablespace), definido com apenas um
arquivo. As outras tabelas devem ser alocadas no filegroup com dois arquivos.
*/
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

-- bia
create table compositor
(
	cod_compositor smallint not null,
	cod_periodo_mus smallint not null,
	nome_compositor nvarchar(50) not null,
	data_nasc date,
	data_morte date,
	cidade_nasc nvarchar(10),
	pais_nasc nvarchar(10),
	constraint PK_compositor primary key (cod_compositor),
	constraint FK_compositor (cod_periodo_mus) references periodo_musical (cod_pm) on delete no action on update cascade
) on spotper_fg02

--bia
create table periodo_musical
(
	cod_pm smallint not null,
	descricao_pm nvarchar(20) not null,
	intervalo varchar(20),
	constraint PK_pm primary key (cod_pm),
	constraint CK_descricao_pm check (descricao_pm in (('idade média',
	'renascença', 'barroco', 'clássico', 'romântico', 'moderno')))
) on spotper_fg02

--bruna
create table faixa
(
num_faixa int not null,
descricao_faixa nvarchar(100) not null,
tipo_gravacao nvarchar(3) not null,
dt_ult_tocada date not null,
vezes_tocada smallint not null,
tempo_execucao int not null, /*analisar o tipo de dado*/
codigo_composicao smallint not null

constraint PK_num_faixa primary key(num_faixa),
constraint FK_cod_composicao foreign key(codigo_composicao) references composicao(cod_composicao)
on delete cascade on update cascade /*analisar o on delete cascade*/

) on spotper_fg01

--bia
create table faixa_compositor
(
	numero_faixa int not null,
	codigo_compositor smallint not null,
    constraint PK_faixa_faixacompositor primary key (numero_faixa),
	constraint PK_compositor_faixacompositor primary key (codigo_compositor),
	constraint FK_faixa_faixacompositor foreign key(numero_faixa) references playlist(cod_playlist)
	on delete no action on update cascade,
	constraint FK_compositor_faixacompositor foreign key(codigo_compositor) references compositor(cod_compositor)
	on delete no action on update cascade
) on spotper_fg02

--bia
create table faixa_playlist 
(
	id_playlist int not null,
	cod_faixa int not null,
    constraint PK_id_playlist primary key (id_playlist),
	constraint PK_cod_faixa primary key (cod_faixa),
	constraint FK_cod_playlist foreign key(id_playlist) references playlist(cod_playlist)
	on delete no action on update cascade,
	constraint FK_cod_faixa foreign key(cod_faixa) references playlist(num_faixa)
	on delete no action on update cascade
) on spotper_fg01


--bruna
create table composicao 
(
	cod_composicao smallint not null,
	descricao_compos nvarchar(200) not null,
	tipo_composicao varchar(50) not null,
	constraint PK_composicao primary key (cod_composicao),
	constraint CK_tipo_composicao check (tipo_composicao in ('sinfonia', 'opera', 'sonata', 'concerto'))
) on spotper_fg02


--bruna
create table interprete
(
	cod_interprete smallint not null,
	nome_interprete nvarchar(50) not null,
	tipo_interprete nvarchar(10) not null,
	constraint PK_cod_interprete check(cod_interprete in ('orquestra', 'trio', 'quarteto', 'ensemble', 'soprano', 'tenor')),
) on spotper_fg02


--bruna
create table faixa_interprete
(
cod_interprete smallint not null,
num_faixa smallint not null,

constraint PK_cod_interprete primary key (cod_interprete),

constraint PK_num_faixa primary key (num_faixa),

constraint FK_cod_interprete foreign key (cod_interprete) 
references interprete (cod_interprete),

constraint FK_num_faixa foreign key (num_faixa)
references faixa (num_faixa)

) on spotper_fg02


/*
--bruna
create table meio_faixa
(
	id_meio_fis smallint not null,
	numero_faixa int not null,

	constraint PK_id_meio_fis primary key (id_meio_fis),
	constraint PK_numero_faixa primary key(numero_faixa),
	constraint FK_meio_fis_meiofaixa (id_meio_fis) references 
) on spotper_fg02
*/


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
    tipo_fone varchar(50) not null ,
    cod_gravadora smallint not null,
    
    CONSTRAINT fone_PK PRIMARY KEY (fone),

    CONSTRAINT telefone_CK CHECK (tipo_fone IN ('celular', 'fixo')),
    
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
    cod_gravadora smallint not null,
		meio_fisico nvarchar(8) not null,

    CONSTRAINT cod_album_PK PRIMARY KEY (cod_album),
      
	  -- Talvez seja melhor criar um gatilho para esse check
    CONSTRAINT album_CK_faixas CHECK ((SELECT COUNT(num_faixa) from Faixa ) <= 64),

		CONSTRAINT album_FK_gravadora FOREIGN KEY (cod_gravadora)
    REFERENCES gravadora (cod_gravad)  ON UPDATE cascade ON DELETE NO ACTION,

		CONSTRAINT data_gravacao_CK CHECK  (dt_gravacao> '2000-01-01'),

		CONSTRAINT meio_fisico_CK CHECK (meio_fisico IN ('CD', 'vinil', 'download'))

) on spotper_fg02