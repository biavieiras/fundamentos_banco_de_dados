/*
3) Defina as seguintes restrições
      a) Um álbum, com faixas de músicas do período barroco, só pode ser inserido no
      banco de dados, caso o tipo de gravação seja DDD.
  OK  b) Um álbum não pode ter mais que 64 faixas (músicas).
  OK? c) No caso de remoção de um álbum do banco de dados, todas as suas faixas
      devem ser removidas. Lembre-se que faixas podem apresentar, por sua vez,
      outros relacionamentos. (É contemplada no delete on cascade)
  OK  d) O preço de compra de um álbum não dever ser superior a três vezes a média
      do preço de compra de álbuns, com todas as faixas com tipo de gravação
       DDD.
*/

-- 3b)
-- FUNCIONANDO !!!

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
FUNCIONANDO!!!
Para contemplar a condição:
. Quando o meio físico de armazenamento é CD, o tipo de gravação tem que
ser ADD ou DDD. Quando o meio físico de armazenamento é vinil ou
download, o tipo de gravação não terá valor algum.
*/


alter trigger tipo_de_gravacao
ON faixa
FOR INSERT, UPDATE
AS 
BEGIN
  declare @tipo_gravacao char(3) 
  declare @meio_fisico varchar(8)
	declare @cod_album smallint

   
  SELECT  @cod_album = codigo_album, @tipo_gravacao = tipo_gravacao 
  from inserted
	
	select @meio_fisico = meio_fisico from album 
	where cod_album = @cod_album

   

	if @meio_fisico = 'CD'
	BEGIN
	
	  if  (@tipo_gravacao != 'ADD' and @tipo_gravacao != 'DDD') or @tipo_gravacao IS NULL
	  BEGIN
	  
	      RAISERROR('O tipo de gravação deve ser ADD ou DDD',16,1)
		  ROLLBACK TRANSACTION
    END
	END

	ELSE 
	BEGIN
	   IF @tipo_gravacao IS NOT NULL
	   BEGIN
	    RAISERROR('O tipo de gravação deve ser NULO',16,1)
		  ROLLBACK TRANSACTION
        END
    END

END



/*
CORRIGIR
todas as faixas do gatilho devem ser do tipo DDD
 3d) O preço de compra de um álbum não dever ser superior a três vezes a média
  do preço de compra de álbuns, com todas as faixas com tipo de gravação
  DDD.
  
*/
ALTER trigger preco_compra_album
ON album
FOR INSERT, UPDATE
AS
BEGIN

	declare @pr_compra decimal(7,2)
	declare @cod_album smallint 
	declare @media_pr_album_DDD decimal(7,2)
	DECLARE @album smallint

	select @pr_compra=pr_compra, @cod_album= cod_album from inserted
 
	select @media_pr_album_DDD = AVG(pr_compra) from album a,faixa f
	where a.cod_album = f.codigo_album and 
	a.cod_album not in (SELECT distinct f.codigo_album from  faixa f
	where  tipo_gravacao = 'ADD'
	OR tipo_gravacao IS NULL)

	PRINT @media_pr_album_DDD
	print @album
	IF @pr_compra > 3 * @media_pr_album_DDD
	BEGIN
		RAISERROR('O preço de compra do album execedeu o valor permitido', 16, 1)
		ROLLBACK TRANSACTION
	END
END

INSERT INTO album (cod_album, descricao_album, nome, tipo_compra, pr_compra, dt_compra, dt_gravacao, cod_gravadora, meio_fisico, qtde_disco)
VALUES
  (24, 'Álbum LGTV', 'Artista POP Plabo Vitah', 'cartão', 288.00, '2023-01-10', '2022-12-01', 1, 'CD', 6)



/*
FUNCIONANDO!
album: gatilho para checar caso o meio_fisico de album seja CD ou vinil na inserção,
a qtde_disco deve ser maior que zero e diferente de nulo
*/

create trigger qtde_disco_album on album
for insert, update
as
begin

declare @meio_fis varchar(8)
declare @qtde_disco smallint

select @meio_fis = meio_fisico, @qtde_disco = qtde_disco from inserted
if @meio_fis = 'CD' or @meio_fis = 'vinil'
	begin
	if @qtde_disco <= 0
		begin
		RAISERROR('A quantidade de discos deve ser maior que 0',16,1)
		ROLLBACK TRANSACTION
		END
	end
else
	begin
	if  @qtde_disco <> 0
		begin
		RAISERROR('A quantidade de discos deve ser igual a 0, pois se trata de um download',16,1)
		ROLLBACK TRANSACTION
		END
	end
end



/*
FUNCIONANDO !!!
faixa: gatilho para checar caso o meio_fisico de album seja CD ou vinil na inserção,
o num_disco deve ser diferente de nulo, maior que zero e menor ou igual a qtde_disco.
*/


create trigger num_disco_faixa on faixa
for insert, update 
as
begin

declare @num_disco smallint
declare @meio_fis varchar(8)
declare @cod_album smallint
declare @qtde_disco smallint

select @num_disco = num_disco, @cod_album = codigo_album from inserted
select @meio_fis = meio_fisico, @qtde_disco = qtde_disco from album a where a.cod_album = @cod_album

if @meio_fis = 'CD' or @meio_fis = 'vinil'
begin
	if @num_disco IS NULL or @num_disco < 1 or @num_disco > @qtde_disco
	begin
		RAISERROR('O número do disco deve receber um valor diferente de nulo, maior que 1 e menor que a quantidade de discos',16,1)
		ROLLBACK TRANSACTION
	END
end
else 
begin
	if @num_disco IS NOT null 
	begin
		RAISERROR('O número do disco deve ser nulo, pois trata-se de um download',16,1)
		ROLLBACK TRANSACTION
	END
END
END


/*
FUNCIONANDO !!!!
3)a) Um álbum, com faixas de músicas do período barroco, 
só pode ser inserido no banco de dados, caso o tipo de 
gravação seja DDD.
*/

-- se a descricao_pm do pm de um compositor de uma faixa
-- q será inserido em um album for igual a 'barroco', 
-- o ti


alter trigger faixa_pm_barroco
on faixa_compositor
after update, insert
as
begin
	declare @desc_pm varchar(20)
	declare @tipo_grav char(3)
	declare @id_faixa int
	declare @id_compositor smallint

	

	select @id_faixa = cod_faixa ,@id_compositor =id_compositor  from inserted

	select @desc_pm = pm.descricao_pm, @tipo_grav = tipo_gravacao
	from periodo_musical pm, compositor c, inserted i, faixa f
	where pm.cod_pm = c.cod_periodo_mus and c.cod_compositor = @id_compositor
	and  f.id_faixa = @id_faixa

	if @desc_pm = 'barroco'
		begin
		if @tipo_grav <> 'DDD' OR @tipo_grav is null
			begin
			raiserror('Um álbum não pode conter uma faixa do período Barroco com o tipo de gravação não sendo DDD', 16, 1)
			rollback transaction
		end
	end
end




	    set @tempo_exec_playlist = cast((cast(floor((@aux4 - @aux2 )/60) + 
		(((@aux4 - @aux2)%60)/100)as dec(6,2)))  as varchar(10)) 
PRINT @tempo_exec_playlist





/*
Gatilho para atualização do tempo de execução
da playlist à medida que novas faixas são
adicionadas:
CORRIGIDO
*/

alter trigger trigger_tempo_execucao_incrementa
ON faixa_playlist
FOR UPDATE, INSERT
AS 
BEGIN
declare @tempo_exec_playlist varchar(10)
declare @tempo_exec_faixa varchar(10)


declare @id_play int
declare @id_faixa int

declare @aux4  dec(6,2)
declare @aux1 dec(6,2)
declare @aux2 dec(6,2)
declare @aux3 dec(6,2)

DECLARE cursor_tempo_execucao CURSOR SCROLL FOR

select id_playlist, cod_faixa from inserted

OPEN cursor_tempo_execucao
FETCH first FROM cursor_tempo_execucao

INTO @id_play,  @id_faixa
WHILE(@@FETCH_STATUS = 0)
	BEGIN

		select @tempo_exec_playlist = tempo_exec from playlist
		where cod_playlist = @id_play

		select @tempo_exec_faixa  = tempo_execucao  from faixa
		where id_faixa  = @id_faixa

		-------------------------------------------------------------
		set @aux1 = cast ( @tempo_exec_faixa as dec(6,2))

		-- transforma em segundos o tempo da faixa
		set @aux2 = FLOOR(@aux1) * 60 + ( @aux1%floor(@aux1))*100

		-------------------------------------------------------------
 
		set @aux3 = cast ( @tempo_exec_playlist as dec(6,2))

		if @aux3 != 0.0
			BEGIN
			-- transforma em segundos o tempo da playlist
			set @aux4 = FLOOR(@aux3) * 60 + ( @aux3%floor(@aux3))*100
			END
		ELSE
			BEGIN
			  set @aux4 = @aux3
			END


		-- somando o tempo total:
		set @tempo_exec_playlist = cast(cast((floor((@aux2 + @aux4 )/60) + (((@aux2 + @aux4)%60)/100)) as dec(6,2)) as varchar(10))

		update playlist set tempo_exec = @tempo_exec_playlist 
		where cod_playlist = @id_play

		
		FETCH NEXT FROM cursor_tempo_execucao
		INTO @id_play,  @id_faixa
	end
	DEALLOCATE cursor_tempo_execucao

END


alter trigger trigger_tempo_execucao_decrementa
ON faixa_playlist
FOR UPDATE, DELETE
AS 
BEGIN
declare @tempo_exec_playlist varchar(10)
declare @tempo_exec_faixa varchar(10)


declare @id_play int
declare @id_faixa int

declare @aux4  dec(6,2)
declare @aux1 dec(6,2)
declare @aux2 dec(6,2)
declare @aux3 dec(6,2)


DECLARE cursor_tempo_execucao_decrementa CURSOR SCROLL FOR

select id_playlist, cod_faixa from deleted

OPEN cursor_tempo_execucao_decrementa
FETCH first FROM cursor_tempo_execucao_decrementa

INTO @id_play,  @id_faixa
WHILE(@@FETCH_STATUS = 0)
	BEGIN

		select @tempo_exec_playlist = tempo_exec from playlist
		where cod_playlist = @id_play

		select @tempo_exec_faixa  = tempo_execucao  from faixa
		where id_faixa  = @id_faixa

		-------------------------------------------------------------
		set @aux1 = cast ( @tempo_exec_faixa as dec(6,2))

		-- transforma em segundos o tempo da faixa
		set @aux2 = FLOOR(@aux1) * 60 + ( @aux1%floor(@aux1))*100
		
	
		-------------------------------------------------------------
 
		set @aux3 = cast ( @tempo_exec_playlist as dec(6,2))
		set @aux4 = FLOOR(@aux3) * 60 + ( @aux3%floor(@aux3))*100
		

	
		    set @tempo_exec_playlist = cast((cast(floor((@aux4 - @aux2 )/60) + 
		(((@aux4 - @aux2)%60)/100)as dec(6,2)))  as varchar(10)) 
PRINT @tempo_exec_playlist

		update playlist set tempo_exec = @tempo_exec_playlist 
		where cod_playlist = @id_play
		
		
          
		FETCH NEXT FROM cursor_tempo_execucao_decrementa
		INTO @id_play,  @id_faixa
	end
	DEALLOCATE cursor_tempo_execucao_decrementa
END
