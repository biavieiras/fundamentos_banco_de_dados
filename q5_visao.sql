
-- questão 5
-- Criar uma visão materializada que tem como atributos o nome da playlist e a
-- quantidade de álbuns que a compõem.




create view playlist_qtde_albuns(nome_playlist, qtde_albuns)
with schemabinding
as
   select nome_playlist, count_big(cod_album) from playlist, faixa_playlist,
   faixa f, album a
   
   where cod_playlist = id_playlist and cod_faixa = f.id_faixa and f.codigo_album = a.cod_album
   group by nome_playlist


CREATE UNIQUE CLUSTERED INDEX I_playlist_qtde_albuns ON playlist_qtde_albuns (nome_playlist)