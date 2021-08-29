#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³VC1_XOPER ºAutor  ³Helio/Marco Aurelio º Data ³  23/06/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação do campo C1_XOPER                                º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rosenberger                                                º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VC1_XOPER()
	Local _Retorno := .T.
	Local nPC1_PRODUTO := aScan(aHeader,{ |aVet| Alltrim(aVet[2]) == "C1_PRODUTO" })

	SB1->( dbSetOrder(1) )
	If SB1->( dbSeek( xFilial() + aCols[N,nPC1_PRODUTO] ) )

		//Operação 01 (INDUSTRIALIZAÇÃO) considerar PNs somente tipo MP/MS/ME
		//Operação 02 (REVENDA) considerar PNs somente tipo PR
		//Operação 03 (USO E CONSUMO) considerar PNs somente tipo MC
		//Operação 04 (ATIVO IMOBILIZADO) considerar PNs somente tipo AT / FP
		//Operação 05 (SERVIÇOS) considerar PNs somente tipo SV

		If M->C1_XOPER == '01'
			If !(SB1->B1_TIPO $ "MP/MS/ME")
				apMsgInfo("A operação 01 só é permitida para Produtos tipo MP/MS/ME")
				_Retorno := .F.
			EndIf
		EndIf


		If M->C1_XOPER == '02'
			If !(SB1->B1_TIPO $ "PR")
				apMsgInfo("A operação 02 só é permitida para Produtos tipo PR")
				_Retorno := .F.
			EndIf
		EndIf

		If M->C1_XOPER == '03'
			If !(SB1->B1_TIPO $ "MC")
				apMsgInfo("A operação 03 só é permitida para Produtos tipo MC")
				_Retorno := .F.
			EndIf
		EndIf

		If M->C1_XOPER == '04'
			If !(SB1->B1_TIPO $ "AT/FP")
				apMsgInfo("A operação 04 só é permitida para Produtos tipo AT/FP")
				_Retorno := .F.
			EndIf
		EndIf

		If M->C1_XOPER == '05'
			If !(SB1->B1_TIPO $ "SV")
				apMsgInfo("A operação 05 só é permitida para Produtos tipo SV")
				_Retorno := .F.
			EndIf
		EndIf

	Else
		If Empty(aCols[N,nPC1_PRODUTO])
			_Retorno := .F.
			MsgStop("Favor preencher o produto antes da operação")
		Else
			_Retorno := .F.
			MsgStop("Produto inválido")
		EndIf
	EndIf

Return _Retorno
