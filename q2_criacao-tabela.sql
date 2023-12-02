
-- Questão 02)
/*
As tabelas referentes aos conjuntos de playlists, faixas e de relacionamento entre
as duas devem ser alocadas no filegroup (tablespace), definido com apenas um
arquivo. As outras tabelas devem ser alocadas no filegroup com dois arquivos.
*/

/*
playlist
composição
Período musical
interprete

gravadora
telefone
compositor

Álbum

Faixa

faixa_inteprete
faixa_playlist
faixa_compositor
*/


-- bia
create table playlist
(
	cod_playlist int not null,
	nome_playlist nvarchar(50) not null,
	dt_criacao date not null,

	tempo_exec varchar(10),
	constraint PK_playlist primary key (cod_playlist)
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

--bia
create table periodo_musical
(
	cod_pm smallint not null,
	descricao_pm nvarchar(20) not null,
	intervalo varchar(20),
	constraint PK_pm primary key (cod_pm),
	constraint CK_descricao_pm check (descricao_pm in ('idade média','renascença', 'barroco', 'clássico', 'romântico', 'moderno'))

) on spotper_fg02

--bruna
create table interprete
(
	cod_interprete smallint not null,
	nome_interprete nvarchar(50) not null,
	tipo_interprete nvarchar(10) not null,
	constraint CK_tipo_interprete check(tipo_interprete in ('orquestra', 'trio', 'quarteto', 'ensemble', 'soprano', 'tenor')),
	constraint PK_cod_interprete primary key (cod_interprete)
) on spotper_fg02

/*****************************************************************************************/


--gui
create table gravadora
(
cod_gravad smallint not null,
nome nvarchar(100) not null,
cep varchar(11),
cidade nvarchar(50),
rua nvarchar(100),
end_site varchar(200),

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
	constraint FK_compositor foreign key (cod_periodo_mus) references periodo_musical 
	(cod_pm) on delete no action on update cascade
) on spotper_fg02


/*****************************************************************************************/


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
	  meio_fisico varchar(8) not null,
	  qtde_disco smallint not null,

    CONSTRAINT cod_album_PK PRIMARY KEY (cod_album),
      

	CONSTRAINT album_FK_gravadora FOREIGN KEY (cod_gravadora)

  REFERENCES gravadora (cod_gravad)  ON UPDATE CASCADE ON DELETE NO ACTION,

	CONSTRAINT data_gravacao_CK CHECK  (dt_gravacao> '2000-01-01'),

	CONSTRAINT meio_fisico_CK CHECK (meio_fisico IN ('CD', 'vinil', 'download')),

	constraint tipo_compra_CK check (tipo_compra in ('cartão', 'dinheiro', 'pix'))

) on spotper_fg02



/*****************************************************************************************/

create table faixa
(
id_faixa int not null,
descricao_faixa nvarchar(100) not null,
num_faixa smallint not null,
tipo_gravacao char(3) , -- DDD OU ADD
dt_ult_tocada date not null,
vezes_tocada smallint not null,
tempo_execucao varchar(10) not null, 
codigo_composicao smallint not null,
codigo_album smallint not null,
num_disco smallint,

constraint PK_id_faixa_album primary key NONCLUSTERED (id_faixa),

--caso algum erro ocorra relacionado a pk de faixa, se atentar a essa constraint
CONSTRAINT un_num_faixa UNIQUE (id_faixa, num_faixa), 

constraint CK_tempo_execucao CHECK (cast(tempo_execucao as dec(4,2))>0.0),

constraint FK_cod_composicao foreign key(codigo_composicao) references composicao(cod_composicao)
on delete no action on update cascade, 

constraint FK_cod_album foreign key(codigo_album) references album(cod_album)
on delete cascade on update cascade

) on spotper_fg01


/*****************************************************************************************/


--bruna
create table faixa_interprete
(
id_interprete smallint not null,
cod_faixa int not null,

constraint PK_cod_interprete_faixa primary key (id_interprete,cod_faixa),

constraint FK_cod_faixainterprete foreign key (id_interprete) 
references interprete (cod_interprete) on UPDATE CASCADE ON DELETE NO ACTION,

constraint FK_num_faixainterprete foreign key (cod_faixa) 
references faixa (id_faixa) on UPDATE CASCADE ON DELETE NO ACTION
) on spotper_fg02

--bia
create table faixa_compositor
(
	cod_faixa int not null,
	id_compositor smallint not null,
    constraint PK__faixa_compositor primary key (cod_faixa, id_compositor),
	
	constraint FK_faixa_faixacompositor foreign key(cod_faixa) references faixa(id_faixa)
	on delete no action on update cascade,
	constraint FK_compositor_faixacompositor foreign key(id_compositor) references compositor(cod_compositor)
	on delete no action on update cascade
) on spotper_fg02

--bia
create table faixa_playlist 
(
	id_playlist int not null,
	cod_faixa int not null,

    constraint PK_faixa_playlist primary key (id_playlist,cod_faixa),
	
	constraint FK_cod_playlist foreign key(id_playlist) references playlist(cod_playlist)
	on delete no action on update cascade,

	constraint FK_cod_faixa foreign key(cod_faixa) references faixa(id_faixa)
	on delete no action on update cascade
) on spotper_fg01








