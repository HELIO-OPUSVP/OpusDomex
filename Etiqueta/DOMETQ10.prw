#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DOMETQ10 บAutor  ณ Michel A. Sander   บ Data ณ  15/05/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta Modelo 10 (nใo grava XD1)                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMETQ10(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local cModelo    := "Z4M"
Local cPorta     := "LPT1"

Local lPrinOK    := MSCBModelo("ZPL",cModelo)

Local aPar       := {}
Local aRet       := {}
Local nVar       := 0

Local cRotacao   := "N"      //(N,R,I,B)

Local mv_par02   := 1         //Qtd Embalagem
Local mv_par03   := 1         //Qtd Etiquetas

Local aRetAnat   := {}        //Codigos Anatel, Array
Local aCodAnat   := {}        //Codigos Anatel, Array
Local cCdAnat1   := ""        //Codigo Anatel 1
Local cCdAnat2   := ""        //Codigo Anatel 2

Private lAchou   := .T.
Private aGrpAnat := {}     //Codigos Anatel Agrupados
Private _cSerieIni:=""
Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNumSerie := ""
Default cNumPeca  := ""

mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" nใo localizada!")
		lAchou := .F.
	EndIf
	

EndIf

//Localiza SA1
If !Empty(SC2->C2_PEDIDO)
	SA1->(DbSetOrder(1))
	If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		Alert("Cliente "+SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" nใo localizado!")
		lAchou := .F.
	EndIf
EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" nใo localizado!")
	lAchou := .F.
EndIf

//
If lAchou
	aRetAnat := U_fCodNat(SB1->B1_COD)
	lAchou   := aRetAnat[1]
	aCodAnat := aRetAnat[2]
	
	If lAchou .And. Empty(SB1->B1_XXNANAT)
		Alert("Nใo foi preenchido o campo 'Nบ Codigo Anatel' para o produto: "+AllTrim(SB1->B1_COD) + Chr(13)+Chr(10)+ "[B1_XXNANAT]")
		lAchou := .F.
	EndIf
	
EndIf

If lAchou
	//Agrupando Codigos Anatel
	For x:=1 To Len(aCodAnat)
		nVar := aScan(aGrpAnat,aCodAnat[x])
		If nVar == 0
			aAdd(aGrpAnat,aCodAnat[x])
		EndIf
	Next x
	
	Do Case
		Case Val(SB1->B1_XXNANAT) == 0 .And. Len(aGrpAnat) == 0
			cCdAnat1 := ""
			cCdAnat2 := ""
			
		Case Val(SB1->B1_XXNANAT) == 1 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := ""
			
		Case Val(SB1->B1_XXNANAT) == 2 .And. Len(aGrpAnat) == 1
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[1]
			
		Case Val(SB1->B1_XXNANAT) == 3 .And. Len(aGrpAnat) == 2
			cCdAnat1 := aGrpAnat[1]
			cCdAnat2 := aGrpAnat[2]
			
		OtherWise
			cCdAnat1 := " E R R O "
			cCdAnat2 := " E R R O "
			If !Empty(cNumOP)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ10)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"OP:"+cNumOP)
			ElseIf !Empty(cNumSenf)
				Alert("Erro no tratamento dos codigos ANATEL (DOMETQ10)."+Chr(13)+Chr(10)+"Favor procurar TI e informar dificuldade! "+Chr(13)+Chr(10)+"Senf:"+cNumSenf)
			EndIf
			lAchou   := .F.
			
	EndCase
	
EndIf

If !Empty(cNumOP)
	
	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" nใo localizada!")
		lAchou := .F.
	EndIf
	
EndIf

//Valida se Campo Descricao do Produto estแ preenchido
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto nใo estแ preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Caso algum registro nใo seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

//Se impressora nใo identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configura็ใo!")
	Return(.T.)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o n๚mero de s้rie														 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
cNumSerie := Val(cNumSerie)
cSerieFim := If( cNumSerie == 1, 1, cNumSerie )
If Len(Alltrim(SC2->C2_NUM)) <=5
	If SC2->C2_QUANT <=9
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
	ElseIf SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
	ElseIf SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
	ElseIf SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
	ElseIf SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
		cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
	EndIf
Else
	Do Case
		Case SC2->C2_QUANT <=9
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
		Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
			cNumSerie:="S" + AllTrim(SC2->C2_NUM)+SC2->C2_ITEM+SC2->C2_SEQUEN+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
	EndCase		
EndIf

lImprime := .F.

nCol := 05
nIni := 07
nLin := 04
//a    := 3

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
//ณMontagem do c๓digo de barras 2D						 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
cWW     := StrZero(Val(SubsTr(cSemana,5,2)),2)
cYY     := Substr(cSemana,3,2)

WEEK->(dbCloseArea())

cL10 := ""
a    := 0
cSerial1 := ""
cSerial2 := ""
cSerial3 := ""
For x := 1 To mv_par03
	
	cSerial1   := ""
	cSerial2   := ""
	cSerial3   := ""
	
	a := a + 1
	If a == 1
	   cL10 := "PN: "+SC2->C2_PRODUTO+";"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+";"+cWW+cYY+";"//+cNumSerie+";"
	   cSerial1   := cNumSerie
	   cNumSerie := Soma1(cNumSerie)	   	   
	ElseIf a == 2 	
	   cL10 += "PN: "+SC2->C2_PRODUTO+";"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+";"+cWW+cYY+";"//+cNumSerie+";"
	   cSerial2   := cNumSerie	   	   
	   cNumSerie := Soma1(cNumSerie)
	ElseIf a == 3 	
	   cL10 += "PN: "+SC2->C2_PRODUTO+";"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+";"+cWW+cYY+";"//+cNumSerie+";"
	   cSerial3   := cNumSerie	   	   
	   cNumSerie := Soma1(cNumSerie)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
		//ณParโmetros de impressใo do Crystal Reports		 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
	   cOptions := "2;0;1;LAYOUT10"			// Parametro 1 (2= Impressora 1=Visualiza)
	   
	   cL10 += cSerial1 + ";" + cSerial2 + ";" + cSerial3
	   	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
		//ณExecuta Crystal Reports para impressใo			 	 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
		
		CALLCRYS('LAYOUT010', cL10 ,cOptions)
	    a := 0
	EndIf
	
Next x

lResto := .F.
If a == 1
   //cL10 := "PN: "+SC2->C2_PRODUTO+";"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+";"+cWW+cYY+";"+cSerial1+";"
   cL10 += "FINAL"+";"+"FINAL"+";"+"FINAL"+";"//+"FINAL"+";"
   cL10 += "FINAL"+";"+"FINAL"+";"+"FINAL"+";"//+"FINAL"+";"
   
   cL10 += cSerial1 + ";" + cSerial2 + ";" + cSerial3
   
   lResto := .T.
ElseIf a == 2 	
   //cL10 := "PN: "+SC2->C2_PRODUTO+";"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+";"+cWW+cYY+";"+cSerial2+";"
   //cL10 += "PN: "+SC2->C2_PRODUTO+";"+"OM: "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+";"+cWW+cYY+";"+cSerial3+";"
   cL10 += "FINAL"+";"+"FINAL"+";"+"FINAL"+";"//+"FINAL"+";"
   
   cL10 += cSerial1 + ";" + cSerial2 + ";" + cSerial3
   
   lResto := .T.
EndIf

If lResto

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
	//ณParโmetros de impressใo do Crystal Reports		 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
   cOptions := "2;0;1;LAYOUT10"			// Parametro 1 (2= Impressora 1=Visualiza)
   	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
	//ณExecuta Crystal Reports para impressใo			 	 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
	CALLCRYS('LAYOUT010', cL10 ,cOptions)
   a := 0

EndIf

Return(.T.)
