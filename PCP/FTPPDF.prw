
#INCLUDE "protheus.ch"
//#INCLUDE "tlpp-core.th"


User Function FTPPDF()
Local oFtp, nStat
Local cFtpSrv := "10.62.28.114"
Local nFTPPort := 22
//local aFiles, cErrorMsg := ''


// Cria o objeto Client
oFtp := tFtpClient():New()
oFtp:Close()
oFtp:bFireWallMode     := .T.
oFtp:bUsesIPConnection := .T. //Pega o IP da interface de rede que estabeleceu a cominuca��o 
oFtp:nControlPort      := 22   //Define a porta padr�o
oFtp:nConnectTimeOut   := 5

// Estabelece a conex�o com o FTP Server 
nStat := oFtp:FtpConnect(cFtpSrv,nFTPPort, "ondati", "Ondati2022!@")

If nStat != 0
	Alert("Erro na conex�o....  "+Str(nStat)+" - "+oFtp:cErrorString)
Else
	Alert("Conectou....")
Endif

oFtp:Close()


/*
aFiles := SFTPDirLS(cFtpSrv, "/home/ondati/public_html","ondati", "Ondati2022!@", @cErrorMsg)
If ( valtype(aFiles) != 'A' )
    Alert("Falha na execu��o : Erro "+cErrorMsg)
Else
	Alert(Len(aFiles))	
Endif
*/


/*
	If !FTPCONNECT( "10.62.28.114" , 22 ,"ondati", "Ondati2022!@",.t. )
		Alert( "Nao foi possivel se conectar!!" )
	Else
		Alert( "Conectado ao servidor!!" )
	
		If FTPDISCONNECT()
			Alert("Desconectado do servidor....")
		Else
			Alert("N�o estava conectado ao servidor....")
		EndIf
	EndIf
*/	

Return Nil



/*
Local oFtp, nStat
Local cFtpSrv := "10.62.28.114"
Local nFTPPort := 22

// Cria o objeto Client
oFtp := tFtpClient():New()

// Estabelece a conex�o com o FTP Server 
nStat := oFtp:FtpConnect(cFtpSrv,nFTPPort, "ondati", "Ondati2022!@")

Alert(nStat)

If nStat != 0
	Alert("Erro....")
 
else
	Alert("Conectou....")
Endif

oFtp:Close()
*/

