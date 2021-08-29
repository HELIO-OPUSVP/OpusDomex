#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SupervMenu�Autor  � Michel Sander      � Data �  06.09.2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela de login para supervisores					          	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SupervMenu()

LOCAL lRetPvt := .F.
Private oBtnConf
Private oDlgPvt
Private oSayUsr
Private oSayPsw
Private oGetUsr, cGetUsr := Space(25)
Private oGetPsw, cGetPsw := Space(20)
Private oGetErr, cGetErr := ""
Private nJanLarg := 200
Private nJanAltu := 300
Private nLinUsr  := 0
Private cStartPath  := GetSrvProfString('Startpath','')

DEFINE MSDIALOG oDlgPvt TITLE "Login" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL

//������������������������������������������������������Ŀ
//�Logotipo da empresa					   						�
//��������������������������������������������������������
oTBitmap := TBitmap():New(00,25,260,184,,cStartPath+"LGMID01.png",.T.,oDlgPvt,{|| nLinUsr := 0},,.F.,.F.,,,.F.,,.T.,,.F.)
oTBitmap:lAutoSize := .T.

//������������������������������������������������������Ŀ
//�Nome de usuario						   						�
//��������������������������������������������������������
nLinUsr += 50
@ nLinUsr, 006   SAY   oSayUsr PROMPT "Usu�rio:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
nLinUsr += 7
@ nLinUsr, 006   MSGET oGetUsr VAR    cGetUsr           SIZE (nJanLarg/2)-12, 011 OF oDlgPvt COLORS 0, 16777215 PIXEL
cEstiloUsr := "QLineEdit{ border: 1px solid gray;border-radius: 5px;background-color: #ffffff;selection-background-color: #ffffff;"
cEstiloUsr += "background-image:url(rpo:bmpuser.png); "   //responsa.png
cEstiloUsr += "background-repeat: no-repeat;"
cEstiloUsr += "background-attachment: fixed;"
cEstiloUsr += "padding-left:25px; }"
oGetUsr:setCSS(cEstiloUsr)
nLinUsr += 20

//������������������������������������������������������Ŀ
//�Senha de usuario						   						�
//��������������������������������������������������������
@ nLinUsr, 006   SAY   oSayPsw PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
nLinUsr += 7
@ nLinUsr, 006   MSGET oGetPsw VAR    cGetPsw           SIZE (nJanLarg/2)-12, 011 OF oDlgPvt COLORS 0, 16777215 PIXEL PASSWORD
cEstiloPsw := "QLineEdit{ border: 1px solid gray;border-radius: 5px;background-color: #ffffff;selection-background-color: #ffffff;"
cEstiloPsw += "background-image:url(rpo:cadeado_mdi.png); "
cEstiloPsw += "background-repeat: no-repeat;"
cEstiloPsw += "background-attachment: fixed;"
cEstiloPsw += "padding-left:25px; }"
oGetPsw:setCSS(cEstiloPsw)
nLinUsr += 20

//������������������������������������������������������Ŀ
//�Mensagem de erro						   						�
//��������������������������������������������������������
@ nLinUsr, 006   MSGET oGetErr VAR    cGetErr        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
oGetErr:lActive := .F.
oGetErr:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE; }")

//������������������������������������������������������Ŀ
//�Botao de confirmacao					   						�
//��������������������������������������������������������
@ (nJanAltu/2)-18, 006 BUTTON oBtnConf PROMPT "Confirmar" SIZE (nJanLarg/2)-12, 015 OF oDlgPvt ;
ACTION { || lRetPvt := U_fVldSuperv(@cGetUsr,@cGetPsw,@cGetErr), If(lRetPvt, oDlgPvt:End(), .T. ) } PIXEL
oBtnConf:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")

ACTIVATE MSDIALOG oDlgPvt CENTERED

//������������������������������������������������������Ŀ
//�Executa rotina							   						�
//��������������������������������������������������������
If lRetPvt
	fMnuSuperv()
Endif

Return ( lRetPvt )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fVldSuperv�Autor  � Michel Sander      � Data �  06.09.2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida usuario e senha de Supervisor   		              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fVldSuperv(cGetUsr,cGetPsw,cGetErr)

Local lUsrRet := .T.
Local aUsrRet := {}

If !Empty(cGetPsw)
	
	//������������������������������������������������������Ŀ
	//�Busca o usuario digitado			   						�
	//��������������������������������������������������������
	PswOrder(2)
	If PswSeek( AllTrim(cGetUsr), .T. )
		aUsrRet := PswRet()
	EndIf
	
	//������������������������������������������������������Ŀ
	//�Valida a senha do usuario digitado   						�
	//��������������������������������������������������������
	cGetErr := ""
	oGetErr:lActive := .F.
	If Len(aUsrRet) > 0
		PswSeek( AllTrim(cGetUsr), .T. )
		lFound := PswName( AllTrim(cGetPsw) )
		If !lFound
			cGetErr := "Senha de usu�rio inv�lida."
			oGetErr:Refresh()
			lUsrRet := .F.
		Else
			If (Upper(AllTrim(aUsrRet[1,13])) <> Upper("Supervisor de Producao")) .And. (Upper(AllTrim(aUsrRet[1,13])) <> Upper("Gerente de Producao"))
				If ValType("aUsrRet[1,10,1]") <> "U"
					If AllTrim(aUsrRet[1,10,1]) <> "000000"
						cGetErr := "Usuario nao e um supervisor."
						oGetErr:Refresh()
						lUsrRet := .F.
					Else
						lUsrRet := .T.
					EndIf
				Else
					cGetErr := "Usuario nao e um supervisor."
					oGetErr:Refresh()
					lUsrRet := .F.
				EndIf
			Else
				lUsrRet := .T.
			EndIf
		EndIf
	Else
		cGetErr := "Usu�rio n�o encontrado."
		oGetErr:Refresh()
		lUsrRet := .F.
	EndIf
	
Else
	
	//������������������������������������������������������Ŀ
	//�Usuario ou senha em branco			   						�
	//��������������������������������������������������������
	If Empty(cGetUsr) .And. Empty(cGetPsw)
		cGetErr := "Usuario/Senha em branco."
	ElseIf !Empty(cGetUsr) .And. Empty(cGetPsw)
		cGetErr := "Senha em branco."
	EndIf
	
	oGetErr:Refresh()
	lUsrRet := .F.
	
EndIf

Return ( lUsrRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SupervMenu�Autor  � Michel Sander      � Data �  06.09.2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Menu Principal do Supervisor						              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fMnuSuperv()

LOCAL oDlgSup
LOCAl lMenu      := .T.
LOCAL cCSSBtN1   := "QPushButton{font: bold 10px Arial;background-image: url(rpo:avgarmazem.png);background-repeat: none; }"+;
						  "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
LOCAL cCSSBtN2   := "QPushButton{font: bold 10px Arial;background-image: url(rpo:avgarmazem.png);background-repeat: none; }"+;
						  "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"
LOCAL cCSSSair   := "QPushButton{font: bold 12px Arial;background-image: url(rpo:final.png);background-repeat: none;}"+;
 						  "QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }"

Do While lMenu
	
	DEFINE MSDIALOG oDlgSup TITLE "Menu de Supervisor" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
	
	//������������������������������������������������������Ŀ
	//�Logotipo da empresa					   						�
	//��������������������������������������������������������
	oTBitmap := TBitmap():New(00,25,260,184,,cStartPath+"LGMID01.png",.T.,oDlgSup,{|| nLinUsr := 0},,.F.,.F.,,,.F.,,.T.,,.F.)
	oTBitmap:lAutoSize := .T.
	
	//������������������������������������������������������Ŀ
	//�Bot�es de usu�rio						   						�
	//��������������������������������������������������������
	nLinUsr := 50
	//@ nLinUsr, 006 BUTTON oBtnEmbN1 PROMPT "Cancela Emb. Nivel 1" SIZE (nJanLarg/2)-12, 015 OF oDlgSup ;
	//	ACTION { || U_DOMETDL8(), oDlgSup:End() } PIXEL
	//oBtnEmbN1:SetCss(cCSSBtN1)
	
	//nLinUsr += 15
	//@ nLinUsr, 006 BUTTON oBtnEmbN2 PROMPT "Canc.Emb.Niv.2/Kit/Drop" SIZE (nJanLarg/2)-12, 015 OF oDlgSup ;
	@ nLinUsr, 006 BUTTON oBtnEmbN2 PROMPT "Cancelamento Embalagem" SIZE (nJanLarg/2)-12, 015 OF oDlgSup ;
	ACTION { || U_EXCLM250(), oDlgSup:End() } PIXEL
	oBtnEmbN2:SetCss(cCSSBtN2)
	
	nLinUsr += 65
	@ nLinUsr, 006 BUTTON oBtnSair PROMPT "Sair" SIZE (nJanLarg/2)-12, 015 OF oDlgSup ;
	ACTION { || lMenu := .F., oDlgSup:End() } PIXEL
	oBtnSair:SetCss(cCSSSair)
	
	ACTIVATE MSDIALOG oDlgSup CENTERED
	
EndDo

Return
