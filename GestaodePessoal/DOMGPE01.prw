User Function DOMGPE01

Local _cVldAlt := ".T."         
Private _cString := "ZRA"

dbSelectArea("ZRA")
dbSetOrder(1)

AxCadastro(_cString,"Cadastro Setores Ponto Elertônico",/*"ExcDiv()"*/,_cVldAlt)

Return