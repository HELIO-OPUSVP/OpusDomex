#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMACD23  �Autor  �Michel Sander       � Data �  26.08.16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela de Faturamento de Pedidos					  		  ���
���          � 											 				  ���
���          �                                                            ���
���          �  U_VALIDACAO("RODA")  Fonte todo alterado e compilado em   ���
���          �  valida��o. Pendente passar para produ��o                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMACW23()

	Private oTxtOP,__oGetOP,__oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oMainEti,oEtiqueta
	Private _nTamEtiq      := 21
	Private _cNumEtqPA     := Space(_nTamEtiq)
	Private _cProduto      := CriaVar("B1_COD",.F.)
	Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
	Private _aCols         := {}
	Private _lAuto	        := .T.
	Private _lIndividual   := .T.
	Private lFaturado      := .F.
	Private cNumNFZY       := ""
	Private lPrevisaoFat   := .T.
	Private _cCodInv
	Private cGetEnd        := Space(2+15+1)
	Private _cCliEmp	     := Space(06)
	Private _cNomCli       := Space(15)
	Private _cDescric	     := Space(27)
	Private _cDescEmb      := Space(27)
	Private _cEmbalag	     := Space(15)
	Private _cNumOp        := SPACE(11)
	Private _cNumPed       := SPACE(06)
	Private _nQtdEmp       := 0
	Private _nQtd          := 0
	Private _aDados        := {}
	Private _aEnd          := {}
	Private _nCont
	Private _cDtaFat       := dDataBase
	Private nQtdCaixa      := 0
	Private cTipoSenf      := ""
	Private nSaldoEmb      := 0
	Private cVolumeAtu     := SPACE(17)
	Private nSaldoGrupo    := 0
	Private nTotalGrupo    := 0
	Private nRestaGrupo    := 0
	Private nPesoEmb       := 0
	Private nPesoBruto     := 0
	Private cLocProcDom    := GetMV("MV_XXLOCPR")
	Private aEmbBip        := {}
	Private aSeqBib        := {}
	Private aEmbPed        := {}
	Private aEmb           := {}
	Private aProdEmb       := {}
	Private lPesoEmb       := .F.
	Private oTelaPeso
	Private __oTelaOP
	Private oTxtQtdEmp
	Private oSelCaixa
	Private cGrupoesp      := "'TRUN'"  //"'TRUN','CORD'"
	Private cZY_SEQ        := ""
	Private cNivelFat      := ""
	Private lHuawei        := .F.
	Private nCx2SepPv      := 0
	Private nTotCx2PV 	  := 0
	Private nSalVol   	  := 0
	Private nSalTot        := 0
	Private lBeginSQL      := .F.
	Private nWebPx:= 1.5
	Private cPush:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 gray);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cPressed:= "background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 blue);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	Private cHover:="background-color: qlineargradient(x1: 0, y1: 0, x2: 1, y2: 1,stop: 0 gray, stop: 0.4 white,stop: 1 Black);color: #171717; font: bold "+cvaltochar(10*nWebPx)+"px Arial;"+;
		"background-repeat:no-repeat ;border-radius: 6px;}"
	dDataBase := Date()


	Define MsDialog __oTelaOP Title OemToAnsi("Faturamento " + DtoC(dDataBase) ) From 0,0 To 450,302 Pixel of oMainWnd PIXEL

	nLin := 005
	@ nLin,001 Say __oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaOP
	@ nLin-2,045*nWebPx MsGet __oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 78,10*nWebPx Pixel Of __oTelaOP
	__oTxtEtiq:oFont := TFont():New('Arial',,17*nWebPx,,.T.,,,,.T.,.F.)
	__oGetOP:oFont := TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	@ 018*nWebPx,001 To 065*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL

	nLin += 025*nWebPx
	@ nLin,005 Say __oTxtOP Var "Num.OP: " Pixel Of __oTelaOP
	@ nLin,027 Say oNumOP Var _cNumOP Size 120*nWebPx,10*nWebPx Pixel Of __oTelaOP
	@ nLin,077 Say oTxtQtdEmp   Var "Qtd: "+ TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of __oTelaOP
	oNumOp:oFont:= TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)
	oTxtQtdEmp:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	
	nLin += 10*nWebPx
	@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaOP
	@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaOP
	oTxtProdCod:oFont  := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	
	nLin += 10*nWebPx
	@ nLin,005 Say oTxtDes      Var "Descri��o: "      Pixel Of __oTelaOP
	@ nLin,035 say oTxtDescPro  Var _cDescric      Size 075*nWebPx,15*nWebPx Pixel Of __oTelaOP
	oTxtDescPro:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)
	
	nLin+= 28*nWebPx
	@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of __oTelaOP
	@ nLin,023 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120*nWebPx,10*nWebPx Pixel Of __oTelaOP
	oNumPed:oFont:= TFont():New('Arial',,15*nWebPx,,.T.,,,,.T.,.F.)

	nLin+= 05*nWebPx
	@ 070*nWebPx,001 To 145*nWebPx,115*nWebPx Pixel Of oMainWnd PIXEL
	nLin+= 10*nWebPx

	@ nLin,005 SAY oTxtDescEmb Var _cDescEmb 		 Pixel Of __oTelaOP
	oTxtDescEmb:oFont := TFont():New('Arial',,14*nWebPx,,.T.,,,,.T.,.F.)

	nLin += 10*nWebPx
	@ nLin,005   Say   oTxtDtfat Var "Faturamento:" Pixel Of __oTelaOP
	@ nLin-1,060 Say oDataFat  Var _cDtaFat  Size 50*nWebPx,10*nWebPx Pixel Of __oTelaOP        // MAURESI - Alterado em 24/05/2019 ( Evitar erro ao alimentar ZY_NOTA )
	nLin+= 11*nWebPx

	@ nLin,005   Say oTxtSldGrupo Var "Volumes do Pedido:" Pixel Of __oTelaOP
	@ nLin-1,060 MSGET oSldGrupo  Var cVolumeAtu When .F. Size 50*nWebPx,10*nWebPx Pixel Of __oTelaOP
	oSldGrupo:oFont:= TFont():New('Arial',,20*nWebPx,,.T.,,,,.T.,.F.)

	nLin += 15*nWebPx

	@ nLin,005 Button oSelCaixa PROMPT "Volume Parcial" Size 65,10*nWebPx Action U_fMontaSelCx(__oTelaOP) Pixel Of __oTelaOP
	cCSSBtN1 :=  "QPushButton{background-image: url(rpo:AVGBOX1.png);"+cPush+;
				"QPushButton:pressed {background-image: url(rpo:AVGBOX1.png);"+cPressed+;
				"QPushButton:hover {background-image: url(rpo:AVGBOX1.png);"+cHover
	oSelCaixa:SetCSS( cCSSBtN1 )
	
	@ nLin,077 Button oEtiqueta PROMPT "Sair" Size 65,10*nWebPx   ACTION (__oTelaOP:End())  Pixel Of __oTelaOP
	cCSSBtN1 :=  "QPushButton{background-image: url(rpo:FINAL.png);"+cPush+;
				"QPushButton:pressed {background-image: url(rpo:FINAL.png);"+cPressed+;
				"QPushButton:hover {background-image: url(rpo:FINAL.png);"+cHover
	oEtiqueta:SetCSS( cCSSBtN1 )
	oSelCaixa:Disable()
	Activate MsDialog __oTelaOP

Return

/*
�����������������������������������������������������������������������������            '
�������������������������������������������������������������������������ͻ��
���Programa  � VldEtq   �Autor  �Helio Ferreira      � Data �  15/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da etiqueta para faturamento					  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VldEtiq()

	Local cVldEst := ""
	Local _lRet := .T.
	_cCliEmp    := ""
	_cDescric   := ""
	_cEmbalag   := ""
	_nQtdEmp    := 0
	_aDados     := {}
 
	If Empty(_cNumEtqPA)
		Return .T.
	Elseif len (alltrim(_cNumEtqPA)) > 0
		_cNumEtqPA:= alltrim(_cNumEtqPA) 
	EndIf

//������������������������������������������������������Ŀ
//�Prepara n�mero da etiqueta bipada							�
//��������������������������������������������������������
	If Len(AllTrim(_cNumEtqPA))<=12 //EAN 13 s/ d�gito verificador.
		_cNumEtqPA := "0"+_cNumEtqPA
		_cNumEtqPA := Subs(_cNumEtqPA,1,12)
	EndIf

	SC2->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SBF->( dbSetOrder(2) )

	If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))

		SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))

		//������������������������������������������������������Ŀ
		//�Verifica separa��o												�
		//��������������������������������������������������������

		XD2->(dbSetOrder(1))

		XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

		_cNumOp   := XD1->XD1_OP

		//������������������������������������������������������Ŀ
		//�Atualiza etiqueta bipada										�
		//��������������������������������������������������������

		If aScan(aEmbBip,{ |aVet| aVet[1] == _cNumEtqPA }) == 0

			If !Empty(XD1->XD1_PVSEP)

				If SZY->(dbSeek(xFilial("SZY")+SubStr(XD1->XD1_PVSEP,1,6)))

					nQtdXD1   := 0
					nQuerySZY := 0

					//������������������������������������������������������Ŀ
					//�Verifica pedido de venda										�
					//��������������������������������������������������������
					If !Empty(_cNumPed)
						If ( SZY->ZY_PEDIDO <> _cNumPed ) .And. !Empty(_cNumPed)
							U_MsgColetor("Pedido diferente da coleta atual.")
							_cNumEtqPA := Space(_nTamEtiq)
							__oGetOP:Refresh()
							__oGetOP:SetFocus()
							Return(.F.)
						EndIf
					Else
						//������������������������������������������������������Ŀ                                        /
						//�Busca os volumes pesados para o pedido						�
						//��������������������������������������������������������
						cAliasXD1 := GetNextAlias()
						lVelho := .F.
						If lVelho
							cWhere    := "%SUBSTRING(XD1_PVSEP,1,6) ='"+SZY->ZY_PEDIDO+"' AND XD1_PESOB > 0 AND XD1_ULTNIV = 'S' AND XD1_ZYNOTA = '' AND XD1_OCORRE <> '5'%"
							If lBeginSQL
								BeginSQL Alias cAliasXD1
								SELECT COUNT(*) QTDEVOLXD1, SUM(XD1_PESOB) AS SOMAPESO From %table:XD1% XD1 (NOLOCK)
								WHERE XD1.%NotDel% AND %Exp:cWhere%
								EndSQL
							Else
								cSQL := "SELECT COUNT(*) AS QTDEVOLXD1, SUM(XD1_PESOB) AS SOMAPESO FROM "+RetSQLName("XD1")+" (NOLOCK) WHERE "
								cSQL += StrTran(cWhere    ,'%','') + " AND "
								cSQL += "D_E_L_E_T_ = ''"
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cAliasXD1,.T.,.F.)
							EndIf

							nTotalGrupo := (cAliasXD1)->QTDEVOLXD1
						Else
							cQuery := "SELECT SUM(ZY_QUANT-ZY_QUJE) ZY_QUANT FROM " + RetSqlName("SZY") + " WHERE ZY_PEDIDO = '"+SZY->ZY_PEDIDO+"' AND ZY_NOTA = '' AND ZY_PRVFAT = '"+DtoS(_cDtaFat)+"' AND D_E_L_E_T_ = '' "

							If Select("QUERYSZY")<>0;QUERYSZY->( dbCloseArea() );EndIf

								TCQUERY cQuery NEW ALIAS "QUERYSZY"


								cWhere    := "%SUBSTRING(XD1_PVSEP,1,6) ='"+SZY->ZY_PEDIDO+"' AND XD1_PESOB > 0 AND XD1_ULTNIV = 'S' AND XD1_ZYNOTA = '' AND XD1_OCORRE <> '5'%"

								cSQL := "SELECT XD1_XXPECA, XD1_QTDATU FROM "+RetSQLName("XD1")+" (NOLOCK) WHERE "
								cSQL += StrTran(cWhere    ,'%','') + " AND "
								cSQL += "D_E_L_E_T_ = '' ORDER BY XD1_QTDATU "
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cAliasXD1,.T.,.F.)

								nTotalGrupo := 0
								nQtdXD1     := 0
								nSelCaixa   := 0
								While !(cAliasXD1)->( EOF() )
									nSelCaixa += (cAliasXD1)->XD1_QTDATU
									If nQtdXD1 < QUERYSZY->ZY_QUANT
										If (nQtdXD1+(cAliasXD1)->XD1_QTDATU) <= QUERYSZY->ZY_QUANT
											nQtdXD1 += (cAliasXD1)->XD1_QTDATU
											nTotalGrupo++
										ENDiF
									EndIf
									nQuerySZY += QUERYSZY->ZY_QUANT
									(cAliasXD1)->( dbSkip() )
								End

								If QUERYSZY->ZY_QUANT < nSelCaixa
									oSelCaixa:Enable()
								EndIf

							EndIf

							(cAliasXD1)->(dbCloseArea())

						EndIf

						//������������������������������������������������������Ŀ
						//�Verifica se pedido est� pronto para faturamento		 �
						//��������������������������������������������������������
						If !VerDispFat(SZY->ZY_PEDIDO, SZY->ZY_PRODUTO, _cDtaFat)
							U_MsgColetor("N�o existe previs�o de faturamento desse pedido para a data escolhida")
							_cNumEtqPA := Space(_nTamEtiq)
							__oGetOP:Refresh()
							__oGetOP:SetFocus()
							Return(.F.)
						EndIf

						//������������������������������������������������������Ŀ
						//�Verifica se pedido est� faturado						      �
						//��������������������������������������������������������
						If lFaturado
							U_MsgColetor("Pedido j� faturado, NF: " + cNumNFZY)
							_cNumEtqPA := Space(_nTamEtiq)
							__oGetOP:Refresh()
							__oGetOP:SetFocus()
							Return(.F.)
						EndIf

						//������������������������������������������������������Ŀ
						//�Verifica se pedido est� liberado pelo COMERCIAL  	 �
						//��������������������������������������������������������
						If SC5->( dbSeek( xFilial() + SZY->ZY_PEDIDO ) )
							If SC5->C5_XXLIBCO <> 'S'
								U_MsgColetor("Pedido n�o liberado para faturamento pelo DEPTO. COMERCIAL.")
								_cNumEtqPA := Space(_nTamEtiq)
								__oGetOP:Refresh()
								__oGetOP:SetFocus()
								Return(.F.)
							EndIf
						EndIf

						//������������������������������������������������������Ŀ
						//�Verifica se pedido est� liberado pelo FISCAL		  	 �
						//��������������������������������������������������������
						If SC5->C5_XXLIBFI == '0'
							U_MsgColetor("Pedido n�o liberado para faturamento pelo DEPTO. FISCAL.")
							_cNumEtqPA := Space(_nTamEtiq)
							__oGetOP:Refresh()
							__oGetOP:SetFocus()
							Return(.F.)
						EndIf


						//������������������������������������������������������Ŀ
						//�Verifica se no Pedido existe TES 999         		  	 �
						//��������������������������������������������������������

						//Query
						cQry999 := " SELECT COUNT(*) QTDE "
						cQry999 += " FROM "+RetSqlName("SC6")+" SC6 "
						cQry999 += " WHERE SC6.D_E_L_E_T_ = '' "
						cQry999 += " AND C6_NUM = '"+SC5->C5_NUM+"' AND C6_TES = '999' "

						//Fecha Alias caso encontre
						If Select("TMPSC6") <> 0 ; TMPSC6->(dbCloseArea()) ; EndIf

							//Cria alias temporario
							TcQuery cQry999 New Alias "TMPSC6"

							//Pega Conteudo
							TMPSC6->(DbGoTop())

							If TMPSC6->QTDE > 0
								U_MsgColetor("Pedido com TES 999. Informe o DEPTO. FISCAL.")
								_cNumEtqPA := Space(_nTamEtiq)
								__oGetOP:Refresh()
								__oGetOP:SetFocus()
								Return(.F.)
							EndIf


							//������������������������������������������������������Ŀ
							//�Verifica Contagem de Volumes                 		  	 �
							//��������������������������������������������������������

							If nTotalGrupo == 0
								U_MsgColetor("Erro na contagem dos volumes. Verifique separa��o parcial ou Previs�o de Faturamento."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Qtde Prevista ="+TransForm(nQuerySZY,"@E 999,999.99")+Chr(13)+Chr(10)+"Qtde Lida = "+TransForm(nQtdXd1,"@E 999,999.99"))
								_cNumEtqPA := Space(_nTamEtiq)
								__oGetOP:Refresh()
								__oGetOP:SetFocus()
								Return(.F.)
							EndIf

							//������������������������������������������������������Ŀ
							//�Atualiza dados para o coletor						 �
							//��������������������������������������������������������
							SC5->(dbSeek(xFilial("SC5")+SZY->ZY_PEDIDO))
							_cNumPed  := SC5->C5_NUM
							_cCliEmp  := SC5->C5_CLIENTE
							_cDescric := Posicione("SA1",1,xFilial("SA1")+_cCliEmp,"A1_NOME")
							lHuawei 	 := If("HUAWEI" $ AllTrim(_cDescric), .T., .F.)

							oTxtProdCod:Refresh()
							oTxtProdEmp:Refresh()
							oTxtQtdEmp:Refresh()
							//					oTxtDescric:=Refresh()        // mauresi em 05/03/2018
							oNumOp:Refresh()
							oTxtQtdEmp:Refresh()
							__oTelaOP:Refresh()

							//������������������������������������������������������Ŀ
							//�Coleta etiqueta bipada								 �
							//��������������������������������������������������������
							_nQtd     += 1
							nQtdCaixa += XD1->XD1_QTDATU
							AADD(aEmbBip,{_cNumEtqPA,XD1->XD1_QTDATU,XD1->( Recno() )})
							cVolumeAtu  := PADL(AllTrim(Str(_nQtd))+"/"+AllTrim(Str(nTotalGrupo)),18)

							lFaturado  := .F.
							cTipoSenf  := ""
							_cNumEtqPA := Space(_nTamEtiq)
							oSldGrupo:Refresh()
							__oGetOP:SetFocus()

							If _nQtd == nTotalGrupo

								//������������������������������������������������������Ŀ
								//�Desmonta embalagem para verificar quantidades		 �
								//��������������������������������������������������������
								aDesmonta := DesmontaVol(SZY->ZY_PEDIDO, _cDtaFat , aEmbBip)
								//nDesmonta := aDesmonta[2]
								If !aDesmonta[1] //nDesmonta <> nQtdCaixa
									If aDesmonta[2] <> aDesmonta[3]
										U_MsgColetor("Quantidades de volumes incompat�vel com o pedido."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Qtde. prevista = "+Alltrim(str(aDesmonta[2]))+Chr(13)+Chr(10)+"Qtde. Lida = "+Alltrim(str(aDesmonta[3]))+Chr(13))
										_cNumEtqPA := Space(_nTamEtiq)
										__oGetOP:Refresh()
										__oGetOP:SetFocus()
										Return ( .F. )
									EndIf
								EndIf

								//������������������������������������������������������Ŀ
								//�Validando saldos para emiss�o da NF - JONAS 28/05/2020    	�
								//��������������������������������������������������������

								MsgRun("Validando saldos","Aguarde...",{|| cVldEst := U_VLQTDFAT(SZY->ZY_PEDIDO, _cDtaFat) })
								If !Empty(cVldEst)
									U_MsgColetor(cVldEst)
									Return ( .F. )
								EndIf

								//DesmontaVol(SZY->ZY_PEDIDO, _cDtaFat , aEmbBip)


								//������������������������������������������������������Ŀ
								//�Gera Nota Fiscal													�
								//��������������������������������������������������������
								If !U_GerNfColetor()
									_cNumPed    := ""
									_cCliEmp    := ""
									_cDescric   := ""
									_nQtd       := 0
									_cNumEtqPA  := Space(_nTamEtiq)
									cTipoSenf   := ""
									_lRet       := .T.
									aEmbBip     := {}
									nTotalGrupo := 0
									__oTelaOP:Refresh()
									__oGetOP:Refresh()
									Return ( .T. )
								Else
									_cNumEtqPA  := Space(_nTamEtiq)
									_nQtd       := 0
									aEmbBip     := {}
									nTotalGrupo := 0
									__oGetOP:Refresh()
									__oGetOP:SetFocus()
									Return ( .F. )
								EndIf

							EndIf

						EndIf

					Else

						U_MsgColetor("Pedido sem separa��o conclu�da.")
						_cNumEtqPA := Space(_nTamEtiq)
						__oGetOP:Refresh()
						__oGetOP:SetFocus()
						_lRet:=.F.

					EndIf

				Else
					_cNumEtqPA := Space(_nTamEtiq)
					__oGetOP:Refresh()
					__oGetOP:SetFocus()
					_lRet:=.F.
					cTipoSenf := ""
				EndIf
			Else

				U_MsgColetor("Etiqueta n�o encontrada.")
				_cNumEtqPA := Space(_nTamEtiq)
				__oGetOP:Refresh()
				__oGetOP:SetFocus()
				_lRet:=.F.

			EndIf

			_cNumEtqPA := Space(_nTamEtiq)
			_lRet      := .T.
			cTipoSenf  := ""
			__oGetOP:Refresh()
			__oGetOP:SetFocus()


//RESET ENVIRONMENT

			Return(_lRet)

/*
�����������������������������������������������������������������������������            '
�������������������������������������������������������������������������ͻ��
���Programa  �VerDispFat�Autor  �Helio Ferreira      � Data �  15/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica se produtos est�o dispon�veis para faturamento    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerDispFat(cVerPedido, cVerProduto, dVerData)

	LOCAL	cWhere    := "%ZY_PEDIDO ='"+cVerPedido+"' AND ZY_PRVFAT ='"+Dtos( dVerData )+"'%"
	LOCAL	cAliasSZY := GetNextAlias()
	LOCAL lFatura   := .T.

	If lBeginSQL
		BeginSQL Alias cAliasSZY
		SELECT ZY_PEDIDO, ZY_PRODUTO, ZY_QUANT, ZY_PRVFAT, ZY_NOTA
		From %table:SZY% SZY (NOLOCK)
		JOIN %table:SB1% SB1 (NOLOCK)
		ON B1_FILIAL =  %Exp:xFilial("SB1")%  
		AND B1_COD = ZY_PRODUTO
		WHERE ZY_FILIAL =  %Exp:xFilial("SZY")%  
		AND SZY.%NotDel%
		And SB1.%NotDel%
		And %Exp:cWhere%
		EndSQL
	Else
		cQuery := "SELECT ZY_PEDIDO, ZY_PRODUTO, ZY_QUANT, ZY_PRVFAT, ZY_NOTA " +Chr(13)+chr(10)
		cQuery += "			From "+RetSqlName("SZY")+" SZY (NOLOCK) "                   + Chr(13)+chr(10)
		cQuery += "			JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) "                   + Chr(13)+chr(10)
		cQuery += "			ON B1_COD = ZY_PRODUTO   "                   + Chr(13)+chr(10)
		cQuery += "			AND B1_FILIAL = '"+xFilial("SB1")+"' "
		cQuery += "			WHERE SZY.D_E_L_E_T_ = '' "                  + Chr(13)+chr(10)
		cQuery += "			AND ZY_FILIAL = '"+xFilial("SZY")+"' "
		cQuery += "					And SB1.D_E_L_E_T_ = '' "              + Chr(13)+chr(10)
		cQuery += "					And " + StrTran(cWhere    ,'%','')     + Chr(13)+chr(10)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSZY,.T.,.F.)
	EndIf

	lPrevisto := .F.
	If (cAliasSZY)->(Eof())
		lFatura := .F.
	Else
		Do While (cAliasSZY)->(!Eof())
			If Empty((cAliasSZY)->ZY_NOTA)
				lPrevisto := .T.
			EndIf
			lFaturado := If( !Empty((cAliasSZY)->ZY_NOTA), .T., .F. )
			cNumNFZY  := (cAliasSZY)->ZY_NOTA
			(cAliasSZY)->(dbSkip())
		EndDo
		If lPrevisto
			lFaturado := .F.
		Endif
	EndIf
	(cAliasSZY)->(dbCloseArea())

Return ( lFatura )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DesmontaVol�Autor�Michel Sander       � Data �  09/15/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Desmonta os volumes para verificar as quantidades          ���
���          � contra o pedido de venda que ser� faturado                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DesmontaVol(cPedido, dData, aEtqBip)

	Local aTemp   := {}
	Local x       := 0
	Local y       := 0
	
	XD1->( dbSetOrder(1) )
	XD2->( dbSetOrder(1) )

//�������������������������������������������������������������������������Ŀ
//�Cria array para explos�o das emmbalagens                                 �
//���������������������������������������������������������������������������
	For x := 1 to Len(aEtqBip)
		cEtq  := aEtqBip[x,1]
		If XD1->( dbSeek( xFilial() + cEtq ) )
			lSeek := (XD2->( dbSeek(xFilial() + cEtq ) ) .and. XD1->XD1_NIVEMB <> '1')
			AADD(aTemp,{aEtqBip[x,1],If(lSeek,'1','2')})
		EndIf
	Next x

//�������������������������������������������������������������������������Ŀ
//�Explode o conte�do das embalagens que ser�o faturadas nesse pedido       �
//���������������������������������������������������������������������������
	For x := 1 to 10000 //Len(aTemp)

		If x > len(aTemp)
			exit
		Endif

		If aTemp[x,2] == '1'
			cEtq := ALLTRIM(aTemp[x,1])
			If XD1->( dbSeek( xFilial() + cEtq ) )
				If XD2->( dbSeek(xFilial() + cEtq ) ) .and. XD1->XD1_NIVEMB <> '1'
					While !XD2->( EOF() ) .and. AllTrim(XD2->XD2_XXPECA) == cEtq
						AADD(aTemp,{XD2->XD2_PCFILH,'0'})
						XD2->( dbSkip() )
					End
				Else
					aTemp[x,2] := '2'
				EndIf
			EndIf
		EndIf

		If aTemp[x,2] == '0'
			cEtq := ALLTRIM(aTemp[x,1])
			If XD1->( dbSeek( xFilial() + cEtq ) )
				If XD2->( dbSeek(xFilial() + cEtq ) ) .and. XD1->XD1_NIVEMB <> '1'
					aTemp[x,2] := '1'
					While !XD2->( EOF() ) .and. AllTrim(XD2->XD2_XXPECA) == cEtq
						AADD(aTemp,{XD2->XD2_PCFILH,'0'})
						XD2->( dbSkip() )
					End
				Else
					aTemp[x,2] := '2'
				EndIf
			EndIf
		EndIf
	Next x

//�������������������������������������������������������������������������Ŀ
//�Agrupa as quantidades por produto												    �
//���������������������������������������������������������������������������
	aAreaXD1 := XD1->( GetArea() )
	XD1->( dbSetOrder(1) )
	aVetProd := {}
	For x := 1 to Len(aTemp)
		If aTemp[x,2] == '2'
			cEtq := aTemp[x,1]
			If XD1->( dbSeek( xFilial() + cEtq ) )
				nTemp := aScan(aVetProd,{|aVet| aVet[1] == XD1->XD1_COD })
				If Empty(nTemp)
					AADD(aVetProd,{XD1->XD1_COD,XD1->XD1_QTDATU})
				Else
					aVetProd[nTemp,2] += XD1->XD1_QTDATU
				EndIf
			EndIf
		EndIf
	Next x
	RestArea(aAreaXD1)

//�������������������������������������������������������������������������Ŀ
//�Verifica as quantidades que ser�o faturadas no dia					    �
//���������������������������������������������������������������������������
	aAreaSZY  := SZY->(GetArea())
	lDiverge  := .T.
	nQtdSZY   := 0
	aVetSZY   := {}

	If SZY->(dbSeek(xFilial("SZY")+cPedido))
		Do While SZY->(!Eof()) .And. SZY->ZY_FILIAL+SZY->ZY_PEDIDO == xFilial("SZY")+cPedido
			If SZY->ZY_PRVFAT == dData .And. Empty(SZY->ZY_NOTA)
				nTemp := aScan( aVetSZY, { |aVet| aVet[1] == SZY->ZY_PRODUTO } )
				If Empty(nTemp)
					AADD(aVetSZY,{SZY->ZY_PRODUTO,SZY->ZY_QUANT})
				Else
					aVetSZY[nTemp,2] += SZY->ZY_QUANT
				EndIf
			EndIf
			SZY->(dbSkip())
		EndDo
	EndIf

	aSort(aVetSZY ,,,{|X,Y| X[1] > Y[1] })
	aSort(aVetProd,,,{|X,Y| X[1] > Y[1] })

	_Retorno := {.T.,0,0}
	If Len(aVetSZY) <> Len(aVetProd)
		_Retorno[1] := .F.
		For x := 1 to Len(aVetSZY)
			_Retorno[2] += aVetSZY[x,2]
			_Retorno[3] += aVetProd[x,2]
		Next x
	Else
		For x := 1 to Len(aVetSZY)
			If aVetSZY[x,2] <> aVetProd[x,2]
				_Retorno[1] := .F.
			EndIf
			_Retorno[2] += aVetSZY[x,2]
			_Retorno[3] += aVetProd[x,2]
		Next x
	EndIf

	RestArea(aAreaSZY)

Return ( _Retorno )

