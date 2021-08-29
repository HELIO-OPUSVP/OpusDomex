#include "protheus.ch"
#include "rwmake.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ81 ºAutor  ³ Michel A. Sander   º Data ³  25/10/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 81 Serial Ericsson em T com Datamatrix     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ81(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local mv_par02   := 1         //Qtd Embalagem
Local mv_par03   := 1         //Qtd Etiquetas

Local nQ         :=0

Private lAchou   := .T.

Private cGrupo   :=space(04)
Private cTipoETQ :=space(15)


Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNumSerie := 1
Default cNumPeca  := ""

mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)

	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	EndIf

EndIf

//Localiza SC6
SC6->(DbSetOrder(1))
If lAchou .And. SC6->(!DbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV))
	Alert("Item Senf "+AllTrim(SC2->C2_ITEMPV)+" não localizado!")
	lAchou := .F.
EndIf

If !Empty(SC2->C2_PEDIDO)
	If lAchou .And. Empty(SC6->C6_SEUCOD)
		Alert("Campo PN não está preenchido no Item do Pedido de Vendas! "+Chr(13)+Chr(10)+"[C6_SEUCOD]")
		lAchou := .F.
	EndIf
EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf

//Localiza SA1
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"não localizado!")
	lAchou := .F.
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

cGrupo :=SB1->B1_GRUPO

DO CASE
   CASE ALLTRIM(cGrupo)=='FLEX'
        cTipoETQ:='COAXIAL CABLE'
   CASE ALLTRIM(cGrupo)=='CORD'
        cTipoETQ:='FIBER CABLE'
   CASE ALLTRIM(cGrupo)=='TRUE'      
        cTipoETQ:='MULTIFIBER CABLE'
   OTHERWISE  
        cTipoETQ:=space(15)
ENDCASE   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Montagem do código de barras 2D						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
WEEK->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Prepara número de série									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cSerieFim := If( Empty(cNumSerie), 1, cNumSerie )
If Len(Alltrim(SC2->C2_NUM)) <= 5
   If (SC2->C2_QUANT*12)<= 99
      cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,1)
   ElseIf ((SC2->C2_QUANT*12)>= 100 .AND. (SC2->C2_QUANT*12)<= 999)
      cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,2)
   ElseIf ((SC2->C2_QUANT*12)>= 1000 .AND. (SC2->C2_QUANT*12)<= 9999)
      cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,3)
   ElseIf ((SC2->C2_QUANT*12)>= 10000 .AND. (SC2->C2_QUANT*12)<= 99999)
      cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,4)
   EndIf
Else
   If (SC2->C2_QUANT*12)<= 99
      cNumSerie := "S" + AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SC2->C2_SEQUEN+StrZero(cSerieFim,1)
   ElseIf ((SC2->C2_QUANT*12)>= 100 .AND. (SC2->C2_QUANT*12)<= 999)
      cNumSerie := "S" + AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SC2->C2_SEQUEN+StrZero(cSerieFim,2)
   ElseIf ((SC2->C2_QUANT*12)>= 1000 .AND. (SC2->C2_QUANT*12)<= 9999)
      cNumSerie := "S" + AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SC2->C2_SEQUEN+StrZero(cSerieFim,3)
   ElseIf ((SC2->C2_QUANT*12)>= 10000 .AND. (SC2->C2_QUANT*12)<= 99999)
      cNumSerie := "S" + AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SC2->C2_SEQUEN+StrZero(cSerieFim,4)
   EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Parâmetros de impressão do Crystal Reports		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cOptions   := "2;0;1;Ericsson"			// Parametro 1 (2= Impressora 1=Visualiza)
cNumSerie1 := SPACE(12)
cNumSerie2 := SPACE(12)

x := 0
For nQ := 1 to nQtdEtq 

      If nQ > 1           
         cNumSerie := Soma1(cNumSerie)
      EndIf
      
      If x==0       
	      cNumSerie1 := cNumSerie
      ElseIf x==1
      	cNumSerie2 := cNumSerie
      EndIf
      
      x++

		If x==2

			// Primeira Etiqueta
         cMVPAR01 := SC6->C6_SEUCOD
         //cMVPAR02 := "COAXIAL CABLE"
         cMVPAR02 := cTipoETQ
         cMVPAR03 := cSemana                                 
         cMVPAR04 := "MADE IN BRAZIL"
         cMVPAR05 := SC6->C6_XXRSTAT
         cMVPAR06 := "T.A."
         cMVPAR07 := "BG7-"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
         cMVPAR08 := cNumSerie1
         
         // Segunda Etiqueta
         cMVPAR09 := SC6->C6_SEUCOD
         //cMVPAR10 := "COAXIAL CABLE"
         cMVPAR10 := cTipoETQ
         cMVPAR11 := cSemana                                 
         cMVPAR12 := "MADE IN BRAZIL"
         cMVPAR13 := SC6->C6_XXRSTAT
         cMVPAR14 := "T.A."
         cMVPAR15 := "BG7-"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
         cMVPAR16 := cNumSerie2

		   cParam := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"+cMVPAR08+";"
		   cParam += cMVPAR09+";"+cMVPAR10+";"+cMVPAR11+";"+cMVPAR12+";"+cMVPAR13+";"+cMVPAR14+";"+cMVPAR15+";"+cMVPAR16+";"

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			//³Executa Crystal Reports para impressão			 	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			CALLCRYS('SerialEricsson', cParam ,cOptions)

			Sleep(200)

	      cNumSerie1 := SPACE(12)
	      cNumSerie2 := SPACE(12)
	      x 			  := 0
	            
      EndIf
       
Next

If x == 1      
   
	// Ultima Etiqueta
   cMVPAR01 := SC6->C6_SEUCOD
   //cMVPAR02 := "COAXIAL CABLE"
   cMVPAR02 := cTipoETQ
   cMVPAR03 := cSemana                                 
   cMVPAR04 := "MADE IN BRAZIL"
   cMVPAR05 := SC6->C6_XXRSTAT
   cMVPAR06 := "T.A."
   cMVPAR07 := "BG7-"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
   cMVPAR08 := cNumSerie1

   cParam := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"+cMVPAR07+";"+cMVPAR08+";"
   cParam += "FINAL"+";"+SPACE(10)+";"+SPACE(10)+";"+SPACE(10)+";"+SPACE(10)+";"+SPACE(10)+";"+SPACE(10)+";"+SPACE(10)+";"
                                                                                                            
	CALLCRYS('SerialEricsson', cParam ,cOptions)
	Sleep(200)

EndIf

Return(.T.)
