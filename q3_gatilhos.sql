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

  declare @cod_album smallint
  declare @qtde_faixas smallint

  select @cod_album = cod_album from inserted

  select @qtde_faixas = count(*) from faixa
  where cod_album = @cod_album

  IF @qtde_faixas > 64
  BEGIN
    RAISERROR ('Quantidade de faixas não pode ser maior que 64', 16, 1)
    ROLLBACK TRANSACTION
    END
END


/*
Para contemplar a condição:
. Quando o meio físico de armazenamento é CD, o tipo de gravação tem que
ser ADD ou DDD. Quando o meio físico de armazenamento é vinil ou
download, o tipo de gravação não terá valor algum.
*/

create trigger tipo_de_gravacao_
ON album
FOR  UPDATE, INSERT
AS 
BEGIN
    declare @tipo_gravacao char(3)
    declare @meio_fisico varchar(8)

    select @meio_fisico = meio_fisico from inserted
    select @tipo_gravacao = tipo_gravacao from faixa f, inserted i
    where 




