#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA650TOK  ºAutor  ³Helio Ferreira      º Data ³  28/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação Tudo Ok da inclusão manual de OP                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA650TOK()
Local _Retorno    := .T.
Local dDataLimite := CtoD("31/03/14")
Local aArea       := GetArea()
Local aAreaSB1    := SB1->( GetArea() )
Local cAlias
Local cAliasNum
Local cNumOpAtual

cQuery := "SELECT * FROM " + RetSqlName("SC2") + " (NOLOCK) WHERE C2_FILIAL = '"+xFilial("SC2")+"' AND C2_DATRF = '' AND D_E_L_E_T_ = '' AND C2_DATPRF < '"+DtoS(Date())+"' ORDER BY C2_DATPRF"

If Select("QUERYSC2") <> 0
	QUERYSC2->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSC2"

If !QUERYSC2->( EOF() )
	MsgStop("A Ordem de Produção " + Subs(QUERYSC2->C2_NUM + QUERYSC2->C2_ITEM + QUERYSC2->C2_SEQUEN,1,11) + " está com data de previsão de FIM atrasada. Favor corrigir sua data antes de incluir novas OPs.")
	If Date() <= dDataLimite
		MsgInfo("Após 31/03/14 estas inclusões serão bloqueadas.","")
		_Retorno := .T.
	Else
		_Retorno := .F.
	EndIf
EndIf

//verifica se o produto possui rastro(lote)

SB1->(DBSELECTAREA('SB1'))
SB1->(DBSETORDER(1))
If SB1->( dbSeek( xFilial() + M->C2_PRODUTO ) )
	IF ALLTRIM(SB1->B1_RASTRO)<>'L'
		MSGALERT('Produto :'+alltrim(M->C2_PRODUTO)+' Sem controle de Lote (B1_RASTRO)' ,"")
		_Retorno:=.F.
	ENDIF
	IF ALLTRIM(SB1->B1_LOCALIZ)<>'S'
		MSGALERT('Produto :'+alltrim(M->C2_PRODUTO)+' Sem controle de Endereço (B1_LOCALIZ) ' ,"")
		_Retorno:=.F.
	ENDIF
	
ENDIF


// Acertando a numeração automática
If _Retorno
	If INCLUI
		cAlias 		:= GetNextAlias()     
		cAliasNum 	:= GetNextAlias()     

		cQuery := "SELECT MAX(C2_EMISSAO) EMISSAO "
		cQuery += "		FROM " + RetSqlName("SC2") + " SC2 "
		cQuery += "		WHERE D_E_L_E_T_ = '' "
		cQuery += "			AND C2_EMISSAO < '" + DtoS(dDataBase) + "'"
		cQuery += "			AND C2_FILIAL = '" + xFilial("SC2") + "'"
		
		DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAlias),.F.,.T.)
		
		cQuery := "SELECT MAX(C2_NUM) NUM "
		cQuery += "	FROM " + RetSqlName("SC2") + " SC2 "
		cQuery += "	WHERE D_E_L_E_T_ = '' "
		cQuery += "		AND C2_EMISSAO >= '" + (cAlias)->EMISSAO + "'
		cQuery += "		AND LEN(C2_NUM) > 5 "
		cQuery += "		AND C2_FILIAL = '" + xFilial("SC2") + "'"
		
		DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAliasNum),.F.,.T.) 
		
		cNumOpAtual := (cAliasNum)->NUM	                    
				
		(cAliasNum)->(DbCloseArea()) 
		(cAlias)->(DbCloseArea()) 
	
		If M->C2_NUM <= cNumOpAtual
			M->C2_NUM := StrZero(Val(QUERYSC2->C2_NUM)+1,Len(SC2->C2_NUM))
		EndIf
	EndIf
EndIf


// Semáforo Domex para inclusão manual de OP  // JOAO - COMENTADO
/*
//If GetMV("MV_XSEMAOP") == 'S' .and. INCLUI // JOAO - COMENTADO
//	//RETIRADO Vanessa Faio TudoOK Op MANUAL!!!                  
//	Public __XXNumSeq := U_INUMSEQ("MA650TOK() - Inclusão de OP manual - " + M->C2_NUM+M->C2_ITEM+M->C2_SEQUEN)             // JOAO - COMENTADO
//	MsgInfo("Entrou no semáforo Domex " + "MA650TOK() - Inclusão de OP manual - " + M->C2_NUM+M->C2_ITEM+M->C2_SEQUEN)// JOAO - COMENTADO
//EndIf // JOAO - COMENTADO
*/


RestArea(aAreaSB1)
RestArea(aArea)

Return _Retorno
