
# 7) Implemente um aplicativo Java, C ou Python, que implementa as seguintes
# funcionalidades:
# (i) Criação de playlists no banco de dados. Esta função deve mostrar todos os
# álbuns existentes. O usuário pode, assim, escolher o(s) álbum(ns) e quais
# faixas destes que devem compor a playlist.


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

def queries(cursor):
  # Para fazer insert ou update
  connection.commit()
  cursor.executemany()

  try:
      query = 'select a.nome,cast(a.pr_compra as float) from album a  where a.pr_compra> (select avg(a.pr_compra) from album a)';
      
      cursor.execute(query);
  except pyodbc.DatabaseError as e:
    print(e)
  # No caso de algum erro usar um try e um rollback:
    connection.rollback()

  finally:
    connection.close()


while(True):
    create = input("Deseja criar uma nova playlist? 's' para sim, 'n' para não,")
    
    if(create =='n'):
      break;
    else:
      #id_play  = 
      nome_play = input("Qual será o nome da playlist?")
      
      query_dt_criacao = 'SELECT GETDATE()'
      cursor.execute(query_dt_criacao)
      row = cursor.fetchone();
      print (row)
      
      