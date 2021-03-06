#include "TbiConn.ch"
#include "TbiCode.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"
//TESTE

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMACD01  �Autor  �Microsiga           � Data �  02/20/13   ���l
�������������������������������������������������������������������������͹��
���Desc.     � Endere�amento pelo coletor de materiais recebidos e com    ���
���          � etiqueta impressa.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Wederson L. Santana - OpusVp - 18/03/2013                                                                                                      //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Espec�fico RosenBerger Domex - ACD - Automa��o e Coleta de dados.                                                                              //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Inclus�o da fun��o fOkLocaliz().                                                                                                               //
//Inclus�o da fun��o fOkEnd().                                                                                                                   //
//Todos os produtos dever�o passar pela avalia��o do CQ.                                                                                         //
//-----------------------------------------------------------------------------------------------------------------------------------------------//

User Function DOMACW01()

	Private cTM         := GetMV("MV_PLTMTMP")
//Private bFocoBotao:= .F.
	Private cNumPeca    := Space(12)
	Private cNumPV      := Space(06)
	Private cNumItPV    := Space(02)
	Private cCodCli     := ''
	Private cNomeCli    := ''
	Private nOpca       := 0
	Private cProduto    := ''
	Private aPecas      := {}
	Private nPecas      := 0
//Private nPesoT    := 0
	Private cPrimProd   := ''
//Private cFilSC5   := If(SM0->M0_CODFIL=='04','01',SM0->M0_CODFIL)  //SC5->( xFilial() )
//Private cFilSC6   := If(SM0->M0_CODFIL=='04','01',SM0->M0_CODFIL)  //SC6->( xFilial() )
	Private cFilSC5     := SC5->( xFilial() )
	Private cFilSC6     := SC6->( xFilial() )
//Private bValidFat := .T.
//Private bLimSepa  := .F.   // Flag de limita��o de separa��o de pe�as para a quantidade do pedido (23/06/10)
	Private bMsgPVAtend := .T.   // Flag para dar mensagem de Pedido atendido somente uma vez, pq sem o flag, para cada pe�a bipada a mais da quantidade do pedido, seria dada a mensagem de pedido atendido.
	Private cAlias      := ''
	Private cMarca		  := ''
	Private oMark
	Private oOP

	Private _nTamEtiq   := 12  //21
	Private _cEndereco  := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
	Private _cEtiqueta  := Space(_nTamEtiq)
	Private _cUltEtiq   := Space(_nTamEtiq)
	Private _nSaldo     := 0

	Private _oEndereco
	Private _oEtiqueta

	Private _cCodPro    := ""
	Private _oCodPro

	Private _cDesPro    := ""
	Private _oDesPro

	Private _cCodFor    := ""
	Private _oCodFor

	Private _cLojFor    := ""
	Private _oLojFor

	Private _cDoc       := ""
	Private _oDoc

	Private _cSerie     := ""
	Private _oSerie

	Private _cLote      := ""
	Private _oLote

	Private _nQtdOri    := 0
	Private _oQtdOri

	Private oMaterial
	Private cMaterial   := Space(16)
	Private oEndereco
	Private cEndereco   := Space(16)
	Private oQuantidade
	Private nQuantidade := 0

	Private _nQtdLibCQ  := 0
	Private _cNumDoc    := CriaVar("DA_DOC")
	Private _cSerie     := CriaVar("DA_SERIE")
	Private _cCounter   := StrZero(0,TamSx3('DB_ITEM')[1])
	Private _cEndSBE    := ""

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
	Private oMainEti
	Private nWebPx:= 1.5 

	Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
	"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
	"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
	"background-repeat:no-repeat ;border-radius: 6px;}"

	Processa({ || ProcRun() })

Return

//----------------------------------

Static Function ProcRun()

Local cTitulo:=  ""

if cFilAnt == "01"
	cTitulo:= "01-Endere�amento Recebimento"
ElseIf cFilAnt == '02'
	cTitulo:= "02-Endere�a Rec.MG"
Endif

	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi(cTitulo) FROM 0,0 TO 450,302 PIXEL of oMainWnd PIXEL

	@ 005, 008	SAY oTexto1   VAR OemToAnsi('Endere�o destino:')  PIXEL SIZE 180*nWebPx,15*nWebPx
	oTexto1:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 015*nWebPx, 008 MSGET _oEndereco VAR _cEndereco  Picture "@!"  SIZE 85*nWebPx,12*nWebPx Valid ValidaEnd() PIXEL
	_oEndereco:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)

	@ 030*nWebPx, 008	SAY oTexto1   VAR OemToAnsi("Etiqueta:")  PIXEL SIZE 180*nWebPx,15*nWebPx
	oTexto1:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 040*nWebPx, 008 MSGET _oEtiqueta VAR _cEtiqueta  Picture "@!"  SIZE 85*nWebPx,12*nWebPx Valid ValidaEtiq() PIXEL
	_oEtiqueta:oFont := TFont():New('Courier New',,25*nWebPx,,.T.,,,,.T.,.F.)

	@ 055*nWebPx, 008	SAY oTexto3   VAR 'Ultima Etiq.: ' + _cUltEtiq  PIXEL SIZE 160*nWebPx,13*nWebPx
	oTexto3:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 065*nWebPx, 008	SAY oTexto3   VAR 'Saldo a endere�ar: '+Transform(_nSaldo,"@E 9,999,999")  PIXEL SIZE 160*nWebPx,13*nWebPx
	oTexto3:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 075*nWebPx, 008	SAY _oCodPro   VAR "C�digo: " + _cCodPro  PIXEL SIZE 160*nWebPx,13*nWebPx
	_oCodPro:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 084*nWebPx, 008	SAY _oDescPro  VAR "Desc.:   " + _cDesPro  PIXEL SIZE 100*nWebPx,20*nWebPx
	_oDescPro:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 101*nWebPx, 008	SAY _oDoc   VAR "NF.: " + _cDoc + "         S�rie: " + _cSerie  PIXEL SIZE 100*nWebPx,20*nWebPx
	_oDoc:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 111*nWebPx, 008	SAY _oLote   VAR "Lote.: " + _cLote   PIXEL SIZE 100*nWebPx,20*nWebPx
	_oLote:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 121*nWebPx, 008	SAY _oQtd   VAR "Qtd. Orig.: " + Transform(_nQtdOri,"@E 999,999.999")   PIXEL SIZE 100*nWebPx,20*nWebPx
	_oQtd:oFont := TFont():New('Arial',,19*nWebPx,,.T.,,,,.T.,.F.)

	@ 131*nWebPx,050 BUTTON _oBtn PROMPT "Fechar" Size 40*nWebPx,13*nWebPx Action Close(oDlg1) Pixel
	cCSSBtN1 := "QPushButton{"+cPush+;
	"QPushButton:pressed {"+cPressed+;
	"QPushButton:hover {"+cHover
	_oBtn:setCSS(cCSSBtN1)

	ACTIVATE MSDIALOG oDlg1

Return

//--------------------------------------------



Static Function ValidaEnd()
	Local _lRet := .T.

	If !Empty(_cEndereco)
	_cEndereco:= Alltrim(_cEndereco)
		//dbSelectArea("SBE")
		//If Type("BE_MSBLQL") <> 'U'
		SBE->( dbSetOrder(1) )
		If SBE->( dbSeek( xFilial() + Subs(_cEndereco,1,17) ) )
			If SBE->BE_MSBLQL == '1'
				U_MsgColetor('Endere�o bloqueado para uso.')
				_cEndSBE := ""
				_lRet    := .F.
			Else
				If Alltrim(M->DB_LOCALIZ) == '01CORTE' .or. Alltrim(M->DB_LOCALIZ) == '01PRODUCAO'
					U_MsgColetor("2-Endere�o permitido apenas pela ferramenta de entrega de material para produ��o")
					_lRet := .F.
				Else
					_cEndSBE :=SBE->BE_LOCALIZ
				EndIf
			EndIf
			//EndIf
		Else
			_lRet := .F.
			U_MsgColetor('Endere�o inv�lido.')
		EndIf
	EndIf

Return(_lRet)

//----------------------------------------------------

Static Function AlertC(cTexto)
	Local aTemp := U_QuebraString(cTexto,20)
	Local cTemp := ''

	For x := 1 to Len(aTemp)
		cTemp += aTemp[x] + Chr(13)
	Next x

	cTemp += 'Continuar?'

	While !apMsgNoYes( cTemp )
	End

Return

//----------------------------------------

Static Function ValidaEtiq()
	Local _Retorno := .F.

	If !(ValidaEnd())
		Return .F.
	EndIf

	If EMPTY(_cEtiqueta)
		Return .F.
	Else
		_cEtiqueta:= alltrim(_cEtiqueta)
	EndIf


	If dDataBase <> Date()
		dDataBase := Date()
	EndIf

	If Len(AllTrim(_cEtiqueta))<=12 //EAN 13 s/ d�gito verificador.
		_cEtiqueta := "0"+_cEtiqueta
		_cEtiqueta := Subs(_cEtiqueta,1,12)
	EndIf

	If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ d�gito verificador.
		_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
	EndIf

	_oEtiqueta:Refresh()

	If !Empty(_cEtiqueta)
		dbSelectArea("XD1")
		dbSetOrder(1)
		If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )
			If !Empty(XD1->XD1_QTDORI)
				If Alltrim(XD1->XD1_LOCALI) == Alltrim(Subs(_cEndereco,3))
					U_MsgColetor("O material j� se encontra neste endere�o.")
					_cEtiqueta  := Space(_nTamEtiq)
				Else
					SB1->( dbSetOrder(1) )
					If SB1->( dbSeek( xFilial("SB1") + XD1->XD1_COD) )
						_lOk :=.T.
						If SB1->B1_LOCPAD == '02'
							SBE->(dbSetOrder(1))
							If! SBE->(dbSeek(xFilial("SBE")+SB1->B1_LOCPAD+AllTrim(Subs(_cEndereco,3))))
								U_MsgColetor('N�o encontrado o endere�o '+AllTrim(Subs(_cEndereco,3))+' para o estoque '+SB1->B1_LOCPAD+'.')
								_cEtiqueta  := Space(_nTamEtiq)
								_lOk :=.F.
							EndIf
						EndIf
						If _lOk
							If XD1->XD1_OCORRE == '2'
								U_MsgColetor('Etiqueta n�o liberada pelo CQ.')
								_cEtiqueta  := Space(_nTamEtiq)
							Else
								If XD1->XD1_OCORRE == '4'
									U_MsgColetor('Etiqueta j� endere�ada no '+XD1->XD1_LOCALI)
									_cEtiqueta  := Space(_nTamEtiq)
								Else
									If XD1->XD1_OCORRE == '5'
										If U_uMsgYesNo('Etiqueta zerada. Deseja corrigir?')
											fTelaEti()
										Else
											_cEtiqueta  := Space(_nTamEtiq)
											_oEtiqueta:Refresh()
											_Retorno := .F.
										EndIf
									Else
										If XD1->XD1_OCORRE $ ('3')
											If Alltrim(XD1->XD1_LOCAL) <> Alltrim(Subs(_cEndereco,1,2))
												U_MsgColetor("N�o � poss�vel endere�ar um material que esteja no almoxarifado '" + XD1->XD1_LOCAL + "' em um endere�o iniciado em '"+Subs(_cEndereco,1,2)+"'.")
												//_cEtiqueta  := Space(_nTamEtiq)
											Else
												dbSelectArea("SD1")
												dbSetOrder(1)
												If SD1->( dbSeek( xFilial() + XD1->XD1_DOC + XD1->XD1_SERIE + XD1->XD1_FORNEC + XD1->XD1_LOJA + XD1->XD1_COD + XD1->XD1_ITEM ) )
													If !Empty( SD1->D1_TES )
														dbSelectArea("SF4")
														dbSetOrder(1)
														If dbSeek( xFilial("SF4") + SD1->D1_TES )
															If SF4->F4_ESTOQUE == 'S'
																If SD1->D1_LOCAL == GetMV("MV_CQ")
																	// Se o Produto foi para CQ
																	SD7->( dbSetOrder(3) )
																	If SD7->(dbSeek(xFilial("SD7")+SD1->D1_COD+SD1->D1_NUMSEQ))
																		_lRet     := .F.
																		_cNumero  := SD7->D7_NUMERO
																		_cProduto := SD7->D7_PRODUTO
																		_cLocal   := SD7->D7_LOCAL
																		SD7->(dbSetOrder(1))
																		If SD7->(dbSeek(xFilial("SD7")+_cNumero+_cProduto+_cLocal))
																			While xFilial("SD7")+_cNumero+_cProduto+_cLocal == SD7->(D7_FILIAL+ D7_NUMERO+ D7_PRODUTO+ D7_LOCAL)
																				If Empty(SD7->D7_ESTORNO)
																					If SD7->D7_TIPO == 1
																						//fOkEnd()
																						_lRet :=.T.
																						Exit
																					EndIf
																				EndIf
																				SD7->(dbSkip())
																			End
																			If! _lRet
																				U_MsgColetor("N�o liberado pelo CQ.")
																				_cEtiqueta  := Space(_nTamEtiq)
																			EndIf
																		Else
																			U_MsgColetor("N�o encontrada refer�ncia no CQ.")
																			_cEtiqueta  := Space(_nTamEtiq)
																		EndIf
																	Else
																		U_MsgColetor("N�o encontrado no CQ.")
																		_cEtiqueta  := Space(_nTamEtiq)
																	EndIf
																Else
																	// Se o produto n�o foi para cq
																	_aCabSDA    := {}
																	_aItSDB     := {}
																	_aItensSDB  := {}
																	lMsErroAuto := .F.
																	_cItem      := StrZero(1,4)
																	_cNumseq    := ""
																	_aAreaEnd   := {}

																	_cLote := ""
																	If Rastro(SD1->D1_COD)//Rastro(SD7->D7_PRODUTO,'S') Sub lote
																		_cLote := If(Empty(XD1->XD1_LOTECT),"LOTE1308",XD1->XD1_LOTECT)
																	EndIf

																	//Busca no SDA registro com saldo.
																	dbSelectArea("SDA")
																	dbGotop()
																	dbSetOrder(1)
																	If dbSeek( xFilial("SDA") + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ )
																		//	If SDA->DA_SALDO > 0
																		//		_cNumSeq := SDA->DA_NUMSEQ
																		//	EndIf
																		//	dbSkip()
																		//End
																	Else
																		U_MsgColetor('N�o encontrado o SDA da NF.')
																	EndIf

																	//Busca o pr�ximo item no SDB.
																	dbSelectArea("SDB")
																	SDB->( dbSetOrder(1))
																	If dbSeek( xFilial("SDB") + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ )
																		While SDB->DB_PRODUTO + SDB->DB_LOCAL + SDB->DB_NUMSEQ == SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ
																			_cItem := DB_ITEM
																			SDB->( dbSkip() )
																		End
																		_cItem:=StrZero(Val(_cItem)+1,4)
																	EndIf

																	// Endere�amento Autom�tico
																	dbSelectArea("SDA")
																	dbGotop()
																	dbSetOrder(1)
																	If dbSeek( xFilial("SDA") + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ )

																		If dDataBase <> Date()
																			dDataBase := Date()
																		EndIf

																		If SDA->DA_SALDO >= XD1->XD1_QTDORI
																			_aCabSDA := {{"DA_PRODUTO" ,SDA->DA_PRODUTO,Nil},;
																				{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ ,Nil}}

																			_aItSDB  := {;
																			    {"DB_ITEM"	  ,_cItem	       ,Nil},;
																				{"DB_ESTORNO" ," "	           ,Nil},;
																				{"DB_LOCALIZ" ,_cEndSBE        ,Nil},;
																				{"DB_DATA"	  ,SDA->DA_DATA    ,Nil},;
																				{"DB_XXPECA"  ,_cEtiqueta      ,Nil},;
																				{"DB_LOTECTL" ,_cLote          ,Nil},;
																				{"DB_QUANT"   ,XD1->XD1_QTDORI ,Nil}}

																			aadd(_aItensSDB,_aitSDB) //Executa o endere�amento do item

																			_aAreaEnd := GetArea()

																			MATA265( _aCabSDA, _aItensSDB, 3)

																			RestArea(_aAreaEnd)
																			// 000076863271
																			If lMsErroAuto
																				MostraErro("\UTIL\LOG\Endereca_Coletor\")
																				//DisarmTransaction()
																				U_MsgColetor("Erro na grava��o do endere�amento.")
																			EndIf



																			If! lMsErroAuto
																				_cCodPro    := XD1->XD1_COD
																				_cDesPro    := SB1->B1_DESC
																				_cCodFor    := XD1->XD1_FORNECE
																				_cLojFor    := XD1->XD1_LOJA
																				_cDoc       := XD1->XD1_DOC
																				_cSerie     := XD1->XD1_SERIE
																				_cLote      := XD1->XD1_LOTECTL
																				_nQtdOri    := XD1->XD1_QTDORI
																				//_Retorno    := .T.

																				oDlg1:Refresh()

																				Reclock("XD1",.F.)
																				XD1->XD1_LOCAL  := Subs(_cEndSBE,1,2)
																				XD1->XD1_LOCALI := _cEndSBE
																				XD1->XD1_OCORRE := '4'  // Etiqueta j� endere�ada
																				XD1->( msUnlock() )

																				_nSaldo    := SDA->DA_SALDO
																				_cUltEtiq  := Str(Val(Subs(_cEtiqueta,1,13)))
																				_cEtiqueta := Space(_nTamEtiq)

																				_Retorno := .F.  // o SetFocus n�o est� funcionando

																				_oEtiqueta:SetFocus()
																			Else
																				U_MsgColetor('Erro no endere�amento!')
																			EndIf
																		Else
																			U_MsgColetor('Saldo para endere�amento ('+Alltrim(Transform(SDA->DA_SALDO,'@E 999,999,999.9999'))+') inferior a quantidade da etiqueta ('+Alltrim(Transform(XD1->XD1_QTDORI,'@E 999,999,999.9999'))+') ('+SDA->DA_DOC+').')
																		EndIf
																	Else
																		U_MsgColetor("Pend�ncia de endere�amento n�o encontrada para esta NF.")
																	EndIf
																EndIf
															Else
																U_MsgColetor('Erro na classifica��o da NF. A TES : ' + SD1->D1_TES + ' n�o atualiza estoque.' )
																_cEtiqueta  := Space(_nTamEtiq)
															EndIf
														EndIf
													Else
														U_MsgColetor("Documento n�o classificado.")
														// Nf n�o classificada
														Reclock("XD1",.F.)
														XD1->XD1_LOCALI := _cEndSBE
														XD1->( MsUnLock() )
														_cEtiqueta  := Space(_nTamEtiq)
													EndIf
												Else
													U_MsgColetor("Item "+XD1->XD1_ITEM+"-"+XD1->XD1_COD+" n�o encontrado na NF "+XD1->XD1_DOC)
													_cEtiqueta  := Space(_nTamEtiq)
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						oDlg1:Refresh()
					EndIf
				EndIf
			Else
				U_MsgColetor("Etiqueta com quantidade zero. Emitir a etiqueta novamente.")
				_Retorno := .F.
			EndIf
		Else
			U_MsgColetor('C�dido de Etiqueta inv�lido.')
			_cEtiqueta  := Space(_nTamEtiq)
			_Retorno := .F.
		EndIf
		//_oEndereco:SetFocus()
		_oEtiqueta:SetFocus()  // Esse setfocus n�o est� funcionando
		//U_MsgColetor("SetFocus")
	Else
		_Retorno := .T.
	EndIf



//If Empty(_cEtiqueta)
//   Return .T.
//Else
//   Return .F.
//Endif

//If !_Retorno
	_cEtiqueta  := Space(_nTamEtiq)
	_oEtiqueta:Refresh()
//Endif

Return _Retorno

//------------------------------Wederson OpusVp

Static Function fOkEnd()
	Local _aCabSDA    :={}
	Local _aItSDB     :={}
	Local _aItensSDB  :={}
	Local	lMsErroAuto :=.F.
	Local _cItem      :=StrZero(1,4)
	Local _cNumseq    :=""
	Local _aAreaEnd   :={}

	If dDataBase <> Date()
		dDataBase := Date()
	EndIf

	_cLote :=""
	If Rastro(SD7->D7_PRODUTO)//Rastro(SD7->D7_PRODUTO,'S') Sub lote
		_cLote:=If(Empty(XD1->XD1_LOTECT),"LOTE1308",XD1->XD1_LOTECT)
	EndIf

//Busca no SDA registro com saldo.
	dbSelectArea("SDA")
	dbGotop()
	dbSetOrder(1)
	If dbSeek( xFilial("SDA") + SD7->D7_PRODUTO + SD7->D7_LOCDEST + SD7->D7_NUMSEQ )
		While xFilial("SDA") + SD7->(D7_PRODUTO + D7_LOCDEST + D7_NUMSEQ) == SDA->(DA_FILIAL+DA_PRODUTO+DA_LOCAL+DA_NUMSEQ)
			If SDA->DA_SALDO > 0
				_cNumSeq:=SDA->DA_NUMSEQ
			EndIf
			dbSkip()
		End
	EndIf

//Busca o pr�ximo item no SDB.
	dbSelectArea("SDB")
	dbGotop()
	dbSetOrder(1)
	If dbSeek( xFilial("SDB") + SD7->(D7_PRODUTO + D7_LOCDEST)+_cNumSeq)
		While xFilial("SDB") + SD7->(D7_PRODUTO + D7_LOCDEST)+_cNumSeq == DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ
			_cItem:=DB_ITEM
			dbSkip()
		End
		_cItem:=StrZero(Val(_cItem)+1,4)
	EndIf

// Endere�amento Autom�tico
	dbSelectArea("SDA")
	dbGotop()
	dbSetOrder(1)
	If dbSeek( xFilial("SDA") + SD7->(D7_PRODUTO + D7_LOCDEST)+_cNumSeq)
		If SDA->DA_SALDO >= XD1->XD1_QTDORI

			If dDataBase <> Date()
				dDataBase := Date()
			EndIf

			nSalDAantes := SDA->DA_SALDO

			_aCabSDA := {{"DA_PRODUTO" ,SDA->DA_PRODUTO,Nil},;
				{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ ,Nil}}

			_aItSDB  := {;
				{"DB_ITEM"	  ,_cItem	       ,Nil},;
				{"DB_ESTORNO" ," "	           ,Nil},;
				{"DB_LOCALIZ" ,_cEndSBE        ,Nil},;
				{"DB_DATA"	  ,SDA->DA_DATA    ,Nil},;
				{"DB_XXPECA"  ,_cEtiqueta      ,Nil},;
				{"DB_LOTECTL" ,_cLote          ,Nil},;
				{"DB_QUANT"   ,XD1->XD1_QTDORI ,Nil} }

			//000076863271
			aadd(_aItensSDB,_aitSDB) //Executa o endere�amento do item

			_aAreaEnd := GetArea()

			MATA265( _aCabSDA, _aItensSDB, 3)

			RestArea(_aAreaEnd)

			If lMsErroAuto
				MostraErro("\UTIL\LOG\Endereca_Coletor\")
				//DisarmTransaction()
				U_MsgColetor("Erro na grava��o do endere�amento.")
			EndIf



			If! lMsErroAuto
				_cCodPro    := XD1->XD1_COD
				_cDesPro    := SB1->B1_DESC
				_cCodFor    := XD1->XD1_FORNECE
				_cLojFor    := XD1->XD1_LOJA
				_cDoc       := XD1->XD1_DOC
				_cSerie     := XD1->XD1_SERIE
				_cLote      := XD1->XD1_LOTECTL
				_nQtdOri    := XD1->XD1_QTDORI
				_Retorno    := .T.

				oDlg1:Refresh()

				If nSalDAantes <> SDA->DA_SALDO
					Reclock("XD1",.F.)
					XD1->XD1_LOCALI := _cEndSBE
					XD1->XD1_OCORRE := '4'  // Etiqueta j� endere�ada
					XD1->( msUnlock() )
				Else
					U_MsgColetor("Ocorreu um erro indeterminado no endere�amento. Favor comunicar a TI.")
				EndIf

				_nSaldo    := SDA->DA_SALDO
				_cUltEtiq  := Str(Val(Subs(_cEtiqueta,1,13)))
				_cEtiqueta := Space(_nTamEtiq)
			EndIf
		Else
			U_MsgColetor('Saldo para endere�amento ('+Alltrim(Transform(SDA->DA_SALDO,'@E 999,999,999.9999'))+') inferior a quantidade da etiqueta ('+Alltrim(Transform(XD1->XD1_QTDORI,'@E 999,999,999.9999'))+') ('+SDA->DA_DOC+').')
		EndIf
	Else
		U_MsgColetor(" Pend�ncia de endere�amento n�o encontrada para esta NF.")
	EndIf

Return()

Static Function fTelaEti()
	Private _lReturn:=.T.

	_cNumEti  :=XD1->XD1_XXPECA
	_cProdEti :=XD1->XD1_COD
	_nQtdEti  :=XD1->XD1_QTDATU
	_cEndeEti :=XD1->XD1_LOCALI
	_cDescEti :=""

	SB1->(dbSetOrder(1))
	SB1->(dbGotop())
	If SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
		_cDescEti := SB1->B1_DESC
	EndIf

	SB2->( dbSetOrder(1) )
	If !SB2->( dbSeek( xFilial() + XD1->XD1_COD + XD1->XD1_LOCAL ) )
		U_MsgColetor("SB2 n�o encontrado.")
	EndIf

	Define MsDialog oTelaEti Title OemToAnsi("Corre��o Etiqueta") From 0,0 To 293,233 Pixel of oMainEti PIXEL

	nLin := 005
	@ nLin,005 Say oTxtEti     Var "Etiqueta " Pixel Of oTelaEti
	@ nLin-2,045 MsGet oGetEti Var _cNumEti When .F. Size 70*nWebPx,10*nWebPx Pixel Of oTelaEti

	oTxtEti:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetEti:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	@ 018,001 To 057,115 Pixel Of oMainEti PIXEL

	@ 020,005 Say oTxtLabel    Var "Dados da Etiqueta" Pixel Of oTelaEti
	@ 027,005 Say oTxtProdEti  Var "C�digo: "   + _cProdEti Pixel Of oTelaEti
	@ 027,077 Say oTxtQtdEti   Var "Qtd: "      + TransForm(_nQtdEti,"@E 999,999.99") Pixel Of oTelaEti
	@ 033,005 Say oTxtDescEti  Var "Descri��o: "+ _cDescEti Size 110*nWebPx,15*nWebPx Pixel Of oTelaEti
	@ 048,005 Say oTxtEndeEti  Var "Endere�o: " + _cEndeEti Pixel Of oTelaEti

	oTxtLabel  :oFont := TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
	oTxtProdEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtDescEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtEndeEti:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oTxtQtdEti :oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

	nLin+= 60
	@ nLin  ,005 Say oTxtQtdEti    Var "Quantidade " Pixel Of oTelaEti
	@ nLin-2,045 MsGet oGetQtdEti  Var _nQtdEti Valid fQtdEti() Picture "@E 9,999,999.99" Size 70*nWebPx,10*nWebPx  Pixel Of oTelaEti
	oTxtQtdEti:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
	oGetQtdEti:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

	nLin+= 20
	@ nLin,070 Button "Cancelar" Size 40*nWebPx,15*nWebPx Action Close(oTelaEti) Pixel Of oTelaEti

	Activate MsDialog oTelaEti

Return(_lReturn)

//--------------------------------------------------------------------

Static Function fQtdEti()
	Close(oTelaEti)
	If _nQtdEti >0
		If _nQtdEti <= SB2->B2_QATU
			DbSelectArea("XD1")
			Reclock("XD1",.F.)
			XD1->XD1_QTDATU := _nQtdEti
			XD1->XD1_OCORRE := "3"
			XD1->( MsUnlock() )
		Else
			U_MsgColetor("N�o foi poss�vel realizar o ajuste .Saldo atual :"+TransForm(SB2->B2_QATU,"@E 999,999.99")+".")
			_cEtiqueta := Space(_nTamEtiq)
			_oEtiqueta:Refresh()
			_lReturn   :=.F.
		EndIf
	Else
		U_MsgColetor("Informe uma quantidade v�lida.")
	EndIf

Return 

