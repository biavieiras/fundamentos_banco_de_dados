-- questão 5
-- FUNCIONANDO !!
-- Criar uma visão materializada que tem como atributos o nome da playlist e a
-- quantidade de álbuns que a compõem.

create view playlist_qtde_albuns(nome_playlist, qtde_albuns)
with schemabinding
as
   select nome_playlist, count_big(*) as 'qtde albuns' from dbo.playlist p, dbo.faixa_playlist,
   dbo.faixa f, dbo.album a
   
   where cod_playlist = id_playlist and cod_faixa = f.id_faixa and f.codigo_album = a.cod_album
   group by p.cod_playlist,nome_playlist

   union

   select nome_playlist, '0' as 'qtde albuns' from dbo.playlist p
   where p.cod_playlist not in (select distinct f.id_playlist from dbo.faixa_playlist f)
  
  
   group by p.cod_playlist, nome_playlist


CREATE UNIQUE CLUSTERED INDEX I_playlist_qtde_albuns ON playlist_qtde_albuns (nome_playlist)

select * from playlist_qtde_albuns



alter view playlist_qtde_albuns(nome_playlist, qtde_albuns)
with schemabinding
as
   select nome_playlist,Isnull(count(fp.id_playlist),0)as 'qtde albuns' from dbo.playlist p left   join
    dbo.faixa_playlist fp on cod_playlist = id_playlist
		left   join
 dbo.faixa f on cod_faixa = f.id_faixa
 left join
   dbo.album a on
   f.codigo_album = a.cod_album
   group by p.cod_playlist,nome_playlist, fp.id_playlist

CREATE UNIQUE CLUSTERED INDEX I_playlist_qtde_albuns ON playlist_qtde_albuns (nome_playlist)