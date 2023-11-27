/*
3) Defina as seguintes restrições
  a) Um álbum, com faixas de músicas do período barroco, só pode ser inserido no
  banco de dados, caso o tipo de gravação seja DDD.
  b) Um álbum não pode ter mais que 64 faixas (músicas).
  c) No caso de remoção de um álbum do banco de dados, todas as suas faixas
  devem ser removidas. Lembre-se que faixas podem apresentar, por sua vez,
  outros relacionamentos. (É contemplada no delete on cascade)
  d) O preço de compra de um álbum não dever ser superior a três vezes a média
  do preço de compra de álbuns, com todas as faixas com tipo de gravação
  DDD.
*/

-- 3b)

create trigger limite_faixas_album
ON  faixa
AFTER  UPDATE, INSERT
AS 
BEGIN
  declare @cod_faixa int
  declare @cod_album smallint
  declare @qtde_faixas smallint

  select @cod_album = codigo_album from inserted

  select @qtde_faixas = count(*) from faixa
  where codigo_album = @cod_album

  IF @qtde_faixas > 64
  BEGIN
    RAISERROR ('Quantidade de faixas não pode ser maior que 64', 16, 1)
    ROLLBACK TRANSACTION
    END
  
  ELSE
	BEGIN
	   IF EXISTS(SELECT * FROM DELETED)
	       UPDATE faixa SET codigo_album = @cod_album
		   where id_faixa = @cod_faixa

       ELSE
	       INSERT INTO faixa SELECT * FROM inserted

     END
   
END


/*
Para contemplar a condição:
. Quando o meio físico de armazenamento é CD, o tipo de gravação tem que
ser ADD ou DDD. Quando o meio físico de armazenamento é vinil ou
download, o tipo de gravação não terá valor algum.
*/


create trigger tipo_de_gravacao_
ON faixa
FOR  UPDATE, INSERT
AS 
BEGIN
  declare @tipo_gravacao char(3)
  declare @meio_fisico varchar(8)
	declare @cod_album smallint

   
  SELECT  @cod_album = codigo_album from inserted
	
	select @meio_fisico = meio_fisico from album 
	where cod_album = @cod_album

  select @tipo_gravacao = tipo_gravacao  from inserted

	if @meio_fisico = 'CD'
	BEGIN
	  if @tipo_gravacao not in ('ADD', 'DDD')
	  BEGIN
	      RAISERROR('O tipo de gravação deve ser ADD ou DDD',16,1)
		  ROLLBACK TRANSACTION
      END
	END

	ELSE 
	BEGIN
	   IF @tipo_gravacao <> NULL
	   BEGIN
	    RAISERROR('O tipo de gravação deve ser NULO',16,1)
		  ROLLBACK TRANSACTION
        END
    END
END


/*
Gatilho para atualização do tempo de execução
da playlist à medida que novas faixas são
adicionadas:
*/


create trigger trigger_tempo_execucao
ON faixa_playlist
AFTER UPDATE, INSERT, DELETE
AS 
BEGIN
declare @tempo_exec_playlist varchar(10)
declare @tempo_exec_faixa varchar(10)


declare @id_play int
declare @id_faixa int


select @id_play = id_playlist, @id_faixa = cod_faixa from inserted

select @tempo_exec_playlist = tempo_exec from playlist
where cod_playlist = @id_play

select @tempo_exec_faixa  = tempo_execucao  from faixa
where id_faixa  = @id_faixa

declare @aux4  dec(6,2)
declare @aux1 dec(6,2)
declare @aux2 dec(6,2)
declare @aux3 dec(6,2)
-------------------------------------------------------------
select @aux1 = cast ( @tempo_exec_faixa as dec(6,2))

-- transforma em segundos o tempo da faixa
select @aux2 = FLOOR(@aux1) * 60 + ( @aux1%floor(@aux1))*100

-------------------------------------------------------------

select @aux3 = cast ( @tempo_exec_playlist as dec(6,2))
-- transforma em segundos o tempo da playlist
select @aux4 = FLOOR(@aux3) * 60 + ( @aux3%floor(@aux3))*100

-- somando o tempo total:
select @tempo_exec_playlist = cast((floor((@aux2 + @aux4 )/60) + (((@aux2 + @aux4)%60)/100)) as varchar(10))

update playlist set tempo_exec = @tempo_exec_playlist 
where cod_playlist = @id_play

/*
IF EXISTS (SELECT * FROM deleted)
update playlist set tempo_exec = cast((floor((@aux2 - @aux4 )/60) + (((@aux2 - @aux4)%60)/100)) as varchar(10)) from deleted
where cod_playlist = @id_play
*/
    
END

/*
 3d) O preço de compra de um álbum não dever ser superior a três vezes a média
  do preço de compra de álbuns, com todas as faixas com tipo de gravação
  DDD.
  *** OBS : Revisar
*/
create trigger preco_compra_album
ON album
INSTEAD OF INSERT, UPDATE
AS
BEGIN

	declare @pr_compra decimal(7,2)
	declare @cod_album smallint 
	declare @media_pr_album_DDD decimal(7,2)

	select @pr_compra=pr_compra, @cod_album= cod_album from inserted
 
	select @media_pr_album_DDD = AVG(pr_compra)  from album a,faixa f
	where a.cod_album = f.codigo_album and tipo_gravacao ='DDD'

	IF @pr_compra > 3 * @media_pr_album_DDD
	BEGIN
		RAISERROR('O preço de compra do album execedeu o valor permitido', 16, 1)
		ROLLBACK TRANSACTION
	END

	ELSE
	BEGIN
	   IF EXISTS(SELECT * FROM DELETED)
	       UPDATE album SET pr_compra = @pr_compra 
		   where cod_album = @cod_album

       ELSE
	       INSERT INTO album SELECT * FROM inserted

     END
END