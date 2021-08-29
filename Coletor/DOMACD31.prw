#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD31  ºAutor  ³Michel A. Sander    º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Entrega de bobinas de fibra para a produção                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACD31()

Private oTxtEnd,oGetEnd,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark
Private _nTamEtiq      := 21
Private _cEndOrig      := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
Private _cEndDest      := Space(Len(CriaVar("BE_LOCALIZ",.F.))+3)
Private _cEtiqueta     := Space(_nTamEtiq)//Space(Len(CriaVar("XD1_XXPECA",.F.)))
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _cOcorre       := CriaVar("XD1_OCORRE",.F.)     //MLS   VERIFICAR OCORRENCIA/STATUS DA ETIQUETA
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _aCols         := {}
Private _cLocOrig      := CriaVar("B2_LOCAL")
Private _cLocDest      := CriaVar("B2_LOCAL")
Private nTxtQTDETQ     := 0
Private cLocProcDom    := GetMV("MV_XXLOCPR")
Private cLocProc		  := GetMv("MV_LOCPROC")
Private nFCICalc       := SuperGetMV("MV_FCICALC",.F.,0)

_cEndDest := PADR("01CORTE",15)
_cLocDest := "01"
_cLocOrig := "01"

DEFINE MSDIALOG oTrans TITLE OemToAnsi("Entrega de Bobina para Produção") FROM 0,0 TO 293,233 PIXEL OF oMainWnd PIXEL

@ 001,005 Say oTxtEnd    Var "Origem" Pixel Of oTrans
@ 001,045 MsGet oGetEnd  Var _cEndOrig When .T. Size 70,10 Valid ValidaOrig() Pixel Of oTrans
oTxtEnd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEnd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 016,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTrans
@ 016,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,10 Valid ValidaEtiq() Pixel Of oTrans
oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 031,005 Say oTxtEndDEST Var "Destino" Pixel Of oTrans
@ 031,045 MsGet oGetEndDEST  Var _cEndDest When .F. Valid fValEnd() Size 70,10 Pixel Of oTrans
oTxtEndDEST:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEndDEST:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 130,070 Say oTxtQTDETQ Var Transform(nTxtQTDETQ,"@E 999,999") Pixel Of oTrans
oTxtQTDETQ:oFont := TFont():New('Arial',,22,,.T.,,,,.T.,.F.)

fGetDados()

@ 130,005 Button "Confirma" Size 40,15 Action fOkProc() Pixel Of oTrans

ACTIVATE MSDIALOG oTrans

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fOkProc  ºAutor  ³Michel A. Sander    º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Confirma o processamento						                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fOkProc()

If Empty(_cEndDest)
	U_MsgColetor('Endereço de destino não preenchido.')
	Return
EndIf

If! Empty(_aCols)
	//Close(oTrans)
	fOkGrava()
	//If Select("TMP") > 0
	//	TMP->(dbCloseArea())
	//EndIf
	//fOkTela()
Else
	U_MsgColetor("Não existem informações para serem processadas.")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fOkGrava ºAutor  ³Michel A. Sander    º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa a transferência						                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fOkGrava()

Local _nTamEtiq   :=Len(CriaVar("XD1_XXPECA",.F.))
Local _nOpcAuto   := 3

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private _aEndereco  := {}
Private _aItem      := {}
Private _cDoc       := ''
Private lTRANSF     :=.F.
Private _aAuto      :={}
*********************************************************************************
PRIVATE cCusMed := GetMv("MV_CUSMED")
PRIVATE cCadastro:= OemToAnsi("Transfer^ncias")     //"Transfer^ncias"
PRIVATE aRegSD3 := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o custo medio e' calculado On-Line               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cCusMed == "O"
     PRIVATE nHdlPrv // Endereco do arquivo de contra prova dos lanctos cont.
     PRIVATE lCriaHeader := .T. // Para criar o header do arquivo Contra Prova
     PRIVATE cLoteEst      // Numero do lote para lancamentos do estoque
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Posiciona numero do Lote para Lancamentos do Faturamento     ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     dbSelectArea("SX5")
     dbSeek(xFilial()+"09EST")
     cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
     PRIVATE nTotal := 0      // Total dos lancamentos contabeis
     PRIVATE cArquivo     // Nome do arquivo contra prova
EndIf
*********************************************************************************

dbSelectArea("TMP")
dbGotop()

Do While !TMP->(EOF())
	
	_aAuto      :={}
	_aItem      :={}
	
	XD1->( dbSetOrder(1))
	XD1->( dbSeek( xFilial("XD1") + TMP->ETIQ ) )
	
	_cProduto := XD1->XD1_COD
	_cOcorre  := XD1->XD1_OCORRE
	
	If ALLTRIM(_cOcorre)<>'4'
		U_MsgColetor('Status diferente de 4, já utilizado, nao será transferido, Produto/Etiqueta: '+ALLTRIM(_cProduto)+'/'+ALLTRIM(TMP->ETIQ))
	Else
		
		SB1->( dbSeek( xFilial("SB1") + _cProduto) )
		If SUBSTR(SB1->B1_GRUPO,1,2) <> "FO"
			U_MsgColetor("O grupo de produto não corresponde a FIBRA")
			lTransf := .F.
			Exit
		EndIf
		
		CriaSB2(XD1->XD1_COD,SUBSTRING(_cEndDest,1,2) )
		
		_cDoc:= U_NEXTDOC()
		_cDoc:=_cDoc+SPACE(09)
		_cDoc:=SUBSTR(_cDoc,1,9)
		
		aadd(_aAuto,{_cDoc,dDataBase})
		
		_aItem := {}
		aadd(_aItem,XD1->XD1_COD)                           //Produto Origem
		aadd(_aItem,SB1->B1_DESC)                           //Descricao Origem
		aadd(_aItem,SB1->B1_UM)  	                        //UM Origem
		aadd(_aItem,XD1->XD1_LOCAL)                         //Local Origem
		aadd(_aItem,XD1->XD1_LOCALIZ)	                    //Endereco Origem
		aadd(_aItem,XD1->XD1_COD)                           //Produto Destino
		aadd(_aItem,SB1->B1_DESC)                           //Descricao Destino
		aadd(_aItem,SB1->B1_UM)  	                        //UM destino
		aadd(_aItem,_cLocDest)					            //Local Destino
		aadd(_aItem,_cEndDest)							    //Endereco Destino
		aadd(_aItem,"")                                     //Numero Serie
		aadd(_aItem,XD1->XD1_LOTECTL)	                    //Lote Origem
		aadd(_aItem,"")         	                        //Sub Lote Origem
		aadd(_aItem,CtoD("31/12/49"))	                    //Validade Lote Origem
		aadd(_aItem,0)		                                //Potencia
		aadd(_aItem,TMP->QTD)           	                //Quantidade
		aadd(_aItem,0)		                                //Quantidade 2a. unidade
		aadd(_aItem,"")   	                                //ESTORNO
		aadd(_aItem,"")         	                        //NUMSEQ
		aadd(_aItem,XD1->XD1_LOTECTL)	                    //Lote Destino
		aadd(_aItem,CtoD("31/12/49"))	                    //Validade Lote Destino
		aadd(_aItem,"")		                                //D3_ITEMGRD
		
		If nFCICalc == 1
			aadd(_aItem,0)                                      //D3_PERIMP
		ENDIF
		
		If GetVersao(.F.,.F.) == "12"
			//aAdd(_aItem,"")   //D3_IDDCF
			aAdd(_aItem,"")   //D3_OBSERVACAO
		EndIf
		aadd(_aAuto,_aItem)
		
		DbSelectArea("SB1")
		dbSetOrder(1)
		
		DbSelectArea("SD3")
		dbSetOrder(2)
		
		
		//	Sleep(13000)    // 3S
		
		***********************************************************************************************************************
		cCodOrig   := XD1->XD1_COD
		cLocOrig   := XD1->XD1_LOCAL
		nQuant260  := TMP->QTD
		cDocto     := _cDoc
		dEmis260   := DDATABASE
		nQuant260D := 0
		cNumLote   := ''
		cLoteDigi  := XD1->XD1_LOTECTL
		dDtValid   := CtoD("31/12/49")
		cNumSerie  := ''
		cLoclzOrig := XD1->XD1_LOCALIZ
		cCodDest   := XD1->XD1_COD
		cLocDest   := _cLocDest
		cLocLzDest := _cEndDest 
		cServico   := ''
		nPotencia  := 0
		cLoteDigiD := XD1->XD1_LOTECTL
		dDtVldDesT := CtoD("31/12/49")
		If a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,NIL,cLoteDigi,dDtValid,NIL,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,.F.,Nil,Nil,"MATA260",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,cLoteDigiD,NIL,nil,nil,.T.)
//		   a260Processa(cCodOrig,cLocOrig,nQuant260,cDocto,dEmis260,nQuant260D,cNumLote,cLoteDigi,dDtValid,cNumSerie,cLoclzOrig,cCodDest,cLocDest,cLocLzDest,lEstorno,nRecOrig,nRecDest,cPrograma,cEstFis,cServico,cTarefa,cAtividade,cAnomalia,cEstDest,cEndDest,cHrInicio,cAtuEst,cCarga,cUnitiza,cOrdTar,cOrdAti,cRHumano,cRFisico,nPotencia,cLoteDest,dDtVldDest ,cCAT83O, cCAT83D, lAtuSB2)
			//U_MsgColetor("Transferencia 005")
			SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
			If SD3->( dbSeek( xFilial() + _cDoc ) )
				While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)
					If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
						If SD3->D3_COD == XD1->XD1_COD
							If SD3->D3_EMISSAO == dDataBase
								If SD3->D3_QUANT == TMP->QTD
									If Empty(SD3->D3_XXOP)
										Reclock("SD3",.F.)
										SD3->D3_XXPECA  := XD1->XD1_XXPECA
										SD3->D3_USUARIO := cUsuario
										SD3->D3_HORA    := Time()
										SD3->( msUnlock() )
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					SD3->( dbSkip() )
				End
				Reclock("XD1",.F.)
				XD1->XD1_LOCAL   := _cLocDest
				XD1->XD1_LOCALIZ := _cEndDest
				XD1->( msUnlock() )
				_nQtd := 0
				lTRANSF:=.T.
			EndIf
		ELSE
		    U_MsgColetor("Erro na transferencia COD 005")
		ENDIF
		***********************************************************************************************************************		
		
        /*
		lMsErroAuto := .F.
		MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)  // Execauto de transferência
		
		If lMsErroAuto
			MostraErro("\UTIL\LOG\Transferencia_Endereco\")
			U_MsgColetor("Erro na transferencia 001")
			lTRANSF:=.F.
		Else
			SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
			If SD3->( dbSeek( xFilial() + _cDoc ) )
				While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)
					If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'
						If SD3->D3_COD == XD1->XD1_COD
							If SD3->D3_EMISSAO == dDataBase
								If SD3->D3_QUANT == TMP->QTD
									If Empty(SD3->D3_XXOP)
										Reclock("SD3",.F.)
										SD3->D3_XXPECA  := XD1->XD1_XXPECA
										SD3->D3_USUARIO := cUsuario
										SD3->D3_HORA    := Time()
										SD3->( msUnlock() )
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					SD3->( dbSkip() )
				End
				Reclock("XD1",.F.)
				XD1->XD1_LOCAL   := _cLocDest
				XD1->XD1_LOCALIZ := _cEndDest
				XD1->( msUnlock() )
				_nQtd := 0
				lTRANSF:=.T.
			EndIf
		EndIf
		*******************************************************************************************************************
		*/
	EndIf
	
	TMP->(DBSKIP())
	
EndDo

If lTRANSF
	U_MsgColetor("Transferencia efetuada")
	lTRANSF:=.F.
ELSE
	U_MsgColetor("Erro na transferencia 002")
	lTRANSF:=.F.
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fGetDadosºAutor  ³Michel A. Sander    º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta MarkBrowse									                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGetDados()

Local _aStru  := {}

If Select("TMP") > 0
	TMP->(dbCloseArea())
EndIf

AADD(_aStru, {"ETIQ"   ,"C",15,0} )
AADD(_aStru, {"QTD"    ,"N",14,2} )

_cArqTrab := CriaTrab(_aStru,.T.)

dbUseArea(.T.,__LocalDriver,_cArqTrab,"TMP",.F.)

IndRegua("TMP",_cArqTrab,"ETIQ",,,)

_aCampos := {}

AADD(_aCampos,{"ETIQ"        ,"" ,"Etiqueta"        ,"@R"              } )
AADD(_aCampos,{"QTD"         ,"" ,"Quant."          ,"@E 9,999,999.99" } )

oMark:= MsSelect():New("TMP",,,_aCampos,Nil,Nil,{46,00,127,117})
oMark:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
oMark:oBrowse:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
oMark:oBrowse:Refresh()

dbSelectArea("TMP")
dbGotop()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fValEnd  ºAutor  ³Michel A. Sander    º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validações de transferência					                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fValEnd()

Local _lRet:=.T.

IF SUBSTR(_cEndDest,1,2)==ALLTRIM(cLocProcDom) .OR. SUBSTR(_cEndDest,1,2)==ALLTRIM(cLocProc)  //97,99
	U_MsgColetor('Não permitido transferencia para local de processo.')
	Return .F.
ENDIF

IF SUBSTR(_cEndDest,1,2)=='13'               //13
	U_MsgColetor('Não permitido transferencia para local 13-Expedição.')
	Return .F.
ENDIF


SBE->( dbSetOrder(1) )
If SBE->( dbSeek( xFilial("SBE") + SUBS(_cEndDest,1,12)) )
	If SBE->BE_MSBLQL == '1'
		_lRet := .F.
		U_MsgColetor('Endereço bloqueado para uso.')
	EndIf
Else
	_lRet := .F.
	U_MsgColetor('Endereço não encontrado.')
EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidaEtiqºAutor  ³Michel A. Sander   º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Etiqueta									                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidaEtiq()

Local _lRet   :=.T.
Local _nSaldo := 0

If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ dígito verificador.
	_cEtiqueta := "0"+_cEtiqueta
	_cEtiqueta := Subs(_cEtiqueta,1,12)
EndIf

If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ dígito verificador.
	_cEtiqueta := Subs(AllTrim(_cEtiqueta),8,12)
EndIf

oTrans:Refresh()

If !Empty(_cEtiqueta)
	XD1->( dbSetOrder(1))
	If XD1->( dbSeek( xFilial("XD1") + _cEtiqueta ) )
		SB1->( dbSetOrder(1) )
		_cProduto := XD1->XD1_COD
		IF XD1->XD1_QTDATU<=0
			U_MsgColetor("Quantidade etiqueta zerado")
			RETURN
		ENDIF
		IF alltrim(XD1->XD1_LOCALI) <> Alltrim(Subs(_cEndOrig,3))
			U_MsgColetor("Endereço etiqueta diferente origem")
			RETURN
		ENDIF
		If SB1->( dbSeek( xFilial("SB1") + _cProduto) )
			If SB1->B1_LOCALIZ == 'S'
				If SB1->B1_RASTRO == 'L'
					If !Empty(XD1->XD1_LOCALI)
						If Len(_aCols)>0
							If aScan(_aCols,{ |x| Upper(AllTrim(x[1])) == Trim(_cEtiqueta) }) == 0   //Se a etiqueta não foi utilizada.
								
								AADD(_aCols,{_cEtiqueta,_nQtd})
								nTxtQTDETQ:=nTxtQTDETQ+1
								
								dbSelectArea("TMP")
								dbGotop()
								IF !EMPTY(_cEtiqueta)
									If! TMP->( dbSeek(_cEtiqueta) )
										Reclock("TMP",.T.)
										TMP->ETIQ := _cEtiqueta
										TMP->QTD  := _nQtd
										TMP->(MsUnLock())
									Else
										Reclock("TMP",.F.)
										TMP->QTD  := _nQtd
										TMP->(MsUnLock())
									EndIf
								ENDIF
								oMark:oBrowse:Refresh()
							Else
								_lRet:=.F.
								U_MsgColetor("Etiqueta  já utilizada !")
							EndIf
						Else
							SB2->(dbSetOrder(1))
							If SB2->(dbSeek(xFilial("SB2")+XD1->XD1_COD+XD1->XD1_LOCAL))
								// Validando se o produto tem divergência de SB2 para SBF
								If QtdComp(SB2->B2_QATU)-QtdComp(SB2->B2_QACLASS) # QtdComp(SaldoSBF(XD1->XD1_LOCAL,"",XD1->XD1_COD))
									U_MsgColetor("Divergência de Saldo Físico X Saldo por Endereço. Não será possível executar o processo.")
									_lRet:=.F.
									U_MsgColetor("Processo abortado.")
								Else
									_cProduto  := SB1->B1_COD
									_nQtd      := XD1->XD1_QTDATU
									_cLoteEti  := If(Empty(XD1->XD1_LOTECT),"LOTE1308",XD1->XD1_LOTECT)
									AADD(_aCols,{_cEtiqueta,_nQtd})
									nTxtQTDETQ:=nTxtQTDETQ+1
									
									dbSelectArea("TMP")
									dbGotop()
									IF !EMPTY(_cEtiqueta)
										If! TMP->( dbSeek(_cEtiqueta) )
											Reclock("TMP",.T.)
											TMP->ETIQ := _cEtiqueta
											TMP->QTD  := _nQtd
											TMP->(MsUnLock())
										Else
											Reclock("TMP",.F.)
											TMP->QTD  := _nQtd
											TMP->(MsUnLock())
										EndIf
									ENDIF
									
									oMark:oBrowse:Refresh()
								EndIf
							EndIf
						EndIf
					Else
						_lRet:=.F.
						U_MsgColetor("Etiqueta sem Endereço preenchido.")
					EndIf
				Else
					_lRet:=.F.
					U_MsgColetor("Produto sem controle de Lote.")
				EndIf
			Else
				_lRet:=.F.
				U_MsgColetor("Produto não controla por endereço.")
			EndIf
		Else
			_lRet:=.F.
			U_MsgColetor("Produto NÃO encontrado")
		EndIf
	Else
		_lRet:=.F.
		U_MsgColetor("Etiqueta não encontrada.")
	EndIf
	IF _lRet==.T.
		oMark:oBrowse:Refresh()
		_cEtiqueta:= Space(_nTamEtiq)
		oGetEtiq:Refresh()
		oTrans:Refresh()
		oGetEtiq:SetFocus()
	ENDIF
	
EndIf

If! _lRet
	_cEtiqueta:= Space(_nTamEtiq)
	_cProduto := CriaVar("B1_COD",.F.)
EndIf

oTxtQTDETQ:Refresh()
oTrans:Refresh()

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AlertC   ºAutor  ³Michel A. Sander    º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mensagem do Coletor								                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AlertC(cTexto)

Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.
LOCAL X     :=0

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

If !apMsgNoYes( cTemp )
	lRet:=.F.
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GuardaEmps  ºAutor  ³Michel A. Sander º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aguarda e atualiza empenho						                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GuardaEmps(cProduto,cLocal)
LOCAL X := 0

aEmpSB2 := {}
SB2->( dbSetOrder(1) )
If SB2->( dbSeek( xFilial() + cProduto + cLocal ) )
	If !Empty(SB2->B2_QEMP)
		AADD(aEmpSB2,{SB2->(Recno()),SB2->B2_QEMP})
	EndIf
EndIf

aEmpSBF := {}
SBF->( dbSetOrder(2) )
If SBF->( dbSeek( xFilial() + cProduto + cLocal ) )
	While !SBF->( EOF() ) .and. SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL == xFilial("SBF") + cProduto + cLocal
		If !Empty(SBF->BF_EMPENHO)
			AADD(aEmpSBF,{SBF->(Recno()),SBF->BF_EMPENHO})
		EndIf
		SBF->( dbSkip() )
	End
EndIf

aEmpSB8 := {}
SB8->( dbSetOrder(1) )
If SB8->( dbSeek( xFilial() + cProduto + cLocal ) )
	While !SB8->( EOF() ) .and. SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL == xFilial("SB8") + cProduto + cLocal
		If !Empty(SB8->B8_EMPENHO)
			AADD(aEmpSB8,{SB8->(Recno()),SB8->B8_EMPENHO})
		EndIf
		SB8->( dbSkip() )
	End
EndIf

For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := 0
	SB2->( msUnlock() )
Next x

For x := 1 to Len(aEmpSBF)
	SBF->( dbGoTo(aEmpSBF[x,1]) )
	Reclock("SBF",.F.)
	SBF->BF_EMPENHO := 0
	SBF->( msUnlock() )
Next x

For x := 1 to Len(aEmpSB8)
	SB8->( dbGoTo(aEmpSB8[x,1]) )
	Reclock("SB8",.F.)
	SB8->B8_EMPENHO := 0
	SB8->( msUnlock() )
Next x

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VoltaEmpsºAutor  ³Michel A. Sander    º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o empenho									                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VoltaEmps()
LOCAL X := 0

For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := aEmpSB2[x,2]
	SB2->( msUnlock() )
Next x

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidaOrig ºAutor  ³Michel A. Sander  º Data ³  01/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida origem										                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidaOrig()

Local _Retorno := .T.

IF SUBSTR(_cEndOrig,1,2)==ALLTRIM(cLocProcDom) .OR. SUBSTR(_cEndOrig,1,2)==ALLTRIM(cLocProc)
	U_MsgColetor('Não permitido transferencia no local de processo.')
	Return .F.
ENDIF

IF !EMPTY(_cEndOrig)
	SBE->( dbSetOrder(1) )
	If SBE->( dbSeek( xFilial("SBE") + Subs(_cEndOrig,1,12) ) )
		If SBE->BE_MSBLQL == '1'
			_Retorno := .F.
			U_MsgColetor('Endereço bloqueado para uso.')
		EndIf
	Else
		_Retorno := .F.
		U_MsgColetor('Endereço não encontrado.')
	EndIf
Else
	_Retorno := .F.
	U_MsgColetor('Preencha a Origem .')
EndIf

Return _Retorno
