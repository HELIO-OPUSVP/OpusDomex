//----------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - OpusVp - 14/08/2013                                                                                                     //
//----------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Rosenberger Domex                                                                                                                  //
//----------------------------------------------------------------------------------------------------------------------------------------------//
//Impressão das etiquetas avulsas.                                                                                                              //
//----------------------------------------------------------------------------------------------------------------------------------------------//

#include "rwmake.ch"
#include "TopConn.ch"
#include "TbiConn.ch"

User Function DOMEST07(_nOpcao)
Local _aArea        := GetArea()
Private _nQtd       := 0
Private _nSaldo     := 0
Private _cLocalDe   := Space(15)
Private _cLocalAt   := Space(15)
Private _cCodigo    := Space(15)
Private _cDoc       := CriaVar("F1_DOC")
Private _cSerie     := CriaVar("F1_SERIE")
Private _cFornece   := CriaVar("F1_FORNECE")
Private _cLoja      := CriaVar("F1_LOJA")
Private _cRazao     := CriaVar("A2_NOME")
Private _nItem      := CriaVar("D1_ITEM")
Private _cPorta     := "LPT1"
//Private _cPorta     := "192.168.0.175"
Private _cPerg      := "DOMEST07"+Space(02)
Private _cDescri    := CriaVar("B1_DESC")
Private _cLocal     := CriaVar("B2_LOCAL")
Private _cEndereco  := CriaVar("BE_LOCALIZ")
Private _lProc      := .F.

Do Case
	Case _nOpcao ==1
		
		@ 200,001 To 410,380 Dialog oDlg Title "Impressao de Etiquetas Avulsas "
		@ 002,002 To 040,190
		@ 045,002 To 080,190
		@ 005,010 Say "Codigo: "
		@ 005,040 Get _cCodigo F3 "DOMSB1" Size 70,15 Valid fBuscaSb1()
		@ 020,040 Get _cDescri When .F. Size 110,15
		@ 050,010 Say "Local: "
		@ 050,025 Get _cLocal Size 30,20 Valid fLocal()
		@ 050,070 Say "Endereço: "
		@ 050,095 Get _cEndereco F3 "SBE" When _lProc Size 70,20 Valid fEndereco()
		@ 065,010 Say "No. Etiquetas: "
		@ 065,045 Get _nQtd Size 50,20 Picture "@E 999,999,999"
		@ 065,100 Say "Quantidade: "
		@ 065,130 Get _nSaldo Size 50,20 Picture "@E 999,999,999.999"
		@ 085,105 Button "Imprimir" Size 40,15 Action fEtiqAvu()
		@ 085,150 Button "Cancelar" Size 40,15 Action Close(oDlg)
		
		Activate Dialog oDlg Centered
		
	Case _nOpcao ==2
		
		@ 200,001 To 380,380 Dialog oDlg Title "Impressao de Etiquetas Enderecos "
		@ 002,002 To 040,190
		@ 045,002 To 065,190
		@ 005,010 Say "Do Endereco: "
		@ 005,050 Get _cLocalDe F3 "SBE"  Size 70,15
		@ 020,010 Say "Ate o Endereco: "
		@ 020,050 Get _cLocalAt F3 "SBE"  Size 70,15
		@ 070,105 Button "Imprimir" Size 40,15 Action fEtiqEnd()
		@ 070,150 Button "Cancelar" Size 40,15 Action Close(oDlg)
		
		Activate Dialog oDlg Centered
		
	Case _nOpcao ==3
		
		fCriaPerg()
		If Pergunte(_cPerg,.T.)
			
			cQuery := "SELECT R_E_C_N_O_ FROM SF1010 WHERE F1_DOC = '"+mv_par01+"' AND F1_SERIE = '"+mv_par02+"' AND F1_FORMUL = 'S' AND D_E_L_E_T_ = ''"
			
			If Select("TEMP") <> 0
				TEMP->( dbCloseArea() )
			EndIf
			
			TCQUERY cQuery NEW ALIAS "TEMP"
			
			If !TEMP->( EOF() )
				SD1->( dbSetOrder(1) )
				SB1->( dbSetOrder(1) )
				SF1->( dbGoto(TEMP->R_E_C_N_O_) )
				SD1->( dbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
				While !SD1->( EOF() ) .and. SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA
					SB1->( dbSeek( xFilial() + SD1->D1_COD ) )
					If SB1->B1_XXETIQU $ "1/2"
						U_DOMEST03()
					EndIf
					SD1->( dbskip() )
				End
			Else
				MsgStop('Náo foi encontrada NF de formulario prorio com este numero/serie')
			EndIf
			
		EndIf
		
EndCase

RestArea(_aArea)
Return

//-----------------------------------------------

Static Function fEndereco()
Local _lRet :=.T.
If! Empty(_cEndereco)
	SBE->(dbSetOrder(1))
	If! SBE->(dbSeek(xFilial("SBE")+_cLocal+_cEndereco))
		MsgInfo("Almoxarifado ou endereço não encontrado.","A T E N Ç Ã O")
		_lRet := .F.
	EndIf
Else
	MsgInfo("Está habilitado para este produto , o controle por endereçamento. ","ENDEREÇO não informado")
EndIf

Return(_lRet)

//-----------------------------------------------

Static Function fLocal()
Local _lRet:=.T.
If! Empty(_cLocal)
	SB2->(dbSetOrder(1))
	If! SB2->(dbSeek(xFilial("SB2")+_cCodigo+_cLocal))
		MsgInfo("Solicite a criação do almoxarifado para este produto.","A T E N Ç Ã O")
		_lRet := .F.
	EndIf
Else
	MsgInfo("Informe um almoxarifado válido , para este produto.","A T E N Ç Ã O")
	_lRet := .F.
EndIf

Return(_lRet)

//-----------------------------------------------

Static Function fBuscaSb1()
Local _lRet:=.F.
_cDescri   :=""
SB1->(dbSetOrder(1))

If SB1->(dbSeek(xFilial("SB1")+_cCodigo))
	_lRet      := .T.
	_cDescri   := SB1->B1_DESC
	_lProc     := Localiza(SB1->B1_COD)
	_cEndereco := If(_lProc,_cEndereco,"")
Else
	MsgStop("Produto inválido.")
EndIf

If _lRet
	lSilk := .F.
	If SG1->( dbSeek( xFilial() + _cCodigo ) )
		While !SG1->( EOF() ) .and. SG1->G1_COD == _cCodigo
			If Subs(SG1->G1_COMP,1,6) == '500960'
				lSilk := .T.
				Exit
			EndIf
			SG1->( dbSkip() )
		End
	EndIf
	
	If !lSilk .and. SB1->B1_TIPO <> 'PA'
		If Upper(Subs(cUsuario,7,5))  == 'DENIS'      .or. ;
		   Upper(Subs(cUsuario,7,7))  == 'LUCIANO'    .or. ;
		   Upper(Subs(cUsuario,7,8))  == 'EDMILSON'   .or. ;
		   Upper(Subs(cUsuario,7,14)) == 'CAMILA MARTINS'   .or. ;		   
		   Upper(Subs(cUsuario,7,10)) == 'HELIO OPUS' .or. ;
		   Upper(Subs(cUsuario,7,13)) == 'SERGIO SANTOS'
		   //MsgStop("A partir do dia 31/01/14, só será permitida a emissão de etiquetas avulsas para produtos 'Silk'.")
		Else
		   MsgStop("Etiquetas avulsas são permitidas apenas para produtos 'Silk'.")
		   _lRet := .F.
		EndIf
	EndIf
EndIf

oDlg:Refresh()

Return(_lRet)

//-----------------------------------------------

Static Function fEtiqEnd()
Close(oDlg)
dbSelectArea("SBE")
dbSetOrder(9)
dbSeek(xFilial("SBE")+_cLocalDe)
Do While.Not.Eof().And.SBE->BE_LOCALIZ >= _cLocalDe.And.SBE->BE_LOCALIZ <= _cLocalAt
	
	MSCBPrinter("TLP 2844",_cPorta,,,.F.)
	MSCBBegin(1,6)
	MSCBSay(28,01,"ALMOXARIFADO :"+SBE->BE_LOCAL,"N","2","1,1")
	MSCBSay(28,03,"ENDERECO :"+SBE->BE_LOCALIZ,"N","2","1,1")
	MSCBSayBar(27,06,SBE->BE_LOCAL+SubStr(SBE->BE_LOCALIZ,1,13),"N","MB07",10,.F.,.T.,.F.,,2,1,Nil,Nil,Nil,Nil)
	MSCBEnd()
	Sleep(500)
	MSCBClosePrinter()
	dbSkip()
EndDo

Return

//-----------------------------------------------

Static Function fEtiqImp()
Close(oDlg)

dbSelectArea("XD1")
For _nX:=1 To _nQtd
	
	_cProxPeca := U_IXD1PECA()
	Reclock("XD1",.T.)
	Replace XD1->XD1_FILIAL  With xFilial("XD1")
	// Substituido por Michel Sander em 28.08.2014 para gravar o documento a partir do programa IXD1PECA()
	Replace XD1->XD1_XXPECA  With _cProxPeca
	Replace XD1->XD1_FORNEC  With Space(06)
	Replace XD1->XD1_LOJA    With Space(02)
	Replace XD1->XD1_DOC     With Space(06)
	Replace XD1->XD1_SERIE   With Space(03)
	Replace XD1->XD1_ITEM    With StrZero(Recno(),4)
	Replace XD1->XD1_COD     With SB1->B1_COD
	Replace XD1->XD1_LOCAL   With SB1->B1_LOCPAD
	Replace XD1->XD1_TIPO    With SB1->B1_TIPO
	Replace XD1->XD1_LOTECT  With ""
	Replace XD1->XD1_DTDIGI  With dDataBase
	Replace XD1->XD1_FORMUL  With ""
	Replace XD1->XD1_LOCALI  With ""
	Replace XD1->XD1_USERID  With __cUserId
	XD1->XD1_OCORRE := "4"
	XD1->( MsUnlock() )
	
Next
Return

//-----------------------------------------------

Static Function fEtiqAvu()
Close(oDlg)
dbSelectArea("XD1")
For _nX:=1 To _nQtd
	_cProxPeca := U_IXD1PECA()
	Reclock("XD1",.T.)
	Replace XD1->XD1_FILIAL  With xFilial("XD1")
	// Substituido por Michel Sander em 28.08.2014 para gravar o documento a partir do programa IXD1PECA()
	Replace XD1->XD1_XXPECA  With _cProxPeca
	Replace XD1->XD1_FORNEC  With Space(06)
	Replace XD1->XD1_LOJA    With Space(02)
	Replace XD1->XD1_DOC     With Space(06)
	Replace XD1->XD1_SERIE   With Space(03)
	Replace XD1->XD1_ITEM    With StrZero(Recno(),4)
	Replace XD1->XD1_COD     With SB1->B1_COD
	Replace XD1->XD1_LOCAL   With _cLocal
	Replace XD1->XD1_TIPO    With SB1->B1_TIPO
	Replace XD1->XD1_LOTECT  With "LOTE1308"
	Replace XD1->XD1_DTDIGI  With dDataBase
	Replace XD1->XD1_FORMUL  With ""
	Replace XD1->XD1_LOCALI  With _cEndereco
	Replace XD1->XD1_USERID  With __cUserId
	XD1->XD1_OCORRE := "4"
	Replace XD1->XD1_QTDORI  With _nSaldo
	Replace XD1->XD1_QTDATU  With _nSaldo
	XD1->( MsUnlock() )
	
	U_DOMEST06()
Next
Return

//---------------------------------------------------------------

Static Function fCriaPerg()
aSvAlias:={Alias(),IndexOrd(),Recno()}
i:=j:=0
aRegistros:={}
//                1      2    3                  4  5      6     7  8  9  10  11  12 13     14  15    16 17 18 19 20     21  22 23 24 25   26 27 28 29  30       31 32 33 34 35  36 37 38 39    40 41 42 43 44
AADD(aRegistros,{_cPerg,"01","NF Importacao ?","","","mv_ch1","C",06,00,00,"G","","mv_par01",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","" ,"","","","",""})
AADD(aRegistros,{_cPerg,"02","Série         ?","","","mv_ch2","C",03,00,00,"G","","mv_par02",""    ,"","","","",""   ,"","","","",""     ,"","","","",""      ,"","","","","","","","","" ,"","","","",""})

DbSelectArea("SX1")
For i := 1 to Len(aRegistros)
	If !dbSeek(aRegistros[i,1]+aRegistros[i,2])
		While !RecLock("SX1",.T.)
		End
		For j:=1 to FCount()
			FieldPut(j,aRegistros[i,j])
		Next
		MsUnlock()
	Endif
Next i

dbSelectArea(aSvAlias[1])
dbSetOrder(aSvAlias[2])
dbGoto(aSvAlias[3])
Return(Nil)
