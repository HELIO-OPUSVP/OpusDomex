#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ70 �Autor  � Michel A. Sander   � Data �  30/10/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta Modelo 70 Serial com Datamatrix para o CORTE      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ70(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

Local mv_par02   := 1         //Qtd Embalagem
Local mv_par03   := 1         //Qtd Etiquetas

Private lAchou     := .T.

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNumSerie := 0
Default cNumPeca  := ""

mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If !Empty(cNumOP)

	//Localiza SC2
	SC2->(DbSetOrder(1))
	If lAchou .And. SC2->(!DbSeek(xFilial("SC2")+cNumOP))
		Alert("Numero O.P. "+AllTrim(cNumOP)+" n�o localizada!")
		lAchou := .F.
	EndIf

EndIf

//Localiza SB1
SB1->(DbSetOrder(1))
If lAchou .And. SB1->(!DbSeek(xFilial("SB1")+SC2->C2_PRODUTO))
	Alert("Produto "+AllTrim(SC2->C2_PRODUTO)+" n�o localizado!")
	lAchou := .F.
EndIf

//Localiza SA1
SA1->(DbSetOrder(1))
If lAchou .And. SA1->(!DbSeek(xFilial("SA1")+SC2->C2_CLIENT))
	Alert("Cliente "+SC2->C2_CLIENT+"n�o localizado!")
	lAchou := .F.
EndIf

If lAchou .And. ( nQtdEtq > SC2->C2_QUANT )
	MsgAlert("Quantidade digitada = "+AllTrim(TransForm(nQtdEtq,"@E 999,999,999.99"))+" � maior que quantidade da OP = "+AllTrim(TransForm(SC2->C2_QUANT,"@E 999,999,999.99")))
	lAchou := .F.
EndIf

//Caso algum registro n�o seja localizado, sair da rotina
If !lAchou
	Return(.T.)
EndIf

//�����������������������������������������������x�[�
//�Prepara n�mero de s�rie									 �
//�����������������������������������������������x�[�
cSerieFim := If( cNumSerie == 1, 1, cNumSerie )
If SC2->C2_QUANT <= 9
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,1) // "1"
ELseIf ((SC2->C2_QUANT)>= 10 .AND. (SC2->C2_QUANT) <= 99)
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,2) // "1"
ElseIf ((SC2->C2_QUANT)>= 100 .AND. (SC2->C2_QUANT)<= 999)
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,3) // "01"
ElseIf ((SC2->C2_QUANT)>= 1000 .AND. (SC2->C2_QUANT)<= 9999)
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,5) // "001"
ElseIf ((SC2->C2_QUANT)>= 10000 .AND. (SC2->C2_QUANT)<= 99999)
	cNumSerie := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+StrZero(cSerieFim,6) // "0001"
EndIf

//�����������������������������������������������x�[�
//�Par�metros de impress�o do Crystal Reports		 �
//�����������������������������������������������x�[�
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
		   cParam += AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie3+";"+cNumSerie1+";"+cNumSerie2+";"+cNumSerie3

			//�����������������������������������������������x�[�
			//�Executa Crystal Reports para impress�o			 	 �
			//�����������������������������������������������x�[�
			CALLCRYS('SerialCorte', cParam ,cOptions)
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
   cParam += "FINAL"+";"+SPACE(12)+";"+cNumSerie1+";"+"FINAL"+";"+"FINAL"+";"
                                                                                                            
	CALLCRYS('SerialCorte', cParam ,cOptions)
	Sleep(100)

ElseIf x == 2

	//�����������������������������������������������x�[�
	//�Parametro de impress�o								 	 �
	//�����������������������������������������������x�[�
   cParam := AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie1+";"
   cParam += AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,01,03)+";"+cNumSerie2+";"
   cParam += "FINAL"+";"+SPACE(12)+";"+cNumSerie1+";"+cNumSerie2+";"+"FINAL"+";"
	
	//�����������������������������������������������x�[�
	//�Executa Crystal Reports para impress�o			 	 �
	//�����������������������������������������������x�[�
	CALLCRYS('SerialCorte', cParam ,cOptions)
	Sleep(100)

EndIf

Return(.T.)