
-- questão 5
-- Criar uma visão materializada que tem como atributos o nome da playlist e a
-- quantidade de álbuns que a compõem.



create view playlist_qtde_albuns(nome_playlist, qtde_albuns)
with schemabinding
as
   select nome_playlist, count_big(cod_album) from dbo.playlist, dbo.faixa_playlist,
   dbo.faixa f, dbo.meio_faixa mfa , dbo.meio_fisico mfi, dbo.album a
   
   where cod_playlist = id_playlist and cod_faixa = f.num_faixa and f.num_faixa = mfa.num_faixa
   and mfa.id_meio_fisico = mfi.id_meio_fisico and a.cod_album = mfi.cod_album
   group by nome_playlist


CREATE UNIQUE CLUSTERED INDEX I_playlist_qtde_albuns ON playlist_qtde_albuns (playlist)