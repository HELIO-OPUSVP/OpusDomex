#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#include "rwmake.ch"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �GERASZI  � Autor �Michel A. Sander      � Data � 06.11.2015 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Rotina para inicializa��o do inventario				     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Domex                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function GERASZI()

Local lGravouLog 	:= .F.
Local oOk        	:= LoadBitmap( GetResources(), "LBOK" )
Local oNOk       	:= LoadBitmap( GetResources(), "LBNO" )
Local oList
Local nModelo     := 1
Local cModoContab := ""
Local cValorContab:= ""

Private __cInterNet	:= Nil
Private aModo			:= {}
Private aValores     := {}
Private cTitulo    	:= "Gera��o da primeira contagem de invent�rio"
Private cAcao      	:= "Inicializa��o"
Private cApresenta 	:= ''
Private cArqSaida 	:= ''
Private cMesAno      := SPACE(06)
Private cLogUpdate 	:= ''
Private cEmpAtu    	:= ''
Private lConcordo  	:= .F.
Private nTela      	:= 0
Private nHdl
Private oTitulo
Private oAcao
Private oEmpAtu
Private oSelEmp
Private oMemo1
Private oMemo2
Private oMemo3
Private oMemo4
Private oDlgUpd
Private oPanel1
Private oPanel2
Private oPanel3
Private oPanel4
Private oPanel5
Private oItemAju
Private oApresenta
Private oTerAceite
Private oArqSaida
Private oChkAceite
Private oBtnAvanca
Private oBtnCancelar
Private oModo
Private oDlgUpd
Private cAlmoxIni := SPACE(20)
Private dDataInv  := GetMV("MV_XXDTINV")
Private lLimpaSZI := .F.
Private lLimpaSZC := .F.
Private lLimpaSB7 := .F.
Private aLocais   := {}

cApresenta := "Esta rotina ir� iniciar o processo de invent�rio na data selecionada no par�metro. Durante esta inicializa��o, todas as etiquetas de materiais dispon�veis em estoque ser�o consideradas como 'primeira contagem' para o invent�rio."

//���������������������������������������������������Ŀ
//� Cria Alias temporario                             �
//�����������������������������������������������������
cAliasLOC := GetNextAlias()

//����������������������������������������������������������Ŀ
//� Procura almoxarifados dispon�veis							    �
//������������������������������������������������������������
BEGINSQL Alias cAliasLOC
	
	SELECT DISTINCT XD1_LOCAL FROM %table:XD1% TMP (NOLOCK)
	WHERE TMP.%NotDel%
	AND   XD1_OCORRE = '4'
	AND   XD1_LOCAL <> ''
	ORDER BY XD1_LOCAL
	
ENDSQL

//����������������������������������������������������������Ŀ
//� Preenche markbrowse com os almoxarifados					    �
//������������������������������������������������������������
aLocais := {}
Do While !(cAliasLOC)->(Eof())
	aAdd(aLocais, {.F.,(cAliasLOC)->XD1_LOCAL,"Almoxarifado "+(cAliasLOC)->XD1_LOCAL})
	(cAliasLOC)->(DbSkip())
EndDo
(cAliasLOC)->(dbCloseArea())

//���������������������������������������������������Ŀ
//� DIALOG PRINCIPAL                                  �
//�����������������������������������������������������
DEFINE DIALOG oDlgUpd TITLE "Invent�rio" FROM 0, 0 TO 22, 75 SIZE 550, 350 PIXEL//"SIGAEST - Update"

@ 000,000 BITMAP oBmp RESNAME 'Login' OF oDlgUpd SIZE 120, oDlgUpd:nBottom NOBORDER WHEN .F. PIXEL
@ 005,070 SAY oTitulo         VAR cTitulo OF oDlgUpd PIXEL FONT (TFont():New('Arial',0,-13,.T.,.T.))
@ 015,070 SAY oAcao           VAR cAcao   OF oDlgUpd PIXEL
@ 155,140 BUTTON oBtnCancelar PROMPT "Cancelar"  SIZE 60, 14 ACTION If(oBtnCancelar:cCaption=='&Cancelar'  , oDlgUpd:End(),oDlgUpd:End())	OF oDlgUpd PIXEL	//"Cancelar"
@ 155,210 BUTTON oBtnAvanca   PROMPT "Avancar >>"  SIZE 60, 14 ACTION If(oBtnAvanca:cCaption  =='&Finalizar' , oDlgUpd:End(), SelePanel(@nTela)) OF oDlgUpd PIXEL		//"Avancar"
oDlgUpd:nStyle := nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_VISIBLE )

//���������������������������������������������������Ŀ
//� PAINEL 1                                          �
//�����������������������������������������������������
oPanel1 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )
@ 002,005 SAY oApresenta VAR "Bem-Vindo!" 	OF oPanel1                         	FONT (TFont():New('Arial',0,-13,.T.,.T.))PIXEL//
@ 015,005 GET oMemo1     VAR cApresenta OF oPanel1 MEMO PIXEL SIZE 180,100	FONT (TFont():New('Verdana',,-12,.T.)) NO BORDER
oMemo1:lReadOnly := .T.

//���������������������������������������������������Ŀ
//� PAINEL 2                                          �
//�����������������������������������������������������
oPanel2 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )
@ 000,005 SAY oTexto5		   VAR "Data do Inventario" OF oPanel2 FONT (TFont():New('Verdana',0,-13,.T.,.T.)) PIXEL
@ 000,080 MSGET oGet5		   VAR dDataInv  WHEN .T.  VALID VLDDATA() OF oPanel2 PIXEL SIZE 50,10 FONT (TFont():New('Verdana',,-12,.T.))

oList := TWBrowse():New( 15, 05, 170, 65,,{ "", "C�digo", "Almoxarifado" },,oPanel2,,,,,,,,,,,,.F.,,.T.,,.F.,,,)//##"Empresa"
oList:SetArray(aLocais)
oList:bLine      := { || { If( aLocais[oList:nAT,1], oOk, oNOK ), aLocais[oList:nAt,2], aLocais[oList:nAT,3] } }
oList:bLDblClick := { || aLocais[oList:nAt,1] := !aLocais[oList:nAt,1] }
oList:bHeaderClick := {|x,a| fMarkAll(x,a) }

//���������������������������������������������������Ŀ
//� PAINEL 5                                          �
//�����������������������������������������������������
oPanel5 := TPanel():New( 028, 072, ,oDlgUpd, , , , , , 200, 120, .F.,.T. )

ACTIVATE DIALOG oDlgUpd CENTER ON INIT SelePanel(@nTela)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMarkAll     �Autor  �Michel Sander     � Data �  10/21/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Marca todos os almoxarifados				                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fMarkAll()

For nX := 1 to Len(aLocais)
	
	oList:nAT := nX
	If aLocais[oList:nAt,1]
		aLocais[oList:nAt,1] := .F.
	Else
		aLocais[oList:nAt,1] := .T.
	EndIf
	
Next

oList:bLine := { || { If( aLocais[oList:nAT,1], oOk, oNOK ), aLocais[oList:nAt,2], aLocais[oList:nAT,3] } }
oList:SetArray(aLocais)
oList:bLine:= bLine
oList:Refresh()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDEND       �Autor  �Michel Sander    � Data �  10/21/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida digitacao de almoxarifados                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function VLDEND(cVerAlmox,cVerEnd)

LOCAL lEndRet := .T.

Return ( lEndRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDDATA      �Autor  �Michel Sander    � Data �  10/21/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida digitacao de almoxarifados                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static function VLDDATA()

LOCAL lEndRet := .T.
PUTMV("MV_XXDTINV", dDataInv)

Return ( lEndRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �SelePanel � Autor �Microsiga S/A          � Data � 03/03/09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Funcao utilizada para selecao atraves de painel            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � UPDATE                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function SelePanel(nTela)

Local lRet := .T.
//����������������������������������������Ŀ
//� Atualiza variaveis da janela principal �
//������������������������������������������
oTitulo:nLeft           := 120; oTitulo:Refresh()
oAcao:nLeft             := 120; oAcao:Refresh()
oBmp:lVisibleControl    := .T.
oPanel1:lVisibleControl := .F.
oPanel2:lVisibleControl := .F.
oPanel5:lVisibleControl := .F.

Do Case
	
	Case nTela == 0 //-- Apresentacao
		
		oPanel1:lVisibleControl := .T.
		
	Case nTela == 1 //-- Parametros
		
		oPanel2:lVisibleControl := .T.
		oBtnAvanca:lActive      := .T.
		
	Case nTela == 2 //-- Selecao da empresa
		
		cAcao := "Gera��o do Invent�rio"; oAcao:Refresh()
		
      lProcessa := .F.
      For nQ := 1 to Len(aLocais)
          If aLocais[nQ,1]
             lProcessa := .T.
          End
      Next
          
      If !lProcessa

         Aviso("Aten��o","Voc� deve escolher pelo menos um almoxarifado.",{"Ok"})
			oPanel2:lVisibleControl := .T.			   
		   lRet := .F.

      Else   
         If dDataInv <> dDataBase
            MsgInfo("Favor alterar a Data Base do sistema para a data do invent�rio!")
            Return .f.
         EndIf
         
			cQuery := "SELECT TOP 1 R_E_C_N_O_ FROM " + RETSQLNAME("SZI") + " WHERE ZI_DATA = '"+DTOS(dDataInv)+"' AND D_E_L_E_T_='' "
			If Select("TEMP") <> 0
				TEMP->( dbCloseArea() )
			EndIf
			TCQUERY cQuery NEW ALIAS "TEMP"
			If !TEMP->( EOF() )
				If Aviso("Aten��o","Deseja limpar o arquivo de Contagens de Coordenadores (SZI) com data de "+DtoC(dDataInv)+"?",{"Sim","N�o"}) == 1
					TCSQLEXEC("UPDATE "+RETSQLNAME("SZI")+" SET D_E_L_E_T_='*' WHERE ZI_DATA = '"+DTOS(dDataInv)+"' AND D_E_L_E_T_=''")
				EndIf
			EndIf
			
			cQuery := "SELECT TOP 1 R_E_C_N_O_ FROM " + RETSQLNAME("SZC") + " WHERE ZC_DATA = '"+DTOS(dDataInv)+"' AND D_E_L_E_T_='' "
			If Select("TEMP") <> 0
				TEMP->( dbCloseArea() )
			EndIf
			TCQUERY cQuery NEW ALIAS "TEMP"
			If !TEMP->( EOF() )
				If Aviso("Aten��o","Deseja limpar o arquivo de Etiquetas coletadas (SZC) com data de "+DtoC(dDataInv)+"?",{"Sim","N�o"}) == 1
					TCSQLEXEC("UPDATE "+RETSQLNAME("SZC")+" SET D_E_L_E_T_='*' WHERE ZC_DATA = '"+DTOS(dDataInv)+"' AND D_E_L_E_T_=''")
				EndIf
			EndIf
			
			cQuery := "SELECT TOP 1 R_E_C_N_O_ FROM " + RETSQLNAME("SB7") + " WHERE B7_DATA = '"+DTOS(dDataInv)+"' AND D_E_L_E_T_='' "
			If Select("TEMP") <> 0
				TEMP->( dbCloseArea() )
			EndIf
			TCQUERY cQuery NEW ALIAS "TEMP"
			If !TEMP->( EOF() )
				If Aviso("Aten��o","Deseja limpar o arquivo de itens inventariados (SB7) com data de "+DtoC(dDataInv)+"?",{"Sim","N�o"}) == 1
					TCSQLEXEC("UPDATE "+RETSQLNAME("SB7")+" SET D_E_L_E_T_='*' WHERE B7_DATA = '"+DTOS(dDataInv)+"' AND D_E_L_E_T_=''")
				EndIf
			EndIf
			
			//����������������������������������������Ŀ
			//� Executa a Stored Procedure		    	�
			//������������������������������������������
			//MsgRun("Gravando itens para invent�rio...","Aguarde...",{|| SP_GRAVA_SZI() })
			
			SP_GRAVA_SZI()
			
			oPanel5:lVisibleControl := .T.
			oBtnCancelar:lActive    := .F. //-- A partir deste ponto nao pode mais ser cancelado
			oBtnAvanca:lActive      := .F.
			//����������������������������������������Ŀ
			//� Processamento dos produtos			    �
			//������������������������������������������
			oDlgUpd:End()
		
		EndIf
			
EndCase

If lRet
	nTela ++
EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �SP_GRAVA_SZI � Autor �Michel Sander       � Data � 03/03/09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Executa Stored Procedure para inserir dados no SZI         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � DOMEX                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Static Function SP_GRAVA_SZI()

LOCAL aSP := {}

For nQ := 1 to Len(aLocais)
	If aLocais[nQ,1]
		aSP := TCSPEXEC("sp_xxgeraszi",DTOS(dDataInv),aLocais[nQ,2],0)
		If !Empty(aSP)
		   U_GERASB7(aLocais[nQ,2])
			Aviso("Aten��o","Processamento no Almoxarifado "+aLocais[nQ,2]+" OK",{"Ok"})
		Else
			Aviso("Aten��o","Erro no processamento no almoxarifado "+aLocais[nQ,2]+" OK",{"Ok"})
		EndIf
	EndIf
Next

Return

/*       	
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � sp_xxgeraszi� Autor �Michel Sander       � Data � 03/03/09 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Stored Procedure para inserir dados no SZI                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � DEVER� SER EXECUTADO DIRETO NO SQL SERVER PARA CRIAR       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

DROP PROCEDURE sp_xxgeraszi
CREATE PROCEDURE sp_xxgeraszi
@MVPAR01 varchar(08),
@MVPAR02 varchar(45),
@RETORNO int OUTPUT
AS

BEGIN TRAN GRAVA_SZI

DECLARE @RECNO INT
DECLARE @LCONTROLE int
SET @RECNO = ISNULL((SELECT MAX(R_E_C_N_O_) FROM SZI010),1)
SET @RETORNO = 0

BEGIN TRY

INSERT INTO SZI010 ( ZI_FILIAL,
ZI_DATA,
ZI_PRODUTO,
ZI_DESC,
ZI_LOCAL,
ZI_LOCALIZ,
ZI_XXPECA,
ZI_CON001,
ZI_STATLIN,
R_E_C_N_O_ )
SELECT  XD1_FILIAL,
@MVPAR01 AS XD1_DATA,
XD1_COD,
B1_DESC,
XD1_LOCAL,
XD1_LOCALI,
XD1_XXPECA,
XD1_QTDATU,
'A',
( ROW_NUMBER() OVER(ORDER BY XD1_COD) ) + @RECNO AS R_E_C_N_O_
FROM XD1010 XD1 (NOLOCK) JOIN SB1010 SB1 (NOLOCK)
ON XD1_COD = B1_COD
WHERE SB1.D_E_L_E_T_ = ''
AND XD1.D_E_L_E_T_=''
AND XD1_OCORRE='4'
AND XD1_LOCAL IN ( @MVPAR02 )
END TRY

BEGIN CATCH

SET @RETORNO = 1

END CATCH

IF @RETORNO <> 1
//COMMIT TRANSACTION GRAVA_SZI ELSE ROLLBACK TRANSACTION GRAVA_SZI
RETURN @RETORNO

GO
*/
