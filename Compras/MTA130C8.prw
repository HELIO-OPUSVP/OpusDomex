#include "rwmake.ch"
#include "protheus.ch"


/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?MTA130C8  ?Autor  ?Marco Aurelio-OPUS  ? Data ?  01/17/17   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? PE no final da Gravacao da Cotacao  - Grava SC1 no SC8     ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
mauresi

*/


User Function MTA130C8()

dbSelectArea("SC8")
	
	RecLock("SC8",.F.)
		SC8->C8_PRAZO  := ( SC8->C8_DATPRF - DDATABASE ) 
		SC8->C8_XXOBSC := SC1->C1_OBS
	MsUnlock()
	
Return
