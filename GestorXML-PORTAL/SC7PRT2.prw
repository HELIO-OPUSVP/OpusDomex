#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F3SB1SC7  ºAutor  ³Helio Ferreira      º Data ³  15/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ F3 personalizado do campo C7_NUM.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function C7PRT2()
	Local x
	Local aIndice     := {}
	Local hcAlias     := Nil
	Local hcCampos    := Nil
	Local hcNaoCampos := Nil
	Local aColsNew    := {}
	Local aHeaderNew  := {}
	Local aSizeNew     := {40,05,200,395}    // Tamanho do newgetdados
	Local aDlgTela     := {000,000,aSizeNew[1]+aSizeNew[3]+215,800}
	Local lRetorno     := .F.
	Local cCpoRet

	Private __oGdItm99
	Public __cRetorn := ""
	Public __cRetorn2 := ""

	nConfLin := 0
	nConfCol := 0

	If Type("CUSUARIO") == "U"
		RpcSetType(3)
		RpcSetEnv("01","01")
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Configurações do F3 personalizado                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cNomeJanela := "Seleção de Pedidos - Portal Rosenberger - 17/05/2022"

	hcAlias     := "SC7"

	hcCampos    := "C7_NUM,C7_ITEM,C7_QUANT"

//AADD(aIndice,{"Código Produto","B1_COD"  })
//AADD(aIndice,{"Descrição"     ,"B1_DESC" })


	AADD(aIndice,{"Pedido"     ,"C7_NUM" })
//AADD(aIndice,{"Código Produto","B1_COD"  })

	cPicture := "999999"
	cFilIni  := "  C7_FORNECE+C7_LOJA = '"+_cCodFOR+_cLojFOR+"' AND C7_ENCER <> 'E' AND ((C7_QUANT-C7_QUJE) > 0) AND C7_CONAPRO <> 'B' AND C7_RESIDUO  = '' "

	cCpoRet  := "C7_NUM"
	cCpoRet2 := "C7_ITEM"

	cCpoPara := "C7_NUM"

// Tamanho da janela
	nConfLin := 0
	nConfCol := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fim da Configuração do F3 personalizado                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aIndice1 := {}
	aIndice2 := {}

	For x := 1 to Len(aIndice)
		AADD(aIndice1,aIndice[x,1])
		AADD(aIndice2,aIndice[x,2])
	Next x

	cIndice := aIndice1[1]

	aSizeNew[3] += nConfLin
	aSizeNew[4] += nConfCol

	aDlgTela[3] += nConfLin
	aDlgTela[4] += nConfCol


	Define MsDialog oDialg Title cNomeJanela From aDlgTela[1],aDlgTela[2] To aDlgTela[3],aDlgTela[4] Of oMainWnd Pixel

/*
Desabilita caixa de pesquisa

@ 20, 05 MSGET    oGet1    VAR cPesquisa Picture cPicture VALID fPesquisa(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos,cPesquisa,aIndice,cIndice) SIZE 250, 012 OF oDialg COLORS 0, 16777215 PIXEL
@ 05, 05 COMBOBOX oCombo1  VAR cIndice ITEMS aIndice1     VALID fCombo() SIZE 250,12 PIXEL
@ 05,255 Button "Pesquisar"    Size 40,10 Pixel Of oDialg Action fPesquisa(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos,cPesquisa,aIndice,cIndice)
*/

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	Private cGetOpc        := GD_UPDATE                   // GD_INSERT+GD_DELETE+GD_UPDATE
	Private cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
	Private cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Private cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Private nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Private nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
	Private cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
	Private cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Private cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols

	aHeaderNew  := faHead(hcAlias,hcCampos,hcNaoCampos) //faHead(hcAlias,hcCampos,hcNaoCampos)
	aColsNew    := {}

	__oGdItm99:=MsNewGetDados():New(aSizeNew[1],aSizeNew[2],aSizeNew[3],aSizeNew[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHeaderNew,aColsNew)
	__oGdItm99:oBrowse:bLDblClick := {|| fOk(aHeaderNew, cCpoRet, cCpoPara, @lRetorno) }


//SetKey(VK_F1,{||__oGdItm99:oBrowse:SetFocus()})

//__oGdItm99:oBrowse:bGotFocus := { || fDblClick1(@__oGdItm99) }

//__oGdItm99:oBrowse:bLClicked:= {|| fOk(__oGdItm99,aHeaderNew, aColsNew, cCpoRet, cCpoPara, @lRetorno) }

//@ 214 , 015 SAY oSay1 PROMPT "Total SC marcadas:"    SIZE 060, 007 OF oDialg COLORS 0, 16777215 PIXEL
//@ 210 , 065 Say oSay2 Var Transform(nQtdTot,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL OF oDialg
//oSay2:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)

	nPC7_NUM    := aScan(__oGdItm99:aHeader,{ |aVet| Alltrim(aVet[2]) == "C7_NUM"    })
	nPC7_ITEM   := aScan(__oGdItm99:aHeader,{ |aVet| Alltrim(aVet[2]) == "C7_ITEM"   })
	nPC7_QUANT  := aScan(__oGdItm99:aHeader,{ |aVet| Alltrim(aVet[2]) == "C7_QUANT"  })
	nPC7SALDO   := aScan(__oGdItm99:aHeader,{ |aVet| Alltrim(aVet[2]) == "C7SALDO"   })
	nPC7_DESCRI := aScan(__oGdItm99:aHeader,{ |aVet| Alltrim(aVet[2]) == "C7_DESCRI" })

	fCarIni(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos)

	@ aSizeNew[3]+06,aSizeNew[4]-90 Button "Ok"       Size 40,15 Pixel Of oDialg Action {|| fOk(aHeaderNew, cCpoRet, cCpoPara, @lRetorno) }
	@ aSizeNew[3]+06,aSizeNew[4]-40 Button "Cancelar" Size 40,15 Pixel Of oDialg Action {||(oDialg:End())}

	Activate MsDialog oDialg Centered

Return lRetorno



User Function C7PRT2RE()

Return(__cRetorn)   //(M->C7_NUM)



Static Function fCombo()

	oGet1:SetFocus()

Return .T.




Static Function faHead(hcAlias,hcCampos,hcNaoCampos)

	Local   haHead      := {}
	Default hcCampos    := ""
	Default hcNaoCampos := ""

*/
//           X3_TITULO         , X3_CAMPO     , X3_PICTURE    ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
	aAdd(haHead,{"Pedido"          ,"C7_NUM"      ,"@!"           ,          06,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(haHead,{"Item"            ,"C7_ITEM"     ,"@R"           ,          04,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(haHead,{"Qtd. Original"   ,"C7_QUANT"    ,"@E 999,999.99",          10,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(haHead,{"Saldo"           ,"C7SALDO"     ,"@E 999,999.99",          10,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
	aAdd(haHead,{"Produto"         ,"C7_DESCRI"   ,"@R"           ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })



Return haHead


Static Function fCarIni(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos)
	Local cQuery
	Local x
	Local lPrimeira := .T.

	cQuery := " SELECT C7_FILIAL,C7_NUM,C7_ITEM, C7_QUANT,(C7_QUANT - C7_QUJE) AS C7SALDO, C7_DESCRI "
	cQuery += " FROM " +RetSqlName("SC7")+ " SC7, "+RetSqlName("SA5") + " SA5 "
	cQuery += " WHERE     C7_FORNECE = '"+_cCodFOR + "' AND C7_LOJA = '"+_cLojFOR +"' "
	cQuery += "       AND C7_ENCER <> 'E' "
	cQuery += " 	  AND ((C7_QUANT-C7_QUJE) > 0) "
	cQuery += " 	  AND C7_CONAPRO <> 'B' "
	cQuery += " 	  AND C7_RESIDUO  = '' "
	cQuery += "       AND A5_FORNECE=C7_FORNECE AND A5_LOJA=C7_LOJA "
	cQuery += " 	  AND C7_PRODUTO=A5_PRODUTO "
	cQuery += " 	  AND A5_CODPRF = '"+oXXGetDad:aCols[oXXGetDad:nAt,nXXPRODXML] +"' "    // Posição do Produto XML no Array
	cQuery += " 	  AND A5_FILIAL = '"+xFilial("SA5")+"' "                   // Somente xonsiderar Filial em Branco.  Filial 01 foi descontinuado, mas ainda está gravado na base
	cQuery += " 	  AND  SC7.D_E_L_E_T_ = '' AND SA5.D_E_L_E_T_='' "


	If Select("TEMP001") <> 0
		TEMP001->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TEMP001"

	While !TEMP001->( EOF() )
		nC7SALDO := TEMP001->C7SALDO

		For x := 1 to Len(oXXGetDad:aCols)
			If x <> oXXGetDad:nAt
				If !Empty(oXXGetDad:aCols[x,nXXPEDIDO])
					If oXXGetDad:aCols[x,nXXPEDIDO] == TEMP001->C7_NUM .and.  oXXGetDad:aCols[x,nXXITEMPC] == TEMP001->C7_ITEM
						nC7SALDO -= oXXGetDad:aCols[x,nXXQTD2]
					EndIf
				Endif
			EndIf
		Next x

		cQuery := "SELECT ZZ6_CHVNFE, ZZ6_QTD FROM " + RetSqlname('ZZ6') + " WHERE ZZ6_CHVNFE <> '"+Alltrim(_cChave)+"' AND "
		If ZZ6->( FieldPos("ZZ6_FILPC") )  <> 0
			cQuery += "ZZ6_FILPC = '"+TEMP001->C7_FILIAL+"' AND "
		EndIf
		cQuery += "ZZ6_PEDIDO = '"+TEMP001->C7_NUM+"' AND ZZ6_ITEMPC = '"+TEMP001->C7_ITEM+"' AND D_E_L_E_T_ = '' "

		If Select('TEMP002') <> 0
			TEMP002->( dbCloseArea() )
		EndIf

		TCQUERY cQuery NEW ALIAS "TEMP002"

		SF1->(DbSetOrder(RetOrder("SF1","F1_FILIAL+F1_CHVNFE")))
		While !TEMP002->( EOF() )
			If !SF1->(dbSeek( xFilial() + Alltrim(TEMP002->ZZ6_CHVNFE) ))
				nC7SALDO -= TEMP002->ZZ6_QTD
			EndIf
			TEMP002->( dbSkip() )
		End

		If Select('TEMP002') <> 0
			TEMP002->( dbCloseArea() )
		EndIf

		If nC7SALDO > 0
			//Cria uma linha no aCols
			If !lPrimeira
				aAdd(__oGdItm99:aCols,Array(Len(__oGdItm99:aHeader)+1))
			EndIf
			lPrimeira := .F.

			__oGdItm99:aCols[Len(__oGdItm99:aCols),nPC7_NUM]    := TEMP001->C7_NUM
			__oGdItm99:aCols[Len(__oGdItm99:aCols),nPC7_ITEM]   := TEMP001->C7_ITEM
			__oGdItm99:aCols[Len(__oGdItm99:aCols),nPC7_QUANT]  := TEMP001->C7_QUANT
			__oGdItm99:aCols[Len(__oGdItm99:aCols),nPC7SALDO]   := nC7SALDO
			__oGdItm99:aCols[Len(__oGdItm99:aCols),nPC7_DESCRI] := TEMP001->C7_DESCRI

			__oGdItm99:aCols[Len(__oGdItm99:aCols),Len(__oGdItm99:aHeader)+1] := .F.

		EndIf

		TEMP001->( dbSkip() )
	End

	If Select("TEMP001") <> 0
		TEMP001->( dbCloseArea() )
	EndIf

Return

Static Function fPesquisa(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos,cPesquisa,aIndice,cIndice)

	Local cQuery
	Local x

//cQuery := "SELECT " + hcCampos + " FROM " + RetSqlName(hcAlias) + " WHERE " + cFilIni + " AND D_E_L_E_T_ = '' "
	cQuery := " SELECT C7_NUM,C7_ITEM, C7_QUANT,(C7_QUANT - C7_QUJE) C7SALDO "
	cQuery += " FROM " +RetSqlName("SC7")+ " SC7, "+RetSqlName("SA5") + " SA5 "
	cQuery += " WHERE     C7_FORNECE = '"+_cCodFOR + "' AND C7_LOJA = '"+_cLojFOR +"' "
	cQuery += "      AND C7_ENCER <> 'E' "
	cQuery += " 	  AND ((C7_QUANT-C7_QUJE) > 0) "
	cQuery += " 	  AND C7_CONAPRO <> 'B' "
	cQuery += " 	  AND C7_RESIDUO  = '' "
	cQuery += "       AND A5_FORNECE=C7_FORNECE AND A5_LOJA=C7_LOJA "
	cQuery += " 	  AND C7_PRODUTO=A5_PRODUTO "
	cQuery += " 	  AND A5_CODPRF = '"+oXXGetDad:aCols[oXXGetDad:nAt,nXXPRODXML]+"' "
	cQuery += " 	  AND  SC7.D_E_L_E_T_ = '' AND SA5.D_E_L_E_T_='' "

	If !Empty(cPesquisa)
		nTemp := aScan(aIndice,{ |aVet| aVet[1] == cIndice  })
		cQuery += " AND "+aIndice[nTemp,2]+" LIKE '"+Alltrim(cPesquisa)+"%' "
	EndIf

	cQuery += " order by C7_NUM "

	If Select("TEMP002") <> 0
		TEMP002->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TEMP002"

	__oGdItm99:aCols := {}

	While !TEMP002->( EOF() )

		//Cria uma linha no aCols
		aAdd(__oGdItm99:aCols,Array(Len(aHeaderNew)+1))
		nLin := Len(__oGdItm99:aCols)


		//Alimenta a linha do aCols vazia
		For x := 1 to Len(aHeaderNew)
			__oGdItm99:aCols[nLin, x ] := &("TEMP002->"+aHeaderNew[x,2])
		Next x
		__oGdItm99:aCols[nLin, Len(aHeaderNew)+1 ] := .F.

		TEMP002->( dbSkip() )
	End

	__oGdItm99:oBrowse:Refresh()

Return .T.



Static Function fOk(aHeaderNew, cCpoRet, cCpoPara, lRetorno)

	&("M->"+cCpoPara) := __oGdItm99:acols[	__oGdItm99:oBrowse:nat , aScan(aHeaderNew, { |aVet| Alltrim(aVet[2]) == cCpoRet } ) ]
	__cRetorn		  :=  __oGdItm99:acols[	__oGdItm99:oBrowse:nat , aScan(aHeaderNew, { |aVet| Alltrim(aVet[2]) == cCpoRet } ) ]
	__cRetorn2		  :=  __oGdItm99:acols[	__oGdItm99:oBrowse:nat , aScan(aHeaderNew, { |aVet| Alltrim(aVet[2]) == cCpoRet2 } ) ]
	lRetorno := .T.

	oDialg:End()

Return
