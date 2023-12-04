# fundamentos_banco_de_dados
Trabalho da disciplina Fundamentos de Banco de Dados 2023.2 da Universidade Federal do Ceará, ministrada pelo professor Doutor Ângelo Brayner. O trabalho consiste em modelar e implementar o banco de dados do "Spotper", um aplicativo de músicas.


7b
   create procedure gravador_maior_n_playlists
as
Declare cursor_gravadora_playlists Cursor Scroll for
    select  g.nome, COUNT(DISTINCT p.cod_playlist)
    from playlist p, faixa_playlist fp, faixa f, faixa_compositor fc, compositor c, gravadora g, album a
    where p.cod_playlist = fp.id_playlist and fp.cod_faixa = f.id_faixa
    and f.id_faixa = fc.cod_faixa and fc.id_compositor = c.cod_compositor
	and a.cod_album = f.codigo_album and g.cod_gravad = a.cod_gravadora
	and c.nome_compositor like '%Antonin Dvorak%'
    GROUP BY g.cod_gravad, g.nome
    ORDER BY COUNT(DISTINCT p.cod_playlist) DESC
OPEN cursor_gravadora_playlists
FETCH first from cursor_gravadora_playlists
DEALLOCATE cursor_gravadora_playlists

def listar_gravad_playlist(cursor):
    query = ('exec gravador_maior_n_playlists')
    
    cursor.execute(query);
    
    row = cursor.fetchone();
   
    print(f"Nome Gravadora: {row[0]} :: Número de Playlists: {row[1]}");

listar_gravad_playlist(cursor);


-----------------
7c
alter procedure compositor_maior_n_playlists
as
Declare cursor_compositor_playlists Cursor Scroll for

    select c.nome_compositor, count(*) as qtde from playlist p, faixa_playlist fp, faixa f, faixa_compositor fc, compositor c
    where p.cod_playlist = fp.id_playlist and fp.cod_faixa = f.id_faixa and f.id_faixa = fc.cod_faixa
	and fc.id_compositor = c.cod_compositor
    group by c.nome_compositor
	order by qtde desc
OPEN cursor_compositor_playlists
FETCH first from cursor_compositor_playlists
DEALLOCATE cursor_compositor_playlists

EXEC compositor_maior_n_playlists



def listar_comp_faixas(cursor):
    query = ("EXEC compositor_maior_n_playlists")
    
    cursor.execute(query)
    row =cursor.fetchone()
    print(f"Nome do compositor: {row[0]} :: Número de faixas: {row[1]}")
     