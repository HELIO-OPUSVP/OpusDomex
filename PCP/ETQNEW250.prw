#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ETQNEW250 บAutor ณMichel Sander       บ Data ณ  05.07.16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para apontamento automแtico de OP na impressao      บฑฑ
ฑฑบ          ณ das etiquetas de embalagens de PA (MATA250 V12.1.7)        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DOMETQDL3.prw                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function ETQNEW250(__TM, __OP, __PRODUTO, __LOCAL, __NQTDE, __CTOTPARC)

   LOCAL lOP := .T.
   _aETQ := {}
	Aadd(_aETQ,{"D3_OP     " , __OP					   		     , NIL })
	Aadd(_aETQ,{"D3_TM     " , __TM	                          , NIL })
	Aadd(_aETQ,{"D3_LOCAL  " , __LOCAL        		           , NIL })
	Aadd(_aETQ,{"D3_COD    " , __PRODUTO		                 , NIL })
	Aadd(_aETQ,{"D3_QUANT  " , __NQTDE	                       , NIL })
	//Aadd(_aETQ,{"D3_PARCTOT" , __CTOTPARC                      , NIL })
	
	Private lMsHelpAuto    := .T.
	Private lMsErroAuto    := .F.
	// Programa ETQNEW250 FORA DE USO retirado por HษLIO em 13/11/17
	//MSExecAuto({|x,y| U_NewMt250(x,y)},_aETQ,3)     // MATA250 da versใo 12.1.7 convertido para teste
   
	If Type("_lColetor") == "U"
		If lMsErroAuto
		   MostraErro()
		   lOP := .F.
		EndIf
	Else
		If !_lColetor
			If lMsErroAuto
			   MostraErro()
			   lOP := .F.
			EndIf
		Else
			If lMsErroAuto
/*				Mostraerro("\Export","MATA250.log")
				cMenErro := MEMOREAD("\Export\"+"MATA250.log")
				cTxtMsg  := " Erro no Apontamento de DIO via coletor." + Chr(13)
				cTxtMsg  += cMenErro + Chr(13)
				cAssunto := "Erro Apontamento de OP de DIO via coletor"
				cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
				cPara    := 'michel@sanderconsulting.com.br'
				cCC      := ""
				cArquivo := Nil
				U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
*/				
			   lOP := .F.
			EndIf
		Endif
	EndIf
		
Return ( lOP )