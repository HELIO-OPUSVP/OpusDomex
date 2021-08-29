#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA103MNU ºAutor  ³Helio Ferreira      º Data ³  16/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA140MNU()

	aAdd(aRotina,{OemToAnsi('Emissao Etiquetas')         , "U__MTA140MNU()" , 0 , 4, 0, nil} )
	aAdd(aRotina,{OemToAnsi('Importa XML/Gera Pre Nota') , "U_MT140XML()"   , 0 , 3, 0, nil} )
//aAdd(aRotina,{OemToAnsi('MAURESI CLASS'  ) , "U_MAURESI()"   , 0 , 3, 0, nil} )
//aAdd(aRotina,{OemToAnsi('MAURESI CLASS 2') , "U_MAURESI()"   , 0 , 4, 0, nil} )

Return

/*
=============================================================================
±±ºPrograma  ³ MT140XML ºAutor  ³ Felipe Melo        º Data ³  18/10/2013 º±±
=============================================================================
*/
User Function MT140XML()

	Local x         := 0
	Local aRecnoSF1 := {}

//Chama rotina de importação
	aRecnoSF1 := U_ImpXmlNF()

//Variavel Publica do fonte IMPXMLNF.PRW
	lImpXmlNF := .T.

//Percorre caso tenha varios recnos
	For x:=1 To Len(aRecnoSF1)
		SF1->(DbGoTo(aRecnoSF1[x][1]))
		A140NFiscal("SF1",aRecnoSF1[x][1],4)
	Next x

//Variavel Publica do fonte IMPXMLNF.PRW
	lImpXmlNF := .F.

Return

/*
=============================================================================
±±ºPrograma  ³_MTA140MNUºAutor  ³Helio Ferreira      º Data ³  16/04/10   º±±
=============================================================================
*/
User Function _MTA140MNU()

	SB1->( dbSetOrder(1) )
	SD1->( dbSetOrder(1) )

	//If Upper(GetEnvServ()) == "VALIDACAO"  // GetEnvServ.Mauresi   13/07/21 
	if U_VALIDACAO() .or. .T.     // MAURESI - Em producao - 23/08/2021	
		If SF1->F1_XBLQXML <> 'S'
			If SD1->( dbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
				While !SD1->( EOF() ) .and. SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
					If SB1->( dbSeek( xFilial() + SD1->D1_COD ) )
						If SB1->B1_XXETIQU $ "1/2"
							If Localiza(SD1->D1_COD)
								If Rastro(SD1->D1_COD)
									U_DOMEST03()
								Else
                           MsgInfo("Produto "+SD1->D1_COD+" não tem controle de Lote.","A T E N Ç Ã O")
								EndIf
							Else
								MsgInfo("Produto "+SD1->D1_COD+" não tem controle por endereço.","A T E N Ç Ã O")
							EndIf
						EndIf
					EndIf
					SD1->( dbSkip() )
				End
			EndIf
			MsgInfo( 'Fim da emissão de etiquetas.' )
		Else
			MsgInfo( 'NF bloqueada para emissão de etiquetas. Solicite a liberação da NF ao Depto. Fiscal' )
		EndIf
	Else
		If SD1->( dbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
			While !SD1->( EOF() ) .and. SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
				If SB1->( dbSeek( xFilial() + SD1->D1_COD ) )
					If SB1->B1_XXETIQU $ "1/2"
						If Localiza(SD1->D1_COD)
							If Rastro(SD1->D1_COD)
								U_DOMEST03()
							Else
								MsgInfo("Produto "+SD1->D1_COD+" não tem controle de Lote.","A T E N Ç Ã O")
							EndIf
						Else
							MsgInfo("Produto "+SD1->D1_COD+" não tem controle por endereço.","A T E N Ç Ã O")
						EndIf
					EndIf
				EndIf
				SD1->( dbSkip() )
			End
		EndIf
		MsgInfo( 'Fim da emissão de etiquetas.' )
	EndIf
Return
