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
���Desc.     � Tela de Faturamento de Pedidos					  			 	  ���
���          � 														      			  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DOMACD23()

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
Private lBeginSQL      := .T.

dDataBase := Date()

If cUsuario == 'HELIO'
	//_cNumEtqPA := Space(_nTamEtiq)
	//_cNumEtqPA := '000023417588   '
	//_cDtaFat   := CtoD("")
EndIf

//U_MsgColetor("Favor avisar Denis.")

//Return


Define MsDialog __oTelaOP Title OemToAnsi("Faturamento " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,001 Say __oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaOP
@ nLin-2,045 MsGet __oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70,10 Pixel Of __oTelaOP
__oTxtEtiq:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
__oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 018,001 To 065,115 Pixel Of oMainWnd PIXEL

nLin += 015
@ nLin,005 Say __oTxtOP Var "Num.OP: " Pixel Of __oTelaOP
@ nLin,027 Say oNumOP Var _cNumOP Size 120,10 Pixel Of __oTelaOP
@ nLin,077 Say oTxtQtdEmp   Var "Qtd: "+ TransForm(_nQtdEmp,"@E 999,999.99") Pixel Of __oTelaOP
oNumOp:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
oTxtQtdEmp:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaOP
@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaOP
oTxtProdCod:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin,005 Say oTxtDes      Var "Descri��o: "      Pixel Of __oTelaOP
@ nLin,035 say oTxtDescPro  Var _cDescric      Size 075,15 Pixel Of __oTelaOP
oTxtDescPro:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
nLin+= 30
@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of __oTelaOP
@ nLin,023 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120,10 Pixel Of __oTelaOP
oNumPed:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)

nLin+= 05
@ 070,001 To 145,115 Pixel Of oMainWnd PIXEL
nLin+= 10

@ nLin,005 SAY oTxtDescEmb Var _cDescEmb 		 Pixel Of __oTelaOP
oTxtDescEmb:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)

nLin += 10
@ nLin,005   Say   oTxtDtfat Var "Faturamento:" Pixel Of __oTelaOP
//@ nLin-1,060 MSGET oDataFat  Var _cDtaFat When .T. VALID vlddata() Size 50,10 Pixel Of __oTelaOP
@ nLin-1,060 Say oDataFat  Var _cDtaFat  Size 50,10 Pixel Of __oTelaOP        // MAURESI - Alterado em 24/05/2019 ( Evitar erro ao alimentar ZY_NOTA )
nLin+= 11

@ nLin,005   Say oTxtSldGrupo Var "Volumes do Pedido:" Pixel Of __oTelaOP
@ nLin-1,060 MSGET oSldGrupo  Var cVolumeAtu When .F. Size 50,10 Pixel Of __oTelaOP
oSldGrupo:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 15

@ nLin,005 Button oSelCaixa PROMPT "Volume Parcial" Size 50,10 Action U_fMontaSelCx(__oTelaOP) Pixel Of __oTelaOP
@ nLin,077 Button oEtiqueta PROMPT "Sair" Size 35,10 Action (__oTelaOP:END()) Pixel Of __oTelaOP
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
If Len(AllTrim(_cNumEtqPA))==12 //EAN 13 s/ d�gito verificador.
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
	
	//If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
	
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
					nDesmonta := aDesmonta[2]
					If !aDesmonta[1] //nDesmonta <> nQtdCaixa
						If nQtdCaixa <> nDesmonta
							U_MsgColetor("Quantidades de volumes incompat�vel com o pedido."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Qtde. prevista = "+Alltrim(str(nDesmonta))+Chr(13)+Chr(10)+"Qtde. Lida = "+Alltrim(str(nQtdCaixa))+Chr(13))
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
	
	//Else
	//	U_MsgColetor("Pr�ximo n�vel de Embalagem n�o encontrada.")
	//	_cNumEtqPA := Space(_nTamEtiq)
	//	__oGetOP:Refresh()
	//	__oGetOP:SetFocus()
	//	cTipoSenf := ""
	//	_lRet:=.F.
	//EndIf
	
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
		ON B1_FILIAL = '' AND B1_COD = ZY_PRODUTO
		WHERE SZY.%NotDel%
		And SB1.%NotDel%
		And %Exp:cWhere%
	EndSQL
Else
	cQuery := "SELECT ZY_PEDIDO, ZY_PRODUTO, ZY_QUANT, ZY_PRVFAT, ZY_NOTA " + Chr(13)
	cQuery += "			From SZY010 SZY (NOLOCK) "                   + Chr(13)
	cQuery += "			JOIN SB1010 SB1 (NOLOCK) "                   + Chr(13)
	cQuery += "			ON B1_COD = ZY_PRODUTO   "                   + Chr(13)
	cQuery += "			WHERE SZY.D_E_L_E_T_ = '' "                  + Chr(13)
	cQuery += "					And SB1.D_E_L_E_T_ = '' "              + Chr(13)
	cQuery += "					And " + StrTran(cWhere    ,'%','')     + Chr(13)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSQL),cAliasSZY,.F.,.T.)
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

_Retorno := {.T.,0}
If Len(aVetSZY) <> Len(aVetProd)
	_Retorno[1] := .F.
	For x := 1 to Len(aVetSZY)
		_Retorno[2] += aVetSZY[x,2]
	Next x
Else
	For x := 1 to Len(aVetSZY)
		If aVetSZY[x,2] <> aVetProd[x,2]
			_Retorno[1] := .F.
		EndIf
		_Retorno[2] += aVetSZY[x,2]
	Next x
EndIf

RestArea(aAreaSZY)

Return ( _Retorno )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fMontaSelCx �Autor  �Michel Sander     � Data �  09/29/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para digita��o dos volumes parciais para faturamento  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fMontaSelCx(__oTelaOp)

LOCAL nOpcVol := 0
LOCAL nAuxVol := nTotalGrupo

Define MsDialog oTelaVol Title OemToAnsi("VOLUME Parcial") From 20,20 To 180,200 Pixel of oMainWnd PIXEL
nLin := 025
@ nLin,003 Say oTxtVol     Var "Volume" Pixel Of oTelaVol
@ nLin-2,030 MsGet oGetVol Var nTotalGrupo Valid (nTotalGrupo <= nAuxVol) When .T. Picture "@E 999999" Size 50,10 Pixel Of oTelaVol
oTxtVol:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetVol:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin+= 010
@ nLin,030 Button oBotVol PROMPT "Confirma" Size 35,15 Action {|| nOpcVol:=1,oTelaVol:End()} Pixel Of oTelaVol
Activate MsDialog oTelaVol


cVolumeAtu  := PADL(AllTrim(Str(1))+"/"+AllTrim(Str(nTotalGrupo)),18)

//If AllTrim(cVolumeAtu)=="1/1"

//������������������������������������������������������Ŀ
//�Gera Nota Fiscal													�
//��������������������������������������������������������
If !U_GerNfColetor()
	_cNumPed    := ""
	_cCliEmp    := ""
	_cDescric   := ""
	_nQtd       := 0
	_cNumEtqPA  := Space(_nTamEtiq)
	aEmbBip     := {}
	nTotalGrupo := 0
	__oTelaOP:Refresh()
	__oGetOP:Refresh()
Else
	_cNumPed    := ""
	_cCliEmp    := ""
	_cDescric   := ""
	_nQtd       := 0
	_cNumEtqPA  := Space(_nTamEtiq)
	aEmbBip     := {}
	nTotalGrupo := 0
	__oTelaOP:Refresh()
	__oGetOP:Refresh()
	__oGetOP:SetFocus()
EndIf

//EndIf

oSelCaixa:Disable()
oSldGrupo:Refresh()
__oGetOP:SetFocus()

Return

/*
�����������������������������������������������������������������������������            '
�������������������������������������������������������������������������ͻ��
���Programa  �GerNfColetor�Autor  �Michel Sander      � Data �  15/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera Nota Fiscal de Sa�da pelo Coletor de Dados			     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GerNfColetor()

LOCAL lFatRet := .F.
Local	cRisco
Local	lCondE
Local ___x

If U_uMsgYesNo("Deseja gerar NOTA FISCAL?")
	
	//�����������������������������������������������������������������������������Ŀ
	//�Valida se � Cliente Risco E e se tem limite de cr�dito para faturar          �
	//�������������������������������������������������������������������������������
	SC5->(dbSetOrder(1))
	SC5->(dbSeek( xFilial() + SZY->ZY_PEDIDO ) )
	
	If SuperGetMV("MV_XANACRE")    // Par�metro geral de liga/desliga an�lise de Cr�dito Domex
		lContinua := U_ValidFat(SZY->ZY_PEDIDO)
		
		If !lContinua                          
		   _cNumEtqPA := Space(_nTamEtiq)
		   __oGetOP:Refresh()
			__oGetOP:SetFocus()
				
		   Return .F.
		EndIf
	EndIf
	
	cSerNF := "001"
	cNF    := U_GeraNFS(SZY->ZY_PEDIDO, cSerNF, _cDtaFat, lHuawei)
	
	If Subs(cNF,1,4) == "ERRO" .OR. Empty(cNF)
		U_MsgColetor("Nota Fiscal n�o gerada: " + cNF+ ".")
		lFatRet := .F.
	Else
		SF2->( dbSetOrder(1) )
		If SF2->( dbSeek( xFilial() + cNF + cSerNF ) )
			
			// Atualiza as etiquetas dos volumes que ser�o faturados
			XD5->(dbSetOrder(2))
			For ___x := 1 TO Len(aEmbBip)
				XD1->( dbGoto( aEmbBip[___x,3] ) )
				If XD1->( Recno() ) == aEmbBip[___x,3]
					Reclock("XD1",.F.)
					XD1->XD1_ZYNOTA  := SF2->F2_DOC
					XD1->XD1_ZYSERIE := SF2->F2_SERIE
					XD1->XD1_ZYDTNF  := SF2->F2_EMISSAO
					XD1->( msUnlock() )
					If !Empty(XD1->XD1_OP)
						If XD5->(dbSeek(xFilial()+XD1->XD1_OP))
							cSQL := "UPDATE "+RetSQLName("XD5")
							cSQL += " SET XD5_NOTA='"+SF2->F2_DOC     +"',"
							cSQL += "   XD5_SERIE ='"+SF2->F2_SERIE   +"',"
							cSQL += "   XD5_CLIENT='"+SF2->F2_CLIENTE +"',"
							cSQL += "   XD5_LOJA  ='"+SF2->F2_LOJA    +"',"
							cSQL += "   XD5_ITEM  ='"+SUBSTR(XD1->XD1_PVSEP,7,2)+"' WHERE D_E_L_E_T_='' AND XD5_PECA = '"+XD1->XD1_XXPECA+"'"
							TCSQLEXEC(cSQL)
						EndIf
					EndIf
				EndIf
			Next ___x
			
			//������������������������������������������������������Ŀ
			//�Atualiza o peso e o volume da nota fiscal			 �
			//��������������������������������������������������������
			U_AtuPesoNf( SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_EMISSAO )
			
			//������������������������������������������������������Ŀ
			//�Atualiza dados de exporta��o									�
			//��������������������������������������������������������
			U_GeraCDL(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
			
			//������������������������������������������������������Ŀ
			//�Transmite a nota fiscal								 �
			//��������������������������������������������������������
			If U_uMsgYesNo("Nota Fiscal '"+SF2->F2_DOC+"' s�rie '"+SF2->F2_SERIE+"' gerada. Deseja transmitir ao SEFAZ?")
				
				
				If 'HOMOLOG' $ Upper(GetEnvServer())
					AutoNfeEnv(cEmpAnt,SF2->F2_FILIAL,"0","2",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC) // Evio em Homologacao.
				else
					AutoNfeEnv(cEmpAnt,SF2->F2_FILIAL,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)
				endif
				
				
				If SF2->F2_FIMP == 'T'  // Status de NF transmitida
					
					__cNumGuia := 0
					If SF2->F2_EST <> 'SP' .And. ( SF2->F2_ICMSRET > 0 )
						
						cTpOper  := "2"		// Nota Fiscal de Saida
						cTpDoc   := "N"      // Tipo de Documento (N= Normal)
						cTpGuia  := "S"		// Gera Guia SIM ou NAO
						cAmbGnre := "1"		// Ambiente WebServices (1=Ambiente Produ��o 2=Ambiente Homologa��o)
						
						
						//������������������������������������������������������Ŀ
						//�Busca o pr�ximo n�mero da guia GNRE							�
						//��������������������������������������������������������
						cAliasSF6 := GetNextAlias()
						BEGINSQL Alias cAliasSF6
							SELECT MAX(CAST(SUBSTRING(F6_NUMERO,5,8) AS INT)) NUMGUIA FROM %table:SF6% (NOLOCK) SF6
							WHERE SUBSTRING(F6_NUMERO,1,4)='ICM0'
						ENDSQL
						__cNumGuia := (cAliasSF6)->NUMGUIA+1
						(cAliasSF6)->(dbCloseArea())
						//												cNumGuia := Val(Posicione("SX5",1,xFilial("SX5")+"53"+"ICMS","X5_DESCRI"))+1
						
						SF6->(dbSetOrder(3))
						If !SF6->(dbSeek(SF2->F2_FILIAL+cTpOper+PADR(cTpDoc,2)+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
							
							//������������������������������������������������������Ŀ
							//�Incrementa o n�mero da guia GNRE								�
							//��������������������������������������������������������
							dbSelectArea("SX5")
							If SX5->(dbSeek(xFilial()+"53"+"ICMS"))
								RecLock("SX5",.F.)
								SX5->X5_DESCRI  := StrZero(__cNumGuia,12)
								SX5->X5_DESCSPA := StrZero(__cNumGuia,12)
								SX5->X5_DESCENG := StrZero(__cNumGuia,12)
								SX5->(MsUnlock())
							EndIf
							
							//������������������������������������������������������Ŀ
							//�Gera os dados da guia no arquivo de GNRE					�
							//��������������������������������������������������������
							Reclock("SF6",.T.)
							SF6->F6_FILIAL  := xFilial("SF6")
							SF6->F6_EST     := SF2->F2_EST
							SF6->F6_NUMERO  := "ICM"+StrZero(__cNumGuia,9)
							SF6->F6_VALOR   := SF2->F2_ICMSRET
							SF6->F6_DTARREC := SF2->F2_EMISSAO
							SF6->F6_DTVENC  := SF2->F2_EMISSAO
							SF6->F6_MESREF  := Month(SF2->F2_EMISSAO)
							SF6->F6_ANOREF  := Year(SF2->F2_EMISSAO)
							SF6->F6_CODREC  := "100099"
							SF6->F6_TIPOIMP := "3"
							SF6->F6_DOC     := SF2->F2_DOC
							SF6->F6_SERIE   := SF2->F2_SERIE
							SF6->F6_CLIFOR  := SF2->F2_CLIENTE
							SF6->F6_LOJA    := SF2->F2_LOJA
							SF6->F6_OPERNF  := cTpOper
							SF6->F6_TIPODOC := cTpDoc
							SF6->F6_CNPJ    := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
							SF6->F6_CODPROD := If ( AllTrim(SF2->F2_EST) $ GetMv("MV_GNREPRO") , 46, 0)
							SF6->F6_DTPAGTO := SF2->F2_EMISSAO
							SF6->F6_REF		 := "1" // Mensal -  Tratar GNRE de Sergipe.   Mauresi - 01/08/2017.

							// Alimenta campos novos na Guia para n�o dar erro de transmissao, ap�s atualizacao de 15/10/2020
							IF SF2->F2_EST $ "AC/AL/AP/BA/CE/DF/GO/MA/MG/MS/MT/PA/PI/PR/RO/RR/SE/TO/"
								SF6->F6_TIPOGNU='10'
								SF6->F6_DOCORIG='1'
							elseif   SF2->F2_EST $  "AM/PE/RS/"
								SF6->F6_TIPOGNU='22'
								SF6->F6_DOCORIG='2'
							elseif   SF2->F2_EST $  "SC/"
								SF6->F6_TIPOGNU='24'
								SF6->F6_DOCORIG='2'
							ENDiF

							SF6->(MsUnlock())
							
							
							//������������������������������������������������������Ŀ
							//� Cria amarracao da Guia na Tabela CDC - Resolve Erro no SPED FISCAL
							//  mauresi - Marco Aurelio (11/10/2017)
							//��������������������������������������������������������
							RecLock("CDC",.T.)
							CDC->CDC_FILIAL		    := xFilial("CDC")
							CDC->CDC_TPMOV			:= "S"
							CDC->CDC_DOC			:= SF2->F2_DOC
							CDC->CDC_SERIE			:= SF2->F2_SERIE
							CDC->CDC_CLIFOR		    := SF2->F2_CLIENTE
							CDC->CDC_LOJA			:= SF2->F2_LOJA
							CDC->CDC_GUIA			:= "ICM"+StrZero(__cNumGuia,9)
							CDC->CDC_UF				:= SF2->F2_EST
							CDC->CDC_IFCOMP		    := "000001"
							CDC->CDC_DCCOMP		    := ""
							CDC->CDC_SDOC			:= "001"
							CDC->(MsUnLock())
							
							//������������������������������������������������������Ŀ
							//�Gera o titulo da GNRE no contas a pagar					�
							//��������������������������������������������������������
							//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
							SE2->(dbSetOrder(1))
							If !SE2->(dbSeek(xFilial()+"ICM"+StrZero(__cNumGuia,9)+SPace(1)+PADR("TX",3)+"ESTADO"+"00"))
								Reclock("SE2",.T.)
								SE2->E2_FILIAL  := xFilial("SE2")
								SE2->E2_PREFIXO := "ICM"
								SE2->E2_NUM     := StrZero(__cNumGuia,9)
								SE2->E2_TIPO    := "TX"
								SE2->E2_NATUREZ := "ICMS"
								SE2->E2_FORNECE := "ESTADO"
								SE2->E2_LOJA    := "00"
								SE2->E2_NOMFOR  := "ESTADO"
								SE2->E2_EMISSAO := SF2->F2_EMISSAO
								SE2->E2_VENCTO  := SF2->F2_EMISSAO
								SE2->E2_VENCREA := SF2->F2_EMISSAO
								SE2->E2_VALOR   := SF2->F2_ICMSRET
								SE2->E2_EMIS1   := SF2->F2_EMISSAO
								SE2->E2_LA      := "N"
								SE2->E2_SALDO   := SF2->F2_ICMSRET
								SE2->E2_VENCORI := SF2->F2_EMISSAO
								SE2->E2_MOEDA   := 1
								SE2->E2_VLCRUZ  := SF2->F2_ICMSRET
								SE2->E2_ORIGEM  := "MATA460A"
								SE2->E2_FILORIG := "01"
								SE2->(MsUnlock())
							EndIf
							
							//������������������������������������������������������Ŀ
							//�Atualiza guia GNRE na nota fiscal de sa�da				�
							//��������������������������������������������������������
							Reclock("SF2",.F.)
							SF2->F2_NFICMST 	:= "ICM"+StrZero(__cNumGuia,9)
							SF2->(MsUnlock())
							
						EndIf
						
					Else
						
						cTpGuia := "N"
						
					EndIf
					
					//������������������������������������������������������Ŀ
					//�Atualiza��o da Nota Fiscal										�
					//��������������������������������������������������������
					Reclock("SF2",.F.)
					SF2->F2_XXAUTNF := "N"      // Flag se a NF j� foi impressa pela rotina automatica de impress�o na expedi��o
					SF2->F2_XXGUIA  := cTpGuia  // Se tem guia ou n�o
					SF2->(MsUnlock())
					lFatRet := .T. //Return ( .T. )
					
					//������������������������������������������������������Ŀ
					//�Atualiza dados de exporta��o									�
       			//��������������������������������������������������������               
       			If SuperGetMV("MV_XANACRE")    // Par�metro geral de liga/desliga an�lise de Cr�dito Domex
		       	   U_TRATASE1(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
		       	EndIf
				Else
					
					U_MsgColetor("Nota Fiscal n�o transmitida.")
					cTxtMsg  := "Verificar erro de envio ao SEFAZ para a NOTA FISCAL "+SF2->F2_DOC+" atrav�s do coletor de dados na EXPEDI��O."
					cAssunto := "Erro de envio NF EXPEDI��O ao SEFAZ"
					cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
					cPara    := 'denis.vieira@rdt.com.br;priscila.silva@rdt.com.br;ludmila.guimaraes@rosenbergerdomex.com.br;juliana.gomes@rosenbergerdomex.com.br;sergio.santos@rdt.com.br;luciano.silva@rosenbergerdomex.com.br'
					cCC      := ""
					cArquivo := Nil
					U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
					lFatRet := .F.
					
				EndIf
				
			Else
				
				U_MsgColetor("Transmiss�o cancelada.")
				lFatRet := .F.
				
			EndIf
			
		Else
			
			U_MsgColetor("Nota gerada mas n�o encontrada no SF2.")
			lFatRet := .F.
			
		EndIf
		
	EndIf
	
Else
	
	lFatRet := .F.
	
EndIf

Return ( lFatRet )
