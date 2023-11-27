/*
6) Defina uma função que tem como parâmetro de entrada o nome (ou parte do)
nome do compositor e o parâmetro de saída todos os álbuns com obras
compostas pelo compositor.
*/
create function albuns_com_obras_compositor
(@nome_compositor nvarchar(50))
returns @tab_result table
(nome_album nvarchar(50), cod_album smallint)

as
begin
declare @nome_comp nvarchar(50)
  set @nome_comp = @nome_compositor
begin
   insert into @tab_result

   select a.cod_album,a.nome  from album a, faixa f, faixa_compositor fc, compositor c
   where a.cod_album = f.codigo_album and f.id_faixa = fc.id_faixa and fc.codigo_compositor = c.cod_compositor
   and c.nome_compositor like @nome_comp
end
return
end