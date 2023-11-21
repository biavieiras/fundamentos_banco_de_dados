
-- Questão 04:
-- Defina um índice primário para a tabela de Faixas sobre o atributo código do
-- álbum. Defina um índice secundário para a mesma tabela sobre o atributo tipo de
-- composição. Os dois com taxas de preenchimento máxima.

CREATE CLUSTERED INDEX faixas_IDX_album ON
FAIXAS (cod_album)
WITH (fillfactor = 100, pad_index = on)


CREATE NONCLUSTERED INDEX faixas_IDX_composicao ON
FAIXAS (codigo_composicao)
WITH (fillfactor = 100, pad_index = on)