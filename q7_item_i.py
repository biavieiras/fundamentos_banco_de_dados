# 7) Implemente um aplicativo Java, C ou Python, que implementa as seguintes
# funcionalidades:
# (i) Criação de playlists no banco de dados. Esta função deve mostrar todos os
# álbuns existentes. O usuário pode, assim, escolher o(s) álbum(ns) e quais
# faixas destes que devem compor a playlist.


import pyodbc
import random
import numbers
import os
#usar comando pip install pyodbc no terminal

driver='SQL Server' 
#server='DESKTOP-ELFS8LL\SQLEXPRESS'
server= 'DESKTOP-4TLSHUG'
database='SpotPer'
username=None
password=None
trusted_connection='yes'

string_conexao = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TRUSTED_CONNECTION={trusted_connection}"


connection = pyodbc.connect(string_conexao)
cursor = connection.cursor()

def queries(cursor):
  # Para fazer insert ou update
  
  cursor.executemany()

  try:
      query = 'select a.nome,cast(a.pr_compra as float) from album a  where a.pr_compra> (select avg(a.pr_compra) from album a)';
      
      cursor.execute(query);
      connection.commit();
      
  except pyodbc.DatabaseError as e:
    print(e)
  # No caso de algum erro usar um try e um rollback:
    connection.rollback()

  finally:
    connection.close()


def criaAlbum():
  while(True):
    _ = os.system('cls')
    create = input("Deseja criar uma nova playlist? 's' para sim, 'n' para nao. \n")
    
    if(create !='s' and create !='n'):
            print('Comando não reconhecido.\n')
            return criaAlbum();
    if(create =='n'):
       break;
    
    else:
  
      nome_play = input("Qual será o nome da playlist?")
      
      query_dt_criacao = 'SELECT GETDATE()'
      cursor.execute(query_dt_criacao)
      row = cursor.fetchone();      
      dt_criacao = row[0]
      
      tempo_exec = 0.0
      aux = 0
      cod_play = random.randint(1, 900)
      
      
      while(aux == 0):
               
          cod_play = random.randint(1, 700)
          aux = 1
          try:
              query = f"insert into playlist values ({cod_play}, '{nome_play}', '{dt_criacao}', {tempo_exec})";
              
              cursor.execute(query);
              
              connection.commit();
      
          except pyodbc.DatabaseError as e:
              print(e)
              aux = 0
    cursor.rollback()
  
    print("\nÁlbuns e Faixas disponíveis: \n\n")

    query_show = 'select a.nome, f.descricao_faixa from album a, faixa f where a.cod_album = f.codigo_album'
    cursor.execute(query_show)

    rows = cursor.fetchall()
    for row in rows:
            print(f"{row[0]} - {row[1]}\n")
        
    cursor.rollback()
    while(True):
        adiciona = input('Deseja adicionar faixas ao álbum? "s" para sim "n" para não: \n')
        
        while(adiciona!= 's' and adiciona != 'n' ):
            print('Entrada inválida, digite novamente.')
            
            adiciona = input('Deseja adicionar faixas ao álbum? "s" para sim "n" para não: \n')          
        
        if(adiciona == 'n'):
            break;
            
        
        else: 
            while(True): 
                addFaixa = input('Qual faixa deseja adicionar:\n')
                query1 = f"select id_faixa from faixa where descricao_faixa = '{addFaixa}'"
                cursor.execute(query1)
                
                l = cursor.fetchone()
               
                
                try:
                    
                    if ( isinstance(l, type(None))):
                        
                        print('Nome não encontrado, por favor, digite novamente\n')
                
                    else:
                    
                        query2 = f'Insert into faixa_playlist values ({cod_play}, {l[0]})'
                        cursor.execute(query2);
                        connection.commit()
                        print('Faixa adicionada com sucesso :D')
                        
                        
                except pyodbc.DatabaseError as e : 
                        print('Nome não encontrado, por favor, digite novamente\n')
                
                break;
      
      
     
criaAlbum()


      


          
    
    
      
              
      