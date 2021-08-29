#Include "Protheus.ch"

User Function A250ARD4()
Local aArea   		   := GetArea()	// Salva area atual para posterior restauracao
Local aItensSD4		:=	ParamIXB    //-- Array com os itens a serem processados
Local aRetSD4      	:=	aItensSD4   //-- Array que ira retornar as alterações processadas pelo cliente
Local aAliasSD4		:=	SD4->(GetArea())
Local lQuantOK		   :=	.F.
Local nSaldoEmp		:=	0
Local nPercPrM	      := 0
Local x


/*
Estrutura do ParamixB

			AADD(aArraySD4[Len(aArraySD4)],{	SD4->(Recno()),;														//01
												A250PotMax(SD4->D4_COD,SD4->D4_POTENCI,SD4->D4_QUANT + (SD4->D4_QTDEORI * nPercPrM),nDecSD4),;			//02
												SD4->D4_COD,;															//03
												SD4->D4_LOCAL,;															//04
												SD4->D4_TRT,;															//05
												SD4->D4_OPORIG,;      													//06
												A250PotMax(SD4->D4_COD,SD4->D4_POTENCI,SD4->D4_QUANT + (SD4->D4_QTDEORI * nPercPrM),nDecSD4),;			//07
												DTOS(SD4->D4_DTVALID),;													//08
												SD4->D4_LOTECTL,;														//09
												SD4->D4_NUMLOTE,;														//10
												SD4->D4_OP,;															//11
												A250PotMax(SD4->D4_COD,SD4->D4_POTENCI,SD4->D4_QTDEORI + (SD4->D4_QTDEORI * nPercPrM),nDecSD4),;		//12
												A250PotMax(SD4->D4_COD,SD4->D4_POTENCI,	SD4->D4_QTSEGUM + (SD4->D4_QTDEORI * nPercPrM),nDecSD4),; 		//13
												SD4->D4_POTENCI})														//14

*/

For x := 1 To Len(aRetSD4[1])
	If Rastro(aRetSD4[1,x,3])
		aRetSD4[1,x,9] := U_RetLotC6(aRetSD4[1,x,11])
	EndIf
Next x

/*
nSaldoEmp := SH6->H6_QTDPROD

IF !Empty(SC2->C2_PEDIDO) //Se não Tiver Pedido de Venda, eh OP da Fabrica
	IF Len(aItensSD4[1]) > 1
		For nA := 1 To Len(aItensSD4[1])
			SD4->(dbGoTo(aItensSD4[1,nA,1]))      //Recno do SD4
			IF !Empty(SD4->D4_XPICK)
				IF !lQuantOK
					IF (SD4->D4_QUANT - nSaldoEmp ) > 0
						lQuantOK := .T.
						aRetSD4[1][nA][2] := nSaldoEmp
					Else
						lQuantOK := .F.
						nSaldoEmp 			:= nSaldoEmp - SD4->D4_QUANT
					EndIF
				Else
					lQuantOK := .T.
					aRetSD4[1][nA][2] := 0
				EndIF
			EndIF
		Next nA
	EndIF

EndIF
*/

RestArea(aAliasSD4)
RestArea(aArea)

Return aRetSD4
