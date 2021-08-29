#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'

User function DOMREGCAD
Local aRotAdic :={}
Local bPre := {||if (Inclui,fTela1(),.t.) }
//Local bOK  := {||MsgAlert('Chamada ao clicar em OK'), .T.}
//Local bTTS  := {||MsgAlert('Chamada durante transacao')}
Local bNoTTS  := {||fAltDesc()}
Local aButtons := {}
//aadd(aButtons,{ "PRODUTO", {|| MsgAlert("Teste")}, "Teste", "Botão Teste" }  ) //adiciona chamada no aRotina
//aadd(aRotAdic,{ "Adicional","U_Adic", 0 , 6 })

//AxCadastro("ZZQ","Regras de Bloqueio para cadastro de produtos", , , aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )
AxCadastro("ZZQ","Regras de Bloqueio para cadastro de produtos", , , aRotAdic, bPre, , ,bNoTTS , , , aButtons, , )

Return()

/*/Função: DOMBLQCAD
description Função de bloqueio 
@type function teste
 12.1.1
@author Ricardo Roda
@since 03/01/2021
/*/
Static Function fTela1()

Local cVar     := Nil
Local oDlgCad     := Nil
Local cTitulo  := "Família de produtos"
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" )
Local i := 0
Local x := 0

Private lChk     := .F.
Private oLbx := Nil
Private aVetor := {}
Private aItens:= {}
Private oSay
Private cfamilias:= ""
Private oFont1 := TFont():New("Arial",,023,,.F.,,,,,.F.,.F.)
Private oFont2 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)

FWMsgRun( , {|osay| fFamilia(oSay)},"Aguarde...","Processando")

For x :=1 to len(aItens)
	aAdd( aVetor, { lMark,aItens[x][1],aItens[x][2],""})
next

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
aItens:= {}

DEFINE MSDIALOG oDlgCad TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
" ", "Família","Descrição","" SIZE 230,095 OF oDlgCad PIXEL ON dblClick(fMarkFam())

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
aVetor[oLbx:nAt,2],;
aVetor[oLbx:nAt,3]}}

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlgCad:End() ENABLE OF oDlgCad
ACTIVATE MSDIALOG oDlgCad CENTER


For i:=1 to len(avetor)
	if avetor[i][1]
		aAdd(aItens,{aVetor[i][2]})
		fTela2(alltrim(aVetor[i][2]),alltrim(aVetor[i][3]))
		cfamilias += alltrim(aVetor[i][2])+","
	Endif
	
Next


M->ZZQ_BASE:= substring(alltrim(cfamilias),1,Len(cfamilias)-1)

Return()


/*/Função: fFamilia
description
@type function
@author Ricardo Roda
@since 03/01/2021
/*///------------------------------------------------
Static Function fFamilia(oSay)
//------------------------------------------------
dbSelectArea("SBP")
SBP->(dbSetOrder(1))
SBP->(DbGotop())
While SBP->(!eof())
	
	If lEnd
		MsgInfo(cCancel,"Fim")
		Exit
	Endif
	
	oSay:cCaption := ("Buscando Famílias: "+ ALLTRIM(SBP->BP_DESCR))
	ProcessMessages()
	
	Aadd(aItens,{ ALLTRIM(SBP->BP_BASE) , ALLTRIM(SBP->BP_DESCR)})
	SBP->(DbSkip())
End

Return ()

/*/Função: fTela2
description
@type function

@author Ricardo Roda
@since 03/01/2021
/*/
Static Function fTela2(cBase,cNomCar)

Local cVar     := Nil
Local oDlgCar     := Nil
Local cTitulo  := "Características:*"+alltrim(cNomCar)
Local lMark    := .F.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" )
Local oChk     := Nil
Local i:= 0
Local x:= 0

Private lChk2     := .F.
Private oLbx2 := Nil
Private aVetor2 := {}
Private aItens2:= {}
Private oSay2
Private cCaracts:= ""
Private aVetor2b:= {}

FWMsgRun( , {|osay2| fCaract(oSay2,cBase)},"Aguarde...","Processando")

For x :=1 to len(aItens2)
	aAdd( aVetor2, { lMark,aItens2[x][1],aItens2[x][2]})
next

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
aItens2:= {}

DEFINE MSDIALOG oDlgCar TITLE cTitulo FROM 0,0 TO 240,500 PIXEL

@ 10,10 LISTBOX oLbx2 VAR cVar FIELDS HEADER ;
" ", "ID","Característica","" SIZE 230,095 OF oDlgCar PIXEL ON dblClick(aVetor2[oLbx2:nAt,1] := !aVetor2[oLbx2:nAt,1],oLbx2:Refresh())

oLbx2:SetArray( aVetor2 )
oLbx2:bLine := {|| {Iif(aVetor2[oLbx2:nAt,1],oOk,oNo),;
aVetor2[oLbx2:nAt,2],;
aVetor2[oLbx2:nAt,3]}}

//+----------------------------------------------------------------
//| Para marcar e desmarcar todos existem duas opçoes, acompanhe...
//+----------------------------------------------------------------
//| Chamando uma funcao própria
//+----------------------------------------------------------------
If oChk <> NIL
	@ 110,10 CHECKBOX oChk VAR lChk2 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlgCar;
	ON CLICK(Iif(lChk2,Marca(lChk2),Marca(lChk2)))
Endif
//+----------------------------------------------------------------
//| Utilizando Eval()
//+----------------------------------------------------------------
@ 110,10 CHECKBOX oChk VAR lChk2 PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlgCar ;
ON CLICK(aEval(aVetor2,{|x| x[1]:=lChk2}),oLbx2:Refresh())

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlgCar:End() ENABLE OF oDlgCar
ACTIVATE MSDIALOG oDlgCar CENTER

aVetor2b:= {}
For i:=1 to len(aVetor2)
	if aVetor2[i][1]
		aAdd(aItens2,{aVetor2[i][2]})
		aAdd(aVetor2b,{aVetor2[i][1],aVetor2[i][2],aVetor2[i][3]})
		cCaracts += alltrim(aVetor2[i][2])+","
	Endif
Next

fTela3(cBase)
M->ZZQ_CARACT:= substring(alltrim(cCaracts),1,Len(cCaracts)-1)

Return(aItens2)

/*/Função: fCaract
description
@type function
@author Ricardo Roda
@since 03/01/2021
/*/

Static Function fCaract(oSay2, cBase)
dbSelectArea("SBQ")
SBQ->(dbSetOrder(2))
IF SBQ->(dbSeek(xFilial("SBQ")+cBase))
	While SBQ->(!eof()) .and. ALLTRIM(SBQ->BQ_BASE) == ALLTRIM(cBase)
		
		If lEnd
			MsgInfo(cCancel,"Fim")
			Exit
		Endif
		
		oSay2:cCaption := ("Buscando Características: "+ ALLTRIM(SBQ->BQ_CARACT))
		ProcessMessages()
		
		Aadd(aItens2,{ ALLTRIM(SBQ->BQ_ID) , ALLTRIM(SBQ->BQ_CARACT)})
		SBQ->(DbSkip())
	End
else
	MsgAlert("Características não encontradas","Aviso")
	Aadd(aItens2,{"",""})
Endif
Return ()
/*/Função: fTela3
description
@type function
@author Ricardo Roda
@since 03/01/2021
/*/
Static Function fTela3(cBase)
Local oButton2
Local oButton3
Local oButton4
Local oButton5
Local oButton6
Local oButton7
Local oButton8
Local oButton10
Local oButton11
Local oButton12                          

Local oSay1       
Local oSay2       
Private cGet2 := SPACE(200) 
Private oGet2

Private cGet1 := ""
Private cVar     := Nil
Private oDlgCar     := Nil
Private cTitulo  := "Opções - Família:*"+cBase
Private lMark    := .F.
Private oOk      := LoadBitmap( GetResources(), "CHECKED" )
Private oNo      := LoadBitmap( GetResources(), "UNCHECKED" )
Private oChk     := Nil
Private i:= 0
Private x:= 0

Private lChk3     := .F.
Private oLbx3 := Nil
Private aVetor3 := {}
Private aItens3:= {}
Private oSay3
Private cOpcoes:= "" 
Private oMultiGe1

FWMsgRun( , {|osay3| fOpcoes(oSay3,cBase,aVetor2b[1,2],aVetor2b[1,3])},"Aguarde...","Processando")

DEFINE MSDIALOG oDlgCar TITLE cTitulo FROM 0,0 TO 650,980 PIXEL
@ 10, 10 SAY 	 oSay1    PROMPT "CARACTERÍSTICAS" SIZE 150, 010 OF oDlgCar FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 25,10 LISTBOX oLbx2 VAR cVar FIELDS HEADER ;
" ", "ID","Característica","" SIZE 230,095 OF oDlgCar PIXEL ON dblClick(FWMsgRun( , {|osay3| fOpcoes(oSay3,cBase,aVetor2b[oLbx2:nAt,2],aVetor2b[oLbx2:nAt,3]),oLbx3:Refresh(),cGet1:= cGet1+"#["+ALLTRIM(aVetor2b[oLbx2:nAt,2])+"]", oMultiGe1:Refresh()  },"Aguarde...","Processando"))
oLbx2:SetArray( aVetor2b )
oLbx2:bLine := {|| {Iif(aVetor2b[oLbx2:nAt,1],oOk,oNo),;
aVetor2b[oLbx2:nAt,2],;
aVetor2b[oLbx2:nAt,3]}}

nlin:= 120
@ 005+nlin, 010 SAY 	 oSay1    PROMPT "REGRA" SIZE 044, 010 OF oDlgCar FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 020+nlin, 008 GET oMultiGe1 VAR cGet1 OF oDlgCar MULTILINE SIZE 408, 120 COLORS 0, 16777215  FONT oFont1 HSCROLL PIXEL
@ 035+nlin, 428 BUTTON oButton2 PROMPT ".AND."	SIZE 046, 012 OF oDlgCar action(cGet1:= cGet1+" .AND. ")  FONT oFont2 PIXEL
@ 050+nlin, 428 BUTTON oButton3 PROMPT ".OR." 	SIZE 046, 012 OF oDlgCar action(cGet1:= cGet1+" .OR. ")  FONT oFont2 PIXEL
@ 065+nlin, 428 BUTTON oButton4 PROMPT "(" 	SIZE 018, 012 OF oDlgCar action(cGet1:= cGet1+" ( ") FONT oFont2 PIXEL
@ 065+nlin, 458 BUTTON oButton5 PROMPT ")" 	SIZE 018, 012 OF oDlgCar action(cGet1:= cGet1+" ) ") FONT oFont2 PIXEL
@ 080+nlin, 428 BUTTON oButton6 PROMPT "==" 	SIZE 018, 012 OF oDlgCar action(cGet1:= cGet1+" == ") FONT oFont2 PIXEL
@ 080+nlin, 458 BUTTON oButton7 PROMPT "<>" 	SIZE 017, 012 OF oDlgCar action(cGet1:= cGet1+" <> ") FONT oFont2 PIXEL
@ 095+nlin, 428 BUTTON oButton8 PROMPT ">=" 	SIZE 018, 012 OF oDlgCar action(cGet1:= cGet1+" >= ") FONT oFont2 PIXEL
@ 095+nlin, 458 BUTTON oButton9 PROMPT "<=" 	SIZE 017, 012 OF oDlgCar action(cGet1:= cGet1+" <= ") FONT oFont2 PIXEL
@ 110+nlin, 428 BUTTON oButton10 PROMPT ">" 		SIZE 018, 012 OF oDlgCar action(cGet1:= cGet1+" > ") FONT oFont2 PIXEL
@ 110+nlin, 458 BUTTON oButton11 PROMPT "<" 		SIZE 017, 012 OF oDlgCar action(cGet1:= cGet1+" < ") FONT oFont2 PIXEL
@ 160+nlin, 428 BUTTON oButton12 PROMPT "OK" SIZE 50, 30 OF oDlgCar action(oDlgCar:end()) FONT oFont2 PIXEL

@ 145+nlin, 010 SAY oSay2    PROMPT "MENSAGEM" SIZE 100, 015 OF oDlgCar FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 160+nlin, 010 GET oGet2 VAR cGet2 SIZE 408, 30 OF oDlgCar COLORS 0, 16777215 FONT oFont1 PIXEL
	

ACTIVATE MSDIALOG oDlgCar CENTER

M->ZZQ_MREGRA:= cGet1 
M->ZZQ_MSG:= cGet2 



Return(aItens3)


/*/Função: fOpcoes
description
@type function
@author Ricardo Roda
@since 03/01/2021
/*/
Static Function fOpcoes(oSay3,cBase,cCaract,cNomCar)
Local lMark    := .F.

aVetor3:={}

dbSelectArea("SBS")
SBS->(dbSetOrder(1))//BS_FILIAL, BS_BASE, BS_ID, BS_CODIGO, R_E_C_N_O_, D_E_L_E_T_
IF SBS->(dbSeek(xFilial("SBS")+PADR(cBase,TamSx3('BS_BASE')[1])+cCaract))
	While SBS->(!eof()) .and. ALLTRIM(SBS->BS_BASE) == ALLTRIM(cBase) .AND. ALLTRIM(SBS->BS_ID) == ALLTRIM(cCaract)
		
		If lEnd
			MsgInfo(cCancel,"Fim")
			Exit
		Endif
		
		oSay3:cCaption := ("Buscando Características: "+ ALLTRIM(cNomCar))
		ProcessMessages()
		
		Aadd(aVetor3,{lMark, ALLTRIM(SBS->BS_CODIGO), ALLTRIM(BS_DESCR)})
		SBS->(DbSkip())
	End
else
	MsgAlert("Opções não encontradas","Aviso")
	Aadd(aVetor3,{"",""})
Endif
@ 10,260 SAY 	 oSay1    PROMPT "OPÇÕES" SIZE 100, 010 OF oDlgCar FONT oFont2 COLORS 8388608, 16777215 PIXEL
@ 25,250 LISTBOX oLbx3 VAR cVar FIELDS HEADER ;
" ", "Opções","Código","" SIZE 230,095 OF oDlgCar PIXEL ON dblClick(aVetor3[oLbx3:nAt,1] := !aVetor3[oLbx3:nAt,1],oLbx3:Refresh(), cGet1:= cGet1+'#|'+alltrim(aVetor3[oLbx3:nAt,2])+'|', oMultiGe1:Refresh())

oLbx3:SetArray( aVetor3 )
oLbx3:bLine := {|| {Iif(aVetor3[oLbx3:nAt,1],oOk,oNo),;
aVetor3[oLbx3:nAt,2],;
aVetor3[oLbx3:nAt,3]}}


Return ()

Static function fMarkFam()
Local _i

For _i:=1 to len(aVetor)
	if  _i == oLbx:nAt
		if !aVetor[oLbx:nAt,1]
			aVetor[_i,1]:= .T.
		Endif
	Else
		aVetor[_i,1]:= .F.
	Endif
	
	oLbx:Refresh()
Next _i

Return


Static Function fAltDesc ()
Local  cQuery:= "" 

  cQuery:= "UPDATE ZZQ010 SET ZZQ_DESREG = SUBSTRING( ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZZQ_MREGRA)),''),1,150) , "
  cQuery+= "ZZQ_DESMSG = SUBSTRING(ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZZQ_MSG)),''),1,150)
//  cQuery+= " WHERE 
  TCSQLEXEC(cQuery)

Return 
