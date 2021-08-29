#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVD3_COD   บAutor  ณHelio Ferreira      บ Data ณ  27/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VD3_COD()
Local _Retorno := .T.

If FunName() <> 'MATA261'
	If !Empty(M->D3_COD)
		If !Empty(SD3->D3_TM)
			If SD3->D3_TM == '011'
				SG1->( dbSetOrder(1) )
				lSilk := .F.
				If SG1->( dbSeek( xFilial() + SD3->D3_COD ) )
					While !SG1->( EOF() ) .and. SG1->G1_COD == SD3->D3_COD
						If Subs(SG1->G1_COMP,1,6) == '500960'
							lSilk := .T.
							Exit
						EndIf
						SG1->( dbSkip() )
					End
				EndIf
				If !lSilk
					MsgStop("Nใo ้ permitido utliizar a TM 011 para produtos que nใo sejam Silk.")
					_Retorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return _Retorno
