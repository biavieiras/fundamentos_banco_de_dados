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
#server= 'DESKTOP-4TLSHUG'
server= 'Revision-PC'
database='SpotPer'
username=None
password=None
trusted_connection='yes'

string_conexao = f"DRIVER={driver};SERVER={server};DATABASE={database};UID={username};PWD={password};TRUSTED_CONNECTION={trusted_connection}"

connection = pyodbc.connect(string_conexao)
cursor = connection.cursor()

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
                                print('Faixa adicionada com sucesso :D\n\n')
                                
                                
                        except pyodbc.DatabaseError as e : 
                                print(e,'\n')
                        
                        finally:
                            ish = input(' Quer continuar adicionando faixas à Playlist?\n'
                                        '[s] - Sim\n'
                                        '[n] - Não\n')
                            if(ish != 's'):
                                break;
                    
                        
                        
                        
        except pyodbc.DatabaseError as e : 
                    print(e,'\n')
            
        break;

def RemovePlaylist():
    while(True):
        plRem = input('Em qual Playlist você deseja remover as faixas?\n')
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
                            ish = input(' Quer continuar removendo faixas à Playlist?\n'
                                        '[1] - Sim\n'
                                        '[2] - Não\n')
                            if(ish != '1'):
                                break;
                    
                        
                        
                        
        except pyodbc.DatabaseError as e : 
                    print(e)
            
        break;

def listar_albuns(cursor):
    query = 'select a.nome,cast(a.pr_compra as float) from album a  where a.pr_compra> (select avg(a.pr_compra) from album a)';
    
    cursor.execute(query);
    
    rows = cursor.fetchall();
   
    for row in rows:
        print(f"Nome do álbum: {row[0]}  :: Preço: R$ {row[1]}");

def listar_gravad_playlist(cursor):
    query = ('exec gravador_maior_n_playlists')
    aux = True
    cursor.execute(query)
    while(True):
     try: 
      row = cursor.fetchone();
      
      if(isinstance(row, type(None))):
         break 
      else:  
        
        print(f"Nome Gravadora: {row[0]} :: Número de Playlists: {row[1]}");
        
        cursor.nextset()
     except:
       break

def listar_comp_faixas(cursor):
    query = ("EXEC compositor_maior_n_playlists")
    
    cursor.execute(query)
    while(True):
     try: 
      row = cursor.fetchone();
      
      if(isinstance(row, type(None))):
         break 
      else:  
        
        
        print(f"Nome do compositor: {row[0]} :: Número de faixas: {row[1]}")
        cursor.nextset()
     except:
       break

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
        """) 
    
    cursor.execute(query);
    
    rows = cursor.fetchall();
   
    for row in rows:
        print(f"Código da playlist: {row[0]}  :: Nome da PLaylist: {row[1]}");

def quer_consultar():
    decisao = input('Deseja realizar uma nova consulta?\n[1] Sim\n[2] Não\n\n')
    if decisao == '1':
        return True
    else:
        return False


while True:
    escolha = input("\nO que deseja fazer? \n\n[1] Criação de playlists no banco de dados \n[2] Manutenção de playlists \n[3] Consultar o Banco de Dados \n[4] Sair \n\n\n")
    if escolha == '1':  
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
            adiciona = input('Deseja adicionar faixas ao álbum?\n [1] Sim [2] Não: \n')
            
            while(adiciona!= '1' and adiciona != '2' ):
                print('Entrada inválida, digite novamente.')
                
                adiciona = input('Deseja adicionar faixas ao álbum?\n [1] Sim [2] Não: \n')          
            
            if(adiciona == '2'):
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
    elif escolha == '2':
        while (True):
            print("\nLista de Playlists: \n\n")
            query_show = 'select nome_playlist, tempo_exec from playlist'
            cursor.execute(query_show)

            rows = cursor.fetchall()

            for row in rows:
                print(f"{row[0]} :: {row[1]} minutos\n")

            addP = input('\n O que deseja fazer?\n'
                '[1] Deletar faixas\n'
                '[2] Adicionar faixas\n'
                '[3] Sair\n\n')
            
            if (addP == '3'):
                break
            elif(addP =='2'):
                AddPlaylist();
            elif(addP == '1'):
                RemovePlaylist();
            else:
                print('Entrada Inválida, digite novamente.\n\n')
    elif escolha == '3':
        while (True):
            consulta = input('Qual consulta deseja executar?\n[a] Listar os álbuns com preço de compra maior que a média de preços de compra de todos os álbuns. \n'
                             '[b] Listar nome da gravadora com maior número de playlists que possuem pelo uma faixa composta pelo compositor Dvorack. \n'
                             '[c] Listar nome do compositor com maior número de faixas nas playlists existentes. \n'
                             '[d] Listar playlists, cujas faixas (todas) têm tipo de composição “Concerto” e período “Barroco”. \n'
                             '[e] Voltar\n\n')
            if consulta == 'a':
                listar_albuns(cursor)
                continuar = quer_consultar()
                if continuar != True:
                    break
            elif consulta == 'b':
                listar_gravad_playlist(cursor)
                continuar = quer_consultar()
                if continuar != True:
                    break
            elif consulta == 'c':
                listar_comp_faixas(cursor)
                continuar = quer_consultar()
                if continuar != True:
                    break
            elif consulta == 'd':
                playlists_barroco_concerto(cursor);
                continuar = quer_consultar()
                if continuar != True:
                    break
            elif consulta == 'e':
                break
            else:
                print('Entrada Inválida. Tente novamente\n\n')
    elif escolha == '4':
        break







#while(True):
#            _ = os.system('cls')
#            create = input("Deseja criar uma nova playlist? 's' para sim, 'n' para nao. \n")
#    
#            if(create !='s' and create !='n'):
#                print('Comando não reconhecido.\n')
#                return criaPlaylist();
#            if(create =='n'):
#                break;