#7) Implemente um aplicativo Java, C ou Python, que implementa as seguintes
#funcionalidades:
#  (i) Criação de playlists no banco de dados. Esta função deve mostrar todos os
#  álbuns existentes. O usuário pode, assim, escolher o(s) álbum(ns) e quais
#  faixas destes que devem compor a playlist.
#  (ii) Manutenção de playlists. Esta funcionalidade deve mostrar todas as playlists
#  existentes. Ao escolha uma playlist, a função deve permitir a remoção de
#  músicas existentes e a inserção de novas músicas na playlist escolhida
#    (iii) Apresente o resultado das seguintes consultas sobre o banco de dados:
#       a. Listar os álbuns com preço de compra maior que a média de preços de
#       compra de todos os álbuns.
#       b. Listar nome da gravadora com maior número de playlists que possuem
#      pelo uma faixa composta pelo compositor Dvorack.
#      c. Listar nome do compositor com maior número de faixas nas playlists
#      existentes.
#      d. Listar playlists, cujas faixas (todas) têm tipo de composição “Concerto” e
#      período “Barroco”.

import pyodbc
#usar comando pip install pyodbc no terminal

def conecta_ao_banco(driver='SQL Server Native Client 11.0', server='REVISION-PC\SQLEXPRESS', database='SpotPerTest', username=None, password=None, trusted_connection='yes'):
    string_conexao = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TRUSTED_CONNECTION={trusted_connection}"

    conexao = pyodbc.connect(string_conexao)
    cursor = conexao.cursor()

    return conexao, cursor

conexao, cursor = conecta_ao_banco()
print(cursor.execute('SELECT * from Compositor').fetchall())

