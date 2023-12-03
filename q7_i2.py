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
server='DESKTOP-ELFS8LL\SQLEXPRESS'
#server= 'DESKTOP-4TLSHUG'
database='SpotPer'
username=None
password=None
trusted_connection='yes'

string_conexao = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TRUSTED_CONNECTION={trusted_connection}"


connection = pyodbc.connect(string_conexao)
cursor = connection.cursor()




"""
  Manutenção de playlists. Esta funcionalidade deve mostrar todas as playlists
existentes. Ao escolher uma playlist, a função deve permitir a remoção de
músicas existentes e a inserção de novas músicas na playlist escolhida
"""


def CustomPlaylist():
    while(True):
      
      _ = os.system("cls")
      
      print("\nLista de Playlists: \n\n")

      query_show = 'select nome_playlist, tempo_exec from playlist'
      cursor.execute(query_show)

      rows = cursor.fetchall()
       
      for row in rows:
                print(f"{row[0]} - {row[1]} minutos\n")

      
      addP = input('\n O que deseja fazer?\n'
                   
                  '[d] Deletar Faixas \n'
                  '[a] Adicionar Faixas\n' 
                  '[s] Sair\n') 
      
      while(addP != 'd' and addP !='a' and addP !='s'):
        print('Entrada Inválida, digite novamente.\n\n')
        addP = input('\n O que deseja fazer?\n'
                   
                  '[d] Deletar Faixas \n'
                  '[a] Adicionar Faixas\n' ) 
      
      if (addP == 's'):
        break
      
      elif(addP =='a'):
        AddPlaylist();     

def AddPlaylist():    
    while(True):
        plAdd = input('Em qual Playlist você deseja adicionar as faixas?')
        query1 = f"select p.cod_playlist from playlist p where p.nome_playlist = '{plAdd}'"
        cursor.execute(query1)
                
        r = cursor.fetchone()
        
        try:
                    
                if ( isinstance(r, type(None))):
                    
                    print('Nome não encontrado, por favor, digite novamente.\n')
            
                else:
                    
                    while(True):
                        addFaixa = input('Qual faixa deseja adicionar: [c] para cancelar\n')
                       
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
                                print('Nome não encontrado, por favor, digite novamente\n')
                        
                        finally:
                            ish = input(' Quer continuar adicionando faixas à Playlist?'
                                        '[s] - sim'
                                        '[n] - nao')
                            if(ish != 's'):
                                break;
                    
                        
                        
                        
        except pyodbc.DatabaseError as e : 
                    print('Nome não encontrado, por favor, digite novamente\n')
            
        break;
        
           
        
            
  
CustomPlaylist()



cursor.close()
      
connection.close()


          
    
    
      
              
      