/*
// P.E. utilizado para adicionar itens no Menu da mBrowse
If EasyEntryPoint("IPO400MNU")
	aRotAdic := ExecBlock("IPO400MNU",.f.,.f.)
	If ValType(aRotAdic) == "A"
		AEval(aRotAdic,{|x| AAdd(aRotina,x)})
	EndIf
EndIf

exemplo:
AAdd( aRotina, { 'Teste', "U_XTESTE", 0, 4 } )
*/

#INCLUDE "TOPCONN.CH"

User Function IPO400MNU()

RegToMemory('SW2',.F.)

AAdd( aRotina, { 'Teste', "U_XTESTE", 0, 4 } )
RETURN

USER FUNCTION XTESTE
MSGALERT('M->'+M->W2_PO_NUM)
MSGALERT(''+SW2->W2_PONUM)

RETURN
