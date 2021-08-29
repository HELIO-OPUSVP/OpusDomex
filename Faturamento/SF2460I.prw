#include "rwmake.ch"
#include "totvs.ch"         
#include "topconn.ch"         

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SF2460I   �Autor  �Helio Ferreira/Michel Data �  23/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada rodado ap�s a grava��o de toda NF         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function SF2460I()

Local aAreaGER := GetArea()
Local aAreaSD2 := SD2->( GetArea() )
Local nTotLiq  := 0
Local nTotBru  := 0
Local nVolumes := 0
Local nQtdSD2  := 0
Local nQtdXD1  := 0
Local cPedXD1  := 0
Local cEspecie

//���������������������������������������Ŀ
//�Busca os volumes montados para o pedido�
//�����������������������������������������
SB1->( dbSetOrder(1) )
SYD->( dbSetOrder(1) )
SD2->( dbSetOrder(3) )

If SF2->F2_XCOLET <> 'S'  // Se n�o for coletor, atualiza o XD1_ZYNOTA
	If SD2->( dbSeek( xFilial() + SF2->F2_DOC + SF2->F2_SERIE ) )
		
		//���������������������������������������Ŀ
		//�Procura os volumes da Nota Fiscal      �
		//�����������������������������������������
		cEspecie  := "PALETES"
		cAliasXD1 := GetNextAlias()
		cWhereXD1 := "%SUBSTRING(XD1_PVSEP,1,6) = '"+SD2->D2_PEDIDO+"' AND XD1_ZYNOTA ='' AND XD1_OCORRE <> '5' AND XD1_NIVEMB = 'P' AND XD1_ULTNIV='S'%"
		cPedXD1   := SD2->D2_PEDIDO
		
		BeginSQL Alias cAliasXD1
			
			SELECT XD1_XXPECA, XD1_COD, XD1_PESOB, XD1_NIVEMB, XD1_ULTNIV, XD1_QTDATU, R_E_C_N_O_ FROM %table:XD1% XD1 (NOLOCK)
			WHERE XD1.%NotDel%
			AND %Exp:cWhereXD1%
			
		EndSQL
		
		//���������������������������������������������������Ŀ
		//�Se n�o encotrar PALETES procura os volumes      	�
		//�����������������������������������������������������
		If (cAliasXD1)->(Eof())
			cEspecie  := "CAIXAS"
			(cAliasXD1)->(dbCloseArea())
			cAliasXD1 := GetNextAlias()
			cWhereXD1 := "%SUBSTRING(XD1_PVSEP,1,6) = '"+SD2->D2_PEDIDO+"' AND XD1_ZYNOTA ='' AND XD1_OCORRE <> '5' AND XD1_NIVEMB <> '1' AND XD1_ULTNIV='S'%"
			cPedXD1   := SD2->D2_PEDIDO
			
			BeginSQL Alias cAliasXD1
				
				SELECT XD1_XXPECA, XD1_COD, XD1_PESOB, XD1_NIVEMB, XD1_ULTNIV, XD1_QTDATU, R_E_C_N_O_ FROM %table:XD1% XD1 (NOLOCK)
				WHERE XD1.%NotDel%
				AND %Exp:cWhereXD1%
				
			EndSQL
			
		EndIf
		
		aVetXD1 := {}
		aVetSD2 := {}
		
		/* INSERIDO POR MICHEL SANDER em 26.07.2018 para atualizar o fator de convers�o em KG para exporta��o no SB5
		
		//���������������������������������������Ŀ
		//�Agrupa os volumes por codigos e peso	�
		//�����������������������������������������
		aVetPeso:= {}
		While !(cAliasXD1)->( EOF() )
		nPosPeso := aScan( aVetPeso, { |aVet| aVet[1] == (cAliasXD1)->XD1_COD } )
		If nPosPeso == 0
		AADD(aVetPeso, { (cAliasXD1)->XD1_COD, (cAliasXD1)->XD1_PESOB, (cAliasXD1)->XD1_QTDATU } )
		Else
		aVetPeso[nPosPeso, 2] += (cAliasXD1)->XD1_PESOB
		aVetPeso[nPosPeso, 3] += (cAliasXD1)->XD1_QTDATU
		EndIf
		(cAliasXD1)->( dbSkip() )
		EndDo
		*/
		
		nPesoTeor := 0
		While !(cAliasXD1)->( EOF() )
			nTemp := aScan( aVetXD1, { |aVet| aVet[1] == (cAliasXD1)->XD1_COD  } )
			If Empty(nTemp)
				AADD(aVetXD1,{(cAliasXD1)->XD1_COD,(cAliasXD1)->XD1_QTDATU})
			Else
				aVetXD1[nTemp,2] += (cAliasXD1)->XD1_QTDATU
			EndIf
			nPesoTeor += (cAliasXD1)->XD1_PESOB
			
			(cAliasXD1)->( dbSkip() )
		End
		(cAliasXD1)->( dbGoTop() )
		nPesoTeor := Round( ( ( nPesoTeor * 90 ) / 100 ), 2 )
		
		While !SD2->( EOF() ) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == SF2->F2_DOC .and. SD2->D2_SERIE == SF2->F2_SERIE
			nTemp := aScan( aVetSD2, { |aVet| aVet[1] == SD2->D2_COD } )
			If Empty(nTemp)
				//AADD(aVetSD2,{SD2->D2_COD,SD2->D2_QUANT})
				// Inserido Por Michel Sander em 27.07.2018 para tratar convers�o de unidade para exporta��o
				AADD(aVetSD2,{SD2->D2_COD,SD2->D2_QUANT,SD2->D2_GRUPO,Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_PESO"), SD2->( Recno() ), (Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_PESO")*SD2->D2_QUANT)})
			Else
				aVetSD2[nTemp,2] += SD2->D2_QUANT
			EndIf
			SD2->( dbSkip() )
		End
		SD2->( dbSeek( xFilial() + SF2->F2_DOC + SF2->F2_SERIE ) )
		
		If Len(aVetXD1) == Len(aVetSD2)
			aSort(aVetXD1,,,{|x,y| x[1]>y[1]})
			aSort(aVetSD2,,,{|x,y| x[1]>y[1]})
			
			lOk := .T.
			For x := 1 to Len(aVetXD1)
				If aVetXD1[x,2] <> aVetSD2[x,2]
					lOk := .F.
					Exit
				EndIf
			Next x
			
			//���������������������������������������Ŀ
			//�Atualiza volumes								�
			//�����������������������������������������
			If lOk
				Do While (cAliasXD1)->(!Eof())
					
					//���������������������������������������Ŀ
					//�Atualiza Nota Fiscal nos Volumes       �
					//�����������������������������������������
					XD1->( dbGoto( (cAliasXD1)->R_E_C_N_O_) )
					If XD1->( Recno() ) == (cAliasXD1)->R_E_C_N_O_
						Reclock("XD1",.F.)
						XD1->XD1_ZYNOTA  := SF2->F2_DOC
						XD1->XD1_ZYSERIE := SF2->F2_SERIE
						XD1->XD1_ZYDTNF  := SF2->F2_EMISSAO
						XD1->( msUnlock() )
					EndIf
					
					(cAliasXD1)->(dbSkip())
					
				EndDo
			EndIf
		EndIf
		(cAliasXD1)->(dbCloseArea())
		
		//����������������������������������������������������Ŀ
		//�Atualiza peso por fator de convers�o p/ exporta��o  �
		//������������������������������������������������������
		If SF2->F2_EST == "EX"
			nTotPesoB1 := 0
			aEval(aVetSD2, {|x| nTotPesoB1 += x[6] })
			For nX := 1 to Len(aVetSD2)
				If SB1->(dbSeek(xFilial("SB1")+aVetSD2[nX,1]))
					If SYD->(dbSeek(xFilial("SYD")+SB1->B1_POSIPI))
						If SYD->YD_XXFATEX == "S"
							nFator  := ( nPesoTeor / nTotPesoB1 )         
							nResult := SB1->B1_PESO * nFator              
							SD2->(dbGoto(aVetSD2[nX,5]))
							Reclock("SD2",.F.)
							SD2->D2_XXFATEX := Round(nResult,3)
							SD2->D2_PESO    := Round(nResult,3)
							//SD2->D2_XXFATEX := Round(nPesoTeor/SD2->D2_QUANT,3)
							//SD2->D2_PESO    := Round(nPesoTeor/SD2->D2_QUANT,3)
							SD2->(MsUnlock())
							IF SD2->D2_EST=='EX' // EXPORTACAO
								Reclock("SB1",.F.)
								SB1->B1_PESO   := Round(nResult,3)
								SB1->B1_PESBRU := (Round(nResult,3)*1.1)
								SB1->(MsUnlock())
							ENDIF
						EndIf
					EndIf
				EndIf
			Next nX
		EndIf
		
	EndIf
	
EndIf

If SuperGetMV("MV_XANACRE")    // Par�metro geral de liga/desliga an�lise de Cr�dito Domex
	U_TRATASE1(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
EndIf

RestArea(aAreaSD2)
RestArea(aAreaGER)

Return
