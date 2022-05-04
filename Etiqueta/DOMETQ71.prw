#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ71 �Autor  � Michel A. Sander   � Data �  31.01.2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta Modelo 29 - Jun��o Trunk 					           ���
���          � (Substitui Leiaute 84)                                     ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ71(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local mv_par02    := 1         //Qtd Embalagem
Local mv_par03    := 1         //Qtd Etiquetas

Private lAchou    := .T.
Private x
Default cNumOP    := ""
Default cNumSenf  := ""
Default nQtdEmb   := 0
Default nQtdEtq   := 0
Default cNumSerie := ""
Default cNumPeca  := ""

//����������������������������������������������������������������Ŀ
//�Busca quantidades para impress�o											 �
//����������������������������������������������������������������Ŀ
mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)

	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" n�o localizada!")
		lAchou := .F.
	EndIf

	//����������������������������������������������������������������Ŀ
	//�Monta o n�mero de s�rie														 �
	//����������������������������������������������������������������Ŀ
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

//����������������������������������������������������������������Ŀ
//�Posiciona no PA																 �
//����������������������������������������������������������������Ŀ
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n�o localizado!")
	lAchou := .F.
EndIf

//����������������������������������������������������������������Ŀ
//�Posiciona no Cliente					    									 �
//����������������������������������������������������������������Ŀ
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"n�o localizado!")
	lAchou := .F.
EndIf

//����������������������������������������������������������������Ŀ
//�Valida descri��o do produto		    									 �
//����������������������������������������������������������������Ŀ
If lAchou .And. Empty(SB1->B1_DESC)
	Alert("Campo Descricao do Produto n�o est� preenchido no cadastro do produto! "+Chr(13)+Chr(10)+"[B1_DESC]")
	lAchou := .F.
EndIf

//Caso algum registro n�o seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

//�����������������������������������������������x�[�
//�Montagem do c�digo de barras 2D						 �
//�����������������������������������������������x�[�
cSQL    := "SELECT dbo.SemanaProtheus() AS SEMANA"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"WEEK",.F.,.T.)
cSemana := WEEK->SEMANA
WEEK->(dbCloseArea())

//����������������������������������������������������������������Ŀ
//�Consiste a quantidade de conectores na estrutura					 �
//����������������������������������������������������������������Ŀ
nEtq := 0
cSQL := "SELECT B1_GRUPO, B1_DESC, G1_COD, G1_COMP, G1_XXQTET1, G1_XXQTET2, G1_QUANT FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COD = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "(G1_XXQTET1 > 0 OR G1_XXQTET2 > 0) AND "
cSQL += "SUBSTRING(B1_GRUPO,1,3) IN ('TRU','CMT') "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"ETQ",.F.,.T.)

If ETQ->(Eof())

   Aviso("Aten��o","Um ou mais Componentes da estrutura est� sem o lado definido. Altere a estrutura e tente novamente.",{"Ok"})
	cTxtMsg  := " Um Componente da estrutura est� sem o lado definido. Altere a estrutura e tente novamente." + Chr(13)
	cTxtMsg  += " Estrutura  = " + ETQ->G1_COD  + Chr(13)
	cTxtMsg  += " Componente = " + ETQ->G1_COMP + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 084 - Jun��o Trunk 29"
	cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475 
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	ETQ->(dbCloseArea())
   Return

EndIf   

//�����������������������������������������������x�[�
//�Par�metros de impress�o do Crystal Reports		 �
//�����������������������������������������������x�[�
cOptions := "2;0;1;Trunk"			// Parametro 1 (2= Impressora 1=Visualiza)
nQ 		:= 1
nSomaSer := cNumSerie
nDobra   := If(SUBSTR(SB1->B1_GRUPO,1,4)=="TRUN", 2, 1)                  
cIL1     := AllTrim(TransForm(SB1->B1_XXIL1,"9.99"))
cIL2     := AllTrim(TransForm(SB1->B1_XXIL2,"9.99"))
nAviso   := Aviso("Aten��o","Tipo de impress�o",{"Total","Parcial"})
nChoice  := If(nAviso==1,SC2->C2_QUANT,mv_par03)
aEtqs    := {}   
x 		 := 0
For x := 1 to nChoice
   
   lUnico := .F.
   ETQ->(dbGoTop())
   Do While ETQ->(!Eof())
      
	   If ETQ->G1_XXQTET1 > 0 .And. ETQ->G1_XXQTET2 > 0

			// Monta os dois lados por serial
			// Monta o LADO A
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "RDT"
	      cMVPAR03 := "FAN: "+AllTrim(SB1->B1_XFANA)
	      cMVPAR04 := "L: A"
	      cMVPAR05 := "SN:"+nSomaSer
	      cMVPAR06 := "IL:"+cIL1+"dB"
         AADD(aEtqs,{ cMVPAR01, cMVPAR02, cMVPAR03, cMVPAR04, cMVPAR05, cMVPAR06 } )

			// Monta o LADO B
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "RDT"
	      cMVPAR03 := "FAN: "+AllTrim(SB1->B1_XFANB)
	      cMVPAR04 := "L: B"
	      cMVPAR05 := "SN:"+nSomaSer
	      cMVPAR06 := "IL:"+cIL2+"dB"
         AADD(aEtqs,{ cMVPAR01, cMVPAR02, cMVPAR03, cMVPAR04, cMVPAR05, cMVPAR06 } )
			nSomaSer := Soma1(nSomaSer)	
			ETQ->(dbSkip())
			lUnico := .T.
			Loop
			
		ElseIf ETQ->G1_XXQTET1 > 0 .And. ETQ->G1_XXQTET2 <= 0
		
			// Monta somente o LADO A
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "RDT"
	      cMVPAR03 := "FAN: "+AllTrim(SB1->B1_XFANA)
	      cMVPAR04 := "L: A"
	      cMVPAR05 := "SN:"+nSomaSer
	      cMVPAR06 := "IL:"+cIL1+"dB"
         AADD(aEtqs,{ cMVPAR01, cMVPAR02, cMVPAR03, cMVPAR04, cMVPAR05, cMVPAR06 } )

		ElseIf ETQ->G1_XXQTET1 <= 0 .And. ETQ->G1_XXQTET2 > 0

			// Monta somente o LADO B
	      cMVPAR01 := SB1->B1_DESC
	      cMVPAR02 := "RDT"
	      cMVPAR03 := "FAN: "+AllTrim(SB1->B1_XFANB)
	      cMVPAR04 := "L: B"
	      cMVPAR05 := "SN:"+nSomaSer
	      cMVPAR06 := "IL:"+cIL2+"dB"
         AADD(aEtqs,{ cMVPAR01, cMVPAR02, cMVPAR03, cMVPAR04, cMVPAR05, cMVPAR06 } )	      

		EndIf

      ETQ->(dbSkip()) 

	EndDo

	If !lUnico
		nSomaSer := Soma1(nSomaSer)
	EndIf		
	
Next x   

//�����������������������������������������������x�[�
//�Impress�o das etiquetas									 �
//�����������������������������������������������x�[�
nCol := 0
For nQ := 1 To Len( aEtqs )
	
	nCol := nCol + 1
	If nCol == 1
	   cL71 := aEtqs[nQ,1]+";"+aEtqs[nQ,2]+";"+aEtqs[nQ,3]+";"+aEtqs[nQ,4]+";"+aEtqs[nQ,5]+";"+aEtqs[nQ,6]+";"
	ElseIf nCol == 2 	
	   cL71 += aEtqs[nQ,1]+";"+aEtqs[nQ,2]+";"+aEtqs[nQ,3]+";"+aEtqs[nQ,4]+";"+aEtqs[nQ,5]+";"+aEtqs[nQ,6]+";"
	ElseIf nCol == 3 	
	   cL71 += aEtqs[nQ,1]+";"+aEtqs[nQ,2]+";"+aEtqs[nQ,3]+";"+aEtqs[nQ,4]+";"+aEtqs[nQ,5]+";"+aEtqs[nQ,6]+";"
		//�����������������������������������������������x�[�
		//�Par�metros de impress�o do Crystal Reports		 �
		//�����������������������������������������������x�[�
	    cOptions := "2;0;1;LAYOUT071"			// Parametro 1 (2= Impressora 1=Visualiza)
	   	
		//�����������������������������������������������x�[�
		//�Executa Crystal Reports para impress�o			 	 �
		//����������������Michel	�������������������������������x�[�
		CALLCRYS('LAYOUT071', cL71 ,cOptions)
		Sleep(1500)
	   nCol := 0
	EndIf

Next nQ

//�����������������������������������������������x�[�
//�Impress�o das �ltima coluna de etiqueta   		 �
//�����������������������������������������������x�[�
lResto := .F.
If nCol == 1
   cL71 += "FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"
   cL71 += "FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"
   lResto := .T.
ElseIf nCol == 2 	
   cL71 += "FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"+"FINAL"+";"
   lResto := .T.
EndIf

If lResto

	//�����������������������������������������������x�[�
	//�Par�metros de impress�o do Crystal Reports		 �
	//�����������������������������������������������x�[�
    cOptions := "2;0;1;LAYOUT071"			// Parametro 1 (2= Impressora 1=Visualiza)
   	
	//�����������������������������������������������x�[�
	//�Executa Crystal Reports para impress�o			 	 �
	//�����������������������������������������������x�[�
	CALLCRYS('LAYOUT071', cL71 ,cOptions)
   nCol := 0

EndIf

ETQ->(dbCloseArea())

Return ( .T. )
