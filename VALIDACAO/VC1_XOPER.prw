#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
���Programa  �VC1_XOPER �Autor  �Helio/Marco Aurelio � Data �  23/06/21   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o do campo C1_XOPER                                ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Rosenberger                                                ���
�����������������������������������������������������������������������������
*/

User Function VC1_XOPER()
	Local _Retorno := .T.
	Local nPC1_PRODUTO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C1_PRODUTO" })

	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek( xFilial() + aCols[N,nPC1_PRODUTO] ) )

		//Opera��o 01 (INDUSTRIALIZA��O) considerar PNs somente tipo MP/MS/ME
		//Opera��o 02 (REVENDA) considerar PNs somente tipo PR
		//Opera��o 03 (USO E CONSUMO) considerar PNs somente tipo MC
		//Opera��o 04 (ATIVO IMOBILIZADO) considerar PNs somente tipo AT / FP
		//Opera��o 05 (SERVI�OS) considerar PNs somente tipo SV

		If M->C1_XOPER == '01'
			If !(SB1->B1_TIPO $ "MP/MS/ME")
				apMsgInfo("A opera��o 01 s� � permitida para Produtos tipo MP/MS/ME")
				_Retorno := .F.
			EndIf
		EndIf


		If M->C1_XOPER == '02'
			If !(SB1->B1_TIPO $ "PR")
				apMsgInfo("A opera��o 02 s� � permitida para Produtos tipo PR")
				_Retorno := .F.
			EndIf
		EndIf

		If M->C1_XOPER == '03'
			If !(SB1->B1_TIPO $ "MC")
				apMsgInfo("A opera��o 03 s� � permitida para Produtos tipo MC")
				_Retorno := .F.
			EndIf
		EndIf

		If M->C1_XOPER == '04'
			If !(SB1->B1_TIPO $ "AT/FP")
				apMsgInfo("A opera��o 04 s� � permitida para Produtos tipo AT/FP")
				_Retorno := .F.
			EndIf
		EndIf

		If M->C1_XOPER == '05'
			If !(SB1->B1_TIPO $ "SV")
				apMsgInfo("A opera��o 05 s� � permitida para Produtos tipo SV")
				_Retorno := .F.
			EndIf
		EndIf

	Else
		If Empty(aCols[N,nPC1_PRODUTO])
			_Retorno := .F.
			MsgStop("Favor preencher o produto antes da opera��o")
		Else
			_Retorno := .F.
			MsgStop("Produto inv�lido")
		EndIf
	EndIf

Return _Retorno
