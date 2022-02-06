#Include "rwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410AGRV  ºAutor  ³Osmar Ferreira      º Data ³  02/02/22   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada antes da gração do Pedido de Venda        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function M410AGRV()
	Local x
	Local lMudou := .F.
	Local nOpcao := PARAMIXB[1]
	Local aAreaGeral := GetArea()
	Local aAreaSC6   := SC6->( GetArea() )
	Local aAreaZZF   := ZZF->( GetArea() )

	If nOpcao = 2   //Alteração
		nPC6_ITEM    := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ITEM" } )
		nPC6_PRCVEN  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRCVEN" } )
		nPC6_XMARGEM := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XMARGEM" } )

		SC6->( dbSetOrder(01) )
		For x:= 1 To Len(aCols)

			If SC6->( dbSeek(xFilial() + M->C5_NUM + aCols[x,nPC6_ITEM]) )				
				If aCols[x,nPC6_PRCVEN] <> SC6->C6_PRCVEN .Or. aCols[x,nPC6_XMARGEM] <> SC6->C6_XMARGEM
					lMudou := .T.  //Houve alteração no preço
				EndIf
            Else
                lMudou := .T.  //Foi inlcuido um novo item
			EndIf
		Next x

		//Gravar para controle de envio de email caso tenha mudado o preço/margem
		If ZZF->( dbSeek(xFilial()+"MRG" + M->C5_NUM + aCols[1,nPC6_ITEM]) )
			RecLock("ZZF",.f.)
		Else
			RecLock("ZZF",.t.)
		EndIf
		ZZF->ZZF_FILIAL := xFilial("ZZF")
		ZZF->ZZF_ORIGEM	:= "MRG"
		ZZF->ZZF_NUMERO	:= M->C5_NUM 
		ZZF->ZZF_ITEM 	:= aCols[1,nPC6_ITEM]
		ZZF->ZZF_COD    := ""
		ZZF->ZZF_DATA   := dDataBase
		If lMudou
			ZZF->ZZF_STACUS	:= "T"
			ZZF->ZZF_OBS    := "Mudou a Margem"
		Else
			ZZF->ZZF_STACUS	:= "F"
			ZZF->ZZF_OBS    := "Não Mudou a Margem"
		EndIf
		ZZF->ZZF_HORA   := Time()
		ZZF->( msUnLock() )

	EndIf

	RestArea(aAreaZZF)
	RestArea(aAreaGeral)
	RestArea(aAreaSC6)

Return
