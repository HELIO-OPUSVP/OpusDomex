#Include "Protheus.ch"
#include "rwmake.ch"
#include "totvs.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FIVEWIN.CH"
#Include "COLORS.CH"
#Include "FONT.CH"
#INCLUDE "MSOBJECT.CH"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  EICFLWPR   ºAutor  ³Mauricio Opus     º Data ³ 220/05/3022    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao FOLLOWUP   º       ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de FollowUP  dinamico Sigaeic                       º±±
±±º          ³ Reprocessamento Automatico                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex - SIGAFAT                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------------------------*
User Function EICFLWPR()
	*----------------------------------------------------------*

	Private dGetPodt1 := (Date()-365)
	Private dGetPodt2 := Date()
	Private cGetPoEIC1:= SPACE(20)
	Private cGetPoEIC2:= 'ZZZZZZZZZZZZZZZ'
	Private cGetPn1   := SPACE(15)
	Private cGetpn2   := 'ZZZZZZZZZZZZZZZ'
	Private aCols1    := {}
	Private cDesc     := SPACE(20)
	Private cfornec   := SPACE(20)
	Private cimp      := SPACE(20)
	Private cagent    := SPACE(20)
	Private cblhouse  := SPACE(20)
	Private cXmodal    := SPACE(20)
	Private cnf       := SPACE(09)
	Private dtconf    := Date()	
	Private cComboBox6:="Todos"

	Private nLINHA :=0
	Private cLINHA :=''
	PRIVATE cPONUM :=''

	PRIVATE nLT      := 0
	PRIVATE nTRSTIME := 0

	PRIVATE oBmpVerde    := LoadBitmap( GetResources(), "BR_VERDE")
	PRIVATE oBmpVermelho := LoadBitmap( GetResources(), "BR_VERMELHO")
	PRIVATE oBmpPreto    := LoadBitmap( GetResources(), "BR_PRETO")
	PRIVATE oBmpAZUL     := LoadBitmap( GetResources(), "BR_AZUL")
	PRIVATE oBmpLARANJA  := LoadBitmap( GetResources(), "BR_LARANJA")
	PRIVATE oBmpPINK     := LoadBitmap( GetResources(), "BR_PINK")


	aemp := {"01","02"}
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER 'MRP' PASSWORD 'MRP'  

	******************************************************************************
	_cData    := DtoC(Date())
	_cAssunto := "Atualizacao FUP inicio -  Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	_cTexto   := "Atualizacao FUP inicio -  Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14) +"- Data " + _cData + "    " +Time()+Chr(13)+ " User: " + Subs(cUsuario,7,14) +Chr(13)
	_cPara    := 'mauricio.souza@opusvp.com.br '
	_cCC      := ""
	_cArquivo := ""

	U_EnvMailto(_cAssunto,_cTexto,_cPara,_cCC,_cArquivo)
	******************************************************************************
	// query
	cQuery := "SELECT W2_ORIGEM,WN_PO_NUM AS W2_PO_SIGA,CCH_PAIS,W3_PO_NUM            AS W2_PO_NUM,W3_POSICAO AS  W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,WN_DOC,WN_QUANT,WN_HAWB,WN_INVOICE,WN_SDOC,WN_QUANT,WN_ITEM,A2_COD,A2_LOJA,WN_HAWB, "
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK) ,"
	cQuery += "      SWN010 SWN WITH(NOLOCK)"
	cQuery += " WHERE W3_PO_NUM LIKE('DA%') AND WN_PO_EIC  LIKE('DA%') "
	cQuery += " AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I"
	cQuery += " AND W2_PO_NUM=WN_PO_EIC AND W3_COD_I=WN_PRODUTO AND WN_ITEM_DA=W3_POSI_DA"
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W3_PO_DA  >='"+cGetPoEIC1+"'      AND W3_PO_DA  <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  SWN.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += " AND  WN_FILIAL='"+xFILIAL('SWN')+"' "

	//COM NF SEM DA
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,WN_DOC,WN_QUANT,WN_HAWB,WN_INVOICE,WN_SDOC,WN_QUANT,WN_ITEM,A2_COD,A2_LOJA,WN_HAWB,"
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK) ,"
	cQuery += "      SWN010 SWN WITH(NOLOCK)"
	cQuery += "	WHERE  W3_PO_NUM NOT LIKE('DA%') AND WN_PO_EIC NOT LIKE('DA%') "
	cQuery += "	AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I"
	cQuery += "	AND W2_PO_NUM=WN_PO_EIC AND W3_COD_I=WN_PRODUTO AND W3_POSICAO=WN_ITEM_DA"
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  SWN.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += " AND  WN_FILIAL='"+xFILIAL('SWN')+"' "

	//SEM NF
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,'' WN_DOC,0 WN_QUANT,'' WN_HAWB,'' WN_INVOICE,'' WN_SDOC,0 WN_QUANT,'' WN_ITEM,A2_COD,A2_LOJA,'' WN_HAWB, "
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	cQuery += "  FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK),
	cQuery += " SW5010 SW5 WITH(NOLOCK)
	cQuery += " WHERE   W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I  AND W5_HAWB='' AND W5_POSICAO=W3_POSICAO
	cQuery += " AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND  SW5.D_E_L_E_T_=''"
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  W5_FILIAL='"+xFILIAL('SW5')+"' "
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += "	 AND W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN
	cQuery += "     (SELECT WN_PO_EIC+WN_PRODUTO+WN_ITEM FROM SWN010  WITH(NOLOCK) WHERE D_E_L_E_T_='' AND WN_PO_EIC=W2_PO_NUM AND WN_PRODUTO=W3_COD_I
	cQuery += "  AND WN_ITEM=W3_POSICAO )
	cQuery += "	AND   W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN  "
	cQuery += "  (SELECT W5_PO_NUM+W5_COD_I+W5_POSICAO FROM SW5010  WITH(NOLOCK) WHERE D_E_L_E_T_=''  "
	cQuery += "  AND W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I AND W5_POSICAO=W3_POSICAO AND W5_HAWB<>'') "

	//SEM NF COM IMP (HAWB)
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA, "
	cQuery += " W3_COD_I,B1_DESC,W3_QTDE ,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,'' WN_DOC,0 WN_QUANT,W5_HAWB WN_HAWB,'' WN_INVOICE,'' WN_SDOC,0 WN_QUANT,'' WN_ITEM,A2_COD,A2_LOJA,W5_HAWB WN_HAWB, "
	cQuery += " W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,'' AS W3_XENTREG,W3_XFREIGT, "
	cQuery += " W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += " W2_TIPO_EM,W2_DEST "
	cQuery += " FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK), "
	cQuery += " SW5010 SW5 WITH(NOLOCK) "
	cQuery += " WHERE  W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I  AND W5_HAWB<>'' AND W5_POSICAO=W3_POSICAO "
	cQuery += " AND W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I "
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0 "
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  SW5.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL ='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL ='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL ='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL ='"+xFILIAL('SB1')+"' "
	cQuery += " AND  W5_FILIAL ='"+xFILIAL('SW5')+"' "
	cQuery += " AND W2_PO_NUM +W3_COD_I+W5_HAWB NOT IN "
	cQuery += " (SELECT WN_PO_EIC+WN_PRODUTO+WN_HAWB FROM SWN010 WHERE D_E_L_E_T_='' AND WN_PO_EIC=W2_PO_NUM AND WN_PRODUTO=W3_COD_I AND WN_HAWB=W5_HAWB ) "
	cQuery += " AND TRIM(W2_PO_SIGA)+TRIM(W3_COD_I)+SUBSTRING(W5_HAWB,1,11) NOT IN "
	cQuery += " (SELECT TRIM(WN_PO_NUM)+TRIM(WN_PRODUTO)+SUBSTRING(WN_HAWB,1,11) "
	cQuery += " FROM SWN010  WITH(NOLOCK) WHERE D_E_L_E_T_='' AND SUBSTRING(WN_HAWB,1,11)=SUBSTRING(W5_HAWB,1,11) "
	cQuery += " AND TRIM(WN_PO_NUM)=TRIM(W2_PO_SIGA) AND TRIM(WN_PRODUTO)=TRIM(W3_COD_I) ) "

	*---------------------------------------------------------------------------------------------
	// PRODUTO ANUENTE
	cQuery += " UNION ALL "
	cQuery += " SELECT W2_ORIGEM,W2_PO_SIGA,CCH_PAIS,W2_PO_NUM,W3_POSICAO,W2_PO_DT,A2_NREDUZ,W2_DIAS_PA,"
	cQuery += "       W3_COD_I,B1_DESC,W3_QTDE,W3_PRECO,W3_QTDE*W3_PRECO VL_TOT ,'' WN_DOC,0 WN_QUANT,'' WN_HAWB,'' WN_INVOICE,'' WN_SDOC,0 WN_QUANT,'' WN_ITEM,A2_COD,A2_LOJA,'' WN_HAWB, "
	cQuery += "       W3_XXOBS,W3_XCONFDT,W3_XNEWDT,W3_XPRVPO,W3_XCOLETA,W3_XETD,W3_XETA,W3_XPRALER,W3_XPRDSB,W3_XENTREG,W3_XFREIGT, "
	cQuery += "       W3_XMODAL,W3_XDTPCOL,W3_XHOUSE , "
	cQuery += "       W2_TIPO_EM,W2_DEST "
	cQuery += "  FROM SW2010 SW2 WITH(NOLOCK),SW3010 SW3 WITH(NOLOCK),SA2010 SA2 WITH(NOLOCK),CCH010 CCH WITH(NOLOCK) ,SB1010 SB1 WITH(NOLOCK)
	cQuery += " WHERE  W2_PO_NUM=W3_PO_NUM AND A2_COD+A2_LOJA=W2_FORN+W2_FORLOJ AND   CCH_CODIGO=A2_CODPAIS AND B1_COD=W3_COD_I
	cQuery += " AND W2_PO_DT  >='"+DTOS(dGetPodt1)+"' AND W2_PO_DT  <='"+DTOS(dGetPodt2)+"' "
	cQuery += " AND W2_PO_NUM >='"+cGetPoEIC1+"'      AND W2_PO_NUM <='"+cGetPoEIC2+"' "
	cQuery += " AND W3_COD_I  >='"+cGetPn1+"'         AND W3_COD_I  <='"+cGetPn2+"' "
	cQuery += " AND W3_SEQ=0"
	cQuery += " AND W3_FLUXO='1' "   //ANUENTE
	cQuery += " AND  SW2.D_E_L_E_T_=''"
	cQuery += " AND  SW3.D_E_L_E_T_=''"
	cQuery += " AND  SA2.D_E_L_E_T_=''"
	cQuery += " AND  CCH.D_E_L_E_T_=''"
	cQuery += " AND  SB1.D_E_L_E_T_=''"
	cQuery += " AND  W2_FILIAL='"+xFILIAL('SW2')+"' "
	cQuery += " AND  W3_FILIAL='"+xFILIAL('SW3')+"' "
	cQuery += " AND  A2_FILIAL='"+xFILIAL('SA2')+"' "
	cQuery += " AND  CCH_FILIAL='"+xFILIAL('CCH')+"' "
	cQuery += " AND  B1_FILIAL='"+xFILIAL('SB1')+"' "
	cQuery += "	 AND W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN
	cQuery += "     (SELECT WN_PO_EIC+WN_PRODUTO+WN_ITEM FROM SWN010  WITH(NOLOCK) WHERE D_E_L_E_T_='' AND WN_PO_EIC=W2_PO_NUM AND WN_PRODUTO=W3_COD_I
	cQuery += "  AND WN_ITEM=W3_POSICAO )
	cQuery += "	AND   W2_PO_NUM+W3_COD_I+W3_POSICAO NOT IN  "
	cQuery += "  (SELECT W5_PO_NUM+W5_COD_I+W5_POSICAO FROM SW5010   WITH(NOLOCK) WHERE D_E_L_E_T_=''  "
	cQuery += "  AND W5_PO_NUM=W2_PO_NUM AND W5_COD_I=W3_COD_I AND W5_POSICAO=W3_POSICAO ) "

	//------------------------------------------------------------------------------------------------------------
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQuery ), "TRB", .F., .T. )

	nRecno := 0

	TRB->( dbEval({|| nRecno++}) )

	ProcRegua(nRecno)

	TRB->( DbGoTop() )

	While TRB->(!Eof())

		IncProc()

		cHAWB      := ''
		cW6_DI_NUM := ''

		SW7->(DbSetOrder(RetOrder("SW7","W7_FILIAL+W7_PO_NUM+W7_COD_I+W7_POSICAO")))
		If SW7->( dbSeek( xFilial() + SUBSTR(TRB->W2_PO_NUM,1,20) + TRB->W3_COD_I + TRB->W3_POSICAO ) )
			SW6->( dbSetOrder(1) )
			IF SW6->( dbSeek( xFilial() + SW7->W7_HAWB ) )
				cW6_DI_NUM := SW6->W6_DI_NUM
			ENDIF
			IF EMPTY(TRB->WN_HAWB)
				cHAWB :=SW7->W7_HAWB
			ELSE
				cHAWB := TRB->WN_HAWB
			EndIf
		ENDIF

		lGRAVA:=.T.

		IF !EMPTY(cimp) .and. lGRAVA==.T.
			IF ALLTRIM(CIMP)$ALLTRIM(cHAWB)
				lGRAVA:=.T.
			ELSE
				lGRAVA:=.F.
				TRB->(DbSkip())
				Loop
			ENDIF
		ENDIF

		IF (TRB->W2_PO_NUM+'/'+TRB->W3_POSICAO+' - '+TRB->W2_PO_SIGA) == cPONUM
			nLINHA := nLINHA
		ELSE
			nLINHA := nLINHA+1
			cPONUM := TRB->W2_PO_NUM+'/'+TRB->W3_POSICAO+' - '+TRB->W2_PO_SIGA
		ENDIF

		cW8_INVOICE := ''
		SW8->( dbSetOrder(RetOrder("SW8","W8_FILIAL+W8_FORN+W8_FORLOJ+W8_COD_I+W8_PO_NUM+W8_POSICAO")) )
		If SW8->( dbSeek( xFilial() + TRB->A2_COD + TRB->A2_LOJA + TRB->W3_COD_I + SUBSTR(TRB->W2_PO_NUM,1,20) + TRB->W3_POSICAO ) )
			cW8_INVOICE := SW8->W8_INVOICE
		EndIf

		// CALCULO LEAD TIME  LT ENTREGA - COLETA     DateDiffDay (Data1, Data2)
		nLT := 0
		IF !EMPTY(TRB->W3_XENTREG) .AND. !EMPTY(TRB->W3_XCOLETA)
			nLT :=  DateDiffDay((STOD(TRB->W3_XENTREG)),(STOD(TRB->W3_XCOLETA)))
		ENDIF

		IF EMPTY(TRB->W3_XMODAL)
			//cMODAL :=POSICIONE('SYQ',1,xFILIAL('SYQ')+TRB->W2_TIPO_EM,'YQ_COD_DI')
			SYQ->( dbSetOrder(1) )
			If SYQ->( dbSeek( xFilial()+TRB->W2_TIPO_EM ) )
				cMODAL :=SYQ->YQ_COD_DI
			ENDIF
		ELSE
			cMODAL := TRB->W3_XMODAL
		ENDIF

		IF !EMPTY(cXmodal)
			IF substring(cXmodal,1,1)==substring(cModal,1,1)
				lGRAVA:=.T.
			ELSE
				lGRAVA:=.F.
				TRB->(DbSkip())
				Loop
			ENDIF
		ENDIF

		*-------------------------------------------------------------------------------------*
		IF substr(cComboBox6,1,1)=='N' .and. empty(cimp)
			IF ALLTRIM(TRB->W3_XMODAL)=='B-COURIER'
				lGRAVA:=.F.
				TRB->(DbSkip())
				Loop
			ELSE
				if  !EMPTY(cHAWB)
					lGRAVA:=.F.
					TRB->(DbSkip())
					Loop
				ELSE
					lGRAVA:=.T.
				endif
			ENDIF
		ENDIF
		*-------------------------------------------------------------------------------------*
		IF substr(cComboBox6,1,1)=='S' .and. empty(cimp)
			IF ALLTRIM(TRB->W3_XMODAL)=='B-COURIER'
				lGRAVA:=.T.
			ELSE
				if  EMPTY(cHAWB)
					lGRAVA:=.F.
					TRB->(DbSkip())
					Loop
				ELSE
					lGRAVA:=.T.
				endif
			ENDIF
		ENDIF
		*-------------------------------------------------------------------------------------*

		// COR LEGENDA -------------------------------------------
		IF !EMPTY(TRB->W3_XENTREG)
			oBmpAux :=oBmpVermelho
		Endif

		IF ALLTRIM(TRB->W3_XMODAL)=='B-COURIER'
			oBmpAux :=oBmpLARANJA
		ENDIF
		if  !EMPTY(cHAWB) .AND. EMPTY(TRB->W3_XENTREG)
			oBmpAux :=oBmpaZUL
		ENDIF
		if  EMPTY(cHAWB) .AND. EMPTY(TRB->W3_XENTREG)
			oBmpAux :=oBmpVerde
		ENDIF
		//----------------------------------------------------------------------------------
		nSLDPO :=0
		cOBS   := TRB->W3_XXOBS
		SC7->(DbSelectArea("SC7"))
		SC7->(DbSetOrder(1)) // C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN
		IF SC7->(DbSeek(xFilial("SC7")+SUBSTR(TRB->W2_PO_SIGA,1,6)+TRB->W3_POSICAO))
			IF SC7->C7_RESIDUO<>'S'
				nSLDPO :=SC7->C7_QUANT-SC7->C7_QUJE
			ELSE
				If !('Residuo' $ cOBS)
					cOBS:='Residuo '+cOBS
				ENDIF
			ENDIF
			dDatPC  := SC7->C7_XDATPRF
		ELSE
			dDatPC  := DATE()
		ENDIF
		//----------------------------------------------------------------------------------
		nQTDIMP:=0
		nSLDIMP:=0
		dTEMB  :=STOD(TRB->W3_XCOLETA)   //COLETA
		dDTPCOL:=STOD(TRB->W3_XDTPCOL)
		IF !EMPTY(cHAWB)
			SW5->( dbSetOrder(RetOrder("SW5","W5_FILIAL+W5_HAWB+W5_PO_NUM+W5_COD_I+W5_POSICAO")) )
			If SW5->( dbSeek( xFilial() + cHAWB + SUBSTR(TRB->W2_PO_NUM,1,20) + TRB->W3_COD_I + TRB->W3_POSICAO ) )
				nQTDIMP := SW5->W5_QTDE
				nSLDIMP := SW5->W5_SALDO_Q
				dTEMB   := SW5->W5_DT_EMB
			EndIf
		ENDIF

		//------------Data coleta /modal pelo embarque SW6-----------------------------
		IF !EMPTY(cHAWB)
			SW6->( dbSetOrder(RetOrder("SW6","W6_FILIAL+W6_HAWB")) )
			If SW6->( dbSeek( xFilial() + cHAWB ) )
				dTEMB   := SW6->W6_DT_EMB
				_cVIATR := SW6->W6_VIA_TRA //MLSMODAL

				cQRYTIME :=" SELECT YR_TRANS_T,YQ_COD_DI FROM TRANSIT_TIME "
				cQRYTIME +=" WHERE YR_ORIGEM='"+alltrim(SW6->W6_ORIGEM)+"' AND  YR_VIA='"+_cVIATR+"' "
				If Select("TR8") > 0
					TR8->(dbCloseArea())
				EndIf
				dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQRYTIME ), "TR8", .F., .T. )
				nTRSTIME:=TR8->YR_TRANS_T
				cMODAL  :=TR8->YQ_COD_DI
				If Select("TR8") > 0
					TR8->(dbCloseArea())
				EndIf

			EndIf
		ELSE
			//
		ENDIF

		nSLDIMP:=0

		cQRYIMP := " SELECT SUM(W5_QTDE) AS XQTDIMP FROM "+RETSQLNAME('SW5')+"  WITH(NOLOCK) "
		cQRYIMP += " WHERE D_E_L_E_T_='' AND  W5_PO_NUM='"+TRB->W2_PO_NUM+"' "
		cQRYIMP += " AND  W5_POSICAO='"+TRB->W3_POSICAO+"' AND W5_SEQ<>0
		cQRYIMP += " AND  W5_COD_I  ='"+TRB->W3_COD_I+"'  "
		cQRYIMP += " AND W5_FILIAL='"+xFILIAL('SW5')+"' "
		If Select("TR6") > 0
			TR6->(dbCloseArea())
		EndIf
		dbUseArea( .T.,"TOPCONN", TcGenQry( ,,cQRYIMP ), "TR6", .F., .T. )

		If Select("TR6") > 0
			If !('Residuo' $ cOBS)
				nSLDIMP:=TRB->W3_QTDE-TR6->XQTDIMP
			ELSE
				nSLDIMP:=0
			ENDIF
			TR6->(dbCloseArea())
		EndIf

		dPRVRDT:=STOD(TRB->W3_XPRDSB)
		IF !EMPTY(TRB->W3_XETA)//MLS ETA AEREO +3  MARITMO+15
			IF SUBSTRING(CMODAL,1,1)=='1'
				dPRVRDT := DaySum(STOD(TRB->W3_XETA), 15)
			ELSE
				dPRVRDT := DaySum(STOD(TRB->W3_XETA), 3)
			ENDIF
			dPRVRDT := DataValida(dPRVRDT,.T.)
		ENDIF
		IF !EMPTY(TRB->W3_XPRALER)
			IF SUBSTRING(CMODAL,1,1)=='1'
				dPRVRDT := DaySum(STOD(TRB->W3_XPRALER), 15)
			ELSE
				dPRVRDT := DaySum(STOD(TRB->W3_XPRALER) , 3)
			ENDIF
			dPRVRDT := DataValida(dPRVRDT,.T.)
		ENDIF

		IF lGRAVA == .T.
			//cCODPRF :=ALLTRIM(POSICIONE('SA5',2,xFILIAL('SA5')+TRB->W3_COD_I+TRB->A2_COD+TRB->A2_LOJA,'A5_CODPRF'))
			SA5->( dbSetOrder(2) )
			If SA5->( dbSeek( xFilial()+TRB->W3_COD_I+TRB->A2_COD+TRB->A2_LOJA ) )
				cCODPRF :=SA5->A5_CODPRF
			ELSE
				cCODPRF :=''
			ENDIF

			//dDatanf := posicione('SF1',1,xFILIAL('SF1')+TRB->WN_DOC+TRB->WN_SDOC+TRB->A2_COD+TRB->A2_LOJA+'N','F1_EMISSAO')
			SF1->( dbSetOrder(1) )
			If SF1->( dbSeek( xFilial()+TRB->WN_DOC+TRB->WN_SDOC+TRB->A2_COD+TRB->A2_LOJA+'N' ) )
				dDatanf :=SF1->F1_EMISSAO
			ELSE
				dDatanf :=''
			ENDIF
			//dDatPC  := posicione('SC7',4,xFILIAL('SC7')+TRB->W3_COD_I+SUBSTR(TRB->W2_PO_SIGA,1,6)+TRB->W3_POSICAO+TRB->W3_POSICAO,'C7_XDATPRF')

			/*    01 @BMP                   */	AADD(aCols1, {oBmpAux   ,  ;
				/*02 Linha       ZZT_NLINHA */	Transform(nLINHA,"@E 99999") ,;
				/*03 Origin      ZZT_ORIGIN */	TRB->W2_ORIGEM+'-'+TRB->CCH_PAIS  ,;
				/*04 PO          ZZT_PO_NUM */	TRB->W2_PO_NUM+'/'+TRB->W3_POSICAO ,;
				/*05 PO SIGA     ZZT_PO_SIG */	TRB->W2_PO_SIGA ,;
				/*06 PO Date     ZZT_DT_PO  */	StoD(TRB->W2_PO_DT) ,;
				/*07 Sup Cod     ZZT_SUPCOD */	TRB->A2_COD+'/'+TRB->A2_LOJA ,;
				/*08 Supplier    ZZT_SUPPLI */	TRB->A2_NREDUZ ,;
				/*09 PN          ZZT_COD_I  */	TRB->W3_COD_I ,;
				/*10 PN Fornec   ZZT_CODFOR */	cCODPRF ,;
				/*11 Description ZZT_DESCR  */	TRB->B1_DESC ,;
				/*12 Qty         ZZT_QUANT  */	TRB->W3_QTDE ,;
				/*13 Unit Price  ZZT_VL_UNI */	TRB->W3_PRECO ,;
				/*14 Total Price ZZT_VL_TOT */	TRB->VL_TOT ,;
				/*15 Requested   ZZT_DTREQU */	dDatPC ,;
				/*16 Confirmed   ZZT_DTCONF */	STOD(TRB->W3_XCONFDT) ,;
				/*17 New Date    ZZT_DTNEW  */	STOD(TRB->W3_XNEWDT) ,;
				/*18 Pre PortXrddZZT_DTPPOR */	STOD(TRB->W3_XPRVPO) ,;
				/*19 Pag Antec.  ZZT_PGTANT */	TRB->W2_DIAS_PA ,;
				/*20 Modal       ZZT_MODAL SUBSTR(TRB->W3_XMODAL,1,1)  */	cMODAL,;
				/*21 IMP         ZZT_HAWB   */	cHAWB ,;
				/*22 Coleta      ZZT_DTCOLE 	STOD(TRB->W3_XCOLETA) */   dTEMB,;
				/*23 Prv ColxRdt ZZT_DTPCOL 	STOD(TRB->W3_XDTPCOL)*/   dDTPCOL,;
				/*24 Freight     ZZT_FREIGH */	TRB->W3_XFREIGT ,;
				/*25 ETD         ZZT_ETD    */	STOD(TRB->W3_XETD) ,;
				/*26 ETA         ZZT_ETA    */	STOD(TRB->W3_XETA) ,;
				/*27 Pre Alerta  ZZT_DTALER */	STOD(TRB->W3_XPRALER) ,;
				/*28 Prev Rdt    ZZT_PRVRDT 	STOD(TRB->W3_XPRDSB) */  dPRVRDT,;
				/*29 Prev Rdt    ZZT_HOUSE  */	TRB->W3_XHOUSE ,;
				/*30 Obs         ZZT_OBS    */	cOBS ,;
				/*31 Entrega     ZZT_ENTREG */	STOD(TRB->W3_XENTREG) ,;
				/*32 Lead Time   ZZT_LT     */	nLT ,;
				/*33 DI          ZZT_DI     */	cW6_DI_NUM ,;
				/*34 Invoice     ZZT_INVOIC */	cW8_INVOICE,;
				/*35 Nota Fiscal ZZT_NFISCA */	IIF(!EMPTY(TRB->WN_DOC),TRB->WN_DOC+' '+TRB->WN_SDOC+'/'+TRB->WN_ITEM,'') ,;
				/*36 Qtde nfe    ZZT_QTDNFE */	TRB->WN_QUANT ,;
				/*37 Data NF     ZZT_DTNF   */	dDatanf ,;
				/*38 Sld_PO_Qty  ZZT_SLDPO  */	nSLDPO ,;
				/*39 Qty_IMP     ZZT_QTDIMP */	nQTDIMP ,;
				/*40 SLD_PO_IMP  ZZT_SLD_PO */	nSLDIMP ,;
				/*41 Transit time           */	nTRSTIME ,;
				/*42 FLAG                   */ .F. })
		ENDIF

		TRB->(DbSkip())
	EndDo

	IF nLINHA == 0
		/*    01 @BMP                   */	AADD(aCols1, {' '   ,  ;
			/*02 Linha       ZZT_NLINHA */	Transform(nLINHA,"@E 99999") ,;
			/*03 Origin      ZZT_ORIGIN */	' ' ,;
			/*04 PO          ZZT_PO_NUM */	' ' ,;
			/*05 PO SIGA     ZZT_PO_SIG */	' ' ,;
			/*06 PO Date     ZZT_DT_PO  */	' ' ,;
			/*07 Sup Cod     ZZT_SUPCOD */	' ' ,;
			/*08 Supplier    ZZT_SUPPLI */	' ' ,;
			/*09 PN          ZZT_COD_I  */	' ' ,;
			/*10 PN Fornec   ZZT_CODFOR */	' ' ,;
			/*11 Description ZZT_DESCR  */	' ' ,;
			/*12 Qty         ZZT_QUANT  */	' ' ,;
			/*13 Unit Price  ZZT_VL_UNI */	' ' ,;
			/*14 Total Price ZZT_VL_TOT */	' ' ,;
			/*15 Requested   ZZT_DTREQU */	' ' ,;
			/*16 Confirmed   ZZT_DTCONF */	' ' ,;
			/*17 New Date    ZZT_DTNEW  */	' ' ,;
			/*18 Pre PortXrddZZT_DTPPOR */	' ' ,;
			/*19 Pag Antec.  ZZT_PGTANT */	' ' ,;
			/*20 Modal       ZZT_MODAL SUBSTR(TRB->W3_XMODAL,1,1)  */	' ',;
			/*21 IMP         ZZT_HAWB   */	' ' ,;
			/*22 Coleta      ZZT_DTCOLE */	' ' ,;
			/*23 Prv ColxRdt ZZT_DTPCOL */	' ' ,;
			/*24 Freight     ZZT_FREIGH */	' ' ,;
			/*25 ETD         ZZT_ETD    */	' ' ,;
			/*26 ETA         ZZT_ETA    */	' ' ,;
			/*27 Pre Alerta  ZZT_DTALER */	' ' ,;
			/*28 Prev Rdt    ZZT_PRVRDT */	' ' ,;
			/*29 Prev Rdt    ZZT_HOUSE  */	' ' ,;
			/*30 Obs         ZZT_OBS    */	' ' ,;
			/*31 Entrega     ZZT_ENTREG */	' ' ,;
			/*32 Lead Time   ZZT_LT     */	' ' ,;
			/*33 DI          ZZT_DI     */	' ' ,;
			/*34 Invoice     ZZT_INVOIC */	' ' ,;
			/*35 Nota Fiscal ZZT_NFISCA */	' ' ,;
			/*36 Qtde nfe    ZZT_QTDNFE */	' ' ,;
			/*37 Data NF     ZZT_DTNF   */	' ' ,;
			/*38 Sld_PO_Qty  ZZT_SLDPO  */	' ' ,;
			/*39 QTY_IMP     ZZT_QTDIMP */	' ' ,;
			/*40 SLD_PO_IMP  ZZT_SLD_PO */	' ' ,;
			/*41 Transit time           */	' ' ,;
			/*42 FLAG                   */ .T. })
	ENDIF

	TRB->(DbCloseArea())
	If Select("TR2") > 0
		TR2->(dbCloseArea())
	EndIf
	If Select("TR3") > 0
		TR3->(dbCloseArea())
	EndIf
	If Select("TR5") > 0
		TR5->(dbCloseArea())
	EndIf

	fGRAVAZZT()

	******************************************************************************
	_cAssunto  := "Atualizacao FUP fim -  Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	_cTexto    := "Atualizacao FUP fim -  Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14) +"- Data " + _cData + "    " +Time()+Chr(13)+ " User: " + Subs(cUsuario,7,14) +Chr(13)
	_cPara     := 'mauricio.souza@opusvp.com.br '
	_cCC       := ""
	_cArquivo  := ""

	U_EnvMailto(_cAssunto,_cTexto,_cPara,_cCC,_cArquivo)
	******************************************************************************

	RESET ENVIRONMENT


Return Nil


//-------------------------------------------------------
STATIC FUNCTION fGRAVAZZT()
	//-------------------------------------------------------
	Local nX:=0
	Local cQRDEL1 :=''

	******************************************************************************
	_cAssunto  := "Atualizacao FUP Grava ZZT -  Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14)
	_cTexto    := "Atualizacao FUP Grava TMP -  Environment: " + GetEnvServer() + " User: " + Subs(cUsuario,7,14) +"- Data " + _cData + "    " +Time()+Chr(13)+ " User: " + Subs(cUsuario,7,14) +Chr(13)
	_cPara     := 'mauricio.souza@opusvp.com.br '
	_cCC       := ""
	_cArquivo  := ""

	U_EnvMailto(_cAssunto,_cTexto,_cPara,_cCC,_cArquivo)
	******************************************************************************


	For nX := 1 to len (aCols1)
		cQRDEL1:=" DELETE FROM ZZT010 WHERE ZZT_PO_NUM ='"+acols1[nX][04]+"' "
		TCSqlExec(cQRDEL1)
	next nx

	cQRDEL2 := " DELETE FROM ZZT010 WHERE SUBSTRING(ZZT_PO_SIG,1,6)+SUBSTRING(ZZT_PO_NUM,22,4) NOT IN  "
	cQRDEL2 += " (SELECT C7_NUM+C7_ITEM FROM SC7010  WITH(NOLOCK)  WHERE C7_NUM=SUBSTRING(ZZT_PO_SIG,1,6) AND C7_ITEM=SUBSTRING(ZZT_PO_NUM,22,4) "
	cQRDEL2 += "      AND C7_FILIAL='"+xFILIAL('SC7')+"' AND D_E_L_E_T_='')  "
	cQRDEL2 += " AND SUBSTRING(ZZT_PO_NUM,1,2)<>'DA' AND ZZT_FILIAL='"+xFILIAL('ZZT')+"' "
	TCSqlExec(cQRDEL2)

	cQRDEL3 := " DELETE FROM ZZT010  "
	cQRDEL3 += " WHERE SUBSTRING(ZZT_PO_NUM,1,20)+SUBSTRING(ZZT_PO_NUM,22,4) NOT IN  "
	cQRDEL3 += " (SELECT W3_PO_NUM+W3_POSICAO FROM SW3010  WITH(NOLOCK)  WHERE W3_PO_NUM=SUBSTRING(ZZT_PO_NUM,1,20) AND W3_POSICAO=SUBSTRING(ZZT_PO_NUM,22,4) "
	cQRDEL3 += "    AND W3_FILIAL='"+xFILIAL('SW3')+"'AND D_E_L_E_T_='')  "
	cQRDEL3 += " AND SUBSTRING(ZZT_PO_NUM,1,2)<>'DA' AND ZZT_FILIAL='"+xFILIAL('ZZT')+"' "
	TCSqlExec(cQRDEL3)

	//---------------------------------------------------------------------------------------------------

	dbSelectArea("ZZT")
	ZZT->(dbSetOrder(1)) //ZZT_FILIAL+ZZT_PO_NUM

	For nX := 1 to len (aCols1)
		IF !EMPTY(aCols1[nX][04])
			RECLOCK('ZZT',.T.)
			ZZT_FILIAL :=xFILIAL('ZZT')
			/*    01 @BMP                        AADD(aCols1, {' '   ,  ; */
			/*02 Linha       ZZT_NLINHA 	Transform(nLINHA,"@E 99999") ,; */
			/*03 Origin       */ ZZT_ORIGIN :=aCols1[nX][03]
			/*04 PO           */ ZZT_PO_NUM :=aCols1[nX][04]
			/*05 PO SIGA      */ ZZT_PO_SIG :=aCols1[nX][05]
			/*06 PO Date      */ ZZT_DT_PO  :=aCols1[nX][06]
			/*07 Sup Cod      */ ZZT_SUPCOD :=aCols1[nX][07]
			/*08 Supplier     */ ZZT_SUPPLI :=aCols1[nX][08]
			/*09 PN           */ ZZT_COD_I  :=aCols1[nX][09]
			/*10 PN Fornec    */ ZZT_CODFOR :=aCols1[nX][10]
			/*11 Description  */ ZZT_DESCR  :=aCols1[nX][11]
			/*12 Qty          */ ZZT_QUANT  :=aCols1[nX][12]
			/*13 Unit Price   */ ZZT_VL_UNI :=aCols1[nX][13]
			/*14 Total Price  */ ZZT_VL_TOT :=aCols1[nX][14]
			/*15 Requested    */ ZZT_DTREQU :=aCols1[nX][15]
			/*16 Confirmed    */ ZZT_DTCONF :=aCols1[nX][16]
			/*17 New Date     */ ZZT_DTNEW  :=aCols1[nX][17]
			/*18 Pre PortXrdd */ ZZT_DTPPOR :=aCols1[nX][18]
			/*19 Pag Antec.   */ ZZT_PGTANT :=aCols1[nX][19]
			/*20 Modal        */ ZZT_MODAL  :=aCols1[nX][20]
			/*21 IMP          */ ZZT_HAWB   :=aCols1[nX][21]
			/*22 Coleta       */ ZZT_DTCOLE :=aCols1[nX][22]
			/*23 Prv ColxRdt  */ ZZT_DTPCOL :=aCols1[nX][23]
			/*24 Freight      */ ZZT_FREIGH :=aCols1[nX][24]
			/*25 ETD          */ ZZT_ETD    :=aCols1[nX][25]
			/*26 ETA          */ ZZT_ETA    :=aCols1[nX][26]
			/*27 Pre Alerta   */ ZZT_DTALER :=aCols1[nX][27]
			/*28 Prev Rdt     */ ZZT_PRVRDT :=aCols1[nX][28]
			/*29 Prev Rdt     */ ZZT_HOUSE  :=aCols1[nX][29]
			/*30 Obs          */ ZZT_OBS    :=aCols1[nX][30]
			/*31 Entrega      */ ZZT_ENTREG :=aCols1[nX][31]
			/*32 Lead Time    */ ZZT_LT     :=aCols1[nX][32]
			/*33 DI           */ ZZT_DI     :=aCols1[nX][33]
			/*34 Invoice      */ ZZT_INVOIC :=aCols1[nX][34]
			/*35 Nota Fiscal  */ ZZT_NFISCA :=aCols1[nX][35]
			/*36 Qtde nfe     */ ZZT_QTDNFE :=aCols1[nX][36]
			IF !EMPTY(aCols1[nX][37])
				/*37 Data NF      */ ZZT_DTNF   :=aCols1[nX][37]
			ENDIF
			/*38 Sld_PO_Qty   */ ZZT_SLDPO  :=aCols1[nX][38]
			/*39 QTY_IMP      */ ZZT_QTDIMP  :=aCols1[nX][39]
			/*40 QTY_IMP      */ ZZT_SLD_PO  :=aCols1[nX][40]
			/*41 Transit time            	' ' ,; */
			/*42 FLAG                    .T. }) */
			ZZT->(MsUnlock())
		ENDIF
	Next nX

return

