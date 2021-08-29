#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FDEPARA   ºAutor  ³Helio Ferreira      º Data ³  23/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada do botão da enchoice de Pedidos de Venda    º±±
±±º          ³ para atualizar informações do pedido na tabela SZU a serem º±±
±±º          ³ impressas em etiquetas personalizadas (tabela SZU)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DOMEX                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FDEPARA()
Local lOk  := .T.
Local lRet := .T.

/*
cGetFile ( [ cMascara], [ cTitulo], [ nMascpadrao], [ cDirinicial], [ lSalvar], [ nOpcoes], [ lArvore], [ lKeepCase] ) --> cRet

Parâmetros/Elementos

cMascara 	Caracter	Indica o nome do arquivo ou máscara.
cTitulo	   Caracter	Indica o título da janela. Caso o parâmetro não seja especificado, o título padrão será apresentado.
nMascpadrao	Numérico	Indica o número da máscara.
cDirinicial	Caracter	Indica o diretório inicial.
lSalvar	   Lógico	Indica se é um "save dialog" ou um "open dialog".
nOpcoes	   Numérico	Indica a opção de funcionamento. Para mais informações das funcionalidades disponíveis, consulte a área Observações.
lArvore	   Lógico	Indica se, verdadeiro (.T.), apresenta o árvore do servidor; caso contrário, falso (.F.).
lKeepCase	Lógico	Indica se, verdadeiro (.T.), mantém o case original; caso contrário, falso (.F.).

GETF_HIDDENDIR (256)*	Mostra arquivos e pastas ocultas
GETF_LOCALFLOPPY (8)	   Apresenta a unidade do disquete da máquina local.
GETF_LOCALHARD (16)	   Apresenta a unidade do disco local.
GETF_MULTISELECT (2)	   Compatibilidade.
GETF_NETWORKDRIVE (32)	Apresenta as unidades da rede (mapeamento).
GETF_NOCHANGEDIR (4)	   Não permite mudar o diretório inicial.
GETF_RETDIRECTORY (128)	Retorna/apresenta um diretório.
GETF_SHAREWARE (64)	   Não implementado.
GETF_SYSDIR (512)*    	Mostra arquivos e pastas do sistema
*/

If apMsgYesNo("Deseja importar um arquivo com informações para emissão de etiquetas?")
	cCaminho := 'C:\                                                                                   '
	cArquivo := cGetFile( '*.csv|*.csv' ,'Informe o arquivo .csv a ser importado', 1, 'C:\'   , .T., nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY ),.F., .T. )
	If !Empty(cArquivo)
		
		aArquivo := U_CSVTOVET(cArquivo)
		
		// Validando o numero do Pedido
		If lRet
			For x := 1 to Len(aArquivo)
				If x <> 1
					If aArquivo[x,1] <> SC5->C5_NUM
						MsgStop("Numero de Pedido da Linha " + Alltrim(Str(x)) + " igual a '" + aArquivo[x,1] + "' difrente do Pedido '"+SC5->C5_NUM+"' posicionado.")
						lRet := .F.
						Exit
					Else
						cNumPed := aArquivo[x,1]
					EndIf
				EndIf
			Next x
		EndIf
		
		// Validando a existência dos itens do Pedido
		If lRet
			SC6->( dbSetOrder(1) )
			For x := 1 to Len(aArquivo)
				If x <> 1
					If !SC6->( dbSeek( xFilial() + cNumPed + StrZero(Val(aArquivo[x,2]),2) ) )
						MsgStop("Numero item do Pedido da Linha " + Alltrim(Str(x)) + " igual a '" + StrZero(Val(aArquivo[x,2]),2) + "' não encontrado ou não salvo.")
						lRet := .F.
						Exit
					EndIf
				EndIf
			Next x
		EndIf
		
		// Validando a quantidade de linhas do array para as quantidades do C6_QTDVEN
		If lRet
			aVetQTD := {}
			SC6->( dbSetOrder(1) )
			For x := 1 to Len(aArquivo)
				If x <> 1
					If SC6->( dbSeek( xFilial() + cNumPed + StrZero(Val(aArquivo[x,2]),2) ) )
						nTemp := aScan(aVetQTD,{ |aVet| aVet[1] == StrZero(Val(aArquivo[x,2]),2) })
						If Empty(nTemp)
							AADD(aVetQTD,{StrZero(Val(aArquivo[x,2]),2),1,Alltrim(aArquivo[x,3])})
						Else
							aVetQTD[nTemp,2] += 1
						EndIF
					EndIf
				EndIf
			Next x
			// Comparando as quantidades
			For x := 1 to Len(aVetQTD)
				If SC6->( dbSeek( xFilial() + cNumPed + aVetQTD[x,1] ) )
					If SC6->C6_QTDVEN <> aVetQTD[x,2]
						MsgStop("Quantidade de linhas do arquivo referente ao item '"+Alltrim(Str(aVetQTD[x,2]))+"' diferente da quantidade do pedido " + Alltrim(Str(SC6->C6_QTDVEN)) + ".")
						lRet := .F.
						Exit
					EndIf
				EndIf
			Next x
			// Comparando os códigos de Produto
			For x := 1 to Len(aVetQTD)
				If SC6->( dbSeek( xFilial() + cNumPed + aVetQTD[x,1] ) )
					If Alltrim(SC6->C6_PRODUTO) <> aVetQTD[x,3]
						MsgStop("Código de produto do arquivo referente ao item '"+Alltrim(Str(aVetQTD[x,3]))+"' diferente do código do Pedido " + Alltrim(SC6->C6_PRODUTO) + ".")
						lRet := .F.
						Exit
					EndIf
				EndIf
			Next x
			
		EndIf
		
		// Validando se já não existe informações já gravadas para o pedido com código de produto diferente
		/*
		If lRet
			SC6->( dbSetOrder(1) )
			SZU->( dbSetOrder(1) )
			For x := 1 to Len(aArquivo)
				If x <> 1
					If SC6->( dbSeek( xFilial() + cNumPed + StrZero(Val(aArquivo[x,2]),2) ) )
						If SZU->( dbSeek( xFilial() + cNumPed + StrZero(Val(aArquivo[x,2]),2) ) )
							While !SZU->( EOF() ) .and. SZU->ZU_PEDIDO == cNumPed .and. SZU->ZU_ITEM == StrZero(Val(aArquivo[x,2]),2)
								If SZU->ZU_PRODUTO <> aArquivo[x,3]
									MsgStop("Código de produto do item '"+StrZero(Val(aArquivo[x,2]),2)+"' do Pedido '"++"' arquivo " + aArquivo[x,3] + " )
								EndIf
								SZU->( dbSkip() )
							End
						EndIf
					EndIf
				EndIf
			Next x
		EndIf
		*/
		
		If !lRet
			MsgInfo("Importação abortada.")
		EndIf
	Else
		MsgStop('Importação abortada.')
	EndIf
EndIf

Return


