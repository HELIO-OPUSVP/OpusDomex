#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#include "Totvs.ch"
#INCLUDE "TOPCONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAS002    ºAutor  ³Microsiga           º Data ³  11/24/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MAS002()

Local lRet        	:= .T.
Local cArquivo  	:= ""
Local cLine			:= ""
Local cCadastro	  	:= OemToAnsi("Atualiza tabela CDC com Guias Geradas")
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

Aadd(aSays,OemToAnsi("Atualiza CDC com Guias" ) )
Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )
FormBatch( cCadastro , aSays , aButtons )
	
IF nOpca == 0
	Return(.T.)
EndIF


Processa( {|lEnd| MAS0002() } , "Lendo Tabela de Guias...")

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

Static Function MAS0002()

local cQry	   	:= ""

cQry := " SELECT * FROM " + RETSQLNAME("SF6")
cQry += "  WHERE F6_DTARREC >= '20170901'  AND F6_DOC <> '' AND D_E_L_E_T_ =''   "
TcQuery cQry NEW Alias "TMP"

DbSelectArea("TMP")
DbGoTop()
Do While !eof()

	dbSelectArea("CDC")
	dbSetOrder(2)     // Filial + Guia + UF
	if !DbSeek(xfilial("CDC")+TMP->F6_NUMERO+TMP->F6_EST)
		RecLock("CDC",.T.)
			CDC->CDC_FILIAL		:= XFILIAL("CDC")     
			CDC->CDC_TPMOV		:= "S"   
			CDC->CDC_DOC		:= TMP->F6_DOC
			CDC->CDC_SERIE		:= TMP->F6_SERIE
			CDC->CDC_CLIFOR		:= TMP->F6_CLIFOR
			CDC->CDC_LOJA		:= TMP->F6_LOJA
			CDC->CDC_GUIA		:= TMP->F6_NUMERO
			CDC->CDC_UF			:= TMP->F6_EST
			CDC->CDC_IFCOMP		:= "000001"
			CDC->CDC_DCCOMP		:= "m"	
			CDC->CDC_SDOC		:= "001"																			
		MsUnLock()
	endif
		 
	DbSelectArea("TMP")
	DBSKIP()
Enddo
MsgInfo("FIM")

Return .T.
