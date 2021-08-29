#Include "Protheus.ch"

User Function IC2_NUM()

	Local cNumOpAtual := ''
	Local dData 		:= CtoD('22/11/2018')
	Local cAlias 		:= GetNextAlias()
	Local cQuery 		:= ''
	Local cAliasNum	:= ''
	Local aAreaSC2 	:= SC2->(GetArea())

	If dDataBase > dData

		cQuery := "SELECT MAX(C2_EMISSAO) EMISSAO "
		cQuery += "		FROM " + RetSqlName("SC2") + " SC2 "
		cQuery += "		WHERE D_E_L_E_T_ = '' "
		cQuery += "			AND C2_EMISSAO < '" + DtoS(dDataBase) + "'"
		cQuery += "			AND C2_FILIAL = '" + xFilial("SC2") + "'"

		DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAlias),.F.,.T.)

		cAliasNum	:= GetNextAlias()

		cQuery := "SELECT MAX(C2_NUM) NUM "
		cQuery += "	FROM " + RetSqlName("SC2") + " SC2 "
		cQuery += "	WHERE D_E_L_E_T_ = '' "
		cQuery += "		AND C2_EMISSAO >= '" + (cAlias)->EMISSAO + "'
		cQuery += "		AND LEN(C2_NUM) > 5 "
		cQuery += "		AND C2_FILIAL = '" + xFilial("SC2") + "'"

		DbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery),(cAliasNum),.F.,.T.)

		If (cAliasNum)->(!Eof())
			cNumOpAtual := (cAliasNum)->NUM
		EndIf

		(cAliasNum)->(DbCloseArea())
		(cAlias)->(DbCloseArea())

	Else

		cNumOpAtual := '85410 '

	EndIf

	DbSelectArea('SC2')
	SC2->(DbSetOrder(1))
	
	If !Empty(cNumOpAtual)
		While SC2->(DbSeek(xFilial('SC2')+cNumOpAtual))
			cNumOpAtual := AllTrim(StrZERO(Val(cNumOpAtual)+1,6))
		EndDo
	Else
       cNumOpAtual := StrZero(1,Len(SC2->C2_NUM))
	EndIf

	RestArea(aAreaSC2)

Return cNumOpAtual
