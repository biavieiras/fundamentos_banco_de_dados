/*
FUNCIONANDO !!
6) Defina uma função que tem como parâmetro de entrada o nome (ou parte do)
nome do compositor e o parâmetro de saída todos os álbuns com obras
compostas pelo compositor.
*/

  
create function albuns_com_obras_compositor
(@nome_compositor nvarchar(50))
returns @tab_result table
(cod_compositor smallint,nome_album nvarchar(50), nome_faixa nvarchar(100))

as
begin
declare @nome_comp nvarchar(50)
  set @nome_comp = @nome_compositor
begin
   insert into @tab_result

   select c.cod_compositor,isnull(a.nome,0),isnull(f.descricao_faixa ,0) from album a 
   right join faixa f on a.cod_album = f.codigo_album
right join  faixa_compositor fc on f.id_faixa = fc.cod_faixa 
right join compositor c 
on fc.id_compositor = c.cod_compositor
  where  c.nome_compositor like @nome_comp
end
return
end

select * from albuns_com_obras_compositor('%GUI%')