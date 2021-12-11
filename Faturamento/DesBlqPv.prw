
#include "rwmake.ch"
#include "protheus.ch"
#include "parmtype.ch"
#include "tbiconn.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DesBlqPV  �Autor  � Osmar Ferreira     � Data �  16/12/21   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de libera��o do Pedido de Venda quando bloqueado    ���
���          � pela margem de contribui��o.                               ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function DesBlqPV(cNumPV)

	Local aAreaSC5 := SC5->( GetArea())
	Local aAreaSC6 := SC6->( GetArea())
	Local oGetDados
	Local aHeader    := {}
	Local aCols      := {}
	//Private cSlvAnexos := "\docs"
	PRIVATE oFontNW

	AADD(aHeader,  {    "Item"      ,   "ITEM"   ,"@R" ,02,0,""            ,"","C","","","","",".F."})//01
	AADD(aHeader,  {    "Produto"   ,   "PROD"   ,"@R" ,15,0,""            ,"","C","","","","",".F."})//02
	AADD(aHeader,  {    "Descri��o" ,   "DESCI"  ,"@R" ,50,0,""            ,"","C","","","","",".F."})//03
    AADD(aHeader,  {    "Pre�o"     ,   "PRECO"  ,""   ,16,8,""            ,"","N","","","","",".F."})//04
    AADD(aHeader,  {    "Custo"     ,   "CUSTO"  ,""   ,16,8,""            ,"","N","","","","",".F."})//05
    AADD(aHeader,  {    "Pre�o Net" ,   "PRNET"  ,""   ,16,8,""            ,"","N","","","","",".F."})//06
    AADD(aHeader,  {    "Margem"    ,   "MARGE"  ,""   ,10,2,""            ,"","N","","","","",".F."})//07

	If SC6->( dbSeek( xFilial() + cNumPV ) )
		While !SC6->( EOF() ) .and. SC6->C6_NUM == cNumPV
			AADD(aCols,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_DESCRI,SC6->C6_PRCVEN, SC6->C6_XCUSUNI,SC6->C6_XPRCNET,SC6->C6_XMARGEM,.F.})
			SC6->( dbSkip() )
		End
	Else
		AADD(aCols,{"","",.F.})
	EndIf

	DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

	Define MsDialog oDlg01 Title OemToAnsi("DESBLOQUEIO DO PEDIDO DE VENDA POR MARGEM DE LUCRO " + cNumPv) From 0,0 To 305,750 Pixel of oMainWnd PIXEL

	oGetDados  := (MsNewGetDados():New( 10, 09 , 130 ,370,GD_UPDATE+GD_DELETE ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*"U_fFfieldok()"*/,/*superdel*/,/*delok*/,oDlg01,aHeader,aCols))

	@ 135,175 Button "Aprovar"  Size 45,13 Action Aprovar(cNumPV)  Pixel
	@ 135,325 Button "Sair"     Size 45,13 Action oDlg01:End()    Pixel

	Activate MsDialog oDlg01

	RestArea(aAreaSC6)
	RestArea(aAreaSC5)

Return

Static Function Aprovar(cNumPV)
    
Return 
