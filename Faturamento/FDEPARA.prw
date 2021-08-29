#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FDEPARA   �Autor  �Helio Ferreira      � Data �  23/02/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o chamada do bot�o da enchoice de Pedidos de Venda    ���
���          � para atualizar informa��es do pedido na tabela SZU a serem ���
���          � impressas em etiquetas personalizadas (tabela SZU)         ���
�������������������������������������������������������������������������͹��
���Uso       � DOMEX                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function FDEPARA()
Local lOk  := .T.
Local lRet := .T.

/*
cGetFile ( [ cMascara], [ cTitulo], [ nMascpadrao], [ cDirinicial], [ lSalvar], [ nOpcoes], [ lArvore], [ lKeepCase] ) --> cRet

Par�metros/Elementos

cMascara 	Caracter	Indica o nome do arquivo ou m�scara.
cTitulo	   Caracter	Indica o t�tulo da janela. Caso o par�metro n�o seja especificado, o t�tulo padr�o ser� apresentado.
nMascpadrao	Num�rico	Indica o n�mero da m�scara.
cDirinicial	Caracter	Indica o diret�rio inicial.
lSalvar	   L�gico	Indica se � um "save dialog" ou um "open dialog".
nOpcoes	   Num�rico	Indica a op��o de funcionamento. Para mais informa��es das funcionalidades dispon�veis, consulte a �rea Observa��es.
lArvore	   L�gico	Indica se, verdadeiro (.T.), apresenta o �rvore do servidor; caso contr�rio, falso (.F.).
lKeepCase	L�gico	Indica se, verdadeiro (.T.), mant�m o case original; caso contr�rio, falso (.F.).

GETF_HIDDENDIR (256)*	Mostra arquivos e pastas ocultas
GETF_LOCALFLOPPY (8)	   Apresenta a unidade do disquete da m�quina local.
GETF_LOCALHARD (16)	   Apresenta a unidade do disco local.
GETF_MULTISELECT (2)	   Compatibilidade.
GETF_NETWORKDRIVE (32)	Apresenta as unidades da rede (mapeamento).
GETF_NOCHANGEDIR (4)	   N�o permite mudar o diret�rio inicial.
GETF_RETDIRECTORY (128)	Retorna/apresenta um diret�rio.
GETF_SHAREWARE (64)	   N�o implementado.
GETF_SYSDIR (512)*    	Mostra arquivos e pastas do sistema
*/

If apMsgYesNo("Deseja importar um arquivo com informa��es para emiss�o de etiquetas?")
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
		
		// Validando a exist�ncia dos itens do Pedido
		If lRet
			SC6->( dbSetOrder(1) )
			For x := 1 to Len(aArquivo)
				If x <> 1
					If !SC6->( dbSeek( xFilial() + cNumPed + StrZero(Val(aArquivo[x,2]),2) ) )
						MsgStop("Numero item do Pedido da Linha " + Alltrim(Str(x)) + " igual a '" + StrZero(Val(aArquivo[x,2]),2) + "' n�o encontrado ou n�o salvo.")
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
			// Comparando os c�digos de Produto
			For x := 1 to Len(aVetQTD)
				If SC6->( dbSeek( xFilial() + cNumPed + aVetQTD[x,1] ) )
					If Alltrim(SC6->C6_PRODUTO) <> aVetQTD[x,3]
						MsgStop("C�digo de produto do arquivo referente ao item '"+Alltrim(Str(aVetQTD[x,3]))+"' diferente do c�digo do Pedido " + Alltrim(SC6->C6_PRODUTO) + ".")
						lRet := .F.
						Exit
					EndIf
				EndIf
			Next x
			
		EndIf
		
		// Validando se j� n�o existe informa��es j� gravadas para o pedido com c�digo de produto diferente
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
									MsgStop("C�digo de produto do item '"+StrZero(Val(aArquivo[x,2]),2)+"' do Pedido '"++"' arquivo " + aArquivo[x,3] + " )
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
			MsgInfo("Importa��o abortada.")
		EndIf
	Else
		MsgStop('Importa��o abortada.')
	EndIf
EndIf

Return


