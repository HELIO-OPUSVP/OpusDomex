#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA100BUT  ºAutor  ³Helio Ferreira      º Data ³  26/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA103BUT()

Local aRetorno   := {}

AADD(aRetorno, { 'SDUPROP' ,{ || UINFADIC() }, "Iformaçõe adicionais" , "Iformaçõe adicionais" } )
if SF1->F1_XBLQXML == "S"
    AADD(aRetorno, { 'SDUPROP' ,{ || U_U103LibEtq() }, "Libera Etiqueta" , "Libera Etiqueta" } )
Endif
SetKey( VK_F8 ,{ || UINFADIC() } )

Return aRetorno


Static Function UINFADIC()
Local cInfAdic := SF1->F1_XXINFAD

DEFINE MSDIALOG oDlg01 TITLE OemToAnsi("Informações adicionais do Documento de Entrada ") FROM 0,0 TO 400,600 PIXEL of oMainWnd PIXEL

oFont := TFont():New( 'Courier New', -13,  -13 ,,,,,,,)
oInfAdic       := TMultiGet():New( 005    ,005     ,{|u|if(Pcount()>0,cInfAdic:=u,cInfAdic)},oDlg01,292,175,oFont,.F., NIL, NIL, NIL,.T., NIL,.F.,{||.F.}  , .F.,.F., NIL, NIL,{||}, .F., NIL, NIL)

@ 184 , 266 BUTTON "Fechar" ACTION Processa( {|| oDlg01:End() } ) SIZE 30,12 PIXEL OF oDlg01

ACTIVATE MSDIALOG oDlg01 CENTER 

Return


 /*/{Protheus.doc} F1BLQXMLescription)
    @type  Function
    @author user
    @since 07/07/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function F1BLQXML

    MsgInfo("Liberação de Etiqueta - em DESENVOLVIMENTO!")
    
Return return_var
