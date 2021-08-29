//-----------------------------------------------------------------------------------------------------------------------------------------------//
//MAURICIO -OpusVp - 20/11/13                                                                                                                    //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Especifico Rosenberger Domex.                                                                                                                  //
//-----------------------------------------------------------------------------------------------------------------------------------------------//
//Devolução MP para Estoque                                                                                                        //
//-----------------------------------------------------------------------------------------------------------------------------------------------//

#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

*---------------------------------------------------------------------------------------------
User Function DOMACW14()
	*---------------------------------------------------------------------------------------------

	Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
	Private oTxtDescric,oTxtProdEmp,oTxtQtdEmp
	Private _nTamEtiq      := 21
	Private _cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
	Private _cEtiqueta     := Space(_nTamEtiq)
	Private _cProduto      := CriaVar("B1_COD",.F.)
	Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
	Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
	Private _aCols         := {}
	Private _lAuto	        := .T.
	Private _lIndividual   := .T.
	Private _cCodInv
	Private cGetEnd        := Space(2+15+1)
	Private _cProd  	     := Space(15)
	Private _cDescric	     := Space(27)
	Private _cEnderec	     := Space(15)
	Private _cStatus	     := Space(15)
	Private _nQtd          := 0
	Private _aDados        := {}
	Private _aEnd          := {}
	Private _nCont
	Private nSaldoSD4      := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private _cDescric      := SPACE(40)
	Private _nQTD1         := 0
	Private _nSALDO97      := 0
	Private aEmpSB2        := {}
	Private aEmpSBF        := {}
	Private aEmpSB8        := {}
	Private aSD4QUANT      := {}
	Private cLocProcDom    := GetMV("MV_XXLOCPR")   // Local de Processos Domex
	Private nFCICalc    := SuperGetMV("MV_FCICALC",.F.,0)
	Private oButt01
	Private oButt02
	Private oButt03

	Private nWebPx:= 1.5
	Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"


	dDataBase := Date()

	Define MsDialog oTelaDV Title OemToAnsi("Devolução Produção p/ Estoque " + DtoC(dDataBase) ) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,005   Say   oTxtOP  Var "OP " Pixel Of oTelaDV
	@ nLin-2,045 MsGet oGetOP  Var _cNumOP Valid ValidaOP() Size 70*nWebPx,10*nWebPx Pixel Of oTelaDV
	oTxtOP:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	oGetOP:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 018*nWebPx,001 To 045*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL

	@ 020*nWebPx,005 Say oTxtProdEmp  Var "Código: "   + _cProd  Pixel Of oTelaDV
	@ 020*nWebPx,097 Say oTxtQtdEmp   Var  TransForm(_nQtd,"@E 999,999.9999") Pixel Of oTelaDV
	@ 027*nWebPx,005 Say oTxtDescric  Var "Descrição: "+ _cDescric Size 110*nWebPx,15*nWebPx Pixel Of oTelaDV
	oTxtProdEmp:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtDescric:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	oTxtQtdEmp:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	fGetDados()

	nLin+= 60*nWebPx
	nLin+= 20*nWebPx
	nLin+= 20*nWebPx
	nLin+= 26*nWebPx


	@ nLin,002*nWebPx Button  oButt01 PROMPT "Nova Etiq. "  Size 37*nWebPx,15*nWebPx Action Dev001()                       Pixel Of oTelaDV
	cCSSBtN1 :=  "QPushButton{background-image: url(rpo:FINAL.png);"+cPush+;
		"QPushButton:pressed {background-image: url(rpo:FINAL.png);"+cPressed+;
		"QPushButton:hover {background-image: url(rpo:FINAL.png);"+cHover
	oButt01:SetCSS( cCSSBtN1 )

	@ nLin,078 Button oButt02 PROMPT "Cancelar. "   Size 37*nWebPx,15*nWebPx Action Processa( {|| oTelaDV:End()} ) Pixel Of oTelaDV
	cCSSBtN1 :=  "QPushButton{background-image: url(rpo:FINAL.png);"+cPush+;
		"QPushButton:pressed {background-image: url(rpo:FINAL.png);"+cPressed+;
		"QPushButton:hover {background-image: url(rpo:FINAL.png);"+cHover
	oButt02:SetCSS( cCSSBtN1 )




	Activate MsDialog oTelaDV

Return

	*---------------------------------------------------------------------------------------------
Static Function fGetDados()
	*---------------------------------------------------------------------------------------------
	Local _aStru   := {}
	Local _nTamCOD := Len(CriaVar("D4_COD",.F.))

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	AADD(_aStru, {"MARCA"     ,"C",01,0} )
	AADD(_aStru, {"PRODUTO"   ,"C",_nTamCOD,0} )
	AADD(_aStru, {"QTD"       ,"N",12,4} )
	AADD(_aStru, {"DESCR"     ,"C",40,0} )
	AADD(_aStru, {"LOTE"      ,"C",10,0} )

	_cArqTrab := CriaTrab(_aStru,.T.)

	dbUseArea(.T.,__LocalDriver,_cArqTrab,"TRB",.F.)

	IndRegua("TRB",_cArqTrab,"PRODUTO",,,)

	_aCampos := {}

	AADD(_aCampos,{"MARCA"       ,"" ,""            ,""                } )
	AADD(_aCampos,{"PRODUTO"     ,"" ,"Produto"     ,"@R"              } )
	AADD(_aCampos,{"QTD"         ,"" ,"QTD"         ,"@E 9,999,999.9999"  } )
	AADD(_aCampos,{"DESCR"       ,"" ,"Descr."      ,"@R" } )
	AADD(_aCampos,{"LOTE"        ,"" ,"LOTE"        ,"@R" } )

	oMark:= MsSelect():New("TRB","MARCA",,_aCampos,Nil,Nil,{47*nWebPx,00,130*nWebPx,150})
	oMark:oBrowse:oFont:= TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
	oMark:oBrowse:Refresh()

	dbSelectArea("TRB")
	dbGotop()

	oMark:oBrowse:Refresh()

Return

	*------------------------------------------------------------------------------------------------
Static Function ValidaOP()
	*------------------------------------------------------------------------------------------------
	Local _lRet :=.T.
	_cProd      := ""
	_cDescric   := ""
	_cEnderec   := ""
	_nQtd       := 0
	_aDados     := {}

	If Empty(_cNumOP)
		Return .T.
	EndIf

	fGetDados()

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )

	If SC2->(dbSeek(xFilial("SC2")+_cNumOP))
		If SC2->C2_QUANT <> SC2->C2_QUJE
			SD4->(dbSetOrder(2))
			If SD4->(dbSeek(xFilial("SD4")+_cNumOP))
				While xFilial("SD4")+_cNumOP == SD4->D4_FILIAL+SD4->D4_OP
					If SD4->D4_LOCAL == cLocProcDom
						If SB1->( dbSeek( xFilial() + SD4->D4_COD ) )

							SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
							SUMD3QTD := 0

							// Calculando o material pago para a OP
							If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
								While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
									If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
										If SD3->D3_CF == 'DE4'
											SUMD3QTD += SD3->D3_QUANT
										EndIf
										If SD3->D3_CF == 'RE4'
											SUMD3QTD -= SD3->D3_QUANT
										EndIf
									EndIf
									SD3->( dbSkip() )
								End
							EndIf

							// Calculando o material já consumido pela OP
							nConsumoOP := 0
							SD3->( dbSetOrder(1) )  // D3_FILIAL + D3_OP + D3_COD + D3_LOCAL
							If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD + cLocProcDom ) )
								While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_OP + SD3->D3_COD  // tratado
									If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
										If SD3->D3_TM == '999' .and. (SD3->D3_CF == 'RE1' .or. SD3->D3_CF == 'RE2')
											nConsumoOP += SD3->D3_QUANT
										EndIf
										If SD3->D3_CF == '499' .and. (SD3->D3_CF == 'DE1' .or. SD3->D3_CF == 'DE2')
											nConsumoOP -= SD3->D3_QUANT
										EndIf
									EndIf
									SD3->( dbSkip() )
								End
							EndIf


							//If (SD4->D4_QUANT - (SUMD3QTD - nConsumoOP)) > 0  // Se o D4_QUANT menos a quantidade paga menos o que já foi consumido
							If (SD4->D4_QUANT - SUMD3QTD) > 0
								If SBF->(dbSeek(xFilial("SBF")+SD4->D4_COD+SB1->B1_LOCPAD))
									While !SBF->( EOF() ) .and. SD4->D4_COD+SB1->B1_LOCPAD == SBF->BF_PRODUTO+SBF->BF_LOCAL
										If SD4->D4_QUANT > 0
											aadd(_aDados,{SB1->B1_COD,SB1->B1_DESC,SBF->BF_LOCALIZ,SD4->D4_QUANT})
										EndIf
										SBF->( dbSkip() )
									End
								EndIf
							EndIf
						EndIf
					EndIf
					SD4->(dbSkip())
				End
			EndIf
		Else
			U_MsgColetor("OP já encerrada.")
			_lRet:=.F.
		EndIf
	Else
		U_MsgColetor("OP não encontrada.")
		_lRet:=.F.
	EndIf

	If Empty(_cNumOP)
		_lRet := .T.
	EndIf

	_cProd      := "OP PAGA"
	_cDescric   := "Todos os empenhos foram atendidos."
	_cEnderec   := ""
	_nQtd       := 0

	If Len(_aDados)> 0
		_cProd      := _aDados[1][1]
		_cDescric   := _aDados[1][2]
		_cEnderec   := _aDados[1][3]
		_nQtd       := _aDados[1][4]
	Else
		SZD->( dbSetOrder(1) )
		If SZD->( dbSeek( xFilial() + Subs(_cNumOP,1,11) ) )
			nTemp := 0
			While !SZD->( EOF() ) .and. Subs(SZD->ZD_OP,1,11) == Subs(_cNumOP,1,11)
				nTemp += SZD->ZD_QTDPG
				SZD->( dbSkip() )
			End
			U_MsgColetor("Ordem de Produção já atendida. Foi emitida etiqueta de Comprovante de Pagamento para produção de" + Chr(13) + Alltrim(Transform(nTemp,"@E 999,999,999.9999"))+".")
			_lRet:=.t.
		Else
			U_MsgColetor("Ordem de Produção já atendida. Etiqueta de Comprovante de Pagamento NÃO impressa.")
			_lRet:=.t.
		EndIf
	EndIf

	IF _lRet == .T.
		If SC2->(dbSeek(xFilial("SC2")+_cNumOP))
			_cProd :=SC2->C2_PRODUTO
			_nQtd  :=SC2->C2_QUANT - SC2->C2_QUJE
			_cDescric :=POSICIONE('SB1',1,xFILIAL('SB1')+_cProd,'B1_DESC')
		ENDIF
		//cQuery:=" 	SELECT D4_OP,D4_COD,D4_QTDEORI,D4_QUANT, D4_LOCAL, D4_OPORIG,                                "
		//cQuery+="  (SELECT SUM(D3_QUANT) FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND     "
		//cQuery+="                                   D3_LOCAL='97'  and D3_CF='DE4' AND                            "
		//cQuery+="                                   D3_ESTORNO<>'S' AND SD3010.D_E_L_E_T_<>'*')   AS D4_TRANSF97, "
		//cQuery+="  (SELECT SUM(D3_QUANT) FROM SD3010 WITH (NOLOCK) WHERE D3_XXOP =D4_OP AND D3_COD=D4_COD AND     "
		//cQuery+="                                   D3_LOCAL='97'  and D3_CF='RE4' AND                            "
		//cQuery+="                                   D3_ESTORNO<>'S' AND SD3010.D_E_L_E_T_<>'*')   AS D4_DEVOL97   "
		//cQuery+="   FROM SD4010, SC2010                                                                           "
		//cQuery+="   WHERE SD4010.D_E_L_E_T_<>'*' AND SC2010.D_E_L_E_T_<>'*' AND D4_OP='"+ALLTRIM(_cNumOP)+"' AND  "
		//cQuery+="         D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN                                                        "
		//cQuery+="   ORDER BY D4_OP,D4_COD                                                                         "


		SD4->( dbSetOrder(2) )
		SUMD3QTD1 := 0
		aVetor    := {}

		If SD4->( dbSeek(xFilial() + Subs(_cNumOP,1,11)) )
			While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == Subs(_cNumOP,1,11)
				If Empty(SD4->D4_OPORIG)
					SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
					If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
						While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
							If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
								nTemp := aScan(aVetor,{ |aVet| aVet[1] == SD3->D3_COD .and. aVet[2] == SD3->D3_LOTECTL })

								If Empty(nTemp)
									AADD(aVetor,{SD3->D3_COD, SD3->D3_LOTECTL, 0})
									nTemp := Len(aVetor)
								EndIf

								If SD3->D3_CF == 'DE4'
									aVetor[nTemp,3] += Round(SD3->D3_QUANT,4)
								EndIf
								If SD3->D3_CF == 'RE4'
									aVetor[nTemp,3] -= Round(SD3->D3_QUANT,4)
								EndIf

							EndIf
							SD3->( dbSkip() )
						End
					EndIf
					SD3->( dbSetOrder(1) )
					If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
						While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_OP + SD3->D3_COD  // tratado
							If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
								nTemp := aScan(aVetor,{ |aVet| aVet[1] == SD3->D3_COD .and. aVet[2] == SD3->D3_LOTECTL })

								If Empty(nTemp)
									AADD(aVetor,{SD3->D3_COD, SD3->D3_LOTECTL, 0})
									nTemp := Len(aVetor)
								EndIf

								If SD3->D3_TM > '500'
									aVetor[nTemp,3] -= Round(SD3->D3_QUANT,4)
								EndIf
								If SD3->D3_CF < '500'
									aVetor[nTemp,3] += Round(SD3->D3_QUANT,4)
								EndIf

							EndIf
							SD3->( dbSkip() )
						End
					EndIf
				EndIf
				SD4->( dbSkip() )
			End

			For _nX := 1 to Len(aVetor)
				If !Empty(aVetor[_nX,3])
					Reclock("TRB",.T.)
					TRB->PRODUTO := aVetor[_nX,1]
					TRB->QTD     := aVetor[_nX,3]
					TRB->DESCR   := POSICIONE('SB1',1,xFILIAL('SB1')+aVetor[_nX,1],'B1_DESC')
					TRB->LOTE    := aVetor[_nX,2]
					TRB->( msUnlock() )
				EndIf
			Next _nX

		EndIf
	EndIf

	TRB->(dbGotop())
	oMark:oBrowse:Refresh()

	oTelaDV:Refresh()

Return(_lRet)

	*---------------------------------------------------------------------------------------------
Static Function DEV001()
	*---------------------------------------------------------------------------------------------
	LOCAL nX :=0

	dbSelectArea("TRB")
	dbGotop()
	Do While.Not. TRB->(Eof())
		//If Marked("MARCA")
		IF .NOT. EMPTY(TRB->MARCA)
			DEV002(TRB->PRODUTO,TRB->QTD,TRB->DESCR,TRB->LOTE)
		ENDIF
		TRB->(DBSKIP())
	ENDDO
	_cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
	fGetDados()
	oGetop:REFRESH()
	oGetop:SETFOCUS()
RETURN

	*---------------------------------------------------------------------------------------------
Static Function DEV002(cProd2,nQTDORI2,cDESC2,cLOTE)
	*---------------------------------------------------------------------------------------------

	PRIVATE oTxtProd2,oTxtDESC2,oTxtlOTE2,oTxtQTDORI2,oTxtQTDDEV2,oGetQTDDEV2,oFontNW
	PRIVATE oTxtNETIQUE
	PRIVATE oGetNETIQUE
	Private oGetDados
	PRIVATE clOTE2     := cLOTE
	PRIVATE nQTDDEV2   := nQTDORI2
	PRIVATE nQTDETIQ   := 0
	Private aHeader    := {}
	Private aCols      := {}

	AADD(aHeader,  {    "ITEM"   ,   "ITEM"    ,""             ,15,0,""            ,"","C","","","","",".F."})//01
	AADD(aHeader,  {    "QTDEP"  ,   "QTDEP"   ,"@E 9,999.9999",04,0,""            ,"","N","","","","",".T."})//02

	AADD(aCols,{'',0,.F.})

	DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

	Define MsDialog oTelaDV2 Title OemToAnsi("Devolução Produção p/ Estoque OP " + _cNumOP ) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	nLin := 005
	@ 005,001 To 040*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL

	@ 007*nWebPx,005 Say oTxtProd2     Var "Produto: "   + cProd2               Pixel Of oTelaDV2
	@ 014*nWebPx,005 Say oTxtDESC2     Var "Descrição: " + SUBSTR(cDESC2,1,22)  Pixel Of oTelaDV2
	@ 021*nWebPx,005 Say oTxtlOTE2     Var "Lote:      " + clOTE2               Pixel COLOR CLR_RED Of oTelaDV2
	@ 028*nWebPx,005 Say oTxtQTDORI2   Var "QTD.ORI: "   + TransForm(nQTDORI2,"@E 999,999.9999") Pixel Of oTelaDV2

	oTxtProd2  :oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtDESC2  :oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtlOTE2  :oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtQTDORI2:oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)

	nLin := 044*nWebPx
	@ nLin   ,005 Say   oTxtQTDDEV2   Var "QTD.DEV: "   Pixel Of oTelaDV2
	@ nLin-2 ,045 MsGet oGetQTDDEV2   Var nQTDDEV2 Valid ValidQTDEV(nQTDORI2)Picture "@E 9,999,999.9999" Size 70*nWebPx,10*nWebPx Pixel Of oTelaDV2
	oTxtQTDDEV2:oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oGetQTDDEV2:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin := 058*nWebPx
	@ nLin   ,005 Say   oTxtNETIQUE   Var "No. Etiquetas: "   Pixel Of oTelaDV2
	@ nLin-2 ,045 MsGet oGetNETIQUE   Var nQTDETIQ Valid ValidQTDET()Picture "@E 9,999,999.9999" Size 70*nWebPx,10*nWebPx Pixel Of oTelaDV2
	oTxtNETIQUE:oFont := TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oGetNETIQUE:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin := 130*nWebPx
	@ nLin,002 Button oButt03 PROMPT "Devolver" Size 55*nWebPx,15*nWebPx Action DEV002TR(cProd2,cLOTE2) Pixel Of oTelaDV2
	cCSSBtN1 :=  "QPushButton{background-image: url(rpo:FINAL.png);"+cPush+;
		"QPushButton:pressed {background-image: url(rpo:FINAL.png);"+cPressed+;
		"QPushButton:hover {background-image: url(rpo:FINAL.png);"+cHover
	oButt03:SetCSS( cCSSBtN1 )



	oGetDados  := (MsNewGetDados():New( 70*nWebPx, 00 , 130*nWebPx ,150,GD_UPDATE+GD_DELETE ,"AlwaysTrue" ,"AlwaysTrue",,,,9999 ,,,,oTelaDV2,aHeader,aCols))
	oGetDados:oBrowse:Refresh()
	oGetDados:oBrowse:oFont  := oFontNW
	oGetDados:oBrowse:bChange:={||U_DEVW002LOK(oGetDados)}

	Activate MsDialog oTelaDV2

Return

	*--------------------------------------------------------
USER FUNCTION DEVW002LOK(oGetDados)
	*--------------------------------------------------------
	Local nX      :=0
	Local nTOTDEV :=0

	FOR nX:=1 TO LEN (oGetDados:aCOLS)
		IF oGetDados:aCOLS[nX][03]==.F.  //NÃO DELETADO
			nTOTDEV :=nTOTDEV+(oGetDados:aCOLS[nX][02])
		ENDIF
	NEXT

	IF nTOTDEV >0
		IF nTOTDEV >nQTDDEV2
			apMsgNoYes("Soma itens Maior que  "+Chr(13)+Chr(10)+;
				"quantidade a devolver."+Chr(13)+Chr(10)+;
				"Tot.Itens "+Transform(nTOTDEV         ,"@E 999,999.9999")+Chr(13)+Chr(10)+;
				"Qtd dev.  "+Transform(nQTDDEV2        ,"@E 999,999.9999")+Chr(13)+Chr(10)+;
				"Diferença "+Transform(nTOTDEV-nQTDDEV2,"@E 999,999.9999"))
		ENDIF
	ENDIF

RETURN

	*--------------------------------------------------------
STATIC FUNCTION ValidQTDET()
	*--------------------------------------------------------
	Local nX       :=0
	Local _nqtdetq :=0
	Local _nItem   :='000'
	Local aCols2   := {}

	IF nQTDDEV2>0 .AND. nQTDETIQ >0
		_nqtdetq := nQTDDEV2/nQTDETIQ

		FOR nX := 1 TO nQTDETIQ
			_nItem:=SOMA1(_nItem)
			_nQTDEV2:=nQTDDEV2/_nqtdetq
			AADD(aCols2,{_nItem,_nqtdetq,.F.})
		NEXT
		oGetDados:ACOLS:=aCOLS2
		oGetDados:oBrowse:Refresh()

	ENDIF
RETURN .T.

	*--------------------------------------------------------
STATIC FUNCTION ValidQTDEV(nQTDORI2)
	*--------------------------------------------------------
	IF nQTDDEV2  > nQTDORI2
		U_MsgColetor("Quantidade devolvida não pode ser maior que saldo a devolver.")
		nQTDDEV2 :=nQTDORI2
		oGetNETIQUE:refresh()
	ENDIF

RETURN

	*--------------------------------------------------------
STATIC FUNCTION DEV002TR(cProd2,cLOTE2) //TRANSFERIR
	*--------------------------------------------------------
	Local     nX          := 0
	Local     _nOpcAuto   := 3
	Local     dVLDSB8     := CTOD("31/12/49")
	Local     lChkMov     := .f.
	PRIVATE   _nSB2QEMP   := 0
	PRIVATE   _lSB2QEMP   := .F.
	PRIVATE	 lTRANSF     := .F.
	PRIVATE	 _cLOCDES    :=SPACE(02)
	cLOTE2  := SUBSTR(cLOTE2,1,10)

	FOR nX := 1 TO LEN(oGetDados:aCOLS)
		IF oGetDados:aCOLS[nX][02] > 0
			//TRANSFERENCIA
			_aAuto      :={}
			_aItem      :={}

			XD1->( dbSetOrder(1))
			SB1->( dbSetOrder(1) )
			SB1->( dbSeek( xFilial() + cProd2 ) )
			SBF->( dbSetOrder(1) )
			SB2->( dbSetOrder(1) )

			cLoteCtl := cLOTE2


			//U_VLDLot97(SB1->B1_DESC,cLoteCtl) RETIRADO EM 07/05/2018 MAURICIO
			DbSelectArea("SB8")
			DBSetOrder(3)
			If SB8->( dbSeek( xFilial() + SB1->B1_COD + '97'  + cLoteCtl) )
				dVLDSB8 := SB8->B8_DTVALID
			EndIf

			If SB2->( dbSeek( xFilial() + SB1->B1_COD + '97' ) )
				If SBF->( dbSeek( xFilial() + '97' + '97PROCESSO     ' +  SB1->B1_COD + Space(Len(SBF->BF_NUMSERI)) + cLoteCtl) )
					If SBF->BF_QUANT >= oGetDados:aCOLS[nX][02] .and. SB2->B2_QATU >= oGetDados:aCOLS[nX][02]

						_cProxPeca := U_IXD1PECA()
						Reclock("XD1",.T.)
						Replace XD1->XD1_FILIAL  With xFilial("XD1")
						Replace XD1->XD1_XXPECA  With _cProxPeca
						Replace XD1->XD1_FORNEC  With Space(06)
						Replace XD1->XD1_LOJA    With Space(02)
						Replace XD1->XD1_DOC     With Space(06)
						Replace XD1->XD1_SERIE   With Space(03)
						Replace XD1->XD1_COD     With SB1->B1_COD
						Replace XD1->XD1_LOCAL   With '01'
						Replace XD1->XD1_TIPO    With SB1->B1_TIPO
						Replace XD1->XD1_LOTECT  With "LOTE1308" //SUBSTR(cLOTE2,1,10)
						Replace XD1->XD1_DTDIGI  With dDataBase
						Replace XD1->XD1_FORMUL  With ""
						Replace XD1->XD1_LOCALI  With '01DEVOLUCAO    '
						Replace XD1->XD1_USERID  With __cUserId
						XD1->XD1_OCORRE := "4"
						Replace XD1->XD1_QTDORI  With oGetDados:aCOLS[nX][02]
						Replace XD1->XD1_QTDATU  With oGetDados:aCOLS[nX][02]
						XD1->( MsUnlock() )

						_cDoc:= U_NEXTDOC()
						_cDoc:= _cDoc + SPACE(09)
						_cDoc:=SUBSTR(_cDoc,1,9)

						aadd(_aAuto,{_cDoc,dDataBase})

						_aItem   := {}

						aadd(_aItem,SB1->B1_COD)                       //Produto Origem
						aadd(_aItem,SB1->B1_DESC)                      //Descricao Origem
						aadd(_aItem,SB1->B1_UM)  	                    //UM Origem
						aadd(_aItem,'97')                              //Local Origem
						aadd(_aItem,'97PROCESSO     ')           	     //Endereco Origem
						aadd(_aItem,SB1->B1_COD)                       //Produto Destino
						aadd(_aItem,SB1->B1_DESC)                      //Descricao Destino
						aadd(_aItem,SB1->B1_UM)  	                    //UM destino
						aadd(_aItem,'01')                              //Local Destino
						aadd(_aItem,'01DEVOLUCAO    ')                 //Endereco Destino
						aadd(_aItem,"")                                //Numero Serie
						aadd(_aItem,cLOTE2)	                          //Lote Origem
						aadd(_aItem,"")         	                    //Sub Lote Origem
						aadd(_aItem,dVLDSB8) 			                 //Validade Lote Origem
						aadd(_aItem,0)		                             //Potencia
						aadd(_aItem,oGetDados:aCOLS[nX][02])           //Quantidade
						aadd(_aItem,0)		                             //Quantidade 2a. unidade
						aadd(_aItem,"")   	                          //ESTORNO
						aadd(_aItem,"")         	                    //NUMSEQ
						//	aadd(_aItem,cLOTE2)                          //Lote Destino
						aadd(_aItem,"LOTE1308")                         //Lote Destino
						aadd(_aItem,dVLDSB8) 			                 //Validade Lote Destino
						aadd(_aItem,"")		                          //D3_ITEMGRD
						If nFCICalc == 1
							aadd(_aItem,0)                                 //D3_PERIMP
						ENDIF
						If GetVersao(.F.,.F.) == "12"
							//aAdd(_aItem,"")   //D3_IDDCF
							aAdd(_aItem,"")   //D3_OBSERVACAO
						EndIf
						aadd(_aAuto,_aItem)

						lMsErroAuto := .F.

						GuardaEmps(SB1->B1_COD,'97')
						MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)  // Execauto de transferência
						VoltaEmps()

						If lMsErroAuto
							//MostraErro("\UTIL\LOG\Devolucao_Producao_MP\")
							MostraErro()
							//DisarmTransaction()
							U_MsgColetor("Erro na Devolução (MP)")
						Else
							U_DOMEST06(.T.,"000024" )
							SD3->( dbSetOrder(2) )  // D3_FILIAL + D3_DOC
							If SD3->( dbSeek( xFilial() + _cDoc ) )
								While !SD3->( EOF() ) .and. ALLTRIM(SD3->D3_DOC) == ALLTRIM(_cDoc)
									If SD3->D3_CF == 'RE4' .or. SD3->D3_CF == 'DE4'

										If SD3->D3_COD == SB1->B1_COD
											If SD3->D3_EMISSAO == dDataBase
												If SD3->D3_QUANT == oGetDados:aCOLS[nX][02]
													If Empty(SD3->D3_XXOP)

														Reclock("SD3",.F.)
														SD3->D3_XXPECA  := XD1->XD1_XXPECA
														SD3->D3_XXOP    := _cNumOP
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
							lTRANSF:=.T.
						ENDIF
					Else
						
						U_MsgColetor("Não existe saldo suficiente do produto " + Alltrim(SB1->B1_COD) +" para devolução." + Chr(13) + "Saldo: "+Alltrim(Str(SBF->BF_QUANT))+ Chr(13) +"Necessidade: " + Alltrim(Str(oGetDados:aCOLS[nX][02])))
					EndIf
				Else
					U_MsgColetor("Não existe saldo do produto " + Alltrim(SB1->B1_COD) +" para devolução (saldo zero).")
				EndIf
			EndIf
		ENDIF
		lChkMov := .f.
	NEXT
	IF lTRANSF   .AND. lMsErroAuto == .F.
		U_MsgColetor("Devolução efetuada Produto: "+SB1->B1_COD)
		lTRANSF:=.F.
	ENDIF
	Close(oTelaDV2)

Return


	*-------------------------------------------------------------------------------------
Static Function GuardaEmps(cProduto,cLocal)
	*-------------------------------------------------------------------------------------
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


	cQuery := "SELECT R_E_C_N_O_, D4_QUANT FROM " + RetSqlName("SD4") + " WHERE D4_COD = '"+cProduto+"' AND D4_LOCAL = '"+cLocal+"' AND D4_QUANT <> 0 "

	If Select("QUERYSD4") <> 0
		QUERYSD4->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "QUERYSD4"

	aSD4QUANT := {}
	While !QUERYSD4->( EOF() )
		AADD(aSD4QUANT,{QUERYSD4->R_E_C_N_O_,QUERYSD4->D4_QUANT})
		SD4->( dbGoTo(QUERYSD4->R_E_C_N_O_) )
		If SD4->( Recno() ) == QUERYSD4->R_E_C_N_O_
			Reclock("SD4",.F.)
			SD4->D4_XQUANT := SD4->D4_QUANT
			SD4->D4_QUANT  := 0
			SD4->( msUnlock() )
		EndIf
		QUERYSD4->( dbSkip() )
	End

Return

	*-------------------------------------------------------------------------------------
Static Function VoltaEmps()
	*-------------------------------------------------------------------------------------
	For x := 1 to Len(aEmpSB2)
		SB2->( dbGoTo(aEmpSB2[x,1]) )
		Reclock("SB2",.F.)
		SB2->B2_QEMP := aEmpSB2[x,2]
		SB2->( msUnlock() )
	Next x

	For x := 1 to Len(aEmpSBF)
		SBF->( dbGoTo(aEmpSBF[x,1]) )
		Reclock("SBF",.F.)
		SBF->BF_EMPENHO := aEmpSBF[x,2]
		SBF->( msUnlock() )
	Next x

	For x := 1 to Len(aEmpSB8)
		SB8->( dbGoTo(aEmpSB8[x,1]) )
		Reclock("SB8",.F.)
		SB8->B8_EMPENHO := aEmpSB8[x,2]
		SB8->( msUnlock() )
	Next x

	For x := 1 to Len(aSD4QUANT)
		SD4->( dbGoTo(aSD4QUANT[x,1]) )
		If SD4->( Recno() ) == aSD4QUANT[x,1]
			Reclock("SD4",.F.)
			SD4->D4_QUANT  := aSD4QUANT[x,2]
			SD4->D4_XQUANT := 0
			SD4->( msUnlock() )
		EndIf
	Next x

Return

	*-------------------------------------------------------------------------------------
Static Function Dev003()
	*-------------------------------------------------------------------------------------
	LOCAL nX :=0

	dbSelectArea("TRB")
	dbGotop()
	Do While.Not. TRB->(Eof())
		IF .NOT. EMPTY(TRB->MARCA)
			//DEV003(TRB->PRODUTO,TRB->QTD,TRB->DESCR)
		ENDIF
		TRB->(DBSKIP())
	ENDDO
	_cNumOP        := Space(Len(CriaVar("D3_OP",.F.)))
	fGetDados()
	oGetop:REFRESH()
	oGetop:SETFOCUS()
	U_MsgColetor("DEVOLUÇÃO - APROVEITAR ETIQUETA, NÃO DISPONIVEL.")
RETURN


