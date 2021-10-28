#include 'rwmake.ch'
#include 'tbiconn.ch'   //Funcoes para uso do Prepare Environment
#include 'tbicode.ch'
#include "protheus.ch"
#include "topconn.ch"

#DEFINE N_BUFFER 15000

User Function Vserverini()// MostraFunc(OK)

	MsgRun("RpcSetEnv()","Favor Aguardar.....",{|| fIniAmbiente() })

	//cRetorno := U_VCompQuent()
	//cRetorno := startjob("U_VCompQuent",getenvserver(), .T. , cMensagem)

	PutMV("XX_SERVERI","")

	//MsgRun("Processando CompilaÁ„o a Quente (VALIDACAO)...","Favor Aguardar.....",{|| fprocessa() })
	MsgRun("Processando CompilaÁ„o a Quente (VALIDACAO)...","Favor Aguardar.....",{|| U_VCompQuent() })
	
	U_msgcoletor(GetMV("XX_SERVERI"))

Return

User Function VCompQuent()
	Local n, x, y, cPutMV

	fIniAmbiente()

	Private cArquivo1  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\02_appserver_master\appserver.ini'
	Private cArquivo2  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\11_appserver_ti\appserver.ini'
	Private cArquivo3  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\12_appserver_workflow\appserver.ini'
	Private cArquivo4  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\13_appserver_schedulle\appserver.ini'
	Private cArquivo5  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\15_appserver_mrp\appserver.ini'
	Private cArquivo6  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\17_appserver_web\appserver.ini'
	Private cArquivo7  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\14_appserver_coletor\appserver.ini'
	Private cArquivo8  := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\16_appserver_apontamento\appserver.ini'
	Private cArquivo9  := 'D:\TOTVS12\01-Oficial\Protheus\Bin\appserver\17_appserver_webcoL\appserver.ini'
	Private cArquivo10 := 'D:\TOTVS12\01-Oficial\Protheus\Bin\appserver\23_appserver_webcolMG\appserver.ini'
	Private cArquivo11 := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\03_appserver_slave01\appserver.ini'
	Private cArquivo12 := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\04_appserver_slave02\appserver.ini'
	Private cArquivo13 := 'D:\TOTVS12\01-Oficial\Protheus\bin\appserver\05_appserver_slave03\appserver.ini'
	Private cArquivo14 := 'D:\TOTVS12\01-Oficial\Protheus\Bin\appserver\17_appserver_webcol_validacao\appserver.ini'
	Private cArquivo15 := 'D:\TOTVS12\01-Oficial\Protheus\Bin\appserver\24_appserver_webcolMG_validacao\appserver.ini'
	Private nNumInis   := 15
	Private _cOrigem   := 'D:\TOTVS12\01-Oficial\Protheus\apo\Compila_Quente_VALIDACAO\tttp120.rpo'
	
	Private nNumRPOs

	If DtoS(Date()) <= '20210831'
		nNumRPOs   := 20
	Else
		nNumRPOs   := 2
	EndIf
	
	Private _cDestino  := 'D:\TOTVS12\01-Oficial\Protheus\apo\validacao\'
	Private cTxtAntRpo := '\APO\VALIDACAO\'

	For y := 1 to nNumInis
		cVariavel := 'cArquivo'+Alltrim(Str(y))
		If !File(&(cVariavel))
			cPutMV := '#' + cVariavel + " n„o encontrado"
			PutMV("XX_SERVERI",GetMv("XX_SERVERI") + cPutMV + Chr(10) )
			Return
		EndIf
	Next y

	// Arquivo 1
	c_buffer := space(N_BUFFER)
	H_ler    := fOpen(cArquivo1, 0)
	fRead(H_Ler,@c_Buffer,N_BUFFER)
	fClose(H_ler)

	nPosRpoOri := At(Upper(cTxtAntRpo),Upper(c_Buffer))+Len(cTxtAntRpo)

	cAPOOri  := Subs(c_Buffer,nPosRpoOri,6)
	cAPODest := StrZero(Val(Subs(c_Buffer,nPosRpoOri,6)) + 1,6)

	cPutMV := '(VALICA«√O)'
	PutMV("XX_SERVERI",GetMv("XX_SERVERI") + cPutMV + Chr(10) )

	cPutMV := '#' + "RPO "+cAPOOri + '=>' + cAPODest
	PutMV("XX_SERVERI",GetMv("XX_SERVERI") + cPutMV + Chr(10) )

	_cDestino += cAPODest
	MontaDir(_cDestino)
	_cDestino += '\tttp120.rpo'

	Copy File &_cOrigem To &_cDestino

	//Rename File &_cOrigem To &_cDestino
	//FRename( _cOrigem , _cDestino )
	//MontaDir(StrTran(_cOrigem,'tttp110.rpo',''))

	If !File(_cDestino)
		cPutMV := '#' + "N„o foi possÌvel copiar o arquivo destino: " + Chr(10) + _cDestino
		PutMV("XX_SERVERI",GetMv("XX_SERVERI") + cPutMV + Chr(10) )
		Return
	EndIf

	For y := 1 to nNumInis

		cVariavel := 'cArquivo'+Alltrim(Str(y))
		c_buffer := space(N_BUFFER)
		H_ler    := fOpen(&(cVariavel), 0)
		fRead(H_Ler,@c_Buffer,N_BUFFER)
		fClose(H_ler)

		// Validando se existe algum ambiente desatualizado
		For x := 1 to Len(c_Buffer)
			If UPPER(Subs(c_Buffer,x,Len(cTxtAntRpo))) == Upper(cTxtAntRpo)
				If Subs(c_Buffer,x+Len(cTxtAntRpo),6) <> cAPOOri //.and. Subs(c_Buffer,x+3,1) <> '\'
					cRpoErrado := Subs(c_Buffer,x+Len(cTxtAntRpo),6)
					cRpoCerto  := cAPOOri

					cPutMV := '#' + "ERRO!!! Ambiente:" + Chr(10) + &(cVariavel) + Chr(10)  + " com repositÛrio igual a " + cRpoErrado+" diferente de " + cRpoCerto + "." + Chr(10) + Chr(10) +"Rodar novamente"
					PutMV("XX_SERVERI",GetMv("XX_SERVERI") + cPutMV + Chr(10) )

					c_buffer := space(N_BUFFER)
					H_ler    := fOpen(&(cVariavel), 0)
					fRead(H_Ler,@c_Buffer,N_BUFFER)
					fClose(H_ler)

					c_Buffer := StrTran(c_Buffer,cRpoErrado,cRpoCerto)
					n_h := fCreate(&(cVariavel))
					fWrite(n_H,c_Buffer,Len(c_Buffer))
					fClose(n_H)

				EndIf
			EndIf
		Next x
	Next y

	// Alterando efetivamente os arquivos INI

	For y := 1 to nNumInis
		cVariavel := 'cArquivo'+Alltrim(Str(y))  // &(cVariavel)

		c_buffer := space(N_BUFFER)
		H_ler    := fOpen(&(cVariavel), 0)
		fRead(H_Ler,@c_Buffer,N_BUFFER)
		fClose(H_ler)

		c_Buffer := StrTran(c_Buffer,cTxtAntRpo+cAPOOri,cTxtAntRpo+cAPODest)
		n_h := fCreate(&(cVariavel))
		fWrite(n_H,c_Buffer,Len(c_Buffer))
		fClose(n_H)
	Next y

	// Depois dos arquivos alterados, validando para ter certeza que todos foram alterados.

	For y := 1 to nNumInis
		cVariavel := 'cArquivo'+Alltrim(Str(y))  // &(cVariavel)

		c_buffer := space(N_BUFFER)
		H_ler    := fOpen(&(cVariavel), 0)
		fRead(H_Ler,@c_Buffer,N_BUFFER)
		fClose(H_ler)

		// Confirmando se n„o ficou nenhum ambiente sem atualizar
		For x := 1 to Len(c_Buffer)
			If UPPER(Subs(c_Buffer,x,Len(cTxtAntRpo))) == Upper(cTxtAntRpo)
				If Subs(c_Buffer,x+Len(cTxtAntRpo),6) <> cAPODest //.and. Subs(c_Buffer,x+3,1) <> '\'
					cRpoErrado := Subs(c_Buffer,x+Len(cTxtAntRpo),6)
					cRpoCerto  := cAPODest

					cPutMV := '#' + "ERRO!!! Ambiente " + Chr(10) + &(cVariavel) + Chr(10)  + " n„o alterado. " + Chr(10) + "Verificar mai˙sculos/ninusculos " + cTxtAntRpo + Chr(10) + "Rodar novamente"
					PutMV("XX_SERVERI",GetMv("XX_SERVERI") + cPutMV + Chr(10) )


					c_buffer := space(N_BUFFER)
					H_ler    := fOpen(&(cVariavel), 0)
					fRead(H_Ler,@c_Buffer,N_BUFFER)
					fClose(H_ler)

					c_Buffer := StrTran(c_Buffer,cTxtAntRpo+cRpoErrado,cTxtAntRpo+cRpoCerto)
					n_h := fCreate(&(cVariavel))
					fWrite(n_H,c_Buffer,Len(c_Buffer))
					fClose(n_H)

				EndIf
			EndIf
		Next x
	Next y

	nPastaAtu := Val(cAPODest)
	For n := 1 to (nPastaAtu - nNumRPOs)
		cPasta     := Subs(_cDestino,1,Len(_cDestino)-Len('000001\tttp120.rpo')) + StrZero(n,6) + '\'
		cFileErase := Subs(_cDestino,1,Len(_cDestino)-Len('000001\tttp120.rpo')) + StrZero(n,6) + '\' + '\tttp120.rpo'

		If File( cFileErase )
			Ferase(cFileErase)
			If !File(cFileErase)
				DirRemove(cPasta)
			EndIf
		EndIf
	Next n

	cPutMV := '#' + "FIM"
	PutMV("XX_SERVERI",GetMv("XX_SERVERI") + cPutMV + Chr(10) )

Return

Static Function fIniAmbiente()

	If Type("cUsuario") == 'U'
		cRpcEmp    := "01"            // Cùdigo da empresa.
		cRpcFil    := "01"            // Cùdigo da filial.
		cEnvUser   := "Admin"         // Nome do usuùrio.
		cEnvPass   := "OpusDomex"     // Senha do usuùrio.
		cEnvMod    := "EST"           // 'FAT'  // Cùdigo do mùdulo.
		cFunName   := "U_VSERVERINI"   // 'RPC'  // Nome da rotina que serù setada para retorno da funùùo FunName().
		aTables    := {}              // {}     // Array contendo as tabelas a serem abertas.
		lShowFinal := .F.             // .F.    // Alimenta a variùvel publica lMsFinalAuto.
		lAbend     := .T.             // .T.    // Se .T., gera mensagem de erro ao ocorrer erro ao checar a licenùa para a estaùùo.
		lOpenSX    := .T.             // .T.    // SE .T. pega a primeira filial do arquivo SM0 quando nùo passar a filial e realiza a abertura dos SXs.
		lConnect   := .T.             // .T.    // Se .T., faz a abertura da conexao com servidor As400, SQL Server etc

		//RPCSetType(3)
		RpcSetEnv(cRpcEmp,cRpcFil,cEnvUser,cEnvPass,cEnvMod,cFunName,aTables,lShowFinal,lAbend,lOpenSX,lConnect) //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
	EndIf
Return

// Static Function fProcessa()
// 	Local cCommand := "D:\TOTVS12\01-Oficial\Protheus\Bin\smartclient\smartclient.exe -q -p=u_VCompQuent -a=R -c=TI -e=compila_quente -m -l"
// 	Local lWait    := .T.
// 	Local cPath    := "D:\TOTVS12\01-Oficial\Protheus\Bin\smartclient\"

// 	WaitRunSrv( @cCommand , @lWait , @cPath )

// Return
