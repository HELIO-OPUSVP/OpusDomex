User Function DOMGPE01

Local _cVldAlt := ".T."         
Private _cString := "ZRA"

dbSelectArea("ZRA")
dbSetOrder(1)

AxCadastro(_cString,"Cadastro Setores Ponto Elert�nico",/*"ExcDiv()"*/,_cVldAlt)

Return