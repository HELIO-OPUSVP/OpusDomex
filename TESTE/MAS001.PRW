#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "Totvs.ch"
#INCLUDE "TOPCONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAS001    ºAutor  ³Microsiga           º Data ³  11/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MAS001()

Local lRet        	:= .T.
Local cArquivo  	:= ""
Local cLine			:= ""
Local cCadastro	  	:= OemToAnsi("Ista rotina adiciona o Componente 50007222221080 nas Estruturas")
Local nHandle   	:= 0
Local nOpca			:= 0
Local aSize    	 	:= MsAdvSize(,.F.,585)
Local aButtons		:= {}   
Local aSays			:= {}

Local aHeader		:= {}
Local aTitulo 		:= {}
Local oDlg
Local oPanel
Local oRegs        

Aadd(aSays,OemToAnsi( "Esta rotina adiciona o Componente 50007222221080 nas Estruturas" ) )
Aadd(aSays,OemToAnsi( "dos produtos" ) )
Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )
FormBatch( cCadastro , aSays , aButtons )
	
IF nOpca == 0
	Return(.T.)
EndIF


Processa( {|lEnd| MAS0001() } , "Lendo Arquivo...")

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpZZ5    ³ Autor:  Osmar Schimitberger  Data ³30/10/2010  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importa dados Produtos X Servicos                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MAS0001()

local cQry	   	:= ""

cQry := " SELECT DISTINCT B1_COD FROM  " + RETSQLNAME("SB1")
cQry += "  WHERE B1_TIPO = 'PA' AND B1_GRUPO = 'CORD' AND D_E_L_E_T_ =''   "
TcQuery cQry NEW Alias "TMP"

DbSelectArea("TMP")
DbGoTop()
Do While !eof()

	dbSelectArea("SG1")
	dbSetOrder(2)     // Filial + Componente + Produto	
	if !DbSeek(xfilial("SG1")+"50007222221080 "+TMP->B1_COD)
		RecLock("SG1",.T.)
		SG1->G1_FILIAL		:= XFILIAL("SG1")     
		SG1->G1_COD			:= TMP->B1_COD     
		SG1->G1_COMP		:= "50007222221080 "    
		SG1->G1_QUANT		:= 0
		SG1->G1_INI			:= ctod("24/11/2014")
		SG1->G1_FIM			:= ctod("31/07/2015")
		SG1->G1_NIV			:= "01"	
		SG1->G1_FIXVAR 	:= "V"
		SG1->G1_OBSERV 	:= "MAS"		
		MsUnLock()
	endif
		 
	DbSelectArea("TMP")
	DBSKIP()
Enddo
MsgInfo("FIM")

Return .T.
