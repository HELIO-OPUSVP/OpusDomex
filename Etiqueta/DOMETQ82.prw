#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DOMETQ82 บAutor  ณ Michel A. Sander   บ Data ณ  25/10/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta Modelo 80 Serial com Datamatrix                   บฑฑ
ฑฑบ          ณ (Sem impressใo de numera็ใo no C๓digo de Barras)           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMETQ82(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local mv_par02   := 1         //Qtd Embalagem
Local mv_par03   := 1         //Qtd Etiquetas
Local clCrystal  := "Serial"

Private lAchou     := .T.

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

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" nใo localizado!")
	lAchou := .F.
EndIf
//If AllTrim(SB1->B1_GRUPO) == "TRUE" .Or. AllTrim(SB1->B1_GRUPO) == "TRUN"
//   clCrystal := "SerialTrunk"
//EndIf

//Localiza SA1
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"nใo localizado!")
	lAchou := .F.
EndIf

//Caso algum registro nใo seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

cOpAux    := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)
nItOP     := StrZero(Val(SubStr(cOPAux,8,1)),3)
cNumSerie := PADR(SubsTr(cOPAux,1,5),6)+SubsTr(cOPAux,6,2)+nItOP

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
//ณPrepara n๚mero de s้rie									 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
If (SC2->C2_QUANT*12)<= 99
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"1"
ElseIf ((SC2->C2_QUANT*12)>= 100 .AND. (SC2->C2_QUANT*12)<= 999)
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"01"
ElseIf ((SC2->C2_QUANT*12)>= 1000 .AND. (SC2->C2_QUANT*12)<= 9999)
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"001"
ElseIf ((SC2->C2_QUANT*12)>= 10000 .AND. (SC2->C2_QUANT*12)<= 99999)
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+"0001"
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
//ณParโmetros de impressใo do Crystal Reports		 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
cOptions   := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
cNumSerie1 := SPACE(12)
cNumSerie2 := SPACE(12)
cNumSerie3 := SPACE(12)

x := 0
For nQ := 1 to nQtdEtq 

      If nQ > 1
         cNumSerie := Soma1(cNumSerie)
      EndIf
      
      If x==0       
	      cNumSerie1 := cNumSerie
      ElseIf x==1
      	cNumSerie2 := cNumSerie
      ElseIf x==2
      	cNumSerie3 := cNumSerie
      EndIf
      
      x++

		If x==3

		   cParam := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie1+";"
		   cParam += AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie2+";"
		   cParam += AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie3+";"+SPACE(10)+";"+SPACE(10)+";"+SPACE(10)+";"

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
			//ณExecuta Crystal Reports para impressใo			 	 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
			CALLCRYS(clCrystal, cParam ,cOptions)
			Sleep(100)
	      cNumSerie1 := SPACE(12)
	      cNumSerie2 := SPACE(12)
	      cNumSerie3 := SPACE(12)
	      x 			  := 0
	            
      EndIf
       
Next

If x == 1      
   
   cParam := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie1+";"
   cParam += "FINAL"+";"+SPACE(12)+";"
   cParam += "FINAL"+";"+SPACE(12)+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"
                                                                                                            
	CALLCRYS(clCrystal, cParam ,cOptions)
	Sleep(100)

ElseIf x == 2

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
	//ณParametro de impressใo								 	 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
   cParam := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie1+";"
   cParam += AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie2+";"
   cParam += "FINAL"+";"+SPACE(12)+";"+SPACE(10)+";"+SPACE(10)+";"+SPACE(10)+";"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
	//ณExecuta Crystal Reports para impressใo			 	 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤxิ[ฟ
	CALLCRYS(clCrystal, cParam ,cOptions)
	Sleep(100)

EndIf

Return(.T.)