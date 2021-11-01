//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - 24/09/12                                                                                                                   //  
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson 22/05/13                                                                                                                                //
//Tratamento fibra                                                                                                                                 //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Domex                                                                                                                                 //
//PARA FUNCIONAMENTO CORRETO, O DARKNESS TEM QUE SER 26 (CONFIGURAÇÃO DE TEMPERATURA DA IMPRESSORA ZM400)                                          //                      //
//-------------------------------------------------------------------------------------------------------------------------------------------------//
//Impressao das etiquetas recebimento.                                                                                                             //
//-------------------------------------------------------------------------------------------------------------------------------------------------//

#include "rwmake.ch"
#include "TopConn.ch"
#include "TbiConn.ch"
#include "protheus.ch"
#include "totvs.ch"

User Function DOMEST03()
	Private oDlg
	Private _nResto     := 0
	Private cStatus     := ''
	Private aCols
	Private _nQtdDigit  := 0

	Private _oGetDados
	Private  cGetOpc        := GD_INSERT+GD_DELETE+GD_UPDATE                   // GD_INSERT+GD_DELETE+GD_UPDATE
	Private  cLinhaOk       := Nil                                             // Funcao executada para validar o contexto da linha atual do aCols
	Private  cTudoOk        := Nil                                             // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Private  cIniCpos       := "+XD1_ITEM"                                     // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Private  nFreeze        := Nil                                             // Campos estaticos na GetDados.
	Private  nMax           := 0                                               // Numero maximo de linhas permitidas. Valor padrao 99
	Private  cCampoOk       := "U_fOkCampo()"                                  // Funcao executada na validacao do campo
	Private  cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Private  cApagaOk       := Nil                                             // Funcao executada para validar a exclusao de uma linha do aCols
	Private  aCpoItem       := {}                                              // Array com os campos que deverão ser tratados quando rotina de inclusão
	Private  aHeader        := {}                                              // Array do aHeader
	Private	aCols          := {}                                              // Array do aCols
	Private	cVrAlias       := "XD1"
	Private	nQtdLnhs       := 1
	Private	cOpcaoUt       := 3                                               // 3 = INCLUSÃO, 2 = Alteração
	Private	cOrdSeek       := 1
	Private	cCndSeek       := "xFilial('XD1')"
	Private	cCpoSeek       := "XD1->XD1_FILIAL"
//Private	cVCampos       := "XD1_ITEM,XD1_QTDATU"
	Private  _aCampos       := {}

	aadd(_aCampos,{"XD1_ITEM"})
	aadd(_aCampos,{"XD1_QTDATU"})

	aAreaGER := GetArea()

	dbSelectArea("SB1")

	If Type("B1_XXQE") <> 'U'
		Private _nEmb       := SB1->B1_XXQE
		Private _nQtd       := If(SB1->B1_XXQE ==0,1,SD1->D1_QUANT / SB1->B1_XXQE)
		Private _nQtd       := If(_nQtd < 1,1,_nQtd)
		Private _nQtdBkp    := _nQtd
	Else
		Private _nEmb       := 0
		Private _nQtd       := 0
		Private _nQtdBkp    := _nQtd
	EndIf
	Private aPrinter	   := {'1-Pequena','2-Grande'}
	Private cPrinter	   := "1"
	Private oCombo1
	Private _aArq		:= {}
	Private aCodEtq 	:= {}
	Private cLocImp := "Z00001"
	Private _txt1
	Private _txt3

	nQtdLnhs:= _nQtd
	nMax    := _nQtd

	RestArea(aAreaGER)

	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))

	nQtdSD1 := SD1->D1_QUANT
  
	@ 001,001 To 400,400 Dialog oDlg Title "Impressao das Etiquetas Pre-Nota: "+SD1->D1_DOC+"-"+SD1->D1_SERIE
	@ 005,010 Say "Codigo: "+SD1->D1_COD        Pixel
	@ 015,010 Say "Descricao: "+SB1->B1_DESC    Pixel
	@ 025,010 Say "Embalagem: "                 Pixel
	@ 025,052 Get _nEmb Size 50,10 Picture "@E 999,999,999.999" Valid fOkEmb() Pixel
	@ 054,010 Say "Quantidade: " Pixel
	@ 050,052 Get _nQtd Size 50,10 Picture "@E 999999999" Valid fOkQtd()     Pixel

	@ 025,105 Say "Qtd NF: " Pixel
	@ 025,130 Say oQtdSD1  Var nQtdSD1  Picture "@E 999,999.99" Size 60,12    Pixel
	oQtdSD1:oFont := TFont():New('Arial',13,13,,.T.,,,,.T.,.F.)

	@ 054,105 Say "Qtd Total: " Pixel
	@ 054,130 Say oQtdEtq  Var _nQtdDigit  Picture "@E 999,999.99" Size 60,12    Pixel
	oQtdEtq:oFont := TFont():New('Arial',13,13,,.T.,,,,.T.,.F.)

	aAdd(aCpoItem,{"XD1_XXPECA",StrZero(1,12),.F.})

	aHeader        := fHeader(cVrAlias,_aCampos)//fHeader(cVrAlias,cVCampos)
	aCols          := fAcols(aHeader,cVrAlias,aCpoItem,nQtdLnhs,cOpcaoUt,cOrdSeek,cCndSeek,cCpoSeek,_aCampos)//cVCampos)
	_oGetDados     := MsNewGetDados():New(70,10,160,190,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDlg,aHeader,aCols)

	@ 165,015 Say "Impressora" Pixel
	@ 175,015 COMBOBOX oCombo1 VAR cPrinter ITEMS aPrinter SIZE 70,25  VALID .T. PIXEL
	@ 175,105 Button "Imprimir" Size 40,15 Action fOkImp()   Pixel
	@ 175,150 Button "Cancelar" Size 40,15 Action Close(oDlg) Pixel


	Activate Dialog oDlg Centered

Return

//----------------------------------------------------

Static Function fOkImp()
	_nQtdDigit := 0

	For _nX := 1 to Len(_oGetDados:aCols)
		_nQtdDigit += _oGetDados:aCols[_nX,2]
	Next _nX

	If _nQtdDigit <> nQtdSD1
		_lRet:=.F.
		MsgInfo("Divergência na quantidade informada: "+Alltrim(TransForm(_nQtdDigit,"@E 999,999,999")) + " para a quantidade da NF: " + Alltrim(TransForm(nQtdSD1,"@E 999,999,999")),"A T E N Ç Ã O")
	Else
		Close(oDlg)

		If _nEmb <> SB1->B1_XXQE.And. SB1->B1_XXETIQU == "1"
			Reclock("SB1",.F.)
			Replace SB1->B1_XXQE With _nEmb
			MsUnlock()
		EndIf

		if Substring(cPrinter,1,1) == '2'
			//CB5->(dbSetOrder(1))
			//CB5->(dbSeek(xFilial("CB5")+"Z00002"))
			//cPorta := CB5->CB5_LPT
			cPorta    := "LPT2"
			cModelo := "Z4M" // ou "S400"
			
			MSCBPrinter(cModelo,cPorta,,,.F.)
			MSCBChkStatus(.F.)

		else

			If !CB5SetImp(cLocImp,.F.)
				MsgAlert("Local de impressao invalido!","Aviso")
				Return .F.
			EndIf

		Endif

		For _nX:=1 To Len(_oGetDados:aCols)
			dbSelectArea("XD1")
			_cProxPeca := U_IXD1PECA()
			Reclock("XD1",.T.)
			Replace XD1->XD1_FILIAL  With xFilial("XD1")
			// Substituido por Michel Sander em 28.08.2014 para gravar o documento a partir do programa IXD1PECA()
			Replace XD1->XD1_XXPECA  With _cProxPeca
			Replace XD1->XD1_FORNEC  With SD1->D1_FORNECE
			Replace XD1->XD1_LOJA    With SD1->D1_LOJA
			Replace XD1->XD1_DOC     With SD1->D1_DOC
			Replace XD1->XD1_SERIE   With SD1->D1_SERIE
			Replace XD1->XD1_ITEM    With SD1->D1_ITEM
			Replace XD1->XD1_COD     With SD1->D1_COD
			Replace XD1->XD1_LOCAL   With SD1->D1_LOCAL
			Replace XD1->XD1_TIPO    With SD1->D1_TIPO
			Replace XD1->XD1_LOTECT  With SD1->D1_LOTECTL
			Replace XD1->XD1_DTDIGI  With SD1->D1_DTDIGIT
			Replace XD1->XD1_FORMUL  With SD1->D1_FORMUL
			Replace XD1->XD1_LOCALI  With SD1->D1_ENDER
			Replace XD1->XD1_USERID  With __cUserId
			Replace XD1->XD1_QTDORI  With _oGetDados:aCols[_nX,2]
			Replace XD1->XD1_QTDATU  With _oGetDados:aCols[_nX,2]
			XD1->XD1_OCORRE := If(SD1->D1_LOCAL $ AllTrim('MV_CQ'),'2','3')
			XD1->( MsUnlock() )
			//mls/*


			if Substring(cPrinter,1,1) == '2'
				MSCBBegin(1,2)
				If dDataBase <= StoD('20130615') .or. .T.
					MSCBSay(05,03,"NF:"+XD1->XD1_DOC + "  Prod:"+Alltrim(XD1->XD1_COD) + " Qt: " + Alltrim(Transform(XD1->XD1_QTDORI,'@E 999,999,999.9'))  ,"N","0","35,30")
				Else
					MSCBSay(05,03,"NF:"+XD1->XD1_DOC + "     Prod:"+XD1->XD1_COD  ,"N","0","35,30")
				EndIf

				MSCBSay(05,08,SubStr(SB1->B1_DESC,1,33)                       ,"N","0","35,30")
				MSCBSay(05,14,"Forn:"+XD1->XD1_FORNEC+"/"+XD1->XD1_LOJA+' - '+ Posicione("SA2",1,xFilial("SA2")+XD1->XD1_FORNEC+XD1->XD1_LOJA,"A2_NOME") ,"N","0","35,30")
				//         1  2  3                        4      5   6     7   8   9    11  12  13
				MSCBSayBar(13,19,AllTrim(XD1->XD1_XXPECA),"MB07",'E',13,.T.,.T.,.F.,,5  ,2, .F.)
				MSCBEnd()
			ELSE

				AADD(_aArq,'CT~~CD,~CC^~CT~'+ CRLF)
				
				AADD(_aArq,'^XA'+ CRLF)
				AADD(_aArq,'~TA000'+ CRLF)
				AADD(_aArq,'~JSN'+ CRLF)
				AADD(_aArq,'^LT0'+ CRLF)
				AADD(_aArq,'^MNW'+ CRLF)
				AADD(_aArq,'^MTT'+ CRLF)
				AADD(_aArq,'^PON'+ CRLF)
				AADD(_aArq,'^PMN'+ CRLF)
				AADD(_aArq,'^LH0,0'+ CRLF)
				AADD(_aArq,'^JMA'+ CRLF)
				AADD(_aArq,'^PR8,8'+ CRLF)
				AADD(_aArq,'^JUS'+ CRLF)
				AADD(_aArq,'^LRN'+ CRLF)
				AADD(_aArq,'^CI27'+ CRLF)
				AADD(_aArq,'^PA0,1,1,0'+ CRLF)
				AADD(_aArq,'^XZ'+ CRLF)
				
				AADD(_aArq,'^XA'+ CRLF)
				AADD(_aArq,'^MMT'+ CRLF)
				AADD(_aArq,'^PW400'+ CRLF)
				AADD(_aArq,'^LL200'+ CRLF)
				AADD(_aArq,'^LS0'+ CRLF)
				AADD(_aArq,'^BY3,2,56^FT60,152^BEN,,Y,N'+ CRLF)
				AADD(_aArq,'^FH\^FD'+AllTrim(XD1->XD1_XXPECA)+'^FS'+ CRLF)

				If dDataBase <= StoD('20130615') .or. .T.
					_Txt1:= "NF:"+XD1->XD1_DOC + "  Prod:"+Alltrim(XD1->XD1_COD) + " Qt: " + Alltrim(Transform(XD1->XD1_QTDORI,'@E 999,999,999.9'))
				Else
					_Txt1:= "NF:"+XD1->XD1_DOC + "     Prod:"+XD1->XD1_COD
				EndIf
				_txt3:= "Forn:"+XD1->XD1_FORNEC+"/"+XD1->XD1_LOJA+' - '+ Posicione("SA2",1,xFilial("SA2")+XD1->XD1_FORNEC+XD1->XD1_LOJA,"A2_NOME")

				AADD(_aArq,'^FT11,26^A0N,17,18^FH\^CI28^FD'+_Txt1+'^FS^CI27'+ CRLF)
				AADD(_aArq,'^FT11,56^A0N,17,18^FH\^CI28^FD'+SubStr(SB1->B1_DESC,1,33)+'^FS^CI27'+ CRLF)
				AADD(_aArq,'^FT11,84^A0N,17,18^FH\^CI28^FD'+_Txt3+'^FS^CI27'+ CRLF)
				AADD(_aArq,'^PQ1,0,1,Y'+ CRLF)
				AADD(_aArq,'^XZ'+ CRLF)

				AaDd(aCodEtq,_aArq)
				_aArq:= {}

				For nY:=1 To Len(aCodEtq)
					For nP:=1 To Len(aCodEtq[nY])
						MSCBWrite(aCodEtq[nY][nP])
					Next nP
				Next nY

				aCodEtq:= {}
				MSCBEND()

			ENDIF


			Sleep(500)
			//mls*/
			cStatus := ''
			SD1->( dbSetOrder(1) )  //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			If SD1->( dbSeek( xFilial() + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNEC + XD1->XD1_LOJA + XD1->XD1_COD + XD1->XD1_ITEM ) )
				If SD1->D1_XXETIQ <> 'S'
					Reclock("SD1",.F.)
					SD1->D1_XXETIQ := 'S'
					SD1->( msUnlock() )

					SF1->( dbSetOrder(1) )
					If SF1->( dbSeek(xFilial() + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNEC + XD1->XD1_LOJA ) )
						If SF1->F1_XXETIQ <> 'I'
							cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SD1") + " WHERE D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA = '"+XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNEC + XD1->XD1_LOJA+"' AND D1_XXETIQ <> 'S' AND D_E_L_E_T_ = '' "

							If Select("QUERYSD1") <> 0
								QUERYSD1->( dbCloseArea() )
							EndIf

							TCQUERY cQuery NEW ALIAS "QUERYSD1"

							If QUERYSD1->( EOF() )
								Reclock("SF1",.F.)
								SF1->F1_XXETIQ := 'I'
								SF1->( msUnlock() )
							EndIf
						EndIf
					EndIf
				EndIf

				If Empty( SD1->D1_TES )
					cStatus := '1'
				Else
					cStatus := '2'
					//Tratamento para quando a nota 'e enviada para o CQ.
					If SD1->D1_LOCAL $ AllTrim(GetMv("MV_CQ"))
						SD7->( dbSetOrder(3) )
						If SD7->(dbSeek(xFilial("SD7")+SD1->D1_COD+SD1->D1_NUMSEQ))
							_lRet     := .F.
							_cNumero  := SD7->D7_NUMERO
							_cProduto := SD7->D7_PRODUTO
							_cLocal   := SD7->D7_LOCAL
							SD7->(dbSetOrder(1))
							If SD7->(dbSeek(xFilial("SD7")+_cNumero+_cProduto+_cLocal))
								While xFilial("SD7")+_cNumero+_cProduto+_cLocal == SD7->D7_FILIAL+SD7->D7_NUMERO+SD7->D7_PRODUTO+SD7->D7_LOCAL
									If Empty(SD7->D7_ESTORNO)
										Reclock("SD7",.F.)
										SD7->D7_XXETIQ := "S"
										SD7->( msUnlock() )
										If SD7->D7_TIPO == 1
											cStatus := '3'
											//Exit
										EndIf
									EndIf
									SD7->(dbSkip())
								End
							EndIf
						EndIf
					Else
						cStatus := '3'
					EndIf
				EndIf
			EndIf
			dbSelectarea("XD1")
			Reclock("XD1",.F.)
			If !Empty(cStatus)
				XD1->XD1_OCORRE := cStatus
			Else
				XD1->XD1_OCORRE := 'Z'
			EndIf
			XD1->( MsUnlock() )
		Next
		MSCBClosePrinter()

	EndIf

Return

//----------------------------------------------------

Static Function fOkEmb()
	Local lRet := .T.
	_oGetDados:aCols := {}
	_nQtdaCols       := SD1->D1_QUANT
	_nQtdEtq         := _nQtdaCols

	If !Empty(_nEmb)
		_nQtd  := If((SD1->D1_QUANT/_nEmb)<0.5,1,NoRound((SD1->D1_QUANT/_nEmb),0))
		_nQtd  += If((SD1->D1_QUANT%_nEmb)>0,1,0)
		_nQtdBkp := _nQtd
	EndIf

	If _nEmb <= SD1->D1_QUANT
		If !Empty(_nQtd)
			For _nX := 1 to _nQtd
				If _nQtdaCols >= _nEmb
					AADD(_oGetDados:aCols,{StrZero(Len(_oGetDados:aCols)+1,3),_nEmb,.F.})
					_nQtdaCols -= _nEmb
				Else
					AADD(_oGetDados:aCols,{StrZero(Len(_oGetDados:aCols)+1,3),_nQtdaCols,.F.})
					_nQtdaCols := 0
				EndIf
			Next _nX
		Else
			lRet:=.F.
		EndIf
	Else
		MsgStop('Quantidade informada superior a Nota Fiscal que é de ' + Alltrim(Transform(SD1->D1_QUANT,'@E 999,999,999.9999')))
		lRet := .F.
	EndIf

	_oGetDados:Refresh()

	FatuQtdDig()

Return(lRet)

//----------------------------------------------------

Static Function fOkQtd()
	Local lRet:=.T.

	If _nQtd <> 0 .and. _nQtd <> _nQtdBkp
		_nQtdBkp         := _nQtd
		_nEmb            := (SD1->D1_QUANT / _nQtd)

		If _nEmb <> Int(_nEmb) .and. _nEmb > 1
			_nEmb := Int(_nEmb) + 1
		EndIf

		_nQtdNF          := SD1->D1_QUANT
		_oGetDados:aCols := {}

		For _nX := 1 to _nQtd
			If _nQtdNF >= _nEmb
				AADD(_oGetDados:aCols,{StrZero(Len(_oGetDados:aCols)+1,3),_nEmb,.F.})
				_nQtdNF -= _nEmb
			Else
				AADD(_oGetDados:aCols,{StrZero(Len(_oGetDados:aCols)+1,3),_nQtdNF,.F.})
				_nQtdNF := 0
			EndIf
		Next _nX
	EndIf

	_oGetDados:Refresh()

Return(lRet)

//-----------------------------------------------------

Static Function fHeader(hcAlias,_ahcCampos,hcNaoCampos)

	Local   haHeader    := {}
//Default hcCampos    := ""
//Default _ahcCampos  := {}
	Default hcNaoCampos := ""

// Montagem do aHeader

	For _nX:=1 To Len(_ahcCampos)

		SX3->(dbSetOrder(2))
		SX3->(dbSeek(_ahcCampos[_nX][1]))

		//While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
		//If ((((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
			//.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)

		If ((((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)) ) .Or. AllTrim(SX3->X3_CAMPO) $ _ahcCampos[_nX][1]);
				.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)

			aAdd(haHeader, {	AllTrim(X3Titulo())	,;
				SX3->X3_CAMPO		   ,;
				SX3->X3_PICTURE		,;
				SX3->X3_TAMANHO		,;
				SX3->X3_DECIMAL		,;
				SX3->X3_VALID		   ,;
				SX3->X3_USADO		   ,;
				SX3->X3_TIPO		   ,;
				SX3->X3_F3			   ,;
				SX3->X3_CONTEXT		,;
				SX3->X3_CBOX	   	,;
				SX3->X3_RELACAO		,;
				SX3->X3_WHEN	   	,;
				SX3->X3_VISUAL	   	,;
				SX3->X3_VLDUSER		,;
				SX3->X3_PICTVAR		,;
				SX3->X3_OBRIGAT		})
		EndIf
		//	SX3->(DbSkip())
		//End
	Next
Return haHeader

//-----------------------------------------------------

Static Function faCols(haHeader,hcAlias,haCampo,hnQtdLin,hcOpc,hcOrdSeek,hcCndSeek,hcCpoSeek,_ahcCampos,hcNaoCampos)

	Local k := 0
	Local x := 0
	Local y := 0
	Local haCol := {}
	Local lFoiTratado := .F.
//Default hcCampos  := ""
	Default hcNaoCampos := ""

	If hcOpc == 3
		// Montagem do aCols em Branco
		For y := 1 To hnQtdLin

			AADD(haCol,Array(Len(haHeader)+1))
			nLin	:= Len(haCol)
			x	:= 1

			For _nX:=1 To Len(_ahcCampos)
				SX3->(DbSetOrder(2))
				SX3->(DbSeek(_ahcCampos[_nX][1]))
				//While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
				If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL)) .Or. AllTrim(SX3->X3_CAMPO) $ _ahcCampos[_nX][1]);
						.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
					lFoiTratado := .F.
					For k := 1 To Len(haCampo)
						If haCampo[k,1] $ SX3->X3_CAMPO .And. !haCampo[k,3]
							haCol[nLin,x] := haCampo[k,2]
							haCampo[k,3]  := .T.
							lFoiTratado   := .T.
							k := Len(haCampo)
						EndIf
					Next k
					If !lFoiTratado
						If Empty(SX3->X3_RELACAO)
							haCol[nLin,x] := CriaVar(SX3->X3_CAMPO)
						Else
							haCol[nLin,x] := &(SX3->X3_RELACAO)
						EndIf
					EndIf
					x += 1
				EndIf
				SX3->(DbSkip())
				//End
			Next

			haCol[nLin,Len(haHeader)+1] := .F.

		Next y
	Else
		// Montagem do aCols com registros caso tenha
		DbSelectArea(hcAlias)
		DbSetOrder(hcOrdSeek)
		If DbSeek(&(hcCndSeek))
			While !EOF() .And. &(hcCndSeek) == &(hcCpoSeek)

				AADD(haCol,Array(Len(haHeader)+1))
				nLin	:= Len(haCol)

				x := 1
				SX3->(DbSetOrder(1))
				SX3->(DbSeek(hcAlias))
				While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
					If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ).Or. AllTrim(SX3->X3_CAMPO) $ hcCampos);
							.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
						If SX3->X3_CONTEXT == "V"
							haCol[nLin,x] := &(SX3->X3_RELACAO)
						Else
							haCol[nLin,x] := &(SX3->X3_CAMPO)
						EndIf
						x += 1
					EndIf
					SX3->(DbSkip())
				End

				haCol[nLin,Len(haHeader)+1] := .F.
				DbSkip()
			End
		Else
			AADD(haCol,Array(Len(haHeader)+1))
			nLin	:= Len(haCol)
			x	:= 1

			SX3->(DbSetOrder(1))
			SX3->(DbSeek(hcAlias))
			While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == hcAlias
				If (((X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. Empty(hcCampos) ) .Or. AllTrim(SX3->X3_CAMPO) $ hcCampos) ;
						.And. !(AllTrim(SX3->X3_CAMPO) $ hcNaoCampos)
					lFoiTratado := .F.
					For k := 1 To Len(haCampo)
						If haCampo[k,1] $ SX3->X3_CAMPO .And. !haCampo[k,3]
							haCol[nLin,x] := haCampo[k,2]
							haCampo[k,3]  := .T.
							lFoiTratado   := .T.
							k := Len(haCampo)
						EndIf
					Next k
					If !lFoiTratado
						If Empty(SX3->X3_RELACAO)
							haCol[nLin,x] := CriaVar(SX3->X3_CAMPO)
						Else
							haCol[nLin,x] := &(SX3->X3_RELACAO)
						EndIf
					EndIf
					x += 1
				EndIf
				SX3->(DbSkip())
			End

			haCol[nLin,Len(haHeader)+1] := .F.
		EndIf
	EndIf

Return haCol

//-----------------------------------------------------

User Function fOkCampo()

	_nQtdDigit := 0
	For _nX := 1 to Len(_oGetDados:aCols)
		If _nX <> n
			_nQtdDigit += _oGetDados:aCols[_nX,2]
		Else
			_nQtdDigit += M->XD1_QTDATU
		EndIf
	Next _nX

	oQtdEtq:Refresh()

Return .T.

Static Function FatuQtdDig()

	_nQtdDigit := 0
	For _nX := 1 to Len(_oGetDados:aCols)
		_nQtdDigit += _oGetDados:aCols[_nX,2]
	Next _nX

	oQtdEtq:Refresh()

Return
