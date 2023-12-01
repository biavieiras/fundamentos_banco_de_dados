


--Inserção Composição
INSERT INTO composicao (cod_composicao, descricao_compos, tipo_composicao)
VALUES
    (1, 'Sinfonia nº 1', 'sinfonia'),
    (2, 'Ópera "Carmen"', 'opera'),
    (3, 'Sonata para Piano em Dó Maior', 'sonata'),
    (4, 'Concerto para Violino em Ré Menor', 'concerto'),
    (5, 'Sinfonia nº 5', 'sinfonia'),
    (6, 'Ópera "A Flauta Mágica"', 'opera');


INSERT INTO composicao (cod_composicao, descricao_compos, tipo_composicao)
VALUES
    (7, 'Opera nº 2', 'opera')

------------------------------------------------------------------------------
-- Inserção Período Musical
INSERT INTO periodo_musical (cod_pm, descricao_pm, intervalo)
VALUES
    (1, 'idade média', '500 - 1400'),
    (2, 'renascença', '1400 - 1600'),
    (3, 'barroco', '1600 - 1750'),
    (4, 'clássico', '1730 - 1820'),
    (5, 'romântico', '1815 - 1910'),
    (6, 'moderno', '1890 - 1975')
    

-----------------------------------------------------------------------------------
-- Interprete:
INSERT INTO interprete (cod_interprete, nome_interprete, tipo_interprete)
VALUES
    (1, 'Orquestra Sinfônica', 'orquestra'),
    (2, 'Trio de Cordas', 'trio'),
    (3, 'Quarteto de Sopros', 'quarteto'),
    (4, 'Ensemble de Jazz', 'ensemble'),
    (5, 'Soprano Solo', 'soprano'),
    (6, 'Tenor Solo', 'tenor')




----------------------------------------------------------------------------------------------------------------------------------
-- Gravadora:

INSERT INTO gravadora (cod_gravad, nome, cep, cidade, rua, end_site)
VALUES
    (1, 'Gravadora Clássica', '12345-678', 'Cidade A', 'Rua A', 'http://www.gravadora-classica.com'),
    (2, 'Gravadora Jazz Masters', '54321-876', 'Cidade B', 'Rua B', 'http://www.gravadora-jazz.com'),
    (3, 'Estúdio Pop Hits', '98765-432', 'Cidade C', 'Rua C', 'http://www.estudio-pop.com'),
    (4, 'Selo Independente', '11111-222', 'Cidade D', 'Rua D', 'http://www.selo-independente.com');
--------------------------------------------------------------------------------------------------------------------------------
-- Telefones Gravadora:
INSERT INTO telefone (fone, tipo_fone, cod_gravadora)
VALUES
    ('1234567890', 'celular', 1),
    ('9876543210', 'fixo', 2),
    ('5551112233', 'celular', 3),
    ('4442223333', 'fixo', 4);


-------------------------------------------------------------------------------------------------------------------------------

-- Album:

INSERT INTO album (cod_album, descricao_album, nome, tipo_compra, pr_compra, dt_compra, dt_gravacao, cod_gravadora, meio_fisico, qtde_disco)
VALUES
  --  (1, 'Álbum Clássico 1', 'Artista Clássico', 'cartão', 50.00, '2023-01-10', '2022-12-01', 1, 'CD', 1),
  --  (2, 'Jazz Masters Collection', 'Jazz Band', 'dinheiro', 35.99, '2023-02-15', '2022-11-15', 2, 'vinil', 2),
  --  (3, 'Pop Hits Volume 1', 'Pop Stars', 'pix', 25.50, '2023-03-20', '2023-01-20', 3, 'download', 0),
   -- (4, 'Indie Rock Anthems', 'Indie Rockers', 'cartão', 40.00, '2023-04-25', '2022-10-05', 4, 'CD', 2),
	(23, 'Heavy Metal Anthems', 'Heavy Rockers', 'cartão', 135.00, '2023-07-25', '2022-10-05', 3, 'CD', 9)

	select * from album
-------------------------------------------------------------------------------------------------------------------------------
-- Faixa
insert into faixa values 
(178, 'Faixa 1', 1, 'DDD', '2023-01-01', 10, '3.30', 1, 1, 1),
(256, 'Faixa 2', 2, 'ADD', '2023-02-15', 8, '4.15', 2, 1, 1),
(34, 'Faixa 3', 3, 'DDD', '2023-03-22', 12, '2.45', 3, 4, 2),
(41, 'Faixa 4', 4, 'ADD', '2023-04-10', 15, '5.00', 4, 4, 2),
(53, 'Faixa 5', 5, null, '2023-05-05', 20, '3.10', 5, 2, 1),
(64, 'Faixa 6', 6, null, '2023-06-18', 18, '4.50', 6, 2, 2),
(73, 'Faixa 7', 7, 'DDD', '2023-07-30', 14, '3.25', 5, 4, 2),
(85, 'Faixa 8', 8, 'ADD', '2023-08-12', 16, '4.30', 3, 4, 1),
(93, 'Faixa 9', 9, 'DDD', '2023-09-25', 22, '2.55', 2, 4, 2),
(10, 'Faixa 10', 10, 'ADD', '2023-10-10', 25, '5.15', 1, 4, 1)
insert into faixa values 
--(300, 'A lua Me traiu', 1, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(301, 'Talking to the moon', 2, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(302, 'One', 5, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(303, 'Adventure of a lifetime', 6, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(304, 'Yellow', 11, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(305, 'Por ande Andei', 12, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(306, 'Piratas  do Caribe', 13, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(307, 'Pra você guardei o amor', 14, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(308, 'Rolling in the deep', 15, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(309, 'Yellow Submarine', 16, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(310, 'Michelle', 17, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(311, 'I dont care', 18, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(312, 'Hey joe', 19, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(313, 'Pescador De Ilusões', 20, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(314, 'Samurai', 21, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(315, 'Sina', 22, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(316, 'Leãozinho', 23, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(317, 'Sozinho', 24, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(318, 'Várias Queixas', 25, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(319, 'Esquadros', 26, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),

--(307, 'Pra você guardei o amor', 14, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(308, 'Rolling in the deep', 15, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(309, 'Yellow Submarine', 16, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(310, 'Michelle', 17, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(311, 'I dont care', 18, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(312, 'Hey joe', 19, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(313, 'Pescador De Ilusões', 20, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(314, 'Samurai', 21, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(315, 'Sina', 22, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(316, 'Leãozinho', 23, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(317, 'Sozinho', 24, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(318, 'Várias Queixas', 25, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(319, 'Esquadros', 26, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(320, 'Pra você guardei o amor', 50, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(321, 'Rolling in the deep', 51, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(322, 'Yellow Submarine', 52, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(323, 'Michelle', 53, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(324, 'I dont care', 54, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(325, 'Hey joe', 55, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(326, 'Pescador De Ilusões', 56, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(327, 'Samurai',57, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(328, 'Sina', 58, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(329, 'Leãozinho', 59, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(330, 'Sozinho', 60, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(331, 'Várias Queixas', 61, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(332, 'Esquadros', 62, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(333, 'Creep', 63, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
--(334, 'Dust in the wind', 64, 'ADD', '2023-11-10', 2, '2.15', 1, 4, 1),
(200, 'Borboletas', 27, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(201, 'Send Me An Angel', 28, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(202, 'All I Want for Christmas Is You', 29, 'DDD', '01-12-2023', 0, '3.15', 3, 4, 2),
(203, 'Voulez-Vous', 29, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(204, 'Like You Do', 30, 'DDD', '01-12-2023', 0, '3.15', 4, 4, 2),
(205, 'Minha Felicidade', 31, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(206, 'De Janeiro a Janeiro', 32, 'DDD', '01-12-2023', 0, '3.15', 5, 4, 2),
(207, 'Back On 74', 33, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(208, 'Oceano', 34, 'DDD', '01-12-2023', 0, '3.15', 3, 4, 2),
(210, '7 rings', 35, 'ADD', '01-12-2023', 0, '3.15', 1, 4, 2),
(211, 'Amor Puro', 36, 'DDD', '01-12-2023', 0, '3.15', 5, 4, 2),
(212, 'Never Say Never', 37, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(213, 'Se Eu Não Te Amasse Tanto Assim', 38, 'ADD', '01-12-2023', 0, '3.15', 3, 4, 2),
(214, 'I Dont Want to Miss a Thing', 39, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(215, 'Lay All Your Love On Me', 40, 'DDD', '01-12-2023', 0, '3.15', 5, 4, 2),
(209, 'Bailando', 41, 'ADD', '01-12-2023', 0, '3.15', 1, 4, 2),
(216, 'Die For You', 42, 'DDD', '01-12-2023', 0, '3.15', 3, 4, 2),
(217, 'Sparks', 43, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(218, 'Pretty Please', 44, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(219, 'Vento no Litoral', 45, 'DDD', '01-12-2023', 0, '3.15', 5, 4, 2),
(220, 'November Rain', 46, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(221, 'Princess of China', 47, 'ADD', '01-12-2023', 0, '3.15', 1, 4, 2),
(222, 'Livin On A Prayer', 48, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2),
(223, 'Mamado', 49, 'DDD', '01-12-2023', 0, '3.15', 1, 4, 2)


-------------------------------------------------------------------------------------------------------------------------------
--Compositor:
-- Inserindo dados na tabela compositor
insert into compositor values 
(678, 1, 'João Silva', '1980-05-15', NULL, 'Rio', 'Brasil'),
(46, 2, 'Maria Oliveira', '1975-09-20', '2022-03-10', 'São Paulo', 'Brasil'),
(34, 3, 'Antônio Santos', '1990-12-03', NULL, 'Paris', 'França'),
(434, 3, 'Isabel Rocha', '1988-07-28', '2021-01-05', 'Salvador', 'Brasil'),
(80, 5, 'Pedro Costa', '1972-01-10', NULL, 'Recife', 'Brasil'),
(67, 6, 'Ana Pereira', '1985-06-22', NULL, 'Porto ', 'Portugal'),
(72, 3, 'Carlos Lima', '1995-11-17', NULL, 'Curitiba', 'Brasil'),
(88, 4, 'Marta Souza', '1982-04-12', '2020-08-08', 'Fortaleza', 'Brasil');



-------------------------------------------------------------------------------------------------------------------------------
-- faixa_compositor:
insert into faixa_compositor values
(41, 434)
( 73,88),
( 41,88),
( 53,88),
( 10,88)