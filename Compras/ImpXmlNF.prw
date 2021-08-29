#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#include "xmlxfun.ch"
#include "tryexception.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpXmlNF บAutor  ณ Felipe A. Melo     บ Data ณ  10/05/2012 บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10 - Chamado via JOB                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
pontos de necessidades
--
parametros para conta de e-mail e senha
GETMV(OP_XMLCONT,"") //CONTA
GETMV(OP_XMLSENH,"") //SENHA
GETMV(OP_XMLSRV1,"")//SERVIDOR POP
GETMV(OP_XMLSRV2,"") //SERVIDOR SMTP
GETMV(OP_XMLDIR1,"") //DIRETORIO PENDENTES  \data\impxml\pendente\      
GETMV(OP_XMLDIR2,"") //DIRETORIO PROCESSADAS \data\impxml\processado\                                                   
GETMV(OP_XMLDIR3,"") //DIRETORIO EXCLUIDOS \data\impxml\EXCLUIDOS\                                                     
GETMV(OP_XMLDIR4,"") //DIRETORIO RECUSADOS \data\impxml\recusado\                                                     

*/

User Function ImpXmlTNF()

	U_ImpXmlNF(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpXmlNF บAutor  ณ Felipe A. Melo     บ Data ณ  10/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpXmlNF(lSchedule)

Local x         := {}
Local aRetTela  := {}
Local aRetArqs  := {}
Local aRetXmls  := {}
Local lRetPreNF := .F.

Private lCTeRemet := .F.
Private cPastaPen := "" //Pendente
Private cPastaPro := "" //Processado
Private cPastaRec := "" //Recusado

Default lSchedule := .F.

// Variavel Publica para Testas nos PE de entrada de Pre-Nota/Doc.Entrada se a rotina de origem ้ a de Importacao de XML
Public lImpXmlNF  := .T.

//Todo desenvolvimento deverแ ser realizado pensando na execu็ใo via JOB ou Usuแrio
//Caso rotina nใo seja chamada pelo Schedule, aparecer tela para informar o XML a ser processado

If lSchedule
//SE FOR SCHEDULE SOMENTE CARREGA OS E-MAILS, MAS NรO REALIZA A IMPORTAวรO DAS NOTAS FISCAIS
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM"
	MsAguarde( { || U_fBxAnexo(.F.) } ,"Baixando e-mail", "Procurando e-mails com anexos XML - Aguarde..." )
	Return
EndIf

//Nesta tela deverแ ter uma chamada para permitir alteracao do caminho definido nos parametros SX6 (diretorio padrใo utilizado pelo schedule)
aRetTela := fTelaParam(lSchedule)
If aRetTela[1]
	nLerPasta := aRetTela[2]
	cPastaPen := GetMv("OP_XMLDIR1") //DIRETORIO PENDENTES  \data\impxml\pendente\     AllTrim(aRetTela[3])
	cPastaPro := GetMv("OP_XMLDIR2") //DIRETORIO PROCESSADAS \data\impxml\processado\	AllTrim(aRetTela[4])
	cPastaRec := GetMv("OP_XMLDIR4") //DIRETORIO RECUSADOS \data\impxml\recusado\ 		AllTrim(aRetTela[5])                                                   
//GetMv(OP_XMLDIR3,"") //DIRETORIO EXCLUIDOS \data\impxml\EXCLUIDOS\                                                     

Else
	Return
EndIf

//Fun็ใo para baixar emails com anexos XML
MsAguarde( { || U_fBxAnexo(.F.) } ,"Baixando e-mail", "Procurando e-mails com anexos XML - Aguarde..." )

//Fun็ใo para ler pasta/diretorio dos xml que serao importados
MsAguarde( { || aRetArqs :=  fLerPasta(cPastaPen,nLerPasta) } ,"Procurando XML", "Procurando por arquivos XML - Aguarde..." )

//Processa arquivos
//aRetArqs:={} //nใo processa
For x:=1 to Len(aRetArqs)
	//Zera Variaveis
	aRetXmls := {}
	
	//Fun็ใo para leitura dos XML
	//aRetXmls := {lRet,aRet,cMsg}
	aRetXmls := fLerXml(aRetArqs[x],nLerPasta)
	lEhCTe  := aRetXmls[4]
	lEhNFe  := !lEhCTe
	
	//Caso retorno .T. ้ que validou com sucesso
	If aRetXmls[1] .And. lEhNFe
		//Fun็ใo para atualiza็ใo cadastral
		fPutCad(aRetXmls[2])
		
		//Fun็ใo para alimentar variแveis e executar MsExecAuto da Pr้-Nota
		Processa({ || lRetPreNF := fExecPreNF(lSchedule,aRetXmls[2]) }, "Aguarde, processando...")
		
		//Fun็ใo para tratar retorno da tentativa de inclusใo da Pr้-Nota
		fReturnPre(lRetPreNF,aRetArqs[x],aRetXmls[2])
		
	ElseIf aRetXmls[1] .And. lEhCTe .And. !lCTeRemet
		//Fun็ใo para alimentar variแveis e executar MsExecAuto da Pr้-Nota
		Processa({ || lRetPreNF := fExecPreCTe(lSchedule,aRetXmls[2]) }, "Aguarde, processando...")
		
		//Fun็ใo para tratar retorno da tentativa de inclusใo da Pr้-Nota
		fReturnPre(lRetPreNF,aRetArqs[x],aRetXmls[2])
		
	ElseIf aRetXmls[1] .And. lEhCTe .And. lCTeRemet
		//Fun็ใo para alimentar variแveis e executar MsExecAuto da Pr้-Nota
		Processa({ || lRetPreNF := fExecCTeRem(lSchedule,aRetXmls[2]) }, "Aguarde, processando...")
		
		//Fun็ใo para tratar retorno da tentativa de inclusใo da Pr้-Nota
		fReturnPre(lRetPreNF,aRetArqs[x],aRetXmls[2])
		
	Else
		//Fun็ใo para tratar retorno da tentativa de inclusใo da Pr้-Nota
		fReturnPre(.F.,aRetArqs[x])
		// -> mensagem de erro
		If lSchedule
			fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", aRetXmls[3])
		Else
			Alert(aRetXmls[3])
		EndIf
	EndIf
	
Next x

If Len(aRetArqs) > 0
	If lSchedule
		fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Aviso de importa็ใo do XML para Pre-Nota", "Fim do processamento!")
	Else
		MsgInfo("Fim do processamento!")
	EndIf
Else
	If lSchedule
		fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Aviso de importa็ใo do XML para Pre-Nota", "Nenhum XML processado!")
	Else
//		MsgInfo("Nenhum XML processado!")
	EndIf
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTelaParamบAutor  ณ Felipe A. Melo     บ Data ณ  23/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fTelaParam(lSchedule)

//Declara็ใo das variaveis
Local cTitulo		:= "PRษ-NF | Importa XML"
Local cText1		:= "Esta rotina tem como objetivo gerar uma Pr้-Nota [Documento de Entrada] para "
Local cText2		:= "cada XML disponibilizado nas pastas pr้-definidas e conforme o preenchimento "
Local cText3		:= "dos parametros desta rotina."
Local cPerg			:= Padr("XMLIMP",10)
Local aSays			:= {}
Local aButtons		:= {}
Local nOpca			:= 0
Local lRet			:= .T.

//Cria SXB caso nใo exista
fCriaSXB()

//Cria SX1 caso nใo exista
fCriaSX1(cPerg)

//Execu็ใo da pergunta ocultamente para alimentar as variaveis
Pergunte(cPerg,.F.)

//Alimenta variaveis da tela que serแ montada abaixo
AADD(aSays,OemToAnsi( ""     ) )
AADD(aSays,OemToAnsi( cText1 ) )
AADD(aSays,OemToAnsi( ""     ) )
AADD(aSays,OemToAnsi( cText2 ) )
AADD(aSays,OemToAnsi( ""     ) )
AADD(aSays,OemToAnsi( cText3 ) )
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() }} )
AADD(aButtons, { 2,.T.,{|o| nOpca:= 0,o:oWnd:End() }} )
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

If !lSchedule
	//Monta tela de processamento
	FormBatch( cTitulo, aSays, aButtons )
	
	//Ap๓s confirma็ใo, trata conforme botใo executado
	If nOpca == 1
		lRet := .T.
	Else
		lRet := .F.
	EndIf
EndIf

Return( {lRet , MV_PAR05 } )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLerPastaบAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLerPasta(cPastaPen,nLerPasta)

Local x       := 00
Local aRet    := {}
Local aDir    := {}

Local oXml    := Nil
Local aItens  := {}
Local aRetXml := {}
Local lTag    := .T.

//Ler todos os XML
aDir := Directory(cPastaPen+"*.XML")
For x:=1 To Len(aDir)
	aAdd(aRet, { cPastaPen, aDir[x][1] })
Next x


For x:=1 To Len(aRet)
	oXml    := Nil
	lTag    := .T.
	lOculta := .F.
	aRetXml := { }
	aRetXml := fLerXml(aRet[x],nLerPasta)
	lEhCTe  := aRetXml[4]
	lEhNFe  := !lEhCTe
	
	If aRetXml[1]
		oXml    := aRetXml[2]
		
		//Verifica se existe TAG no objeto
		If lEhNFe
			lTag := IIf(lTag,fChekErro(oXml),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_NFE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_NFE:_INFNFE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_IDE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_DEST),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_PROTNFE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_NFEPROC:_PROTNFE:_INFPROT),.F.)
		EndIf
		
		If lEhCTe
			lTag := IIf(lTag,fChekErro(oXml),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_CTE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_CTE:_INFCTE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_IDE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_EMIT),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_DEST),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_PROTCTE),.F.)
			lTag := IIf(lTag,fChekErro(oXml:_CTEPROC:_PROTCTE:_INFPROT),.F.)
		EndIf
		
		//Caso encontra alguma TAG com erro (ausente)
		If !lTag
			//Adiciona Linha
			aAdd(aItens,{})
			
			aAdd(aTail(aItens), "ERRO" )
			aAdd(aTail(aItens), "ERRO" )
			aAdd(aTail(aItens), "ERRO" )
			aAdd(aTail(aItens), StoD("") )
			aAdd(aTail(aItens), 0 )
			aAdd(aTail(aItens), aRetXml[3] )
			aAdd(aTail(aItens), "ERRO" )
			aAdd(aTail(aItens), "ERRO" )
			aAdd(aTail(aItens), aRet[x][2] )
			aAdd(aTail(aItens), "ERRO" )
			aAdd(aTail(aItens), "ERRO2" )			
		EndIf
		
		//Verifica se NFe foi emitida pela propria Empresa, para omitir na listagem (Felipe Melo - 21/01/2013)
		If lTag .And. AllTrim(SM0->M0_CGC) == AllTrim(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)
			lOculta := .T.
			fErase(aRet[x][1]+aRet[x][2])
		EndIf
		
		//==========================================================================================
		//Se XML nใo foi excluido e ้ XML de NFe, entใo mostrar na listagem
		If lTag .And. !lOculta .And. lEhNFe
			//Adiciona Linha
			aAdd(aItens,{})
			
			cNumero :=''
			cSerie	:=''
			cTpXML	:=''
			dDtEmis	:=ctod('  /  /  ')
			nValor	:=0
			cDE		:=''
			cPara	:=''
			cChave	:=''
			cArqXML	:=''
			cCLIFOR :=''
			
			// busca Versao da NF-e para tratar diferencas entre 2.00 e 3.10 - Adicionado por Marco Aurelio-MAS-30/10/14
			cVersao:= oXml:_NFEPROC:_VERSAO:TEXT
			
			//01 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF)
				cNumero := oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
			EndIf
			//02 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE)
				cSerie	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			EndIf
			//03 - Verifica se existe TAG no objeto
			If lTag
				cTpXML := "NFe-"+fVerTipo(oXml)
			EndIf
			//04 - Verifica se existe TAG no objeto
			if alltrim(cVersao) <> "2.00"
				If lTag .And. fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi)
					dDtEmis := StoD(StrTran(Substr(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:TEXT,1,10),"-",""))
				EndIf         
			else
				If lTag .And. fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI)
					dDtEmis := StoD(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,"-",""))
				EndIf
			endif
			//05 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF)
				nValor:= Val(StrTran(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT,",","."))
			EndIf
			//06 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME)
				cDE := oXml:_NFEPROC:_NFE:_INFNFE:_EMIT:_XNOME:TEXT
			Else
				aAdd(aTail(aItens), "ERRO NA ESTRUTURA DO XML" )
			EndIf
			//07 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_XNOME)
				cPARA := oXml:_NFEPROC:_NFE:_INFNFE:_DEST:_XNOME:TEXT
			EndIf
			//08 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE)
				cChave:=oXml:_NFEPROC:_PROTNFE:_INFPROT:_CHNFE:TEXT
			EndIf
			//09 - Verifica se existe TAG no objeto
			If fChekErro(aRet[x][2])
				cArqXML := aRet[x][2]
			EndIf
			
			If upper(cTpXML) == "NFE-NORMAL"
				SA2->(dbSetOrder(3))
				If SA2->(dbSeek(xFilial("SA2")+AllTrim(oXml:_NFeProc:_NFe:_InfNfe:_Emit:_CNPJ:TEXT)))
					cCliFor := 'SA2'+SA2->A2_COD+SA2->A2_LOJA
				Endif
			Else
				SA1->(dbSetOrder(3))
				If SA1->(dbSeek(xFilial("SA1")+AllTrim(oXml:_NFeProc:_NFe:_InfNfe:_Emit:_CNPJ:TEXT)))
					cCliFor := 'SA1'+SA1->A1_COD+SA1->A1_LOJA
				Endif
			EndIf
		EndIf
		
		If lTag .And. !lOculta .And. lEhCTe
			//Adiciona Linha
			aAdd(aItens,{})
			
			cNumero :=''
			cSerie	:=''
			cTpXML	:=''
			dDtEmis	:=ctod('  /  /  ')
			nValor	:=0
			cDE		:=''
			cPara	:=''
			cChave	:=''
			cArqXML	:=''
			cCLIFOR :=''
			cVersao:= oXML:_InfCTE:_VERSAO:TEXT
			
			//01 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT)
				cNumero := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT
			EndIf
			//02 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE)
				cSerie := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT
			EndIf
			//03 - Verifica se existe TAG no objeto
			If lTag
				If AllTrim(SM0->M0_CGC) != AllTrim(oXml:_CTEPROC:_CTE:_InfCte:_Rem:_CNPJ:Text)
					cTpXML :=  "CTe-Normal" //fVerTipo(oXml)
				Else
					cTpXML :=  "CTe-Remet." //fVerTipo(oXml)
				EndIf
			EndIf
			//04 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI)
				dDtEmis:=StoD(SubStr(StrTran(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT,"-",""),1,8))
			EndIf
			//05 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST)
				nValor := Val(StrTran(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT,",","."))
			EndIf
			//06 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME)
				cDE := oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_XNOME:TEXT
			EndIf
			//07 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME)
				CPARA := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT
			EndIf
			//08 - Verifica se existe TAG no objeto
			If lTag .And. fChekErro(oXml:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE)
				cChave := oXml:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT
			EndIf
			//09 - Verifica se existe TAG no objeto
			If fChekErro(aRet[x][2])
				cArqXML := aRet[x][2]
			EndIf
			SA2->(dbSetOrder(3))
			If SA2->(dbSeek(xFilial("SA2")+AllTrim(oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)))
				cCliFor := 'SA2'+SA2->A2_COD+SA2->A2_LOJA
			Endif
			
		EndIf
		If lTag .And. !lOculta
			aAdd(aTail(aItens), right('000000000'+alltrim(cNumero),9) )
			aAdd(aTail(aItens), left(cSerie+'   ',3) )
			aAdd(aTail(aItens), cTpXML )
			aAdd(aTail(aItens), dDtEmis )
			aAdd(aTail(aItens), nValor )
			aAdd(aTail(aItens), cDE )
			aAdd(aTail(aItens), cPara )
			aAdd(aTail(aItens), cChave )
			aAdd(aTail(aItens), cArqXML )
			aAdd(aTail(aItens), cCliFor )
			aAdd(aTail(aItens), cVersao )			
		ENDIF
	Else
		//Adiciona Linha
		aAdd(aItens,{})
		
		aAdd(aTail(aItens), "ERRO" )
		aAdd(aTail(aItens), "ERRO" )
		aAdd(aTail(aItens), "ERRO" )
		aAdd(aTail(aItens), StoD("") )
		aAdd(aTail(aItens), 0 )
		aAdd(aTail(aItens), aRetXml[3] )
		aAdd(aTail(aItens), "ERRO" )
		aAdd(aTail(aItens), "ERRO" )
		aAdd(aTail(aItens), aRet[x][2] )
		aAdd(aTail(aItens), "ERRO" )		
		aAdd(aTail(aItens), "ERRO2" )		
		
	EndIf
Next x

fSelectNFe(@aRet,aItens)

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLerXml  บAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLerXml(aRetArqs,nLerPasta)

Local lRet      := .T.
Local aRet      := {}
Local cMsg      := ""
Local cError    := ""
Local lEhCTe    := .F.
Local cWarning  := ""
Local cLocalXml := aRetArqs[1]
Local cNomelXml := aRetArqs[2]
Local cXmlTexto := ""
Local oXmlObjto := Nil

If File(cLocalXml + cNomelXml)
	//Nao processa XML de outra empresa/filial
	cXmlTexto := MemoRead(cLocalXml + cNomelXml)
	If lRet .And. !(SM0->M0_CGC $ cXmlTexto)
		lRet := .F.
		cMsg := "Este XML pertence a outra empresa ou filial" //e nใo podera ser processado na empresa/filial corrente."
	EndIf
	
	//Nao processa XML com erro de sintaxe
	oXmlObjto := XmlParserFile(cLocalXml + cNomelXml,"_",@cError,@cWarning)
	If lRet .And. Empty(oXmlObjto) .Or. !Empty(cError)
		lRet := .F.
		cMsg := "Erro de sintaxe no arquivo XML: "+cError //+Chr(13)+Chr(10)+"Entre em contato com o emissor do documento e comunique a ocorr๊ncia."
	EndIf
	
	//Fun็ใo para valida็ใo do XML
	If lRet
		lRet := fValidXml(oXmlObjto,@cMsg,nLerPasta,@lEhCTe)
	EndIf
	
	//Atualiza array de retorno com o XML lido
	If lRet
		aRet := oXmlObjto
	EndIf
Else
	lRet      := .F.
	aRet      := {}
	cMsg      := "Arquivo XML nใo localizado."
EndIf

//Verifica se ้ NFe ou CTe

Return({lRet,aRet,cMsg,lEhCTe})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fValidXmlบAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValidXml(oFullXML,cMsg,nLerPasta,lEhCTe)

Local nX        := 00
Local lRet      := .T.
Local cTipoNF   := ""
Local cPerg     := "XMLIMP"
Local cTipoNF   := ""
Local lNFeFound := .F.
Local lCTeFound := .F.

Private oXML    := oFullXML
Private oAuxXML := oFullXML
Private oCT     := Nil
Private oNF     := Nil
Private oDet    := Nil
Private oIdent  := Nil

Pergunte(cPerg,.F.)

//Verifica se ้ NFe
oAuxXML := XmlChildEx(oAuxXML,"_NFE")
lNFeFound := Type("oAuxXML") != "U"
If !lNFeFound
	For nX := 1 To XmlChildCount(oXML)
		oAuxXML  := XmlChildEx(XmlGetchild(oXML,nX),"_NFE")
		lNFeFound := Type("oAuxXML:_InfNfe") != "U"
		If lNFeFound
			oXML := oAuxXML
			Exit
		EndIf
	Next nX
EndIf

//Verifica se ้ CTe se nใo for NFe
If !lNFeFound
	oAuxXML := oFullXML
	oAuxXML := XmlChildEx(oAuxXML,"_CTE")
	lCTeFound := Type("oAuxXML") != "U"
	If !lCTeFound
		For nX := 1 To XmlChildCount(oXML)
			oAuxXML   := XmlChildEx(XmlGetchild(oXML,nX),"_CTE")
			lCTeFound := Type("oAuxXML:_InfCte") != "U"
			If lCTeFound
				oXML := oAuxXML
				Exit
			EndIf
		Next nX
	EndIf
EndIf

//Valida arquivo quando NFe
If lRet .And. lNFeFound
	oNF    := oXML
	oDet   := IIf(ValType(oNF:_InfNfe:_Det)=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
	oIdent := oNF:_InfNfe:_IDE
	
	//Verifica o tipo da nota fiscal
	For nX :=1 To Len(oDet)
		//Beneficiamento
		If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ alltrim(GetMv("OP_XMLBEN")) 	//"901/920"
			cTipoNF := "B"
			nX := Len(oDet)
		EndIf
		
		//Devolu็ใo
		If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ alltrim(GetMv("OP_XMLDEV"))    //"201" //"902/903"
			cTipoNF := "D"
			nX := Len(oDet)
		EndIf
	Next nX
	
	//Normal
	If Empty(cTipoNF) .And. !Empty(oIdent:_finNFe:Text)
		cTipoNF := "N"
	ElseIf Empty(cTipoNF)
		cTipoNF := ""
	EndIf
	
	//Verifica o tipo da nota fiscal
	//If AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "1"
	if cTipoNF == "N"
		If !(nLerPasta == 1 .Or. nLerPasta == 4)
			cMsg := "Nใo ้ para processar arquivos normais!"
			lRet := .F.
		EndIf
		//ElseIf AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "2"
	ElseIf cTipoNF == "D"
		If !(nLerPasta == 2 .Or. nLerPasta == 4)
			cMsg := "Nใo ้ para processar arquivos de devolu็ใo!"
			lRet := .F.
		EndIf
		//ElseIf !Empty(oXML:_InfNfe:_Ide:_finNFe:Text)
	ElseIf cTipoNF == "B"
		If !(nLerPasta == 3 .Or. nLerPasta == 4)
			cMsg := "Nใo ้ para processar arquivos de beneficiamento!"
			lRet := .F.
		EndIf
	Else
		cMsg := "Nใo foi identificado o tipo do arquivo XML!"
		lRet := .F.
	EndIf
	
	//Verifica se CNPJ estแ dentro do range informado nos parametros
	cCnpjCliFor := Alltrim(oXML:_INFNFE:_EMIT:_CNPJ:TEXT)
	If !(cCnpjCliFor >= MV_PAR01 .And. cCnpjCliFor <= MV_PAR02)
		cMsg := "CNPJ do Cliente/Fornecedor estแ fora do range definido nos parametros!"
		lRet := .F.
	EndIf
	
	//Verifica se Data da Emissใo estแ dentro do range informado nos parametros
	//Adicionado por Marco Aurelio-MAS-30/10/14

	cVersao	:=  oXML:_InfNfe:_VERSAO:TEXT
	if alltrim(cVersao) <> "2.00"
		dDtEmis	 := StoD(StrTran(Substr(oXml:_INFNFE:_IDE:_dhEmi:TEXT,1,10),"-",""))	//MAS- EMISSAO PARA EMIS
	Else
		dDtEmis := StoD(StrTran(Substr(oXml:_INFNFE:_IDE:_dEmi:TEXT,1,10),"-",""))	//MAS - EMISSAO PARA EMIS
	Endif
	
	If !(dDtEmis >= MV_PAR03 .And. dDtEmis <= MV_PAR04)	//MAS - EMISSAO PARA EMIS
		cMsg := "Data de Emissใo estแ fora do range definido nos parametros!"
		lRet := .F.
	EndIf
EndIf

//Valida arquivo quando CTe
If lRet .And. lCTeFound
	oCT    := oXML
	oIdent := oCT:_InfCte:_IDE
	
	//Verifica o tipo da nota fiscal
	If SubStr(AllTrim(oIdent:_CFOP:TEXT),2,3) $ "352/353"
		//Normal
		cTipoNF := "T"
	Else
		cTipoNF := ""
		lRet := .F.
		cTipoNF := ""
		cMsg := "CFOP nใo tratada para processar arquivos de conhecimento (CTe)!"
	EndIf
	
	//Verifica o tipo da nota fiscal
	if lRet .And. cTipoNF == "T"
		If !(nLerPasta == 4)
			cMsg := "Nใo ้ para processar arquivos de conhecimento (CTe)!"
			lRet := .F.
		EndIf
	EndIf
	
	If lRet .And. !( AllTrim(SM0->M0_CGC) == AllTrim(oCT:_InfCte:_Dest:_CNPJ:Text) .Or. AllTrim(SM0->M0_CGC) == AllTrim(oCT:_InfCte:_Rem:_CNPJ:Text) )
		cMsg := "O Destinatแrio nใo ้ " + alltrim(SM0->M0_NOME) + " !"
		lRet := .F.
	EndIf
	
	If lRet
		If AllTrim(SM0->M0_CGC) == AllTrim(oCT:_InfCte:_Rem:_CNPJ:Text)
			lCTeRemet := .T.
		Else
			lCTeRemet := .F.
		EndIf
	EndIf
	
	//Verifica se CNPJ estแ dentro do range informado nos parametros
	cCnpjCliFor := Alltrim(oCT:_InfCte:_Emit:_Cnpj:Text)
	If lRet .And. !(cCnpjCliFor >= MV_PAR01 .And. cCnpjCliFor <= MV_PAR02)
		cMsg := "CNPJ do Cliente/Fornecedor estแ fora do range definido nos parametros!"
		lRet := .F.
	EndIf
	
	//Verifica se Data da Emissใo estแ dentro do range informado nos parametros
	dDtEmis := StoD(SubStr(StrTran(oCT:_InfCte:_IDE:_DhEmi:Text,"-",""),1,8))	`//MAS-EMISSAO PARA EMIS
	If lRet .And. !(dDtEmis >= MV_PAR03 .And. dDtEmis <= MV_PAR04)	//MAS-EMISSAO PARA EMIS
		cMsg := "Data de Emissใo estแ fora do range definido nos parametros!"
		lRet := .F.
	EndIf
	
EndIf

//Tratamento para quando o XML nใo ้ tratado na rotina
If lRet .And. !lNFeFound .And. !lCTeFound
	lRet := .F.
	cMsg := "XML nใo ้ de emissใo NFe/CTe, rotina nใo trata demais XML!"
EndIf

//Trata variavel, pois ้ variavel de retorno
If lRet .And. lCTeFound
	lEhCTe := .T.
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fPutCad  บAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPutCad(oObjXml)

Local oNFe         := Nil
Local cCadCNPJ     := ""
Local cCadIE       := ""
Local cCadFant     := ""
Local cCadNome     := ""
Local cEndCEP      := ""
Local cEndMunCod   := ""
Local cEndMunDesc  := ""
Local cEndPaisCod  := ""
Local cEndPaisDesc := ""
Local cEndFone     := ""
Local cEndLgr      := ""
Local cEndNumero   := ""
Local cEndUF       := ""
Local cEndBairro   := ""

Local lOk          := .T.

//Verifica se existe TAG no objeto
If fChekErro(oObjXml:_NFEPROC:_NFE:_INFNFE)
	oNFe := oObjXml:_NFEPROC:_NFE:_INFNFE
Else
	Return()
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_CNPJ)
	cCadCNPJ := AllTrim(oNFe:_EMIT:_CNPJ:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_IE)
	cCadIE := AllTrim(oNFe:_EMIT:_IE:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_XFANT)
	cCadFant := AllTrim(oNFe:_EMIT:_XFANT:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_XNOME)
	cCadNome := AllTrim(oNFe:_EMIT:_XNOME:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_CEP)
	cEndCEP := AllTrim(oNFe:_EMIT:_ENDEREMIT:_CEP:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_CMUN)
	cEndMunCod := AllTrim(oNFe:_EMIT:_ENDEREMIT:_CMUN:TEXT)
	cEndMunCod := SubStr(cEndMunCod,3,Len(cEndMunCod))
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_XMUN)
	cEndMunDesc := AllTrim(oNFe:_EMIT:_ENDEREMIT:_XMUN:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_CPAIS)
	cEndPaisCod := AllTrim(oNFe:_EMIT:_ENDEREMIT:_CPAIS:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_XPAIS)
	cEndPaisDesc := AllTrim(oNFe:_EMIT:_ENDEREMIT:_XPAIS:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_FONE)
	cEndFone := AllTrim(oNFe:_EMIT:_ENDEREMIT:_FONE:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_XLGR)
	cEndLgr := AllTrim(oNFe:_EMIT:_ENDEREMIT:_XLGR:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_NRO)
	cEndNumero := AllTrim(oNFe:_EMIT:_ENDEREMIT:_NRO:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_UF)
	cEndUF := AllTrim(oNFe:_EMIT:_ENDEREMIT:_UF:TEXT)
EndIf

//Verifica se existe TAG no objeto
If fChekErro(oNFe:_EMIT:_ENDEREMIT:_XBAIRRO)
	cEndBairro := AllTrim(oNFe:_EMIT:_ENDEREMIT:_XBAIRRO:TEXT)
EndIf

//Tratamento da Variavel
If Empty(cCadCNPJ)
	lOk := .F.
Else
	cCadCNPJ := AllTrim(cCadCNPJ)
EndIf

//Verifica se CNPJ ้ valido
If "00000000000" $ cCadCNPJ
	lOk := .F.
EndIf

//Verifica se CNPJ ้ valido
If !CGC(cCadCNPJ,,.F.)
	lOk := .F.
EndIf

//Atualiza็ใo Cadastral
If lOk
	//Pesquisar CNPJ no SA1
	SA1->(DbSetOrder(3))
	If SA1->(DbSeek(xFilial("SA1")+cCadCNPJ))
		RecLock("SA1",.F.)
			SA1->A1_NOME    := IIf(!Empty(SA1->A1_NOME)     ,SA1->A1_NOME    ,cCadNome)
			SA1->A1_NREDUZ  := IIf(!Empty(SA1->A1_NREDUZ)   ,SA1->A1_NREDUZ  ,cCadFant)
			SA1->A1_END     := IIf(!Empty(SA1->A1_END)      ,SA1->A1_END     ,cEndLgr+", "+cEndNumero)
			SA1->A1_EST     := IIf(!Empty(SA1->A1_EST)      ,SA1->A1_EST     ,cEndUF)
			SA1->A1_COD_MUN := IIf(!Empty(SA1->A1_COD_MUN)  ,SA1->A1_COD_MUN ,cEndMunCod)
			SA1->A1_MUN     := IIf(!Empty(SA1->A1_MUN)      ,SA1->A1_MUN     ,cEndMunDesc)
			SA1->A1_BAIRRO  := IIf(!Empty(SA1->A1_BAIRRO)   ,SA1->A1_BAIRRO  ,cEndBairro)
			SA1->A1_CEP     := IIf(!Empty(SA1->A1_CEP)      ,SA1->A1_CEP     ,cEndCEP)
			SA1->A1_TEL     := IIf(!Empty(SA1->A1_TEL)      ,SA1->A1_TEL     ,cEndFone)
			SA1->A1_CODPAIS := IIf(!Empty(SA1->A1_CODPAIS)  ,SA1->A1_CODPAIS ,cEndPaisCod)
		SA1->(MsUnLock())
	EndIf
	
	//Pesquisar CNPJ no SA2
	SA2->(DbSetOrder(3))
	If SA2->(DbSeek(xFilial("SA2")+cCadCNPJ))
		RecLock("SA2",.F.)
			SA2->A2_NOME    := IIf(!Empty(SA2->A2_NOME)     ,SA2->A2_NOME    ,cCadNome)
			SA2->A2_NREDUZ  := IIf(!Empty(SA2->A2_NREDUZ)   ,SA2->A2_NREDUZ  ,cCadFant)
			SA2->A2_END     := IIf(!Empty(SA2->A2_END)      ,SA2->A2_END     ,cEndLgr+", "+cEndNumero)
			SA2->A2_EST     := IIf(!Empty(SA2->A2_EST)      ,SA2->A2_EST     ,cEndUF)
			SA2->A2_COD_MUN := IIf(!Empty(SA2->A2_COD_MUN)  ,SA2->A2_COD_MUN ,cEndMunCod)
			SA2->A2_MUN     := IIf(!Empty(SA2->A2_MUN)      ,SA2->A2_MUN     ,cEndMunDesc)
			SA2->A2_BAIRRO  := IIf(!Empty(SA2->A2_BAIRRO)   ,SA2->A2_BAIRRO  ,cEndBairro)
			SA2->A2_CEP     := IIf(!Empty(SA2->A2_CEP)      ,SA2->A2_CEP     ,cEndCEP)
			SA2->A2_TEL     := IIf(!Empty(SA2->A2_TEL)      ,SA2->A2_TEL     ,cEndFone)
			SA2->A2_CODPAIS := IIf(!Empty(SA2->A2_CODPAIS)  ,SA2->A2_CODPAIS ,cEndPaisCod)
		SA2->(MsUnLock())
	EndIf
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExecPreNFบAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fExecPreCTe(lSchedule,oObjXML)

Local lRet      := .T.
Local cMsg      := ""
Local aCabec116 := {}
Local aItens116 := {}
Local aAux      := {}
Local aAux1     := {}
Local cCodiRem  := ""
Local cLojaRem  := ""
Local cFornCTe  := ""
Local cLojaCTe  := ""
Local cNomeCTe  := ""
Local aAux      := {}
Local aAux1     := {}
Local aDadosCli := {"",""}
Local aDadosFor := {"",""}
Local cDefCPAG	:= "001"
Local cDefTES	:= "019"
Local cTES_CT   := cDefCPAG
Local cCPag_CT  := cDefTES

////VARIAVEIS PARA PARAMBOX
Local cPerg   := "ONFCTEXML"
LOCAL aParamBox := {}
Static aPergRet := {}
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
LOCAL cLoad := "ONFCTEXML_01"
LOCAL lCanSave := .T.
LOCAL lUserSave := .F.
//////FIM DAS VARIAVEIS


Private oXML    := oObjXML:_CTeProc:_CTe

//-- Verifica se o fornecedor do conhecimento esta cadastrado no sistema.
If ValType(XmlChildEx(oXML:_InfCte:_Emit,"_CNPJ")) <> "U"
	cCNPJ_CT := AllTrim(oXML:_InfCte:_Emit:_CNPJ:Text)
Else
	cCNPJ_CT := AllTrim(oXML:_InfCte:_Emit:_CPF:Text)
EndIf

SA2->(dbSetOrder(3))
If lRet .And. !SA2->(dbSeek(xFilial("SA2")+cCNPJ_CT))
	Alert("Fornecedor nใo localizado!")
	lRet := .F.
Else
	cFornCTe := SA2->A2_COD
	cLojaCTe := SA2->A2_LOJA
	cNomeCTe := SA2->A2_NOME
EndIf

If lRet .And. AllTrim(SM0->M0_CGC) != AllTrim(oXML:_InfCte:_Dest:_CNPJ:Text)
	Alert("O Destinatแrio nใo ้ " +alltrim(SM0->M0_NOME)+ " !")
	lRet := .F.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Identifica se a empresa foi remetente das notas fiscais contidas no conhecimento: 			ณ
//ณ 																				 			ณ
//ณ Se sim, significa que as notas contidas no conhecimento sao notas de saida, podendo ser 	ณ
//ณ notas de venda, devolucao de compras ou devolucao de remessa para beneficiamento.     		ณ
//ณ 																				 			ณ
//ณ Se nao, significa que as notas contidas no conhecimento sao notas de entrada, podendo ser	ณ
//ณ notas de compra, devolucao de vendas ou remessa para beneficiamento.     					ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	cCNPJ_CF := AllTrim(oXML:_InfCte:_Rem:_CNPJ:Text) //-- Armazena o CNPJ do remetente das notas contidas no conhecimento
	cTipoFrete := "C"
	//-- Como no XML nao e possivel saber se o destinatario e cliente ou fornecedor
	//-- Validarei os dois casos
	SA1->(dbSetOrder(3))
	If SA1->(dbSeek(xFilial("SA1")+cCNPJ_CF))
		aDadosCli[1] := SA1->A1_COD
		aDadosCli[2] := SA1->A1_LOJA
	Else
		aDadosCli[1] := CriaVar("A1_COD",.F.)
		aDadosCli[2] := CriaVar("A1_LOJA",.F.)
	EndIf
	SA2->(dbSetOrder(3))
	If SA2->(dbSeek(xFilial("SA2")+cCNPJ_CF))
		aDadosFor[1] := SA2->A2_COD
		aDadosFor[2] := SA2->A2_LOJA
	Else
		aDadosFor[1] := CriaVar("A2_COD",.F.)
		aDadosFor[2] := CriaVar("A2_LOJA",.F.)
	EndIf
	
	If Empty(aDadosCli[1]) .And. !Empty(aDadosFor[1])
		cCodiRem := aDadosFor[1]
		cLojaRem := aDadosFor[2]
	ElseIf !Empty(aDadosCli[1]) .And. Empty(aDadosFor[1])
		cCodiRem := aDadosCli[1]
		cLojaRem := aDadosCli[2]
	Else
		Alert("Fornecedor nใo localizado!")
		lRet := .F.
	EndIf
EndIf
lLayout2 := .f.
If lRet
	lRet := .f.
	//-- Separa secao que contem as notas do conhecimento para laco
	If ValType(XmlChildEx(oXML:_InfCte:_Rem,"_INFNF")) != "U"
		aAux :=  If(ValType(oXML:_InfCte:_Rem:_INFNF) == "O",{oXML:_InfCte:_Rem:_INFNF},oXML:_InfCte:_Rem:_INFNF)
		lRet := .T.
		lLayout2 := .f.
	EndIf
	//nova versใo do layout da CT-e
	If ValType(XmlChildEx(oXML:_InfCte:_InfCteNorm:_InfDoc,"_INFNF")) != "U"
		aAux := If(ValType(oXML:_InfCte:_InfCteNorm:_InfDoc) == "O",{oXML:_InfCte:_InfCteNorm:_InfDoc:_INFNF},oXML:_InfCte:_InfCteNorm:_InfDoc:_INFNF)
		lRet := .T.
		lLayout2 := .t.
	EndIf
	
	If ValType(XmlChildEx(oXML:_InfCte:_Rem,"_INFNFE")) != "U"
		aAux1 := If(ValType(oXML:_InfCte:_Rem:_INFNFE) == "O",{oXML:_InfCte:_Rem:_INFNFE},oXML:_InfCte:_Rem:_INFNFE)
		lRet := .T.
	EndIf
	If ValType(XmlChildEx(oXML:_InfCte:_InfCteNorm:_InfDoc,"_INFNFE")) != "U"
		aAux1 := If(ValType(oXML:_InfCte:_InfCteNorm:_InfDoc) == "O",{oXML:_InfCte:_InfCteNorm:_InfDoc:_INFNFE},oXML:_InfCte:_InfCteNorm:_InfDoc:_INFNFE)
		lRet := .T.
	EndIf
EndIf
// Limpa filtro da tabela SF1 para pesquisar pelo fornecedor correto
//marcos rezende
//verificar processamento da rotina quando o xml da CT-e for nova versใo


SF1->(dbClearFilter())
If Len(aAux) > 0		// Quando preenche aAux significa que o XML contem os numeros das notas originais, portanto o emitente do CTe nao trabalha com NF-e
	SF1->(dbSetOrder(1))
	if !lLayout2
		For nX := 1 To Len(aAux)
			cChaveNF :=	Padr(AllTrim(aAux[nX]:_nDoc:Text),TamSX3("F1_DOC")[1]) +;
			Padr(AllTrim(aAux[nX]:_Serie:Text),TamSX3("F1_SERIE")[1])
			//-- Se remetente nao identificado e porque pode ser cliente ou fornecedor
			//-- Dai identifica atraves de seek no SF1
			If Empty(cCodiRem)
				If SF1->(dbSeek(xFilial("SF1")+cChaveNF+aDadosFor[1]+aDadosFor[2])) // Se achar, significa que sao notas de compra
					cCodiRem := aDadosFor[1]
					cLojaRem := aDadosFor[2]
				ElseIf SF1->(dbSeek(xFilial("SF1")+cChaveNF+aDadosCli[1]+aDadosCli[1])) //Se achar, significa que sao notas de devol./beneficiamento
					cCodiRem := aDadosCli[1]
					cLojaRem := aDadosCli[2]
				Else //-- Se nao achou, e porque nota ainda nao estao no sistema: dai nao da pra processar
					lRet := .F.
				EndIf
			ElseIf !SF1->(dbSeek(xFilial("SF1")+cChaveNF+cCodiRem+cLojaRem))
				lRet := .F. //-- Se nao achou, e porque nota ainda nao estao no sistema: dai nao da pra processar
			EndIf
			
			//-- Registra notas que farao parte do conhecimento
			If lRet
				aAdd(aItens116,{{"PRIMARYKEY",SubStr(SF1->&(IndexKey()),3)}})
			Else
				cMsg := "Documento de entrada inexistente na base. Processe o recebimento deste documento de entrada."
				Exit
			EndIf
		Next nX
	else
		For nX := 1 To Len(aAux[1])
			cChaveNF :=	Padr(AllTrim(aAux[1][nX]:_nDoc:Text),TamSX3("F1_DOC")[1]) +;
			Padr(AllTrim(aAux[1][nX]:_Serie:Text),TamSX3("F1_SERIE")[1])
			//-- Se remetente nao identificado e porque pode ser cliente ou fornecedor
			//-- Dai identifica atraves de seek no SF1
			If Empty(cCodiRem)
				If SF1->(dbSeek(xFilial("SF1")+cChaveNF+aDadosFor[1]+aDadosFor[2])) // Se achar, significa que sao notas de compra
					cCodiRem := aDadosFor[1]
					cLojaRem := aDadosFor[2]
				ElseIf SF1->(dbSeek(xFilial("SF1")+cChaveNF+aDadosCli[1]+aDadosCli[1])) //Se achar, significa que sao notas de devol./beneficiamento
					cCodiRem := aDadosCli[1]
					cLojaRem := aDadosCli[2]
				Else //-- Se nao achou, e porque nota ainda nao estao no sistema: dai nao da pra processar
					lRet := .F.
				EndIf
			ElseIf !SF1->(dbSeek(xFilial("SF1")+cChaveNF+cCodiRem+cLojaRem))
				lRet := .F. //-- Se nao achou, e porque nota ainda nao estao no sistema: dai nao da pra processar
			EndIf
			
			//-- Registra notas que farao parte do conhecimento
			If lRet
				aAdd(aItens116,{{"PRIMARYKEY",SubStr(SF1->&(IndexKey()),3)}})
			Else
				cMsg := "Documento de entrada inexistente na base. Processe o recebimento deste documento de entrada."
				Exit
			EndIf
		Next nX
	endif
EndIf

IF Len(aAux1) > 0		// Quando preenche aAux1 significa que o XML contem a chave DANFE das notas originais, portanto o emitente do CTe trabalha com NF-e
	For nX := 1 To Len(aAux1)
		SF1->(dbSetOrder(8))
		cChaveNF :=	Padr(AllTrim(aAux1[nX]:_chave:Text),TamSX3("F1_CHVNFE")[1])
		
		//-- Se remetente nao identificado e porque pode ser cliente ou fornecedor
		//-- Dai identifica atraves de seek no SF1 e SF2
		If Empty(cCodiRem)
			If SF1->(dbSeek(xFilial("SF1")+cChaveNF))
				dbSelectArea("SA2")
				dbSetOrder(1)
				If SA2->(dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)) // Se achar, significa que sao notas de compra
					cCodiRem := aDadosFor[1]
					cLojaRem := aDadosFor[2]
				Else
					dbSelectArea("SA1")
					dbSetOrder(1)
					If SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)) //Se achar, significa que sao notas de devol./beneficiamento
						cCodiRem := aDadosCli[1]
						cLojaRem := aDadosCli[2]
					EndIf
				EndIf
			Else //-- Se nao achou, e porque nota ainda nao estao no sistema: dai nao da pra processar
				lRet := .F.
			EndIf
		ElseIf !SF1->(dbSeek(xFilial("SF1")+cChaveNF))
			lRet := .F. //-- Se nao achou, e porque nota ainda nao estao no sistema: dai nao da pra processar
		EndIf
		
		SF1->(dbSetOrder(1))
		
		//-- Registra notas que farao parte do conhecimento
		If lRet
			aAdd(aItens116,{{"PRIMARYKEY",SubStr(SF1->&(IndexKey()),3)}})
		Else
			cMsg := "Documento de entrada inexistente na base. Processe o recebimento deste documento de entrada."
			Exit
		EndIf
	Next nX
EndIf

If lRet
	
	//Begin Transaction
	
	cDocCTe := AllTrim(oXML:_InfCte:_Ide:_nCt:Text)
	cDocCTe := "000000000"+cDocCTe
	cDocCTe := Right(cDocCTe,TamSx3("F1_DOC")[1])
	//estas perguntas teem como objetivo a altera็ใo a crit้rio do usuแrio de informa็๕es da
	//carta de corre็ใo.
	aParamBox:={}
	aAdd(aParamBox,{1,"TES",space(TamSx3("F4_CODIGO")[1]),"","","SF4","",0,.F.}) // Tipo caractere
	aAdd(aParamBox,{1,"Cond.Pagto",space(TamSx3("F1_COND")[1]),"","","SE4","",0,.F.}) // Tipo caractere
	//	aAdd(aParamBox,{2,"Produto",TamSx3("B1_CODIGO")[1],"","","SB1","",0,.F.}) // Tipo caractere
	aAdd(aParamBox,{9,"CT-e nro:"+cDocCTe,150,7,.T.})
	nPosX := 0
	nPosY := 0
	ParamBox(aParamBox, "CT-e Parametriza็๕es", @aPergRet, bOk, aButtons, lCentered, nPosx,nPosy, , cLoad, lCanSave, lUserSave)
	
	//confirmando ou cancelando deve definir os valores para variaveis
	//se retornar branco, define valores padrใo.
	if empty(aPergRet[1])
		aPergRet[1] := cDefTES
	ENDIF
	if empty(aPergRet[2])
		aPergRet[2] := cDefCPAG
	ENDIF
	
	cTES_CT		:= aPergRet[1]
	cCPag_CT	:= aPergRet[2]
	
	aCabec116 := {}
	aAdd(aCabec116,{"",dDataBase-90})       												// Data inicial para filtro das notas
	aAdd(aCabec116,{"",dDataBase})          												// Data final para filtro das notas
	aAdd(aCabec116,{"",2})                  												// 2-Inclusao ; 1=Exclusao
	aAdd(aCabec116,{"",cCodiRem})            												// Rementente das notas contidas no conhecimento
	aAdd(aCabec116,{"",cLojaRem})             												// Loja do remetente das notas contidas no conhecimento
	aAdd(aCabec116,{"",1})                  												// Tipo das notas contidas no conhecimento: 1=Normal ; 2=Devol/Benef
	aAdd(aCabec116,{"",1})                  												// 1=Aglutina itens ; 2=Nao aglutina itens
	aAdd(aCabec116,{"F1_EST",""})  		  													// UF das notas contidas no conhecimento
	aAdd(aCabec116,{"",Val(oXML:_InfCte:_VPrest:_VRec:Text)}) 								// Valor do conhecimento
	aAdd(aCabec116,{"F1_FORMUL",1})															// Formulario proprio: 1=Nao ; 2=Sim
	aAdd(aCabec116,{"F1_DOC",cDocCTe})														// Numero da nota de conhecimento
	aAdd(aCabec116,{"F1_SERIE",PadR(oXML:_InfCte:_Ide:_Serie:Text,TamSx3("F1_SERIE")[1])})	// Serie da nota de conhecimento
	aAdd(aCabec116,{"F1_FORNECE",cFornCTe}) 												// Fornecedor da nota de conhecimento
	aAdd(aCabec116,{"F1_LOJA",cLojaCTe})													// Loja do fornecedor da nota de conhecimento
	aAdd(aCabec116,{"",cTES_CT})															// TES a ser utilizada nos itens do conhecimento
	aAdd(aCabec116,{"F1_BASERET",Val(oXML:_InfCte:_imp:_icms:_ICMS00:_vBC:Text)})			// Valor da base de calculo do ICMS retido
	aAdd(aCabec116,{"F1_ICMRET",Val(oXML:_InfCte:_imp:_icms:_ICMS00:_vICMS:Text)})			// Valor do ICMS retido
	aAdd(aCabec116,{"F1_COND",cCPag_CT})											   		// Condicao de pagamento
	aAdd(aCabec116,{"F1_EMISSAO",SToD(Substr(StrTran(oXML:_InfCte:_Ide:_dhEmi:Text,"-",""),1,8))})	// Data de emissao do conhecimento
	aAdd(aCabec116,{"F1_ESPECIE","CTE"})															// Especie do documento
	aAdd(aCabec116,{"F1_CHVNFE",oObjXML:_CTeProc:_ProtCTe:_InfProt:_ChCTe:TEXT})					// Chave do documento
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Executa a ExecAuto do MATA116 para gravar os itens com o valor de frete rateado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	//lAutoErrNoFile := .T.
	MsExecAuto({|x,y| MATA116(x,y)},aClone(aCabec116),aClone(aItens116))
	//esta apresentando erro ap๓s valida็ใo do campo
	If lMsErroAuto
		MostraErro()
		lRet := .F.
		//-- Desfaz transacao
		DisarmTran()
	Else
		cMsgErro := Alltrim(aCabec116[11,2])+' / '+Alltrim(aCabec116[12,2])+" - CTe Gerado Com Sucesso!"
		fErroHTML("INTEGRACAO XML x CTe", "[Workflow Protheus] CTe Gerado Com Sucesso ["+Alltrim(aCabec116[11,2])+' / '+Alltrim(aCabec116[12,2])+"]", cMsgErro)
		MsgAlert(cMsgErro)
	endif
	
	//End Transaction
	
	//		localiza a nota fiscal e verifica se for eletronica grava novamente a chave caso nใo tenha sido gravada pelo Execauto
	//altera็ใo realizada por marcos rezende para contornar erro no execauto que nใo consegue gravar a chave da nota fiscal.
	SF1->(dbClearFilter())
	SF1->(dbsetorder(1))
	cSerCTE := PadR(oXML:_InfCte:_Ide:_Serie:Text,TamSx3("F1_SERIE")[1])
	cCHVCTE := oObjXML:_CTeProc:_ProtCTe:_InfProt:_ChCTe:TEXT
	if sf1->(dbseek(xfilial("SF1")+cDocCTe+cSerCTE+cFornCTe+cLojaCTe+"C",.t.))
		
		if !empty(oObjXML:_CTeProc:_ProtCTe:_InfProt:_ChCTe:TEXT) .and. empty(sf1->f1_chvnfe)
			reclock("SF1",.f.)
			sf1->f1_chvnfe := cCHVCTE
			sf1->(msunlock())
		endif
	endif
	
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExecPreNFบAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fExecPreNF(lSchedule,oObjXml)

Local cTipoNF      := ""
Private oNfe       := oObjXml
Private oNF        := IIf(Type("oNFe:_NfeProc")<>"U",oNFe:_NFeProc:_NFe,oNFe:_NFe)
Private oEmitente  := oNF:_InfNfe:_Emit
Private oIdent     := oNF:_InfNfe:_IDE
Private oDestino   := oNF:_InfNfe:_Dest
Private oTotal     := oNF:_InfNfe:_Total
Private oTransp    := oNF:_InfNfe:_Transp
Private oDet       := IIf(Type("oNF:_InfNfe:_Det")=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
Private cNumNF     := StrZero(Val(Alltrim(oIdent:_nNF:TEXT)),9)
Private cSerNF     := IIf(AllTrim(oIdent:_serie:TEXT)=="0",Space(3),Padr(AllTrim(oIdent:_serie:TEXT),3))
Private cChavNFe   := oNFe:_NFeProc:_ProtNfe:_InfProt:_ChNfe:TEXT
Private cTipoNF    := ""
Private cEdit1     := ""
Private _DESCdigit := ""
Private _NCMdigit  := ""
Private _oDlg
//Private dEmissNF   := StoD(StrTran(oIdent:_dEmi:TEXT,"-",""))

cVersao		:= oNF:_InfNfe:_VERSAO:TEXT
if alltrim(cVersao) <> "2.00"
	dEmissNF    := StoD(StrTran(Substr(oIdent:_dhEmi:TEXT,1,10),"-",""))
else
	dEmissNF    := StoD(StrTran(oIdent:_dEmi:TEXT,"-",""))
endif

//Verifica o tipo da nota fiscal
For nX :=1 To Len(oDet)
	//Beneficiamento
	If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ alltrim(GetMv("OP_XMLBEN"))	//"901/920"
		cTipoNF := "B"
		nX := Len(oDet)
	EndIf
	
	//Devolu็ใo
	If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ alltrim(GetMv("OP_XMLDEV"))	//"201" //"902/903"
		cTipoNF := "D"
		nX := Len(oDet)
	EndIf
Next nX

//Normal
If Empty(cTipoNF) .And. !Empty(oIdent:_finNFe:Text)
	cTipoNF := "N"
ElseIf Empty(cTipoNF)
	cErroMsg := "[SF1] O tipo da NFe no XML Nใo Identificado - Verifique NF/Serie ("+cNumNF+"/"+AllTrim(cSerNF)+")"
	If lSchedule
		fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", cErroMsg)
	Else
		MsgAlert(cErroMsg)
	EndIf
	Return(.F.)
EndIf

If cTipoNF == "N"
	SA2->(dbSetOrder(3))
	If SA2->(!dbSeek(xFilial("SA2")+AllTrim(oEmitente:_CNPJ:TEXT)))
		cErroMsg := "[SA2] CNPJ Origem Nใo Localizado - Verifique " + AllTrim(oEmitente:_CNPJ:TEXT)
		If lSchedule
			fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", cErroMsg)
		Else
			MsgAlert(cErroMsg)
		EndIf
		Return(.F.)
	Endif
	cCodCliFor := SA2->A2_COD
	cLojCliFor := SA2->A2_LOJA
	cCndCliFor := SA2->A2_COND
Else
	SA1->(dbSetOrder(3))
	If SA1->(!dbSeek(xFilial("SA1")+AllTrim(oEmitente:_CNPJ:TEXT)))
		cErroMsg := "[SA1] CNPJ Origem Nใo Localizado - Verifique " + AllTrim(oEmitente:_CNPJ:TEXT)
		If lSchedule
			fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", cErroMsg)
		Else
			MsgAlert(cErroMsg)
		EndIf
		Return(.F.)
	Endif
	cCodCliFor := SA1->A1_COD
	cLojCliFor := SA1->A1_LOJA
	cCndCliFor := SA1->A1_COND
EndIf

//Nota Fiscal jแ existe na base ?
SF1->(dbSetOrder(1))
If SF1->(DbSeek(XFilial("SF1") + cNumNF + cSerNF + cCodCliFor + cLojCliFor))
	IF cTipoNF == "N"
		cErroMsg := "Nota No.: "+cNumNF+"/"+cSerNF+" do Fornec. "+cCodCliFor+"/"+cLojCliFor+" Ja Existe. A Importacao sera interrompida!"
	Else
		cErroMsg := "Nota No.: "+cNumNF+"/"+cSerNF+" do Cliente "+cCodCliFor+"/"+cLojCliFor+" Ja Existe. A Importacao sera interrompida!"
	Endif
	If lSchedule
		fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", cErroMsg)
	Else
		MsgAlert(cErroMsg)
	EndIf
	Return(.F.)
EndIf

//Reseta as variaveis
aCabec := {}
aItens := {}

aadd(aCabec,{"F1_TIPO"    ,cTipoNF                                          ,Nil,Nil})
aadd(aCabec,{"F1_FORMUL"  ,"N"                                              ,Nil,Nil})
aadd(aCabec,{"F1_DOC"     ,cNumNF                                           ,Nil,Nil})
aadd(aCabec,{"F1_SERIE"   ,cSerNF                                           ,Nil,Nil})
aadd(aCabec,{"F1_COND"    ,IIf(Empty(cCndCliFor),"001",cCndCliFor)          ,Nil,Nil})
aadd(aCabec,{"F1_EMISSAO" ,dEmissNF                                         ,Nil,Nil})
aadd(aCabec,{"F1_FORNECE" ,cCodCliFor                                       ,Nil,Nil})
aadd(aCabec,{"F1_LOJA"    ,cLojCliFor                                       ,Nil,Nil})
aadd(aCabec,{"F1_ESPECIE" ,"SPED"                                           ,Nil,Nil})
aadd(aCabec,{"F1_CHVNFE"  ,cChavNFe                                         ,Nil,Nil})

// Primeiro Processamento
// Busca de Informa็๕es para Pedidos de Compras
cProds := ""

For nX := 1 To Len(oDet)
	aLinha   := {}
	cEdit1 := Space(15)
	
	cProduto := Padr(AllTrim(oDet[nX]:_Prod:_cProd:TEXT),15)
	xProduto := cProduto
	cDescPro := AllTrim(oDet[nX]:_Prod:_xProd:TEXT)
	cNCM     := AllTrim(oDet[nX]:_Prod:_NCM:TEXT)
	Chkproc  := .F.
	lVldProd := .T.
	lTelaProd:= .F.
	lProdGen := .F. //produto gen้rico?
	cMsgVld  := ""
	
	If cTipoNF == "N"
		//Valida se produto existe na tabela SA5
		If lVldProd
			SA5->(dbSetOrder(14))
			If SA5->(!dbSeek(xFilial("SA5") + cCodCliFor + cLojCliFor + cProduto))
				lVldProd := .F.
				cMsgVld  := "O produto ("+cProduto+") nใo estแ relacionado na rotina de produto x fornecedor!"
			EndIf
		EndIf
		
		//Valida se produto existe na tabela SB1
		If lVldProd
			SB1->(dbSetOrder(1))
			If SB1->(!dbSeek(xFilial("SB1")+SA5->A5_PRODUTO))
				lVldProd := .F.
				cMsgVld  := "O produto ("+SA5->A5_PRODUTO+") informado na rotina de produto x fornecedor nใo existe no cadastro de produtos!"
			EndIf
		EndIf
		
		If lVldProd
			if sb1->(fieldpos("B1_XXMLGEN")>0) //SE CAMPO DE PROD GENERICO DE XML ESTIVER CRIADO NA BASE
				IF SB1->B1_XXMLGEN ='S' //SE O CAMPO DE PRODUTO GENERICO ESTIVER COMO SIM, DETERMINA AO SISTEMA QUE SOLICITE PRODUTO PARA AMARRAวรO
					lTelaProd := .T.
					lProdGen  := .t.
				endif
			endif
		endif
		
		//Valida se produto na tabela Sb1 estแ bloqueado
		If lVldProd
			If SB1->B1_MSBLQL == "1"
				lVldProd := .F.
				cMsgVld  := "O produto ("+SA5->A5_PRODUTO+") estแ bloqueado no cadastro de produtos!"
			EndIf
		EndIf
		
		//Pergunta se deseja relacionar produto na tela criada abaixo
		If !lVldProd
			If lSchedule
				fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", cMsgVld)
				Return(.F.)
			Else
				If SimNao(cMsgVld+Chr(13)+Chr(10)+"Deseja selecionar novo codigo de produto?") != "S"
					Return(.F.)
				Else
					lTelaProd := .T.
				EndIf
			EndIf
		EndIf
		
		If lTelaProd
			DEFINE MSDIALOG _oDlg TITLE "Produto de Substituicao" FROM C(177),C(192) TO C(320),C(659) PIXEL
			
			// Cria as Groups do Sistema
			@ C(002),C(003) TO C(071),C(186) LABEL "NF: "+cNumNF+"/"+cSerNF+" - Selecione Produto Equivalente" PIXEL OF _oDlg
			
			// Cria Componentes Padroes do Sistema
			@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM             Size C(150),C(008) COLOR CLR_HRED      PIXEL OF _oDlg
			@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT         Size C(150),C(012) COLOR CLR_HRED      PIXEL OF _oDlg
			@ C(034),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(fValProd())   Size C(060),C(009)                     PIXEL OF _oDlg
			@ C(044),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE     PIXEL OF _oDlg
			@ C(052),C(027) Say "Descricao: "+_DESCdigit                         Size C(150),C(008) COLOR CLR_HBLUE     PIXEL OF _oDlg
			
			// Cria Botoes Padroes do Sistema
			@ C(004),C(194) Button "Processar"                                   Size C(037),C(012) Action(fTroca())    PIXEL OF _oDlg
			@ C(025),C(194) Button "Cancelar"                                    Size C(037),C(012) Action(_oDlg:End()) PIXEL OF _oDlg
			
			// Define Propriedades Iniciais dos Componentes
			oEdit1:SetFocus()
			
			ACTIVATE MSDIALOG _oDlg CENTERED
			
			If !Chkproc
				MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
				Return(.F.)
			Else
				if ! lProdGen //somente grava amarra็ใo se nใo for produto gen้rico
					SA5->(dbSetOrder(1))
					If !SA5->(dbSeek(xFilial("SA5")+ cCodCliFor + cLojCliFor + SB1->B1_COD))
						Reclock("SA5",.T.)
							SA5->A5_FILIAL 	:= xFilial("SA5")
							SA5->A5_FORNECE := SA2->A2_COD
							SA5->A5_LOJA 	:= SA2->A2_LOJA
							SA5->A5_NOMEFOR := SA2->A2_NOME
							SA5->A5_PRODUTO := SB1->B1_COD
							SA5->A5_NOMPROD := cDescPro
							SA5->A5_CODPRF  := xProduto
						SA5->(MsUnlock())
					Endif
				endif
			EndIf
		EndIf
		If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000'
			//RecLock("SB1",.F.)
			//Replace SB1->B1_POSIPI with cNCM
			//SB1->(MSUnLock())
		Endif
	Else
		//Valida se produto existe na tabela SA7
		If lVldProd
			SA7->(dbSetOrder(3))
			If SA7->(!dbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + cProduto))
				lVldProd := .F.
				cMsgVld  := "O produto ("+cProduto+") nใo estแ relacionado na rotina de produto x cliente!"
			EndIf
		EndIf
		
		//Valida se produto existe na tabela SA1
		If lVldProd
			SB1->(dbSetOrder(1))
			If SB1->(!dbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
				lVldProd := .F.
				cMsgVld  := "O produto ("+SA7->A7_PRODUTO+") informado na rotina de produto x cliente nใo existe no cadastro de produtos!"
			EndIf
		EndIf
		
		//Valida se produto na tabela SA1 estแ bloqueado
		If lVldProd
			If SB1->B1_MSBLQL == "1"
				lVldProd := .F.
				cMsgVld  := "O produto ("+SA7->A7_PRODUTO+") estแ bloqueado no cadastro de produtos!"
			EndIf
		EndIf
		
		If lVldProd
			if sb1->(fieldpos("B1_XXMLGEN")>0) //SE CAMPO DE PROD GENERICO DE XML ESTIVER CRIADO NA BASE
				IF SB1->B1_XXMLGEN ='S' //SE O CAMPO DE PRODUTO GENERICO ESTIVER COMO SIM, DETERMINA AO SISTEMA QUE SOLICITE PRODUTO PARA AMARRAวรO
					lTelaProd := .T.
					lProdGen  := .t.
				endif
			endif
		endif
		//Pergunta se deseja relacionar produto na tela criada abaixo
		If !lVldProd
			If lSchedule
				fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", cMsgVld)
				Return(.F.)
			Else
				If SimNao(cMsgVld+Chr(13)+Chr(10)+"Deseja selecionar novo codigo de produto?") != "S"
					Return(.F.)
				Else
					lTelaProd := .T.
				EndIf
			EndIf
		EndIf
		
		If lTelaProd
			DEFINE MSDIALOG _oDlg TITLE "Produto de Substituicao" FROM C(177),C(192) TO C(320),C(659) PIXEL
			
			// Cria as Groups do Sistema
			@ C(002),C(003) TO C(071),C(186) LABEL "NF: "+cNumNF+"/"+cSerNF+" - Selecione Produto Equivalente" PIXEL OF _oDlg
			
			// Cria Componentes Padroes do Sistema
			@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM             Size C(150),C(008) COLOR CLR_HRED      PIXEL OF _oDlg
			@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT         Size C(150),C(008) COLOR CLR_HRED      PIXEL OF _oDlg
			@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(fValProd())   Size C(060),C(009)                     PIXEL OF _oDlg
			@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE     PIXEL OF _oDlg
			@ C(048),C(027) Say "Descricao: "+_DESCdigit                         Size C(150),C(008) COLOR CLR_HBLUE     PIXEL OF _oDlg
			
			// Cria Botoes Padroes do Sistema
			@ C(004),C(194) Button "Processar"                                   Size C(037),C(012) Action(fTroca())    PIXEL OF _oDlg
			@ C(025),C(194) Button "Cancelar"                                    Size C(037),C(012) Action(_oDlg:End()) PIXEL OF _oDlg
			
			// Define Propriedades Iniciais dos Componentes
			oEdit1:SetFocus()
			
			ACTIVATE MSDIALOG _oDlg CENTERED
			
			If !Chkproc
				MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
				Return(.F.)
			Else
				SA7->(dbSetOrder(1))  //A7_FILIAL,A7_CLIENTE,A7_LOJA,A7_PRODUTO
				SA7->(!dbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + SB1->B1_COD))      
				if ! lProdGen //somente grava amarra็ใo se nใo for produto gen้rico
					SA7->(dbSetOrder(1))
					If SA7->(!dbSeek(xFilial("SA7") + cCodCliFor + cLojCliFor + SB1->B1_COD))
						If AllTrim(SA7->A7_CODCLI) != AllTrim(xProduto)
							RecLock("SA7",.T.)
						Else
							RecLock("SA7",.F.)
						EndIf
					Else
						Reclock("SA7",.T.)
					Endif
					
					SA7->A7_FILIAL := xFilial("SA7")
					SA7->A7_CLIENTE := SA1->A1_COD
					SA7->A7_LOJA 	:= SA1->A1_LOJA
					SA7->A7_PRODUTO := SB1->B1_COD
					SA7->A7_DESCCLI := cDescPro
					SA7->A7_CODCLI  := xProduto
					SA7->(MsUnlock())
				endif
			EndIf
		EndIf
		If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000'
			//RecLock("SB1",.F.)
			//Replace SB1->B1_POSIPI with cNCM
			//SB1->(MSUnLock())
		Endif
	Endif
	cNCM     := AllTrim(oDet[nX]:_Prod:_NCM:TEXT)
	Chkproc  := .F.
	aadd(aLinha,{"D1_COD",SB1->B1_COD,Nil,Nil})
	If Val(oDet[nX]:_Prod:_qTrib:TEXT) != 0
		aadd(aLinha,{"D1_QUANT",Val(oDet[nX]:_Prod:_qTrib:TEXT),Nil,Nil})
		aadd(aLinha,{"D1_VUNIT",Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qTrib:TEXT),5),Nil,Nil})
	Else                            '
		aadd(aLinha,{"D1_QUANT",Val(oDet[nX]:_Prod:_qCom:TEXT),Nil,Nil})
		aadd(aLinha,{"D1_VUNIT",Round(Val(oDet[nX]:_Prod:_vProd:TEXT)/Val(oDet[nX]:_Prod:_qCom:TEXT),5),Nil,Nil})
	Endif
	aadd(aLinha,{"D1_TOTAL",Val(oDet[nX]:_Prod:_vProd:TEXT),Nil,Nil})
	If Type("oDet[nX]:_Prod:_vDesc")<> "U"
		aadd(aLinha,{"D1_VALDESC",Val(oDet[nX]:_Prod:_vDesc:TEXT),Nil,Nil})
	Endif
	Do Case
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS00")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS00
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS10")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS10
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS20")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS20
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS30")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS30
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS40")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS40
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS51")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS51
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS60")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS60
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS70")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS70
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS90")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS90
	EndCase
	If Type("oICM") <> "U"
		CST_Aux := Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT)
	Else
		CST_Aux := ""
	EndIf
	aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})
	cAdic   := IIf(Type("oDet[nX]:_InfAdProd:TEXT") != "U",oDet[nX]:_InfAdProd:TEXT,"")
	cLote   := ""
	dValid  := ""
	cOp     := ""
	
	// Pega Lote
	If At('Lote:',cAdic) > 0
		nPosLote := At('Lote:',cAdic)+Len('Lote:')
		For nC := nPosLote To Len(cAdic)
			cLote += SubStr(cAdic,nC,1)
			
			If SubStr(cAdic,nC,1)$' /'
				nC := Len(cAdic) + 10
			Endif
		Next
	Endif
	
	// Pega Validade
	If At('dv:',cAdic) > 0
		nPosValid := At('dv:',cAdic)+Len('dv:')
		For nC := nPosValid To Len(cAdic)
			If SubStr(cAdic,nC,1)$'0123456789.'
				dValid += SubStr(cAdic,nC,1)
			Endif
			If SubStr(cAdic,nC,1)$' /'
				nC := Len(cAdic) + 10
			Endif
		Next
	Endif
	dValid := CtoD(dValid)
	
	aadd(aLinha,{"D1_LOTECTL",cLote,Nil,Nil})
	aadd(aLinha,{"D1_DTVALID",dValid,Nil,Nil})
	
	aadd(aItens,aLinha)
	
	//SB1->(dbSetOrder(1))
	cProds += AllTrim(SB1->B1_COD)+'/'
	
Next nX

// Retira a Ultima "/" da Variavel cProds
//marcos rezende
// identificado que esta variแvel nใo ้ utilizada
cProds := Left(cProds,Len(cProds)-1)
///desativado

//Executa rotina de inclusใo Pre-Nota
If Len(aItens) > 0
	lRetFim     := .F.
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	ROLLBACKSXE()
	MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)
	
	If lMsErroAuto
		lRetFim := .F.
		
		cMsgErro := Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - Erro na execu็ใo do MsExecAuto para gera็ใo da Pre-Nota."
		fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-Nota", cMsgErro)
		
		If !lSchedule
			MsgAlert(cMsgErro)
		EndIf
		
		MostraErro()
	Else
		lRetFim := .T.
		ConfirmSX8()
		
		cMsgErro := Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - Pr้ Nota Gerada Com Sucesso!"
		fErroHTML("INTEGRACAO XML x PRE-NOTA", "[Workflow Protheus] Pr้ Nota Gerada Com Sucesso ["+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+"]", cMsgErro)
		If !lSchedule
			MsgAlert(cMsgErro)
			//abre tela de classifica็ใo da nota fiscal logo ap๓s a inclusใo da pre nota
			u_fCLNFx()
			
		EndIf
	EndIf
Endif

Return(lRetFim)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfReturnPreบAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fReturnPre(lOk,aRetArqs,oObjXml)

Local cLocalXml := aRetArqs[1]
Local cNomelXml := aRetArqs[2]
Local cPerg     := "XMLIMP"
Local cSubPasta := ""
Local oNfe      := oObjXml
Local oNF     
Local oDet    
Local oIdent  
Local cTipoNF   := ""
Local lATFixo
Local lTag :=.t.
Local 	cDirProc := '\data\impxml\processado\'  
Local 	cDirPend := '\data\impxml\pendente\'
Local 	cDirRecu := '\data\impxml\recusado\'

lTag := IIf(lTag,fChekErro(oNFe:_NFEPROC),.F.)
if ltag
	oNF       := IIf(ValType(oNFe:_NfeProc)<>"U",oNFe:_NFeProc:_NFe,oNFe:_NFe)
	oDet      := IIf(ValType(oNF:_InfNfe:_Det)=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
	oIdent    := oNF:_InfNfe:_IDE
	
	Private cNumNF     := StrZero(Val(Alltrim(oIdent:_nNF:TEXT)),9)
	Pergunte(cPerg,.F.)
	lATFixo := .f.
	
	
	//Verifica o tipo da nota fiscal
	For nX :=1 To Len(oDet)
		//Beneficiamento
		If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ alltrim(GetMv("OP_XMLBEN"))	//"901/920"
			cTipoNF := "B"
			nX := Len(oDet)
		EndIf
		If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ "551/406"
			lATFixo := .t.
		EndIf
		
		//Devolu็ใo
		If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ alltrim(GetMv("OP_XMLDEV"))	//"201" //"902/903"
			cTipoNF := "D"
			nX := Len(oDet)
		EndIf
	Next nX
	
	//Normal
	If Empty(cTipoNF) .And. !Empty(oIdent:_finNFe:Text)
		cTipoNF := "N"
	ElseIf Empty(cTipoNF)
		cTipoNF := ""
	EndIf
endif

//Se OK, mover para Processados
//Caso contrario, mover para recusados
cFile := Upper(cLocalXml+cNomelXml)

cAno  := StrZero(Year(dDataBase),4)
cMes  := StrZero(Month(dDataBase),2)

If lOk
	///altera็ใo realizada por Marcos Rezende em 02/06/2014
	//para realizar a separa็ใo das notas fiscais que sใo destinadas a ativo imobilizado
	cQryATF :=" "
	cQryATF +=" SELECT DISTINCT D1_CF FROM "+retsqlname("SD1")
	cQryATF +=" WHERE SD1010.D_E_L_E_T_=' ' "
	cQryATF +=" AND SUBSTRING(D1_CF,2,3) IN('551','406') "
	cQryATF +=" AND D1_DOC='"+SF1->F1_DOC+"' "
	cQryATF +=" AND D1_SERIE='"+SF1->F1_SERIE+"' "
	cQryATF +=" AND D1_FORNECE='"+SF1->F1_FORNECE+"' "
	cQryATF +=" AND D1_LOJA='"+SF1->F1_LOJA+"' "
	//cQryAtf +=" AND D1_DTDIGIT='"+SF1->F1_DOC+"' "
	if select("QRYATF")>0
		QRYATF->(dbclosearea())
	endif
	tcquery cQryAtf new ALIAS "QRYATF"
	if QRYATF->(!EOF()) //้ nota de ativo
		lATFixo := .t.
	endif
	//Verifica o tipo da nota fiscal
	//If AllTrim(oObjXml:_NFeProc:_NFe:_InfNfe:_IDE:_finNFe:Text) == "1"
	/*
	If cTipoNF == "N"
	cSubPasta := "NORMAL\"
	//ElseIf AllTrim(oObjXml:_NFeProc:_NFe:_InfNfe:_IDE:_finNFe:Text) == "2"
	ElseIf cTipoNF == "D"
	cSubPasta := "DEVOLUCAO\"
	//ElseIf !Empty(oObjXml:_NFeProc:_NFe:_InfNfe:_IDE:_finNFe:Text)
	ElseIf cTipoNF == "B"
	cSubPasta := "BENEFICIAMENTO\"
	EndIf
	*/
	if lATFixo
		cSubPasta := "ATIVOFIXO\"
	endif       
	cDirDest := Upper(AllTrim(cDirProc)+cSubPasta+cAno+"\"+cMes+"\")
	xFile := StrTran(Upper(cFile),Upper(AllTrim(cDirPend)),cDirDest)
	
Else
	
	cDirDest := Upper(AllTrim(cDirRecu)+cAno+"\"+cMes+"\")
	xFile := StrTran(Upper(cFile),Upper(AllTrim(cDirPend)),cDirDest)
	
EndIf

//Caso nao exista, cria o diretorio no servidor
MontaDir(cDirDest)

If !File(xFile)
	Copy File &cFile To &xFile
EndIf

lDelOk := .F.
If !File(xFile)
	lDelOk := .T. //nใo conseguiu copiar arquivo
	alert('Nใo foi posssivel copiar o arquivo: '+cFile+chr(13)+"para "+xFile)
endif

While !lDelOk
	fErase(cFile)
	lDelOk := !File(cFile)
	If !lDelOk
		Alert("O XML estแ aberto, feche o mesmo para que ele seja movido de pasta!")
	EndIf
End

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaSXB  บAutor ณ Felipe A. Melo     บ Data ณ  23/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSXB()

Local aSXB   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0

aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ", "XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}

aAdd(aSXB,{"PASTA","1","01","RE","Selecione a pasta","Selecione a pasta","Selecione a pasta","SX5"})
aAdd(aSXB,{"PASTA","2","01","01","","","","U_fDirXml()"  } )
aAdd(aSXB,{"PASTA","5","01","  ","","","","U_fDirXml(1)" } )

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !dbSeek( Padr(aSXB[i,1],Len(SXB->XB_ALIAS)) + aSXB[i,2] + aSXB[i,3] + aSXB[i,4] )
			
			RecLock("SXB",.T.)
			
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
			
			SXB->(dbCommit())
			SXB->(MsUnLock())
		EndIf
	EndIf
Next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCriaSX1  บAutor ณ Felipe A. Melo     บ Data ณ  23/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fCriaSX1(cPerg)

Local aPergs := {}

aAdd(aPergs,{"Do CNPJ?"              ,"Do CNPJ?"              ,"Do CNPJ?"              ,"mv_ch1","C",14,00,00	,"G","","mv_par01",""      ,""      ,""      ,"","",""         ,""         ,""         ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","","",""})
aAdd(aPergs,{"At้ CNPJ?"             ,"At้ CNPJ?"             ,"At้ CNPJ?"             ,"mv_ch2","C",14,00,00	,"G","","mv_par02",""      ,""      ,""      ,"","",""         ,""         ,""         ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","","",""})
aAdd(aPergs,{"Da Data Emissใo?"      ,"Da Data Emissใo?"      ,"Da Data Emissใo?"      ,"mv_ch3","D",08,00,00	,"G","","mv_par03",""      ,""      ,""      ,"","",""         ,""         ,""         ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","","",""})
aAdd(aPergs,{"At้ Data Emissใo?"     ,"At้ Data Emissใo?"     ,"At้ Data Emissใo?"     ,"mv_ch4","D",08,00,00	,"G","","mv_par04",""      ,""      ,""      ,"","",""         ,""         ,""         ,"","",""              ,""              ,""              ,"","",""     ,""     ,""     ,"","","","","","","",""})
aAdd(aPergs,{"Ler Qual XML"          ,"Ler Qual XML"          ,"Ler Qual XML"          ,"mv_ch5","N",01,00,01	,"C","","mv_par05","Normal","Normal","Normal","","","Devolu็ใo","Devolu็ใo","Devolu็ใo","","","Beneficiamento","Beneficiamento","Beneficiamento","","","Todos","Todos","Todos","","","","","","","",""})

AjustaSx1(cPerg,aPergs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDirXml   บAutor ณ Felipe A. Melo     บ Data ณ  23/05/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function fDirXml(nOper)

Local mvRet		:= Alltrim(ReadVar())
Local cPath 	:= ""

Default nOper   := 0

If nOper == 0
	cPath  := cGetFile("","Selecionar diret๓rio:",1,cPath,.F.,GETF_RETDIRECTORY )
	cPath  := OemToAnsi(cPath)
	cPath  := AllTrim(cPath)
	cPath  := Padr(cPath,90)
	&mvRet := cPath
Else
	cPath  := &mvRet
	cPath  := OemToAnsi(cPath)
	cPath  := AllTrim(cPath)
	cPath  := Padr(cPath,90)
EndIf

Return(cPath)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fValProd  บAutor ณ Felipe A. Melo     บ Data ณ  27/08/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValProd()

Local lOk  := .T.
Local lRet := .F.

SB1->(dbSetOrder(1))
If lOk .And. SB1->(!dbSeek(xFilial("SB1")+AllTrim(cEdit1)))
	MsgAlert("Produto Cod.: "+cEdit1+" Nao Encontrado. Informe um produto valido!")
	lOk := .F.
EndIf

If lOk .And. SB1->B1_MSBLQL == "1"
	MsgAlert("Produto Cod.: "+cEdit1+" Bloqueado. Informe um produto valido!")
	lOk := .F.
EndIf

If lOk
	lRet       := .T.
	_DESCdigit := SB1->B1_DESC
	_NCMdigit  := SB1->B1_POSIPI
Else
	lRet       := .F.
	_DESCdigit := ""
	_NCMdigit  := ""
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fTroca    บAutor ณ Felipe A. Melo     บ Data ณ  27/08/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fTroca()

Local lOk:= .T.
cProduto := AllTrim(cEdit1)

SB1->(dbSetOrder(1))
If lOk .And. SB1->(!dbSeek(xFilial("SB1")+cProduto))
	MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. Informe um produto valido!")
	lOk := .F.
EndIf

If lOk .And. SB1->B1_MSBLQL == "1"
	MsgAlert("Produto Cod.: "+cProduto+" Bloqueado. Informe um produto valido!")
	lOk := .F.
EndIf

If lOk .And. Empty(SB1->B1_POSIPI) .And. !Empty(cNCM) .And. cNCM != '00000000'
	//RecLock("SB1",.F.)
	//Replace SB1->B1_POSIPI with cNCM
	//SB1->(MSUnLock())
Endif

If lOk
	Chkproc  := .T.
	_oDlg:End()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fErroHTML บAutor ณ Felipe A. Melo     บ Data ณ  03/09/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fErroHTML(cTitulo, cAssunto, cMsg)

// DESABILITADOPOR MARCO AURELIO -- EMERGENCIAL
/*
Private oHtml
Private oProcess

oProcess:=TWFProcess():New("00001",OemToAnsi(cTitulo))
oProcess:NewTask("000001","\workflow\html\aviso_prenota.htm")
oHtml:=oProcess:oHtml

oProcess:ClientName( Subs(cUsuario,7,15) )
oProcess:cTo      := supergetmv("MV_XMLMAIL")
//oProcess:cTo      += AllTrim(UsrRetMail(__cUserID))
oProcess:UserSiga := "000000"
oProcess:cSubject := cAssunto

//oProcess:cFromAddr	:= UsrRetMail(__cUserID)
//oProcess:cFromName	:= UsrRetName(__cUserID)

oProcess:oHtml:ValByName( "Mensag"			, cMsg			)
oProcess:oHtml:ValByName( "DataEnv"			, DtoC(Date())	)

//Envia e-mail
oProcess:Start()
oProcess:Finish()
*/
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fBxAnexo บAutor  ณMicrosiga           บ Data ณ  05/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fBxAnexo(lSchedule)

Static __MailServer
Static __MailError
Static __MailFormatText    := .f. // Mensagem em formato Texto
Static __isConfirmMailRead := .f. // Se mensagem deve pedir confima็ใo de leitura

Local cCliente     := ""
Local cLoja        := ""
Local cStrAtch     := ""
Local cTypeMsg     := ""
Local cEmpresa     := ""
Local cFilEmp      := ""
Local cFilCli      := ""
Local cFilCarga    := ""
Local cCarga       := ""
Local cSeqCar      := ""
Local cTour        := ""
Local cStatus      := ""

Local lReturn      := .T.
Local lRetSmtp     := .F.
Local nMessages    :=  0

Local __cAccount   := GetMv("OP_XMLCONT") //"nfe_teste@higiex.com.br"  //GetSrvProfString("MMAccount",__cAccount)
Local __cPswEmail  := GetMv("OP_XMLSENH") //"teste123"           //GetSrvProfString("MMPswEmail",__cPswEmail)
Local __cSmtp      := GetMv("OP_XMLSRV1") //"smtp.sjc.terra.com.br" //GetSrvProfString("MMSmtp",__cSmtp)
Local __cPop3      := GetMv("OP_XMLSRV2") // "pop.sjc.terra.com.br"  //GetSrvProfString("MMPop3",__cPop3)


Local cFrom        := ""
Local cTo          := ""
Local cCc          := ""
Local cBcc         := ""
Local cSubject     := ""
Local cBody        := ""

Local lRet         := .T.
Local nMessages    :=  0

Default lSchedule  := .T.

aFileAtch := {}

If lRet

	cPortRec:= "143"   
	lSSL:= .F.
	
	lRet := MailImapConn ( __cPop3    , __cAccount, __cPswEmail ,,cPortRec, lSSL)  //Conectar com servidor imap
//	lRet := MailImapConn ( cMailServer, cMailConta, cMailSenha ,,cPortRec, lSSL)  //Conectar com servidor imap
//	lRet := MailPopOn(__cPop3, __cAccount, __cPswEmail, 30 )	
	If !lRet
		Alert("Nใo foi possivel acessar a conta de email! "  )
	EndIf
	

	
EndIf

If lRet
	lRet := PopMsgCount(@nMessages)
EndIf

If lRet
	
	If nMessages > 0
		
		conout(" ")
		conout(Replicate("=",80))
		conout(OemtoAnsi("A conta contem "+StrZero(nMessages,3)+" mensagem(s)") ) //###
		conout(Replicate("=",80))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRecebe as mensagens e grava os arquivos XML           ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		For nX := 1 to nMessages
			
			aFileAtch := {}
			cFrom     := ""
			cTo       := ""
			cCc       := ""
			cBcc      := ""
			cSubject  := ""
			cBody     := ""
			
			MailReceive(nX,,,,,,,aFileAtch,GetMv("OP_XMLDIR1"),.T.)			
			
			For nY := 1 to Len(aFileAtch)
				If ".XML" $ Upper(aFileAtch[nY][1])
					ConOut(" ")
					ConOut(Replicate("=",80))
					ConOut("Recebido o arquivo " + aFileAtch[nY][1]) //
					ConOut(Replicate("=",80))
				Else
					fErase(aFileAtch[nY][1])
				Endif
				
			Next nY
			
		Next nX
		
	Else
		Conout(Replicate("=",80))
		ConOut( Time()+" - Nao existem arquivos a serem recebidos" )
		Conout(Replicate("=",80))
	Endif
EndIf

//DISCONNECT POP SERVER
//MailPopOff()
MailImapOff() //ณDesconecta o IMAP


If lSchedule
	RESET ENVIRONMENT
EndIf

__RpcCalled := Nil

Return(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  MailReceiveบAutor  ณMicrosiga           บ Data ณ  05/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MailReceive(anMsgNumber, acFrom, acTo, acCc, acBcc, acSubject, acBody, aaFiles, acPath, alDelete, alUseTLSMail, alUseSSLMail)

local oMessage
local nInd
local lRunTbi	 := .F.
local nCount
local cFilename
local aAttInfo

default acFrom := ""
default acTo := ""
default acCc := ""
default acBcc := ""
default acSubject := ""
default acBody := ""
default acPath  := ""
default alDelete := .f.
default aaFiles := { }
default alUseTLSMail := .f.
default alUseSSLMail := .f.

oMessage := TMailMessage():New()
oMessage:Clear()
__MailError := oMessage:Receive(__MailServer, anMsgNumber)
if __MailError == 0
	acFrom := oMessage:cFrom
	acTo := oMessage:cTo
	acCc := oMessage:cCc
	acBcc := oMessage:cBcc
	acSubject := oMessage:cSubject
	acBody := oMessage:cBody
	
	nCount := 0
	for nInd := 1 to oMessage:getAttachCount()
		aAttInfo := oMessage:getAttachInfo(nInd)
		//Somente arquivo .XML
		If ".XML" $ Upper(aAttInfo[1])
			if empty(aAttInfo[1])
				aAttInfo[1] := "ATT.DAT"
			endif
			cFilename := acPath + "\" + aAttInfo[1]
			while file(cFilename)
				nCount++
				cFilename := acPath + "\" + substr(aAttInfo[1], 1, at(".", aAttInfo[1]) - 1) + strZero(nCount, 3) +;
				substr(aAttInfo[1], at(".", aAttInfo[1]))
			enddo
			nHandle := FCreate(cFilename)
			if nHandle == 0
				__MailError := 2000
				return .f.
			endif
			FWrite(nHandle, oMessage:getAttach(nInd))
			FClose(nHandle)
			aAdd(aaFiles, { cFilename, aAttInfo[2]})
		EndIf
	Next nInd
	
	if alDelete
		__MailServer:DeleteMsg(anMsgNumber)
	endif
endif

return( __MailError == 0 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MailPopOnบAutor  ณMicrosiga           บ Data ณ  05/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MailPopOn(cServer,cUser,cPassword,nTimeOut)

Default nTimeOut := 30

__MailError	 := 0
if valType(__MailServer) == "U"
	__MailServer := TMailManager():New()
endif

__MailServer:SetUseTLS( .T. )  // MAS - Adicionao DOMEX
__MailServer:Init(cServer, '', cUSer, cPassword )
__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
__MailError := __MailServer:PopConnect( )


IF __MailError == 0
	Alert("Conectou")
Else
	Alert(" NAO CONECTOU --> "   + str(__MailError))
Endif

Return( __MailError == 0 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMailPopOffบAutor  ณMicrosiga           บ Data ณ  05/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MailPopOff()

__MailError := __MailServer:PopDisconnect()

Return( __MailError == 0 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  PopMsgCountบAutor  ณMicrosiga           บ Data ณ  05/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function PopMsgCount(nMsgCount)

nMsgCount := 0
__MailError := __MailServer:GetNumMsgs(@nMsgCount)

Return( __MailError == 0 )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSelectNFeบAutor  ณ Felipe A. Melo     บ Data ณ  02/12/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSelectNFe(aRet,aItens)

Local aBkpLin     := aClone(aRet)

//Declara็ใo das variaveis do cabe็alho
Private oGdxItens := Nil
Private oDlgxTela := Nil
Private oGdTrt    := Nil
Private nOpcao    := 0
Private bOk       := { || IIf(oGdTrt:TudoOk()    , (nOpcao:=1 , oDlgxTela:End()) , nOpcao:=0) }
Private bCancel   := { || nOpcao:=0 , oDlgxTela:End() }
Private aButtons  := {}
Private aRotina  := {}
Private aPosObj   := {}
Private cStrCad   := "XML"
Private cTitCad   := "Rela็ใo de Arquivos XML para importa็ใo - V3.001"
Private nCtrlClik := 1
Private oSayNFe := NiL
Private oGetNFe := Nil
Private cGetNFe := Space(TamSX3("F2_CHVNFE")[1])

aAdd( aButtons, { "Classificar"		, {|| u_fNFCLAS()}		, "Classificar NF"	, "Classif.NF" 	} )
aAdd( aButtons, { "Excluir XML"		, {|| fExcluiXml() }	, "Excluir XML"		, "Exc. XML" 	} )
aAdd( aButtons, { "Cons.SEFAZ"		, {|| u_fConsSEFAZ()}	, "Cons.SEFAZ"		, "Cons.SEFAZ" 	} )
//aAdd( aButtons, { "Parametros"		, {|| fTelaPar2(.F.)}	, "Parametros"		, "Param." 		} )
aAdd( aButtons, { "Legenda"			, {|| BRWXMLLeg()}		, "Legenda"			, "Legenda" 	} )

//aAdd( aButtons, { "Situacao XML"	, {|| BRWXMLLeg()}, "Situacao XML", "Situacao XML" } )
//aAdd( aButtons, { "Visualiza XML"	, {|| fVerXml()}, "Visualiza XML", "Visualiza XML" } )


//Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //necessแrio para que a rotina de classifica็ใo funcione, pois retira o nopc da variavel arotina e nใo da variavel criada como publica
//Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //"Conhecimento"
//Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //"Conhecimento"
//Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //"Conhecimento"

aAdd(aPosObj,{005,005,035,400})  // Tamanho do Get Cabec
aAdd(aPosObj,{040,005,270,650})  // Tamanho do Get Itens(Mostrando os itens)
aAdd(aPosObj,{000,000,480,885})  // Tamanho do Get Tela (Mostrando os itens)

Define MsDialog oDlgxTela Title "["+cStrCad+"] - "+cTitCad From aPosObj[3][1],aPosObj[3][2] To aPosObj[3][3],aPosObj[3][4]  Of oMainWnd Pixel

/*Cabec*/  fCabec(oDlgxTela,aPosObj[1])
/*Itens*/fGDItens(oDlgxTela,aPosObj[2],@aRet,aItens)
Activate MsDialog oDlgxTela On Init EnchoiceBar(oDlgxTela,bOk,bCancel,,aButtons) //CENTERED

If nOpcao == 1  // Botใo Confirmar
	nPosFlag := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
	nPosArq  := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_ARQXML"})
	aRet  := {}
	For x:=1 To Len(oGdTrt:aCols)
		If oGdTrt:aCols[x][nPosFlag] == "LBTIK"
			//Refaz o array que serแ impresso
			aAdd(aRet,Array(Len(aBkpLin[1])))
			
			//			For y:=1 To Len(aBkpLin[1])
			//				aRet[Len(aRet)][y] := aBkpLin[x][y]
			//			Next x
			cDirPen := aBkpLin[1][1]
			aRet[Len(aRet)][1] := cDirPen
			aRet[Len(aRet)][2] := oGdTrt:aCols[x][nPosArq]
			
		EndIf
	Next x
	
Else
	//Responsแvel por nใo processar caso opera็ใo seja cancelada
	aRet     := {}
	//aRet   := aClone(aBkpLin)
EndIf

Return


static function fConfirmar
nPosFlag := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
nPosArq  := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_ARQXML"})
aRet  := {}
For x:=1 To Len(oGdTrt:aCols)
	If oGdTrt:aCols[x][nPosFlag] == "LBTIK"
		//Refaz o array que serแ impresso
		aAdd(aRet,Array(Len(aBkpLin[1])))
		
		//			For y:=1 To Len(aBkpLin[1])
		//				aRet[Len(aRet)][y] := aBkpLin[x][y]
		//			Next x
		cDirPen := aBkpLin[1][1]
		aRet[Len(aRet)][1] := cDirPen
		aRet[Len(aRet)][2] := oGdTrt:aCols[x][nPosArq]
		
	EndIf
Next x
return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fCabec   บAutor  ณ Felipe A. Melo     บ Data ณ  25/09/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fCabec(oDefTela,aSizeDlg)

Local nQtdCpo := 4
Local nTamCpo := ((aSizeDlg[4]-5)/nQtdCpo)-5

//Numero NF - Declara็ใo das Variแveis
Local bSayNFe  := {|| "Pesquisar Chave NFe/CTe"}
Local aSayNFe  := {aSizeDlg[1]+05,   aSizeDlg[2]+(05*1)            ,   nTamCpo*03  ,   008}
Local aGetNFe  := {aSizeDlg[1]+15,   aSizeDlg[2]+(05*1)            ,   nTamCpo*04+(10)  ,   008}
//Local aGetNFe:= {aSizeDlg[1]+15,   aSizeDlg[2]+(05*1)            ,   nTamCpo*03  ,   008} //Descomentar caso tenha que ativar Botใo pesquisar
Local aBtn01   := {aSizeDlg[1]+15,   aSizeDlg[2]+(05*2)+(nTamCpo*3),   nTamCpo+05  ,   010}

@ aSizeDlg[1], aSizeDlg[2] To aSizeDlg[3], aSizeDlg[4] Of oDefTela Pixel

//Campo Chave Nfe
oSayNFe := TSay():New( aSayNFe[1],aSayNFe[2],bSayNFe,oDefTela,,,.F.,.F.,.F.,.T.,,,aSayNFe[3],aSayNFe[4])
oGetNFe := TGet():New( aGetNFe[1],aGetNFe[2],{|u| IIf(Pcount()>0,cGetNFe:=u,cGetNFe)},oDefTela,aGetNFe[3],aGetNFe[4],PesqPict("SF2","F2_CHVNFE"),{|| fVldChvNfe() },,,,.F.,,.T.,  ,.F.,/*cWhen*/,.F.,.F.,,.F.,.F.,/*cF3*/,"cGetNFe",,,,.T.)

//Botใo Pesquisar
//@ aBtn01[1],aBtn01[2] Button "Pesquisar" Size aBtn01[3],aBtn01[4] Pixel Of oDefTela Action fPesquisar()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPesquisarบAutor  ณ Felipe A. Melo     บ Data ณ  18/10/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPesquisar()
	fVldChvNfe()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVldChvNfeบAutor  ณ Felipe A. Melo     บ Data ณ  18/10/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldChvNfe()

Local x         :=  0
Local nItem     :=  1
Local lAchou    := .F.
Local cChaveNF  := AllTrim(cGetNFe)
Local nPosFlag  := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG" })
Local nPosChav  := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_CHAVE"})

//Se chave em branco, sair sem validar e sem travar rotina
If Empty(cChaveNF)
	Return(.T.)
EndIf

//Desmarca todos itens
//For x := 1 To Len(oGdTrt:aCols)
//	oGdTrt:aCols[x][nPosFlag] := "LBNO"
//Next x

//Procura Chave
For x := 1 To Len(oGdTrt:aCols)
	If AllTrim(oGdTrt:aCols[x][nPosChav]) == cChaveNF
		oGdTrt:aCols[x][nPosFlag] := "LBTIK"
		nItem :=  x
		lAchou:= .T.
		x := Len(oGdTrt:aCols)
	EndIf
Next x

//Atualiza Browse
If lAchou
	oGdTrt:oBrowse:nAt:= nItem
	oGdTrt:oBrowse:Refresh()
	oGdTrt:oBrowse:SetFocus()
	//MsgInfo("Chave localizada, clique em confirmar para continuar!")
Else
	If Len(oGdTrt:aCols) > 0
		oGdTrt:oBrowse:nAt:= 1
		oGdTrt:oBrowse:Refresh()
		oGdTrt:oBrowse:SetFocus()
	EndIf
	Alert("Chave nใo localizada!")
EndIf

//Verifica pelo chave se nota jแ foi importada
If lAchou
	If !fChvSF1Ok(cChaveNF)
		lAchou := .F.
		Alert("Jแ existe uma NF no sistema com esta chave inserida!")
	EndIf
EndIf

//Posiciona Foco no campo
//oGetNFe:SetFocus()

Return(lAchou)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fChvSF1OkบAutor  ณ Felipe A. Melo     บ Data ณ 11/11/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fChvSF1Ok(cChaveNF)

Local lRet := .T.
Default cChaveNF := "XXXX-XXXX-XXXX-XXXX-XXXX-XXXX"

//Fecha Alias caso encontre
If Select("TMPSF1") <> 0 
	TMPSF1->(dbCloseArea()) 
EndIf

//Query
cQrySF1 := " SELECT COUNT(*) QTDE "
cQrySF1 += " FROM "+RetSqlName("SF1")+" SF1 "
cQrySF1 += " WHERE SF1.D_E_L_E_T_ = '' "
cQrySF1 += " AND F1_CHVNFE = '"+cChaveNF+"' "

//Cria alias temporario
TcQuery cQrySF1 New Alias "TMPSF1"

//Pega Conteudo
TMPSF1->(DbGoTop())

If TMPSF1->QTDE > 0
	lRet := .F.
EndIf

//Fecha Alias caso encontre
If Select("TMPSF1") <> 0 ; TMPSF1->(dbCloseArea()) ; EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fGDItens บAutor  ณ Felipe A. Melo     บ Data ณ  02/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGDItens(oDefTela,aPosObj,aRet,aItens)

Local xHeader := {}
Local xCols   := {}
Local nLin    := 00
Local x       := 00
Local y       := 00

Local cGetOpc        := GD_DELETE                                       // GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinhaOk       := "AllwaysTrue()"                                 // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk        := "AllwaysTrue()"                                 // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos       := Nil                                             // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze        := Nil                                             // Campos estaticos na GetDados.
Local nMax           := 999                                             // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk       := "AllwaysTrue()"                                 // Funcao executada na validacao do campo
Local cSuperApagar   := Nil                                             // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk       := .F.                                             // Funcao executada para validar a exclusao de uma linha do aCols
Local aPRENF :={}
//altera็ใo realizada por Marcos Rezende em 02/06/14
//para inclusใo de parametros e ordena็ใo
Local cPerg   := "ORDBRWIMP"  // Pergunta do Relatorio
LOCAL aParamBox := {}
Static aPergRet := {}
LOCAL bOk := {|| .T.}
LOCAL aButtons := {}
LOCAL lCentered := .T.
LOCAL cLoad := "ORDBRWIMP_01"
LOCAL lCanSave := .T.
LOCAL lUserSave := .T.
///fim das altera็๕es

//             X3_TITULO       , X3_CAMPO    , X3_PICTURE      ,  X3_TAMANHO, X3_DECIMAL, X3_VALID, X3_USADO        , X3_TIPO, X3_F3 , X3_CONTEXT , X3_CBOX                        , X3_RELACAO ,X3_WHEN ,X3_VISUAL, X3_VLDUSER, X3_PICTVAR, X3_OBRIGAT
aAdd(xHeader,{" "              ,"XX_FLAG"    ,"@BMP"           ,           1,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{" "              ,"XX_LEGENDA" ,"@BMP"           ,           2,          0, ".F."      , "", "C"    , ""    , "V"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Numero NF "     ,"XX_DOC"     ,"@!"             ,           9,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Serie NF"       ,"XX_SERIE"   ,"@!"             ,           2,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Tipo"           ,"XX_TIPO"    ,""               ,          10,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Dt.Emissใo NF"  ,"XX_EMISSAO" ,"@D"             ,           8,          0, ""      , "€€€€€€€€€€€€€€", "D"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"(R$) Valor NF"  ,"XX_VALOR"   ,"@E 9,999,999.99",          12,          0, ""      , "€€€€€€€€€€€€€€", "N"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"De"             ,"XX_DE"      ,"@!"             ,          40,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Para"           ,"XX_PARA"    ,"@!"             ,          40,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Chave"          ,"XX_CHAVE"   ,"@!"             ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Arquivo XML"    ,"XX_ARQXML"  ,"@!"             ,          60,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Cod CLIFOR "     ,"XX_CLIFOR" ,"@!"             ,          11,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })
aAdd(xHeader,{"Versao Nf-e"     ,"XX_VERSAO" ,"@!"             ,           4,          0, ""      , "€€€€€€€€€€€€€€", "C"    , ""    , "R"        , ""                             , ""         ,""      ,"V"      , ""               , ""        , ""        })

//altera็ใo realizada por Marcos Rezende em 02/06/14 para Ordena็ใo do Browser atrav้s de pergunta
//esta modifica็ใo deve ser incorporada ao Browser futuramente
aParamBox:={}
aAdd(aParamBox,{3,"Ordem",1,{"Numero","Data"},50,"",.F.})
/*
If ParamBox(aParamBox, "Ordem de Registros de Importa็ใo de XML", @aPergRet, bOk, aButtons, lCentered, nPosx,nPosy, , cLoad, lCanSave, lUserSave)
if aPergRet[1] = 1
aSort(aItens,,, {|x,y| right('000000000'+x[1],9) < right('000000000'+y[1],9)} )
else
aSort(aItens,,, {|x,y| dtos(x[4])+right('000000000'+x[1],9) < dtos(y[4])+right('000000000'+y[1],9)} )
endif
endif
//fim das altera็๕es
*/



//Fecha Alias caso encontre
If Select("QRYF1") <> 0 
	QRYF1->(dbCloseArea()) 
EndIf

///MONTA ARRAY DE NF DE ENTRADA EM SITUAวรO DE CLASSIFICAวรO
//PARA MONTAR LEGENDAS
cQry := " SELECT DISTINCT D1_TES,D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA as 'ID'  "
cQry += " FROM "+RetSqlName("SD1")+" SD1 " 
cQry += " WHERE D_E_L_E_T_=' ' "
cQry += " AND D1_DTDIGIT>='"+DTOS(DDATABASE-500)+"' "


tcquery cQry NEW ALIAS QRYF1
while QRYF1->(!eof())
	aADD(aPRENF,{QRYF1->ID,D1_TES})
	QRYF1->(dbskip())
enddo
QRYF1->(dbclosearea())


//Alimenta aCols
For x:=1 To Len(aItens)
	
	//nใo exibe nota repetida no browser
	//	if 	'020319' $ aItens[x][8]
	if aScan(xCols,{ |aCpo| Upper( AllTrim( aCpo[10] ) ) ==  alltrim(aItens[x][8])   }) == 0 .OR. alltrim(upper(alltrim(aItens[x][8])))=='ERRO'
		
		aAdd(xCols,Array(Len(xHeader)+1))
		nLin := Len(xCols)
		
		xCols[nLin,             1] := "LBNO"
		cCOR := "BR_VERMELHO"
		if upper(alltrim(aItens[x][1]))=='ERRO'
			cCOR := "BR_PRETO"
		ELSE
			//			    if '19685' $ aitens[x][1]
			//			    alert('ok')
			//			    endif
			nPosNF := ascan( aPRENF, { |aCpo| Upper( AllTrim( aCpo[1] ) ) ==  aItens[x][1]+aItens[x][2]+subs(aItens[x][10],4,8)} )
			if nPosNF >0
				
				IF empty(aPRENF[nPosNF][2] )
					//se a nota jแ estiver no sistema, verifica se jแ foi classificada
					cCOR := "BR_AMARELO"
				else
					cCOR := "BR_VERDE"
				ENDIF
				
			endif
		ENDIF
		
		xCols[nLin,             2] := cCOR
		xCols[nLin,             3] := aItens[x][1]
		xCols[nLin,             4] := aItens[x][2]
		xCols[nLin,             5] := aItens[x][3]
		xCols[nLin,             6] := aItens[x][4]
		xCols[nLin,             7] := aItens[x][5]
		xCols[nLin,             8] := aItens[x][6]
		xCols[nLin,             9] := aItens[x][7]
		xCols[nLin,            10] := aItens[x][8]
		xCols[nLin,            11] := aItens[x][9]
		xCols[nLin,            12] := aItens[x][10]
		xCols[nLin,            13] := aItens[x][11]		//MAS - VERSAO- 06/11/14
		
		xCols[nLin,Len(xHeader)+1] := .F.
	endif
	//	endif
Next x

//Execu็ใo das rotinas
oGdTrt:=MsNewGetDados():New(aPosObj[1],aPosObj[2],aPosObj[3],aPosObj[4],cGetOpc,cLinhaOk,cTudoOk,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oDefTela,xHeader,xCols)
oGdTrt:oBrowse:bLDblClick 	:= {|x,y,z| fDblClick(x,y,z) }   // Inibe acao do Double Click ate definir o que sera feito.
oGdTrt:oBrowse:bHeaderClick := {|x,y| fTrataCol(y) }

If Len(oGdTrt:aCols) > 0
	oGdTrt:oBrowse:nAt:= 1
	oGdTrt:oBrowse:Refresh()
	oGdTrt:oBrowse:SetFocus()
EndIf
OrdemBRW(3) //ordenar por Documento

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fDblClickบAutor  ณ Felipe A. Melo     บ Data ณ  02/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDblClick(nRow,nCol,nFlag)

Local x        := 1
Local nLinhaOK := oGdTrt:oBrowse:nAt
Local nPosFlag := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosLEG := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_LEGENDA"})

//somente irแ marcar a nota fiscal caso seja clicado no mark da tela, do contrario irแ abrir janela
//visualizando todos os dados da nota fiscal a ser importada.
if ncol==1
	If fLinErro(oGdTrt,nLinhaOK)
		Alert("Este item nใo pode ser marcado, pois cont้m erro no XML!")
		Return
	EndIf
	If oGdTrt:aCols[nLinhaOK][nPosLEG] == "BR_VERDE"
		Alert("Nota fiscal jแ importada, nใo pode ser marcada")
		Return
	EndIf
	
	If empty(oGdTrt:aCols[nLinhaOK][nPosLEG])
		Alert("Nใo Existe XML para ser importado.")
		Return
	EndIf

	
	//			If oGdTrt:aCols[nLinhaOK][nPosLEG] == "BR_AMARELO"
	//				Alert("Nota fiscal jแ importada, nใo pode ser marcada")
	//			Return
	//			EndIf
	//Marca apenas o registro em questใo
	If oGdTrt:aCols[nLinhaOK][nPosFlag] == "LBTIK"
		oGdTrt:aCols[nLinhaOK][nPosFlag] := "LBNO"
	Else
		oGdTrt:aCols[nLinhaOK][nPosFlag] := "LBTIK"
	EndIf
else
	//abre janela contendo o conte๚do do xml
	//localiza na tabela de controle o dados a serem gravados
	//rotina em desenvolvimento por marcos rezende 
	If fLinErro(oGdTrt,nLinhaOK)
		Alert("Este item nใo pode Visualizado, pois cont้m erro no XML!")
		Return
	ElseIf empty(oGdTrt:aCols[nLinhaOK][nPosLEG])
		Alert("Nใo Existe XML para ser Visualizado.")
		Return
    Else
		fVerXml()
//		ShowDOC()
	EndIf	
	

endif


//Atualiza tela
oGdTrt:oBrowse:nAt := nLinhaOK
oGdTrt:oBrowse:Refresh()
oGdTrt:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fTrataColบAutor  ณ Felipe A. Melo     บ Data ณ  02/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina acionada quando clicar no cabe็alho (tํtulos das colunas)บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fTrataCol(nCol)

Local x        := 1
Local nLinhaOK := oGdTrt:oBrowse:nAt
Local nPosFlag := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})

Default nCol      := 1
//alert('clicou na coluna: '+alltrim(str(nCol)) +chr(13)+'Conteudo celula: '+oGdTrt:aCols[nLinhaOK][nCol] )
OrdemBRW(nCol)

//Conta de cliques
nCtrlClik ++

//Controla pra evitar passar por duas vezes na mesma rotina
//If nCtrlClik%2 != 0
//	Return
//EndIF
/*
If nCol == nPosFlag
//Marca apenas o registro em questใo
If oGdTrt:aCols[nLinhaOK][nPosFlag] == "LBTIK"
For x:=1 To Len(oGdTrt:aCols)
oGdTrt:aCols[x][nPosFlag] := IIf(fLinErro(oGdTrt,x),"LBNO","LBNO")
Next x
Else
For x:=1 To Len(oGdTrt:aCols)
oGdTrt:aCols[x][nPosFlag] := IIf(fLinErro(oGdTrt,x),"LBNO","LBTIK")
Next x
EndIf
EndIf
*/
//Atualiza tela
oGdTrt:oBrowse:nAt := nLinhaOK
oGdTrt:oBrowse:Refresh()
oGdTrt:oBrowse:SetFocus()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fChekErr บAutor  ณ Felipe A. Melo     บ Data ณ  12/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChekErro(cTeste)

Local lRet := .T.
Local cRet := Nil

bBlock := ErrorBlock( { |e| ChecErro(e) } )

BEGIN SEQUENCE
cRet := ValType(cTeste)
END SEQUENCE

If cRet == "U"
	lRet := .F.
EndIf

Return(lRet)

//========================================================
Static Function ChecErro(e)

IF e:gencode > 0
	lRet:=.F.
Else
	lRet:=.T.
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLinErro บAutor  ณ Felipe A. Melo     บ Data ณ  12/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLinErro(oGdTrt,nLinhaOK)

Local lRet   := .F.
Local cVErro := ""

Local nPos01 := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_DOC"})
Local nPos02 := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_SERIE"})
Local nPos03 := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_DE"})
Local nPos04 := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_PARA"})
Local nPos05 := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_CHAVE"})
Local nPos06 := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_ARQXML"})

cVErro += "/"+Upper(AllTrim(oGdTrt:aCols[nLinhaOK][nPos01]))+"/"
cVErro += "/"+Upper(AllTrim(oGdTrt:aCols[nLinhaOK][nPos02]))+"/"
cVErro += "/"+Upper(AllTrim(oGdTrt:aCols[nLinhaOK][nPos03]))+"/"
cVErro += "/"+Upper(AllTrim(oGdTrt:aCols[nLinhaOK][nPos04]))+"/"
cVErro += "/"+Upper(AllTrim(oGdTrt:aCols[nLinhaOK][nPos05]))+"/"
cVErro += "/"+Upper(AllTrim(oGdTrt:aCols[nLinhaOK][nPos06]))+"/"

If "/ERRO/" $ cVErro
	lRet := .T.
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLinErro บAutor  ณ Felipe A. Melo     บ Data ณ  12/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVerTipo(oObjXml)

Local oNfe      := oObjXml
Local oNF       := IIf(ValType(oNFe:_NfeProc)<>"U",oNFe:_NFeProc:_NFe,oNFe:_NFe)
Local oDet      := IIf(ValType(oNF:_InfNfe:_Det)=="O",{oNF:_InfNfe:_Det},oNF:_InfNfe:_Det)
Local oIdent    := oNF:_InfNfe:_IDE
Local cTipoNF   := ""

lTag := fChekErro(oObjXml)
lTag := fChekErro(oNfe)
lTag := fChekErro(oNF)
lTag := fChekErro(oDet)

//Verifica o tipo da nota fiscal
For nX :=1 To Len(oDet)
	//Beneficiamento
	If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ "901/920"
		cTipoNF := "Benef."
		nX := Len(oDet)
	EndIf
	
	//Devolu็ใo
	If SubStr(AllTrim(oDet[nX]:_Prod:_CFOP:TEXT),2,3) $ "201" //"902/903"
		cTipoNF := "Devol."
		nX := Len(oDet)
	EndIf
Next nX

//Normal
If Empty(cTipoNF) .And. !Empty(oIdent:_finNFe:Text)
	cTipoNF := "Normal"
ElseIf Empty(cTipoNF)
	cTipoNF := "ERRO"
EndIf

Return(cTipoNF)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExcluiXmlบAutor  ณ Felipe A. Melo     บ Data ณ  17/12/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclui os XML marcados                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fExcluiXml()

Local nLinhaOK  := oGdTrt:oBrowse:nAt
Local nPosFlag  := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosLegen := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_LEGENDA"})
Local nPosNomArq:= aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_ARQXML"})
Local nPosDele  := Len(oGdTrt:aHeader)+1
Local nContDel  := 0

Local cAno      := StrZero(Year(dDataBase),4)
Local cMes      := StrZero(Month(dDataBase),2)
Local cDirOrig  := "\data\impxml\pendente\"
Local cDirDest  := "\data\impxml\excluido\"+cAno+"\"+cMes+"\"
Local cNomelXml := ""
Local cMsgDel   := ""
Local nMsgDel   := 0

//Caso nใo confirme, sair sem excluir registros XML's!
cMsgDel := "Esta rotina tem como objetivo excluir os arquivos XML da pasta pendente, mas deixando uma copia na pasta excluido."
cMsgDel += Chr(13)+Chr(10)+Chr(13)+Chr(10)
cMsgDel += "Agora escolha o que deseja fazer:"
cMsgDel += Chr(13)+Chr(10)
cMsgDel += "1) Excluir todos arquivos que tem algum tipo de erro, identificado com (X)"
cMsgDel += Chr(13)+Chr(10)
cMsgDel += "2) Excluir todos arquivos que foram marcados como deletados (cor cinza)"
cMsgDel += Chr(13)+Chr(10)
cMsgDel += "3) Excluir todos arquivos das duas condi็๕es acima, marcados e com erro"
cMsgDel += Chr(13)+Chr(10)
cMsgDel += "4) Sair sem fazer nada"

nMsgDel := Aviso("Exclusใo XML",cMsgDel,{"Erro","Marcado","Ambos","Sair"},3)

If nMsgDel == 4
	Return
EndIf

//Caso nao exista, cria o diretorio no servidor
MontaDir(cDirDest)

//Excluir XML's e remover registros do array
For x:=1 To Len(oGdTrt:aCols)
	//Caso marcado como deletado
	lPodeExcluir := .T.
	
	//Ja foi excluir, por isso essa valida็ใo
	If lPodeExcluir .And. Empty(oGdTrt:aCols[x])
		lPodeExcluir := .F.
	EndIf
	
	If lPodeExcluir
		Do Case
			Case nMsgDel == 1 .And. oGdTrt:aCols[x][nPosLegen] == "BR_PRETO"  //Erro
				lPodeExcluir := .T. //Apenas pra facilitar a leitura
				
			Case nMsgDel == 2 .And. (oGdTrt:aCols[x][nPosFlag] == "LBTIK"  .or. oGdTrt:aCols[x][nPosDele] == .T.)          //Marcado
				lPodeExcluir := .T. //Apenas pra facilitar a leitura
				
			Case nMsgDel == 3 .And. (oGdTrt:aCols[x][nPosLegen] == "BR_PRETO" .Or. oGdTrt:aCols[x][nPosFlag] == "LBTIK" ) //Ambos
				lPodeExcluir := .T. //Apenas pra facilitar a leitura
				
			Otherwise
				lPodeExcluir := .F. //NรO PODE EXCLUIR
				
		EndCase
	EndIf
	
	If lPodeExcluir
		nContDel ++
		
		cNomelXml := oGdTrt:aCols[x][nPosNomArq]
		
		If File(cDirOrig+cNomelXml)
			Copy File &cDirOrig+cNomelXml To &cDirDest+cNomelXml
			Sleep(300)//aguarda para concluir a copia
			If File(cDirDest+cNomelXml) //somente exclui se o arquivo jแ estiver na pasta de destino
				
				lDelOk := .F.
				While !lDelOk
					fErase(cDirOrig+cNomelXml)
					lDelOk := !File(cDirOrig+cNomelXml)
					If !lDelOk
						Alert("O XML estแ aberto, feche o mesmo para que ele seja movido de pasta!")
					EndIf
				End
				//Anula registro no array
				aDel(oGdTrt:aCols,x)
				
				//Subtrai uma linha devido a exclusใo
				x--
			else
				Alert("Nใo foi possํvel excluir o arquivo, Contate administrador do sistema")
			endif
			
		else
			alert("Arquivo de origem nใo encontrado"+CHR(13)+"O nome do arquivo nใo pode conter acentos ou caracteres especiais")
		EndIf
		
	EndIf
Next x

//Remove registros anulados no array
If nContDel > 0
	aSize(oGdTrt:aCols,Len(oGdTrt:aCols)-nContDel)
EndIf

//Atualiza tela
If nLinhaOK > Len(oGdTrt:aCols)
	oGdTrt:oBrowse:nAt := Len(oGdTrt:aCols)
EndIf

oGdTrt:oBrowse:nAt := nLinhaOK
oGdTrt:oBrowse:Refresh()
oGdTrt:oBrowse:SetFocus()

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExecPreNFบAutor  ณ Felipe A. Melo     บ Data ณ    /  /2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fExecCTeRem(lSchedule,oObjXml)

Local lRet      := .T.
Local cMsgErro  := ""
Local cFornCTe  := ""
Local cLojaCTe  := ""
Local cNomeCTe  := ""
Local cDocCTe  := ""
Local cSerNF   := ""
Local dEmissNF := StoD("")
Local cChavNFe := ""
Local cCodProd  := "050.025        "
Local cCPag_CT  := "001"
Local nQtdServ  := 0
Local nValServ  := 0

Private oXML    := oObjXML:_CTeProc:_CTe

//-- Verifica se o fornecedor do conhecimento esta cadastrado no sistema.
If ValType(XmlChildEx(oXML:_InfCte:_Emit,"_CNPJ")) <> "U"
	cCNPJ_CT := AllTrim(oXML:_InfCte:_Emit:_CNPJ:Text)
Else
	cCNPJ_CT := AllTrim(oXML:_InfCte:_Emit:_CPF:Text)
EndIf

SA2->(dbSetOrder(3))
If lRet .And. !SA2->(dbSeek(xFilial("SA2")+cCNPJ_CT))
	Alert("Fornecedor nใo localizado!")
	lRet := .F.
Else
	cFornCTe := SA2->A2_COD
	cLojaCTe := SA2->A2_LOJA
	cNomeCTe := SA2->A2_NOME
EndIf

If lRet .And. AllTrim(SM0->M0_CGC) != AllTrim(oXML:_InfCte:_Rem:_CNPJ:Text)
	Alert("O Remetente nใo ้ a Empresa Atual no sistema, selecione empresa e tente novamente!")
	lRet := .F.
EndIf

//Procura Produto
SB1->(dbSetOrder(1))
If lRet .And. !SB1->(dbSeek(xFilial("SB1")+cCodProd))
	Alert("Produto '"+cCodProd+"' nใo localizado!")
	lRet := .F.
EndIf

If lRet
	//------------------------------------------------------------
	//Declara variaveis - Cabe็alho
	//------------------------------------------------------------
	cDocCTe  := AllTrim(oXML:_InfCte:_Ide:_nCt:Text)
	cDocCTe  := "000000000"+cDocCTe
	cDocCTe  := Right(cDocCTe,TamSx3("F1_DOC")[1])
	cSerNF   := PadR(oXML:_InfCte:_Ide:_Serie:Text,TamSx3("F1_SERIE")[1])

	if alltrim(cVersao) <> "2.00"
		dEmissNF := SToD(Substr(StrTran(Substr(oXML:_InfCte:_Ide:_dhEmi:Text,1,10),"-",""),1,8))
	Else
		dEmissNF := SToD(Substr(StrTran(oXML:_InfCte:_Ide:_dhEmi:Text,"-",""),1,8))
	Endif
		
	
	cChavNFe := oObjXML:_CTeProc:_ProtCTe:_InfProt:_ChCTe:TEXT
	
	//------------------------------------------------------------
	//Declara variaveis - Itens
	//------------------------------------------------------------
	nQtdServ := 1
	nValServ := Val(oXML:_InfCte:_VPrest:_VRec:Text)
EndIf

SF1->(DbSetOrder(1))
If lRet .And. SF1->(DbSeek(xFilial("SF1")+cDocCTe+cSerNF+cFornCTe+cLojaCTe+"N"))
	Alert("Este CTe "+cDocCTe+"/"+cSerNF+" jแ foi incluso no sistema!")
	lRet := .F.
EndIf

If lRet
	//------------------------------------------------------------
	//Alimenta Array
	//------------------------------------------------------------
	aCabec := {}
	aadd(aCabec,{"F1_TIPO"    ,"N"                                              ,Nil,Nil})
	aadd(aCabec,{"F1_FORMUL"  ,1                                                ,Nil,Nil})
	aadd(aCabec,{"F1_DOC"     ,cDocCTe                                          ,Nil,Nil})
	aadd(aCabec,{"F1_SERIE"   ,cSerNF                                           ,Nil,Nil})
	aadd(aCabec,{"F1_COND"    ,cCPag_CT                                         ,Nil,Nil})
	aadd(aCabec,{"F1_EMISSAO" ,dEmissNF                                         ,Nil,Nil})
	aadd(aCabec,{"F1_FORNECE" ,cFornCTe                                         ,Nil,Nil})
	aadd(aCabec,{"F1_LOJA"    ,cLojaCTe                                         ,Nil,Nil})
	aadd(aCabec,{"F1_ESPECIE" ,"CTE"                                            ,Nil,Nil})
	aadd(aCabec,{"F1_CHVNFE"  ,cChavNFe                                         ,Nil,Nil})
	
	//------------------------------------------------------------
	//Alimenta Array
	//------------------------------------------------------------
	aItens := {}
	aLinha := {}
	aadd(aLinha,{"D1_COD"  ,cCodProd    ,Nil,Nil})
	aadd(aLinha,{"D1_QUANT",nQtdServ    ,Nil,Nil})
	aadd(aLinha,{"D1_VUNIT",nValServ    ,Nil,Nil})
	aadd(aLinha,{"D1_TOTAL",nValServ    ,Nil,Nil})
	aadd(aItens,aLinha)
EndIf

//Executa rotina de inclusใo Pre-Nota
If lRet .And. Len(aItens) > 0
	//Begin Transaction
	
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	ROLLBACKSXE()
	MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)
	
	If lMsErroAuto
		lRet := .F.
		
		cMsgErro := Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - Erro na execu็ใo do MsExecAuto para gera็ใo da Pre-CTe."
		fErroHTML("INTEGRACAO XML x Pre-CTe", "[Workflow Protheus] Erro na importa็ใo do XML para Pre-CTe", cMsgErro)
		
		If !lSchedule
			MsgAlert(cMsgErro)
		EndIf
		
		MostraErro()
	Else
		lRet := .T.
		ConfirmSX8()
		
		cMsgErro := Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - CTe Gerada Com Sucesso!"
		fErroHTML("INTEGRACAO XML x Pre-CTe", "[Workflow Protheus] Pre-CTe Gerada Com Sucesso ["+Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+"]", cMsgErro)
		If !lSchedule
			MsgAlert(cMsgErro)
			//abre tela de classifica็ใo da nota fiscal logo ap๓s a inclusใo da pre nota
			u_fCLNFx()
		EndIf
	EndIf
	
	//End Transaction
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPXMLNF  บAutor  ณMarcos Rezende      บ Data ณ  06/25/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra legenda do Browser Principal                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static Function BRWXMLLeg()
Local aLegenda := {}
aAdd(aLegenda, {"BR_PRETO"    	,"Documento com erro"}) //"Docto. nao Classificado"
aAdd(aLegenda, {"BR_VERDE"		,"Documento Importado e Classificado"}) //"Docto. Bloqueado"
aAdd(aLegenda, {"BR_AMARELO"	,"Documento Importado, aguarda Classifica็ใo"}) //"Docto. Bloqueado"
aAdd(aLegenda, {"BR_VERMELHO"   ,"Documento nใo importado"}) //"Docto. Normal"

BrwLegenda("Importa XML","Legenda" ,aLegenda) //"Legenda"

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPXMLNF  บAutor  ณMarcos Rezende      บ Data ณ  07/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classifica as notas fiscais marcadas                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

user Function fClNFCTE
Local nPosLEG := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_LEGENDA"})
Local nPosFlag:= aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
//Local 	aRotina := {}
Private nRegSF1	  := 'sf1->(recno())'

For x:=1 To Len(oGdTrt:aCols)
	//Caso marcado como deletado
	lMarcado := .T.
	Do Case
		Case oGdTrt:aCols[x][nPosLEG] == "BR_AMARELO" .AND. oGdTrt:aCols[x][nPosFlag] == "LBTIK" //A CLASSIFICAR E MARCADO
			lMarcado := .T.
		Otherwise
			lMarcado := .F.
	EndCase
	
	IF lMarcado
		cChavePesq := oGdTrt:aCols[x][3]+oGdTrt:aCols[x][4]+subs(oGdTrt:aCols[x][12],4,8) //CHAVE DE PESQUISA DE NOTA FISCAL
		sf1->(dbsetorder(1))
		if sf1->(dbseek(xfilial("SF1")+cChavePesq)) //se encontrar a nota fiscal, aciona rotina de classifica็ใo
			public nOpc := 4
			public nOpcX := 4
			public l103Class	:= .T.
			
			l103TolRec  := .T.
			INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
			ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)
			A103NFiscal('SF1',SF1->(RECNO()),4,,.T.,.f.)
			
		endif
	ENDIF
	
Next x



return



user function fNFCLAS
Local 	aRotina := {}
Local cFiltro := ""
Aadd(aRotina,{"Classifar","U_FCLNFX()", 0 , 4}) //"Conhecimento"
cFiltro := "F1_STATUS == ' ' .AND. F1_DTDIGIT >= STOD('20140101') "
dbselectarea("SF1")
SET FILTER TO &(cFiltro)
AxCadastro("SF1", "NFs a classificar", ".t.", ".t.", aRotina )
SET FILTER TO

return



USER Function fClNFx
Private aRotina  := {}
Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //necessแrio para que a rotina de classifica็ใo funcione, pois retira o nopc da variavel arotina e nใo da variavel criada como publica
Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //"Conhecimento"
Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //"Conhecimento"
Aadd(aRotina,{"Classif.OPUS","U_FCLNFX()", 0 , 4}) //"Conhecimento"

nOpc := 4
nOpcX := 4
l103Class	:= .T.
l103TolRec  := .T.
INCLUI := IIf(Type("INCLUI")=="U",.F.,INCLUI)
ALTERA := IIf(Type("ALTERA")=="U",.F.,ALTERA)
A103NFiscal('SF1',SF1->(RECNO()),4,,.T.,.f.)
return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVerXml   บAutor  ณMicrosiga           บ Data ณ  13/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza XML no Browse/Leitor de XML (Ex.Danfeview)       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fVerXml

Local cDirSrv :="data\impxml\Pendente\" //012036-cte_teste.xml"
Local cDirLocal := "c:\temp\"
Local cArquivo := ""
Local nPosSel  := oGdTrt:nat
Local nPosLEG := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_LEGENDA"})
Local nPosFlag:= aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosArq := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_ARQXML"})
Local lCompacta := .T.
Local nRmtType := GetRemoteType()
//verifica se o Browser esta habilitado dentro do Protheus e no parametro
Local lBrw      := GETMV("MV_ZBRWRSA",,.T.)
Local lBrwIni := (GetPvProfString("CONFIG","BROWSERENABLED","ERRO",GetRemoteIniName()) == "1")


// Nao permite visualizar XML com erro
/*
If fLinErro(oGdTrt,nLinhaOK)
		Alert("Nใo Existe XML para este Item!")
		Return
EndIf	
  */
  
montadir(cDirLocal)
cArqLocal := cDirLocal+oGdTrt:aCols[nPosSel][nPosArq]
cArqSrv    := cDirSrv+oGdTrt:aCols[nPosSel][nPosArq]

lSucess := CpyS2T(cArqSrv,cDirLocal,.f.)

if lSucess //se conseguiu copiar o arquivo
	If lBrw .AND. lBrwIni
		DEFINE MSDIALOG oDlg FROM 0,0 to 650,1000 PIXEL TITLE "Consulta XML"
		oTIBrowser := TiBrowser():New(0,0,500,300,cArqLocal,oDlg)
		oButton := Tbutton():New(310,0070,'OK',oDlg, {||oDlg:End(),lContinue := .t.},40,10,,,,.t.)
		Activate MSdialog oDlg Centered
		//caso o browser nใo esteja ativo dentro do protheus abre o IE
	ElseIf nRmtType == 2 .OR. !lBrw //LINUX ou parametro .F.
		ShellExecute("open",cArqLocal,"","",5)
	ElseIf !lBrwIni
		ShellExecute("open",cArqLocal,"","",5)
		//        MsgStop("SmartClient.ini nใo configurado corretamente. verificar chave 'BROWSERENABLED'")
	EndIf
else
	alert("Nใo foi possivel abrir o XML, erro ao copiar o arquivo para a esta็ใo")
endif
return

user function fConsSEFAZ
//Acessar site da fazenda e abrir a consulta completa conforme a chave constante no xml
DEFINE MSDIALOG oDlg FROM 0,0 to 650,1000 PIXEL TITLE "Consulta SEFAZ"
oTIBrowser := TiBrowser():New(0,0,500,300,"http://www.nfe.fazenda.gov.br/portal/consulta.aspx?tipoConsulta=completa&tipoConteudo=XbSeqxE8pl8=",oDlg)
oButton := Tbutton():New(310,0070,'OK',oDlg, {||oDlg:End(),lContinue := .t.},40,10,,,,.t.)
Activate MSdialog oDlg Centered

return

//ordena็ใo das colunas
static function OrdemBRW(nCol)
Local nPosLEG := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_LEGENDA"})
Local nPosFlag:= aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosArq := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_ARQXML"})
Local nPosDOC := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_DOC"})

oGdTrt:aCols
if nCol == nPosDOC
	aSort(oGdTrt:aCols,,, {|x,y| right('000000000'+x[nPosDOC],9) < right('000000000'+y[nPosDOC],9)} )
else // if nCol == nPosLEG
	aSort(oGdTrt:aCols,,, {|x,y| x[nCol] < y[nCol]} )
endif

//		aSort(aItens,,, {|x,y| dtos(x[4])+right('000000000'+x[1],9) < dtos(y[4])+right('000000000'+y[1],9)} )

return

static function showDOC()
Local nPosLEG := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_LEGENDA"})
Local nPosFlag:= aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_FLAG"})
Local nPosArq := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_ARQXML"})
Local nPosDOC := aScan(oGdTrt:aHeader,{|x|AllTrim(x[2])=="XX_DOC"})
Local oGdDOC
Local oFolder
PRIVATE aTitles     := {OemToAnsi("Itens"),OemToAnsi("Financeiro"),OemToAnsi("Totais")}
PRIVATE aDialogs    := {"Itens","Financeiro","Totais"}
Private xHeader2:= {}
Private xCols2  := {}
Private aAlterFields := {}
//capturar as informa็๕es do conte๚do do XML
//gravar em Tabela Personalizada todo o conte๚do do XML tendo como chave de pesquisa a chave da nota fiscal ou CT-e
//caso da importa็ใo jแ exista as informa็๕es irแ desconsiderar os dados e nใo irแ importar

//abrir tela formato browse contendo o conte๚do da tabela personalizada(somente os registros vinculados a chave) com a possibilidade de altera็ใo dos conte๚dos(TES,Ccontabil,Desc.Item, C.Custo)
//todas as altera็๕es serใo salvas nesta tabela.
//quando for realizada a importa็ใo dos dados, localizarแ nesta tabela os registros, caso exista, ignora o conte๚do do xml e importa os dados existentes nesta tabela.

aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 20, 20, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{005,070,110,175,215,280}} )
nGetLin := aPosObj[3,1]

//	SetKey(VK_F4,{||U_X415F4()})

SHOWDOC_H() //monta acols e aheader
DEFINE MSDIALOG oDlg TITLE "Importa XML" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

cProd 	:= SPACE(15)
cCHV	:=	space(44)
@ 05,(aPosGet[1,1])     SAY   "Documento/Serie "                    Of oDlg SIZE 58 ,9  PIXEL COLOR CLR_BLUE FONT oFontBRW //"Total "
@ 05,(aPosGet[1,1]*10)  MSGET oDOC  VAR cDOC    PICTURE "@!"  OF oDlg PIXEL COLOR CLR_BLUE FONT oFont When .F. SIZE 150,09

@ 20,(aPosGet[1,1])     SAY   "Chave eletronica "                    Of oDlg SIZE 58 ,9  PIXEL COLOR CLR_BLUE FONT oFontBRW //"Total "
@ 20,(aPosGet[1,1]*10)  MSGET oCHV  VAR cCHV     PICTURE "@!"  OF oDlg PIXEL COLOR CLR_BLUE FONT oFont When .F. SIZE 450,09

//   @ 05,(aPosGet[1,1]*15)     SAY   "Valor Total"                 Of oDlg  SIZE 58 ,9  PIXEL COLOR CLR_BLUE FONT oFontBRW //"Total "
//   @ 05,(aPosGet[1,1]*15)  MSGET oValEstru VAR nValEstru     PICTURE "@E 999,999,999.9999"  OF oFolder:aDialogs[1] PIXEL COLOR CLR_BLUE FONT oFont When .F. SIZE 45,09


oFolder := TFolder():New(50, 0,aTitles,aPages,oDlg,,,, .T., .F.,aPosObj[3,4],aPosObj[3,3]+aPosObj[3,1],)
oFolder:aDialogs[1]:oFont := oDlg:oFont
//Execu็ใo das rotinas

nFreeze 		:= 1  //congela a primeira coluna que terแ o n๚mero da nota
cGetOpc 		:= 2  //modo de edi็ใo
cSuperApagar	:= "AllWaysTrue"
cCampoOk        := "AllWaysTrue"
cLinhaOk        := "AllWaysTrue"
cTudoOk   		:= "AllWaysTrue"
cApagaOk		:= "AllWaysTrue"
oGdDOC			:=MsNewGetDados():New(0,0,220,670,cGetOpc,cLinhaOk,cTudoOk,cIniCpos,aAlterFields,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oFolder:aDialogs[1],xHeader2,xCols2)
//oGdTrt:oBrowse:bLDblClick 	:= {|x,y,z| fDblClick(x,y,z) }
//oGdTrt:oBrowse:bHeaderClick := {|x,y| fTrataCol(y) }

If Len(oGdDOC:aCols) > 0
	oGdDOC:oBrowse:nAt:= 1
	oGdDOC:oBrowse:Refresh()
	oGdDOC:oBrowse:SetFocus()
	//	oGdDOC:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT		//alinha o controle a แrea total da tela
EndIf

ACTIVATE MSDIALOG oDlg ON INIT BARSHOWDOC(oDlg,{||nOpcA:=1,IIf(oGetDb:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()}, nOpcx)
return

Static Function BARSHOWDOC(oDlg,bOk,bCancel,nOpc)

Local aUsButtons:= {}
Local aButtons 	:= {}
Local lOpcPadrao:= GetNewPar("MV_REPGOPC","N") == "N"
Local nPOpcional:= If(lOpcPadrao,aScan(aHeader,{|x| AllTrim(x[2])=="CK_OPC"}),aScan(aHeader,{|x| AllTrim(x[2])=="CK_MOPC"}))

aadd(aButtons,{"POSCLI",{|| If(!Empty(M->CJ_CLIENTE),a450F4Con(),.F.)},OemToAnsi("Posio de Cliente"), OemToAnsi("Posio de Cliente") })	//"Posio de Cliente"
aadd(aButtons,{"RELATORIO",{||MX415Impos(aRotina[ nOpc, 4 ])},OemToAnsi("Planilha Financeira"),OemToAnsi("Planilha Financeira") })	//"Planilha Financeira"
If ( RpcCheckTbi() )
	aadd(aButtons,{"VENDEDOR",{|| U_MX415TbiCl()},OemToAnsi("Inclusao de cliente TBI"),OemToAnsi("Inclusao de cliente TBI")}) //"Inclusao de cliente TBI"
EndIf

If aRotina[ nOpc, 4 ] == 2
	AAdd(aButtons,{ "BMPVISUAL", {|| U_X415Track() }, OemToAnsi("System Tracker"),OemToAnsi("System Tracker") } )  // "System Tracker"
EndIf
If ( nOpc == 1 .Or. nOpc == 2 .Or. nOpc == 5 ) .And. nPOpcional > 0
	Aadd(aButtons,{"SDUCOUNT", {|| SeleOpc(2,"MATX415",TMP1->CK_PRODUTO,,,U_MX415Opc(lOpcPadrao),"M->CK_PRODUTO",.T.,TMP1->CK_QTDVEN,TMP1->CK_ENTREG) } ,"Opcionais Selecionados","Opcionais"}) //"Opcionais Selecionados"###"Opcionais"
EndIf

//Op็ใo acionada automaticamente atrav้s da valida็ใo das linhas
//Aadd(aButtons,{"Estrutura Item",{|| U_X415ESTRITEM()},OemToAnsi("Estrutura Item"),OemToAnsi("Estrutura Item") })
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))

///monta aHeader do SHOWDOC
// Montagem da matriz aHeader
// e tamb้m preenchimento dos dados
STATIC Function SHOWDOC_H()

Local aSaveArea	:= GetArea()
Local aCampos	:= {}
Local cTBL 		:= "SF1"

PRIVATE nUsado := 0

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cTBL)
While !EOF() .And. (x3_arquivo == cTBL)
	If	x3Uso(x3_usado) .and. cNivel >= x3_nivel
		nUsado++
		AADD(xHeader2,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal, x3_valid,;
		x3_usado, x3_tipo, cTBL, x3_context } )
		aADD(aAlterFields,x3_campo)
	EndIF
	dbSkip()
EndDO
Aadd(aCampos,{"D1_FLAG","L",1,0})

RestArea(aSaveArea)
(cTBL)->(DbGoTo())
nRegSHOW:=1
while (cTBL)->(!eof()) .and. nRegSHOW <=50 //limita a exibi็ใo a 50 registros
	nRegSHOW++
	aAdd(xCols2,Array(Len(xHeader2)+1))//cria array vazia
	xCols2[Len(xCols2),Len(xHeader2)+1] := .F. //define o ๚ltimo campo (controle de deletado)
	For nI := 1 To Len(xHeader2)
		xCols2[Len(xCols2)][nI] := (cTBL)->&(xHeader2[nI][2]) //adiciona o conte๚do do campo da tabela cTBL no aCols
	Next nI
	(cTBL)->(DbSkip())
enddo

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVerXml   บAutor  ณMicrosiga           บ Data ณ  13/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza XML no Browse/Leitor de XML (Ex.Danfeview)       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTelaPar2(lSchedule)

aRetTela := fTelaParam(lSchedule)
If aRetTela[1]
	nLerPasta := aRetTela[2]
	cPastaPen := GetMv("OP_XMLDIR1") //DIRETORIO PENDENTES  \data\impxml\pendente\     AllTrim(aRetTela[3])
	cPastaPro := GetMv("OP_XMLDIR2") //DIRETORIO PROCESSADAS \data\impxml\processado\	AllTrim(aRetTela[4])
	cPastaRec := GetMv("OP_XMLDIR4") //DIRETORIO RECUSADOS \data\impxml\recusado\ 		AllTrim(aRetTela[5])                                                   

	//Fun็ใo para baixar emails com anexos XML
	MsAguarde( { || U_fBxAnexo(.F.) } ,"Baixando e-mail", "Procurando e-mails com anexos XML - Aguarde..." )

	//Fun็ใo para ler pasta/diretorio dos xml que serao importados
	MsAguarde( { || aRetArqs :=  fLerPasta(cPastaPen,nLerPasta) } ,"Procurando XML", "Procurando por arquivos XML - Aguarde..." )

EndIf


Return

//==================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOPXML010  บ Autor ณ Marco Aurelio      บ Data ณ  12/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Consulta Chave do XML dos Fornecedores                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Importa XML                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function OPXML010()
Local oDlgKey, oBtnOut, oBtnCon
Local cIdEnt    := ""
Local cChaveXml := AllTrim(ZBZ->ZBZ_CHAVE)
Local cModelo   := ZBZ->ZBZ_MODELO
Local cProtocolo:= ZBZ->ZBZ_PROT
Local cMensagem := ""
Local aArea     := GetArea()
Local lRet      := .T.
Local cPref     := "NF-e"                             
Local cTAG      := "NFE"
Local cCodRet   := ""
Default cURL    := AllTrim(SuperGetMv("MV_SPEDURL"))
If cModelo == "55"
 	cPref   := "NF-e"                             
	cTAG    := "NFE"
ElseIf cModelo == "57"
 	cPref   := "CT-e"                             
	cTAG    := "CTE"
EndIf
	
	DEFINE MSDIALOG oDlgKey TITLE "Consulta "+cPref FROM 0,0 TO 150,305 PIXEL OF GetWndDefault()
	
	@ 12,008 SAY "Informe a Chave de acesso do xml de "+cPref PIXEL OF oDlgKey
	@ 20,008 MSGET cChaveXml SIZE 140,10 PIXEL OF oDlgKey READONLY
	
	@ 46,035 BUTTON oBtnCon PROMPT "&Consultar" SIZE 38,11 PIXEL ;
	ACTION (lValidado := U_XConsXml(cURL,cChaveXml,cModelo,cProtocolo,@cMensagem,@cCodRet,.T.),;
		,oDlgKey:End())
	@ 46,077 BUTTON oBtnOut PROMPT "&Sair" SIZE 38,11 PIXEL ACTION oDlgKey:End()
	
	ACTIVATE DIALOG oDlgKey CENTERED
    
	If !Empty(cCodRet)
		U_XMLSETCS(cModelo,cChaveXml,cCodRet,cMensagem) 
    EndIf
Return




//aqui vai conectar com imap
Static Function MailImapConn ( cServer, cUser, cPassword, nTimeOut , cPortRec, lSSL)
Local nResult := 0
Default nTimeOut := 15

__MailError	 := 0
If ValType(__MailServer) == "U"
	__MailServer := TMailManager():New()
Endif
//TMailManager(): Init ( < cMailServer>, < cSmtpServer>, < cAccount>, < cPassword>, [ nMailPort], [ nSmtpPort] ) 
if lSSL
	__MailServer:SetUseSSL( lSSL )
endif
__MailServer:Init(AllTrim(cServer),'', AllTrim(cUSer), AllTrim(cPassword) ,Val(cPortRec))
__MailError	:= __MailServer:SetPopTimeOut( nTimeOut )
__MailError := __MailServer:ImapConnect()


IF __MailError == 0
	Alert("Conectou")
Else
	Alert(" NAO CONECTOU --> "   + str(__MailError))
Endif


Return( __MailError == 0 )


//desconectar o IMAP
Static Function MailImapOff()
__MailError := __MailServer:ImapDisconnect()
Return( __MailError == 0 )
