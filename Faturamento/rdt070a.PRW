/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RDT030A   �Autor  �Fabr�cio            � Data �  03/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chama fun��o MATA030 filtrando para os clientes ativos.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ROSENBERGER DOMEX TELECOM                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function rdt070a()

local fantigo
local fnovo   := "U5_ATIVO == '1'"

// Aplica filtro novo na tabela

dbselectarea("SU5")
fantigo := dbfilter()
dbsetfilter({ || &fnovo }, fnovo)

tmka070()

// Volta filtro antigo

dbselectarea("SU5")
if !empty(fantigo)
  dbsetfilter({ || &fantigo }, fantigo)
else
  dbclearfil()
endif

return .t.