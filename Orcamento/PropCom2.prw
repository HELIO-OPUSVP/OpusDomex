#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PropCom2 บAutor  ณ Marco Aurelio-OPUS  บ Data ณ  23/08/2019บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ  
ฑฑบProg.ORI  ณ PropCom1 บAutor  ณ Felipe Aurelio Melo บ Data ณ  11/02/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera็ใo de Proposta Comercial - Integracao com Word         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PropCom2()

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Descricao da variaveis em uso nesta rotina e no documento do Word       บ
//ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
//Local cPathDot           := "\modelos\PropComercial.dot"
//Local cTempDot           := AllTrim(GetTempPath())+"PropComercial.dot"

//Local cPathDot           := "\modelos\PropComercial.dot"
//Local cTempDot           := AllTrim(GetTempPath())+"PropComercial.dot"
//Local cTempDot           := "C:\ALL\"+"PropComercial.dot"

Local cPathDot           := "\modelos\DMXProposta01.dotx"
Local cTempDot           := "C:\ALL\"+"DMXProposta01.dotx"


Local n                  := 00
Local aItem01            := {}
Local cRFQ               := ""	//Numero Or็amento

Local cDtDia             := StrZero(Day   (Date() ) ,2)
Local cDtMes             := Upper(MesExtenso(Month(Date())))
Local cDtAno             := StrZero(Year  (Date() ) ,4)

Local cEmpNome           := ""

Local cContatoNome       := ""
Local cContatoDpto       := ""
Local cContatoEmail      := ""
Local cContatoTel        := ""

Local cVendedorNome      := ""
Local cVendedorTel       := ""
Local cVendedorEmail     := ""

Local cSuporteNome       := ""
Local cSuporteTel        := ""
Local cSuporteEmail      := ""

Local cNumeroProposta    := ""
Local cNumeroRevisao     := ""
Local cReferenciaCliente := ""

Local cCondPagto         := ""
Local cFrete             := ""
Local cLocalFrete        := ""
Local cValidProposta     := ""

Local cObservacao        := ""

Local cQtdTotal          := ""
Local cQtdTotalA         := ""
Local cQtdTotalB         := ""
Local cQtdTotalC         := ""

Local nQtdTotal          := 0
Local nQtdTotalA         := 0
Local nQtdTotalB         := 0
Local nQtdTotalC         := 0

Local nVarCalc           := 0
Local nICMS              := 0
Local nPisCofins         := 0
Local nIPI               := 0

Local nPerICMS           := 0
Local nPerPisCofins      := 0
Local nPerIPI            := 0

Local cVarNCM            := ""
Local cVarPrdDesc        := ""

Private hWord

//ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
//บ Mensagem de confirma็ใo                                                 บ
//ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
IF SimNao("Deseja gerar proposta em documento do word?","Proposta Comercial") != "S"
	Return
EndIf

//Alimenta variaveis
cRFQ               := SCJ->CJ_NUM

cNumeroProposta    := SCJ->CJ_NUM
cNumeroRevisao     := SCJ->CJ_REVISAO
cReferenciaCliente := SCJ->CJ_REFEREN

//Cadastro Cliente
SA1->(DbSetOrder(1))
If SA1->(DbSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA))
	cEmpNome           := AllTrim(Upper(SA1->A1_NOME))
EndIf

cContatoNome       := AllTrim(Upper(SCJ->CJ_CONTATO))
cContatoDpto       := AllTrim(Upper(SCJ->CJ_DPTO))
cContatoEmail      := AllTrim(Lower(SCJ->CJ_EMAIL))
cContatoTel        := "("+AllTrim(SCJ->CJ_DDD)+") "+SCJ->CJ_FONE

//Vendedor
SA3->(DbSetOrder(1))
If SA3->(DbSeek(xFilial("SA3")+SCJ->CJ_VEND1))
	cVendedorNome      := AllTrim(Upper(SA3->A3_NOME))
	cVendedorTel       := "("+SA3->A3_DDDTEL+") " + SA3->A3_TEL
	cVendedorEmail     := AllTrim(Lower(SA3->A3_EMAIL))
EndIf

//Suporte
SA3->(DbSetOrder(1))
If SA3->(DbSeek(xFilial("SA3")+SCJ->CJ_SUPORTE))
	cSuporteNome       := AllTrim(Upper(SA3->A3_NOME))
	cSuporteTel        := "("+SA3->A3_DDDTEL+") " + SA3->A3_TEL
	cSuporteEmail      := AllTrim(Lower(SA3->A3_EMAIL))
EndIf

//Detalhes do Or็amento
cCondPagto         := Posicione("SE4",1,xFilial("SE4")+SCJ->CJ_CONDPAG,"E4_DESCRI")
cFrete             := SCJ->CJ_DMFRETE
cLocalFrete        := SCJ->CJ_LOCAL
cValidProposta     := SCJ->CJ_VALPROP

//Observa็ใo
cObservacao        := AllTrim(Upper(SCJ->CJ_OBS1)) + " "
cObservacao        += AllTrim(Upper(SCJ->CJ_OBS2)) + " "
cObservacao        += AllTrim(Upper(SCJ->CJ_OBS3)) + " "
cObservacao        += AllTrim(Upper(SCJ->CJ_OBS4)) + " "

SB1->(DbSetOrder(1))

SCK->(DbSetOrder(1))
SCK->(DbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM))

While SCK->(!Eof()) .And. SCK->CK_FILIAL+SCK->CK_NUM == SCJ->CJ_FILIAL+SCJ->CJ_NUM
	
	SB1->(DbSeek(xFilial("SB1")+SCK->CK_PRODUTO))
	cVarNCM     := SB1->B1_POSIPI
	
	cVarPrdDesc := AllTrim(SB1->B1_DESCR1) + " "
	cVarPrdDesc += AllTrim(SB1->B1_DESCR2) + " "
	cVarPrdDesc += AllTrim(SB1->B1_DESCR3) + " "
	cVarPrdDesc += AllTrim(SB1->B1_DESCR4) + " "
	cVarPrdDesc += AllTrim(SB1->B1_DESCR5)
	
	If Empty(cVarPrdDesc)
		cVarPrdDesc := SCK->CK_DESCRI
	EndIf

	//Reseta Variaveis
	nVarCalc   := 0
	nICMS      := 0
	nPisCofins := 0
	nIPI       := 0

	//Definindo % dos Impostos
	nPerICMS      := (100 - ( SCK->CK_ICMS                          ) ) / 100
	nPerPisCofins := (100 - ( GetMv("MV_TXPIS")+GetMv("MV_TXCOFIN") ) ) / 100
	nPerIPI       := (SCK->CK_IPI / 100) + 1

	//Achando PIS/COFINS
	nVarCalc   := SCK->CK_XXNET
	nVarCalc   := nVarCalc / (nPerICMS+nPerPisCofins-1)
	nVarCalc   := nVarCalc * nPerICMS
	nPisCofins := nVarCalc - SCK->CK_XXNET

	//Achando Valor do ICMS
	nVarCalc   := SCK->CK_XXNET
	nVarCalc   := nVarCalc / (nPerICMS+nPerPisCofins-1)
	nICMS      := nVarCalc - (SCK->CK_XXNET+nPisCofins)

	//Achando Valor do IPI
	nVarCalc   := SCK->CK_XXNET
	nVarCalc   := nVarCalc + nPisCofins + nICMS
	nVarCalc   := nVarCalc * nPerIPI
	nIPI       := nVarCalc - (SCK->CK_XXNET+nPisCofins+nICMS)


	/* DESATIVADO EM 07-06-2013 
	//Achando Valor do ICMS
	nVarCalc   := SCK->CK_XXNET
	nVarCalc   := nVarCalc * nICMS
	nICMS      := SCK->CK_XXNET - nVarCalc

	//Achando Valor do PIS/COFINS
	nVarCalc   := nVarCalc * nPisCofins
	nPisCofins := (SCK->CK_XXNET + nICMS) - nVarCalc

	//Achando Valor do IPI
	nVarCalc   := nVarCalc * nIPI
	nIPI       := (SCK->CK_XXNET + nICMS + nPisCofins) - nVarCalc
	*/

	//=========================================================================
	//Adiciona Linha vazia no array
	aAdd(aItem01,Array(11))

	//ITEM	
	aItem01[Len(aItem01)][01] := AllTrim(SCK->CK_ITEM)

	//CำDIGO ROSENBERGER	
	aItem01[Len(aItem01)][02] := AllTrim(SCK->CK_PRODUTO)

	//DESCRIวรO DO PRODUTO	
	aItem01[Len(aItem01)][03] := AllTrim(cVarPrdDesc)

	//QTDE	
	aItem01[Len(aItem01)][04] := AllTrim(Transform(SCK->CK_QTDVEN, "@E 999,999,999.99"))

	//NCM	
	aItem01[Len(aItem01)][05] := AllTrim(SB1->B1_POSIPI)

	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	//A1_XXORPR1 - Escolha do impressใo da coluna 1, terใo as 5 op็๕es abaixo
	//A1_XXORPR2 - Escolha do impressใo da coluna 2, terใo as 5 op็๕es abaixo
	//A1_XXORPR3 - Escolha do impressใo da coluna 3, terใo as 5 op็๕es abaixo
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	//TIPO 1	- VALOR UNITมRIO SEM PIS/COFINS, ICMS e IPI
	nVar001 := SCK->CK_XXNET
	//nVarPrint := SCK->CK_XXNET
	//aItem01[Len(aItem01)][06] := AllTrim(Transform(nVarPrint, "@E 999,999,999.99"))
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	//TIPO 2	- VALOR UNITมRIO COM PIS/COFINS,  SEM ICMS e IPI
	nVar002 := SCK->CK_XXNET + nPisCofins
	//nVarPrint := SCK->CK_XXNET + nPisCofins
	//aItem01[Len(aItem01)][07] := AllTrim(Transform(nVarPrint, "@E 999,999,999.99"))
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	//TIPO 3	- VALOR UNITมRIO COM PIS/COFINS e ICMS, sem IPI
	nVar003 := SCK->CK_XXNET + nPisCofins + nICMS
	//nVarPrint := SCK->CK_XXNET + nPisCofins + nICMS
	//aItem01[Len(aItem01)][09] := AllTrim(Transform(nVarPrint, "@E 999,999,999.99"))
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	//TIPO 4	- VALOR UNITมRIO COM PIS/COFINS, ICMS e IPI
	nVar004 := SCK->CK_XXNET + nPisCofins + nICMS + nIPI
	//nVarPrint := SCK->CK_XXNET + nPisCofins + nICMS + nIPI
	//aItem01[Len(aItem01)][11] := AllTrim(Transform(nVarPrint, "@E 999,999,999.99"))
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	//TIPO 5	- VALOR UNITมRIO COM PIS/COFINS, ICMS, IPI e ST
	//nVar005 := SCK->CK_ICMSRET
	//nVar005 := SCK->CK_BASESOL     // Helio Ferreira
	If SCK->CK_XXICRET == 'N'
	   nVar005   := SCK->CK_XXNET + nPisCofins + nICMS + nIPI
	Else
	   nVar005   := SCK->CK_XXNET + nPisCofins + nICMS + nIPI + (SCK->CK_ICMSRET/SCK->CK_QTDVEN)
	EndIf
	//nVarST := 0 
	//If SCK->CK_XXICRET == "S"
	//	nVarST := SCK->CK_ICMSRET
	//EndIf
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------
	//PIS/COFINS
	//aItem01[Len(aItem01)][07] := AllTrim(Transform(GetMv("MV_TXPIS")+GetMv("MV_TXCOFIN"), "@E 999,999,999.99")) + " %"
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------

   //Valor 01 conforme Cadastro Cliente
	nVarPrint := 0
	nVarPrint := &("nVar00"+IIf(Empty(SA1->A1_XXORPR1),"1",SA1->A1_XXORPR1))
	aItem01[Len(aItem01)][06] := AllTrim(Transform(nVarPrint, "@E 999,999,999.99"))
	cCabec001 := Posicione("SX5",1,xFilial("SX5")+"ZS"+IIf(Empty(SA1->A1_XXORPR1),"1",SA1->A1_XXORPR1),"X5_DESCRI")

   //Valor 02 conforme Cadastro Cliente
	nVarPrint := 0
	nVarPrint := &("nVar00"+IIf(Empty(SA1->A1_XXORPR2),"2",SA1->A1_XXORPR2))
	aItem01[Len(aItem01)][07] := AllTrim(Transform(nVarPrint, "@E 999,999,999.99"))
	cCabec002 := Posicione("SX5",1,xFilial("SX5")+"ZS"+IIf(Empty(SA1->A1_XXORPR2),"2",SA1->A1_XXORPR2),"X5_DESCRI")

   //Valor 03 conforme Cadastro Cliente
	nVarPrint := 0
	nVarPrint := &("nVar00"+IIf(Empty(SA1->A1_XXORPR3),"3",SA1->A1_XXORPR3))
	aItem01[Len(aItem01)][08] := AllTrim(Transform(nVarPrint, "@E 999,999,999.99"))
	cCabec003 := Posicione("SX5",1,xFilial("SX5")+"ZS"+IIf(Empty(SA1->A1_XXORPR3),"3",SA1->A1_XXORPR3),"X5_DESCRI")
	cCabec004 := StrTran(cCabec003,"PRECO UNIT.","")
	nQtdTotal += (nVarPrint * SCK->CK_QTDVEN)
	//-----------------------------------------------------------------------------------------
	//-----------------------------------------------------------------------------------------

	//ICMS	
	aItem01[Len(aItem01)][09] := AllTrim(Transform(SCK->CK_ICMS, "@E 999,999,999")) + " %"

	//IPI	
	aItem01[Len(aItem01)][10] := AllTrim(Transform(SCK->CK_IPI, "@E 999,999,999")) + " %"

	//PRAZO DE ENTREGA DIAS ฺTEIS
	aItem01[Len(aItem01)][11] := SCK->CK_PRAZO
	//=========================================================================

	//SCK->CK_SEUCOD
	//cVarNCM
	//AllTrim(Transform( (SCK->CK_PRCVEN / ( (100-SCK->CK_ICMS)/100 ) )                         , "@E 999,999,999.99")),;
	//AllTrim(Transform( (SCK->CK_PRCVEN / ( (100-SCK->CK_ICMS)/100 ) ) * ((SCK->CK_IPI/100)+1) , "@E 999,999,999.99")),;
	//AllTrim(Transform( (SCK->CK_VALOR  / ( (100-SCK->CK_ICMS)/100 ) ) * ((SCK->CK_IPI/100)+1) , "@E 999,999,999.99")),;
	//nQtdTotal   += SCK->CK_QTDVEN
	//nPrecoTotal += (SCK->CK_VALOR  / ( (100-SCK->CK_ICMS)/100 )) * ((SCK->CK_IPI/100)+1)

	//nQtdTotal += (SCK->CK_XXNET * SCK->CK_QTDVEN)

	//nVarST := 0
	//If SCK->CK_XXICRET == "S"
	//	nVarST := SCK->CK_ICMSRET
	//EndIf
	//nQtdTotalA += (nVarCalc * SCK->CK_QTDVEN)
	//nQtdTotalB += nVarST
	//nQtdTotalC += (nVarCalc * SCK->CK_QTDVEN) + nVarST

	SCK->(DbSkip())
End

cQtdTotal    := AllTrim(Transform(nQtdTotal    ,"@E 999,999,999.99"))

//cQtdTotalA := AllTrim(Transform(nQtdTotalA   ,"@E 999,999,999.99"))
//cQtdTotalB := AllTrim(Transform(nQtdTotalB   ,"@E 999,999,999.99"))
//cQtdTotalC := AllTrim(Transform(nQtdTotalC   ,"@E 999,999,999.99"))

If File(cTempDot)
	FErase(cTempDot)
EndIf
	
__CopyFile(cPathDot,cTempDot)

//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_NewFile(hWord, cTempDot )

OLE_SetDocumentVar(hWord, 'cDtDia'		        , cDtDia             )
OLE_SetDocumentVar(hWord, 'cDtMes'             , cDtMes             )
OLE_SetDocumentVar(hWord, 'cDtAno'             , cDtAno             )

OLE_SetDocumentVar(hWord, 'cEmpNome'           , cEmpNome           )

OLE_SetDocumentVar(hWord, 'cContatoNome'       , cContatoNome       )
OLE_SetDocumentVar(hWord, 'cContatoDpto'       , cContatoDpto       )
OLE_SetDocumentVar(hWord, 'cContatoEmail'      , cContatoEmail      )
OLE_SetDocumentVar(hWord, 'cContatoTel'        , cContatoTel        )

OLE_SetDocumentVar(hWord, 'cVendedorNome'      , cVendedorNome      )
OLE_SetDocumentVar(hWord, 'cVendedorTel'       , cVendedorTel       )
OLE_SetDocumentVar(hWord, 'cVendedorEmail'     , cVendedorEmail     )

OLE_SetDocumentVar(hWord, 'cSuporteNome'       , cSuporteNome       )
OLE_SetDocumentVar(hWord, 'cSuporteTel'        , cSuporteTel        )
OLE_SetDocumentVar(hWord, 'cSuporteEmail'      , cSuporteEmail      )

OLE_SetDocumentVar(hWord, 'cNumeroProposta'    , cNumeroProposta    )
OLE_SetDocumentVar(hWord, 'cNumeroRevisao'     , cNumeroRevisao     )
OLE_SetDocumentVar(hWord, 'cReferenciaCliente' , cReferenciaCliente )

OLE_SetDocumentVar(hWord, 'cCondPagto'         , cCondPagto         )
OLE_SetDocumentVar(hWord, 'cFrete'             , cFrete             )
OLE_SetDocumentVar(hWord, 'cLocalFrete'        , cLocalFrete        )
OLE_SetDocumentVar(hWord, 'cValidProposta'     , cValidProposta     )

OLE_SetDocumentVar(hWord, 'cObservacao'        , cObservacao        )

OLE_SetDocumentVar(hWord, 'cQtdTotal'          , cQtdTotal          )

//OLE_SetDocumentVar(hWord, 'cQtdTotalA'       , cQtdTotalA         )
//OLE_SetDocumentVar(hWord, 'cQtdTotalB'       , cQtdTotalB         )
//OLE_SetDocumentVar(hWord, 'cQtdTotalC'       , cQtdTotalC         )

OLE_SetDocumentVar(hWord, 'cCabec001'          , cCabec001          )
OLE_SetDocumentVar(hWord, 'cCabec002'          , cCabec002          )
OLE_SetDocumentVar(hWord, 'cCabec003'          , cCabec003          )
OLE_SetDocumentVar(hWord, 'cCabec004'          , cCabec004          )

//*********************
OLE_SetDocumentVar(hWord, 'cTReg01'	, Str(Len(aItem01)))
For n:=1 To Len(aItem01)
	//ITEM	
	OLE_SetDocumentVar(hWord, 'a01Item'      +AllTrim(Str(n))	, aItem01[n][01])

	//CำDIGO ROSENBERGER	
	OLE_SetDocumentVar(hWord, 'a01CodDomex'  +AllTrim(Str(n))	, aItem01[n][02])

	//DESCRIวรO DO PRODUTO	
	OLE_SetDocumentVar(hWord, 'a01ProdDesc'  +AllTrim(Str(n))	, aItem01[n][03])

	//QTDE	
	OLE_SetDocumentVar(hWord, 'a01Qtde'      +AllTrim(Str(n))	, aItem01[n][04])

	//NCM
	OLE_SetDocumentVar(hWord, 'a01Ncm'       +AllTrim(Str(n))	, aItem01[n][05])

	//VALOR 001
	OLE_SetDocumentVar(hWord, 'a01Vlr001'    +AllTrim(Str(n))	, aItem01[n][06])

	//VALOR 002
	OLE_SetDocumentVar(hWord, 'a01Vlr002'    +AllTrim(Str(n))	, aItem01[n][07])

	//VALOR 003
	OLE_SetDocumentVar(hWord, 'a01Vlr003'    +AllTrim(Str(n))	, aItem01[n][08])

	//ICMS	
	OLE_SetDocumentVar(hWord, 'a01PercIcms'  +AllTrim(Str(n))	, aItem01[n][09])

	//IPI	
	OLE_SetDocumentVar(hWord, 'a01PercIpi'   +AllTrim(Str(n))	, aItem01[n][10])

	//PRAZO DE ENTREGA DIAS ฺTEIS
	OLE_SetDocumentVar(hWord, 'a01PrazoDias' +AllTrim(Str(n))	, aItem01[n][11])

Next n

//Executa Macros
OLE_ExecuteMacro(hWord,"CriaItem01")

//Atualizando as variaveis do documento do Word
OLE_UpdateFields(hWord)

//Salva documento
//cFileDes := AllTrim(GetTempPath())+AllTrim(cRFQ)+"-R01.doc"    

cFileDes := "C:\ALL\"+AllTrim(cRFQ)+"-R01.doc"

nRelease := "01"
lLoop    := .T.
While lLoop
	If !File(cFileDes)
		OLE_SaveAsFile(hWord,cFileDes)
		lLoop := .F.
	Else
		nRelease := Soma1(nRelease)
		cFileDes := AllTrim(GetTempPath())+AllTrim(cRFQ)+"-R"+nRelease+".doc"
	EndIf
End

//Pergunta se deve fechar documento documento
OLE_CloseFile( hWord )
OLE_CloseLink( hWord )

If SimNao("Documento gerado e salvo com sucesso no diretorio abaixo.";
          +Chr(13)+Chr(10);
          +Chr(13)+Chr(10);
          +cFileDes;
          +Chr(13)+Chr(10);
          +Chr(13)+Chr(10);
          +"Deseja abri-lo?";
          ,"Abrir proposta no word") == "S"
	fAbreDocs("open",cFileDes,"","",.f.)
EndIF

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fAbreDocsบAutor  ณ Felipe Aurelio Melo บ Data ณ  11/02/2013บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus10                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAbreDocs(cOper,cFileName,cParam,cDir,lMsg)
Local nRet:=0
If !Empty(cFileName)
	nRet:=ShellExecute(cOper,cFileName,cParam,cDir,1)
	If nRet<=32
		If lMsg
			MsgStop("ATENวรO: Nใo foi possํvel abrir o arquivo "+cFileName)
		EndIf
		Return(.f.)
	EndIf
Endif
Return(.t.)