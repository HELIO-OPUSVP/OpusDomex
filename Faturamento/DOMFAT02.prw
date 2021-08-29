//--------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson Santana - 21/11/2012                                                                                                               //
//--------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                            //
//--------------------------------------------------------------------------------------------------------------------------------------------//
#Include "topconn.ch"
#Include "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "colors.ch"

User Function DOMFAT02()   
Local _aArea    := GetArea()
Private _cCodigo:= Space(06)
Private _cTRB   := GetNextAlias()
Private _cSQL   := GetNextAlias()
//Private _cRegiao:= M->A1_XXREGIA
Private _cRegiao:= SA1->A1_XXREGIA

SZ9->(dbSetOrder(1))
If! SZ9->(dbSeek(xFilial("SZ9")+SA1->A1_XXREGIA))
    If fGeraTRB() > 0
       aCampos:={}
       aadd(aCampos , {"OK"		    ,""} )
       aadd(aCampos , {"Z9_DESC"     ,"Região"} )
       aadd(aCampos , {"Z9_EST"      ,"UF"} )
       aadd(aCampos , {"Z9_NOME"     ,"Transportadora"} )
       aadd(aCampos , {"Z9_TRANSP"   ,"Código"})
	
       cTit:= "Transportadoras para "+SA1->A1_EST
	
       @ 000,013 To 420,850 Dialog oMov Title cTit
       @ 002,002 To 180,415 Browse _cTRB Fields aCampos Mark "OK" Object oBrw
       @ 188,300 BmpButton Type 1 Action fOkProc()
       @ 188,340 BmpButton Type 2 Action Close(oMov)
	
       Activate Dialog oMov Centered

       If Select(_cSQL) > 0
	       (_cSQL)->(dbCloseArea())
       EndIf
       If Select(_cTRB) > 0
	       (_cTRB)->(dbCloseArea())
       EndIf
    EndIf   
ElseIf SZ9->(dbSeek(xFilial("SZ9")+SA1->A1_XXREGIA))
    _cCodigo:=SZ9->Z9_TRANSP                        
Else
    _cCodigo:=SA1->A1_TRANSP
EndIf   
RestArea(_aArea)
Return(_cCodigo)                            

//-------------------

Static Function fOkProc()
Local _nCont:=0
dbSelectArea(_cTRB)
dbGotop()
Do While.Not.Eof()
	If Marked("OK") 
	   _cCodigo:=(_cTRB)->Z9_TRANSP
	   _nCont++
	EndIf
	dbSkip()
EndDo         
If _nCont <> 1
   MsgInfo("Selecione uma transportadora.","A T E N Ç Ã O")
   dbSelectArea(_cTRB)
   dbGotop()
Else
   Close(oMov)
EndIf
Return           

//---------------------

Static Function fGeraTRB()

cQuery:="Select Z9_DESC,Z9_EST,Z9_NOME,Z9_TRANSP"+Chr(13)
cQuery+="From "+RetSqlName("SZ9")+Chr(13)
cQuery+="Where D_E_L_E_T_ <> '*' "+Chr(13)
cQuery+="And Z9_EST = '"+SA1->A1_EST+"' "+Chr(13)
cQuery+="Order By Z9_DESC"

TCQuery cQuery ALIAS &_cSQL NEW

cArqTRB:= CriaTrab(NIL,.F.)
aCampos  := {}

aadd(aCampos , {"OK"		      ,"C",002,0} )
aadd(aCampos , {"Z9_DESC"     ,"C",030,0} )
aadd(aCampos , {"Z9_EST"      ,"C",002,0} )
aadd(aCampos , {"Z9_NOME"     ,"C",015,0} )
aadd(aCampos , {"Z9_TRANSP"   ,"C",006,0})

DbCreate(cArqTRB,aCampos)
dbUseArea(.T.,, cArqTRB, _cTRB,)
Index On Z9_DESC TO &cArqTRB

dbSelectArea(_cSQL)
dbGotop()
ProcRegua(RecCount())
Do While.Not.Eof()
	dbSelectArea(_cTRB)
	Reclock(_cTRB,.T.)
	Replace (_cTRB)->Z9_DESC   With (_cSQL)->Z9_DESC
	Replace (_cTRB)->Z9_EST    With (_cSQL)->Z9_EST
	Replace (_cTRB)->Z9_NOME   With (_cSQL)->Z9_NOME
	Replace (_cTRB)->Z9_TRANSP With (_cSQL)->Z9_TRANSP
	MsUnlock()
	dbSelectArea(_cSQL)
	dbSkip()
EndDo              
dbSelectArea(_cTRB)
dbGotop()
Return(RecCount())