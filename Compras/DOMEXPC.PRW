/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMEXPC   �Autor  �Marcos Rezende      � Data �  12/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina tempor�ria para atualiza��o do pedido de compras    ���
���          � dos campos personalizados do cliente, no qual o ponto de   ���
���          � entrada MT160PLN n�o esta atualizando                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

user function DOMEXPC
cQuery := ""
cQuery+=CRLF+";WITH PCCOTA AS("
cQuery+=CRLF+"select C8_NUM,C8_ITEM,C8_NUMPED,C8_SEQFOR,C8_ITEFOR,C7_NUM,C7_EMISSAO,C8_DATPRF,C7_DATPRF,C7_DOMNECE,C7_XXORIGI,C8_PRAZO"
cQuery+=CRLF+",C7_OBS,"
cQuery+=CRLF+"	CASE "
cQuery+=CRLF+"		WHEN LTRIM(RTRIM(C8_SEQFOR)) <> ' '  THEN RTRIM(LTRIM(C7_OBS))+ ' PC: '+LTRIM(RTRIM(C8_SEQFOR))+'/'+C8_ITEFOR "
cQuery+=CRLF+"		ELSE C7_OBS "
cQuery+=CRLF+"	END C7_OBSNEW "
cQuery+=CRLF+""
cQuery+=CRLF+"FROM SC7010 SC7"
cQuery+=CRLF+"inner join SC8010 SC8 ON  C7_NUM = C8_NUMPED AND C7_ITEM = C8_ITEMPED"
cQuery+=CRLF+"WHERE "
cQuery+=CRLF+"SC8.D_E_L_E_T_=' ' "
cQuery+=CRLF+"AND SC7.D_E_L_E_T_=' '"
cQuery+=CRLF+"AND C7_XXORIGI=''"
cQuery+=CRLF+")"
cQuery+=CRLF+"UPDATE PCCOTA"
cQuery+=CRLF+"SET "
cQuery+=CRLF+"	C7_XXORIGI  = C7_DATPRF"
cQuery+=CRLF+"	,C7_DOMNECE = C7_DATPRF"
cQuery+=CRLF+"	,C7_OBS     = C7_OBSNEW"

TcSqlExec(cQuery) 
//tcquery cquery new alias "TMPSQL"


MATA121()
return