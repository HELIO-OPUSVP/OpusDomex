/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RDT030I   �Autor  �Fabr�cio            � Data �  03/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chama fun��o MATA030 filtrando para os clientes inativos.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ROSENBERGER DOMEX TELECOM                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

user function rdt030i()

local fantigo := dbfilter()
local fnovo   := "A1_DMXATIV == '2'"

// Aplica filtro novo na tabela

dbselectarea("SA1")
dbsetfilter({ || &fnovo }, fnovo)

mata030()

// Volta filtro antigo

dbselectarea("SA1")
if !empty(fantigo)
  dbsetfilter({ || &fantigo }, fantigo)
else
  dbclearfil()
endif

return .t.