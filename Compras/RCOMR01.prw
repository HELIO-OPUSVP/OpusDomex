#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE VBOX      080
#DEFINE VSPACE    008
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   010                                                // Mแximo de produtos para a primeira pแgina
#DEFINE MAXITEMP2 044                                                // Mแximo de produtos para a pagina 2 (caso nao utilize a op็ใo de impressao em verso)
#DEFINE MAXITEMP3 015                                                // Mแximo de produtos para a pagina 2 (caso utilize a op็ใo de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%.
#DEFINE MAXITEMP4 022                                                // Mแximo de produtos para a pagina 2 (caso contenha main info cpl que suporta a primeira pagina)
#DEFINE MAXITEMC  012                                                // Mแxima de caracteres por linha de produtos/servi็os
#DEFINE MAXMENLIN 110                                                // Mแximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG    006                                                // Mแximo de dados adicionais na primeira pแgina
#DEFINE MAXMSG2   019                                                // Mแximo de dados adicionais na segunda pแgina
#DEFINE MAXBOXH   800                                                // Tamanho maximo do box Horizontal
#DEFINE MAXBOXV   600
#DEFINE INIBOXH   -10
#DEFINE MAXMENL   080                                                // Mแximo de caracteres por linha de dados adicionais
#DEFINE MAXVALORC 009                                                // Mแximo de caracteres por linha de valores num้ricos

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOMR01  บAutor  ณ Michel Alex Sander บ Data ณ  17.01.05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Emissao do Pedido de Compras em modo Grแfico (Paisagem)    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DOMEX                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ                                  							                 ผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RCOMR01(oPedCom, cPedAuto)

Private oFont5
Private oFont6
Private oFont7
Private oFont8
Private oFont8n
Private oFont10
Private oFont13n
Private oFont15
Private oFont15n
Private oFont16
Private oFont16n
Private oFont24
Private cUSER := ""
Private aSays	   := {}
Private aButtons  := {}
Private cCadastro := ''
Private nOpca 	   := 0
Private cperg     := 'RCOMA1'
Private nLin      := 10
Private nPag      := 0
Private aRegs     := {}
Private nLimite   := 1850
Private nTotPed   := 0
Private lContinua := .f.
Private cObs      := ''
Private cTransp   := ''
Private cDesenho  := ''
Private cComposta := ''
Private aObservac := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Array dos parametros de impressใo                                  		 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aRegs := {}
aAdd( aRegs,{ cPerg,"01","Pedido Compra De","","","mv_cha","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","SC7","" })
aAdd( aRegs,{ cPerg,"02","Pedido Compra Ate","","","mv_chb","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","SC7","" })
aAdd( aRegs,{ cPerg,"03","Emissao De","","","mv_chc","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd( aRegs,{ cPerg,"04","Emissao Ate","","","mv_chd","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd( aRegs,{ cPerg,"05","Fornecedor De","","","mv_che","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","SA2","" })
aAdd( aRegs,{ cPerg,"06","Fornecedor Ate","","","mv_chf","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","SA2","" })
                                     
ValidPerg(aRegs,cPerg)
Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica se gera PDF automatico dos pedidos de compra            		  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Type("lAutoPed") <> "U"

   MV_PAR01 := cPedAuto
   MV_PAR02 := cPedAuto
   MV_PAR03 := CTOD("01/01/01")
   MV_PAR04 := CTOD("31/12/47")
   MV_PAR05 := SPACE(06)
   MV_PAR06 := "ZZZZZZ"
	PrcRFAT04(@oPedCom)
	
Else

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta tela inicial                                                		 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aAdd(aSays,OemToAnsi( 'Este Programa tem como objetivo imprimir o PEDIDO DE COMPRA' ) )
	
	aAdd( aButtons, { 5,.T.,{|| Pergunte(cPerg,.t.) }} )
	aAdd( aButtons, { 1,.T.,{|o| nOpca := 1, If( GpConfOk(), FechaBatch(), nOpca := 0 ) }} )
	aAdd( aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
	FormBatch( cCadastro, aSays, aButtons )
	
	If nOpca == 1
		Processa( { || PrcRFAT04() },'Processamento das Informa็๕es', NIL, .T. )
	Endif

EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRCRFAT04 บAutor  ณ Michel Alex Sander บ Data ณ  17/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa os dados da tabela de acordo com os parโmetros    บฑฑ
ฑฑบ          ณ Especificados na RFATR04                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrcRFAT04(oPedCom)

Local nCon   := 0

dbSelectArea("SC1")
dbSetOrder(2)
dbSelectArea("SC7")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)

cQuery := "SELECT * FROM "       + RetSqlName("SC7") + " (NOLOCK) WHERE "
cQuery += "C7_FILIAL = '"        + xFilial("SC7")    + "' AND "
cQuery += "C7_NUM     BETWEEN '" + mv_par01          + "' AND '" + mv_par02       + "' AND "
cQuery += "C7_EMISSAO BETWEEN '" + Dtos(mv_par03)    + "' AND '" + Dtos(mv_par04) + "' AND "
cQuery += "C7_FORNECE BETWEEN '" + mv_par05          + "' AND '" + mv_par06       + "' AND "
cQuery += "D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY C7_NUM"

dbUseArea(.t., "TOPCONN", TcGenQry(,,cQuery), "TC7", .f., .t.)
If TC7->(Eof())
	TC7->(dbCloseArea())
	Return .t.
EndIf

dbEval( { || nCon += 1 } )

If Type("lAutoPed") == "U"

	oPedCom := TMSPrinter():New( "" ) //inicializa a variavel
	oBrush  := TBrush():New("",1)
	oPedCom:SetLandscape() //ou SetPortrait()
	oFont5  := TFont():New("Arial",9,5 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont7  := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8n := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15 := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont21 := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont22T:= TFont():New("Times New Roman",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont24T:= TFont():New("Times New Roman",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	
Else

	oFont5  := TFontEx():New(oPedCom,"Arial",5,5 ,.T.,.F.)
	oFont7  := TFontEx():New(oPedCom,"Arial",7,7 ,.T.,.F.)
	oFont8  := TFontEx():New(oPedCom,"Arial",8,8 ,.T.,.F.)
	oFont8n := TFontEx():New(oPedCom,"Arial",8,8 ,.T.,.F.)
	oFont10 := TFontEx():New(oPedCom,"Arial",10,10,.T.,.F.)
	oFont12 := TFontEx():New(oPedCom,"Arial",12,12,.T.,.F.)
	oFont12n:= TFontEx():New(oPedCom,"Arial",12,12,.T.,.F.)
	oFont13 := TFontEx():New(oPedCom,"Arial",13,13,.T.,.F.)
	oFont13n:= TFontEx():New(oPedCom,"Arial",13,13,.T.,.F.)
	oFont15 := TFontEx():New(oPedCom,"Arial",15,15,.T.,.F.)
	oFont15n:= TFontEx():New(oPedCom,"Arial",15,15,.T.,.F.)
	oFont16 := TFontEx():New(oPedCom,"Arial",16,16,.T.,.F.)
	oFont16n:= TFontEx():New(oPedCom,"Arial",16,16,.T.,.F.)
	oFont21 := TFontEx():New(oPedCom,"Arial",21,21,.T.,.F.)
	oFont24 := TFontEx():New(oPedCom,"Arial",24,24,.T.,.F.)
	oFont22T:= TFontEx():New(oPedCom,"Times New Roman",16,16,.T.,.T.,.F.)
	oFont24T:= TFontEx():New(oPedCom,"Times New Roman",24,24,.T.,.T.,.F.)
	
EndIf

oPedCom:StartPage()    // Inicia uma nova pแgina

nLin := 0010
ProcRegua(nCon)
TC7->(dbGotop())
While TC7->(!Eof())
	
	IncProc("Gerando as tabelas...")
	
	nFilOrdem := TC7->C7_FILIAL
	nNumOrdem := TC7->C7_NUM
	
	//---> Imprime o Cabecalho do Orcamento
	RFAT04Cabec(@oPedCom)
	nTotPed := 0
	cObs    := ''
	aObservac := {}
	nCont   := 0
	While TC7->(!Eof()) .And. TC7->C7_FILIAL+TC7->C7_NUM == nFilOrdem+nNumOrdem
		
			cTransp := ''
		    
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Aumentado as linhas de impressao do campo observacao.        ณ
		//ณ Pode-se informar at้ 4 linhas de observacao (C7_OBS).        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !Empty(TC7->C7_OBS)
			cObs      += TC7->C7_OBS
			If ((Int(nCont/2))*2) = nCont
				Aadd( aObservac, TC7->C7_OBS )
			Else 
				aObservac[Len(aObservac)] += " " + TC7->C7_OBS
			EndIf
			nCont ++
		EndIf
		
		If (nLin+0075) > nLimite
			lContinua := .t.
			RodapePC(@oPedCom)
			oPedCom:EndPage()     // Finaliza a pแgina
			oPedCom:StartPage()   // Inicia uma nova pแgina
			
			nLin := 0040
			RFAT04Cabec(@oPedCom)
		EndIf
		
		DetalhePC(@oPedCom)
		
		cDesenho  := ''
		cComposta := {}
		nTotPed   += (TC7->C7_TOTAL + TC7->C7_VALIPI)
		nLin      += 0050
		TC7->(dbSkip())
		
	End
	
	SaltoItens(@oPedCom)
	lContinua := .f.
	RodapePC(@oPedCom)
	oPedCom:EndPage()
	nPag := 0
	
End

oPedCom:EndPage()     // Finaliza a pแgina
If Type("lAutoPed") == "U"
	cFileHtml := "\system\PEDCOM_PDF\Relatorio.HTM"
	lSend := oPedCom:SaveAsHTML( cFileHtml, {1,2} )
	oPedCom:SaveAllAsJpeg( '\system\PEDCOM_PDF\relatorio', 1120, 840, 140, 100 )
	oPedCom:Preview()     // Visualiza antes de imprimir
Endif
TC7->(dbCloseArea())

Return ( oPedCom )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT04CabecบAutor ณ Michel Alex Sander บ Data ณ  17/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o cabecalho do pedido de compra                    บฑฑ
ฑฑบ          ณ especificado na RFATR04                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RFAT04Cabec(oPedCom)

// Incrementa o numero da pagina
nPag += 1

// Frame do Relatorio
nLin := 0040
oPedCom:Box       ( nLin,0001,2400,3200 )

// Cabecalho
nLin += 0020
oPedCom:Line      ( nLin,0015,nLin+0150,0015 )
oPedCom:Line      ( nLin,0015,nLin     ,1230)

// Logotipo da Empresa
//cLogoD := GetSrvProfString("Startpath","") + "DANFE0101.BMP"
oPedCom:SayBitmap ( nlin+0020,0025,'DANFE0101.bmp', 350, 250 )   // Logotipo da WS

oPedCom:Line      ( nlin,1270,nlin     ,2090)
oPedCom:Line      ( nlin,1270,nlin+0150,1270)
oPedCom:Line      ( nlin,2120,nlin+0150,2120)
oPedCom:Line      ( nLin,2120,nLin     ,2550)
oPedCom:Line      ( nLin,2580,nLin     ,3180)
oPedCom:Line      ( nLin,2580,nLin+0150,2580)
oPedCom:Say       ( nlin,0380,"ROSENBERGER DOMEX TELEC. LTDA",If( Type("lAutoPed") == "U", oFont12n, oFont12n:oFont) )
oPedCom:Say       ( nlin,2130,"Data de Emissใo",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Say       ( nlin,2600,"N๚mero",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
nLin += 25
oPedCom:Say       ( nlin,1300,"PEDIDO DE COMPRA",If( Type("lAutoPed") == "U", oFont21, oFont21:oFont) )
oPedCom:Say       ( nLin,2750,TC7->C7_NUM+"/"+StrZero(nPag,2), If( Type("lAutoPed") == "U", oFont24T, oFont24T:oFont) )
nLin += 025
oPedCom:Say       ( nLin,2220,SubStr(TC7->C7_EMISSAO,7,2)+"/"+SubStr(TC7->C7_EMISSAO,5,2)+"/"+SubStr(TC7->C7_EMISSAO,1,4), If( Type("lAutoPed") == "U", oFont15n, oFont15n:oFont ) )
nLin += 0115

// Bloco do Fornecedor
oPedCom:Say       ( nLin-0050,2750,"Revisใo ",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0015,nLin+0300,0015)
oPedCom:Line      ( nLin,0015,nLin     ,3180)
nLin += 0025
oPedCom:Say       ( nLin,0020,"Fornecedor",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
SA2->(dbSeek(xFilial("SA2")+TC7->C7_FORNECE+TC7->C7_LOJA))
oPedCom:Say       ( nLin-5,0200,SA2->A2_COD + " " + SA2->A2_NOME, If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
nLin += 0050
oPedCom:Say       ( nLin,0020,"Endere็o  ", If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Say       ( nLin-5,0200,SA2->A2_END, If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
oPedCom:Say       ( nLin,1900,"Fแbrica:LOCAL PARA FATURAMENTO E COBRANวA",If( Type("lAutoPed") == "U", oFont10, oFont10:oFont)  )
nLin += 0050
oPedCom:Say       ( nLin,0020,"C I D A D E",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Say       ( nLin-5,0200,SA2->A2_MUN,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
oPedCom:Say       ( nLin,0950,"Estado",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Say       ( nLin-5,1050,SA2->A2_EST,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
oPedCom:Say       ( nLin,1240,"Cep",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Say       ( nLin-5,1300,TransForm(SA2->A2_CEP,"@R XX.XXX-XXX"), If( Type("lAutoPed") == "U", oFont10, oFont10:oFont)  )
oPedCom:Say       ( nLin,1900,"Av. Cabletech, 601 - Guamirim - CAวAPAVA - SP",If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
nLin += 0050
oPedCom:Say       ( nLin,0020,"CNPJ / CPF ", If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Say       ( nLin-5,0200,TransForm(SA2->A2_CGC,"@R XX.XXX.XXX/XXXX-XX"),If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
oPedCom:Say       ( nLin,1900,"CEP 12.295-230 - Tel (12) 3221 8500",If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
oPedCom:Say       ( nLin,0950,"Tel",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Say       ( nLin-5,1050,SA2->A2_TEL,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
nLin += 0050
oPedCom:Say       ( nLin,0020,"Ins. Estad.",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Say       ( nLin-5,0200,SA2->A2_INSCR,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
oPedCom:Say       ( nLin,1900,"CNPJ 54.821.137/0001-36",If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
oPedCom:Say       ( nLin,0950,"Fax",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Say       ( nLin-5,1050,SA2->A2_FAX,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
nLin += 0050
oPedCom:Say       ( nLin,0020,"Contato",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ))
If Empty(TC7->C7_CONTATO)
	oPedCom:Say    ( nLin-5,0200,SA2->A2_CONTATO,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
Else
	oPedCom:Say    ( nLin-5,0200,TC7->C7_CONTATO,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
EndIf
oPedCom:Say       ( nLin,0950,"E-Mail",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Say       ( nLin-5,1050,SA2->A2_EMAIL,If( Type("lAutoPed") == "U", oFont10, oFont10:oFont) )
nLin += 0050

// Bloco das Condicoes Comerciais
oPedCom:Line      ( nLin,0015,nLin+0150,0015 )
oPedCom:Line      ( nLin,0015,nLin     ,2300 )
oPedCom:Line      ( nLin,2330,nLin+0150,2330 )
oPedCom:Line      ( nLin,2330,nLin     ,2800 )
oPedCom:Line      ( nLin,2830,nLin+0150,2830 )
oPedCom:Line      ( nLin,2830,nLin     ,3180 )
oPedCom:Say       ( nLin,2335,"Condi็๕es de Pagamento",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Say       ( nLin,2835,"CONTA No.",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
nLin += 0050
oPedCom:Say       ( nLin,0025,"SOLICITAMOS FORNECER OS MATERIAIS OU SERVICOS ABAIXO ESPECIFICADOS CONFORME NOSSAS CONDIวีES DE COMPRA.",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
nLin += 0050
SE4->(dbSeek(xFilial("SE4")+TC7->C7_COND))
oPedCom:Say       ( nLin,2340,SubStr(SE4->E4_DESCRI,1,20),If( Type("lAutoPed") == "U", oFont13n, oFont13n:oFont) )
nLin += 0075

// Itens do Pedido de Compra
oPedCom:Line      ( nLin,0015,nLin+0100,0015 )
oPedCom:Line      ( nLin,0015,nLin     ,3180 )
oPedCom:Say       ( nLin,0020,"ITEM"         ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0100,nLin+0100,0100 )
oPedCom:Say       ( nLin,0105,"RDC"          ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0230,nLin+0100,0230 )
oPedCom:Say       ( nLin,0235,"CODIGO"       ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0595,nLin+0100,0595 )
oPedCom:Say       ( nLin,0600,"QUANT."       ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0790,nLin+0100,0790 )
oPedCom:Say       ( nLin,0795,"UN"           ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0840,nLin+0100,0840 )
oPedCom:Say       ( nLin,0845,"DESCRICAO DO PRODUTO",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont) )
oPedCom:Line      ( nLin,1960,nLin+0100,1960 )
oPedCom:Say       ( nLin,1965,"PESO UNIT."   ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,2160,nLin+0100,2160 )
oPedCom:Say       ( nLin,2165,"PESO TOTAL"   ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,2365,nLin+0100,2365 )
oPedCom:Say       ( nLin,2370,"ENTREGA"      ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,2565,nLin+0100,2565 )
oPedCom:Say       ( nLin,2570,"R$ UNITARIO"  ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,2805,nLin+0100,2805 )
oPedCom:Say       ( nLin,2810,"IPI"          ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,2855,nLin+0100,2855 )
oPedCom:Say       ( nLin,2860,"R$ TOTAL ITEM",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,3175,nLin+0100,3175 )
nLin += 0050

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetalhePC บAutor  ณ Michel Alex Sander บ Data ณ  17/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime os itens do pedido de compra                       บฑฑ
ฑฑบ          ณ especificados na RFATR04                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DetalhePC(oPedCom)

SB1->(dbSeek(xFilial("SB1")+TC7->C7_PRODUTO))
cUser := Embaralha(TC7->C7_USERLGI,1)
cDesenho := ''
cComposta := SB1->B1_DESC

oPedCom:Line      ( nLin,0015,nLin+0100,0015 )
oPedCom:Say       ( nLin,0040,TC7->C7_ITEM   ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0100,nLin+0100,0100 )
oPedCom:Say       ( nLin,0105,TC7->C7_NUMSC  ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFOnt ) )
oPedCom:Line      ( nLin,0230,nLin+0100,0230 )
oPedCom:Say       ( nLin,0240,SB1->B1_COD    ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0595,nLin+0100,0595 )
oPedCom:Say       ( nLin,0600,TransForm(TC7->C7_QUANT,"@E 999,999.99"),If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0790,nLin+0100,0790 )
oPedCom:Say       ( nLin,0795,TC7->C7_UM     ,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,0840,nLin+0100,0840 )
oPedCom:Say       ( nLin,0850,Substr(cComposta,1,68),If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,1960,nLin+0100,1960 )
//oPedCom:Say       ( nLin,1965,TransForm(TC7->C7_DMPESO,"@ZE 99999.9999"),oFont8)
oPedCom:Line      ( nLin,2160,nLin+0100,2160 )
//oPedCom:Say       ( nLin,2165,TransForm(nPesoT,"@ZE 99999.9999"),oFont8)
oPedCom:Line      ( nLin,2365,nLin+0100,2365 )
oPedCom:Say       ( nLin,2370,SubStr(TC7->C7_DATPRF,7,2)+"/"+SubStr(TC7->C7_DATPRF,5,2)+"/"+SubStr(TC7->C7_DATPRF,1,4),If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,2565,nLin+0100,2565 )
oPedCom:Say       ( nLin,2570,TransForm(TC7->C7_PRECO,"@ZE 99,999,999.99"),If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,2805,nLin+0100,2805 )
oPedCom:Say       ( nLin,2810,TransForm(TC7->C7_IPI,"@Z 99"),If( Type("lAutoPed") == "U", oFont7, oFont7:oFont ) )
oPedCom:Line      ( nLin,2855,nLin+0100,2855 )
oPedCom:Say       ( nLin,2890,TransForm(TC7->C7_TOTAL,"@E 999,999,999.99"),If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Line      ( nLin,3175,nLin+0100,3175 )
nLin += 0050

If (nLin+0075) > nLimite
	lContinua := .t.
	RodapePC(@oPedCom)
	oPedCom:EndPage()     // Finaliza a pแgina
	oPedCom:StartPage()   // Inicia uma nova pแgina
	nLin := 0040
	RFAT04Cabec(@oPedCom)
EndIf

For nQ := 69 to Len(cComposta) Step 68
	If (nLin+0075) > nLimite
		lContinua := .t.
		RodapePC(@oPedCom)
		oPedCom:EndPage()     // Finaliza a pแgina
		oPedCom:StartPage()   // Inicia uma nova pแgina
		nLin := 0040
		RFAT04Cabec(@oPedCom)
	EndIf
	oPedCom:Line      ( nLin,0015,nLin+0100,0015 )
	oPedCom:Line      ( nLin,0100,nLin+0100,0100 )
	oPedCom:Line      ( nLin,0230,nLin+0100,0230 )
	oPedCom:Line      ( nLin,0595,nLin+0100,0595 )
	oPedCom:Line      ( nLin,0790,nLin+0100,0790 )
	oPedCom:Line      ( nLin,0840,nLin+0100,0840 )
	oPedCom:Say       ( nLin,0850,SubStr(cComposta,nQ,68),If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
	oPedCom:Line      ( nLin,1960,nLin+0100,1960 )
	oPedCom:Line      ( nLin,2160,nLin+0100,2160 )
	oPedCom:Line      ( nLin,2365,nLin+0100,2365 )
	oPedCom:Line      ( nLin,2565,nLin+0100,2565 )
	oPedCom:Line      ( nLin,2805,nLin+0100,2805 )
	oPedCom:Line      ( nLin,2855,nLin+0100,2855 )
	oPedCom:Line      ( nLin,3175,nLin+0100,3175 )
	nLin += 0050
Next


Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSaltoItensบAutor  ณ Michel Alex Sander บ Data ณ  17/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o saldo do item ate o rodape                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SaltoItens(oPedCom)

For nX := nLin to nLimite Step 50
	
	If (nLin+0075) >= nLimite
		nLin += 0050
		Exit
	EndIf
	
	oPedCom:Line      ( nLin,0015,nLin+0100,0015 )
	oPedCom:Line      ( nLin,0100,nLin+0100,0100 )
	oPedCom:Line      ( nLin,0230,nLin+0100,0230 )
	oPedCom:Line      ( nLin,0595,nLin+0100,0595 )
	oPedCom:Line      ( nLin,0790,nLin+0100,0790 )
	oPedCom:Line      ( nLin,0840,nLin+0100,0840 )
	oPedCom:Line      ( nLin,1960,nLin+0100,1960 )
	oPedCom:Line      ( nLin,2160,nLin+0100,2160 )
	oPedCom:Line      ( nLin,2365,nLin+0100,2365 )
	oPedCom:Line      ( nLin,2565,nLin+0100,2565 )
	oPedCom:Line      ( nLin,2805,nLin+0100,2805 )
	oPedCom:Line      ( nLin,2855,nLin+0100,2855 )
	oPedCom:Line      ( nLin,3175,nLin+0100,3175 )
	nLin += 0050
	
Next

Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RodapePC ณ Autor ณ Michel Alex Sander บ Data ณ  17/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o rodape                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RodapePC(oPedCom)

oPedCom:Line      ( nLin,0015,nLin     ,3180 )
nLin += 0025
oPedCom:Box  (nLin,0015,nLin+0150,3175)
oPedCom:Say (nLin,0020,"MENSAGENS",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
nLin += 0050
oPedCom:Say (nLin,0020,"TESTE PADRAO ROSENBERGER",If( Type("lAutoPed") == "U", oFont7, oFont7:oFont ) )
nLin += 0050
oPedCom:Say (nLin,0020,"Trata-se de um teste de pedido de compras da empresa Rosenberger.",If( Type("lAutoPed") == "U", oFont7, oFont7:oFont) )
nLin += 0075
oPedCom:Line(nLin,0015,nLin+0250,0015)
oPedCom:Line(nLin,0015,nLin     ,1550)
oPedCom:Line(nLin,1580,nLin+0250,1580)
oPedCom:Line(nLin,1580,nLin     ,2050)
oPedCom:Line(nLin,2080,nLin+0250,2080)
oPedCom:Line(nLin,2080,nLin     ,2500)
oPedCom:Line(nLin,2530,nLin+0250,2530)
oPedCom:Line(nLin,2530,nLin     ,3180)
oPedCom:Say (nLin,0015,"Observa็๕es:",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Say (nLin,1580,"COMPRADOR",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Say (nLin,2080,"GERENTE DE COMPRAS",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
oPedCom:Say (nLin,2535,"VALOR TOTAL COM IPI",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
nLin += 0050
If Len(aObservac) >= 1
	oPedCom:Say (nLin,0015,aObservac[1],If( Type("lAutoPed") == "U", oFont7, oFont7:oFont ) )
EndIf
If !lContinua
	oPedCom:Say (nLin,2735,"R$ "+TransForm(nTotPed,"@ZE 999,999,999.99"),If( Type("lAutoPed") == "U", oFont15n, oFont15n:oFont ) )
EndIf
nLin += 0060
oPedCom:Line(nLin,2530,nLin     ,3180)

If Len(aObservac) >= 2
	oPedCom:Say (nLin,0015,aObservac[2],If( Type("lAutoPed") == "U", oFont7, oFont7:oFont ) )
EndIf

oPedCom:Say (nLin,2535,"RECEBI A 1o. VIA DESTE PEDIDO DE COMPRA",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
nLin += 0050
If !Empty(cTransp)
	SA4->(dbSeek(xFilial("SA4")+cTransp))
	oPedCom:Say (nLin,0015,SA4->A4_NOME,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
EndIf


oPedCom:Say (nLin,1620,SubStr(cUSER,1,15),If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
oPedCom:Say (nLin,2120,"Hamilton Dias",If( Type("lAutoPed") == "U", oFont10, oFont10:oFont ) )
oPedCom:Say (nLin,2535,"PEDIDO No. ",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
nLin += 0050
If !Empty(cTransp)
	oPedCom:Say (nLin,0015,SA4->A4_END+"  "+SA4->A4_MUN+"   "+SA4->A4_TEL,If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
EndIf
oPedCom:Say (nLin,2535,"____/____/____    _________________________",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
nLin += 0030
oPedCom:Say (nLin,2535,"                                          ASSINATURA",If( Type("lAutoPed") == "U", oFont8, oFont8:oFont ) )
nLin += 0020
oPedCom:EndPage()     // Finaliza a pแgina
//oPedCom:StartPage()   // Inicia uma nova pแgina
//Ultima()
Return .t.

for i:=1 to Len( aRegs )
	IF !sx1->( DBSeek( cPerg+aRegs[i,2] ) )
		IF RecLock("SX1",.T.)
			FOR j:=1 to FCount()
				IF j <= Len( aRegs[i] )
					FieldPut( j,aRegs[i,j] )
				ENDIF
			NEXT
		ENDIF
		MsUnlock()
	Endif
Next

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ULTIMA   บAutor  ณ Michel Alex Sander บ Data ณ  17/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao da pagina de condicoes do pedido de compra       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAFAT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ULTIMA(oPedCom)

aTexto := {}
Aadd( aTexto,Space(255)+'C O N D I C O E S    G E R A I S      D E      C O M P R A'+Space(255)+'Data Rev. 02/06/06')

nLin := 0030

FOR nInd := 1 TO Len(aTexto)
	vTexto := aTexto[nInd]
	oPedCom:Say (nLin,0000.5,aTexto[nInd],If( Type("lAutoPed") == "U", oFont5, oFont5:oFont ) )
//	nLin := 0027 +     nLin
	nLin := 0018 +     nLin
	
	If nLin > 2350
		oPedCom:EndPage()     // Finaliza a pแgina
		oPedCom:StartPage()   // Inicia uma nova pแgina
		nLin := 0030
	EndIf
NEXT

RETURN .T.
