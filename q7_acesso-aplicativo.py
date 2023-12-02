

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

driver='SQL Server' 
server='DESKTOP-ELFS8LL'
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
        print(row);
    
        
listar_albuns(cursor);



cursor.close();
connection.close();

#Se a consulta estiver mudando algo no banco (adc tupla, altera tabela, etc.), deve-se usar o comando cursor.commit()
#Exemplo:
#comando = "INSERT INTO Aluno VALUES(5689, 'Claudinho', '05987456322', '20161771986', 'Rua Caucaianos', 103)"
#cursor.execute(comando)
#cursor.commit()
