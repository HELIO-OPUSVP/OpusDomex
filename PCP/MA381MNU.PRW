#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA381MNU     �Autor  �Helio Ferreira   � Data �  30/04/21   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicionar bot�es de browse na tela de���
���          � Ajuste de Empenho Modelo 2                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Domex                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/


User Function MA381MNU()

	aAdd(aRotina,{OemToAnsi('Filtro (CQ)')       , "U_FIL381CQ(.T.)" , 0 , 3, 0, nil} )
	aAdd(aRotina,{OemToAnsi('Libera��o OP (CQ)') , "U_LIB381CQ()" , 0 , 4, 0, nil} )
	aAdd(aRotina,{OemToAnsi('Bloqueio OP (CQ)')  , "U_BLQ381CQ()" , 0 , 4, 0, nil} )

	//If FunName() == "MATA381"
	//	SetKey(VK_F5 ,Nil)
	//	SetKey(VK_F5, { || U_FIL381CQ(.F.) } )
	//EndIf

Return


User Function FIL381CQ(lPergunta)

	Local calias
	Local oObjMBrw := Nil

	//Captura objeto mBrowse
	oObjMBrw := GetObjBrow()

	cAlias:="SD4"//Alias()
	cPerg := PadR("FIL381CQ",10)

	_cFILTER1 := ""

	dbSelectArea(cAlias)

	_cArq     := CriaTrab(NIL,.f.)
	_cKey     := Indexkey()
	_nIndex   := RetIndex(cAlias)

	If lPergunta
		If Pergunte(cPerg,.T.)
			&(cAlias)->(Dbclearfilter())
		Else
			Setmbtopfilter(cAlias,"")
			dbSelectarea(cAlias)
			oObjMBrw:GoTop()
			oObjMBrw:Refresh()
			Return
		EndIf
	Else
		Pergunte(cPerg,.F.)
		&(cAlias)->(Dbclearfilter())
	EndIf

	_cFILTER1 := "D4_FILIAL = '"+xFilial("SD4")+"' "

	If mv_par01 = 1 // Bloqueados
		_cFILTER1 += " AND D4_XBLQCQ = 'S' "
	EndIf

	If mv_par01 = 2 // Liberados
		_cFILTER1 += " AND D4_XBLQCQ <> 'S' "
	EndIf

	//Executa Filtro
	Setmbtopfilter(cAlias,"")
	MsAguarde({|| Setmbtopfilter(cAlias,_cFilter1) },'Filtrando Registros...')

	//Atualizar mBrowse
	oObjMBrw:GoTop()
	oObjMBrw:Refresh()

Return

User Function LIB381CQ()

	Local aAreaSD4 := SD4->( GetArea() )
	Local cOP      := Alltrim(SD4->D4_OP)

	SD4->( dbSetOrder(2) )

	SC2->( dbSetOrder(1) )
	If SC2->( dbSeek( xFilial() + SD4->D4_OP ) )
		If SC2->C2_XBLQCQ == 'S' .or. SC2->C2_XBLQCQ == 'W'
			If MsgYesNo("Confirma a libera��o da OP " + cOP + " para separa��o de materiais?","Aten��o")
				If SD4->( dbSeek( xFilial() + cOP ) )
					While !SD4->( EOF() ) .and. SD4->D4_FILIAL == xFilial("SD4") .and. Alltrim(SD4->D4_OP) == cOP
						Reclock("SD4")
						SD4->D4_XBLQCQ := "N"
						SD4->( msUnlock() )
						SD4->( dbSkip() )
					End
					Reclock("SC2",.F.)
					SC2->C2_XBLQCQ := "N"
					SC2->C2_XTPBLQ := ""
					SC2->( msUnlock() )
					MsgInfo("Libera��o realizada com sucesso","Ok")
				EndIf
			Else
				MsgInfo("Libera��o cancelada","Aten��o")
			EndIf
		Else
			MsgInfo("OP j� liberada","Aten��o")
		EndIf
	EndIf

	RestArea(aAreaSD4)

Return

User Function BLQ381CQ()

	Local aAreaSD4 := SD4->( GetArea() )
	Local cOP      := Alltrim(SD4->D4_OP)

	SD4->( dbSetOrder(2) )

	SC2->( dbSetOrder(1) )
	If SC2->( dbSeek( xFilial() + SD4->D4_OP ) )
		If SC2->C2_XBLQCQ == 'N' .or. Empty(SC2->C2_XBLQCQ)
			If MsgYesNo("Confirma o bloqueio da OP " + cOP + " para separa��o de materiais?","Aten��o")
				If SD4->( dbSeek( xFilial() + cOP ) )
					While !SD4->( EOF() ) .and. SD4->D4_FILIAL == xFilial("SD4") .and. Alltrim(SD4->D4_OP) == cOP
						Reclock("SD4")
						SD4->D4_XBLQCQ := "S"
						SD4->( msUnlock() )
						SD4->( dbSkip() )
					End
					Reclock("SC2",.F.)
					SC2->C2_XBLQCQ := "S"
					SC2->C2_XTPBLQ := ""
					SC2->( msUnlock() )
					MsgInfo("Bloqueio realizado com sucesso","Ok")
				EndIf
			Else
				MsgInfo("Bloqueio cancelado","Aten��o")
			EndIf
		Else
			MsgInfo("OP j� bloqueada","Aten��o")
		EndIf
	EndIf

	RestArea(aAreaSD4)

Return
