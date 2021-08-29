#include "rwmake.ch"

User Function fWhenCpo()

Local aAreaGER := GetArea()
Local aAreaSX3 := SX3->( GetArea() )
Local _Retorno := .T.
Local cPastaUsr:= ""
Local cCampo:= ""
Local cNCampo:= ""
Local cPastaSx3:= ""

/*
Local _Retorno
Local _cPastas := ""
Local _cCampos := ""
Public cCpoSB1

If Empty(cCpoSB1)
   cCpoSB1 := ""
   
	P08->(DbSetOrder(1))
	IF P08->(dbSeek(xFilial()+__cUserId))
	   //Alert("entrou no seek do P08")
		While !P08->( EOF() ) .and. Alltrim(__cUserId) == P08->P08_CODUSR
		   //Alert("Entrou no while do p08")
			_cPastas += P08->P08_PASTA+","
			P08->( dbSkip() )
		End
	EndIf
	
	Alert("Variavel pastas: " + _cPastas)
	
	SX3->( dbSetOrder(1) )
	SX3->(dbSeek("SB1"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SB1"
		If Alltrim(SX3->X3_FOLDER) $ _cPastas
		    cCpoSB1 += Alltrim(SX3->X3_CAMPO) + ","
		EndIf
		SX3->( dbSkip() )
	End
	
	Alert("Variavel campos: " + cCpoSB1)
EndIf

cCampo    := Subs(ReadVar(),4)

If cCampo $ cCpoSB1
	_Retorno := .T.
Else
	_Retorno := .F.
EndIf

Return _Retorno
  */


IF inclui
	dbSelectArea("P08")
	P08->(DbSetOrder(1))
	IF P08->(!dbSeek(xFilial("P08")+alltrim(__cUserId)))
		_Retorno := .F.
	Endif
Else
	dbSelectArea("P08")
	P08->(DbSetOrder(1))//P08_FILIAL, P08_CODUSR
	//IF P08->(dbSeek(xFilial("P08")+alltrim(__cUserId)))
	//	while P08->(!eof()) .AND. P08->P08_CODUSR == alltrim(__cUserId)
	//		cPastaUsr+= P08->P08_PASTA+"|"
	//		P08->(dbSkip())
	//	End
	//Endif
	
	cCampo    := ReadVar()
	cNCampo   := substring(cCampo, 4, len(cCampo))
	cPastaSx3 := GetSx3Cache(cNCampo,"X3_FOLDER")
	
	
	IF P08->(dbSeek(xFilial("P08")+alltrim(__cUserId) + cPastaSx3))
		//If cPastaSx3  $ cPastaUsr
		_Retorno:= .T.
	Else
		_Retorno:= .F.
	Endif
Endif
//Endif

RestArea(aAreaSX3)
RestArea(aAreaGER)

Return _Retorno
