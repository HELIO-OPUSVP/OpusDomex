#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AtuPesoNf�Autor  �Michel A. Sander    � Data �  23/11/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza peso e volume na nota fiscal de saida             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function AtuPesoNf(cFilUso, cNfsUso, cSerUso, cCliUso, cLojUso, dEmiUso)

	Local aAreaGER := GetArea()
	Local aAreaSD2 := SD2->( GetArea() )
	Local aAreaSF2 := SF2->( GetArea() )
	Local	lTodosOk := .T.
	Local	nPesoLiq := 0

//���������������������������������������Ŀ
//�Busca os volumes montados para o pedido�
//�����������������������������������������
	SF2->( dbSetOrder(1) )
	SD2->( dbSetOrder(3) )

	If SD2->( dbSeek( cFilUso + cNfsUso + cSerUso ) )

		// Retirado por Michel Sander em 10.05.2018 para considerar Paletes e Volumes avulsos no mesmo pedido
		//���������������������������������������Ŀ
		//�Procura os volumes da Nota Fiscal      �
		//�����������������������������������������
	/*
	cEspecie  := "PALETES"
	cAliasXD1 := GetNextAlias()
	cWhereXD1 := "%SUBSTRING(XD1_PVSEP,1,6) = '"+SD2->D2_PEDIDO+"' AND XD1_ZYNOTA = '"+cNfsUso+"' AND XD1_OCORRE <> '5' AND XD1_NIVEMB = 'P' AND XD1_ULTNIV='S'%"
	cPedXD1   := SD2->D2_PEDIDO
	
		BeginSQL Alias cAliasXD1
		
		SELECT XD1_XXPECA, XD1_PESOB, XD1_NIVEMB, XD1_ULTNIV, R_E_C_N_O_ FROM %table:XD1% XD1 (NOLOCK)
		WHERE XD1.%NotDel%
		AND %Exp:cWhereXD1%
		
		EndSQL

		//���������������������������������������������������Ŀ
		//�Se n�o encotrar PALETES procura os volumes      	  �
		//�����������������������������������������������������
		If (cAliasXD1)->(Eof())
			cEspecie  := "VOLUMES"
			(cAliasXD1)->(dbCloseArea())
			cAliasXD1 := GetNextAlias()
			cWhereXD1 := "%SUBSTRING(XD1_PVSEP,1,6) = '"+SD2->D2_PEDIDO+"' AND XD1_ZYNOTA = '"+cNfsUso+"' AND XD1_OCORRE <> '5' AND XD1_NIVEMB <> '1' AND XD1_ULTNIV='S' AND %"
			cPedXD1   := SD2->D2_PEDIDO

			BeginSQL Alias cAliasXD1
			
			SELECT XD1_XXPECA, XD1_PESOB, XD1_NIVEMB, XD1_ULTNIV, R_E_C_N_O_ FROM %table:XD1% XD1 (NOLOCK)
			WHERE XD1.%NotDel%
			AND %Exp:cWhereXD1%
			
			EndSQL

		EndIf
	*/

		//���������������������������������������Ŀ
		//�Busca volumes e/ou Paletes dispon�veis �
		//�����������������������������������������
		cEspecie  := "VOLUMES"
		cAliasXD1 := GetNextAlias()
		cWhereXD1 := "%SUBSTRING(XD1_PVSEP,1,6) = '"+SD2->D2_PEDIDO+"' AND XD1_ZYNOTA = '"+cNfsUso+"' AND XD1_OCORRE <> '5' AND XD1_NIVEMB <> '1' AND XD1_ULTNIV='S'%"
		cPedXD1   := SD2->D2_PEDIDO

		BeginSQL Alias cAliasXD1
		
		SELECT XD1_XXPECA, XD1_PESOB, XD1_NIVEMB, XD1_ULTNIV, R_E_C_N_O_ FROM %table:XD1% XD1 (NOLOCK)
		WHERE XD1.%NotDel%
		AND %Exp:cWhereXD1%
		
		EndSQL

		//���������������������������������������Ŀ
		//�Soma os pesos		 						   �
		//�����������������������������������������
		nVolumes := 0
		nTotBru  := 0
		nTotLiq  := 0

		Do While (cAliasXD1)->(!Eof())

			nVolumes += 1
			nTotBru  += (cAliasXD1)->XD1_PESOB
			(cAliasXD1)->(dbSkip())

		EndDo

		nTotLiq  := nTotBru - ( (nTotBru * 10) / 100 )
		(cAliasXD1)->(dbCloseArea())

		//���������������������������������������Ŀ
		//�Verifica peso liquido novo				   �
		//�����������������������������������������
		// Inserido por Michel Sander em 20.11.2018 para tratar o peso liquido do produto
		lAjustPeso:= .T.
		If lAjustPeso
			nPesoLiq := 0
			lTodosOk := .T.
			While SD2->(!Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFilUso+cNfsUso+cSerUso+cCliUso+cLojUso
				cVerPeso := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_XPESOOK")
				nPesoLiq += SB1->B1_PESO * SD2->D2_QUANT
				If cVerPeso <> "S"
					lTodosOk := .F.
					Exit
				EndIf
				SD2->(dbSkip())
			End
			If lTodosOk
				If nPesoLiq < nTotBru
					nTotLiq  := nPesoLiq
				EndIf

				/* Worflow para divergencia entre peso bruto x peso liquido na nota fiscal
				If nPesoLiq > nTotBru
					If SD2->( dbSeek( cFilUso + cNfsUso + cSerUso ) )
						While SD2->(!Eof()) .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFilUso+cNfsUso+cSerUso+cCliUso+cLojUso
							If SB1->(dbSeek(xFilial()+SD2->D2_COD))
					      Reclock("SB1",.F.)
					      SB1->B1_XPESOOK := ""
					      SB1->(MsUnlock())
							EndIf
					   SD2->(dbSkip())
						End
					cTxtMsg  := " Divergencia de Peso Liquido maior que o Peso Bruto na nota fiscal de sa�da." + Chr(13)
					cTxtMsg  += " Nota Fiscal = " + cNfsUso  + Chr(13)
					cTexto   := StrTran(cTxtMsg,Chr(13),"<br>")
					cAssunto := "Divergencia entre Peso Bruto x Peso Liquido"
					cPara    := "denis.vieira@rdt.com.br"
					cCC      := ""
					cArquivo := Nil
					U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo)
					EndIf
				EndIf
				*/			
			EndIf
		EndIf

		//���������������������������������������Ŀ
		//�Atualiza peso e volume secundario      �
		//�����������������������������������������
		If SF2->( dbSeek( cFilUso + cNfsUso + cSerUso + cCliUso + cLojUso ) )
			Reclock("SF2",.F.)
			SF2->F2_XXVOLUM := nVolumes
			SF2->F2_XXPESOB := nTotBru
			SF2->F2_XXPESOL := nTotLiq
			SF2->F2_XXESPEC := cEspecie
			IF SF2->F2_EST=='EX'  // exportacao
				SF2->F2_PBRUTO := nTotBru
				SF2->F2_PLIQUI := nTotLiq
			ENDIF
			SF2->(MsUnlock())
		EndIf

	EndIf

	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
	RestArea(aAreaGER)

Return