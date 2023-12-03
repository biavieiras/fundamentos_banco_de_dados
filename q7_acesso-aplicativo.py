

#7) Implemente um aplicativo Java, C ou Python, que implementa as seguintes
#funcionalidades:
#  (i) Criação de playlists no banco de dados. Esta função deve mostrar todos os
#  álbuns existentes. O usuário pode, assim, escolher o(s) álbum(ns) e quais
#  faixas destes que devem compor a playlist.
#  (ii) Manutenção de playlists. Esta funcionalidade deve mostrar todas as playlists
#  existentes. Ao escolha uma playlist, a função deve permitir a remoção de
#  músicas existentes e a inserção de novas músicas na playlist escolhida
#    (iii) Apresente o resultado das seguintes consultas sobre o banco de dados:
#      OK a. Listar os álbuns com preço de compra maior que a média de preços de
#         compra de todos os álbuns.
#      OK b. Listar nome da gravadora com maior número de playlists que possuem
#         pelo uma faixa composta pelo compositor Dvorack.
#      OK c. Listar nome do compositor com maior número de faixas nas playlists
#         existentes.
#      OK d. Listar playlists, cujas faixas (todas) têm tipo de composição “Concerto” e
#      período “Barroco”.

# Executar o comando python -u "d:\Documentos_Importantes\UFC\4º_semestre\Fundamento de Banco de Dados\Trab_2_FBD\fundamentos_banco_de_dados\q7_acesso-aplicativo.py"


import pyodbc


driver='SQL Server' 
server='DESKTOP-ELFS8LL\SQLEXPRESS'
database='SpotPer'
username=None
password=None
trusted_connection='yes'

string_conexao = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TRUSTED_CONNECTION={trusted_connection}"



    

connection = pyodbc.connect(string_conexao)
cursor = connection.cursor()

#    a. Listar os álbuns com preço de compra maior que a média de preços de
#       compra de todos os álbuns.
def listar_albuns(cursor):
    query = 'select a.nome,cast(a.pr_compra as float) from album a  where a.pr_compra> (select avg(a.pr_compra) from album a)';
    
    cursor.execute(query);
    
    rows = cursor.fetchall();
   
    for row in rows:
        print(f"Nome do álbum: {row[0]}  :: Preço: R$ {row[1]}");
    
        
listar_albuns(cursor);


#   b. Listar nome da gravadora com maior número de playlists que possuem
#   pelo uma faixa composta pelo compositor Dvorack.
"""
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
"""


def listar_gravad_playlist(cursor):
    query = ('exec gravador_maior_n_playlists')
    
    cursor.execute(query);
    
    row = cursor.fetchone();
   
    print(f"Nome Gravadora: {row[0]} :: Número de Playlists: {row[1]}");

listar_gravad_playlist(cursor);





#     c. Listar nome do compositor com maior número de faixas nas playlists
#     existentes.


"""
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

"""

def listar_comp_faixas(cursor):
    query = ("EXEC compositor_maior_n_playlists")
    
    cursor.execute(query)
    row =cursor.fetchone()
    print(f"Nome do compositor: {row[0]} :: Número de faixas: {row[1]}")
     
    
    
listar_comp_faixas(cursor);



#    d. Listar playlists, cujas faixas (todas) têm tipo de composição “Concerto” e
#    período “Barroco”.


def playlists_barroco_concerto(cursor):
    query =(
        
        """
select p.cod_playlist ,p.nome_playlist from playlist p, faixa_playlist fp, faixa f, faixa_compositor fc, 
compositor c, periodo_musical pm
where p.cod_playlist = fp.id_playlist and fp.cod_faixa = f.id_faixa and
 f.id_faixa = fc.cod_faixa and fc.id_compositor = c.cod_compositor and
c.cod_periodo_mus = pm.cod_pm
except
select p.cod_playlist ,p.nome_playlist from playlist p, faixa_playlist fp, faixa f, faixa_compositor fc, 
compositor c, periodo_musical pm, composicao cc
where p.cod_playlist = fp.id_playlist and fp.cod_faixa = f.id_faixa and
 f.id_faixa = fc.cod_faixa and fc.id_compositor = c.cod_compositor and
c.cod_periodo_mus = pm.cod_pm and f.codigo_composicao = cc.cod_composicao
 and pm.descricao_pm in (select pm.descricao_pm from periodo_musical pm where pm.descricao_pm!='barroco')
 except
 select  p.cod_playlist ,p.nome_playlist from playlist p, faixa_playlist fp, faixa f, faixa_compositor fc, 
compositor c, periodo_musical pm, composicao cc
where p.cod_playlist = fp.id_playlist and fp.cod_faixa = f.id_faixa and
 f.id_faixa = fc.cod_faixa and fc.id_compositor = c.cod_compositor and
c.cod_periodo_mus = pm.cod_pm and f.codigo_composicao = cc.cod_composicao and
 f.codigo_composicao in (select cc.cod_composicao from composicao cc where tipo_composicao!='concerto')
"""
    ) 
    
    cursor.execute(query);
    
    rows = cursor.fetchall();
   
    for row in rows:
        print(f"Código da playlist: {row[0]}  :: Nome da PLaylist: {row[1]}");
    


        
playlists_barroco_concerto(cursor);


cursor.close();
connection.close();





"""
    def playlists_barroco_concerto(cursor):
    query = ('(select distinct p.cod_playlist, p.nome_playlist'
    'from playlist p '
    'where not exists( '
	'select p2.cod_playlist'
    'from playlist p2, faixa_playlist fp, faixa f, faixa_compositor fc, compositor c, periodo_musical pm, composicao cc '
	'where p.cod_playlist = fp.id_playlist and fp.cod_faixa = f.id_faixa '
	'and f.id_faixa = fc.cod_faixa and fc.id_compositor = c.cod_compositor'
	'and c.cod_periodo_mus = pm.cod_pm'
	'and cc.cod_composicao = f.codigo_composicao'
	"AND (cc.tipo_composicao not LIKE '%_oncerto%' or pm.descricao_pm not LIKE '%_arroco%')))"
'EXCEPT' 
'(select distinct p.cod_playlist, p.nome_playlist'
'from playlist p, faixa_playlist fp, faixa f, faixa_compositor fc, compositor c, periodo_musical pm, composicao cc '
'where p.cod_playlist = fp.id_playlist and fp.cod_faixa = f.id_faixa '
	  'and cc.cod_composicao = f.codigo_composicao'
	  'and f.id_faixa in --faixas que nao estao associadas a nenhum compositor'
	  '(select f2.id_faixa from faixa f2'
	   'except'
	   'select fc2.cod_faixa from faixa_compositor fc2)));')
    
    cursor.execute(query);
    
    rows = cursor.fetchall();
   
    for row in rows:
        print(f"Código da playlist: {row[0]}  :: Nome da PLaylist: {row[1]}");
    
"""

        
#playlists_barroco_concerto(cursor);




#Se a consulta estiver mudando algo no banco (adc tupla, altera tabela, etc.), deve-se usar o comando cursor.commit()
#Exemplo:
#comando = "INSERT INTO Aluno VALUES(5689, 'Claudinho', '05987456322', '20161771986', 'Rua Caucaianos', 103)"
#cursor.execute(comando)
#cursor.commit()
