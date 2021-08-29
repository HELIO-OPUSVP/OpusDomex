#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DOMACD20  �Autor  �Michel Sander       � Data �  02.06.16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela de reimpress�o de etiquetas da expedi��o	           ���
���          � 														                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

Define MsDialog oTelaOP Title OemToAnsi("Reimpress�o de Etiquetas" ) From 0,0 To 293,233 Pixel of oMainWnd PIXEL

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
	
	//������������������������������������������������������Ŀ
	//�Verifica separa��o												�
	//��������������������������������������������������������
	If Empty(XD1->XD1_PVSEP)
		U_MsgColetor("Esta embalagem n�o est� separada, portanto n�o poder� ser reimpresso a etiqueta da embalagem.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		Return ( .F. )
	EndIf
	
	//������������������������������������������������������Ŀ
	//�Verifica faturamento												�
	//��������������������������������������������������������
	If !Empty(XD1->XD1_ZYNOTA)
		U_MsgColetor("Esta embalagem J� foi faturada.")
		_cNumEtqPA := Space(_nTamEtiq)
		oGetOp:Refresh()
		oGetOp:SetFocus()
		Return ( .F. )
	EndIf

	//������������������������������������������������������Ŀ
	//�Busca o volume dessa etiqueta									�
	//��������������������������������������������������������
   aFilhas := {}
	XD2->(dbSetOrder(2))
	If XD2->(dbSeek(xFilial("XD2")+XD1->XD1_XXPECA))

		If U_uMsgYesNo("Deseja reimprimir a etiqueta do volume dessa caixa?")

			//������������������������������������������������������Ŀ
			//�Cancela o volume dessa etiqueta								�
			//��������������������������������������������������������
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
									
					//����������������������������������������������������������������������Ŀ
					//�Deleta etiqueta antiga																 �
					//������������������������������������������������������������������������
               Reclock("XD1",.F.)
               XD1->XD1_OCORRE := "5"
               XD1->(MsUnlock())

					//����������������������������������������������������������������������Ŀ
					//�LAYOUT 01 - HUAWEI UNIFICADA												   	�
					//������������������������������������������������������������������������
					lRotValid :=  U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.F.,nPesoBruto,lColetor) 			// Valida��es de Layout 01
					If !lRotValid
						U_MsgColetor("A etiqueta n�o ser� impressa. Verifique os problemas com o  layout da etiqueta e repita a opera��o.")
						Return ( .F. )
					Else
						cRotina   := "U_DOMETQ04(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.T.,nPesoBruto,lColetor)"		// Impress�o de Etiqueta Layout 01
					EndIf
			
					//������������������������������������������������������Ŀ
					//�Executa rotina de impressao									�
					//��������������������������������������������������������
					lRetEtq := &(cRotina)
					If lRetEtq
						//����������������������������������������������������������������������Ŀ
						//�Atualiza separacao da nova etiqueta												 �
						//������������������������������������������������������������������������
	               Reclock("XD1",.F.)
						XD1->XD1_PVSEP := cSeparado
	               XD1->(MsUnlock())
	            EndIf   
				
			   Else // N�o � Huawai
			   
					cProxNiv   := XD1->XD1_NIVEMB
					nPesoBruto := XD1->XD1_PESOB
					__mv_par02 := XD1->XD1_OP
					__mv_par03 := Nil
					__mv_par04 := XD1->XD1_QTDORI
					__mv_par05 := 1
					__mv_par06 := "90"
					cVolumeAtu := Alltrim(XD1->XD1_VOLUME)
					cSeparado  := XD1->XD1_PVSEP

					//����������������������������������������������������������������������Ŀ
					//�Deleta etiqueta antiga																 �
					//������������������������������������������������������������������������
               Reclock("XD1",.F.)
               XD1->XD1_OCORRE := "5"
               XD1->(MsUnlock())
               
					//����������������������������������������������������������������������Ŀ
					//�LAYOUT 90 - Etiqueta Nivel 3												   	�
					//������������������������������������������������������������������������
					lRotValid :=  U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.F.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,Nil) 			// Valida��es de Layout 90 - Nivel 3
					If !lRotValid
						U_MsgColetor("A etiqueta n�o ser� impressa. Verifique os problemas com o  layout da etiqueta e repita a opera��o.")
						Return ( .F. )
					Else
						__mv_par02 := XD1->XD1_OP
						__mv_par03 := Nil
						__mv_par04 := XD1->XD1_QTDORI
						__mv_par05 := 1
						__mv_par06 := "90"
						cRotina    := "U_DOMETQ90(__mv_par02,__mv_par03,__mv_par04,__mv_par05,cProxNiv,aFilhas,.T.,nPesoBruto,cVolumeAtu,lColetor,cNumSerie,Nil,Nil)"		// Impress�o de Etiqueta Layout 90 - Nivel 3
					EndIf
					
					//������������������������������������������������������Ŀ
					//�Executa rotina de impressao									�
					//��������������������������������������������������������
					lRetEtq := &(cRotina)
					If lRetEtq
						//����������������������������������������������������������������������Ŀ
						//�Atualiza separacao da nova etiqueta												 �
						//������������������������������������������������������������������������
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
		U_MsgColetor("N�o foi encontrado o volume que cont�m essa etiqueta.")
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
