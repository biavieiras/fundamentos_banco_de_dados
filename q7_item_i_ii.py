# 7) Implemente um aplicativo Java, C ou Python, que implementa as seguintes
# funcionalidades:
# (i) Criação de playlists no banco de dados. Esta função deve mostrar todos os
# álbuns existentes. O usuário pode, assim, escolher o(s) álbum(ns) e quais
# faixas destes que devem compor a playlist.

# python -u "d:\Documentos_Importantes\UFC\4º_semestre\Fundamento de Banco de Dados\Trab_2_FBD\fundamentos_banco_de_dados\q7_item_i_ii.py"



import pyodbc
import random
import numbers
import os
#usar comando pip install pyodbc no terminal

driver='SQL Server' 
#server='DESKTOP-ELFS8LL\SQLEXPRESS'
server= 'DESKTOP-4TLSHUG'
#server= 'Revision-PC'
database='SpotPer'
username=None
password=None
trusted_connection='yes'

string_conexao = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TRUSTED_CONNECTION={trusted_connection}"


connection = pyodbc.connect(string_conexao)
cursor = connection.cursor()


def criaPlaylist():
  while(True):
    _ = os.system('cls')
    create = input("Deseja criar uma nova playlist? 's' para sim, 'n' para nao. \n")
    
    if(create !='s' and create !='n'):
            print('Comando não reconhecido.\n')
            return criaPlaylist();
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
            
            adiciona = input('Deseja adicionar faixas à playlist? "s" para sim "n" para não: \n')          
        
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
  
      

"""
  Manutenção de playlists. Esta funcionalidade deve mostrar todas as playlists
existentes. Ao escolher uma playlist, a função deve permitir a remoção de
músicas existentes e a inserção de novas músicas na playlist escolhida
"""


def CustomPlaylist():
    while(True):
      
      #_ = os.system("cls")
      
      print("\nLista de Playlists: \n\n")

      query_show = 'select nome_playlist, tempo_exec from playlist'
      cursor.execute(query_show)

      rows = cursor.fetchall()
       
      for row in rows:
                print(f"{row[0]} :: {row[1]} minutos\n")

      
      addP = input('\n O que deseja fazer?\n'
                   
                  '[d] Deletar Faixas \n'
                  '[a] Adicionar Faixas\n' 
                  '[s] Sair\n') 
      
      while(addP != 'd' and addP !='a' and addP !='s'):
        print('Entrada Inválida, digite novamente.\n\n')
        addP = input('\n O que deseja fazer?\n'
                   
                  '[d] Deletar Faixas \n'
                  '[a] Adicionar Faixas\n'
                  '[s] Sair\n') 
      
      if (addP == 's'):
        break
      
      elif(addP =='a'):
        AddPlaylist();  
        
      elif(addP == 'd'):
        RemovePlaylist();     

def AddPlaylist():    
    while(True):
        plAdd = input('Em qual Playlist você deseja adicionar as faixas?')
        query1 = f"select p.cod_playlist from playlist p where p.nome_playlist ='{plAdd}'"
        cursor.execute(query1)
                
        r = cursor.fetchone()
        
        
        try:
                    
                if ( isinstance(r, type(None))):
                    
                    print('Nome não encontrado, por favor, digite novamente.\n')
            
                else:
                    
                    while(True):
                        print("\n Faixas disponíveis: \n\n")

                        query_show = 'select f.descricao_faixa from  faixa f '
                        cursor.execute(query_show)

                        rows = cursor.fetchall()
                        for row in rows:
                                print(f"{row[0]} \n") 
                        
                        
                        print(f'\nFaixas da Playlist {plAdd}:\n')
                        
                        query25 = f'select f.descricao_faixa from playlist p, faixa_playlist fp, faixa f where f.id_faixa = fp.cod_faixa and fp.id_playlist = p.cod_playlist  and p.cod_playlist = {r[0]}'
                        cursor.rollback()
                        cursor.execute(query25)
                        
                        rows = cursor.fetchall()
                        
                        count = 1
                        for row in rows:
                            
                          print(f'{count} - {row[0]} \n')
                          count += 1 
                          
                        cursor.rollback()  
                        
                                 
                        addFaixa = input('Qual faixa deseja adicionar: [c] para cancelar: \n')
                       
                        if(addFaixa =='c'): break;
                        
                        
                        
                                            
                        query1 = f"select id_faixa from faixa where descricao_faixa = '{addFaixa}'"
                        cursor.execute(query1)
                        
                        l = cursor.fetchone()
                                       
                        try:
                            
                            if ( isinstance(l, type(None))):
                                
                                print('Nome não encontrado, por favor, digite novamente.\n')
                        
                            else:
                            
                                query2 = f'Insert into faixa_playlist values ({r[0]}, {l[0]})'
                                cursor.execute(query2);
                                connection.commit()
                                print('Faixa adicionada com sucesso :D')
                                
                                
                        except pyodbc.DatabaseError as e : 
                                print(e,'\n')
                        
                        finally:
                            ish = input(' Quer continuar adicionando faixas à Playlist?'
                                        '[s] - sim\n'
                                        '[n] - nao\n')
                            if(ish != 's'):
                                break;
                    
                        
                        
                        
        except pyodbc.DatabaseError as e : 
                    print(e,'\n')
            
        break;
        
           
def RemovePlaylist():
    while(True):
        plRem = input('Em qual Playlist você deseja remover as faixas?')
        query1 = f"select p.cod_playlist from playlist p where p.nome_playlist ='{plRem}'"
        cursor.execute(query1)
                
        r = cursor.fetchone()
        
        
        try:
                    
                if ( isinstance(r, type(None))):
                    
                    print('Nome não encontrado, por favor, digite novamente.\n')
            
                else:
                    
                    while(True):
                        print(f'Faixas da Playlist {plRem}:\n')
                        
                        query25 = f'select f.descricao_faixa from playlist p, faixa_playlist fp, faixa f where f.id_faixa = fp.cod_faixa and fp.id_playlist = p.cod_playlist  and p.cod_playlist = {r[0]}'
                        cursor.rollback()
                        cursor.execute(query25)
                        
                        rows = cursor.fetchall()
                        
                        count = 1
                        for row in rows:
                            
                          print(f'{count} - {row[0]} \n')
                          count += 1 
                          
                        remFaixa = input('Qual faixa você deseja remover: [c] para cancelar: \n')
                       
                        if(remFaixa =='c'): break;
                        
                        query1 = f"select id_faixa from faixa where descricao_faixa ='{remFaixa}'"
                        cursor.execute(query1)
                        
                        l = cursor.fetchone()
                                       
                        try:
                            
                            if ( isinstance(l, type(None))):
                                
                                print('Nome não encontrado, por favor, digite novamente.\n')
                        
                            else:
                            
                                query2 = f'delete from faixa_playlist where id_playlist={r[0]} and  cod_faixa = {l[0]}'
                                cursor.execute(query2);
                                connection.commit()
                                print('Faixa Removida com sucesso :D')
                                
                                
                        except pyodbc.DatabaseError as e : 
                                print(e)
                        
                        finally:
                            ish = input(' Quer continuar removendo faixas à Playlist?'
                                        '[s] - sim\n'
                                        '[n] - nao\n')
                            if(ish != 's'):
                                break;
                    
                        
                        
                        
        except pyodbc.DatabaseError as e : 
                    print(e)
            
        break;
        
            
  


      
     
criaPlaylist()
CustomPlaylist()

cursor.close()
      
connection.close()


    
    
      
              
      