
#INCLUDE "protheus.ch"
//#INCLUDE "tlpp-core.th"


User Function FTPPDF()
	Local oFtp, nStat
	Local cFtpSrv := "10.62.28.114"
	Local nFTPPort := 21
	Local aRetDir := {}
//local aFiles, cErrorMsg := ''


// Cria o objeto Client
	oFtp := tFtpClient():New()
	oFtp:Close()
	oFtp:bFireWallMode     := .T.
	oFtp:bUsesIPConnection := .T. //Pega o IP da interface de rede que estabeleceu a cominucação
	oFtp:nControlPort      := 21   //Define a porta padrão
	oFtp:nConnectTimeOut   := 5

// Estabelece a conexão com o FTP Server 
	nStat := oFtp:FtpConnect(cFtpSrv,nFTPPort, "ondati", "Ondati2022!@")

	If nStat != 0
		Alert("Erro na conexão....  "+Str(nStat)+" - "+oFtp:cErrorString)
	Else
		Alert("Conectou no servidor!!!....")
	Endif


	nRet := oFtp:ChDir( "/home/ondati/public_html" )
	If nRet <> 0
		Alert( "Nao foi possível modificar diretório!!" )
	else
		Alert(nRet)	
	EndIf


	aRetDir := oFtp:DIRECTORY( "*.*" , .F.)
	If !Empty(aRetDir)
		Alert(aRetDir[1][1])   
	Else	   
	   Alert('Vazio sem arquivos.....')
	EndIf

	

	oFtp:Close()


	


/*
	If !FTPCONNECT( "10.62.28.114" , 22 ,"ondati", "Ondati2022!@",.t. )
		Alert( "Nao foi possivel se conectar!!" )
	Else
		Alert( "Conectado ao servidor!!" )
	
		If FTPDISCONNECT()
			Alert("Desconectado do servidor....")
		Else
			Alert("Não estava conectado ao servidor....")
		EndIf
	EndIf
*/	

Return Nil

/*
	#INCLUDE "protheus.ch"
	#DEFINE DEFAULT_FTP 21
	#DEFINE PATH "\teste\"
Function TestFTP()
	Local aRetDir := {}
	//Tenta se conectar ao servidor ftp em localhost na porta 21
	//com usuário e senha anônimos
	if !FTPCONNECT( "localhost" , 21 ,"Anonymous", "test@test.com" )
		conout( "Nao foi possível se conectar!!" )
		Return NIL
	EndIf
	//Tenta mudar do diretório corrente ftp, para o diretório
	//especificado como parâmetro
	if !FTPDIRCHANGE( "/test" )
		conout( "Nao foi possível modificar diretório!!" )
		Return NIL
	EndIf
	//Retorna apenas os arquivos contidos no local
	aRetDir := FTPDIRECTORY( "*.*" , )
	//Retorna os diretórios e arquivos contidos no local   	//
	aRetDir := FTPDIRECTORY( "*.*" , "D")
	//Verifica se o array está vazio
	If Empty( aRetDir )
		conout( "Array Vazio!!" )
		Return NIL
	EndIf
Return

*/
