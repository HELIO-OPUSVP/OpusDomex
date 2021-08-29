#include "totvs.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410PVNF  ºHelio Ferreira/Marco Aurelio º Data ³  19/06/19  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//FILIALMG

User Function M410PVNF()
Local _Retorno := .T.
Local aArea    := GetArea()

If _Retorno
	If SuperGetMV("MV_XANACRE")    // Parâmetro geral de liga/desliga análise de Crédito Domex
		_Retorno := U_ValidFat(SC5->C5_NUM)  
	EndIf
EndIf


// Jonas Validacao nova filial MG
If (SC5->C5_CLIENTE == '700000' .AND. SC5->C5_LOJACLI == '01' .AND. fwfilial() == "01") .OR. (SC5->C5_CLIENTE == '001078' .AND. SC5->C5_LOJACLI == '01' .AND. fwfilial() == "02")
	If SC6->( dbSeek( xFilial("SC6") + SC5->C5_NUM ))
		While SC6->(!EOF()) .AND. SC5->C5_NUM==SC6->C6_NUM .AND. SC5->C5_FILIAL==SC6->C6_FILIAL .AND. _Retorno
			If SC6->C6_LOCAL == "95"
				_Retorno := U_fvalXD1(SC6->C6_PRODUTO, SC6->C6_LOCAL, SC6->C6_QTDVEN)
			EndIf
		SC6->(dbskip())
		EndDo
	EndIf
EndIf

RestArea(aArea)

Return _Retorno



User function fvalXD1(cProd, cLoc, nQtd)
Local lValid := .t.


cQuery := "SELECT CASE WHEN SUM(XD1_QTDATU) IS NULL THEN 0 ELSE SUM(XD1_QTDATU) END AS QTDXD1 FROM " + RetSqlName("XD1") + " (NOLOCK) WHERE XD1_FILIAL = '"+xFilial("XD1")+"' AND XD1_COD = '"+cProd+"' AND "
cQuery += "XD1_LOCAL = '"+cLoc+"'  AND D_E_L_E_T_ = '' AND XD1_OCORRE= '4' "
	
If Select("QUERY") <> 0
	QUERY->( dbCloseArea() )
EndIf
	
TCQUERY cQuery NEW ALIAS "QUERY"
	
If QUERY->QTDXD1 < 0 // QUERY->( EOF() )
	If MsgYesNo("Não há etiquetas disponíveis para o produto : "+cProd+" armazem : "+cLoc+".")
		lValid := .F.
	Else
		lValid := .F.
	EndIf
Elseif QUERY->QTDXD1 <> nQtd
	If MsgYesNo("Filial " + xFilial("XD1") + ": Quantidade ("+alltrim(str(QUERY->QTDXD1))+") de etiquetas do produto  "+cProd+" armazem  "+cLoc+" quantidade ("+alltrim(str(nQtd))+ ") do pedido.")
		lValid := .F.
	Else
		lValid := .F.
	EndIf
EndIF

If Select("QUERY") <> 0
	QUERY->( dbCloseArea() )
EndIf

Return lValid
