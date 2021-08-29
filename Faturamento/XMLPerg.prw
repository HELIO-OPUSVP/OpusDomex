#include "protheus.ch"

User Function XMLPerg(cPerg, cDir, bOk, cTitulo, cNome, cDesc, cExtensao, nOpc, cMsgProc)

Local oFont1    
Local oDialog
Local oImagem
Local cTipoArq 	:= "Todos os Arquivos (*.*)     | *.* |"
Local cArquivo  := ""
Local cXML      := ""
Local lCancela  := .F.
Local bGravaArq := {|| Iif(lCancela, Alert("Processamento cancelado pelo usuário."), Iif(!Empty(cXML), Eval({|| Iif(nOpc == 1, ShellExecute("open", AllTrim(cArquivo)+"."+AllTrim(cExtensao), "", "", 1), NIL), Aviso("Resultado de processamento", "Arquivo gerado com sucesso!", {"Ok"})}), Alert("Nenhum arquivo foi gerado!")))}


Default nOpc      := 1
Default cDir      := "C:\"
Default cExtensao := "XML"
Default cMsgProc  := "Aguarde. Gerando relatório..."

Pergunte(cPerg, .F.)

cArquivo := cDir + cNome
cArquivo := PadR(cArquivo, 250)

oFont1 := TFont():New(,,16,,.T.) 

oDialog := MSDialog():New(0, 0, 270, 400, OemToAnsi(cTitulo),,,,,,CLR_WHITE,,,.T.,,,)

TSay():New(005,063,{|| "Listagem de Pedidos por Produto"},,,oFont1,,,,.T.)

TGroup():New(015,004,043,197," Destino: "  ,oDialog,,,.T.)
TGet():New(024,008,bSetGet(cArquivo),,171,010,,,,,,,,.T.)
//TButton():New(024,180, "...",,{|| cPath := cGetFile(cTipoArq,"Selecione o diretÛrio de destino",0,cDir,.T.,GETF_LOCALHARD+GETF_RETDIRECTORY, .F.), cDir := Iif(Empty(cPath), cDir, cPath), cArquivo := PadR(cDir + cNome, 250)},012,012,,,,.T.)
TBtnBmp2():New(047,359,026,026,"SDUOPEN",,,,{|| cPath := cGetFile(cTipoArq,"Selecione o diretório de destino",0,cDir,.T.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY, .F.), cDir := Iif(Empty(cPath), cDir, cPath), cArquivo := PadR(cDir + cNome, 250)},oDialog,"Pesquisa local de destino")

TGroup():New(045,004,100,197," Descrição: ",oDialog,,,.T.)
TMultiGet():New(054,008,bSetGet(cDesc),,185,040,,,,,,.T.,,,,,,.T.,,,)
                                                          
TGroup():New(102,004,133,095," Opeções: ",oDialog,,,.T.)
oImagem := TBitmap():New(113,009, 32, 32, "MDIEXCEL",,.T.,oDialog,,,,,,,,,.T.,,,.T.)
TRadMenu():New(110,025,{"Gera arquivo + Abre","Somente gera arquivo"},bSetGet(nOpc), oDialog,,{|| oImagem:Load(Iif(nOpc == 1, "MDIEXCEL", "SALVAR"))},,,,,,065,011,,,,.T.)
     
SButton():New(120, 110, 5, {|| Pergunte(cPerg, .T.)}) // Parametros
SButton():New(120, 140, 1, {|| Iif(VldNomeArq(@cArquivo, cExtensao), Eval({|| Processa({|lEnd| cXML := Eval(bOk, @lEnd, AllTrim(cArquivo)+"."+AllTrim(cExtensao)), lCancela := lEnd},cMsgProc,,.T.), Eval(bGravaArq), oDialog:End()}),Nil)} ) // Ok
//SButton():New(120, 140, 1  ,{|| fOk(cArquivo,cExtensao,cMsgProc,bOk,bGravaArq) } ) // Ok

SButton():New(120, 170, 2, {|| oDialog:End()})         // Cancela

Activate Dialog oDialog CENTERED
	
Return .T.

Static Function fOk(cArquivo,cExtensao,cMsgProc,bOk,bGravaArq)

	//{|| Iif(VldNomeArq(@cArquivo, cExtensao), Eval({|| Processa({|lEnd| cXML := Eval(bOk, @lEnd, AllTrim(cArquivo)+"."+AllTrim(cExtensao)), lCancela := lEnd},cMsgProc,,.T.), Eval(bGravaArq), oDialog:End()}),Nil)}
			processa({|| Iif(VldNomeArq(@cArquivo, cExtensao), Eval({|| Processa({|lEnd| cXML := Eval(bOk, @lEnd, AllTrim(cArquivo)+"."+AllTrim(cExtensao)), lCancela := lEnd},cMsgProc,,.T.), Eval(bGravaArq), oDialog:End()}),Nil)})
		//If VldNomeArq(@cArquivo, cExtensao)
		//	Eval({|| {|lEnd| cXML := Eval(bOk, @lEnd, AllTrim(cArquivo)+"."+AllTrim(cExtensao)
		//Else
		//	lCancela := lEnd},cMsgProc,,.T.), Eval(bGravaArq), })
		//EndIf
		//Eval({|| Iif(VldNomeArq(@cArquivo, cExtensao), Eval({|| Processa({|lEnd| cXML := Eval(bOk, @lEnd, AllTrim(cArquivo)+"."+AllTrim(cExtensao)), lCancela := lEnd},cMsgProc,,.T.), Eval(bGravaArq), oDialog:End()}),Nil)})
	

Return

Static Function VldNomeArq(cArq, cExt)
Local lRet     := .T.
Local lAchou   := .F.
Local cNomeRel := SubStr(cArq, RAt("\", cArq) + 1)
Local cPath    := SubStr(cArq, 1, RAt("\", cArq))

// Procura pelo arquivo no diretÛrio
aEval(Directory(cPath+"*."+cExt), {|aArqTXT| Iif(AllTrim(Upper(SubStr(aArqTXT[1],1,RAt(".",aArqTXT[1]) - 1))) == AllTrim(Upper(cNomeRel)), lAchou := .T., Nil)})

If lAchou	
	If MsgNoYes("Já existe um arquivo no diretório com este nome. Deseja continuar e substituir este arquivo?")
		If FErase(AllTrim(cArq)+"."+AllTrim(cExt)) < 0// Apaga o arquivo
			lRet := .F.
			Alert("Atenção! Não foi possível excluir o arquivo "+AllTrim(cArq)+"."+AllTrim(cExt)+". Verifique se o mesmo está aberto ou sendo utilizado por outro programa.")
		EndIf		
	Else
		lRet := .F.
	EndIf
EndIf

Return lRet
