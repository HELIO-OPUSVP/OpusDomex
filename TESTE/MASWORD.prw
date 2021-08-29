User Function MASWORD

Local cArquivo := "C:\ALL\docteste.dotx"

//Cria um ponteiro e já chama o arquivo
nHandWord := OLE_CreateLink()
OLE_NewFile(nHandWord, cArquivo) //cArquivo deve conter o endereço que o dot está na máquina, por exemplo, C:\arquivos_dot\teste.dotx
 
//Setando o conteúdo das DocVariables
OLE_SetDocumentVar(nHandWord, "VarTeste", dToC(Date()) + " - " + Time() + " AAAAA")
 
//Atualizando campos
OLE_UpdateFields(nHandWord)
 
//Monstrando um alerta
MsgAlert('O arquivo gerado foi <b>Salvo</b>?<br>Ao clicar em OK o Microsoft Word será <b>fechado</b>!','Atenção')
 
//Fechando o arquivo e o link
OLE_CloseFile(nHandWord)      


OLE_CloseLink(nHandWord) 


Return