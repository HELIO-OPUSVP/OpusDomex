#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DOMETQ09 �Autor  � Michel A. Sander   � Data �  02.04.2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Etiqueta Modelo 07 - Cabos Trunk (n�o grava XD1)           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMETQ09(cNumOP,cNumSenf,nQtdEmb,nQtdEtq,cNivel,aFilhas,lImpressao,nPesoVol,lColetor,cNumSerie,cNumPeca)

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

Private cCdAnat1   := ""        //Codigo Anatel 1
Private cCdAnat2   := ""        //Codigo Anatel 2
Private lAchou     := .T.
Private aGrpAnat   := {}     //Codigos Anatel Agrupados
Private _cSerieIni := ""

Default cNumOP   := ""
Default cNumSenf := ""
Default nQtdEmb  := 0
Default nQtdEtq  := 0
Default cNumSerie := ""
Default cNumPeca  := ""
Default _MV_PAR07 := 1

//����������������������������������������������������������������Ŀ
//�Busca quantidades para impress�o											 �
//����������������������������������������������������������������Ŀ
mv_par02:= nQtdEmb   //Qtd Embalagem
mv_par03:= nQtdEtq   //Qtd Etiquetas

If ValType("MV_PAR07") == NIL
   _MV_PAR07 := 1
ElseIf ValType("MV_PAR07") == 'C'
   _MV_PAR07 := Soma1(MV_PAR07)
ElseIf ValType("MV_PAR07") == 'N'
   _MV_PAR07 := MV_PAR07
   If _MV_PAR07 == 0 
      _MV_PAR07++
   EndIf   
EndIf

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
	_cSerieIni:=""
	If _MV_PAR07 > 1
	   _MV_PAR07 += 1
	EndIf

	Do Case
			Case SC2->C2_QUANT <=9
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(_mv_par07,1)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10 .And.  SC2->C2_QUANT <= 99
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(_mv_par07,2)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=100 .And. SC2->C2_QUANT <= 999
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(_mv_par07,3)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=1000 .And. SC2->C2_QUANT <= 9999
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(_mv_par07,4)	// MV_PAR07 Sequencial Serial
			Case  SC2->C2_QUANT >=10000 .And. SC2->C2_QUANT <= 99999
				_cSerieIni:=AllTrim(SC2->C2_NUM)+SUBSTR(SC2->C2_ITEM,01,02)+SUBSTR(SC2->C2_SEQUEN,03,03)+STRZERO(_mv_par07,5)	// MV_PAR07 Sequencial Serial
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

//Se impressora n�o identificada, sair da rotina
If !lPrinOK
	Alert("Erro de configura��o!")
	Return(.T.)
EndIf

//����������������������������������������������������������������Ŀ
//�Consiste a quantidade de conectores na estrutura					 �
//����������������������������������������������������������������Ŀ
nEtq := 0
cSQL := "SELECT B1_GRUPO, B1_DESC, G1_COD, G1_COMP, G1_XXLADO, G1_QUANT FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COMP = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "B1_GRUPO = 'CON' ORDER BY G1_XXLADO"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"ETQ",.F.,.T.)

If ETQ->(Eof())

   Aviso("Aten��o","N�o existe conectores na estrutura dessa OP. Verifique se os componentes do tipo conectores est�o no grupo CON.",{"Ok"})
	cTxtMsg  := " N�o existe conectores na estrutura dessa OP. Verifique se os componentes do tipo conectores est�o no grupo CON." + Chr(13)
	cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
	cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 011 - Conector"
	cPara    := 'denis.vieira@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;fabiana.santos@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
 	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
   ETQ->(dbCloseArea())
   Return

EndIf   

//����������������������������������������������������������������Ŀ
//�Consiste a quantidade de fibra na estrutura							 �
//����������������������������������������������������������������Ŀ
cSQL := "SELECT COUNT(B1_COD) QTDEFIBRA FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COMP = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "B1_GRUPO = 'FO'"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"FIB",.F.,.T.)
If FIB->QTDEFIBRA <> 1
   Aviso("Aten��o","A estrutura usada n�o possui quantidade de fibra padr�o para impress�o de etiquetas, ou possui mais de uma fibra na estrutura.",{"Ok"})
	cTxtMsg  := " A estrutura usada n�o possui quantidade de fibra padr�o para impress�o de etiquetas, ou possui mais de uma fibra na estrutura." + Chr(13)
	cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
	cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 011 - Conector"
	cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
   FIB->(dbCloseArea())      
   ETQ->(dbCloseArea())
   Return
Else
	FIB->(dbCloseArea())
EndIf

//����������������������������������������������������������������Ŀ
//�Consiste os lados do componente do tipo conector					 �
//����������������������������������������������������������������Ŀ
cSQL := "SELECT G1_COD, G1_COMP, G1_XXLADO FROM "+RetSqlName("SG1")+" JOIN "+RetSqlName("SB1")+" ON "
cSQL += "G1_FILIAL = B1_FILIAL AND G1_COMP = B1_COD WHERE "
cSQL += RetSqlName("SB1")+".D_E_L_E_T_ = '' AND "
cSQL += RetSqlName("SG1")+".D_E_L_E_T_ = '' AND "
cSQL += "G1_COD = '"+SC2->C2_PRODUTO+"' AND "
cSQL += "B1_GRUPO = 'CON' ORDER BY G1_COMP"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),"LAD",.F.,.T.)
nTpLadoA := 0 
nTpLadoB := 0   
nTpLadoU := 0

Do While LAD->(!Eof())
   If LAD->G1_XXLADO == "A"
      nTpLadoA += 1
   ElseIf LAD->G1_XXLADO == "B"
      nTpLadoB += 1
   ElseIf LAD->G1_XXLADO == "U"
      nTpLadoU += 1
   ElseIf Empty(LAD->G1_XXLADO)
	   Aviso("Aten��o","Um Componente da estrutura est� sem o lado definido. Altere a estrutura e tente novamente.",{"Ok"})
		cTxtMsg  := " Um Componente da estrutura est� sem o lado definido. Altere a estrutura e tente novamente." + Chr(13)
		cTxtMsg  += " Estrutura  = " + LAD->G1_COD  + Chr(13)
		cTxtMsg  += " Componente = " + LAD->G1_COMP + Chr(13)
		cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
		cAssunto := "Etiqueta Layout 011 - Conector"
		cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
		cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
		cArquivo := Nil
		U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
		LAD->(dbCloseArea())
		ETQ->(dbCloseArea())
	   Return
   EndIf
	LAD->(dbSkip())
Enddo
LAD->(dbCloseArea())

//����������������������������������������������������������������Ŀ
//�Verifica duplicidade de lados de conectores na estrutura			 �
//����������������������������������������������������������������Ŀ
If ( (nTpLadoA-nTpLadob) <> 0 ) .Or. ( nTpLadoU > 1 )

   Aviso("Aten��o","Conectores da estrutura est�o com lados inconsistentes. Altere a estrutura e tente novamente.",{"Ok"})
	cTxtMsg  := " Conectores da estrutura estao com lados inconsistentes. Altere a estrutura e tente novamente." + Chr(13)
	cTxtMsg  += " Produto = " + SC2->C2_PRODUTO + Chr(13)
	cTxtMsg  += " Cliente = " + SC2->C2_CLIENT  + Chr(13)
	cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
	cAssunto := "Etiqueta Layout 011 - Conector"
	cPara    := 'denis.vieira@rdt.com.br;fabiana.santos@rdt.com.br;tatiane.alves@rosenbergerdomex.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br'
	cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	cArquivo := Nil
	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	ETQ->(dbCloseArea())
   Return

EndIf

//����������������������������������������������������������������Ŀ
//�Variaveis de sequencia de via e serie									 �
//����������������������������������������������������������������Ŀ
_cSerieIni := Val(_cSerieIni)
_cSerieIni -= 1

Do While ETQ->(!Eof())

   For x := 1 to ( ETQ->G1_QUANT * nQtdEtq )
   
	    //Chamando fun��o da impressora ZEBRA
	  	 MSCBPRINTER(cModelo,cPorta,,,.F.)
	    MSCBChkStatus(.F.)
		 MSCBLOADGRF("RDT2.GRF")
		 MSCBLOADGRF("ANATEL2.GRF")

		 //Inicia impress�o da etiqueta
		 MSCBBEGIN(1,5)
		 lImprime := .T.
		 nCol := 05
		 nIni := 07
		 nLin := 04
		
	 	 MSCBGRAFIC(10,10,"RDT2")
		 MSCBSAY(020,035   ,"DESCRICAO" 					 ,cRotacao,"0","30,30")
		 MSCBSAY(030,035   ,"LADO :" + ETQ->G1_XXLADO ,cRotacao,"0","24,24")
		 MSCBSAY(040,035   ,"PN:" + ETQ->G1_COMP		 ,cRotacao,"0","25,25")
		 MSCBSAY(050,035   ,"PN:" + ETQ->G1_COMP		 ,cRotacao,"0","25,25")		 
	  	 MSCBInfoEti("DOMEX","80X60")

		 //Finaliza impress�o da etiqueta
		 MSCBEND()
		 Sleep(500)
		 MSCBCLOSEPRINTER()

	Next
	
   ETQ->(dbSkip())
   
EndDo

ETQ->(dbCloseArea())

Return ( .T. )
