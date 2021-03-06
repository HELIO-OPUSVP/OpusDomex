#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010TOK   �Autor  �Helio Ferreira      � Data �  31/08/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tudo Ok do cadastro de Produtos                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function A010TOK()

	Local _Retorno := .T.

	If Empty(M->B1_TIPO)
		MsgStop("Favor preencher o tipo do produto para continuar")
	Else
		If M->B1_TIPO == 'FP'
			cConta := '110309000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta)
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'MA'
			cConta  :=  '110312000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'MC'
			cConta :=  '110303000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'ME'
			cConta :=  '110310000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'MP'
			cConta :=  '110301000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'MS'
			cConta :=  '110302000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'PA'
			cConta :=  '110307000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		//If Inclui
		//	If M->B1_TIPO == 'PA'
		//		If Empty(M->B1_BASE)
		//			If !SubStr(M->B1_SUBCLAS,1,8) $ GetMv("MV_XB1CLAS")
		//				MsgStop("Para produtos do tipo PA � obrigat�rio utilizar a estrutura de c�digos inteligentes." )
		//				_Retorno := .F.
		//			EndIf
		//		EndIf
		//	EndIf
		//EndIf

		If _Retorno
			If Inclui
				If M->B1_TIPO == 'PA'
					If SubStr(M->B1_SUBCLAS,1,8) $ GetMv("MV_XB1CLAS")
						//Para algumas subclasse n�o ser� feito o controle de c�digo autom�tico
						_Retorno := .T.
					Else
						If Empty(M->B1_BASE)
							MsgStop("Para produtos do tipo PA � obrigat�rio utilizar a estrutura de c�digos inteligentes." )
							_Retorno := .F.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'PI'
			cConta :=  '110305000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf

		If M->B1_TIPO == 'PR'
			cConta :=  '110311000000'
			If Empty(M->B1_CONTA)
				MsgStop("Favor preencher a conta cont�bil do produto com: " + cConta )
				_Retorno := .F.
			Else
				If Alltrim(M->B1_CONTA) <> cConta
					MsgStop("Conta cont�bil inv�lida para produto tipo "+M->B1_TIPO+". Conta correta: " + cConta )
					_Retorno := .F.
				EndIf
			EndIf
		EndIf
	EndIf

Return _Retorno
