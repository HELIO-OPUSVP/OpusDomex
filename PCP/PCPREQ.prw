#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  11/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ NO MOMENTO DA PRODUÇÃO É VERIFICADO SE TEM REQUISIÇÃO DO ESTº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PCPREQ(cOP,cTM,lTM)

lRETURN := .T.

IF cTM = '010'  .AND. lTM
	cQuery := "SELECT * "
	cQuery += "FROM " + RetSqlName("SD3") + " (NOLOCK) "
	cQuery += "WHERE D3_OP='"+cOP+"' AND SD3010.D_E_L_E_T_='' AND D3_ESTORNO='' AND D3_TM='599' AND D3_FILIAL = '01'"
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QRYA",.F.,.T.)
	
	IF QRYA->(EOF())
		ALERT("REQUISIÇÃO PARA ESTA OM INEXISTENTE!"+CHR(13)+"Favor providenciar junto ao Almoxarifado as Requisições")
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
		ALERT("EXISTE(M) S.A.(s) EM ABERTO(S)!"+CHR(13)+"Favor verificar junto ao Almoxarifado as Requisições"+chr(13)+" ->    Não é possivel apontar OP com SA em Aberto.  <-")
		lRETURN := .F.
	ENDIF
	QRYA->(DBCLOSEAREA())
ENDIF

Return(lRETURN)
