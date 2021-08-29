#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMACD29  บAutor  ณMichel Sander       บ Data ณ  23.02.17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desmontagem de Embalagens								 			  บฑฑ
ฑฑบ          ณ 														                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMACD29()

Private oTxtOP,__oGetOP,__oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti,oEtiqueta,oDesmonta
Private _nTamEtiq      := 21
Private _cNumEtqPA     := Space(_nTamEtiq)
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _nQtd          := CriaVar("XD1_QTDATU",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private cEtqDesmonta   := ""
Private _aCols         := {}
Private _lAuto	        := .T.
Private _lIndividual   := .T.
Private lFaturado      := .F.
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
Private cGrupoesp      := "'TRUN'"  //"'TRUN','CORD'"
Private lBeginSQL      := .F.
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
	_cNumEtqPA := Space(_nTamEtiq)
	//_cNumEtqPA := '00001925766x   '
	_cDtaFat   := CtoD("16/02/17")
EndIf

Define MsDialog __oTelaOP Title OemToAnsi("Desmontagem " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

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
@ nLin,005 Say oTxtDes      Var "Descri็ใo: "      Pixel Of __oTelaOP
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
@ nLin,005   Say oTxtSldGrupo Var "Volumes do Pedido:" Pixel Of __oTelaOP
@ nLin-1,060 MSGET oSldGrupo  Var cVolumeAtu When .F. Size 50,10 Pixel Of __oTelaOP
oSldGrupo:oFont:= TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 35
@ nLin,005 Button oDesmonta PROMPT "Desmonta Embalagem" Size 60,10 Action Desmonta() Pixel Of __oTelaOP
@ nLin,077 Button oEtiqueta PROMPT "Sair" Size 35,10 Action Close(__oTelaOP) Pixel Of __oTelaOP
oDesmonta:Disable()

Activate MsDialog __oTelaOP

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldEtq   บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da etiqueta para faturamento						     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldEtiq()

Local _lRet := .T.
_cCliEmp    := ""
_cDescric   := ""
_cEmbalag   := ""
_nQtdEmp    := 0
_aDados     := {}

If Empty(_cNumEtqPA)
	Return ( .T. )
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPrepara n๚mero da etiqueta bipada							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(AllTrim(_cNumEtqPA))==12 //EAN 13 s/ dํgito verificador.
	_cNumEtqPA := "0"+_cNumEtqPA
	_cNumEtqPA := Subs(_cNumEtqPA,1,12)
EndIf

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SBF->( dbSetOrder(2) )
XD1->( dbSetOrder(1) )
XD2->( dbSetOrder(1) )

If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))
	
	SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica nivel														ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If XD1->XD1_ULTNIV <> 'S'
		U_MsgColetor("A embalagem nใo pode ser desmontada, pois nใo se apresenta como o ๚ltimo nํvel de embalagem.")
		_cNumEtqPA := Space(_nTamEtiq)
		__oGetOP:Refresh()
		__oGetOP:SetFocus()
		Return(.F.)
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSalva etiqueta bipada											ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   cEtqDesmonta := _cNumEtqPA
   
	If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
		
		_cNumOp   := XD1->XD1_OP
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza etiqueta bipada										ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If aScan(aEmbBip,{ |aVet| aVet[1] == _cNumEtqPA }) == 0
			
			If SZY->(dbSeek(xFilial("SZY")+SubStr(XD1->XD1_PVSEP,1,6)))
				
            /* 
            // Retirado por Michel Sander em 19.07.2018 para permitir desmontagem apenas para caixas nใo faturadas
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica se pedido estแ pronto para faturamento			ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				VerDispFat(SZY->ZY_PEDIDO, SZY->ZY_PRODUTO, _cDtaFat)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณVerifica se pedido estแ faturado								ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If lFaturado
					U_MsgColetor("Pedido jแ faturado.")
					_cNumEtqPA := Space(_nTamEtiq)
					__oGetOP:Refresh()
					__oGetOP:SetFocus()
					Return(.F.)
				EndIf
            */

				If !Empty(XD1->XD1_ZYNOTA)
					U_MsgColetor("Embalagem jแ faturada.")
					_cNumEtqPA := Space(_nTamEtiq)
					__oGetOP:Refresh()
					__oGetOP:SetFocus()
					Return(.F.)
				EndIf
            
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza dados para o coletor									ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				SC5->(dbSeek(xFilial("SC5")+SZY->ZY_PEDIDO))
				_cNumPed  := SC5->C5_NUM
				_cCliEmp  := SC5->C5_CLIENTE
				_cDescric := Posicione("SA1",1,xFilial("SA1")+_cCliEmp,"A1_NOME")

				oTxtProdCod:Refresh()
				oTxtProdEmp:Refresh()
				oTxtQtdEmp:Refresh()
//				oTxtDescric:=Refresh()
				oNumOp:Refresh()
				oTxtQtdEmp:Refresh()
				__oTelaOP:Refresh()
				lFaturado  := .F.					
				cTipoSenf  := ""
				oDesmonta:Enable()
				oDesmonta:SetFocus()
				
				_cNumEtqPA  := Space(_nTamEtiq)
				__oGetOP:Refresh()
				__oGetOP:SetFocus()
			
		
			EndIf
			
		
		Else
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			_lRet:=.F.
			cTipoSenf := ""
			Return(.F.)
		EndIf
		
	Else
		U_MsgColetor("Pr๓ximo nํvel de Embalagem nใo encontrada.")
		_cNumEtqPA := Space(_nTamEtiq)
		__oGetOP:Refresh()
		__oGetOP:SetFocus()
		cTipoSenf := ""
		Return(.F.)
	EndIf
	
Else
	
	U_MsgColetor("Etiqueta nใo encontrada, ou a embalagem foi desmontada.")
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

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDesmonta  บAutor  ณMichel A. Sander    บ Data ณ  23.02.17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desmonta a embalagem e cancela a separa็ใo das filhas	     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    

Static Function Desmonta()

LOCAL aDesmonta := {}

If U_uMsgYesNo("Confirma a DESMONTAGEM da embalagem ?")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEstorna etiquetas das embalagens filhas no XD2			ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cEtqOrigem := XD1->XD1_XXPECA
	If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
		Do While XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
	      AADD(aDesmonta,{XD2->XD2_PCFILH})
			Reclock("XD2",.F.)
			XD2->(dbDelete())
			XD2->(MsUnlock())
		EndDo
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCancela a separa็ใo das filhas								ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For nX := 1 to Len(aDesmonta)              
		If XD1->(dbSeek(xFilial("XD1")+aDesmonta[nX,1]))
		   Reclock("XD1",.F.)
		   XD1->XD1_PVSEP := ""
		   XD1->XD1_ZYSEQ := ""
		   XD1->(MsUnlock())
		EndIf
	Next nX
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDeleta a etiqueta da embalagem final						ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If XD1->(dbSeek(xFilial("XD1")+cEtqOrigem))
	   Reclock("XD1",.F.)
	   XD1->XD1_OCORRE := "5"
	   XD1->(MsUnLock())
	EndIf
   
	oDesmonta:Disable()
	_cNumEtqPA   := Space(_nTamEtiq)
   cEtqDesmonta := ""

	__oGetOP:Refresh()
	__oGetOP:SetFocus()
	
EndIf
	
Return ( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerDispFatบAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se produtos estใo disponํveis para faturamento    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

If (cAliasSZY)->(Eof())
   lFatura := .F.
Else
   Do While (cAliasSZY)->(!Eof())
      lFaturado := If( !Empty((cAliasSZY)->ZY_NOTA), .T., .F. )
      (cAliasSZY)->(dbSkip())
   EndDo   
EndIf
(cAliasSZY)->(dbCloseArea())

Return ( lFatura )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VldData  บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo da data de faturamento								     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldData()

If _cDtaFat < dDataBase
	U_MsgColetor("Data de faturamento nใo deve ser menor que a data atual.")
	Return(.f.)
Else
	return(.t.)
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ            '
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAlertC    บAutor  ณHelio Ferreira      บ Data ณ  15/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mensagem de alerta para o coletor de dados				     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AlertC(cTexto)

Local aTemp := U_QuebraString(cTexto,20)
Local cTemp := ''
Local lRet  := .T.

For x := 1 to Len(aTemp)
	cTemp += aTemp[x] + Chr(13)
Next x

cTemp += 'Continuar?'

While !apMsgNoYes( cTemp )
	lRet:=.F.
End

Return(lRet)
