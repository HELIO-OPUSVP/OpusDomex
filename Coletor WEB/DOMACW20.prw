#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMACD20  ºAutor  ³Michel Sander       º Data ³  02.06.16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela de reimpressão de etiquetas da expedição	           º±±
±±º          ³ 														                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMACW20()

U_MsgColetor(" ROTINA EM DESENVOLVIMENTO ")

RETURN
/*

Private oTxtOP,oGetOP,oTxtEtiq,oGetEtiq,oTxtProd,oGetProd,oTxtQtd,oGetQtd,oMark,oTxtQtdEmp,oMainEti
Private _nTamEtiq      := 21
Private _cNumEtqPA     := Space(_nTamEtiq)
Private oTelaPeso
Private cGrupoesp      := "'TRUN'"  //"'TRUN','CORD'"
Private lBeginSQL      := .F.
Private cZY_SEQ        := ""
Private cNivelFat      := ""
Private lHuawei        := .F. 

dDataBase := Date()

If cUsuario == 'HELIO'
	//_cNumEtqPA := Space(_nTamEtiq)
	_cNumEtqPA := '00001775076x   '
	_cDtaFat   := CtoD('16/06/16')
EndIf

Define MsDialog oTelaOP Title OemToAnsi("Reimpressão de Etiquetas" ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

nLin := 005
@ nLin,001 Say oTxtEtiq    Var "Num.Etiqueta" Pixel Of oTelaOP
@ nLin-2,045 MsGet oGetOP  Var _cNumEtqPA When .T. Valid VldEtiq() Size 70,10 Pixel Of oTelaOP
oTxtEtiq:oFont := TFont():New('Arial',,17,,.T.,,,,.T.,.F.)
oGetOP:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

nLin += 015
@ nLin,001 Button oEtiqueta PROMPT "Cancela" Size 35,10 Action oTelaOp:End() Pixel Of oTelaOp

Activate MsDialog oTelaOP

Return

Static Function VldEtiq()

LOCAl _lOk := .T.

If Empty(_cNumEtqPA)
	Return .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara número da etiqueta bipada							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(AllTrim(_cNumEtqPA))==12 //EAN 13 s/ dígito verificador.
	_cNumEtqPA := "0"+_cNumEtqPA
	_cNumEtqPA := Subs(_cNumEtqPA,1,12)
EndIf

SC2->( dbSetOrder(1) )
SB1->( dbSetOrder(1) )
SBF->( dbSetOrder(2) )

If XD1->(dbSeek(xFilial("XD1")+_cNumEtqPA))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica separação												³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(XD1->XD1_PVSEP)
		U_MsgColetor("Esta embalagem não está separada, portanto não poderá ser reimpresso a etiqueta da embalagem.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		Return ( .F. )
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica faturamento												³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(XD1->XD1_ZYNOTA)
		U_MsgColetor("Esta embalagem Já foi faturada.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		Return ( .F. )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o volume dessa etiqueta									³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   aFilhas := {}
	XD2->(dbSetOrder(2))
	If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

		If U_uMsgYesNo("Deseja reimprimir a etiqueta do volume dessa caixa?")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Cancela o volume dessa etiqueta								³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cInterna := XD2->XD2_XXPECA
			XD2->(dbSetOrder(1))
			Do While XD2->(dbSeek(xFilial("XD2")+cInterna))
			  	AADD(aFilhas,{XD2->XD2_PCFILH,"",""})
				Reclock("XD2",.F.)
				XD2->(dbDelete())
				XD2->(MsUnlock())
			EndDo

			If XD1->(dbSeek(xFilial("XD1")+cInterna))

				SC2->(dbSeek(xFilial("SC2")+XD1->XD1_OP))
				SA1->(dbSeek(xFilial("SA1")+SC2->C2_CLIENT))
				lHuawei  := If("HUAWEI" $ SA1->A1_NOME, .T., .F.)
            lColetor := .T.
            
			   If lHuawei
			
					cProxNiv   := XD1->XD1_NIVEMB
					nPesoBruto := XD1->XD1_PESOB
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := XD1->XD1_QTDORI
					__mv_par05 := 1
					__mv_par06 := "01"
					cSeparado  := XD1->XD1_PVSEP
									
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Deleta etiqueta antiga																 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               Reclock("XD1",.F.)
               XD1->XD1_OCORRE := "5"
               XD1->(MsUnlock())

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³LAYOUT 01 - HUAWEI UNIFICADA												   	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lRotValid :=  U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.F.,nPesoBruto,lColetor) 			// Validações de Layout 01
					If !lRotValid
						U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
						Return ( .F. )
					Else
						cRotina   := "U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.T.,nPesoBruto,lColetor)"		// Impressão de Etiqueta Layout 01
					EndIf
			
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Executa rotina de impressao									³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lRetEtq := &(cRotina)
					If lRetEtq
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Atualiza separacao da nova etiqueta												 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	               Reclock("XD1",.F.)
						XD1->XD1_PVSEP := cSeparado
	               XD1->(MsUnlock())
	            EndIf   
				
			   Else // Não é Huawai
			   
					cProxNiv   := XD1->XD1_NIVEMB
					nPesoBruto := XD1->XD1_PESOB
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := XD1->XD1_QTDORI
					__mv_par05 := 1
					__mv_par06 := "90"
					cVolumeAtu := Alltrim(XD1->XD1_VOLUME)
					cSeparado  := XD1->XD1_PVSEP

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Deleta etiqueta antiga																 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               Reclock("XD1",.F.)
               XD1->XD1_OCORRE := "5"
               XD1->(MsUnlock())
               
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³LAYOUT 90 - Etiqueta Nivel 3												   	³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lRotValid :=  U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.F.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,Nil) 			// Validações de Layout 90 - Nivel 3
					If !lRotValid
						U_MsgColetor("A etiqueta não será impressa. Verifique os problemas com o  layout da etiqueta e repita a operação.")
						Return ( .F. )
					Else
						__mv_par02 := XD1->XD1_OP
						__mv_par03 := Nil
						__mv_par04 := XD1->XD1_QTDORI
						__mv_par05 := 1
						__mv_par06 := "90"
						cRotina    := "U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.T.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,Nil)"		// Impressão de Etiqueta Layout 90 - Nivel 3
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Executa rotina de impressao									³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lRetEtq := &(cRotina)
					If lRetEtq
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Atualiza separacao da nova etiqueta												 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	               Reclock("XD1",.F.)
						XD1->XD1_PVSEP := cSeparado
	               XD1->(MsUnlock())
	            EndIf   

				EndIf
				
			EndIf
			
		Else
			_cNumEtqPA := Space(_nTamEtiq)
			oGetOp:Refresh()
			oGetOp:SetFocus()
			Return ( .F. )
		EndIf	
		
	Else
		U_MsgColetor("Não foi encontrado o volume que contém essa etiqueta.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		Return ( .F. )
	EndIf	

EndIf

_cNumEtqPA := Space(_nTamEtiq)
oGetOp:Refresh()
oGetOp:SetFocus()

Return ( _lOk )
