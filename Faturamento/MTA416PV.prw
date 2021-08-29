#INCLUDE "RWMAKE.CH"


/*/{Protheus.doc} MTA416PV
// Grava campos complementares na aprovação do Orçamento
@author Helio Ferreira
@since 14/09/2016
@version undefined
@example
(examples)
@see (links_or_references)
/*/


User Function MTA416PV()

Local aAreaSCJ := SCJ->(GetArea())
Local aAreaSCK := SCK->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aArea := GetArea()

M->C5_XXCTATO  := SCJ->CJ_CODCONT
M->C5_CONTATO  := SCJ->CJ_CONTATO
M->C5_EMAIL    := SCJ->CJ_EMAIL
M->C5_DMXORC   := SCJ->CJ_NUM
M->C5_XPVTIPO  := "OF"      // Solicitado por Dayse em 11/12/2019

SCK->(dbsetorder(1))

For i:=1 to len(_aCols)
	If SCK->(dbSeek(xFilial()+_acols[i][ascan(_aHeader,{|x| Upper(alltrim(x[2])) == "C6_NUMORC"})]))
		_acols[i][ascan(_aHeader,{|x| Alltrim(x[2]) == "C6_IPI"})]    := SCK->CK_IPI
		_acols[i][ascan(_aHeader,{|x| Alltrim(x[2]) == "C6_XOPER"})]  := SCK->CK_XOPER
		_acols[i][ascan(_aHeader,{|x| Alltrim(x[2]) == "C6_SEUCOD"})] := SCK->CK_SEUCOD	
	Endif
Next

RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaSCJ)
RestArea(aAreaSCK)
RestArea(aArea)

Return Nil
