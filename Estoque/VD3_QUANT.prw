#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VD3_QUANT()ºAutor  ³Helio Ferreira     º Data ³  12/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VD3_QUANT(Param01,Param02,Param03,Param04)

	Local _Retorno := .T.
	Private cLocProcDom := GetMV("MV_XXLOCPR")

	Private lNew := .T.
	Private OPVD3QUANT
	Private nD3_QUANT
	Private cD3_COD
	Private cD3_LOCAL
	Private aOps

	Default Param01 := ""  //M->D3_OP
	Default Param02  := 0  //M->D3_QUANT
	Default Param03  := "" //M->D3_COD
	Default Param04  := "" //M->D3_LOCAL
	cOpOrig2:=''



	If (FunName() <> "MATA242" .and. FunName() <> "MATA240" .and. FunName() <> "MATA241" .and. FunName() <> "MATA260" .and. FunName() <> "MATA261") .Or. Empty(FunName())
		If Empty(Param01)
			OPVD3QUANT := M->D3_OP
		Else
			OPVD3QUANT := Param01
		EndIf

		// If alltrim(OPVD3QUANT)="89120 01001"
		// 	Return _Retorno
		// EndIf

		If Empty(Param02)
			nD3_QUANT := M->D3_QUANT
		Else
			nD3_QUANT := Param02
		EndIf

		If Empty(Param03)
			cD3_COD := M->D3_COD
		Else
			cD3_COD := Param03
		EndIf

		If Empty(Param04)
			cD3_LOCAL := M->D3_LOCAL
		Else
			cD3_LOCAL := Param04
		EndIf

		Processa({|| _Retorno := ProcRun() })
	EndIf

Return _Retorno


Static Function ProcRun()

	Local _Retorno  := .T.
	Local aAreaGER  := GetArea()

	Local aAreaSD4  := SD4->( GetArea() )
	Local aAreaSBF  := SBF->( GetArea() )
	//Local aAreaSB1  := SB1->( GetArea() )
	Local aAreaSD3  := SD3->( GetArea() )
	Local aAreaSC2  := SC2->( GetArea() )

	Local nIndApto  := 0
	Local nPos      := 0
	Local nP05_SOMA := 0
	Local aInsuficientes := {}
	Local aNecessidades := {}
	Local nOP, nOX, nXB, nU

	Private cUserSys     := RetCodUsr()   //MLS


	If Type("lAutoMt250") == 'U'
		//_Retorno := U_VD3_QUANT()
	Else
		If lAutoMt250
			Return _Retorno
		EndIF
	EndIf

	SG1->( dbSetOrder(1) )
	SZA->( dbSetOrder(1) )
	SZE->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	SC2->( dbSetOrder(1) )

	//If (FunName() <> "MATA240" .and. FunName() <> "MATA241" .and. FunName() <> "MATA260" .and. FunName() <> "MATA261") .Or. Empty(FunName())
	If !Empty(nD3_QUANT)

		nProcRegua  := 0
		nTotRegProc := 0

		If lNew

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calculando quantidade de produtos a serem validados³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cAliasSC2 := GetNextAlias()
			cOpOrigem := "%'"+Subs(OPVD3QUANT,1,8)+"'%"


			BeginSQL Alias cAliasSC2
			
			SELECT C2_NUM+C2_ITEM+C2_SEQUEN C2_NUMOP, C2_PRODUTO, C2_QUANT,B1_XKITPIG FROM %table:SC2% SC2 (NOLOCK),%table:SB1% SB1 (NOLOCK) WHERE
			SUBSTRING(C2_NUM+C2_ITEM,1,8) = %Exp:cOpOrigem%
			AND SB1.B1_FILIAL = %xFilial:SB1% 
			AND SB1.B1_COD = SC2.C2_PRODUTO
			AND SC2.C2_FILIAL = %xFilial:SC2% 
			AND SC2.C2_DATRF  = ''
			//AND SC2.C2_FILIAL = '01'
			AND SC2.%NotDel%
			
			EndSQL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calcula indice de apontamento								³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aOps := {}

			//Validar se é apontametno de KIT PIG Tail
			lKitPig := .F.
			IF SC2->(DbSeek(xFilial("SC2") + OPVD3QUANT))
				IF SB1->(DBSeek(xfilial("SB1") + SC2->C2_PRODUTO))
					lKitPig := (SB1->B1_XKITPIG == "S")
				EndIf
			EndIf

			If lKitPig
				Do While (cAliasSC2)->(!EOF())
					If Subs((cAliasSC2)->C2_NUMOP,1,11) == Subs(OPVD3QUANT,1,11)
						If Subs((cAliasSC2)->C2_NUMOP,1,11) == Subs(OPVD3QUANT,1,11)
							nIndApto := nD3_QUANT / (cAliasSC2)->C2_QUANT
						EndIf
						AADD( aOPs,{(cAliasSC2)->C2_NUMOP,(cAliasSC2)->C2_PRODUTO,(cAliasSC2)->C2_QUANT} )
					EndIf

					(cAliasSC2)->(dbSkip())
				EndDo
			Else
				Do While (cAliasSC2)->(!EOF())
					If Subs((cAliasSC2)->C2_NUMOP,1,11) >= Subs(OPVD3QUANT,1,11)
						If Subs((cAliasSC2)->C2_NUMOP,1,11) == Subs(OPVD3QUANT,1,11)
							nIndApto := nD3_QUANT / (cAliasSC2)->C2_QUANT
						EndIf
						AADD( aOPs,{(cAliasSC2)->C2_NUMOP,(cAliasSC2)->C2_PRODUTO,(cAliasSC2)->C2_QUANT} )
					EndIf

					(cAliasSC2)->(dbSkip())
				EndDo
			EndIf
			(cAliasSC2)->(dbCloseArea())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Busca quantidades para processamento no empenho		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cAliasSD4 :=  "SD4G"//GetNextAlias()

			If U_VALIDACAO("HELIO",.T.,'03/02/22','03/02/22')
				U_ATUD4XOP()
				BeginSQL Alias cAliasSD4
         			 SELECT COUNT(*) NSOMA FROM %table:SD4% SD4 (NOLOCK) WHERE SD4.D4_FILIAL = %xFilial:SD4% AND D4_XOP = %Exp:cOpOrigem% AND SD4.%NotDel%
				EndSQL
			Else
				BeginSQL Alias cAliasSD4
         			 SELECT COUNT(*) NSOMA FROM %table:SD4% SD4 (NOLOCK) WHERE SD4.D4_FILIAL = %xFilial:SD4% AND SUBSTRING(D4_OP,1,8) = %Exp:cOpOrigem% AND SD4.%NotDel%
				EndSQL
			EndIf
			//endif

			nTotRegProc := (cAliasSD4)->NSOMA
			(cAliasSD4)->(dbCloseArea())

			//		nTotRegProc := (cAliasSD4)->NSOMA
			//		(cAliasSD4)->(dbCloseArea())
			ProcRegua(nTotRegProc)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Verifica se existe produto SILK na estrutura			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			lSilk := .F. // fVerSilk(cD3_COD)

			If !(Posicione("SB1",1,xFilial("SB1")+cD3_COD,"B1_TIPO") $ 'PA,BN') .and. !lSilk
				If cD3_LOCAL <> '97'
					U_UMsgStop("Produtos diferentes de 'PA' devem ter suas produções apontadas no almoxarifado de produção 97.")
					_Retorno := .F.
				EndIf
			EndIf

		ElSe //lNew

			aOPs := {}
			If SC2->( dbSeek( xFilial() + Subs(OPVD3QUANT,1,8) ) )  // Somente a raiz da OP

				While !SC2->( EOF() ) .and. Subs(OPVD3QUANT,1,8) == SC2->C2_NUM + SC2->C2_ITEM
					If Subs(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,1,11) >= Subs(OPVD3QUANT,1,11)
						If Subs(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,1,11) == Subs(OPVD3QUANT,1,11)
							nIndApto := nD3_QUANT / SC2->C2_QUANT
						EndIf

						If Empty(SC2->C2_DATRF)
							AADD( aOPs,{SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN,SC2->C2_PRODUTO,SC2->C2_QUANT} )
						EndIf
					EndIf
					SC2->( dbSkip() )
				End
			EndIf

			SD4->( dbSetOrder(2) )
			For nOP := 1 to Len(aOPs)
				If SD4->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )
					While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == Subs(aOps[nOp,1],1,11)
						nTotRegProc++
						SD4->( dbSkip() )
					End
				EndIf
			Next nOP

			ProcRegua(nTotRegProc)

			SG1->( dbSetOrder(1) )
			lSilk := .F.
			If SG1->( dbSeek( xFilial() + cD3_COD ) )
				While !SG1->( EOF() ) .and. SG1->G1_COD == cD3_COD
					If Subs(SG1->G1_COMP,1,6) == '500960'
						lSilk := .T.
						Exit
					EndIf
					SG1->( dbSkip() )
				End
			EndIf

			If !(Posicione("SB1",1,xFilial("SB1")+cD3_COD,"B1_TIPO") $ 'PA,BN') .and. !lSilk
				If cD3_LOCAL <> '97'
					U_UMsgStop("Produtos diferentes de 'PA' devem ter suas produções apontadas no almoxarifado de produção 97.")
					_Retorno := .F.
				EndIf
			EndIf

		EndIf lNew

		SC2->( dbSetOrder(1) )
		For nOP := 1 to Len(aOPs)
			If SB1->( dbSeek( xFilial() + aOps[nOp,2] ) ) .and. _Retorno

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Verifica se existe produto SILK na estrutura			³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				lSilk := fVerSilk(aOps[nOp,2])

				If !lSilk

					SD4->( dbSetOrder(2) )
					If SD4->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )

						SC2->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )

						If SC2->C2_QUANT > SC2->C2_QUJE

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica o que já foi apontado da OP   				³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							SD3->( dbSetOrder(1) )
							nTotApto := 0

							If SD3->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Seleciona os apontamentos da OP  						³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								_cAlias   := GetNextAlias()
								c_cOP     := "%'"+Subs(aOps[nOp,1],1,11)+"'%"
								cFilialSD3 := xFilial("SD3")

								BeginSQL Alias _cAlias
								
								SELECT SUM(D3_QUANT) AS SUM_D3QTD FROM SD3010 (NOLOCK) WHERE
								D3_OP = %exp:c_cOP% AND 
								(D3_CF = 'PR0' OR D3_CF = 'PR1') AND
								D3_ESTORNO = '' AND D3_FILIAL = %exp:cFilialSD3% AND
								D_E_L_E_T_ = ''
								
								EndSQL

								nTotApto := (_cAlias)->SUM_D3QTD
								(_cAlias)->( dbCloseArea() )

							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Verifica comprovantes de pagamento da OP  			³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						/*
						cAliasSZD := GetNextAlias()
						cOpOrigem := "%'"+Subs(aOps[nOp,1],1,11)+"'%"
						
							BeginSQL Alias cAliasSZD
							
							SELECT SUM(ZD_QTDPG) AS SUM_ZDQTD FROM %Table:SZD% SZD (NOLOCK) WHERE
							SUBSTRING(ZD_OP,1,11) = %Exp:cOpOrigem% AND
							SZD.ZD_FILIAL 		  = %xFilial:SZD%   AND
							SZD.%NotDel%
							
							EndSQL

							nTotEtiq := (cAliasSZD)->SUM_ZDQTD
							(cAliasSZD)->(dbCloseArea())

							//SUSTITUIDO POR MICHEL SANDER EM 28.03.2017
							//nTotEtiq := 0
							//SZD->( dbSetOrder(1) )
							//If SZD->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )
							//While !SZD->( EOF() ) .and. Subs(SZD->ZD_OP,1,11) == Subs(aOps[nOp,1],1,11)
							//nTotEtiq += SZD->ZD_QTDPG
							//SZD->( dbSkip() )
							//End
							//EndIf


							If nTotEtiq < (nTotApto + (nIndApto * aOps[nOp,3]))
								If Subs(aOps[nOp,1],1,11) == Subs(OPVD3QUANT,1,11)
									cTexto := "Apontamento de OP "+Alltrim(aOps[nOp,1])+" nao permitido."+Chr(13)
								Else
									cTexto := "Apontamento de OP FILHA "+Alltrim(aOps[nOp,1])+" nao permitido."+Chr(13)
								EndIf
								cTexto += "Obrigatorio a emissao de etiqueta de comprovante de pagamento pelo Estoque."+Chr(13)
								cTexto += "Apontamento de OP realizado: " + Alltrim(Transform(nTotApto,"@E 999,999,999.9999"))+Chr(13)
								cTexto += "Emissao de etiqueta de comprovante de pagamento de material suficiente para producao de: " + Alltrim(Transform(nTotEtiq,"@E 999,999,999.9999"))+". Saldo possível de ser apontado: " + Alltrim(Transform(nTotEtiq-nTotApto,"@E 999,999,999.9999"))+"."
								If !(Alltrim(Upper(Subs(cUsuario,7,15))) $ "ELIO OPUS/DENIS")
									U_UMsgStop( cTexto )
									_Retorno := .F.
								Else
									U_UMsgStop("Administrador, nao foi emitida a etiqueta de comprovante de pagamento de OP mas o apontamento NAO sera bloqueado.")
								EndIf
							EndIf
							//EndIf
						   */

							If lNew

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
								//³Verifica perda de FORNECEDORES (TRANSFERENCIA DO 01 PARA O 97)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							   /*
							   cAliasSZE := GetNextAlias()
							   cOpOrigem := "%'"+Subs(aOps[nOp,1],1,8)+"'%"
							
								BeginSQL Alias cAliasSZE
								
								SELECT ZE_FILIAL, ZE_OP, ZE_PRODUTO, ZE_SALDO, R_E_C_N_O_, D_E_L_E_T_
								FROM %Table:SZE% SZE (NOLOCK) WHERE
								SZE.ZE_FILIAL  = %xFilial:SZE% 	           AND
								SZE.ZE_SALDO 	 <> 0            				  AND
								Substring(SZE.ZE_OP,1,8) = %Exp:cOpOrigem%  AND
								SZE.%NotDel%
								EndSQL

								If !(cAliasSZE)->(EOF())
									U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"Existe pendência de pagamento de perda (Fornecedor) do produto: " + Alltrim((cAliasSZE)->ZE_PRODUTO) + " quantidade " + Alltrim(Transform((cAliasSZE)->ZE_SALDO,"@E 999,999,999.9999")) + " para esta OP.")
									//_Retorno := .F.
								EndIf
								(cAliasSZE)->(dbCloseArea())
							   */
								If _Retorno

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									//³Seleciona os empenhos da OP								³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
									cAliasSD4  := GetNextAlias()
									cOpOrigem  := "%'"+Subs(aOps[nOp,1],1,11)+"'%"

								/*
									BeginSQL Alias cAliasSD4
									
									SELECT D4_FILIAL, D4_OP, D4_COD, D4_LOCAL, D4_QUANT, D4_QTDEORI, D4_OPORIG,
									
									ISNULL( ( SELECT SUM_D3QTD = SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM %Table:SD3% (NOLOCK)
									WHERE D3_XXOP    = D4_OP
									AND   D3_COD     = D4_COD
									AND   D3_LOCAL   = D4_LOCAL
									AND   D3_ESTORNO = ''
									AND   D3_CF      IN ('DE4','RE4')
									AND   D3_FILIAL  = D4_FILIAL
									AND   D_E_L_E_T_ = '' ), 0 ) D3_PG_OP,
									
									ISNULL( ( SELECT SUM(D3_QUANT) FROM %Table:SD3% (NOLOCK)
									WHERE	D3_ESTORNO 	= '' 					AND
									D3_TM			= '571'				AND
									D3_OP      	= D4_OP           AND
									D3_FILIAL   = D4_FILIAL			AND
									D_E_L_E_T_  = '' ), 0 ) D3_PG_PER_FOR,
									
									ISNULL( ( SELECT SUM(ZE_QTDORI) FROM %Table:SZE% (NOLOCK)
									WHERE	ZE_PRODUTO 	= D4_COD  			AND
									ZE_OP      	      = D4_OP           AND
									ZE_FILIAL         = D4_FILIAL			AND
									D_E_L_E_T_        = '' ), 0 ) ZE_PER_FOR
									
									FROM %Table:SD4% (NOLOCK) JOIN %Table:SB1% SB1 (NOLOCK) ON B1_COD = D4_COD
									WHERE SUBSTRING(D4_OP,1,11) = %Exp:cOpOrigem% AND
									SB1.B1_TIPO  <> 'MO' 						  		 AND
									SB1.B1_APROPRI <> 'I'                   		 AND
									SD4.D4_LOCAL = '97'					 		  		 AND
									SD4.D4_OPORIG = ''							  		 AND
									SD4.D4_FILIAL = %xFilial:SD4%			  			 AND
									SB1.B1_FILIAL = %xFilial:SB1%			  			 AND
									SD4.%NotDel% 									  		 AND
									SB1.%NotDel%
									ORDER BY D4_FILIAL, D4_OP
									
									EndSQL
								   */

									cQuery := "SELECT D4_FILIAL, D4_OP, D4_COD, D4_LOCAL, D4_QUANT, D4_QTDEORI, D4_OPORIG, "

									cQuery += "	ISNULL( ( SELECT SUM_D3QTD = SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END) FROM SD3010 SD3 (NOLOCK) "
									cQuery += "	WHERE D3_XXOP    = D4_OP                                                                                           "
									cQuery += "	AND   D3_COD     = D4_COD                                                                                          "
									cQuery += "	AND   D3_LOCAL   = D4_LOCAL                                                                                        "
									cQuery += "	AND   D3_ESTORNO = ''                                                                                              "
									cQuery += "	AND   D3_CF      IN ('DE4','RE4')                                                                                  "
									cQuery += "	AND   D3_FILIAL  = D4_FILIAL AND D3_FILIAL = '"+xFilial("SD3")+"' AND D4_FILIAL = '"+xFilial("SD4")+"'                                             "
									cQuery += "	AND   D_E_L_E_T_ = '' ), 0 ) D3_PG_OP,                                                                             "

									cQuery += "	ISNULL( ( SELECT SUM(ZE_QTDORI-ZE_SALDO) FROM SZE010 SZE (NOLOCK)                                                  "
									cQuery += "	WHERE	ZE_PRODUTO 	= D4_COD  			AND                                                                            "
									cQuery += "	ZE_OP      	      = D4_OP           AND                                                                            "
									cQuery += "	ZE_FILIAL         = D4_FILIAL			AND ZE_FILIAL = '"+xFilial("SZE")+"' AND                                                       "
									cQuery += "	D_E_L_E_T_        = '' ), 0 ) D3_PG_PER_FOR,                                                                       "

									cQuery += "	ISNULL( ( SELECT SUM(ZE_QTDORI) FROM SZE010 SZE (NOLOCK)                                                           "
									cQuery += "	WHERE	ZE_PRODUTO 	= D4_COD  			AND                                                                            "
									cQuery += "	ZE_OP      	      = D4_OP           AND                                                                            "
									cQuery += "	ZE_FILIAL         = D4_FILIAL			AND ZE_FILIAL = '"+xFilial("SZE")+"' AND                                                       "
									cQuery += "	D_E_L_E_T_        = '' ), 0 ) ZE_PER_FOR                                                                           "

									cQuery += "	FROM SD4010 SD4 (NOLOCK) JOIN SB1010 SB1 (NOLOCK) ON B1_COD = D4_COD                                               "
									//cQuery += "	WHERE SUBSTRING(D4_OP,1,11) = '"+Subs(aOps[nOp,1],1,11)+"' AND                                                     "
									cQuery += "	WHERE D4_OP = '"+Subs(aOps[nOp,1],1,11)+"' AND                                                     "
									cQuery += "	SB1.B1_TIPO  <> 'MO' 						  		 AND                                                                  "
									cQuery += "	SB1.B1_APROPRI <> 'I'                   		 AND                                                                  "
									cQuery += "	SD4.D4_LOCAL = '97'					 		  		 AND                                                                  "
									cQuery += "	SD4.D4_OPORIG = ''							  		 AND                                                                  "
									cQuery += "	SD4.D4_FILIAL = '"+xFilial("SD4")+"'			 AND                                                                  "
									cQuery += "	SB1.B1_FILIAL = '"+xFilial("SB1")+"'		    AND                                                                  "
									cQuery += "	SD4.D_E_L_E_T_ = '' 									 AND                                                                  "
									cQuery += "	SB1.D_E_L_E_T_ = ''                                                                                                "
									cQuery += "	ORDER BY D4_FILIAL, D4_OP                                                                                          "

									dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSD4,.F.,.T.)

									Do While (cAliasSD4)->(!EOF()) .And. _Retorno

										SUMD3QTD1      := (cAliasSD4)->D3_PG_OP
										nD3_PG_PER_FOR := (cAliasSD4)->D3_PG_PER_FOR
										nZE_PER_FOR    := (cAliasSD4)->ZE_PER_FOR

										// nIndApto := nD3_QUANT  / (cAliasSC2)->C2_QUANT
										// aOps[nOp,3]  => AADD( aOPs,{(cAliasSC2)->C2_NUMOP,(cAliasSC2)->C2_PRODUTO,(cAliasSC2)->C2_QUANT} )

										// Portanto
										//  Qtd já apontada
										//If (nTotApto        + ( nIndApto*aOps[nOp,3] ) ) >= SC2->C2_QUANT // M->D3_PARCTOT == 'T'
										//	If (cAliasSD4)->D4_QTDEORI > (SUMD3QTD1+nD3_PG_PER_FOR)
										//		U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim((cAliasSD4)->D4_COD) + " não foi totalmente pago para a OP "+Alltrim((cAliasSD4)->D4_OP)+"."+Chr(13)+"Total empenho: " + Alltrim(Transform((cAliasSD4)->D4_QTDEORI,"@E 999,999,999.9999")) + ". Pendência pagamento: " + Alltrim(Transform((cAliasSD4)->D4_QTDEORI - (SUMD3QTD1+nD3_PG_PER_FOR),"@E 999,999,999.9999")) + "." )
										//		_Retorno := .F.
										//		Exit
										//	Else
										//		If (SUMD3QTD1+nD3_PG_PER_FOR) > (cAliasSD4)->D4_QTDEORI
										//			U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim((cAliasSD4)->D4_COD) + " foi pago a MAIS para esta OP."+Chr(13)+"Total empenho: " + Alltrim(Transform((cAliasSD4)->D4_QTDEORI,"@E 999,999,999.9999")) + ". Pagamento a mais: " + Alltrim(Transform((SUMD3QTD1+nD3_PG_PER_FOR) - (cAliasSD4)->D4_QTDEORI,"@E 999,999,999.9999")) + "." )
										//			_Retorno := .F.
										//			Exit
										//		EndIf
										//	EndIf

										//Else

									/*
									SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
									SUMD3QTD1 := 0
									
										If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
											While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
												If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
													If SD3->D3_CF == 'DE4'
									SUMD3QTD1 += SD3->D3_QUANT
													EndIf
													If SD3->D3_CF == 'RE4'
									               SUMD3QTD1 -= SD3->D3_QUANT
													EndIf
												EndIf
									         SD3->( dbSkip() )
											End
										EndIf
									   */

										//nTotNecessidade := (nTotApto + (nIndApto*aOps[nOp,3])) * ((cAliasSD4)->D4_QTDEORI / SC2->C2_QUANT)

										nApto_D3QUANT := nTotApto + nD3_QUANT

										If nApto_D3QUANT > SC2->C2_QUANT
											nApto_D3QUANT := SC2->C2_QUANT
										EndIf
										nTotNecessidade := (nApto_D3QUANT) * ((cAliasSD4)->D4_QTDEORI / SC2->C2_QUANT)

										//nTotNecessidade += nZE_PER_FOR   // Lançamento de perda de fornecedores (SZE->ZE_QTDORI)

										ntotPago        := SUMD3QTD1 //+ nD3_PG_PER_FOR //- nZE_PER_FOR  não tem que somar o pagamento de perda pra fornecedor

										If nTotNecessidade > ntotPago
											cTxt := "Apontamento não permitido:"                                                         + Chr(13)
											cTxt += "Produto: " + Alltrim((cAliasSD4)->D4_COD) + " OP: " + Alltrim(aOps[nOp,1])          + Chr(13)
											cTxt += "Necessidade total: " +Alltrim(Transform(nTotNecessidade,"@E 999,999,999.9999"))     + Chr(13)

											cTxt += "   Pagamentos OP: " +Alltrim(Transform(SUMD3QTD1+nZE_PER_FOR ,"@E 999,999,999.9999"))    + Chr(13)

											If !Empty(nD3_PG_PER_FOR)
												cTxt += "   Pagamentos de Perda de Fornecedor: "+Alltrim(Transform(nD3_PG_PER_FOR,"@E 999,999,999.9999")) + Chr(13)
												cTxt += "Total de Pagamentos: "+Alltrim(Transform(SUMD3QTD1+nD3_PG_PER_FOR,"@E 999,999,999.9999")) + Chr(13)
											EndIf

											If !Empty(nZE_PER_FOR)
												cTxt += "   Perda de Fornecedor: "+Alltrim(Transform(nZE_PER_FOR,"@E 999,999,999.9999")) + Chr(13)
											EndIf

											cTxt += "Disponível: " + Alltrim(Transform(ntotPago,"@E 999,999,999.9999")) + " menor que necessidade: " + Alltrim(Transform(nTotNecessidade,"@E 999,999,999.9999")) + Chr(13)

											U_UMsgStop(cTxt)
											_Retorno := .F.
											Exit
										Else
											If ntotPago > (cAliasSD4)->D4_QTDEORI
												U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim((cAliasSD4)->D4_COD) + " foi pago a MAIS para esta OP."+Chr(13)+"Total empenho: " + Alltrim(Transform((cAliasSD4)->D4_QTDEORI,"@E 999,999,999.9999")) + ". Pagamento a mais: " + Alltrim(Transform(ntotPago - (cAliasSD4)->D4_QTDEORI,"@E 999,999,999.9999")) + "." )
												_Retorno := .F.
												Exit
											Else
												// Se for o ultimo apontamento
												If (nTotApto + nD3_QUANT) >= SC2->C2_QUANT

													//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													//³Verifica perdas de produção DOMEX (REQUISITA DIRETO PRA OP) ³
													//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
													cAliasSZA := GetNextAlias()
													cOpOrigem := "%'"+Subs(aOps[nOp,1],1,8)+"'%"

													BeginSQL Alias cAliasSZA
													
													SELECT ZA_FILIAL, ZA_OP, ZA_PRODUTO, ZA_SALDO, R_E_C_N_O_, D_E_L_E_T_
													FROM %Table:SZA% SZA (NOLOCK) WHERE
													SZA.ZA_FILIAL  = %xFilial:SZA% 	           AND
													SZA.ZA_SALDO 	 <> 0 		           		  AND
													Substring(SZA.ZA_OP,1,8) = %Exp:cOpOrigem% AND
													SZA.%NotDel%
													
													EndSQL

													If (cAliasSZA)->(!Eof())
														//"Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+;
															//"Existe pendência de pagamento de perda do produto: " + Alltrim((cAliasSZA)->ZA_PRODUTO) + ;
															//" quantidade " + Alltrim(Transform((cAliasSZA)->ZA_SALDO,"@E 999,999,999.9999")) + " para esta OP.")

														U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"Existe pendência de pagamento de perda do produto: " + Alltrim((cAliasSZA)->ZA_PRODUTO) + " quantidade " + Alltrim(Transform((cAliasSZA)->ZA_SALDO,"@E 999,999,999.9999")) + " para esta OP.")
														_Retorno := .F.
													EndIf
													(cAliasSZA)->(dbCloseArea())

												EndIf
											EndIf
										EndIf

										//EndIf

										(cAliasSD4)->(dbSkip())
										nProcRegua++

										IncProc("Validando pagamento de Materiais... " + Alltrim(Str(nProcRegua)) + "/" + Alltrim(Str(nTotRegProc)))

									EndDo

									(cAliasSD4)->(dbCloseArea())

								EndIf
							Else //lNew

								SC2->( dbSetOrder(1) )
								If SC2->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )
									While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == Subs(aOps[nOp,1],1,11) .and. _Retorno
										//If (SD4->D4_LOCAL == '01' .or. SD4->D4_LOCAL == '02') // .AND. SD4->D4_DATA >= CtoD("12/08/13")
										If SD4->D4_LOCAL $ "99,97,08" //.OR. ALLTRIM(cUserSys)=='000206'//MLS - USUARIO DENIS
											If SD4->D4_LOCAL <> GetMv("MV_LOCPROC")
												If SB1->( dbSeek( xFilial() + SD4->D4_COD	) )
													If SB1->B1_TIPO <> 'MO'
														// Validando se o produto não é de uma OP filha
														cOPProdPI      := SD4->D4_OPORIG
														//bProdPI      := .F.
														//aAreaSC2Temp := SC2->( GetArea() )
														//cRaizOP      := SC2->C2_NUM + SC2->C2_ITEM
														//SC2->( dbSeek( xFilial() + cRaizOP ) )
														//While !SC2->( EOF() ) .and. SC2->C2_NUM + SC2->C2_ITEM == cRaizOP
														//	If SC2->C2_PRODUTO == SD4->D4_COD
														//		bProdPI := .T.
														//		Exit
														//	EndIf
														//	SC2->( dbSkip() )
														//End
														//RestArea(aAreaSC2Temp)

														If Empty(cOPProdPI)

															//cQuery := "SELECT SUM(D3_QUANT) AS SUMD3QTD1 FROM " + RetSqlName("SD3") + " WHERE D3_COD = '"+SD4->D4_COD+"' AND D3_XXOP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_CF = 'DE4' AND D3_LOCAL = '"+GetMV("MV_XXLOCPR")+"' AND D_E_L_E_T_ = '' "  // tratado
															//If Select("TEMP1") <> 0
															//	TEMP1->( dbCloseArea() )
															//EndIf
															//TCQUERY cQuery NEW ALIAS "TEMP1"
															//If (nTotApto + (nIndApto*aOps[nOp,3])) >= SC2->C2_QUANT // M->D3_PARCTOT == 'T'  EM TESTE

															SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado

															If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )

																//cTemp1 := Time()

																//SUMD3QTD1 := 0
																//While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
																//	If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
																//		If SD3->D3_CF == 'DE4'
																//			SUMD3QTD1 += SD3->D3_QUANT
																//		EndIf
																//		If SD3->D3_CF == 'RE4'
																//			SUMD3QTD1 -= SD3->D3_QUANT
																//		EndIf
																//	EndIf
																//	SD3->( dbSkip() )
																//End

																//cTemp2 := Time()

																_cAlias   := GetNextAlias()
																c_cOP     := "%'"+Subs(SD4->D4_OP ,1,11)+"'%"
																c_produto := "%'"+SD4->D4_COD+"'%"
																c_local   := "%'"+cLocProcDom+"'%"
																SUMD3QTD1 := 0
																cFilialSD3 := xFilial("SD3")

																BeginSQL Alias _cAlias
																
																SELECT SUM_D3QTD = SUM(CASE WHEN D3_CF='RE4' THEN -D3_QUANT ELSE +D3_QUANT END)
																FROM SD3010 (NOLOCK)
																WHERE D3_XXOP  = %exp:c_cOP%
																AND   D3_COD   = %exp:c_produto%
																AND   D3_LOCAL = %exp:c_local%
																AND   D3_ESTORNO = '' 
																AND   D3_FILIAL = %exp:cFilialSD3%
																AND   D3_CF      IN ('DE4','RE4')
																AND   D_E_L_E_T_ = ''
																
																EndSQL

																SUMD3QTD1 := (_cAlias)->SUM_D3QTD

																(_cAlias)->( dbCloseArea() )

															EndIf

															SD3->( dbSetOrder(1) )
															SUMD3QTD2 := 0
															If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
																While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_OP + SD3->D3_COD  // tratado
																	If Empty(SD3->D3_ESTORNO) .and. SD3->D3_TM == '571'  // Perda de Fornecedores
																		SUMD3QTD2 += SD3->D3_QUANT
																	EndIf
																	SD3->( dbSkip() )
																End
															EndIf

															// Esta segunda parte vai sumir futuramente
															//cQuery := "SELECT SUM(D3_QUANT) AS SUMD3QTD2 FROM " + RetSqlName("SD3") + " WHERE D3_COD = '"+SD4->D4_COD+"' AND D3_OP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_TM > '500' AND D3_LOCAL <> '"+cLocProcDom+"' AND D_E_L_E_T_ = '' "
															//If Select("TEMP2") <> 0
															//	TEMP2->( dbCloseArea() )
															//EndIf
															//TCQUERY cQuery NEW ALIAS "TEMP2"

															If (nTotApto + (nIndApto*aOps[nOp,3])) >= SC2->C2_QUANT // M->D3_PARCTOT == 'T'
																//Validando se
																//If SD4->D4_QTDEORI > (SUMD3QTD1 + TEMP2->SUMD3QTD2)
																If SD4->D4_QTDEORI > (SUMD3QTD1+SUMD3QTD2)
																	//U_MsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim(SD4->D4_COD) + " não foi totalmente pago para esta OP."+Chr(13)+"Total empenho: " + Alltrim(Transform(SD4->D4_QTDEORI,"@E 999,999,999.9999")) + ". Pendência pagamento: " + Alltrim(Transform(SD4->D4_QTDEORI - (SUMD3QTD1 + TEMP2->SUMD3QTD2),"@E 999,999,999.9999")) + "." )
																	U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim(SD4->D4_COD) + " não foi totalmente pago para a OP "+Alltrim(SD4->D4_OP)+"."+Chr(13)+"Total empenho: " + Alltrim(Transform(SD4->D4_QTDEORI,"@E 999,999,999.9999")) + ". Pendência pagamento: " + Alltrim(Transform(SD4->D4_QTDEORI - (SUMD3QTD1+SUMD3QTD2),"@E 999,999,999.9999")) + "." )
																	If !(Alltrim(Upper(Subs(cUsuario,7,15))) $ "ELIO OPUS/DENIS")
																		_Retorno := .F.
																	Else
																		If Empty(SD4->D4_QUANT)
																			U_UMsgStop("Administrador, como o saldo do empenho deste produto ESTÁ zero, o apontamento por enquanto SERÁ permitido.")
																		Else
																			U_UMsgStop("Administrador, como o saldo do empenho deste produto NÃO ESTÁ zero, o apontamento por enquanto SERÁ permitido.")
																			//_Retorno := .F.
																		EndIf
																	EndIf
																Else
																	If (SUMD3QTD1+SUMD3QTD2) > SD4->D4_QTDEORI
																		U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim(SD4->D4_COD) + " foi pago a MAIS para esta OP."+Chr(13)+"Total empenho: " + Alltrim(Transform(SD4->D4_QTDEORI,"@E 999,999,999.9999")) + ". Pagamento a mais: " + Alltrim(Transform((SUMD3QTD1+SUMD3QTD2) - SD4->D4_QTDEORI,"@E 999,999,999.9999")) + "." )
																		_Retorno := .F.
																	EndIf
																EndIf

																// Perdas de produção
																If _Retorno
																	If SZA->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )
																		While !SZA->( EOF() ) .and. Subs(SZA->ZA_OP,1,11) == Subs(aOps[nOp,1],1,11)
																			If !Empty(SZA->ZA_SALDO)
																				If SB1->( dbSeek( xFilial() + SZA->ZA_PRODUTO ) )
																					If SB1->B1_APROPRI <> 'I' .and. SB1->B1_TIPO <> 'MO'
																						U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"Existe pendência de pagamento de perda do produto: " + Alltrim(SZA->ZA_PRODUTO) + " quantidade " + Alltrim(Transform(SZA->ZA_SALDO,"@E 999,999,999.9999")) + " para esta OP.")
																						_Retorno := .F.
																					EndIf
																				EndIf
																			EndIf
																			SZA->( dbSkip() )
																		End
																	EndIf
																EndIf

																// Perdas de Fornecedores
																If _Retorno
																	If SZE->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )
																		While !SZE->( EOF() ) .and. Subs(SZE->ZE_OP,1,11) == Subs(aOps[nOp,1],1,11)
																			If !Empty(SZE->ZE_SALDO)
																				If SB1->( dbSeek( xFilial() + SZE->ZE_PRODUTO ) )
																					If SB1->B1_APROPRI <> 'I' .and. SB1->B1_TIPO <> 'MO'
																						U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"Existe pendência de pagamento de perda (Fornecedor) do produto: " + Alltrim(SZE->ZE_PRODUTO) + " quantidade " + Alltrim(Transform(SZE->ZE_SALDO,"@E 999,999,999.9999")) + " para esta OP.")
																						_Retorno := .F.
																					EndIf
																				EndIf
																			EndIf
																			SZE->( dbSkip() )
																		End
																	EndIf
																EndIf

															Else
																//cQuery := "SELECT SUM(D3_QUANT) AS SUMD3QTD1 FROM " + RetSqlName("SD3") + " WHERE D3_COD = '"+SD4->D4_COD+"' AND D3_XXOP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_CF = 'DE4' AND D3_LOCAL = '"+GetMV("MV_XXLOCPR")+"' AND D_E_L_E_T_ = '' "
																//If Select("TEMP1") <> 0
																//	TEMP1->( dbCloseArea() )
																//EndIf
																//TCQUERY cQuery NEW ALIAS "TEMP1"

																SD3->(DbOrderNickName("USUSD30001"))  // D3_FILIAL + D3_XXOP + D3_COD   tratado
																//nTemp := SUMD3QTD1
																SUMD3QTD1 := 0

																If SD3->( dbSeek( xFilial() + SD4->D4_OP + SD4->D4_COD ) )
																	While !SD3->( EOF() ) .and. SD4->D4_OP + SD4->D4_COD == SD3->D3_XXOP + SD3->D3_COD  // tratado
																		If Empty(SD3->D3_ESTORNO) .and. SD3->D3_LOCAL == cLocProcDom
																			If SD3->D3_CF == 'DE4'
																				SUMD3QTD1 += SD3->D3_QUANT
																			EndIf
																			If SD3->D3_CF == 'RE4'
																				SUMD3QTD1 -= SD3->D3_QUANT
																			EndIf
																		EndIf
																		SD3->( dbSkip() )
																	End
																EndIf

																//If nTemp <> SUMD3QTD1
																//   n := 1
																//EndIf

																// Esta segunda parte vai sumir futuramente
																//cQuery := "SELECT SUM(D3_QUANT) AS SUMD3QTD2 FROM " + RetSqlName("SD3") + " WHERE D3_COD = '"+SD4->D4_COD+"' AND D3_OP = '"+SD4->D4_OP+"' AND D3_ESTORNO = '' AND D3_TM > '500' AND D3_LOCAL <> '"+cLocProcDom+"' AND D_E_L_E_T_ = '' "
																//If Select("TEMP2") <> 0
																//	TEMP2->( dbCloseArea() )
																//EndIf
																//TCQUERY cQuery NEW ALIAS "TEMP2"

																nTotNecessidade := (nTotApto + (nIndApto*aOps[nOp,3])) * (SD4->D4_QTDEORI / SC2->C2_QUANT)
																ntotPago        := SUMD3QTD1  // + TEMP2->SUMD3QTD2

																If nTotNecessidade > ntotPago
																	U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim(SD4->D4_COD) + " teve "+Alltrim(Transform(ntotPago,"@E 999,999,999.9999"))+" pago para esta OP e sua necessidade seria de " + Alltrim(Transform(nTotNecessidade,"@E 999,999,999.9999")) + "." )
																	_Retorno := .F.
																Else
																	If ntotPago > SD4->D4_QTDEORI
																		U_UMsgStop("Apontamento de Produção da OP " + Alltrim(aOps[nOp,1]) + " não permitido."+Chr(13)+"O Produto " + Alltrim(SD4->D4_COD) + " foi pago a MAIS para esta OP."+Chr(13)+"Total empenho: " + Alltrim(Transform(SD4->D4_QTDEORI,"@E 999,999,999.9999")) + ". Pagamento a mais: " + Alltrim(Transform(ntotPago - SD4->D4_QTDEORI,"@E 999,999,999.9999")) + "." )
																		_Retorno := .F.
																	EndIf
																EndIf
															EndIf
														EndIf
													EndIf
												EndIf
												//EndIf
											EndIf
										Else
											U_UMsgStop("Não é permitido o apontamento de OP com empenho em Almoxarifados diferentes de 08, 97, 99."+Chr(13)+"OP: " + SD4->D4_OP + " Produto: " + SD4->D4_COD + " Local: " + SD4->D4_LOCAL+".")
											_Retorno := .F.
										EndIf
										SD4->( dbSkip() )

										nProcRegua++

										IncProc("Validando pagamento de Materiais... " + Alltrim(Str(nProcRegua)) + "/" + Alltrim(Str(nTotRegProc))+"!!")
									End
								Else
									U_UMsgStop('Ordem de Producao nao encontrada: ' + aOps[nOp,1])
								EndIf


							EndIf lNew
						Else
							U_UMsgStop("Atenção, quantidade da OP " + Alltrim(SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN) + " já finalizada.")
							_Retorno := .F.
						EndIf
						//
					Else

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Seleciona os apontamentos da OP  						³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						_cAlias   := GetNextAlias()
						c_cOP     := "%'"+Subs(aOps[nOp,1],1,11)+"'%"
						cFilialSD3 := xFilial("SD3")

						BeginSQL Alias _cAlias
							
							SELECT SUM(D3_QUANT) AS SUM_D3QTD FROM SD3010 (NOLOCK) WHERE
							D3_OP = %exp:c_cOP% AND 
							(D3_CF = 'PR0' OR D3_CF = 'PR1') AND
							D3_ESTORNO = '' AND D3_FILIAL = %exp:cFilialSD3% AND
							D_E_L_E_T_ = ''
							
						EndSQL

						nTotApto := (_cAlias)->SUM_D3QTD
						(_cAlias)->( dbCloseArea() )

						If 	SC2->( dbSeek( xFilial() + Subs(aOps[nOp,1],1,11) ) )
							If (nTotApto + nD3_QUANT)  > SC2->C2_QUANT
								U_UMsgStop("Atenção, quantidade apontada maior que a quantidade da OP, apontamento atual "+alltrim(str(nD3_QUANT))+", já realizado"+alltrim(str(nTotApto))+", quantidade da OP "+ alltrim(str(SC2->C2_QUANT)) +".")
								_Retorno := .F.
							EndIf
						EndIf

					EndIf
				EndIf
			EndIf
		Next nOp

		// Valindando as necessidades com os saldos em estoque -- Jonas 24/08/2020
		// jonas validacao saldo 99
		If _Retorno
			aNecessidades := {}
			SD4->( dbSetOrder(2) )
			For nOX := 1 to Len(aOPs)
				If SD4->( dbSeek( xFilial() + Subs(aOps[nOX,1],1,11) ) )
					While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,11) == Subs(aOps[nOX,1],1,11)
						If SD4->D4_LOCAL == "99"
							nPos := aScan(aNecessidades,{|aVet| aVet[1] == SD4->D4_COD .and. aVet[2] == SD4->D4_LOCAL })


							If nPos == 0
								AADD(aNecessidades, {SD4->D4_COD, SD4->D4_LOCAL, ROUND(SD4->D4_QTDEORI*nIndApto,4)  })
							Else
								aNecessidades[nPos,3] += ROUND(SD4->D4_QTDEORI*nIndApto,4)
							EndIf


						EndIf
						SD4->( dbSkip() )
					End
				EndIf
			Next nOX

			SB2->( dbSetOrder(1) )
			//If Len(aNecessidades) <> 0
			For nXB := 1 to Len(aNecessidades)
				//                            Produto              Local
				If SB2->( dbSeek( xFilial() + aNecessidades[nXB,1] + aNecessidades[nXB,2] ) ) //.and. aNecessidades[x,2]=="99"

					nP05_SOMA := 0
					cQuery := " SELECT SUM(CAST(RIGHT(RTRIM(P05_SOMA), LEN(RTRIM(P05_SOMA))-PATINDEX('%-%',P05_SOMA)) AS DECIMAL(10,5) )) AS SOMA_P05 FROM P05010 (NOLOCK) WHERE P05_FILIAL='"+xFilial("P05")+"' AND D_E_L_E_T_='' AND  P05_CAMPO='B2_QATU' AND P05_PRODUT='"+aNecessidades[nXB,1]+"' AND P05_LOCAL='99' "

					If Select("TMPP05") <> 0
						TMPP05->( dbCloseArea() )
					EndIf

					// Retirara essa query. Criar indice e colocar While
					TCQUERY cQuery NEW ALIAS TMPP05

					If TMPP05->(!EOF())
						If TMPP05->SOMA_P05 > 0
							nP05_SOMA := TMPP05->SOMA_P05
						EndIf
					EndIf

					TMPP05->( dbCloseArea() )

					If (SB2->B2_QATU - nP05_SOMA) < aNecessidades[nXB,3] //(SB2->B2_QATU ) < aNecessidades[x,3]
						AADD(aInsuficientes,{SB2->B2_COD, SB2->B2_LOCAL, SB2->B2_QATU - nP05_SOMA, aNecessidades[nXB,3]})
					EndIf
					//EndIf
				Else
					AADD(aInsuficientes,{aNecessidades[nXB,1], aNecessidades[nXB,2], 0, aNecessidades[nXB,3]})
				EndIf
			Next nXB
			//EndIf

			If Len(aInsuficientes) <> 0
				//U_UMsgStop("Atenção, quantidade apontada maior que a quantidade da OP, apontamento atual "+alltrim(str(nD3_QUANT))+", já realizado"+alltrim(str(nTotApto))+", quantidade da OP "+ alltrim(str(SC2->C2_QUANT)) +".")
				For nU := 1 to Len(aInsuficientes)
					cTimeEnv := DtoC(Date())+'-'+Time()
					//         Protudo               Saldo                                             Local                  Necessidade
					U_VD3MAIL1(aInsuficientes[nU,1], Transform(aInsuficientes[nU,3],"@E 999,999.9999"),aInsuficientes[nU,2] , aInsuficientes[nU,4] , cTimeEnv )

					//U_uMsgYesNo("Falta de Saldo...Enviando e-mail ..."+ DTOC(DATE()) + " / "+ Time() +", Produto: "  + aInsuficientes[nU,1] + " Local " + aInsuficientes[nU,2] + " Saldo " + Transform(aInsuficientes[nU,3],"@E 999,999.9999") + " Necessidade " + Transform(aInsuficientes[nU,4],"@E 999,999.9999") + Chr(13)+"."+Chr(13)+"Enviando e-mail de monitoramento: " + cTimeEnv,"Deseja continuar?")

				Next nU
				_Retorno := .T.
			EndIf

		EndIf

		// Fim das Validações
		If _Retorno

			If Len(aOps) > 0
				SD4->( dbSetOrder(2) )
				SB8->( dbSetOrder(3) )   //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)

				If SD4->( dbSeek( xFilial() + Subs(aOps[1,1],1,8) ) )
					cLote := U_RETLOTC6(SD4->D4_OP)
					While !SD4->( EOF() ) .and. Subs(SD4->D4_OP,1,8) == Subs(aOps[1,1],1,8)
						If SB8->( dbSeek( xFilial() + SD4->D4_COD + SD4->D4_LOCAL + cLote ) )
							If SB8->B8_EMPENHO <> 0
								//SB8->( dbGoTo(QUERYSB8->R_E_C_N_O_) )
								//If SB8->( Recno() ) == QUERYSB8->R_E_C_N_O_
								Reclock("SB8",.F.)
								SB8->B8_EMPENHO := 0
								SB8->( msUnlock() )
								//EndIf
								//QUERYSB8->( dbSkip() )
							EndIf
						End
						SD4->( dbSkip() )
					End
					msUnlockAll()
					//   TCSQLEXEC("UPDATE SB8010 SET B8_EMPENHO = 0 WHERE B8_FILIAL = '01' AND B8_EMPENHO <> 0 AND D_E_L_E_T_ = '' ")
				EndIf

			Endif
		EndIf
	EndIf

	RestArea(aAreaSC2)
	RestArea(aAreaSD3)
	RestArea(aAreaSBF)
	RestArea(aAreaSD4)
	RestArea(aAreaGER)

// TESTE TRANSFERENCIA EM
/*
lContinua := .T.

	If lContinua
lRastroL  := Rastro(aCols[n,nPosCODOri],'L')
lRastroS  := Rastro(aCols[n,nPosCODOri],'S')
lLocalizO := Localiza(aCols[n,nPosCODOri])
lLocalizD := Localiza(aCols[n,nPosCODDes])

//-- Produtos sem Rastro ou Localizacao mas com Controle de Estoque (ou integracao com WMS)
//-- Negativo - Impede Movimentacoes que causem Saldo Negativo no SB2
		If !lPermNegat .And. ;
(!(lRastroL .Or. lRastroS) .And. (!lLocalizO .And. !lLocalizD) .Or. IntDL(aCols[n,nPosCODOri]))
SB2->(DbSetOrder(1))
				If !SB2->(dbSeek(xFilial('SB2')+aCols[n,nPosCODOri]+aCols[n,nPosLOCOri], .F.))
Help(' ',1,'A260Local')
lRet		:= .F.
lContinua	:= .F.
			EndIf
			If lContinua
//-- Subtrai a Reserva do Saldo a ser Retornado?
				If IntDL(aCols[n,nPosCODOri]) .And. lLocalizO .And. aCols[n,nPosCODOri]==aCols[n,nPosCODDes] .And. aCols[n,nPosLOCOri]==aCols[n,nPosLOCDes] .And. aCols[n,nPosLcZOri]#aCols[n,nPosLcZDes]
lSaldoSemR := .F.
				EndIf
nSaldo := SaldoMov(Nil,Nil,Nil,If(mv_par03==1,.F.,Nil),Nil,Nil, lSaldoSemR, If(Type('dA261Data') == "D",dA261Data,dDataBase))
				For nX := If(!lDigita,n+1,1) to Len(aCols)
					If nX # n
						If !aCols[nX,Len(aCols[nX])].And.(If(lRastroL,aCols[n,nPosLoTCTL]==aCols[nX,nPosLoTCTL],.T.).And.If(lRastroS,aCols[n,nPosNLOTE]==aCols[nX,nPosNLOTE],.T.))
							If aCols[n,nPosCODOri] + aCols[n,nPosLOCOri] == aCols[nX,nPosCODOri] + aCols[nX,nPosLOCOri]
nSaldo -= aCols[nX,nPosQUANT]
							ElseIf aCols[n,nPosCODOri] + aCols[n,nPosLOCOri] == aCols[nX,nPosCODDes] + aCols[nX,nPosLOCDes]
nSaldo += aCols[nX,nPosQUANT]
							EndIf
						EndIf
					EndIf
				Next nX
				If QtdComp(nSaldo) < QtdComp(nQuant)
Help(' ',1,'MA240NEGAT')
lRet		:= .F.
lContinua	:= .F.
				EndIf
			EndIf
		EndIf
	EndIf

//-- Produto Origem com Localizacao - Impede Movimentacoes com
//-- Quantidades maiores que o Saldo no SBF
	If lContinua .And. lLocalizO
		If Empty(aCols[n,nPosLcZOri]+aCols[n,nPosNSer]) .Or. ;
(!Empty(aCols[n,nPosLcZOri]) .And. !SBE->(dbSeek(xFilial('SBE')+aCols[n,nPosLOCOri]+aCols[n,nPosLcZOri],.F.)))
Help(' ',1,'MA260OBR')
lRet		:= .F.
lContinua	:= .F.
			EndIf
		If lContinua
nSaldo := SaldoSBF(aCols[n,nPosLOCOri],aCols[n,nPosLcZOri],aCols[n,nPosCODOri],aCols[n,nPosNSer],aCols[n,nPosLoTCTL],aCols[n,nPosNLOTE])
			For nX := If(!lDigita,n+1,1) to Len(aCols)
				If nX # n
					If !aCols[nX,Len(aCols[nX])].And.(If(lRastroL,aCols[n,nPosLoTCTL]==aCols[nX,nPosLoTCTL],.T.).And.If(lRastroS,aCols[n,nPosNLOTE]==aCols[nX,nPosNLOTE],.T.))
						If aCols[n,nPosCODOri] + aCols[n,nPosLOCOri] + aCols[n,nPosCODDes] + aCols[n,nPosNSer] == aCols[nX,nPosCODOri] + aCols[nX,nPosLcZOri] + aCols[nX,nPosLcZOri] + aCols[nX,nPosNSer]
nSaldo -= aCols[nX,nPosQUANT]
						ElseIf aCols[n,nPosCODOri] + aCols[n,nPosLOCOri]  + aCols[n,nPosLcZOri] + aCols[n,nPosNSer] == aCols[nX,nPosCODDes] + aCols[nX,nPosLOCDes] + aCols[nX,nPosLcZDes] + aCols[nX,nPosNSer]
nSaldo += aCols[nX,nPosQUANT]
						EndIf
					EndIf
				EndIf
			Next nX
			If QtdComp(nSaldo) < QtdComp(nQuant)
Help(' ',1,'SALDOLOCLZ')
lRet		:= .F.
lContinua	:= .F.
			EndIf
		EndIf
	EndIf

//-- Produto Destino com Localizacao - Impede Movimentacoes com
//-- Quantidades superiores a Capacidade no SBE
	If lContinua .And. lLocalizD
		If (aCols[n,nPosLOCDes] == cLocCQ .And. Empty(aCols[n,nPosLcZDes]+aCols[n,nPosNSer])) .Or. ;
(!Empty(aCols[n,nPosLcZDes]) .And. !SBE->(dbSeek(xFilial('SBE')+aCols[n,nPosLOCDes]+aCols[n,nPosLcZDes],.F.)))
Help(' ',1,'MA260OBR')
lRet		:= .F.
lContinua	:= .F.
			EndIf
		If lContinua
nSaldo := QuantSBF(aCols[n,nPosLOCDes],aCols[n,nPosLcZDes],aCols[n,nPosCODDes])
			For nX := If(!lDigita,n+1,1) to Len(aCols)
				If nX # n
					If !aCols[nX,Len(aCols[nX])].And.(If(lRastroL,aCols[n,nPosLoTCTL]==aCols[nX,nPosLoTCTL],.T.).And.If(lRastroS,aCols[n,nPosNLOTE]==aCols[nX,nPosNLOTE],.T.))
						If	aCols[n,nPosCODDes] + aCols[n,nPosLOCDes] + aCols[n,nPosLcZDes] == aCols[nX,nPosCODOri] + aCols[nX,nPosLOCOri] + aCols[nX,nPosLcZOri]
nSaldo -= aCols[nX,nPosQUANT]
						ElseIf aCols[n,nPosCODDes] + aCols[n,nPosLOCDes] + aCols[n,nPosLcZDes] == aCols[nX,nPosCODDes] + aCols[nX,nPosLOCDes] + aCols[nX,nPosLcZDes]
nSaldo += aCols[nX,nPosQUANT]
						EndIf
					EndIf
				EndIf
			Next nX
			If SBE->(!Eof()) .And. QtdComp(SBE->BE_CAPACID)>QtdComp(0) .And. (QtdComp(SBE->BE_CAPACID)<QtdComp(nQuant+QuantSBF(cLocDest, cLoclzDest)))
Help(' ',1,'MA265CAPAC')
lRet		:= .F.
lContinua	:= .F.
			EndIf
		EndIf
	EndIf

//-- Produto Origem com Rastro - Impede Movimentacoes com Quantidades
//-- maiores que as existentes no Lote/SubLote de Origem
	If lContinua .And. (lRastroL .Or. lRastroS)
		If lRastroL
SB8->(dbSetOrder(3))
			If !SB8->(dbSeek(xFilial('SB8')+aCols[n,nPosCODOri]+aCols[n,nPosLOCOri]+aCols[n,nPosLoTCTL],.F.))
Help(' ', 1, 'A240LOTERR')
lRet		:= .F.
lContinua	:= .F.
			Else
nSaldo := SaldoLote(aCols[n,nPosCODOri],aCols[n,nPosLOCOri],aCols[n,nPosLoTCTL],NIL,NIL,NIL,NIL,dA261Data)
			EndIf
		ElseIf lRastroS
SB8->(dbSetOrder(2))
			If !SB8->(dbSeek(xFilial('SB8')+aCols[n,nPosNLOTE]+aCols[n,nPosLoTCTL]+aCols[n,nPosCODOri]+aCols[n,nPosLOCOri],.F.))
Help(' ', 1, 'A240LOTERR')
lRet		:= .F.
lContinua	:= .F.
			Else
nSaldo := SB8Saldo(nil,.T.,nil,nil,nil,lEmpPrev,nil,dA261Data)
			EndIf
		EndIf
		If lContinua
			For nX := If(!lDigita,n+1,1) to Len(aCols)
				If nX # n
					If !aCols[nX,Len(aCols[nX])].And.(If(lRastroL,aCols[n,nPosLoTCTL]==aCols[nX,nPosLoTCTL],.T.).And.If(lRastroS,aCols[n,nPosNLOTE]==aCols[nX,nPosNLOTE],.T.))
						If aCols[n,nPosCODOri] + aCols[n,nPosLOCOri] + aCols[n,nPosLoTCTL] + If(lRastroS,aCols[n,nPosNLOTE],'') == aCols[nX,nPosCODOri] + aCols[nX,nPosLOCOri] + aCols[nX,nPosLoTCTL] + If(lRastroS,aCols[nX,nPosNLOTE],'')
nSaldo -= aCols[nX,nPosQUANT]
						EndIf
					EndIf
				EndIf
			Next nX
			If QtdComp(nSaldo) < QtdComp(nQuant)
cHelp:=Substr("STR0006",1,4)+" "+aCols[n,nPosCODOri]+Substr("STR0018",1,4)+" "+aCols[n,nPosLoTCTL]
Help(" ",1,"MA240NEGAT",,cHelp,4,1)
lRet		:= .F.
lContinua	:= .F.
			EndIf
		EndIf
	EndIf
*/

Return _Retorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVerSilk  ºAutor  ³Michel Sander       º Data ³  28.03.17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se existe produto Silk na estrutura               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fVerSilk(cCodSilk)

	LOCAL lVerSilk := .F.

	cAliasSG1 := GetNextAlias()
	cProdOrig := "%'"+cCodSilk+"'%"
	cFilialSG1 := xFilial("SG1")

	BeginSQL Alias cAliasSG1
	
	SELECT G1_FILIAL, G1_COD, G1_COMP FROM %table:SG1% SG1 (NOLOCK) WHERE G1_FILIAL = %exp:cFilialSG1% AND G1_COD = %Exp:cProdOrig% AND SUBSTRING(G1_COMP,1,6) = '500960' AND SG1.%NotDel%
	
	EndSQL

	lVerSilk := If((cAliasSG1)->(!EOF()), .T., .F.)
	(cAliasSG1)->(dbCloseArea())

Return ( lVerSilk )

User Function ATUD4XOP()
	Local cAliasSD4 := RetSqlName("SD4")
	Local cQuery    := "SELECT TOP 1 R_E_C_N_O_ FROM " + cAliasSD4 + " WHERE D4_FILIAL = '"+xFilial("SD4")+"' AND D4_XOP = '' "
	Local cUpdate   := "UPDATE " + cAliasSD4 + " SET D4_XOP = SUBSTRING(D4_OP,1,8) WHERE D4_XOP = '' "

	If Select("TEMPSD4")<>0
		TEMPSD4->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TEMPSD4"

	If !TEMPSD4->( EOF() )
		TCSQLEXEC(cUpdate)
	ENDIF

	TEMPSD4->( dbCloseArea() )

Return
