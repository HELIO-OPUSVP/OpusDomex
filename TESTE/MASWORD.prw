User Function MASWORD

Local cArquivo := "C:\ALL\docteste.dotx"

//Cria um ponteiro e j� chama o arquivo
nHandWord := OLE_CreateLink()
OLE_NewFile(nHandWord, cArquivo) //cArquivo deve conter o endere�o que o dot est� na m�quina, por exemplo, C:\arquivos_dot\teste.dotx
 
//Setando o conte�do das DocVariables
OLE_SetDocumentVar(nHandWord, "VarTeste", dToC(Date()) + " - " + Time() + " AAAAA")
 
//Atualizando campos
OLE_UpdateFields(nHandWord)
 
//Monstrando um alerta
MsgAlert('O arquivo gerado foi <b>Salvo</b>?<br>Ao clicar em OK o Microsoft Word ser� <b>fechado</b>!','Aten��o')
 
//Fechando o arquivo e o link
OLE_CloseFile(nHandWord)      


OLE_CloseLink(nHandWord) 


Return