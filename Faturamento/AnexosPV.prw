
#include "rwmake.ch"
#include "protheus.ch"
#include "parmtype.ch"
#include "tbiconn.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AnexosOP  ºAutor  ³Helio / Osmar       º Data ³  17/11/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Botão de amarração de documentos (.doc, .pdf) a cadastro   º±±
±±º          ³ de Ordem de Produção.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AnexosPV(cNumPV)

Local aAreaSC5 := SC5->( GetArea())
Local aAreaSC6 := SC6->( GetArea())
Local oGetDados
Local aHeader    := {}
Local aCols      := {}
Private cSlvAnexos := "\docs"
PRIVATE oFontNW

AADD(aHeader,  {    "Item"      ,   "ITEM"   ,"@R" ,02,0,""            ,"","C","","","","",".F."})//01
AADD(aHeader,  {    "Produto"   ,   "PROD"   ,"@R" ,15,0,""            ,"","C","","","","",".F."})//02
AADD(aHeader,  {    "Descrição" ,   "DESCI"  ,"@R" ,50,0,""            ,"","C","","","","",".F."})//03

If SC6->( dbSeek( xFilial() + cNumPV ) )
	While !SC6->( EOF() ) .and. SC6->C6_NUM == cNumPV 
		AADD(aCols,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_DESCRI,.F.})
		SC6->( dbSkip() )
	End
Else
	AADD(aCols,{"","",.F.})
EndIf

DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

Define MsDialog oDlg01 Title OemToAnsi("AMARRAÇÃO DE DOCUMENTOS AO PEDIDO DE VENDA  " + cNumPv) From 0,0 To 305,750 Pixel of oMainWnd PIXEL

oGetDados  := (MsNewGetDados():New( 10, 09 , 130 ,370,GD_UPDATE+GD_DELETE ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*"U_fFfieldok()"*/,/*superdel*/,/*delok*/,oDlg01,aHeader,aCols))

@ 135,175 Button "Anexos"  Size 45,13 Action Anexos(cNumPV,oGetDados:aCols[oGetDados:oBrowse:nAt,1])        Pixel
@ 135,325 Button "Sair"    Size 45,13 Action oDlg01:End()    Pixel

Activate MsDialog oDlg01

RestArea(aAreaSC6)
RestArea(aAreaSC5)

Return

//
//Anexa os arquivos no Pedido de Venda
//
Static Function Anexos(cPV, cItem)
Local aHeader    := {}
Local aCols      := {}
Private cNPedido := cPV
Private cNItem   := cItem
Private oxGetDados

AADD(aHeader,  {    "Cod. Documento"    ,   "ITEM"    ,"@R" ,50,0,""            ,"","C","","","","",".F."})//01
AADD(aHeader,  {    "Descrição"         ,   "DESCRI"  ,"@R" ,50,0,""            ,"","C","","","","",".T."})//02


If SZV->( dbSeek( xFilial() + "SC6" +cNPedido+cNItem ) )
	While !SZV->( EOF() ) .and. SZV->ZV_ALIAS == 'SC6' .and. AllTrim(SZV->ZV_CHAVE) == AllTrim(cNPedido+cNItem)
		AADD(aCols,{SZV->ZV_ARQUIVO,SZV->ZV_DESCRI,.F.})
		SZV->( dbSkip() )
	End
Else
	AADD(aCols,{"","",.F.})
EndIf

DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

Define MsDialog oDlg02 Title OemToAnsi("Documentos amarrados ao Pedido de Venda " + cPV+"/"+cItem) From 0,0 To 305,750 Pixel of oMainWnd PIXEL

oxGetDados  := (MsNewGetDados():New( 10, 09 , 130 ,370,GD_UPDATE+GD_DELETE ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,"U_fFfieldok()",/*superdel*/,/*delok*/,oDlg02,aHeader,aCols))
//oGetDados:oBrowse:Refresh()
//oGetDados:oBrowse:oFont  := oFontNW
//oGetDados:oBrowse:bChange:={||U_DEV002LOK(oGetDados)}

@ 135,175 Button "Incluir"     Size 45,13 Action Incluir()       Pixel
@ 135,225 Button "Excluir"     Size 45,13 Action Excluir()       Pixel
@ 135,275 Button "Visualizar"  Size 45,13 Action Visualizar()    Pixel
@ 135,325 Button "Sair"        Size 45,13 Action oDlg02:End()    Pixel

Activate MsDialog oDlg02

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

Private cChave    := cNPedido+cNItem
Private cAlias    := "SC6"

If Empty(cChave)
	//MsgStop("Preencher primeiramente o código do produto.")
	//Verificar se a OP esta fechada
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
	
	//Cria pasta caso não exista ainda
	MontaDir(cSlvAnexos+"\"+cChave+"\")
	
	cNewGetFile := cSlvAnexos+"\"+cChave+"\"+cFile+cExten
	
	If File(cNewGetFile)
		Alert("Arquivo já anexado anteriormente.")
		Return
	EndIf
	
	COPY File &cGetFile TO &cNewGetFile
	
	If File(cNewGetFile)
		Reclock("SZV",.T.)
		SZV->ZV_FILIAL  := xFilial("SZV")
		SZV->ZV_ALIAS   := cAlias
		SZV->ZV_CHAVE   := cChave
		SZV->ZV_ARQUIVO := cFile+cExten
		SZV->( msUnlock() )
		
		If Len(oxGetDados:aCols) == 1 .and. Empty(oxGetDados:aCols[1,1])
			oxGetDados:aCols[1,1] := SZV->ZV_ARQUIVO
			oxGetDados:aCols[1,2] := SZV->ZV_DESCRI
		Else
			AADD(oxGetDados:aCols,{SZV->ZV_ARQUIVO,SZV->ZV_DESCRI,.F.})
		EndIf
		
		MsgInfo("Arquivo incluído com sucesso.")
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
MsgStop("Arquivo não encontrado.")
Return
EndIf

If File(cFileDes)
fErase(cFileDes)
EndIf

If File(cFileDes)
Alert("Arquivo já está aberto!")
Return
EndIf

COPY File &cFileOri TO &cFileDes

ShellExecute("open",cFileDes,"","", 5 )
Else
MsgStop("O arquivo não foi encontrado para exibição")
EndIf
Else
MsgStop("Posicione em um arquivo para exibição")
EndIf
*/

n := oxGetDados:oBrowse:nAt
If n > 0

	If SZV->( dbSeek( xFilial() + "SC6" + cNPedido+cNItem + Space(15-Len(cNPedido+cNItem)) + oxGetDados:aCols[n,1] ) )
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
				MsgStop("Arquivo não encontrado.")
				Return
			EndIf
			
			If File(cFileDes)
				fErase(cFileDes)
			EndIf
			
			If File(cFileDes)
				Alert("Arquivo já está aberto!")
				Return
			EndIf
			
			COPY File &cFileOri TO &cFileDes
			
			ShellExecute("open",cFileDes,"","", 5 )
		Else
			MsgStop("Documento não encontrado no Controle de Documentos.")
		EndIf
	Else
		MsgStop("O arquivo não foi encontrado para exibição")
	EndIf
Else
	MsgStop("Posicione em um arquivo para exibição")
EndIf

Return

Static Function Excluir()

Local cFileDes := ""
Local cPathTmp := AllTrim( GetTempPath() )

n := oxGetDados:oBrowse:nAt

If n > 0
	//If SZV->( dbSeek( xFilial() + "SC2" + SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN + oGetDados:aCols[n,1] ) )
	If SZV->( dbSeek( xFilial() + "SC6" + cNPedido+cNItem + Space(15-Len(cNPedido+cNItem)) + oxGetDados:aCols[n,1] ) )

		If MsgYesNo("Deseja realmente excluir o arquivo '" + Alltrim(oxGetDados:aCols[n,1]) + "' ?")
			cFileDel := cSlvAnexos + "\" + AllTrim(SZV->ZV_CHAVE) + "\" + AllTrim(SZV->ZV_ARQUIVO)
			
			If !File(cFileDel)
				MsgStop("Arquivo não encontrado para ser excluído.")
				Return
			EndIf
			
			fErase(cFileDel)
			
			If File(cFileDes)
				MsgStop("Não foi possível excluir o arquivo.")
			Else
				Reclock("SZV",.F.)
				SZV->( dbDelete() )
				SZV->( msUnlock() )
				
				aColsBkp := aClone(oxGetDados:aCols)
				aColsNew := {}
				
				For x := 1 to Len(aColsBkp)
					If x <> n
						AADD(aColsNew,aColsBkp[x])
					EndIf
				Next x
				
				oxGetDados:aCols := aClone(aColsNew)
				
				MsgInfo("Arquivo excluído com sucesso.")
				
			EndIf
		EndIf
	Else
		MsgStop("O arquivo não foi encontrado para exclusão.")
	EndIf
Else
	MsgStop("Posicione em um arquivo para exclusão.")
EndIf

Return

User Function fFfieldok()

If SZV->( dbSeek( xFilial() + "SC6" + cNPedido+cNItem + Space(15-Len(cNPedido+cNItem)) + oxGetDados:acols[oxGetDados:oBrowse:nAt,1] ) )
	Reclock("SZV",.F.)
	SZV->ZV_DESCRI := M->DESCRI
	SZV->( msUnlock() )
EndIf

Return .T.
