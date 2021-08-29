#include "rwmake.ch" 
        
User Function DOMROM01()  

Private cPedido := "      "
Private cItem	:= Space(2)            

@ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
@ 08,005 TO 053,190
@ 18,010 SAY OemToAnsi("Impressao de romaneio de obra")
@ 28,010 SAY OemToAnsi("Pedido:")
@ 28,040 GET cPedido PICTURE "@!" VALID ValidPedido(cPedido) F3 "SC5" SIZE 70,10 
@ 40,010 SAY OemToAnsi("Item:")
@ 40,040 GET cItem PICTURE "@!" Valid ValidItem(cPedido,cItem) SIZE 30,10
 
@ 56,130 BMPBUTTON TYPE 1 ACTION MsgRun("Gerando documento WORD","Processando",{|| WordImp(cPedido,cItem) })
@ 56,160 BMPBUTTON TYPE 2 ACTION Close(oDlg)
 
ACTIVATE DIALOG oDlg CENTERED
 
Return() 

Static Function ValidPedido(cPedido)

Local lRet := .T.

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
If SC5->(!DbSeek(xFilial("SC5")+cPedido))      
	Alert("Pedido Inexistente") 
	lRet := .F.
EndIf


Return     lRet   

Static Function ValidItem(cPedido,cItem)

Local lRet := .T.

DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	If SC6->(!DbSeek(xFilial("SC6")+AvKey(cPedido,"C6_NUM")+AvKey(cItem,"C6_ITEM")))     
		Alert("Item Inexistente")    
		lRet := .F.
	Else
		If Empty(SC6->C6_NOTA)
			Alert("Item nao faturado")
			lRet := .F.
		EndIf	
	EndIf


Return     lRet
 
Static Function WordImp(cPedido,cItem)  

Local cPathDot             := "\SYSTEM\DOT\ROMANEIO.DOT"
Local cItens := ""
local cOp := ""

Private      hWord
 
Close(oDlg)
                    
DbSelectArea("SC5")
SC5->(DbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+cPedido)) 

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbSeek(xFilial("SC6")+AvKey(cPedido,"C6_NUM")+AvKey(cItem,"C6_ITEM")))     
	
	cOp := AllTrim(SC6->C6_NUMOP + SC6->C6_ITEMOP + "001")
	If Empty(cOp)                                  
		Alert("Pedido sem OP vinculada")
		Return
	EndIf 
	
	cTempPath := GetTempPath()
	CpyS2T( cPathDot, cTempPath )
	  
	//Conecta ao word
	hWord  := OLE_CreateLink()
	OLE_NewFile(hWord, cTempPath + "\ROMANEIO.DOT" )
	 Alert(AllTrim(SC6->C6_NOTA))
	//Montagem das variaveis do cabecalho         
	OLE_SetDocumentVar(hWord, 'c_Pedido', cPedido)
	OLE_SetDocumentVar(hWord, 'c_Produto', AllTrim(SC6->C6_PRODUTO) + "-" + AllTrim(SC6->C6_DESCRI))
	OLE_SetDocumentVar(hWord, 'c_NotaFiscal', AllTrim(SC6->C6_NOTA))
	OLE_SetDocumentVar(hWord, 'c_Cliente', Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"))
	
	DbSelectArea("SD4")
	SD4->(DbSetOrder(2))
	SD4->(DbSeek(xFilial("SD4")+cOp))
	
	While SD4->(!Eof()) .and. AllTrim(SD4->D4_OP) == cOp
	//
		cItens += "(" + AllTrim(Str(SD4->D4_QTDEORI)) + " " + AllTrim(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_UM")) + ") " + AllTrim(SD4->D4_COD) + " - " + AllTrim(Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC")) + Chr(13)
		SD4->(DbSkip())
	endDo
	
	OLE_SetDocumentVar(hWord, 'cItens',cItens)   //variavel para identificar o numero total de linhas na parte variavel
	//Sera utilizado na macro do documento para execucao do for next
	 
	            
	OLE_UpdateFields(hWord)    // Atualizando as variaveis do documento do Word
	
	Alert("Documento WORD Criado com sucesso, salve o arquivo e apos este processo finalize a comunicacao entre WORD e Protheus fechando esta janela.")
	           
       OLE_CloseFile( hWord )
       OLE_CloseLink( hWord )

EndIf
	
Return()