#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Include 'TopConn.ch'

user function MA410MNU()

	aAdd(aRotina,{"Impressao de OF" ,"U_DOMIMPOF()"           , 0 , 0, 0 , NIL}) 
	aadd(aRotina,{"Paletizacao" ,"U_DOMCUB01(SC5->C5_NUM)", 0 , 3, 0 , Nil})   
	
	aadd(aRotina,{"Etiqueta SGP" ,"U_EtiSGP01(SC5->C5_NUM)", 0 , 3, 0 , Nil})

return
