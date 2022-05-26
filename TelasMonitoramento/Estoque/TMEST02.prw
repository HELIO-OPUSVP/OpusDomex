#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "TOpconn.ch"
#include "protheus.ch"
#include "fwsmallapplication.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMEST01      ºAutor  ³Helio Ferreira º Data ³  15/06/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMEST02()

Local cGetOpc        := NIL // GD_UPDATE                   // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "ALLWAYSTRUE()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := ""                                              // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "ALLWAYSTRUE()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
Local nPadMasc       := "@E 999,999,999.9999"
Local nPadNum        := 12
Local nPadDec        := 4

Private aHead        := {}                                              // Array do aHeader
Private aCols        := {}                                              // Array do aCols
Private aCols2       := {}                                              
Private nOpca        := 0
Private nSkipLin     := 15
Private nLin         := 01
Private nCol         := 10
Private aAcessos     := {}
Private oBtn
Public cUsuario
Private cCor1        := "BR_VERDE"
PrivatE cCor2        := "BR_AMARELO"
Private cCor3        := "BR_VERMELHO"
Private cCor4        := "BR_PRETO"
Private cCor5        := "BR_PINK"
Private nPendencias  := 0
Private cMaxTempo    := ""
Private nMaxTempo    := 0

RPCSetType(3)
aAbreTab := {}
RpcSetEnv("01","01",,,,,aAbreTab) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

DEFINE MSDIALOG oDlg01 TITLE OemToAnsi("FILIAL MG-Monitor de Pagamentos do Estoque ") FROM 0,0 TO 600,1200 PIXEL of oMainWnd PIXEL

@ 08, 10	SAY oTexto1 Var "Pendências de pagamento de material pelo estoque Filial MG:"    SIZE 300,20 PIXEL
oTexto1:oFont := TFont():New('Arial',,25,,.F.,,,,.T.,.F.)
oTexto1:nClrText := CLR_BLUE


@ 17, 380	SAY oTexto1 Var "Tempo da primeira solicitação:"    SIZE 300,20 PIXEL
oTexto1:oFont := TFont():New('Arial',,20,,.F.,,,,.T.,.F.)

@ 08, 493	SAY oMaxTempo Var cMaxTempo    SIZE 100,20 PIXEL
oMaxTempo:oFont := TFont():New('Courier New',,50,,.T.,,,,.T.,.F.)
oMaxTempo:nClrText := CLR_RED

@ 275, 10	SAY oTexto1 Var "Número de Pagamentos Pendentes:"    SIZE 300,20 PIXEL
oTexto1:oFont := TFont():New('Arial',,25,,.F.,,,,.T.,.F.)
oTexto1:nClrText := CLR_BLUE

@ 272, 175	SAY oPendencias Var Alltrim(Str(nPendencias))    SIZE 300,20 PIXEL
oPendencias:oFont := TFont():New('Courier New',,40,,.T.,,,,.T.,.F.)



@ 260,480 BUTTON oBtn01 PROMPT "Reimprimir todas" ACTION Processa( {|| BtoReimp() } ) SIZE 110,30 PIXEL OF oDlg01
oBtn01:oFont := TFont():New('Arial',,25,,.T.,,,,.T.,.F.)
//oBtn01:SetCSS( FWGetCSS( CSS_BUTTON ) )
//oBtn01:SetCSS("#STYLE0002")
oBtn01:SETCSS( STYLE_FORM )
//oBtn01:SETCSS( STYLE_COMBOBOX )
//oBtn01:SetCss(CSSButton())

//          X3_TITULO           , X3_CAMPO     , X3_PICTURE ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3   , X3_CONTEXT , X3_CBOX            , X3_RELACAO ,X3_WHEN                       ,X3_VISUAL, X3_VLDUSER                    , X3_PICTVAR, X3_OBRIGAT
aAdd(aHead,{""                  ,"FLAG"        ,"@BMP"  ,     01,    0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"TEMPO SOLICITAÇÃO" ,"TEMPO"       ,"@R"    ,     10,    0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"DOCUMENTO"         ,"DOCUMENTO"   ,"@R"    ,     12,    0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"PRODUTO"           ,"PRODUTO"     ,"@R"    ,     25,    0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"DESCRIÇÃO"         ,"DESC"        ,"@R"    ,     90,    0, ""      , "€€€€€€€€€€€€€€", "C"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })
aAdd(aHead,{"SALDO"             ,"SALDO"       ,"@E"    ,     12,    4, ""      , "€€€€€€€€€€€€€€", "N"    , ""      , "R"        , ""                 , ""         ,""                            ,"V"      , ""                            , ""        , ""        })

oGdItm01:=MsNewGetDados():New(35,10,253,590,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDlg01,aHead,aCols)
oGdItm01:oBrowse:bLDblClick := {|| ReimpLin() }
oGdItm01:oBrowse:oFont:= TFont():New('Courier New',,20,,.F.,,,,.T.,.F.)

SetKey(VK_F5,{||fAtualiza()})
                              
DEFINE TIMER oTimer1 INTERVAL 1*(60*1000)         ACTION (fAtualiza())  OF oDlg01 // 2 segundos  1000 = 1 segundo

ACTIVATE TIMER oTimer1

oGdItm01:oBrowse:bGotFocus := { || Alert("oBrowse:bGotFocus") }
oGdItm01:oBrowse:bLClicked := { || Alert("oBrowse:bLClicked") }

fAtualiza()

ACTIVATE MSDIALOG oDlg01 CENTERED // ON INIT EnchoiceBar( oDlgMenu01,{|| nOpca := 0,oDlgMenu01:End()},{|| nOpca := 0,oDlgMenu01:End()} ) //CENTER

Return


Static Function fAtualiza()
aCols  := {}
aCols2 := {} 

cQuery := "SELECT * FROM "+RetSqlName("SZA")+" WHERE ZA_FILIAL = '02' AND ZA_PRODUTO <> '50010100' AND ZA_SALDO <> 0 AND D_E_L_E_T_ = '' ORDER BY ZA_DATA DESC, ZA_HORA DESC "

If Select("QUERYSZA") <> 0
	QUERYSZA->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZA"

nMaxTempo   := 0
cMaxTempo   := ""
nPendencias := 0

While !QUERYSZA->( EOF() )
   aDiferenca := fSubtrai(DtoS(Date())+Time(),QUERYSZA->ZA_DATA+QUERYSZA->ZA_HORA)
	cDiferenca := aDiferenca[1]
	nDiferenca := aDiferenca[2]
	
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial() + QUERYSZA->ZA_PRODUTO ) )
	nSaldoProd := Posicione("SB2",1,xFilial("SB2")+QUERYSZA->ZA_PRODUTO+SB1->B1_LOCPAD,"B2_QATU")
	
	If nMaxTempo < nDiferenca .and. nSaldoProd > 0
	   nMaxTempo := nDiferenca
	   cMaxTempo := cDiferenca
   EndIf
 
	aAdd(aCols,Array(Len(aHead)+1))

	If nSaldoProd > 0
	   If nDiferenca < (10*60)  // Até 10 minutos
		   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor1
		   nPendencias++
	   Else
		   If nDiferenca < (20*60)  // Até 20 minutos
			   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor2
			   nPendencias++
		   Else
		      aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor3
		      nPendencias++
			EndIf
		EndIf
	Else
	   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor4
	EndIf
	
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="TEMPO"     }) ] := cDiferenca
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="DOCUMENTO" }) ] := QUERYSZA->ZA_DOCUMEN
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="PRODUTO"   }) ] := QUERYSZA->ZA_PRODUTO
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="DESC"      }) ] := QUERYSZA->ZA_DESC
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="SALDO"     }) ] := QUERYSZA->ZA_SALDO
	aCols[Len(aCols), Len(aHead)+1]                                   := .F.
	
	aAdd(aCols2,Array(9))
	aCols2[Len(aCols2),1] := StoD(QUERYSZA->ZA_DATA)
	aCols2[Len(aCols2),2] := QUERYSZA->ZA_HORA
	aCols2[Len(aCols2),3] := QUERYSZA->ZA_SALDO
	aCols2[Len(aCols2),4] := QUERYSZA->ZA_OPERADO
	aCols2[Len(aCols2),5] := QUERYSZA->ZA_PRODUTO
	aCols2[Len(aCols2),6] := QUERYSZA->ZA_DESC
	aCols2[Len(aCols2),7] := QUERYSZA->ZA_DOCUMEN
	aCols2[Len(aCols2),8] := QUERYSZA->ZA_OP
   aCols2[Len(aCols2),9] := cDiferenca

	QUERYSZA->( dbSkip() )
End

If Select("QUERYSZA") <> 0
	QUERYSZA->( dbCloseArea() )
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Perda de fornecedores SZE                                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT * FROM "+RetSqlName("SZE")+" WHERE ZE_FILIAL = '02' AND ZE_SALDO <> 0 AND D_E_L_E_T_ = '' ORDER BY ZE_DATA DESC, ZE_HORA DESC "

If Select("QUERYSZE") <> 0
	QUERYSZE->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZE"

While !QUERYSZE->( EOF() )
   aDiferenca := fSubtrai(DtoS(Date())+Time(),QUERYSZE->ZE_DATA+QUERYSZE->ZE_HORA)
	cDiferenca := aDiferenca[1]
	nDiferenca := aDiferenca[2]

	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial() + QUERYSZE->ZE_PRODUTO ) )
	nSaldoProd := Posicione("SB2",1,xFilial("SB2")+QUERYSZE->ZE_PRODUTO+SB1->B1_LOCPAD,"B2_QATU")
	
	If nMaxTempo < nDiferenca .and. nSaldoProd > 0
	   nMaxTempo := nDiferenca
	   cMaxTempo := cDiferenca
   EndIf
 
	aAdd(aCols,Array(Len(aHead)+1))
	
	If nSaldoProd > 0
	   If nDiferenca < (10*60)  // Até 10 minutos
		   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor1
		   nPendencias++
	   Else
		   If nDiferenca < (20*60)  // Até 20 minutos
			   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor2
			   nPendencias++
		   Else
		      aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor3
		      nPendencias++
			EndIf
		EndIf
	Else
	   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor4
	EndIf
	
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="TEMPO"     }) ] := cDiferenca
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="DOCUMENTO" }) ] := QUERYSZE->ZE_DOCUMEN
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="PRODUTO"   }) ] := QUERYSZE->ZE_PRODUTO
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="DESC"      }) ] := QUERYSZE->ZE_DESC
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="SALDO"     }) ] := QUERYSZE->ZE_SALDO
	aCols[Len(aCols), Len(aHead)+1]                                   := .F.
	
	aAdd(aCols2,Array(9))
	aCols2[Len(aCols2),1] := StoD(QUERYSZE->ZE_DATA)
	aCols2[Len(aCols2),2] := QUERYSZE->ZE_HORA
	aCols2[Len(aCols2),3] := QUERYSZE->ZE_SALDO
	aCols2[Len(aCols2),4] := QUERYSZE->ZE_OPERADO
	aCols2[Len(aCols2),5] := QUERYSZE->ZE_PRODUTO
	aCols2[Len(aCols2),6] := QUERYSZE->ZE_DESC
	aCols2[Len(aCols2),7] := QUERYSZE->ZE_DOCUMEN
	aCols2[Len(aCols2),8] := QUERYSZE->ZE_OP
   aCols2[Len(aCols2),9] := cDiferenca

	QUERYSZE->( dbSkip() )
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pagamento de Materiais de Consumo SZX                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT * FROM "+RetSqlName("SZX")+" WHERE ZX_FILIAL = '02' AND ZX_SALDO <> 0 AND D_E_L_E_T_ = '' ORDER BY ZX_DATA DESC, ZX_HORA DESC "

If Select("QUERYSZX") <> 0
	QUERYSZX->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSZX"

While !QUERYSZX->( EOF() )
   aDiferenca := fSubtrai(DtoS(Date())+Time(),QUERYSZX->ZX_DATA+QUERYSZX->ZX_HORA)
	cDiferenca := aDiferenca[1]
	nDiferenca := aDiferenca[2]
	
	SB1->( dbSetOrder(1) )
	SB1->( dbSeek( xFilial() + QUERYSZX->ZX_PRODUTO ) )
	nSaldoProd := Posicione("SB2",1,xFilial("SB2")+QUERYSZX->ZX_PRODUTO+SB1->B1_LOCPAD,"B2_QATU")
	
	//If nMaxTempo < nDiferenca .and. nSaldoProd > 0
	//   nMaxTempo := nDiferenca
	//   cMaxTempo := cDiferenca
   //EndIf
 
	aAdd(aCols,Array(Len(aHead)+1))
	
	If nSaldoProd > 0
	  If nDiferenca < (10*60)  // Até 10 minutos
		   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"         }) ] := cCor5
		   nPendencias++
	   Else
		   If nDiferenca < (20*60)  // Até 20 minutos
			   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor5
			   nPendencias++
		   Else
		      aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"      }) ] := cCor5
		      nPendencias++
			EndIf
		EndIf
	Else
	   aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="FLAG"            }) ] := cCor4
	EndIf
	
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="TEMPO"     }) ] := cDiferenca
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="DOCUMENTO" }) ] := QUERYSZX->ZX_DOCUMEN
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="PRODUTO"   }) ] := QUERYSZX->ZX_PRODUTO
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="DESC"      }) ] := QUERYSZX->ZX_DESC
	aCols[Len(aCols), aScan(aHead,{|x|AllTrim(x[2])=="SALDO"     }) ] := QUERYSZX->ZX_SALDO
	aCols[Len(aCols), Len(aHead)+1]                                   := .F.
	
	aAdd(aCols2,Array(9))
	aCols2[Len(aCols2),1] := StoD(QUERYSZE->ZE_DATA)
	aCols2[Len(aCols2),2] := QUERYSZX->ZX_HORA
	aCols2[Len(aCols2),3] := QUERYSZX->ZX_SALDO
	aCols2[Len(aCols2),4] := QUERYSZX->ZX_NOME
	aCols2[Len(aCols2),5] := QUERYSZX->ZX_PRODUTO
	aCols2[Len(aCols2),6] := QUERYSZX->ZX_DESC
	aCols2[Len(aCols2),7] := QUERYSZX->ZX_DOCUMEN
	aCols2[Len(aCols2),8] := "" // QUERYSZX->ZX_OP
   aCols2[Len(aCols2),9] := cDiferenca

	QUERYSZX->( dbSkip() )
End

aSort (aCols ,,,{|x, y| x[2] < y[2]})
aSort (aCols2,,,{|x, y| x[9] < y[9]})

oGdItm01:aCols := aCols

oGdItm01:Refresh()
oMaxTempo:Refresh()
oPendencias:Refresh()

Return


Static Function fSubtrai(cDataFin,cDataIni)

Local _Retorno  := {"",0}
Local dDataF    := Stod(Subs(cDataFin,1,8))
Local dDataI    := Stod(Subs(cDataIni,1,8))
Local nDiaDif   := dDataF - dDataI
Local nHoraDif  := nDiaDif * 24
Local nMinDif   := nHoraDif * 60
Local nSegDif   := nMinDif * 60

Local cHoraI    := Subs(cDataIni,9,8)
Local cHoraF    := Subs(cDataFin,9,8)

Local cDifHoras := ELAPTIME(cHoraI,cHoraF)
Local nDifHoras := (Val(Subs(cDifHoras,1,2))*3600) + (Val(Subs(cDifHoras,4,2))*60) + (Val(Subs(cDifHoras,7,2)))

Local nDifTSeg  := nSegDif + nDifHoras

Local nSegHor   := Int(nDifTSeg/3600)*3600
Local nSegMin   := Int((nDifTSeg-nSegHor)/60)*60
Local nSegSeg   := nDifTSeg - nSegHor - nSegMin

If nSegHor <= 356400
	_Retorno[1]  := StrZero(nSegHor/3600,2)+":"+StrZero(nSegMin/60,2)+":"+StrZero(nSegSeg,2)
Else
	_Retorno[1]  := Alltrim(Str(nSegHor/3600))+":"+StrZero(nSegMin/60,2)+":"+StrZero(nSegSeg,2)
EndIf

_Retorno[2]     := nDifTSeg

Return _Retorno

Static Function BtoReimp()
Local x := 0
If MsgYesNo("Deseja reimprimir todas etiquetas?")
	For x := 1 to Len(aCols2)
		Etiqueta(X)
	Next x
EndIf

Return


Static Function ReimpLin()

If MsgYesNo("Deseja reimprimir a etiqueta do documento " + aCols2[oGdItm01:oBrowse:nAt,7] + "?" )
	Etiqueta(oGdItm01:oBrowse:nat)
EndIf

Return


Static Function Etiqueta(X)
Local _cPorta    := "LPT1"

MSCBPrinter("TLP 2844",_cPorta,,,.F.)
MSCBBegin(1,6)

MSCBSay(28,01,"REIMPRESSÃO DE PAGAMENTO","N","3","1,1")

n := 3
	
MSCBSay(28,01+n,"DATA:"+DtoC(aCols2[x,1])+" HORA:"+aCols2[x,2]+Space(10)+Transform(aCols2[x,3],"@E 999,999.99"),"N","2","1,1")

MSCBSay(28,03+n,"OPERA.:"+aCols2[x,4]+" QTD:"+Transform(aCols2[x,3],"@E 999,999.99"),"N","2","1,1")

MSCBSay(28,05+n,"PRODUTO: "+Alltrim(aCols2[x,5])+" "+Alltrim(aCols2[x,6]),"N","2","1,1")

MSCBSayBar(31,07+n,aCols2[x,7],"N","MB07",10 ,.F.,.T.,.F.,,3,1  ,Nil,Nil,Nil,Nil)

MSCBSay(46,18+n,"OP: "+aCols2[x,8],"N","2","1,1")

MSCBEnd()

MSCBClosePrinter()

Return
