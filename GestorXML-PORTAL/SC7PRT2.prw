#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F3SB1SC7  ºAutor  ³Helio Ferreira      º Data ³  15/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ F3 personalizado do campo C7_NUM                       º±±
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
Local cAlias
Local cPesquisa   := Space(200)
Local hcAlias     := Nil
Local hcCampos    := Nil
Local hcNaoCampos := Nil
Local aColsNew    := {}
Local aHeaderNew  := {}
Local aSizeNew     := {40,05,200,295}    
Local aDlgTela     := {000,000,aSizeNew[1]+aSizeNew[3]+215,600}
Local lRetorno     := .F.                                            
Local cCpoRet

Private __oGdItm99
Public __cRetorn := ""

nConfLin := 0
nConfCol := 0

If Type("CUSUARIO") == "U"
	RpcSetType(3)
	RpcSetEnv("01","01")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Configurações do F3 personalizado                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cNomeJanela := "Seleção de Pedidos - Portal Rosenberger"

hcAlias     := "SC7"

hcCampos    := "C7_NUM,C7_ITEM,C7_QUANT"

//AADD(aIndice,{"Código Produto","B1_COD"  })
//AADD(aIndice,{"Descrição"     ,"B1_DESC" })


AADD(aIndice,{"Pedido"     ,"C7_NUM" })
//AADD(aIndice,{"Código Produto","B1_COD"  })

cPicture := "999999"                         
cFilIni  := "  C7_FORNECE+C7_LOJA = '"+_cCodFOR+_cLojFOR+"' AND C7_ENCER <> 'E' AND ((C7_QUANT-C7_QUJE) > 0) AND C7_CONAPRO <> 'B' AND C7_RESIDUO  = '' "

cCpoRet  := "C7_NUM"
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

@ 20, 05 MSGET    oGet1    VAR cPesquisa Picture cPicture VALID fPesquisa(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos,cPesquisa,aIndice,cIndice) SIZE 250, 012 OF oDialg COLORS 0, 16777215 PIXEL
@ 05, 05 COMBOBOX oCombo1  VAR cIndice ITEMS aIndice1     VALID fCombo() SIZE 250,12 PIXEL
@ 05,255 Button "Pesquisar"    Size 40,10 Pixel Of oDialg Action fPesquisa(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos,cPesquisa,aIndice,cIndice)


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

//          X3_TITULO    , X3_CAMPO     , X3_PICTURE ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
//aAdd(aHeade,{""                ,"FLAG"        ,"@BMP"         ,          01,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"SC"              ,"C1_NUM"      ,"@R"           ,          06,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Item"            ,"C1_ITEM"     ,"@R"           ,          02,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Produto"         ,"C1_PRODUTO"  ,"@R"           ,          15,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Descrição"       ,"C1_DESCRI"   ,"@!"           ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Qtd."            ,"C1_QUANT"    ,"@E 999,999.99",          10,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"UM"              ,"C1_UM"       ,"@!"           ,          02,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Armazém"         ,"C1_LOCAL"    ,"@R"           ,          02,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Grupo"           ,"B1_GRUPO"    ,"@R"           ,          04,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Necessidade"     ,"C1_DATPRF"   ,"@D"           ,          08,          0, ""      , "€€€€€€€€€€€€€€", "D"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Requisitante"    ,"C1_XENTID"   ,"@R"           ,          25,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(aHeade,{"Período Consumo" ,"C1_XPERCON"  ,"@R"           ,          40,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

aHeaderNew  := faHead(hcAlias,hcCampos,hcNaoCampos) //faHead(hcAlias,hcCampos,hcNaoCampos)
aColsNew    := fCarIni(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos)

__oGdItm99:=MsNewGetDados():New(aSizeNew[1],aSizeNew[2],aSizeNew[3],aSizeNew[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDialg,aHeaderNew,aColsNew)
__oGdItm99:oBrowse:bLDblClick := {|| fOk(aHeaderNew, cCpoRet, cCpoPara, @lRetorno) }

//SetKey(VK_F1,{||__oGdItm99:oBrowse:SetFocus()})

//__oGdItm99:oBrowse:bGotFocus := { || fDblClick1(@__oGdItm99) }

//__oGdItm99:oBrowse:bLClicked:= {|| fOk(__oGdItm99,aHeaderNew, aColsNew, cCpoRet, cCpoPara, @lRetorno) }

//@ 214 , 015 SAY oSay1 PROMPT "Total SC marcadas:"    SIZE 060, 007 OF oDialg COLORS 0, 16777215 PIXEL
//@ 210 , 065 Say oSay2 Var Transform(nQtdTot,"@E 999,999,999.99") Size 130,50 COLOR CLR_HBLUE     PIXEL OF oDialg
//oSay2:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)

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


// Montagem do aHeader

/*
SX3->(dbSetOrder(1))
SX3->(dbSeek(hcAlias))
While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
	If ((((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
		.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
		aAdd(haHead, {	AllTrim(X3Titulo())	,;
		SX3->X3_CAMPO		,;
		SX3->X3_PICTURE		,;
		SX3->X3_TAMANHO		,;
		SX3->X3_DECIMAL		,;
		SX3->X3_VALID		,;
		SX3->X3_USADO		,;
		SX3->X3_TIPO		,;
		SX3->X3_F3			,;
		SX3->X3_CONTEXT		,;
		SX3->X3_CBOX		,;
		SX3->X3_RELACAO		,;
		SX3->X3_WHEN		,;
		SX3->X3_VISUAL		,;
		SX3->X3_VLDUSER		,;
		SX3->X3_PICTVAR		,;
		SX3->X3_OBRIGAT		})
	EndIf
	SX3->(DbSkip())
End

*/
//          X3_TITULO    , X3_CAMPO     , X3_PICTURE ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
aAdd(haHead,{"Pedido"          ,"C7_NUM"      ,"@!"           ,          06,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(haHead,{"Item"            ,"C7_ITEM"     ,"@R"           ,          04,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(haHead,{"Qtd."            ,"C7_QUANT"    ,"@E 999,999.99",          10,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
//aAdd(haHead,{"Saldo"           ,"C7SALDO"     ,"@E 999,999.99",          10,          2, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })


Return haHead
     

Static Function fCarIni(aHeaderNew,cFilIni,hcAlias,hcCampos,hcNaoCampos)
Local cQuery 
Local x
Local aColsIni := {}

//cQuery := "SELECT " + hcCampos + " FROM " + RetSqlName(hcAlias) + " WHERE " + cFilIni + " AND D_E_L_E_T_ = '' ORDER BY C7_NUM "

cQuery := " SELECT C7_NUM,C7_ITEM, C7_QUANT,(C7_QUANT - C7_QUJE) AS C7SALDO "
cQuery += " FROM " +RetSqlName("SC7")+ " SC7, "+RetSqlName("SA5") + " SA5 "
cQuery += " WHERE     C7_FORNECE = '"+_cCodFOR + "' AND C7_LOJA = '"+_cLojFOR +"' "
cQuery += "      AND C7_ENCER <> 'E' "
cQuery += " 	  AND ((C7_QUANT-C7_QUJE) > 0) " 
cQuery += " 	  AND C7_CONAPRO <> 'B' "
cQuery += " 	  AND C7_RESIDUO  = '' "
cQuery += "       AND A5_FORNECE=C7_FORNECE AND A5_LOJA=C7_LOJA " 
cQuery += " 	  AND C7_PRODUTO=A5_PRODUTO "
cQuery += " 	  AND A5_CODPRF <> '' "
cQuery += " 	  AND  SC7.D_E_L_E_T_ = '' AND SA5.D_E_L_E_T_='' "




If Select("TEMP001") <> 0
   TEMP001->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "TEMP001"

While !TEMP001->( EOF() )
	
	//Cria uma linha no aCols
	aAdd(aColsIni,Array(Len(aHeaderNew)+1))
	nLin := Len(aColsIni)
	
	
	//Alimenta a linha do aCols vazia
	For x := 1 to Len(aHeaderNew)
	   aColsIni[nLin, x ] := &("TEMP001->"+aHeaderNew[x,2])
	Next x
	aColsIni[nLin, Len(aHeaderNew)+1 ] := .F.
	
	TEMP001->( dbSkip() )
End

Return aColsIni

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
cQuery += " 	  AND A5_CODPRF <> '' "
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

lRetorno := .T.
      
oDialg:End()

Return        
