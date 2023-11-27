
-- questão 5
-- Criar uma visão materializada que tem como atributos o nome da playlist e a
-- quantidade de álbuns que a compõem.



alter view playlist_qtde_albuns(nome_playlist, qtde_albuns)
with schemabinding
as
   select nome_playlist, count_big(*) from dbo.playlist, dbo.faixa_playlist,
   dbo.faixa f, dbo.album a
   
   where cod_playlist = id_playlist and cod_faixa = f.id_faixa and f.codigo_album = a.cod_album
   group by nome_playlist


CREATE UNIQUE CLUSTERED INDEX I_playlist_qtde_albuns ON playlist_qtde_albuns (nome_playlist)