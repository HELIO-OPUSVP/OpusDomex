#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  11/07/12   ���
�������������������������������������������������������������������������͹��
���Descricao � NO MOMENTO DA PRODU��O � VERIFICADO SE TEM REQUISI��O DO EST���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function PCPREQ(cOP,cTM,lTM)

lRETURN := .T.

IF cTM = '010'  .AND. lTM
	cQuery := "SELECT * "
	cQuery += "FROM " + RetSqlName("SD3") + " (NOLOCK) "
	cQuery += "WHERE D3_OP='"+cOP+"' AND SD3010.D_E_L_E_T_='' AND D3_ESTORNO='' AND D3_TM='599' AND D3_FILIAL = '01'"
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QRYA",.F.,.T.)
	
	IF QRYA->(EOF())
		ALERT("REQUISI��O PARA ESTA OM INEXISTENTE!"+CHR(13)+"Favor providenciar junto ao Almoxarifado as Requisi��es")
		lRETURN := .F.
	ENDIF
	QRYA->(DBCLOSEAREA())
ELSEIF cTM = '010'  .AND. !lTM
	
	//	SELECT * FROM SCP010 WHERE SCP010.D_E_L_E_T_='' AND CP_STATUS<>'E' AND CP_OP='49777 01001'
	cQuery := "SELECT * "
	cQuery += "FROM " + RetSqlName("SCP") + " (NOLOCK) "
	cQuery += "WHERE CP_OP='"+cOP+"' AND "+RetSqlName("SCP")+".D_E_L_E_T_='' AND CP_STATUS<>'E' AND CP_FILIAL = '01' "
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QRYA",.F.,.T.)
	
	IF !QRYA->(EOF())
		ALERT("EXISTE(M) S.A.(s) EM ABERTO(S)!"+CHR(13)+"Favor verificar junto ao Almoxarifado as Requisi��es"+chr(13)+" ->    N�o � possivel apontar OP com SA em Aberto.  <-")
		lRETURN := .F.
	ENDIF
	QRYA->(DBCLOSEAREA())
ENDIF

Return(lRETURN)
