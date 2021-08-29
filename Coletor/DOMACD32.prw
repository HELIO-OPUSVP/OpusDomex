#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMACD32  �Autor  �Michel A. Sander    � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Devolu��o de bobinas de fibra para o estoque               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMACD32()

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

_cEndOrig := PADR("01CORTE",15)
_cEndDest := PADR("01DEVFIBRA",15)
_cLocOrig := "01"
_cLocDest := "01"

DEFINE MSDIALOG oTrans TITLE OemToAnsi("Devolu��o de Bobina ao Estoque") FROM 0,0 TO 293,233 PIXEL OF oMainWnd PIXEL

@ 016,005 Say oTxtEtiq   Var "Etiqueta " Pixel Of oTrans
@ 016,045 MsGet oGetEtiq Var _cEtiqueta  Size 70,10 Valid ValidaEtiq() Pixel Of oTrans
oTxtEtiq:oFont:= TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEtiq:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 001,005 Say oTxtEnd    Var "Origem" Pixel Of oTrans
@ 001,045 MsGet oGetEnd  Var _cEndOrig When .F. Size 70,10 Valid ValidaOrig() Pixel Of oTrans
oTxtEnd:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetEnd:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fOkProc  �Autor  �Michel A. Sander    � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Confirma o processamento						                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fOkProc()

If Empty(_cEndDest)
	U_MsgColetor('Endere�o de destino n�o preenchido.')
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
	U_MsgColetor("N�o existem informa��es para serem processadas.")
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fOkGrava �Autor  �Michel A. Sander    � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa a transfer�ncia						                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fOkGrava()

Local _nTamEtiq   :=Len(CriaVar("XD1_XXPECA",.F.))
Local _nOpcAuto   := 3
Local lChkMov      := .f.

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
Private _aEndereco  := {}
Private _aItem      := {}
Private _cDoc	     := ''
Private lTRANSF     :=.F.
Private _aAuto      :={}

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
		U_MsgColetor('Status diferente de 4, j� utilizado, nao ser� transferido, Produto/Etiqueta: '+ALLTRIM(_cProduto)+'/'+ALLTRIM(TMP->ETIQ))
	Else
		
		SB1->( dbSeek( xFilial("SB1") + _cProduto) )
		If SUBSTR(SB1->B1_GRUPO,1,2) <> "FO"
			U_MsgColetor("O grupo de produto n�o corresponde a FIBRA")
			lTransf := .F.
			Exit
		EndIf
		
		
		_cDoc:= U_NEXTDOC()
		_cDoc:=_cDoc+SPACE(09)
		_cDoc:=SUBSTR(_cDoc,1,9)
		
		aadd(_aAuto,{_cDoc,dDataBase})
		
		_aItem := {}
		aadd(_aItem,XD1->XD1_COD)                           //Produto Origem
		aadd(_aItem,SB1->B1_DESC)                           //Descricao Origem
		aadd(_aItem,SB1->B1_UM)  	                         //UM Origem
		aadd(_aItem,_cLocOrig)		                         //Local Origem
		aadd(_aItem,_cEndOrig)	   		             	    //Endereco Origem
		aadd(_aItem,XD1->XD1_COD)                           //Produto Destino
		aadd(_aItem,SB1->B1_DESC)                           //Descricao Destino
		aadd(_aItem,SB1->B1_UM)  	                         //UM destino
		aadd(_aItem,_cLocDest)					                //Local Destino
		aadd(_aItem,_cEndDest)										 //Endereco Destino
		aadd(_aItem,"")                                     //Numero Serie
		aadd(_aItem,XD1->XD1_LOTECTL)	                      //Lote Origem
		aadd(_aItem,"")         	                         //Sub Lote Origem
		aadd(_aItem,CtoD("31/12/49"))	                      //Validade Lote Origem
		aadd(_aItem,0)		                                  //Potencia
		aadd(_aItem,TMP->QTD)           	                   //Quantidade
		aadd(_aItem,0)		                                  //Quantidade 2a. unidade
		aadd(_aItem,"")   	                               //ESTORNO
		aadd(_aItem,"")         	                         //NUMSEQ
		aadd(_aItem,XD1->XD1_LOTECTL)	                      //Lote Destino
		aadd(_aItem,CtoD("31/12/49"))	                      //Validade Lote Destino
		aadd(_aItem,"")		                               //D3_ITEMGRD
		
		If nFCICalc == 1
			aadd(_aItem,0)                                      //D3_PERIMP
		ENDIF
		
		If GetVersao(.F.,.F.) == "12"
			//aAdd(_aItem,"")   //D3_IDDCF
			aAdd(_aItem,"")   //D3_OBSERVACAO
		EndIf
		aadd(_aAuto,_aItem)

		 
		BEGIN TRANSACTION
		
			lMsErroAuto := .F.
			MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)  // Execauto de transfer�ncia

		END TRANSACTION
		
		If lMsErroAuto
			MostraErro("\UTIL\LOG\Transferencia_Endereco\")
			//DisarmTransaction()
			U_MsgColetor("Erro na transferencia")
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
										//SD3->D3_XXOP    := SD4->D4_OP
										SD3->D3_USUARIO := cUsuario
										SD3->D3_HORA    := Time()
										SD3->( msUnlock() )
									EndIf
									If !lCHkMov
										//VERIFICA INTEGRIDADE DOS MOVIMENTOS 
										lCHkMov := U_CHKMOV(SD3->D3_COD, SD3->D3_NUMSEQ, SD3->( Recno()), "T")
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					SD3->( dbSkip() )
				End
			EndIf
			Reclock("XD1",.F.)
			XD1->XD1_LOCAL   := _cLocDest
			XD1->XD1_LOCALIZ := _cEndDest
			XD1->( msUnlock() )
			_nQtd := 0
		EndIf
		
		lTRANSF:=.T.
		
	EndIf
	
	lChkMov := .f.
	TMP->(DBSKIP())
	
EndDo

If lTRANSF
	U_MsgColetor("Transferencia efetuada")
	lTRANSF:=.F.
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fGetDados�Autor  �Michel A. Sander    � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta MarkBrowse									                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fValEnd  �Autor  �Michel A. Sander    � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��es de transfer�ncia					                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fValEnd()

Local _lRet:=.T.

IF SUBSTR(_cEndDest,1,2)==ALLTRIM(cLocProcDom) .OR. SUBSTR(_cEndDest,1,2)==ALLTRIM(cLocProc)  //97,99
	U_MsgColetor('N�o permitido transferencia para local de processo.')
	Return .F.
ENDIF

IF SUBSTR(_cEndDest,1,2)=='13'               //13
	U_MsgColetor('N�o permitido transferencia para local 13-Expedi��o.')
	Return .F.
ENDIF

SBE->( dbSetOrder(1) )
If SBE->( dbSeek( xFilial("SBE") + _cLocDest + AllTrim(_cEndDest) ) )
	If SBE->BE_MSBLQL == '1'
		_lRet := .F.
		U_MsgColetor('Endere�o bloqueado para uso.')
	EndIf
Else
	_lRet := .F.
	U_MsgColetor('Endere�o n�o encontrado.')
EndIf

Return(_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ValidaEtiq�Autor  �Michel A. Sander   � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Etiqueta									                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidaEtiq()

Local _lRet   :=.T.
Local _nSaldo := 0

If Len(AllTrim(_cEtiqueta))==12 //EAN 13 s/ d�gito verificador.
	_cEtiqueta := "0"+_cEtiqueta
	_cEtiqueta := Subs(_cEtiqueta,1,12)
EndIf

If Len(AllTrim(_cEtiqueta))==20 //CODE 128 c/ d�gito verificador.
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
		IF alltrim(XD1->XD1_LOCALI)<> alltrim(_cEndOrig)�
			U_MsgColetor("Endere�o etiqueta diferente origem")
			RETURN
		ENDIF
		If SB1->( dbSeek( xFilial("SB1") + _cProduto) )
			If SB1->B1_LOCALIZ == 'S'
				If SB1->B1_RASTRO == 'L'
					If !Empty(XD1->XD1_LOCALI)
						If Len(_aCols)>0
							If aScan(_aCols,{ |x| Upper(AllTrim(x[1])) == Trim(_cEtiqueta) }) == 0   //Se a etiqueta n�o foi utilizada.
								
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
								U_MsgColetor("Etiqueta  j� utilizada !")
							EndIf
						Else
							SB2->(dbSetOrder(1))
							If SB2->(dbSeek(xFilial("SB2")+XD1->XD1_COD+XD1->XD1_LOCAL))
								// Validando se o produto tem diverg�ncia de SB2 para SBF
								If QtdComp(SB2->B2_QATU)-QtdComp(SB2->B2_QACLASS) # QtdComp(SaldoSBF(XD1->XD1_LOCAL,"",XD1->XD1_COD))
									U_MsgColetor("Diverg�ncia de Saldo F�sico X Saldo por Endere�o. N�o ser� poss�vel executar o processo.")
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
						U_MsgColetor("Etiqueta sem Endere�o preenchido.")
					EndIf
				Else
					_lRet:=.F.
					U_MsgColetor("Produto sem controle de Lote.")
				EndIf
			Else
				_lRet:=.F.
				U_MsgColetor("Produto n�o controla por endere�o.")
			EndIf
		Else
			_lRet:=.F.
			U_MsgColetor("Produto N�O encontrado")
		EndIf
	Else
		_lRet:=.F.
		U_MsgColetor("Etiqueta n�o encontrada.")
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AlertC   �Autor  �Michel A. Sander    � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Mensagem do Coletor								                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AlertC(cTexto)

Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

If !apMsgNoYes( cTemp )
	lRet:=.F.
EndIf

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GuardaEmps  �Autor  �Michel A. Sander � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Aguarda e atualiza empenho						                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GuardaEmps(cProduto,cLocal)

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VoltaEmps�Autor  �Michel A. Sander    � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o empenho									                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VoltaEmps()

For x := 1 to Len(aEmpSB2)
	SB2->( dbGoTo(aEmpSB2[x,1]) )
	Reclock("SB2",.F.)
	SB2->B2_QEMP := aEmpSB2[x,2]
	SB2->( msUnlock() )
Next x

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ValidaOrig �Autor  �Michel A. Sander  � Data �  01/11/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida origem										                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidaOrig()

Local _Retorno := .T.

IF SUBSTR(_cEndOrig,1,2)==ALLTRIM(cLocProcDom) .OR. SUBSTR(_cEndOrig,1,2)==ALLTRIM(cLocProc)
	U_MsgColetor('N�o permitido transferencia no local de processo.')
	Return .F.
ENDIF

IF !EMPTY(_cEndOrig)
	SBE->( dbSetOrder(1) )
	If SBE->( dbSeek( xFilial("SBE") + AllTrim(_cEndOrig)) )
		If SBE->BE_MSBLQL == '1'
			_Retorno := .F.
			U_MsgColetor('Endere�o bloqueado para uso.')
		EndIf
	Else
		_Retorno := .F.
		U_MsgColetor('Endere�o n�o encontrado.')
	EndIf
Else
	_Retorno := .F.
	U_MsgColetor('Preencha a Origem .')
EndIf

Return _Retorno
