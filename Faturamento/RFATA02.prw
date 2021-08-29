#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATA02  ºAutor  ³Michel Sander       º Data ³  01/26/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutenção no cadastro de Previsão de Faturamento          º±±
±±º          ³ 							                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamada no pedido de venda durante INCLUSAO/ALTERACAO      º±±
±±º          ³ através de opção na EnchoiceBar (Prev. Fat.)				     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATA02()

LOCAL aArea 	 := GetArea()
LOCAL lRet  	 := .T.

PRIVATE aColsC6   := ACLONE(aCols)
PRIVATE aHeaderC6 := ACLONE(aHeader)
PRIVATE nUltN     := N
PRIVATE cUltN 	   := "00"


Aviso("Atenção","Esta tela foi descontinuada. Favor acessar a rotina de Previsão de Faturamento.",{"Ok"})
Return



For _nx := 1 to n
   cUltN := Soma1(cUltN)
Next _nx


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o contador do aCols                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
N := 1

If INCLUI
	
	If Empty(aCols[n,2]) .Or. Empty(aCols[n,6])
		Aviso("Atenção","o item não está preenchido para permitir previsão. Coloque dados do produto e quantidade.",{"Ok"})
		aHeader := ACLONE(aHeaderC6)
		aCols   := ACLONE(aColsC6)
		n       := nUltN
		RestArea( aArea )
		Return ( .T. )
	EndIf
	
EndIf

aHeader := {}
dbSelectArea("SZY")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o cabecalho                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


SX3->( dbSetOrder(1) )
dbSelectArea("Sx3")
dbSeek("SZY")
nUsado := 0
While !EOF() .And. (SX3->X3_ARQUIVO == "SZY")
	IF X3USO(x3_usado) .AND. cNivel >= SX3->X3_NIVEL
 
//			If Trim(x3_campo) != "ZY_FILIAL" .And. Trim(x3_campo) != "ZY_PEDIDO" .And. Trim(x3_campo) != "ZY_LOCENTR"
		If !(Alltrim(X3_CAMPO) $   "ZY_FILIAL/ZY_PEDIDO/ZY_LOCENTR/ZY_DATA2" )	
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo,,,Nil } )
		EndIf
	EndIf
	dbSkip()
EndDO


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aCols da previsão												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
__nOpcA := 3
If Empty(aCols&cUltN)
	SZY->(dbSetOrder(1))
	SZY->(dbSeek(xFilial("SZY")+M->C5_NUM+aColsC6[nUltN,1]))
	Do While SZY->(!Eof()) .And. SZY->ZY_FILIAL+SZY->ZY_PEDIDO+SZY->ZY_ITEM == xFilial("SZY")+M->C5_NUM+aColsC6[nUltN,1]
		aadd(aCols&cUltN,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			aCols&cUltN[Len(aCols&cUltN),nCntFor] := SZY->(FieldGet(FieldPos(aHeader[nCntFor][2])))
		Next nCntFor
		aCols&cUltN[Len(aCols&cUltN)][nUsado+1] := .F.
		SZY->(dbSkip())
	EndDo
	If ( Empty(aCols&cUltN) )
		aadd(aCols&cUltN,Array(nUsado+1))
		For nCntFor	:= 1 To nUsado
			aCols&cUltN[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		Next nCntFor
		aCols&cUltN[Len(aCols&cUltN)][nUsado+1] := .F.
		aCols&cUltN[Len(aCols&cUltN)][1] := cUltN
		aCols&cUltN[Len(aCols&cUltN)][2] := "001"
		aCols&cUltN[Len(aCols&cUltN)][3] := aColsC6[nUltN,2]
		aCols&cUltN[Len(aCols&cUltN)][4] := Posicione("SB1",1,xFilial("SB1")+aColsC6[nUltN,2],"B1_DESC")
		aCols&cUltN[Len(aCols&cUltN)][5] := Posicione("SB1",1,xFilial("SB1")+aColsC6[nUltN,2],"B1_UM")
		aCols&cUltN[Len(aCols&cUltN)][6] := aColsC6[nUltN,6]
		aCols&cUltN[Len(aCols&cUltN)][8] := dDataBase
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a tela para digitação da previsão de faturamento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG __oDlg TITLE OemToAnsi("Previsão de Faturamento") From 9,0 To 28,165 OF oMainWnd

cGetOpc        := GD_INSERT+GD_DELETE+GD_UPDATE			// GD_INSERT+GD_DELETE+GD_UPDATE
cLinhaOk       := "U_VLRFTA02()"	   // Funcao executada para validar o contexto da linha atual do aCols
cTudoOk        := "U_VLRFTA03()"   // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
cIniCpos       := "+ZY_SEQ/ZY_ITEM/ZY_PRODUTO/ZY_DESC/ZY_UM/ZY_PRVFAT/ZY_LOCENTR"         // Nome dos campos do tipo caracter que utilizarao incremento automatico.
nFreeze        := Nil               // Campos estaticos na GetDados.
nMax           := 999               // Numero maximo de linhas permitidas. Valor padrao 99
cCampoOk       := "U_FVLCPO02()"   // Funcao executada na validacao do campo
cSuperApagar   := Nil               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
cApagaOk       := Nil               // Funcao executada para validar a exclusao de uma linha do aCols

__oGet := MsNewGetDados():New(30,5,128,650,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,__oDlg,aHeader,aCols&cUltN)

ACTIVATE MSDIALOG __oDlg ON INIT EnchoiceBar(__oDlg,{|| U_FtOkoDlg() },{||__oDlg:End()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche aCols da previsão com a digitação  				     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If __nOpcA == 1
	aCols&cUltN := aClone(__oGet:acols)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura aCols do pedido de venda							       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := ACLONE(aHeaderC6)
aCols   := ACLONE(aColsC6)
n       := nUltN
RestArea( aArea )

Return ( .T. )


User Function FtOkoDlg()
Local _Retorno := .T.

_Retorno := U_VLRFTA03()

If _Retorno
	__nOpcA := 1
	__oDlg:End()
EndIf

Return _Retorno
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VLRFTA02 ºAutor  ³Michel Sander       º Data ³  01/26/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida linha da previsão de faturamento				        º±±
±±º          ³ 							                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VLRFTA02()

LOCAL __lRet     := .T.

REturn ( __lRet )


User Function VLRFTA03()

LOCAL __lRet     := .T.
LOCAL __lData    := .F.
LOCAL nSoma      := 0
LOCAl __lParcial := .F.
LOCAL __nPosData := ASCAN(aHeader,{ |x| ALLTRIM( Upper(x[2]) ) == "ZY_PRVFAT" } )
LOCAL __nPosQtde := ASCAN(aHeader,{ |x| ALLTRIM( Upper(x[2]) ) == "ZY_QUANT" } )
LOCAL __nPosDoc  := ASCAN(aHeader,{ |x| ALLTRIM( Upper(x[2]) ) == "ZY_NOTA" } )

For nQ := 1 to Len(__oGet:aCols)

   If __oGet:aCols[nQ,Len(__oGet:aCols[nQ])]
      Loop
   EndIf
	nSoma += __oGet:aCols[nQ,__nPosQtde]
	If __oGet:aCols[nQ,__nPosData] < Date()
		__lData := .T.
	EndIf

Next

If nSoma <> aColsC6[nUltN,__nPosQtde]
	Aviso("Atenção","A quantidade total informada é diferente da quantidade do item no pedido.",{"Ok"})
	__lRet := .F.
EndIf

REturn ( __lRet )

User Function FVLCPO02()
Local _Retorno := .T.
LOCAL __nPosDoc  := ASCAN(aHeader,{ |x| ALLTRIM( Upper(x[2]) ) == "ZY_NOTA" } )

cCMPValid := ReadVar()   // GATILHO - Retorna o nome do CAMPO disparador do gatilho / FIELD / VARIÁVEL RETORNA CAMPO / FUNÇÃO RETORNA CAMPO

If cCMPValid == "M->ZY_PRVFAT"
	If !Empty(aCols[n,__nPosDoc])
		Aviso("Atenção","A data de um item já faturado não pode ser alterada.",{"Ok"})
		_Retorno := .F.
	Else
		//If M->ZY_PRVFAT < Date()   // Validação tiradapor Hélio em 02/02/17
	   //	Aviso("Atenção","A data de faturamento não pode ser inferior a data atual.",{"Ok"})
		//	_Retorno := .F.
		//EndIf
	EndIf
EndIf

If cCMPValid == "M->ZY_QUANT"
	If !Empty(aCols[n,__nPosDoc])
		Aviso("Atenção","A quantidade de um item já faturado não pode ser alterada.",{"Ok"})
		_Retorno := .F.
	EndIf
EndIf

Return _Retorno
