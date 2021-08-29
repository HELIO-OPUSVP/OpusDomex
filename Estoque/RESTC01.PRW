#include "rwmake.ch"
#include "protheus.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA010MNU ºAutor  ³Helio Ferreira      º Data ³  30/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Botão de amarração de documentos (.doc, .pdf) a cadastro   º±±
±±º          ³ de produtos.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Domex                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RESTC01()

//Private cSlvAnexos := "\system\docs"
Private cSlvAnexos := "\docs"
PRIVATE oFontNW
Private oGetDados
Private aHeader    := {}
Private aCols      := {}
Private cProduto   := Space(16)
Private cDescProd  := Space(60)      
Private cCodClien  := Space(06)
Private cNomClien  := Space(60)
Private oTexto2
Private oTexto3
Private oTexto4

AADD(aHeader,  {    "Arquivo"    ,   "ITEM"    ,"@R" ,50,0,""            ,"","C","","","","",".F."})//01
AADD(aHeader,  {    "Descrição"  ,   "DESCRI"  ,"@R" ,50,0,""            ,"","C","","","","",".T."})//02

AADD(aCols,{"","",.F.})

DEFINE FONT oFontNW  NAME "Arial" SIZE 0,-15 BOLD

Define MsDialog oDlg01 Title OemToAnsi("Documentos amarrados ao produto ") From 0,0 To 310,750 Pixel of oMainWnd PIXEL

@ 007, 008	SAY oTexto1   VAR 'Produto/OP: '  PIXEL SIZE 180,15
oTexto1:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 005, 60 MSGET oProduto VAR cProduto  Picture "@!"  SIZE 90,12 Valid ValidaProd() PIXEL
oProduto:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

@ 007, 155	SAY oTexto2   VAR cDescProd  PIXEL SIZE 500,15
oTexto2:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

@ 025, 008	SAY oTextoC   VAR 'Cliente: '  PIXEL SIZE 180,15
oTextoC:oFont := TFont():New('Arial',,20,,.T.,,,,.T.,.F.)

@ 025, 60	SAY oTexto3   VAR cCodClien  PIXEL SIZE 500,15
oTexto3:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

@ 025, 105	SAY oTexto4   VAR cNomClien  PIXEL SIZE 500,15
oTexto4:oFont := TFont():New('Courier New',,24,,.T.,,,,.T.,.F.)

//GD_UPDATE+GD_DELETE
oGetDados  := (MsNewGetDados():New( 40, 09 , 130 ,370,Nil ,"AlwaysTrue" ,"AlwaysTrue", /*inicpos*/,/*aCpoHead*/,/*nfreeze*/,9999 ,/*"U_Ffieldok()"*/,/*superdel*/,/*delok*/,oDlg01,aHeader,aCols))
//oGetDados:oBrowse:Refresh()
//oGetDados:oBrowse:oFont  := oFontNW
//oGetDados:oBrowse:bChange:={||U_DEV002LOK(oGetDados)}

@ 135,275 Button "&Visualizar"  Size 45,13 Action Visualizar()    Pixel
@ 135,325 Button "Sair"        Size 45,13 Action oDlg01:End()    Pixel

Activate MsDialog oDlg01

Return

Static Function Visualizar()

Local cPathTmp := AllTrim( GetTempPath() )
Local cFileDes := ""

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

n := oGetDados:oBrowse:nAt
If n > 0
	If SZV->( dbSeek( xFilial() + "SB1" + SB1->B1_COD + oGetDados:aCols[n,1] ) )
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

Static Function ValidaProd()
Local lEncontrou := .F.

SB1->( dbSetOrder(1) )
If SB1->( dbSeek( xFilial() + Subs(cProduto,1,15) ) )
   lEncontrou := .T.
Else
   SC2->( dbSetOrder(1) )
   If SC2->( dbSeek( xFilial() + Subs(cProduto,1,11) ) )
      cCodCLien := SC2->C2_CLIENT
      cNomClien := SC2->C2_NCLIENT
      oTexto3:Refresh()
      oTexto4:Refresh()
      If SB1->( dbSeek( xFilial() + SC2->C2_PRODUTO ) )
         lEncontrou := .T.   
      EndIf
   EndIf
EndIf

If lEncontrou

   cDescProd := SB1->B1_DESC
   oGetDados:aCols := {}
	If SZV->( dbSeek( xFilial() + "SB1" + SB1->B1_COD ) )
		While !SZV->( EOF() ) .and. SZV->ZV_ALIAS == 'SB1' .and. SZV->ZV_CHAVE == SB1->B1_COD
			AADD(oGetDados:aCols,{SZV->ZV_ARQUIVO,SZV->ZV_DESCRI,.F.})
			SZV->( dbSkip() )
		End
		oGetDados:oBrowse:Refresh()
	Else
	   MsgInfo("Não foram encontrados docmentos para este produto/OP")
	   oGetDados:aCols := {}
	   AADD(oGetDados:aCols,{"","",.F.})
	   
	   // Envio de workflow para engenharia
	   cAssunto := "Produto consultado sem Documento Domex"
	   cTexto   := "Produto: " + SB1->B1_COD
	   cPara    := 'denis.vieira@rdt.com.br;monique.garcia@rosenbergerdomex.com.br;daniel.cavalcante@rosenbergerdomex.com.br;fabiana.santos@rosenbergerdomex.com.br;tatiane.alves@rosenbergerdomex.com.br;lucimar.silveira@rosenbergerdomex.com.br'
  		cCC      := 'natalia.silva@rosenbergerdomex.com.br;keila.gamt@rosenbergerdomex.com.br;leonardo.andrade@rosenbergerdomex.com.br;gabriel.cenato@rosenbergerdomex.com.br;luiz.pavret@rdt.com.br' //chamado monique 015475
	   cArquivo := Nil
	   U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
	   
	   MsgInfo("Workflow de aviso enviado para: '" + cPara + "'.")
	EndIf
	//oGetDados:oBrowse:Refresh()
Else
	MsgInfo("Produto/OP não encontrado.")
	cDescProd       := ""
	oGetDados:aCols := {}
	AADD(oGetDados:aCols,{"","",.F.})
	//oGetDados:oBrowse:Refresh()
EndIf

If Len(oGetDados:aCols) == 1
   Visualizar()
EndIf

Return .T.
