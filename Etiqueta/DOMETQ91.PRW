#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ91 ºAutor  ³ Michel A. Sander   º Data ³  05/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta de Transportadora	para Nota Fiscal                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ91()

PRIVATE cChvDanfe  := SPACE(44)
PRIVATE nOpcDanfe  := 0
PRIVATE nVolDanfe  := 0
PRIVATE oTelaDanfe
PRIVATE oGetDanfe
PRIVATE cPedDanfe  := ""
PRIVATE cNfDanfe   := ""
PRIVATE cSemana    := ""
PRIVATE cTransp    := ""
PRIVATE nRadio     := 1

aRadio := {"Saída","Entrada"}

//cChvDanfe := "35160454821137000136550010000567331000667591"
Define MsDialog oTelaDanfe Title OemToAnsi("Impressão de etiquetas por Nota Fiscal") From 20,20 To 150,620 Pixel of oMainWnd PIXEL
@ 1,005 TO 1,310 PIXEL OF oTelaDanfe
nLin := 010                                                    
@ nLin,005 Say   oTxtDanfe Var "Chave de Acesso da NF" Pixel Of oTelaDanfe
@ nLin,085 MsGet oGetDanfe Var cChvDanfe When .T. Picture "@!" Valid ValDanfe() Size 210,10 Pixel Of oTelaDanfe
nLin += 015
@ nLin,005 Say   oTxtVol   Var "Quantidade de Volumes" Pixel Of oTelaDanfe
@ nLin,085 MsGet oGetVol   Var nVolDanfe When .T. Picture "99999" Valid nVolDanfe > 0 Size 50,10 Pixel Of oTelaDanfe
oTxtDanfe:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetDanfe:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
oTxtVol:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetVol:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin += 016
@ 038,005  RADIO oRadio 		VAR nRadio ITEMS "Nota de Saída","Nota de Entrada" SIZE 50,10 OF oTelaDanfe PIXEL
@ nLin,260 Button oBotDanfe PROMPT "Confirma" Size 35,15 Action {|| nOpcDanfe:=1,oTelaDanfe:End()} Pixel Of oTelaDanfe
Activate MsDialog oTelaDanfe

If nOpcDanfe == 1
	ImpEtqDanfe()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValDanfe ºAutor  ³ Michel A. Sander   º Data ³  05/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca os volumes da DANFE na expedição		                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValDanfe()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica os volumes da DANFE							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nRadio == 1
	
	cAliasSF2 := GetNextAlias()
	cWhereSF2 := "%F2_CHVNFE = '"+ALLTRIM(cChvDanfe)+"'%"
	
	BeginSQL Alias cAliasSF2
		
		SELECT * FROM %table:SF2% SF2 (NOLOCK)
		WHERE SF2.%NotDel%
		AND %Exp:cWhereSF2%
		
	EndSQL

	If (cAliasSF2)->(Eof())
	   Aviso("Atenção","Nota Fiscal de Saída não encontrada.",{"Ok"})
	   (cAliasSF2)->(dbCloseArea())
		cChvDanfe  := SPACE(44)	   
		oGetDanfe:Refresh()
	   Return .f.
	EndIf
	
	SD2->(dbSetOrder(3))
	If SD2->(dbSeek((cAliasSF2)->F2_FILIAL+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE))
		
		SC5->(dbSetOrder(1))
		SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
		SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		cPedDanfe   := SC5->C5_ESP1
		cNfDanfe    := (cAliasSF2)->F2_DOC+" "+ALLTRIM(SA1->A1_MUN)
		cSemana     := fSemanaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)
		cTransp     := SUBSTR(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME"),1,25)
		cIndexQry   := RetSQLName("XD1")+"6"
		cAliasXD1   := GetNextAlias()
		cIndice     := "%WITH(INDEX(" + cIndexQry + "))%"
		cWhere      := "%XD1_FILIAL = '01' AND SUBSTRING(XD1_PVSEP,1,6)='"+Alltrim(SC5->C5_NUM)+"' AND "
		cWhere      += "XD1_OCORRE  = '6'  AND "
		cWhere      += "XD1_NIVEMB  = '3'  AND "
		cWhere      += "XD1_ZYNOTA  = '"+(cAliasSF2)->F2_DOC+"'%"
		
		BeginSQL Alias cAliasXD1
			SELECT COUNT(*) NQTDECAIXA FROM %table:XD1% (NOLOCK) %exp:cIndice% WHERE %exp:cWhere%
		EndSQL
		nVolDanfe := (cAliasXD1)->NQTDECAIXA
		(cAliasXD1)->(dbCloseArea())
		
	EndIf

	(cAliasSF2)->(dbCloseArea())	
	
Else
	
	cAliasSF1 := GetNextAlias()
	cWhereSF1 := "%F1_CHVNFE = '"+ALLTRIM(cChvDanfe)+"'%"
	
	BeginSQL Alias cAliasSF1
		
		SELECT * FROM %table:SF1% SF1 (NOLOCK)
		WHERE SF1.%NotDel%
		AND %Exp:cWhereSF1%
		
	EndSQL

	If (cAliasSF1)->(Eof())
	   Aviso("Atenção","Nota Fiscal de Entrada não encontrada.",{"Ok"})
	   (cAliasSF1)->(dbCloseArea())
		cChvDanfe  := SPACE(44)	   
		oGetDanfe:Refresh()
	   Return .f.
	EndIf

	SD1->(dbSetOrder(1))
	If SD1->(dbSeek((cAliasSF1)->F1_FILIAL+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE))
		
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(xFilial("SC7")+SD1->D1_PEDIDO))
		SA2->(dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))
		cPedDanfe   := SC7->C7_NUM
		cNfDanfe    := (cAliasSF1)->F1_DOC+" "+ALLTRIM(SA2->A2_MUN)
		cSemana     := fSemanaAno()+"/"+SubStr(StrZero(Year(Date()),4),3,2)
		cTransp     := ""  //SUBSTR(Posicione("SA4",1,xFilial("SA4")+SC7->C7_TRANSP,"A4_NOME"),1,25)
		cIndexQry   := RetSQLName("XD1")+"6"
		cAliasXD1   := GetNextAlias()
		cIndice     := "%WITH(INDEX(" + cIndexQry + "))%"
		cWhere      := "%XD1_FILIAL = '01' AND SUBSTRING(XD1_PVSEP,1,6)='"+Alltrim(SC7->C7_NUM)+"' AND "
		cWhere      += "XD1_OCORRE  = '6'  AND "
		cWhere      += "XD1_NIVEMB  = '3'  AND "
		cWhere      += "XD1_ZYNOTA  = '"+(cAliasSF1)->F1_DOC+"'%"
		
		BeginSQL Alias cAliasXD1
			SELECT COUNT(*) NQTDECAIXA FROM %table:XD1% (NOLOCK) %exp:cIndice% WHERE %exp:cWhere%
		EndSQL
		nVolDanfe := (cAliasXD1)->NQTDECAIXA
		(cAliasXD1)->(dbCloseArea())
		
	EndIf

	(cAliasSF1)->(dbCloseArea())	
		
Endif

oTelaDanfe:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpEtqDanfeºAutor ³ Michel A. Sander  º Data ³  05/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão da etiqueta							                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpEtqDanfe()

Local cPathTmp   := AllTrim( GetSrvProfString("RootPath","") )
Local cFileDes   := ""
LOCAL cModelo    := "Z4M"
Local cPorta     := "LPT1"
Local cRotacao   := "N"      //(N,R,I,B)

//Chamando função da impressora ZEBRA

For nX := 1 to nVolDanfe
	
	MSCBPRINTER(cModelo,cPorta,,,.F.)
	MSCBChkStatus(.F.)
	MSCBLOADGRF("RDT2.GRF")
	
	//Inicia impressão da etiqueta
	MSCBBEGIN(1,5)
	
	nCol  := 06
	nLin  := 17
	
	//Logos
	MSCBGRAFIC(05,07,"RDT2")
	
	MSCBSAY(nCol   ,nLin      ,"Rosenberger Domex Telecomunicações"                              ,cRotacao,"0","26,26")
	MSCBSAY(nCol   ,nLin+3    ,"Av. Cabletech, 601 - Caçapava - SP"	                           ,cRotacao,"0","26,26")
	MSCBSAY(nCol   ,nLin+6    ,"Tel (12) 3221 8500"																,cRotacao,"0","26,26")
	MSCBSAY(nCol   ,nLin+9    ,"www.rdt.com.br"                                                  ,cRotacao,"0","26,26")
	
	//Contorno/Borda
	MSCBBOX(03,30,115,80,3,"B")
	
	//Grade de Separacao de coluna
	MSCBBOX(40,30,40,80,3,"B")
	MSCBSAY(nCol,    35, "Cliente"                              ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 35, SUBSTR(SA1->A1_NOME,1,20)              ,cRotacao,"0","35,35")
	
	//Grade de Clientes
	MSCBBOX(03,40,115,80,3,"B")
	MSCBSAY(nCol   , 45, "Pedido Compra"                       ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 45, cPedDanfe				                 ,cRotacao,"0","35,35")
	
	//Grade da Nota Fiscal/Local
	MSCBBOX(03,50,115,80,3,"B")
	MSCBSAY(nCol   , 55, "NF/LOCAL"     	                    ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 55, cNfDanfe  				                 ,cRotacao,"0","35,35")
	
	//Grade da Semana/Ano
	MSCBBOX(03,60,115,80,3,"B")
	MSCBSAY(nCol   , 65, "Semana/Ano"                          ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 65, cSemana  				                 ,cRotacao,"0","35,35")
	
	//Grade da Semana/Ano
	MSCBBOX(03,70,115,80,3,"B")
	MSCBSAY(nCol   , 75, "Transportadora"                      ,cRotacao,"0","35,35")
	MSCBSAY(nCol+40, 75, cTransp  				                 ,cRotacao,"0","35,35")
	MSCBInfoEti("DOMEX","80X60")
	
	//Finaliza impressão da etiqueta
	MSCBEND()
	Sleep(500)
	
	MSCBCLOSEPRINTER()
	
Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSemanaAnoºAutor  ³ Felipe Melo        º Data ³  11/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fSemanaAno()

Local dDataIni := StoD(StrZero(Year(Date()),4)+"0101")
Local dDataAtu := Date()
Local nRet     := 0
Local cRet     := ""
Local nDiff    := Dow(dDataIni)

nDias := (dDataAtu - dDataIni) + nDiff

nRet  := nDias
nRet  := nRet / 7
nRet  := Int(nRet)

//Se iniciou a semana, soma 1
If nDias % 7 > 0
	nRet := nRet + 1
EndIf

cRet := StrZero(nRet,2)

//Função padrão que retorna a semana e o ano
//RetSem(dDataAtu)

Return(cRet)
