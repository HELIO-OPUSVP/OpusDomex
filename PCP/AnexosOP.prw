#include "rwmake.ch"
#include "protheus.ch"
#include "parmtype.ch"
#include "tbiconn.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AnexosOP  �Autor  �Helio / Osmar       � Data �  17/11/21   ���
�������������������������������������������������������������������������͹��
���Desc.     � Bot�o de amarra��o de documentos (.doc, .pdf) a cadastro   ���
���          � de Ordem de Produ��o.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function AnexosOP()

//Private cSlvAnexos := "\system\docs"
Private cSlvAnexos := "\docs"
PRIVATE oFontNW
Private oGetDados
Private aHeader    := {}
Private aCols      := {}

AADD(aHeader,  {    "Cod. Documento"    ,   "ITEM"    ,"@R" ,50,0,""            ,"","C","","","","",".F."})//01
AADD(aHeader,  {    "Descri��o"         ,   "DESCRI"  ,"@R" ,50,0,""            ,"","C","","","","",".T."})//02

If SZV->( dbSeek( xFilial() + "SC2" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN ) )
	While !SZV->( EOF() ) .and. SZV->ZV_ALIAS == 'SC2' .and. SZV->ZV_CHAVE == SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		AADD(aCols,{SZV->ZV_ARQUIVO,SZV->ZV_DESCRI,.F.})
		SZV->( dbSkip() )
	End
Else
	AADD(aCols,{"","",.F.})
EndIf

DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

Define MsDialog oDlg01 Title OemToAnsi("Documentos amarrados a Ordem de Produ��o " + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) From 0,0 To 305,750 Pixel of oMainWnd PIXEL

oGetDados  := (MsNewGetDados():New( 10, 09 , 130 ,370,GD_UPDATE+GD_DELETE ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,"U__Ffieldok()",/*superdel*/,/*delok*/,oDlg01,aHeader,aCols))
//oGetDados:oBrowse:Refresh()
//oGetDados:oBrowse:oFont  := oFontNW
//oGetDados:oBrowse:bChange:={||U_DEV002LOK(oGetDados)}

//@ 135,175 Button "Incluir"     Size 45,13 Action Incluir()       Pixel
//@ 135,275 Button "Excluir"     Size 45,13 Action Excluir()       Pixel
@ 135,275 Button "Visualizar"  Size 45,13 Action Visualizar()    Pixel
@ 135,325 Button "Sair"        Size 45,13 Action oDlg01:End()    Pixel

Activate MsDialog oDlg01

Return


Static Function Incluir()

Local cTipo 	:= "Todos os Arquivos (*.*)    | *.*    |"+;
"Arquivos PDF (*.PDF)       | *.PDF  |"+;
"Arquivos JPEG (*.JPG)      | *.JPG  |"+;
"Arquivos do Word (*.DOCX)  | *.DOCX |"+;
"Arquivos do Excel (*.XLSX) | *.XLSX |"

Local cTitulo	:= "Dialogo de Selecao de Arquivos"
Local cDirIni	:= ""
Local cDrive	:= ""
Local cDir		:= ""
Local cFile		:= ""
Local cExten	:= ""
Local cGetFile	:= ""
Local cNewFile	:= ""

Private cChave    := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
Private cAlias    := "SC2"

If Empty(cChave)
	MsgStop("Preencher primeiramente o c�digo do produto.")
	Return
EndIf

cGetFile	:= cGetFile(cTipo,cTitulo,,cDirIni,.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE)//GETF_ONLYSERVER+GETF_RETDIRECTORY+GETF_LOCALFLOPPY

// Separa os componentes
SplitPath( cGetFile, @cDrive, @cDir, @cFile, @cExten )

If !Empty(cFile)
	If !File(cGetFile)
		Alert("Erro ao localizar arquivo origem!")
		Return
	EndIf
	
	//Cria pasta caso n�o exita ainda
	MontaDir(cSlvAnexos+"\"+cChave+"\")
	
	cNewGetFile := cSlvAnexos+"\"+cChave+"\"+cFile+cExten
	
	If File(cNewGetFile)
		Alert("Arquivo j� anexado anteriormente.")
		Return
	EndIf
	
	COPY File &cGetFile TO &cNewGetFile
	
	If File(cNewGetFile)
		//Reclock("SZV",.T.)
		SZV->ZV_FILIAL  := xFilial("SZV")
		SZV->ZV_ALIAS   := cAlias
		SZV->ZV_CHAVE   := cChave
		SZV->ZV_ARQUIVO := cFile+cExten
		SZV->( msUnlock() )
		
		If Len(oGetDados:aCols) == 1 .and. Empty(oGetDados:aCols[1,1])
			oGetDados:aCols[1,1] := SZV->ZV_ARQUIVO
			oGetDados:aCols[1,2] := SZV->ZV_DESCRI
		Else
			AADD(oGetDados:aCols,{SZV->ZV_ARQUIVO,SZV->ZV_DESCRI,.F.})
		EndIf
		
		MsgInfo("Arquivo inclu�do com sucesso.")
	Else
		MsgStop("Erro ao anexar o arquivo.")
	EndIf
EndIf

Return


Static Function Visualizar()

Local cFileDes := ""
Local cPathTmp := AllTrim( GetTempPath() )
/*
n := oGetDados:oBrowse:nAt
If n > 0
If SZV->( dbSeek( xFilial() + "SB1" + SB1->B1_COD + oGetDados:aCols[n,1] ) )

cFileOri := cSlvAnexos + "\" + SZV->ZV_CHAVE + "\" + SZV->ZV_ARQUIVO
cFileDes := cPathTmp + SZV->ZV_ARQUIVO

If !File(cFileOri)
MsgStop("Arquivo n�o encontrado.")
Return
EndIf

If File(cFileDes)
fErase(cFileDes)
EndIf

If File(cFileDes)
Alert("Arquivo j� est� aberto!")
Return
EndIf

COPY File &cFileOri TO &cFileDes

ShellExecute("open",cFileDes,"","", 5 )
Else
MsgStop("O arquivo n�o foi encontrado para exibi��o")
EndIf
Else
MsgStop("Posicione em um arquivo para exibi��o")
EndIf
*/

n := oGetDados:oBrowse:nAt
If n > 0
	If SZV->( dbSeek( xFilial() + "SC2" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN + oGetDados:aCols[n,1] ) )
		QDH->( dbSetOrder(1) )
		If QDH->( dbSeek( xFilial() + Subs(SZV->ZV_ARQUIVO,1,16) ) )
			
			While !QDH->( EOF() ) .and. Alltrim(QDH->QDH_DOCTO) == Alltrim(SZV->ZV_ARQUIVO)
				QDHRecno := QDH->( Recno() )
				QDH->( dbSkip() )
			End
			
			QDH->( dbGoTo(QDHRecno) )
			
			cFileOri := cSlvAnexos + "\" + QDH->QDH_NOMDOC
			
			cFileDes := cPathTmp + QDH->QDH_NOMDOC
			
			If !File(cFileOri)
				MsgStop("Arquivo n�o encontrado.")
				Return
			EndIf
			
			If File(cFileDes)
				fErase(cFileDes)
			EndIf
			
			If File(cFileDes)
				Alert("Arquivo j� est� aberto!")
				Return
			EndIf
			
			COPY File &cFileOri TO &cFileDes
			
			ShellExecute("open",cFileDes,"","", 5 )
		Else
			MsgStop("Documento n�o encontrado no Controle de Documentos.")
		EndIf
	Else
		MsgStop("O arquivo n�o foi encontrado para exibi��o")
	EndIf
Else
	MsgStop("Posicione em um arquivo para exibi��o")
EndIf

Return

Static Function Excluir()

Local cFileDes := ""
Local cPathTmp := AllTrim( GetTempPath() )

n := oGetDados:oBrowse:nAt

If n > 0
	If SZV->( dbSeek( xFilial() + "SC2" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN + oGetDados:aCols[n,1] ) )
		If MsgYesNo("Deseja realmente excluir o arquivo '" + Alltrim(oGetDados:aCols[n,1]) + "' ?")
			cFileDel := cSlvAnexos + "\" + SZV->ZV_CHAVE + "\" + SZV->ZV_ARQUIVO
			
			If !File(cFileDel)
				MsgStop("Arquivo n�o encontrado para ser exclu�do.")
				Return
			EndIf
			
			fErase(cFileDel)
			
			If File(cFileDes)
				MsgStop("N�o foi poss�vel excluir o arquivo.")
			Else
				//Reclock("SZV",.F.)
				SZV->( dbDelete() )
				SZV->( msUnlock() )
				
				aColsBkp := aClone(oGetDados:aCols)
				aColsNew := {}
				
				For x := 1 to Len(aColsBkp)
					If x <> n
						AADD(aColsNew,aColsBkp[x])
					EndIf
				Next x
				
				oGetDados:aCols := aClone(aColsNew)
				
				MsgInfo("Arquivo exclu�do com sucesso.")
				
			EndIf
		EndIf
	Else
		MsgStop("O arquivo n�o foi encontrado para exibi��o.")
	EndIf
Else
	MsgStop("Posicione em um arquivo para exibi��o.")
EndIf

Return

User Function _Ffieldok()

If SZV->( dbSeek( xFilial() + "SC2" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN + oGetDados:acols[oGetDados:oBrowse:nAt,1] ) )
	//Reclock("SZV",.F.)
	SZV->ZV_DESCRI := M->DESCRI
	SZV->( msUnlock() )
EndIf

Return .T.
