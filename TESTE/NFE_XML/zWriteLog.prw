#include 'protheus.ch'
#include 'parmtype.ch'
#include 'Totvs.ch'

user function zWritLog(cLog)
	
	Default cLog := "Log Empty"
	
	FwLogMsg("INFO",;
	 		 /*cTransactionId*/,;
	 		 "BAIXA_XML",;
	 		 FunName(),;
	 		 "",;
	 		 "BAIXA_XML",;
	 		 cLog,;
	 		 0,;
	 		 0,;
	 		 {})
return