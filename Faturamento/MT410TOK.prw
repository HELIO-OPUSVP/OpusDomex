#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "AP5MAIL.CH"
#include "rwmake.ch"



/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅMT410TOK  пїЅAutor  пїЅJuliano F. da Silva пїЅ Data пїЅ  04/05/11   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ Ponto entrada utilizado para tratar os dados de pedidos    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ de venda para exportaпїЅпїЅo                                   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function MT410TOK()

	Local aAreaGER    := GetArea()
	Local aAreaSA1    := SA1->( GetArea() )
	Local aAreaSC5    := SC5->( GetArea() )
	Local aAreaSC2    := SC2->( GetArea() )
	Local aAreaSC6    := SC2->( GetArea() )
	Local aAreaSB1	   := SB1->( GetArea() )
	Local aAreaZFM	   := ZFM->( GetArea() )
	Local lValid      :=.F.
	Local cQuery      := ""
	Local nPos        := aScan(aHeader,{ |X| X[2] == "C6_BLQ    " } )//:= //AScan( aHeader, {|x| x[2] == "EG2_RATE"  } )
	Local _Retorno    :=.T.
	Local nPC6_ITEM   := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ITEM"    } )
	Local nPC6PRODUTO := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
	Local nPC6PRCVEN  := aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRCVEN"  } )
	Local _lContrib	:= .T.
	Local lGenerica			//Tabela de venda generica / padrгo
	Local lValTabVen  := .f.
	Local nPrMaximo   := 0	//Preзo mбximo
	Local nPrMinimo   := 0	//Preзo mнnimo
	Local _nx, nx, x, nq
	//Local lValTES	:= .F.

	If M->C5_TIPO == "N"
		DbSelectArea("SA1")
		DbSetOrder(1)
		If MsSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJAENT)
			If SA1->A1_EST =="EX"
				lValid := .T.
			EndIf
		EndIf
	EndIf

	If M->C5_TIPO == "B"
		DbSelectArea("SA2")
		DbSetOrder(1)
		If MsSeek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJAENT)
			If SA2->A2_EST =="EX"
				lValid := .T.
			EndIf
		EndIf
	EndIf

	If lValid .And.Empty(M->C5_LCEMB)
		Alert("Preencha o Campo: Local Emb. - Pedido de Exportaзгo.")
		_Retorno := .F.
	EndIf

// VALIDA SE CLIENTE Й RISCO E (Anбlise de Credito)
	If SuperGetMV("MV_XANACRE")

		If  M->C5_TIPO $ "N"
			cRisco 	:= Alltrim(Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_RISCO"))
			cCondE 	:= Posicione("SE4",1,xFilial("SE4") + M->C5_CONDPAG,"E4_XRISCOE")
			cAdiant	:= Posicione("SE4",1,xFilial("SE4") + M->C5_CONDPAG,"E4_CTRADT") // 1=Adiantamento  2=Sem Adiantamento

			If cRisco $ "E"
				If !cCondE	// Se nao for Cond.Pagto permitida para Risco E
					MsgAlert("Condiзгo de Pagamento Nгo Permitida para este Cliente, pois ele tem Risco '"+cRisco+"'. ")
					_Retorno := .F.
				Endif

				//Se a condicao estiver Correta e for cartao de Crйdito, verifica se a Autorizaзгo foi informada
				if _Retorno .and. cAdiant <> "1"	// Adiantamento

					// Se tiver algum campo Preenchido
					if !empty(M->C5_XAUTCC ) .or. !empty(M->C5_XDTAUT ) .or. M->C5_XVLRAUT > 0
						if empty(M->C5_XAUTCC ) .or. empty(M->C5_XDTAUT ) .or. M->C5_XVLRAUT = 0
							MsgAlert("Os Campos de Cуdigo/Data/Valor de Autorizaзгo do Cartгo, devem estar todos preenchidos ou todos em branco. ")
							_Retorno := .F.
						Endif
					Endif

				Endif

			Endif

			// Limpa Campo de DESPESAS ACESSORIAS - UTILIZADO PARA RELACIONAR ADIANTAMENTO.
			// Alterado a posiпїЅпїЅo da chamda (colocado fora do EndIf em 13/09/2019 para limpar o campo Independente do Risco do Cliente
			M->C5_DESPESA := 0

		Endif
	EndIf

	M->C5_DESPESA := 0	// Adiciona em 14/11/2019

//Tratamento para bloqueio da OF
	If M->C5_FECHADO =="1"//.AND.(SC5->C5_NUM<>M->C5_NUM)
		For nx := 1 To Len(aCols)
			aCols[nx,nPos] := " "
		Next
		//Avisa
		If AllTrim(M->C5_OBS) <>"EMAIL"
			EnvEmail()
			M->C5_OBS := "EMAIL"
		EndIf

	ElseIf M->C5_FECHADO =="2".AND.(SC5->C5_NUM==M->C5_NUM)
		if SC5->C5_FECHADO=="1"
			if Select("WRK") >0
				WRK->(dbCloseArea())
			EndIf
			cQuery := " SELECT C2_NUM, C2_PRODUTO, C2_PEDIDO "
			cQuery  += " FROM "+ RetSqlName("SC2")+" (NOLOCK) SC2 "
			cQuery  += " WHERE C2_FILIAL = '01' AND C2_PEDIDO ='"+SC5->C5_NUM+"' "
			cQuery += " AND D_E_L_E_T_ <> '*' "
			TcQuery cQuery Alias "WRK" New
			("WRK")->(DbGoTop())
			If !Eof()
				Alert("Nгo foi possivel Alterar o Status da OF de Fechado (Sim) para (Nao). existe OP criada!")
				DbSelectArea("WRK")
				WRK->(dbCloseArea())
				M->C5_FECHADO:="1"
				Return(_Retorno)
			else
				For nx := 1 To Len(aCols)
					aCols[nx,nPos] := "S"
				Next
				M->C5_OBS := ""
			EndIf
		EndIf
	ElseIf M->C5_FECHADO =="1".AND.(SC5->C5_NUM==M->C5_NUM).AND.SC5->C5_FECHADO =="2"
		For nx := 1 To Len(aCols)
			aCols[nx,nPos] := " "
		Next
		//Avisa
		EnvEmail()
	EndIf

//alterado por Marcos Rezende em 04/10/2012
//contemplar a obrigatoriedade de preenchimento do pedido referencial

	IF M->C5_XPVTIPO $ "TR/DV"
		IF EMPTY(M->C5_XPVREF)
			alert("Tipo de pedido necessita do pedido referenciado"+chr(13)+"Preencha o campo referencia ou altere o Tipo Pedido")
			_Retorno := .f.
		endif
	endif

	If _Retorno
		For _nx := 1 to Len(aCols)
			If aCols[_nx,Len(aHeader)+1]
				SC2->( DbOrderNickName("USUSC20001") )  // C2_FILIAL + C2_PEDIDO + C2_ITEMPV
				If SC2->( dbSeek( xFilial() + M->C5_NUM + aCols[_nx,nPC6_ITEM] ) )
					MsgStop("Nгo serб possнvel excluir o item " + aCols[_nx,nPC6_ITEM] + ". A Ordem de ProduпїЅпїЅo " + Subs(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,1,11) + " jпїЅ foi gerada para o mesmo.")
					_Retorno := .F.
				EndIf
			EndIf
		Next _nx
	EndIf



//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅValida a TES inteligente com as Regras definidas na tabela ZFMпїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

	nPos_ITEM		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ITEM" } )
	nPos_OPER		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_XOPER" } )
	nPos_PRODUTO	:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_PRODUTO" } )
	nPos_TES		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_TES" } )
	nPos_QTDVEN    	:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_QTDVEN" } )
	nPos_ENTR3     	:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_ENTRE3" } )
	nPos_CFO		:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_CF" } )
	nPos_QTDENT    	:= aScan( aHeader, { |aVet| Alltrim(aVet[2]) == "C6_QTDENT" } )

// TESTA SE OPERACAO E "99"
	For x := 1 to Len(aCols)
		If !aCols[x,Len(aHeader)+1]
			If !empty(aCols[x,nPos_OPER]) .and. aCols[x,nPos_OPER] <> "99"

				if _Retorno //.and. PARAMIXB[1] == 1  // ExclusпїЅo

					if M->C5_XXLIBFI <> '0'
						_cCliente		:= M->C5_CLIENTE
						_cLojaCli		:= M->C5_LOJACLI
						_cTipoCli		:= M->C5_TIPOCLI

						_cOper			:= aCols[x,nPos_OPER]
						_cProduto		:= aCols[x,nPos_PRODUTO]
						//	_Saldo			:= aCols[x,nPos_QTDVEN] - aCols[x,nPos_QTDENT]

						_TESZFM			:= U_ReTesInt(_cOper,_cCliente,_cLojaCli,_cProduto,_cTipoCli)[1]


						// Verifica se a TES da Regra пїЅ a mesma informada no PV
						If aCols[x,nPos_TES]		<>  _TESZFM
							// Bloqueia somente se o item ainda tiver saldo para Faturar (13/07/2020)
							//if _Saldo > 0
							Alert("TES informada diferente na Regra de TES inteligente no item " + aCols[x,nPos_ITEM] + ".")
							_Retorno := .F.
							Exit
							//endif
						endif


// INICIO - MAURESI
						_xxCF	:= POSICIONE("SF4",1,xFilial("SF4")+aCols[x,nPos_TES],"F4_CF")
						_cUF    := Alltrim(Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_EST"))
						_lContrib := iif(Alltrim(Posicione("SA1", 1, xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI, "A1_CONTRIB"))<>"2",.T.,.F.)

						if aCols[x,nPos_CFO]   <> _xxCF
							if _cUF <> "SP"
								if _cUF == "EX"
									_cDig := "7"
								else
									_cDig := "6"
								endif

								// MAURESI - 09/03/2020
								aCols[x,nPos_CFO] := _cDig+Substr(_xxCF,2,3)
								if !(_lContrib) .and. aCols[x,nPos_TES] $ "522"
									aCols[x,nPos_CFO] := _cDig+"108"
								ENDIF

							endif
						endif
//		FIM - MAURESI
						//	aCols[x,nPos_CFO] :=
					/*
					///пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
					//пїЅValida CFOP permitidos para TIPO SENF            пїЅ
					// Lista passada pela Priscila em 13/12/2017        пїЅ
					//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
					_xTpCOP := "5116/6116/5117/6117/5201/6201/5202/6202/5410/6410/5411/6411/5412/6412/5413/6413/5501/6501/5553/6553/5554/6554/"
					_xTpCOP += "5556/6556/5901/6901/5902/6902/5903/6903/5905/6905/5908/6908/5909/6909/5910/6910/5911/6911/5912/6912/"
					_xTpCOP += "5913/6913/5914/6914/5915/6915/5916/6916/5921/6921/5923/6923/5949/6949/7949/"
					
						If M->C5_XPVTIPO $ "SR" .and. !(aCols[x,nPos_CFO] $ _xTpCOP)
					Alert("CFOP nпїЅo permitida para SENF, informada no item " + aCols[x,nPos_ITEM] + ".")
					_Retorno := .F.
					Exit
						endif
					*/
					Endif

				Endif

			EndIf
		EndIf
	Next x





/*
///пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅValida CFOP permitidos para TIPO SENF            пїЅ
// Lista passada pela Priscila em 13/12/2017        пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

_xTpCOP := "5116/6116/5117/6117/5201/6201/5202/6202/5410/6410/5411/6411/5412/6412/5413/6413/5501/6501/5553/6553/5554/6554/"
_xTpCOP += "5556/6556/5901/6901/5902/6902/5903/6903/5905/6905/5908/6908/5909/6909/5910/6910/5911/6911/5912/6912/"
_xTpCOP += "5913/6913/5914/6914/5915/6915/5916/6916/5921/6921/5923/6923/5949/6949/7949/"

	if _Retorno .and. (M->C5_XPVTIPO $ "SR")
		For _nx := 1 to Len(aCols)
			If !aCols[_nx,Len(aHeader)+1]
				If !(aCols[_nx,nPos_CFO] $ _xTpCOP)
Alert("CFOP nпїЅo permitida para SENF, informada no item " + aCols[_nx,nPos_ITEM] + ".")
_Retorno := .F.
Exit
				endif

			Endif
		Next _nx
	Endif
*/


//Inserido por Michel Sander em 01.12.2016 para tratar as quantidades do pedido x previsпїЅo de faturamento
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅVerifica PrevisпїЅo de Faturamento.	                                                   пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	cAux := "00"
	For nQ := 1 to Len(aCols)

		cAux := Soma1(cAux)

		// Verifica se a Previsгo estб Preenchida
		If Len(aCols&cAux) > 0

			nSeq      := 1
			nSomaItem := 0

			Do While nSeq <= Len(aCols&cAux)
				If aCols[nQ,nPos_ITEM] == aCols&cAux[nSeq,1] //.And. aCols[nQ,nPos_PRODUTO] == aCols&cAux[nSeq,3]
					nSomaItem += aCols&cAux[nSeq,6]
				EndIf
				nSeq++
			End
		/*
			If nSomaItem <> aCols[nQ,nPos_QTDVEN]
		Alert("A quantidade do item "+aCols[nQ,nPos_ITEM]+" no pedido de vendas estпїЅ diferente da previsпїЅo de faturamento.")
		_Retorno := .F.
			EndIf
		*/

			//Validando o produto (nпїЅo pode validar o produto pq nпїЅo dпїЅ pra alterar o produto no getdados do SZY)
			//SZY->(dbSetOrder(1))
			//If SZY->(dbSeek(xFilial("SZY")+M->C5_NUM+aCols[nQ,nPos_ITEM])) //+"001"
			//	Do While SZY->(!Eof()) .And. SZY->ZY_FILIAL+SZY->ZY_PEDIDO+SZY->ZY_ITEM == xFilial("SZY")+M->C5_NUM+aCols[nQ,nPos_ITEM]
			//		If SZY->ZY_PRODUTO <> aCols[nQ,nPos_PRODUTO]
			// 			Alert("O Produto do item "+aCols[nQ,nPos_ITEM]+" no pedido de vendas estпїЅ diferente da previsпїЅo de faturamento.")
			//			_Retorno := .F.
			//		EndIf
			//		SZY->(dbSkip())
			//	End
			//EndIf


		Else

			If !INCLUI
				SZY->(dbSetOrder(1))
				If SZY->(dbSeek(xFilial("SZY")+M->C5_NUM+aCols[nQ,nPos_ITEM]+"001"))
					//If Empty(SZY->ZY_NOTA)
					//	If ( aCols[nQ,nPos_ENTR3] <> SZY->ZY_PRVFAT ) .And. !Empty(SZY->ZY_PRVFAT)
					//		Alert("A data do item "+aCols[nQ,nPos_ITEM]+" no pedido de vendas estпїЅ diferente da previsпїЅo de faturamento.")
					//		_Retorno := .F.
					//	EndIf
					//EndIf
					nSomaItem := 0
					Do While SZY->(!Eof()) .And. SZY->ZY_FILIAL+SZY->ZY_PEDIDO+SZY->ZY_ITEM == xFilial("SZY")+M->C5_NUM+aCols[nQ,nPos_ITEM]
						nSomaItem += SZY->ZY_QUANT
						SZY->(dbSkip())
					EndDo
				/*
					If nSomaItem <> aCols[nQ,nPos_QTDVEN]
				Alert("A quantidade do item "+aCols[nQ,nPos_ITEM]+" no pedido de vendas estпїЅ diferente da previsпїЅo de faturamento.")
				_Retorno := .F.
					EndIf
				*/
				EndIf
			EndIf

		EndIf

	Next nQ

	//Validaзгo de Tabelas de Preзo
	//Verifica se vai aplicar o controle de validaзгo do preзo
	//e obrigaзгo da tabela de preзos
	If Altera
		If M->C5_EMISSAO > GetMV("MV_XTABVEN")
			lValTabVen := .t.
		Else
			lValTabVen := .f.
		EndIf
	Else
		If Inclui
			lValTabVen := .t.
		EndIf
	EndIf

	//Osmar Ferreira - 08/12/2020
	If Empty(M->C5_CLIENT)
		   M->C5_CLIENT  := M->C5_CLIENTE
		   M->C5_LOJAENT :=	M->C5_LOJACLI 
	EndIf
	
    SB1->( dbSetOrder(01) )

	SB1->( dbSeek(xFilial() + aCols[n,nPos_PRODUTO]) )
	
	//Para produtos tipo "SI-Serviзos" o preзo de venda nгo serб validado
    If SB1->B1_TIPO == 'SI'
       lValTabVen := .f.
    EndIf 

	If _Retorno .and. (INCLUI .or. ALTERA) .And. lValTabVen
		//If M->C5_TIPO == 'N'
		If M->C5_XPVTIPO == "OF"
			SA1->( dbSetOrder(1) )
			If SA1->( dbSeek( xFilial() + M->C5_CLIENTE + M->C5_LOJACLI ) )
				If !Empty(SA1->A1_TABELA)
					DA0->( dbSetOrder(1) )
					IF DA0->( dbSeek( xFilial() + M->C5_TABELA ) )
						If (M->C5_TABELA == SA1->A1_TABELA) .Or. (DA0->DA0_XGENER == "S")
							For x := 1 to Len(aCols)
								If !aCols[x,Len(aHeader) + 1]
									DA0->( dbSetOrder(1) )
									IF DA0->( dbSeek( xFilial() + M->C5_TABELA ) )
										DA1->( dbSetOrder(1) )
										If !DA1->( dbSeek( xFilial() + M->C5_TABELA + aCols[x,nPC6PRODUTO] ) )
											MsgStop("Produto nгo encontrado na Tabela de Preзos " + M->C5_TABELA + ". Favor incluir o produto na Tabela de Preзos antes de incluir o Pedido de Vendas.")
											_Retorno := .F.
										else


                        					//Aguardando a criaзгo do campo DA1_XAPROV - Osmar 27/10/2020
                        					//If DA1->DA1_XAPROV == "N" 
                        					//   MsgStop("Preзo Bloqueado na Tabela de Preзos")
                        					//   _Retorno := .F.
											//Else
                        					//EndIf //Este If deve estar antes do Else (linha 463) do If/else acima


											nPrMaximo := DA1->DA1_PRCVEN + ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )
											nPrMinimo := DA1->DA1_PRCVEN - ( DA1->DA1_PRCVEN * ( DA1->DA1_XTOLER / 100 ) )

											IF aCols[x,nPC6PRCVEN] == DA1->DA1_PRCVEN
												_Retorno := .T.
											else
												If DA0->DA0_XGENER == "S"
													lGenerica := .T.
												else
													lGenerica := .F.
												EndIf

												If lGenerica
													If aCols[x,nPC6PRCVEN] > DA1->DA1_PRCVEN
														_Retorno := .T.
													Else
														MsgStop("Preзo inferior a Tabela de Preзos")
														_Retorno := .F.
													EndIf
												Else
													If ( aCols[x,nPC6PRCVEN] >= nPrMinimo ) .And. ( aCols[x,nPC6PRCVEN] <= nPrMaximo )
														_Retorno := .T.
													Else
														MsgStop("Preзo fora das margens de tolerвncia da Tabela de Preзos")
														_Retorno := .F.
													EndIf
												EndIf
												/*
												If lGenerica .and. aCols[x,nPC6PRCVEN] > DA1->DA1_PRCVEN
													_Retorno := .T.
												ELSE
													_Retorno := .F.
													If lGenerica
														MsgStop("Preзo inferior a Tabela de Preзos")
													Else
														MsgStop("Preзo diferente da Tabela de Preзos")
													EndIf
												EndIf
												*/
											EndIf
										ENDIF
									EndIF
								EndIF
							Next x
						Else
							MsgStop('Tabel de Preзos informada no cabeзalho do Pedido estб diferente da utilizada no Cadastro do Cliente')
							_Retorno  := .F.
						EndIf
					Else
						MsgStop('Tabel de Preзos nгo cadastrada')
						_Retorno  := .F.
					EndIf



				else
					MsgStop('Favor preencher a Tabela de Preзos no cadastro de Clientes')
					_Retorno  := .F.
				EndIF
			EndIf
		EndIf
	EndIf



//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅBaixa o saldo da PrevisпїЅo de Vendas.                                                   пїЅ
//пїЅ                                                                                       пїЅ
//пїЅTEM QUE FICAR POR ULTIMO NESTE PONTO DE ENTRADA!!!                                     пїЅ
//пїЅSe for incluir alguma outra validaпїЅпїЅo neste ponto, incluir acima deste bloco de cпїЅdigo.пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

	If _Retorno .and. PARAMIXB[1] == 1  // ExclusпїЅo
		SC6->( dbSetOrder(1) )
		SC4->( dbSetOrder(3) )  // C4_FILIAL + C4_PRODUTO + C4_CNPJ + C4_DATA
		SA1->( dbSetOrder(1) )

		If SC5->C5_TIPO == 'N'
			If SC6->( dbSeek( xFilial() + SC5->C5_NUM ) )
				If SA1->( dbSeek( xFilial() + SC5->C5_CLIENTE + SC5->C5_LOJAENT ) )
					While !SC6->( EOF() ) .and. SC6->C6_NUM == SC5->C5_NUM
						If !Empty(SC6->C6_XXPREVI)
							If SC4->( dbSeek( xFilial() + SC6->C6_XXPREVI + Subs(SA1->A1_CGC,1,8) + Space(6) + DtoS(SC6->C6_XXPREDT) ) )
								If !Empty(SC6->C6_XXPREQT)
									Reclock("SC4",.F.)
									SC4->C4_QUANT   += SC6->C6_XXPREQT
									SC4->( msUnlock() )

									Reclock("SC6",.F.)
									SC6->C6_XXPREQT := SC6->C6_QTDVEN
									SC6->( msUnlock() )
								EndIf

							EndIf
						EndIf
						SC6->( dbSkip() )
					End
				EndIf
			EndIf
		EndIf
	EndIf


// Valida Alteracao do campo Motivo de revisao - Envia WorkFlow (somente para PV jпїЅ LIberados para o Fiscal)
	If  _Retorno .and. M->C5_XXLIBFI <> '0'  //.and. PARAMIXB[1] == 1  // ExclusпїЅo
		if ( Alltrim(M->C5_MOTREVI) <> Alltrim(SC5->C5_MOTREVI) )  .and. ( M->C5_NUM == SC5->C5_NUM )

			c_Pula	 := Chr(13)+Chr(10)
			c_MudaLn  := '<br/>'
			cData     := DtoC(Date())

			//		MsgAlert("Anterior : " + SC5->C5_MOTREVI + c_Pula + "Novo: " + M->C5_MOTREVI)
			cAssunto  := "Domex - Alteraзгo no campo Motivo de Revisao do PV: " +M->C5_NUM
			cTexto    := "Alteraзгo realizada por: " + Alltrim(Subs(cUsuario,7,14)) + " em " + cData + "  as " + Time()	 + c_MudaLn + c_MudaLn
			cTexto    += "Conteъdo Anterior.: " + Alltrim(SC5->C5_MOTREVI) + c_MudaLn + c_MudaLn
			cTexto    += "Conteъdo Novo.....: " + Alltrim(M->C5_MOTREVI)
			//cTexto    := StrTran(cTexto,Chr(13),"<br>")
			cPara     :=  ";priscila.silva@rosenbergerdomex.com.br;juliana.gomes@rosenbergerdomex.com.br;thalita.rufino@rosenbergerdomex.com.br;sergio.santos@rosenbergerdomex.com.br" 
			cPara     +=  ";ludmila.guimaraes@rosenbergerdomex.com.br;denis.vieira@rosenbergerdomex.com.br" +";"+ Alltrim(UsrRetMail(SC5->C5_USER))+";"+AllTrim(UsrRetMail(__cUserID))
			cCC       :=  ""
			cArquivo  :=  ""
			U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)

			// Deixa Pedido Bloqueado para o Depto FISCAL avaliar novamente.
			//cQR1B:= " UPDATE SC5010 SET C5_XXLIBFI = '0' WHERE C5_NUM = '"+M->C5_NUM+"' "
			//TCSQLEXEC(cQR1B)

			M->C5_XXLIBFI = '0'

		endif
	Endif



	RestArea(aAreaSA1)
	RestArea(aAreaSC5)
	RestArea(aAreaSC2)
	RestArea(aAreaSC6)
	RestArea(aAreaSB1)
	RestArea(aAreaZFM)
	RestArea(aAreaGER)

Return(_Retorno)

/*
|--------------------------------------|
| FunпїЅпїЅo utilizada para envio de Email |
| Juliano F.Silva 26/10/11             |
|--------------------------------------|
*/

Static Function EnvEmail()
// Variaveis Locais da Funcao
	Local cEmailP	  := GetMv( "MV_EMAILOM" , .F. , ) 	// retorna Teste
//"vanessa.faio@rosenbergerdomex.com.br;juliano.ferreira@rdt.com.br"
	Local cEmailDe   := "siga@rosenbergerdomex.com.br"   // siga@rosenbergerdomex.com.br
	Local cEmailDePs := "Rdt1010@"  // "rdt1010"
	Local oMail      := tMailManager():NEW()
	Local nRet       := 0
	Local cSMTP      := "smtp.office365.com" //"vexch01.domex.com.br"//"mail.rdt.com.br"
	Local nSMTPTime  := 120                     // Timeout SMTP
	Local cBody      := ""
	Local cUser    := SubStr(cUsuario,7,15)

	cBody  := " <body> "
	cBody  += "<span style='color: rgb(51, 51, 255);'></span> "
	cBody  += "<table style='text-align: left; width: 792px; height: 339px;' "
	cBody  += " border='2' cellpadding='2' cellspacing='1'> "
	cBody  += "  <tbody> "
	cBody  += "    <tr> "
	cBody  += "      <td colspan='3' rowspan='1'> "
	cBody  += "      <h5 "
	cBody  += " style='height: 67px; font-family: Arial; color: rgb(204, 0, 0); text-align: center; background-color: rgb(87, 104, 193);'><big><big>AVISO</big></big></h5> "
	cBody  += "      </td> "
	cBody  += "    </tr>  "
	cBody  += "    <tr>  "
	cBody  += "      <th rowspan='1' colspan='3'></th> "
	cBody  += "    </tr> "
	cBody  += "    <tr align='center'> "
	cBody  += "      <td rowspan='1' colspan='3'><span "
	cBody  += " style='color: rgb(0, 102, 0);'>Liberada OF para P.C.P.</span></td> "
	cBody  += "    </tr>               "
	cBody  += "    <tr>               "
	cBody  += "      <td>Numero:</td>"
	cBody  += "      <td colspan='2' rowspan='1'><span"
	cBody  += " style='color: rgb(51, 51, 255);'>"+M->C5_NUM+"</span></td> "
	cBody  += "    </tr> "
	cBody  += "    <tr> "
	cBody  += "      <td>Liberada por:</td> "
	cBody  += "      <td colspan='2' rowspan='1'><span "
	cBody  += " style='color: rgb(51, 51, 255);'>"+cUser+"</span></td>"
	cBody  += "    </tr> "
	cBody  += "  </tbody>  "
	cBody  += " </table>  "
	cBody  += " </body>  "
	cBody  += " </html> "

	oMail:Init("", cSMTP, cEmailDe, cEmailDePs)

	nret := oMail:SMTPConnect()
	if oMail:SetSMTPTimeout(nSMTPTime) != 0
		conout("[ERROR]Falha ao definir timeout")
		return .F.
	endif

	If nRet == 0
		conout("Sucess")
	Else
		conout(nret)
		conout(oMail:GetErrorString(nret))
	Endif

// Realiza autenticacao no servidor
	nErr := oMail:smtpAuth(cEmailDe, cEmailDePs)
	if nErr <> 0
		conOut("[ERROR]Falha ao autenticar: " + oMail:getErrorString(nErr))
		oMail:smtpDisconnect()
		return .F.
	endif

// Cria uma nova mensagem (TMailMessage)
	oMessage := tMailMessage():new()
	oMessage:clear()
	oMessage:cFrom    := cEmailDe    //email de
	oMessage:cTo      := cEmailP     //email para
//oMessage:cCC      := cEmailCC  //copia de email
//goMessage:cBCC     := ""       //"copia oculta
	oMessage:cSubject := "Liberaзгo da OF "+M->C5_NUM+" para gerar O.P."

	oMessage:cBody    := cBody//"Corpo do e-mail"

// Envia a mensagem
	nErr := oMessage:send(oMail)
	if nErr <> 0
		conout("[ERROR]Falha ao enviar: " + oMail:getErrorString(nErr))
		oMail:smtpDisconnect()
		return .F.
	endif
	oMail:SmtpDisconnect()

Return(.T.)
