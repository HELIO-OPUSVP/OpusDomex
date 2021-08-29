#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMETQ84 ºAutor  ³ Michel A. Sander   º Data ³  08.11.2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Etiqueta Modelo 29 - Junção Trunk 					           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMETQ84(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local mv_par02    := 1         //Qtd Embalagem
Local mv_par03    := 1         //Qtd Etiquetas

Private lAchou    := .T.
Default cNumOP    := ""
Default cNumSenf  := ""
Default nQtdEmb   := 0
Default nQtdEtq   := 0
Default cNumSerie := ""
Default cNumPeca  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca quantidades para impressão											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)

	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" não localizada!")
		lAchou := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta o número de série														 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	cSerieFim := If( cNumSerie == 1, 1, cNumSerie )

	Do Case
			Case SC2->C2_QUANT <=9
				cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,1)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
				cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,2)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
				cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,3)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
				cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,4)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
				cNumSerie:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(cSerieFim,5)	// MV_PAR07 Sequencial Serial
	EndCase
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no PA																 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" não localizado!")
	lAchou := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no Cliente					    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"não localizado!")
	lAchou := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida descrição do produto		    									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto não está preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Caso algum registro não seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Montagem do código de barras 2D						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
WEEK->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consiste a quantidade de conectores na estrutura					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
nEtq := 0
cSQL := "SELECT B1_GRUPO, B1_DESC, G1_COD, G1_COMP, G1_XXQTET1, G1_XXQTET2, G1_QUANT FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COD = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "(G1_XXQTET1 > 0 OR G1_XXQTET2 > 0) AND "
cSQL += "SUBSTRING(B1_GRUPO,1,3) = 'TRU'"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"ETQ",.F.,.T.)

If ETQ->(Eof())

   Aviso("Atenção","Um ou mais Componentes da estrutura está sem o lado definido. Altere a estrutura e tente novamente.",{"Ok"})
	cTxtMsg  := " Um Componente da estrutura está sem o lado definido. Altere a estrutura e tente novamente." + Chr(13)
	cTxtMsg  += " Estrutura  = " + ETQ->G1_COD  + Chr(13)
	cTxtMsg  += " Componente = " + ETQ->G1_COMP + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 084 - Junção Trunk 29"
	cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	ETQ->(dbCloseArea())
   Return

EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
//³Parâmetros de impressão do Crystal Reports		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
cOptions := "2;0;1;Trunk"			// Parametro 1 (2= Impressora 1=Visualiza)
nQ 		:= 1
nSomaSer := cNumSerie
nDobra   := If(SUBSTR(SB1->B1_GRUPO,1,4)=="TRUN", 2, 1)                  
cIL1     := AllTrim(TransForm(SB1->B1_XXIL1,"9.99"))
cIL2     := AllTrim(TransForm(SB1->B1_XXIL2,"9.99"))
nAviso   := Aviso("Atenção","Tipo de impressão",{"Total","Parcial"})
nChoice  := If(nAviso==1,SC2->C2_QUANT,mv_par03)
   
For x := 1 to nChoice
   
   ETQ->(dbGoTop())
   Do While ETQ->(!Eof())
      
	   If ETQ->G1_XXQTET1 > 0 .And. ETQ->G1_XXQTET2 > 0

			// Imprime os dois lados por serial
			// Imprime o LADO A
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "LADO: A"
	      cMVPAR03 := "PN:"+SB1->B1_COD //ETQ->G1_COMP
	      cMVPAR04 := "SN:"+nSomaSer
	      cMVPAR05 := "IL:"+cIL1+"dB"
	      cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)
	      cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"
	   
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		   //³Executa Crystal Reports para impressão			 	 ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	      CALLCRYS('TrunkJuncao29', cParam ,cOptions)
         Sleep(2000)

			// Imprime o LADO B
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "LADO: B"
	      cMVPAR03 := "PN:"+SB1->B1_COD //ETQ->G1_COMP
	      cMVPAR04 := "SN:"+nSomaSer
	      cMVPAR05 := "IL:"+cIL2+"dB"
	      cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)
	      cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"
	   
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		   //³Executa Crystal Reports para impressão			  ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	      CALLCRYS('TrunkJuncao29', cParam ,cOptions)
         Sleep(2000)
	
		ElseIf ETQ->G1_XXQTET1 > 0 .And. ETQ->G1_XXQTET2 <= 0
		
			// Imprime o LADO A
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "LADO: A"
	      cMVPAR03 := "PN:"+SB1->B1_COD //ETQ->G1_COMP
	      cMVPAR04 := "SN:"+nSomaSer
	      cMVPAR05 := "IL:"+cIL1+"dB"
	      cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)
	      cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"
	   
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		   //³Executa Crystal Reports para impressão			 	 ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	      CALLCRYS('TrunkJuncao29', cParam ,cOptions)
         Sleep(2000)

		ElseIf ETQ->G1_XXQTET1 <= 0 .And. ETQ->G1_XXQTET2 > 0

			// Imprime o LADO B
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "LADO: B"
	      cMVPAR03 := "PN:"+SB1->B1_COD //ETQ->G1_COMP
	      cMVPAR04 := "SN:"+nSomaSer
	      cMVPAR05 := "IL:"+cIL2+"dB"
	      cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)
	      cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"
	   
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		   //³Executa Crystal Reports para impressão			  ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
	      CALLCRYS('TrunkJuncao29', cParam ,cOptions)
         Sleep(2000)

		EndIf
/*
      If ETQ->G1_XXQTET1 > 0

	      For y := 1 to ETQ->G1_XXQTET1
	         
		      cMVPAR01 := SB1->B1_DESC
		      cMVPAR02 := "LADO: A"
		      cMVPAR03 := "PN:"+SB1->B1_COD //ETQ->G1_COMP
		      cMVPAR04 := "SN:"+nSomaSer
		      cMVPAR05 := "IL:"+cIL1+"dB"
		      cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)
		      cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"
		   
			  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			  //³Executa Crystal Reports para impressão			 	 ³
			  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		      CALLCRYS('TrunkJuncao29', cParam ,cOptions)
	         Sleep(2000)
	
	      Next y
      
      EndIf
         
      If ETQ->G1_XXQTET2 > 0
	      
	      For y := 1 to ETQ->G1_XXQTET2
	         
		      cMVPAR01 := SB1->B1_DESC
		      cMVPAR02 := "LADO: B"
		      cMVPAR03 := "PN:"+SB1->B1_COD //ETQ->G1_COMP
		      cMVPAR04 := "SN:"+nSomaSer
		      cMVPAR05 := "IL:"+cIL2+"dB"
		      cMVPAR06 := SUBSTR(cSemana,5,2)+"/"+SUBSTR(cSemana,3,2)
		      cParam   := cMVPAR01+";"+cMVPAR02+";"+cMVPAR03+";"+cMVPAR04+";"+cMVPAR05+";"+cMVPAR06+";"
		   
			  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
			  //³Executa Crystal Reports para impressão			  ³
			  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄxÔ[¿
		      CALLCRYS('TrunkJuncao29', cParam ,cOptions)
	         Sleep(2000)
	
	      Next y
                                                                
      EndIf
*/
      ETQ->(dbSkip()) 
	   
	EndDo

   nSomaSer := Soma1(nSomaSer)
      
Next x

ETQ->(dbCloseArea())

Return ( .T. )
