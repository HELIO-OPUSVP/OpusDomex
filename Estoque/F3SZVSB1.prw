#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
//#INCLUDE 'DBTREE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F3SZV     ºAutor  ³Helio Ferreira      º Data ³  26/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function F3SZVSB1(__nOpc)

Private cSlvAnexos:= "\ServiceDesk\banco_conhecimento\SB1"

/*
Private aRotina  := {	{ OemToAnsi(STR0002),"Ft340Pesqui",0,1,0,.F.},;	// "Pesquisar"
{ OemToAnsi(STR0003),"Ft340Alter" ,0,2,0,NIL},;	// "Visual"
{ OemToAnsi(STR0004),"Ft340Inclu" ,0,3,0,NIL},;	// "Incluir"
{ OemToAnsi(STR0005),"Ft340Alter" ,0,4,0,NIL},;	// "Alterar"
{ OemToAnsi(STR0006),"Ft340Alter" ,0,5,0,NIL},;	// "Exclusao"
{ OemToAnsi(STR0030),"Ft340UpdFil",0,4,0,NIL},;	// "Atualiza"
{ OemToAnsi(STR0007),"Ft340SavAs" ,0,4,0,NIL} }	// "Salvar Como"

*/

If __nOpc == 3  // Inclui
   fInclui()
EndIf

If __nOpc == 4  // Altera
   fAbrirDoc()
EndIf

Return

Static Function fInclui()

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

Private cChave    := M->B1_COD
Private cAlias    := "SB1"

If Empty(cChave)
   MsgStop("Preencher primeiramente o código do produto.")
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

	//Cria pasta caso não exita ainda
	MontaDir(cSlvAnexos+"\"+cChave+"\")
	
	cNewGetFile := cSlvAnexos+"\"+cChave+"\"+cFile+cExten
	
	If File(cNewGetFile)
		Alert("Arquivo já anexado anteriormente.")
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
	   SZV->( dbSeek( xFilial() + cAlias + cChave) )
      MsgInfo("Arquivo incluído com sucesso.")
   Else
      MsgStop("Erro ao anexar o arquivo.")
   EndIf
EndIf

Return


Static Function fAbrirDoc()

Local cFileDes := ""
Local cPathTmp := AllTrim( GetTempPath() )

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

Return
