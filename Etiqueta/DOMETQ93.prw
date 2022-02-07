#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ93 ºAutor  ³ Michel A. Sander   º Data ³  04/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta padrão TELEFÔNICA							              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Executado pela DOMETDL3 e via Menu                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//..
User Function DOMETQ93(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe, lManual, nQtdEmbal)

PRIVATE cChvDanfe  := SPACE(44)
PRIVATE nOpcDanfe  := 0
PRIVATE nVolDanfe  := 0
PRIVATE oTelaDanfe
PRIVATE cPedDanfe  := ""
PRIVATE cSemana    := ""
PRIVATE cTransp    := ""
DEFAULT lManual    := .F.
DEFAULT nQtdEmbal  := 0

ImpEtqTel(@cEtqOp, @cEtqProd, @cEtqPed, @nEtqQtd, @dDataFab, @lControl, @cNfDanfe, @nPesoDanfe, @lManual, @nQtdEmbal)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpEtqTelºAutor  ³ Michel A. Sander   º Data ³  04/10/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime etiqueta padrão telefônica			                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpEtqTel(cEtqOp, cEtqProd, cEtqPed, nEtqQtd, dDataFab, lControl, cNfDanfe, nPesoDanfe, lManual, nQtdEmbal)

Local cPathTmp   := AllTrim( GetSrvProfString("RootPath","") )
Local cFileDes   := ""
LOCAL cModelo    := "Z4M"
Local cPorta     := "LPT2"
Local cRotacao   := "N"      //(N,R,I,B)
Local cAliasSB1  := SB1->(GetArea())
Local cAliasSC2  := SC2->(GetArea())
Local nX		 := 0 
Local nEtqQtdI   := 1                             
//Chamando função da impressora ZEBRA
If !lControl
	cPorta := "LPT1"
EndIf

// Armazenando informacoes para um possivel cancelamento da etiqueta por falha na impressao
If Type("cTeletDl32_CancOP") <> "U"
	cTeletDl32_CancOP  := cEtqOp
	cTeletDl33_CancPro := cEtqProd
	cTeletDl34_CancPed := cEtqPed
	cTeletDl35_CancUni := nEtqQtd
	cTeletDl38_CancDat := dDataFab
EndIf

If nQtdEmbal == 0
   nQtdEmbal := nEtqQtd
EndIf
   
If !lManual 
   nEtqQtd := 1
else
	nEtqQtdI := nEtqQtd
	nEtqQtd := 1
EndIf

For nX := 1 to nEtqQtd

	if lManual
		cFila := SuperGetMv("MV_XFILEXP",.F.,"000005")
		IF !CB5SetImp(cFila,.F.)
			Aviso("Local de impressao invalido!","Aviso")
			Return .F.
		EndIf
	Endif
	//Chamando função da impressora ZEBRA
	if !lManual
		MSCBPRINTER(cModelo,cPorta,,,.F.)
		MSCBChkStatus(.F.)
		//	MSCBLOADGRF("ANATEL2.GRF")
	//else
	//	MSCBPRINTER(cModelo,cPorta,,,.F.)
	//	MSCBChkStatus(.F.)	
	Endif
	MSCBLOADGRF("RDT2.GRF")
	
	//Inicia impressão da etiqueta
	If !lManual
		MSCBBEGIN(1,5)	
	Else
		MSCBBEGIN(nEtqQtdI,5)
	EndIf
	nCol    := 06
	nLin    := 13
	nLinFim := 85
	
	cItBusca := SUBSTR(cEtqOp,7,2)
	SC5->(dbSetOrder(1))
	SC5->(dbSeek(xFilial()+cEtqPed))
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial()+cEtqPed+cItBusca))
	
	//Contorno/Borda
	MSCBBOX(03,03,115,nLinFim,6,"B")
	
	//Grade principal
	MSCBBOX(03,nLin,115,nLin,3,"B")
	MSCBSAY(nCol+30, nLin-07, "IDENTIFICAÇÃO DE MATERIAL"               ,cRotacao,"0","35,35")
	
	//Grade do Fornecedor
	MSCBBOX(40,nLin,40,nLinFim,3,"B")
	
	MSCBSAY(nCol,    nLin+2, "FORNECEDOR:"                              ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, nLin+2, "ROSENBERGER DOMEX"                        ,cRotacao,"0","35,35")
	
	nLin += 07
	
	//Grade de Descrição do Produto
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol   , nLin+2, "DESCRIÇÃO:"                               ,cRotacao,"0","35,35")
	cEtqDesc := ""
	
	If SC6->( FieldPos("C6_XDESCTE") ) > 0 
	
		If !Empty(SC6->C6_XDESCTE)
			MSCBSAY(nCol+40, nLin+2, SC6->C6_XDESCTE	              ,cRotacao,"0","21,21")
		Else
			If SB1->(dbSeek(xFilial("SB1")+cEtqProd))
				MSCBSAY(nCol+40, nLin+2, SB1->B1_DESC	              ,cRotacao,"0","21,21")
				cEtqDesc := SB1->B1_DESC
			EndIf
		EndIf
	
	Else
	
		If SB1->(dbSeek(xFilial("SB1")+cEtqProd))
			MSCBSAY(nCol+40, nLin+2, SB1->B1_DESC	              ,cRotacao,"0","21,21")
			cEtqDesc := SB1->B1_DESC
		EndIf
	
	EndIf
	
	//Grade do Codigo de Material
	nLin += 07
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol   , nLin+2, "COD. MATERIAL:"     	                    ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, nLin+2, SC6->C6_SEUCOD			                 ,cRotacao,"0","35,35")
	
	//Grade da Quantidade
	nLin += 07
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol   , nLin+2, "QUANT/UNID:"                              ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, nLin+2, TransForm(nQtdEmbal,"@E 999999")+"   PC"     ,cRotacao,"0","35,35")
	
	//Grade de Peso Bruto
	cPesoFinal := If(nPesoDanfe>0,TransForm(nPesoDanfe,"@E 99999.99"),"")+" -KG"
	nLin += 07
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol   , nLin+2, "PESO BRUTO:"                              ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, nLIn+2, cPesoFinal		  				                 ,cRotacao,"0","35,35")
	
	//Grade do Pedido de Compra
	nLin += 07
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol   , nLin+2, "PEDIDO DE COMPRA:"                        ,cRotacao,"0","31,31")
	MSCBSAY(nCol+40, nLin+2, SC5->C5_ESP1	  				                 ,cRotacao,"0","31,31")
	//MSCBSAY(nCol+40, nLin+2, cEtqPed			  				              ,cRotacao,"0","31,31")
	
	//Grade da Nota Fiscal
	nLin += 07
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol   , nLin+2, "NOTA FISCAL:"                             ,cRotacao,"0","35,35")
	If !Empty(cNfDanfe)
		MSCBSAY(nCol+40, nLin+2, cNfDanfe	  				                 ,cRotacao,"0","29,29")
	Else
	EndIf
	
	//Grade da Data de Fabricação
	nLin += 07
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol-1 , nLin+2, "DATA DE FABRICAÇÃO:"                      ,cRotacao,"0","29,29")
	MSCBSAY(nCol+40, nLin+2, DTOC(dDataFab)  				                 ,cRotacao,"0","29,29")
	
	//Grade de Empilhamento
	nLin += 07
	MSCBBOX(03,nLin,115,nLinFim,3,"B")
	MSCBSAY(nCol   , nLin+2, "EMPILHAMENTO"                             ,cRotacao,"0","35,35")
	MSCBSAY(nCol   , nLin+6  , "    MAXIMO"                             ,cRotacao,"0","35,35")
	MSCBSAY(nCol   , nLin+10 , "   PERMITIDO:"                          ,cRotacao,"0","35,35")
	//	MSCBSAY(nCol+40, nLin+2, cSemana  				                 ,cRotacao,"0","35,35")
	
	//MSCBInfoEti("DOMEX","80X60")
	
	//Finaliza impressão da etiqueta
	MSCBEND()
	Sleep(500)
	
	MSCBCLOSEPRINTER()
  
Next

RestArea( cAliasSB1 )
RestArea( cAliasSC2 )

Return
