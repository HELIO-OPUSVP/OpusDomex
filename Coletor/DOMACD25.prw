#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDOMACD25  บAutor  ณMichel Sander       บ Data ณ  26.08.16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiqueta TELEFONICA para faturamento (EXPEDICAO) 			  บฑฑ
ฑฑบ          ณ 														                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOMACD25()

Private oTxtOP,__oGetOP,__oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oMainEti,oEtiqueta
Private oTxtProdCod,oTxtProdEmp,oNumOp
Private _nTamEtiq      := 21
Private _cNumEtqPA     := Space(_nTamEtiq)
Private _cProduto      := CriaVar("B1_COD",.F.)
Private _cLoteEti      := CriaVar("BF_LOTECTL",.F.)
Private _aCols         := {}
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
Private cLocProcDom    := GetMV("MV_XXLOCPR")
Private __oTelaOP
Private oTxtQtdEmp
Private aTelefonic     := {}
Private lTelefonic     := .F.

dDataBase := Date()

If cUsuario == 'HELIO'
	_cNumEtqPA := Space(_nTamEtiq)
	//_cNumEtqPA := '00001925766x   '
	_cDtaFat   := CtoD("13/10/16")
EndIf

Define MsDialog __oTelaOP Title OemToAnsi("Etiqueta TELEFONICA " + DtoC(dDataBase) ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,001 Say __oTxtEtiq    Var "Num.Etiqueta" Pixel Of __oTelaOP
@ nLin-2,045 MsGet __oGetOP  Var _cNumEtqPA Valid VldEtiq() Size 70,10 Pixel Of __oTelaOP
__oTxtEtiq:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
__oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 018,001 To 132,115 Pixel Of oMainWnd PIXEL

nLin += 015
@ nLin,005 Say oTxtProdEmp  Var "Cliente: "        Pixel Of __oTelaOP
@ nLin,035 Say oTxtProdCod  Var _cCliEmp           Pixel Of __oTelaOP
oTxtProdCod:oFont  := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin,005 Say oTxtDes      Var "Descri็ใo: "      Pixel Of __oTelaOP
@ nLin,042 say oTxtDescPro  Var _cDescric      Size 075,15 Pixel Of __oTelaOP
oTxtDescPro:oFont := TFont():New('Arial',,14,,.T.,,,,.T.,.F.)
nLin+= 30
@ nLin,005 Say oTxtPed Var "Pedido: " Pixel Of __oTelaOP
@ nLin,035 Say oNumPed Var _cNumPed+'-'+_cNomCli Size 120,10 Pixel Of __oTelaOP
oNumPed:oFont:= TFont():New('Arial',,15,,.T.,,,,.T.,.F.)
nLin+= 75 

@ nLin,077 Button oEtiqueta PROMPT "Sair" Size 35,10 Action Close(__oTelaOP) Pixel Of __oTelaOP

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
Local nQ
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

If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica volume													ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   // teste de ultimo nivel retirado em 29/06/17 por helio para atender a etiqueta de DIO nive 2 quando jแ emitiu a nivel 3
   cNumNF := ""
   If XD1->XD1_ULTNIV <> "S"
		If U_uMsgYesNo("Embalagem nใo ้ ultimo nํvel. Continuar?")
		   XD2->( dbSetOrder(2) )
		   If XD2->( dbSeek( xFilial() + _cNumEtqPA ) )
		      cEtqPai := XD2->XD2_XXPECA
		      aAreaXD1 := XD1->( GetArea() )
		      XD1->( dbSetOrder(1) )  
		      If XD1->( dbSeek( xFilial() + cEtqPai ) )
		         cNumNF := XD1->XD1_ZYNOTA
		      EndIf
		      RestArea(aAreaXD1)
		   Else
		      U_MsgColetor("Embalagem superior a esta nใo encontrada.")
		      _cNumEtqPA := Space(_nTamEtiq)
		   	__oGetOP:Refresh()
		   	__oGetOP:SetFocus()
		   	Return(.F.)
		   EndIf
		Else
		   U_MsgColetor("Esse volume nใo ้ embalagem final.")
		   _cNumEtqPA := Space(_nTamEtiq)
		   __oGetOP:Refresh()
		   __oGetOP:SetFocus()
		   Return(.F.)	
		EndIf
   Else
      cNumNF := XD1->XD1_ZYNOTA
   EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica faturamento												ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   If Empty(cNumNF)
		U_MsgColetor("Esse volume ainda nใo foi faturado.")
		_cNumEtqPA := Space(_nTamEtiq)
		__oGetOP:Refresh()
		__oGetOP:SetFocus()
		Return(.F.)	
   EndIf
   
	SB1->(dbSeek(xFilial("SB1")+XD1->XD1_COD))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica separa็ใo												ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	XD2->(dbSetOrder(1))
	If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))
		
      SZY->(dbSetOrder(1))
      If SZY->(dbSeek(xFilial("SZY")+SUBSTRING(XD1->XD1_PVSEP,1,6)))

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza dados para o coletor									ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			SC5->(dbSeek(xFilial("SC5")+SZY->ZY_PEDIDO))
			SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE))

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVerifica se o Cliente ้ TELEFONICA							ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			lTelefonic := .F.
			If ("TELEFONICA" $ Upper(SA1->A1_NOME)) .Or. ("TELEFONICA" $ Upper(SA1->A1_NREDUZ))
			   lTelefonic := .T.
			   cPedTel := SC5->C5_ESP1
			Else
				U_MsgColetor("Esse volume nใo pertence ao cliente TELEFONICA.")
				_cNumEtqPA := Space(_nTamEtiq)
				__oGetOP:Refresh()
				__oGetOP:SetFocus()
				Return(.F.)	
			EndIf

			_cNumPed  := SC5->C5_NUM
			_cCliEmp  := SC5->C5_CLIENTE
			_cDescric := SA1->A1_NOME
		   cPedTel   := SC5->C5_ESP1
		   _cOPImp   := AllTrim(XD1->XD1_LOTECT)+"001"	
			__oTelaOP:Refresh()
			
			If U_uMsgYesNo("Imprime Etiqueta?")
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณImprime Etiqueta TELEFONICA									ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				aDesmonta := DesmontaVol(_cNumEtqPA)
				For nQ := 1 to Len( aDesmonta )
				    // 01 - Numero da OP
				    // 02 - Codigo do Produto
				    // 03 - Pedido de Compra do Cliente
				    // 04 - Quantidade da Etiqueta
				    // 05 - Data de Produ็ใo
				    // 06 - Muda impressora de etiqueta para EXPEDIวรO
				    // 07 - N๚mero da Nota Fiscal
				    // 08 - Peso do Item
		          U_DOMETQ93(_cOPImp, aDesmonta[nQ,1], _cNumPed, aDesmonta[nQ,3], dDataBase, .T., IIF(!Empty(XD1->XD1_ZYNOTA),XD1->XD1_ZYNOTA,""), XD1->XD1_PESOB )
				Next nQ
		   EndIf
		   
		Else
			U_MsgColetor("Pedido nใo encontrado")
			_cNumEtqPA := Space(_nTamEtiq)
			__oGetOP:Refresh()
			__oGetOP:SetFocus()
			Return(.F.)	
	   EndIf
	Else
		U_MsgColetor("Pr๓ximo nํvel de Embalagem nใo encontrada.")
		_cNumEtqPA := Space(_nTamEtiq)
		__oGetOP:Refresh()
		__oGetOP:SetFocus()
		cTipoSenf := ""
		_lRet:=.F.
	EndIf
	
Else
	
	U_MsgColetor("Embalagem final nใo encontrada.")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DesmontaVolบAutorณMichel Sander       บ Data ณ  09/15/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desmonta os volumes para verificar as quantidades          บฑฑ
ฑฑบ          ณ contra o pedido de venda que serแ faturado                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DesmontaVol(cCodVolume)

LOCAL cAliasXD2  := GetNextAlias()
LOCAL cAliasXD1  := GetNextAlias()
LOCAL cPeca      := "%XD2_XXPECA='"+cCodVolume+"'%"
LOCAl aTelefonic := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica as caixas do volume bipado VOLUME 3				ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
BEGINSQL Alias cAliasXD2
 
	SELECT XD1_COD, XD1_PVSEP, SUM(XD1_QTDATU) XD1_QTDATU, SUM(XD1_PESOB) XD1_PESOB 
			 FROM %table:XD1% XD1 (NOLOCK) 
			 JOIN %table:XD2% XD2 (NOLOCK)
			 ON XD1_XXPECA = XD2_PCFILH 
			 WHERE XD1.%NotDel% AND 
			 		 XD2.%NotDel% AND 
			 		 XD1_ULTNIV = 'N' AND
					 %Exp:cPeca% GROUP BY XD1_COD, XD1_PVSEP ORDER BY XD1_PVSEP
ENDSQL
                  
//XD1_PESOB <> 0 AND

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAgrupa os Itens													ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do While (cAliasXD2)->(!EOF())
   // 01 - Codigo do Produto
   // 02 - Pedido + Item
   // 03 - Quantidade
   // 04 - Peso do Item
   AADD(aTelefonic,{ (cAliasXD2)->XD1_COD, (cAliasXD2)->XD1_PVSEP, (cAliasXD2)->XD1_QTDATU, (cAliasXD2)->XD1_PESOB })
	(cAliasXD2)->(dbSkip())
EndDo
(cAliasXD2)->(dbCloseArea())

If Len( aTelefonic ) > 0
   Return ( aTelefonic )
EndIf                   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica as caixas do volume bipado VOLUME 2	DIO/TRUN	ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cPeca := "%XD1_XXPECA='"+cCodVolume+"'%"
BEGINSQL Alias cAliasXD1
 
	SELECT XD1_COD, XD1_PVSEP, SUM(XD1_QTDATU) XD1_QTDATU, SUM(XD1_PESOB) XD1_PESOB 
			 FROM %table:XD1% XD1 (NOLOCK) 
			 WHERE XD1.%NotDel% AND 
			 		 XD1_PESOB <> 0 AND
			 		 XD1_NIVEMB <> '3' AND
			 		 XD1_ULTNIV = 'S' AND
					 %Exp:cPeca% GROUP BY XD1_COD, XD1_PVSEP ORDER BY XD1_PVSEP
ENDSQL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAgrupa os Itens													ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do While (cAliasXD1)->(!EOF())
   // 01 - Codigo do Produto
   // 02 - Pedido + Item
   // 03 - Quantidade
   // 04 - Peso do Item
   AADD(aTelefonic,{ (cAliasXD1)->XD1_COD, (cAliasXD1)->XD1_PVSEP, (cAliasXD1)->XD1_QTDATU, (cAliasXD1)->XD1_PESOB })
	(cAliasXD1)->(dbSkip())
EndDo
(cAliasXD1)->(dbCloseArea())

Return ( aTelefonic )
