#include "rwmake.ch"
#include "totvs.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD38 ºAutor  ³Jackson Santos       º Data ³  12/09/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Devolução para o estoque produções Kit Pig   			     º±±
±±º          ³ Será feito a leitura por etiqueta e não por OP             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACW38()

U_MsgColetor(" ROTINA EM DESENVOLVIMENTO ")

RETURN
/*
Local nCol1 := 005
Local nCol2 := 015
Local nLin     := 010
Local oTexto1, oTexto2

Private nTamEtiqD  := 100 // 21
Private cEtqDom  := Space(nTamEtiqD)
Private cProd1 	:= SPACE(15)
Private cDESC1 	:= SPACE(50)  
Private clOTE1 	:= SPACE(11)  
Private nQTDJATRF := 0
Private nQTDORI1 	:= 0
Private aEmpSB2   := {}
Private aEmpSB8	:= {}
Private aEmpSBF	:= {}

DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("Devolução KIT PIG") FROM 0,0 TO 293,233 PIXEL

@ nLin, nCol1	SAY oTexto1   VAR OemToAnsi('Etiqueta Rosenberger:')  PIXEL SIZE 180,15
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)
nLin += 10
@ nLin, nCol2 MSGET oEtqDom VAR cEtqDom  Picture "@!"  SIZE 85,12 Valid vEtqDom() PIXEL
oEtqDom:oFont := TFont():New('Courier New',,25,,.T.,,,,.T.,.F.)
nLin += 25
@ nLin, nCol2 Say oProd1     Var "Produto: "   + cProd1                Pixel Of oDlg1
nLin += 15
@ nLin, nCol2 Say oDESC1     Var "Descrição: " + SUBSTR(cDESC1,1,22)   Pixel Of oDlg1
nLin += 15
//@ nLin, nCol2 Say olOTE1     Var "Lote:      " + clOTE1                Pixel COLOR CLR_RED Of oDlg1
//nLin += 10
@ nLin, nCol2 Say oQTDJATRF   Var "Qtd. Transferida: "   + TransForm(nQTDJATRF,"@E 999,999.9999") Pixel Of oDlg1
nLin += 30

@ nLin,040 Button "Sair" Size 55,13 Action Close(oDlg1) Pixel

ACTIVATE MSDIALOG oDlg1

Return


Static Function vEtqDom()
Local _Retorno  := .F.
Local cEtiqueta := ""
Local lEncontrou := .F.
//Local aAreaSIX   := SIX->( GetArea() )

If Len(Alltrim(cEtqDom)) <> 12 .and. Len(Alltrim(cEtqDom)) <> 0
	U_MsgColetor("Etiqueta Rosenberger inválida",1)
	Return .F.
EndIf


If Len(AllTrim(cEtqDom)) == 12 //EAN 13 s/ dígito verificador.
	cEtqDom := "0"+cEtqDom
	cEtqDom := Subs(cEtqDom,1,12)
EndIf

oEtqDom:Refresh()

If !Empty(cEtqDom)
	XD1->( dbSetOrder(1) )
	If XD1->( dbSeek( xFilial() + cEtqDom ) )
		
		//Obrigatório o armazem ser o 91
		If XD1->XD1_LOCAL <> "97" .And. XD1->XD1_LOCAL <> "01" 
			U_MsgColetor("Armazém Inválido :" +XD1->XD1_LOCAL )
			_Retorno := .T.
		ElseIf XD1->XD1_LOCAL == "01"     
			U_MsgColetor("Já Transferido para o armazém :" +XD1->XD1_LOCAL )
			_Retorno := .T.
		Else			
			//Verifica se a etiqueta não está cancelada ou não foi transferida
			If XD1->XD1_OCORRE == "5"
				U_MsgColetor("Etiqueta lida está cancelada.")
				_Retorno := .F.				
			Else
				
				SC2->( dbSetOrder(1) )
				SB1->( dbSetOrder(1) )
				SBF->( dbSetOrder(2) )
				SD3->( dbSetOrder(1) )
				SB8->( dbSetOrder(3) )
				SF5->( dbSetOrder(1) )
				
				_cNumOP := Alltrim(XD1->XD1_OP)
				
				aLotesPA := {}
				If SC2->( dbSeek( xFilial() + _cNumOP ) )
					cPaPi     := Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_TIPO")
					cC2_LOCAL := SC2->C2_LOCAL
					cLotesProd := ''
					
					If SB1->B1_XKITPIG == "S"
						cProd1 	:= Alltrim(SB1->B1_COD)
						cDESC1 	:= Alltrim(SB1->B1_DESC)
						clOTE1 	:= XD1->XD1_LOTECT
						nQTDORI1 := XD1->XD1_QTDATU
						
						oProd1:Refresh()
						oDESC1:Refresh()
						//olOTE1:Refresh()
						//oQTDJATRF:Refresh()
						
						
						DEV002TR(cProd1,cLOTE1)							
						_Retorno:=.T.
						
					Else
						U_MsgColetor("Produto não é KIT PIG")
						_Retorno := .T.
					EndIf
				Endif
			EndIf
		EndIf
	Else
		U_MsgColetor("Número de etiqueta não encontrado")
		_Retorno := .T.
	EndIf
Else
	_Retorno := .T.
EndIf

If _Retorno
	cEtqDom  := Space(100)
	//cProd1 	:= Space(15)
	//cDESC1 	:= Space(50)
	//clOTE1 	:= Space(11)
	nQTDORI1 := 0
	
	oEtqDom:Refresh()
	oProd1:Refresh()
	oDESC1:Refresh()
	//olOTE1:Refresh()
	//oQTDORI1:Refresh() 
	oQTDJATRF:Refresh()
	
	oEtqDom:SetFocus()
EndIf

Return _Retorno

*--------------------------------------------------------
STATIC FUNCTION DEV002TR(cProd2,cLOTE2) //TRANSFERIR
*--------------------------------------------------------
Local     nX          := 0
Local     _nOpcAuto   := 3
Local     dVLDSB8     := CTOD("31/12/49")
                   
Private _nSB2QEMP     := 0
Private _lSB2QEMP     := .F.
Private lTRANSF       := .F.
Private _cLOCDES      :=SPACE(02)
Private lRecalcSld	 := .F.
Private lErroSaldo	 := .F.
Private nFCICalc       := SuperGetMV("MV_FCICALC",.F.,0)
Default cProd2        := ""
//Default cLOTE2      := ""
//cLOTE2              := SUBSTR(cLOTE2,1,10)

//TRANSFERENCIA
_aAuto      :={}
_aItem      :={}
cLocaliz    := ''

cLocaliz := '97PROCESSO     '

SBF->( dbSetOrder(1) )

cLoteOP := cLOTE2
SB8->( DBSetOrder(3) )

If SB8->( dbSeek( xFilial() + SB1->B1_COD + cC2_LOCAL  + cLoteOP) )
	dVLDSB8 := SB8->B8_DTVALID
	If SB8->B8_SALDO < nqtdOri1
		lRecalcSld := .T.
	EndIf
EndIf

If SBF->( dbSeek( xFilial() + cC2_LOCAL + cLocaliz +  SB1->B1_COD + Space(Len(SBF->BF_NUMSERI)) + cLoteOP) )
	If SBF->BF_QUANT < nQtdOri1
		lRecalcSld := .T.
	EndIf
	
	If lRecalcSld
		U_UMATA300(SB1->B1_COD,SB1->B1_COD,"97","97")
	EndIf
	
	If SB8->( dbSeek( xFilial() + SB1->B1_COD + cC2_LOCAL  + cLoteOP) )
		If SB8->B8_SALDO < nQtdOri1
			lErroSaldo := .T.
		EndIf
	EndIf
	
	IF SBF->( dbSeek( xFilial() + cC2_LOCAL + cLocaliz +  SB1->B1_COD + Space(Len(SBF->BF_NUMSERI)) + cLoteOP) )
		If SBF->BF_QUANT < nQtdOri1
			lErroSaldo := .T.
		EndIf
	EndIf
	
	If !lErroSaldo
		
		_cDoc:= U_NEXTDOC()
		_cDoc:= _cDoc + SPACE(09)
		_cDoc:= SUBSTR(_cDoc,1,9)
		
		aadd(_aAuto,{_cDoc,dDataBase})
		
		_aItem   := {}

		aadd(_aItem,SB1->B1_COD)                       //Produto Origem
		aadd(_aItem,SB1->B1_DESC)                      //Descricao Origem
		aadd(_aItem,SB1->B1_UM)  	                    //UM Origem
		aadd(_aItem,cC2_LOCAL)                         //Local Origem
		aadd(_aItem,cLocaliz)                  	     //Endereco Origem
		aadd(_aItem,SB1->B1_COD)                       //Produto Destino
		aadd(_aItem,SB1->B1_DESC)                      //Descricao Destino
		aadd(_aItem,SB1->B1_UM)  	                    //UM destino
		aadd(_aItem,'01')                              //Local Destino
		aadd(_aItem,'01DEVOLUCAO    ')                 //Endereco Destino
		aadd(_aItem,'')                                //Numero Serie
		aadd(_aItem,cLOTE2)	                          //Lote Origem
		aadd(_aItem,'')         	                    //Sub Lote Origem
		aadd(_aItem,dVLDSB8  )								  //Validade Lote Origem
		aadd(_aItem,0)		                             //Potencia
		aadd(_aItem,nQtdOri1)                          //Quantidade
		aadd(_aItem,0)		                             //Quantidade 2a. unidade
		aadd(_aItem,'')   	                          //ESTORNO
		aadd(_aItem,'')         	                    //NUMSEQ
		aadd(_aItem,cLOTE2)                            //Lote Destino
		aadd(_aItem,dVLDSB8) 								  //Validade Lote Destino
		aadd(_aItem,"")		                          //D3_ITEMGRD
		If nFCICalc == 1
			aadd(_aItem,0)                              //D3_PERIMP
		ENDIF
		If GetVersao(.F.,.F.) == "12"
			//aAdd(_aItem,"")   //D3_IDDCF
			aAdd(_aItem,"")   //D3_OBSERVACAO
		EndIf
		aadd(_aAuto,_aItem)
		
		lMsErroAuto := .F.
		
		GuardaEmps(SB1->B1_COD,cC2_LOCAL)
					
		MSExecAuto({|x,y| mata261(x,y)},_aAuto,_nOpcAuto)  // Execauto de transferência
		
		VoltaEmps()
					
		If lMsErroAuto
			MostraErro("\UTIL\LOG\Devolucao_Producao_KIT_PIG\")
			//DisarmTransaction()
			U_MsgColetor("Erro na Devolução (KIT PIG)")
		Else
			
			Reclock("XD1",.F.)
			XD1->XD1_LOCAL 	:= '01'
			//XD1->XD1_LOTECT	:= SUBSTR(cLOTE2,1,10)
			//XD1->XD1_DTDIGI	:= dDataBase
			XD1->XD1_LOCALI 	:= '01DEVOLUCAO    '
			//XD1->XD1_USERID  := __cUserId
			XD1->XD1_OCORRE := "4"
			XD1->( MsUnlock() )
			
			nQTDJATRF ++
			
			lTRANSF:=.T.
		ENDIF
	Else
		U_MsgColetor("Não existe saldo suficiente do produto " + Alltrim(SB1->B1_COD) +" para devolução." + Chr(13) + "Saldo: "+Alltrim(Str(SBF->BF_QUANT))+ Chr(13) +"Necessidade: " + Alltrim(Str(nQtdOri1)))
	EndIf
Else
	U_MsgColetor("Não existe saldo do produto " + Alltrim(SB1->B1_COD) +" para devolução (saldo zero).")
EndIf

IF lTRANSF   .AND. lMsErroAuto == .F.
	U_MsgColetor("Devolução efetuada  Produto: "+Chr(13)+SB1->B1_COD+".",1)
	lTRANSF:=.F.
ENDIF

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

While !QUERYSD4->( EOF() )
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

/*
For x := 1 to Len(aSD4QUANT)
	SD4->( dbGoTo(aSD4QUANT[x,1]) )
	If SD4->( Recno() ) == aSD4QUANT[x,1]
		Reclock("SD4",.F.)
		SD4->D4_QUANT := aSD4QUANT[x,2]
		SD4->( msUnlock() )
	EndIf
Next x
*/

cQuery := "SELECT R_E_C_N_O_ FROM " + RetSqlName("SD4") + " WHERE D4_XQUANT <> 0 AND D_E_L_E_T_ = '' "


Return
