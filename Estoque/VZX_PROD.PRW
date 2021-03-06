#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VZX_PROD  �Autor  �Helio Ferreira      � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function VZX_PROD()
Local _Retorno 	:= .T.
Local lAutoria 	:= .F.
Local cUserAut 	:= SuperGetMV("MV_USZXAUT",.F.,"000288/000646/000622")
Local cMensErro := ""
If !Empty(M->ZX_PRODUTO)
	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek( xFilial() + M->ZX_PRODUTO ) )
	/*
		lPermitido := .T.
		If SB1->B1_TIPO <> 'MC'
			If SB1->B1_TIPO <> 'MS'
			   If SB1->B1_LOCPAD <> "05"
			      If SB1->B1_LOCPAD <> "07"
				      lPermitido := .F.       
				   EndIf
				EndIf
			EndIf                          
		EndIf
		If !lPermitido
			MsgStop("Somente Materiais de Consumo/Secund�rios devem ser solicitados por esta rotina. A partir de 15/02/2020 esta rotina n�o permitir� a solicita��o deste dipo de produto.")
			If Date() >= CtoD("15/02/2021")  // ALTERACAO 17/01/2010 PARA 15/02/2021 MLS SOLIC:Denis   17/10/2018
				_Retorno := .F.
			EndIf
			
			cTexto   := "Produto " + M->ZX_PRODUTO + " tipo "+SB1->B1_TIPO+" solicitado pela rotina de Solicita��o de Materiais de Consumo pelo usu�rio " + M->ZX_NOME
			cAssunto := "Material indevido na Solicita��o de MC "
			cTxtMsg  := cAssunto
			cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
			cPara    := 'fabiana.santos@rosenbergerdomex.com.br;tatiane.alves@rosenbergerdomex.com.br;denis.vieira@rdt.com.br;'
			cCC      := ""
			cArquivo := Nil
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
			
		EndIf
	*/
		//If Adicionado Por Jackson Santos em 14/09/21
		lAutoria := Alltrim(__cUserID) $ Alltrim(cUserAut)
		If lAutoria			
			MsgAlert("Usu�rio Autorizado a Fazer a Movimenta��o","Movimento [ PA / PR / MP ]")
			_Retorno := .T.		
		Else
			// Adicionado por MAURESI en 09/03/2020
			if Alltrim(SB1->B1_TIPO)  $ "PA/PR/MP/"   // Produto Acabado / Produto Revenda / Materia Prima
				cMensErro := "Produtos dos tipos [ PA / PR / MP ] n�o podem ser solicitados por esta rotina." 
				cMensErro += Char(13) + Char(10) + "Caso necessitar solicite ao administrador cadastra seu c�digo"
				cMensErro += Char(13) + Char(10) + "de usu�rio no par�metro: MV_USZXAUT"
				
				MsgStop(cMensErro)
				_Retorno := .F.
			endif
		Endif
	Else
		MsgStop("Produto inv�lido.")
	EndIf
EndIf

Return _Retorno
