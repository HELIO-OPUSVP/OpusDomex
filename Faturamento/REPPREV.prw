#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �REPPREV   �Autor  �Helio Ferreira      � Data �  07/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function REPPREV()

Local cPerg  := 'REPPREV'
Local cCadastro := "REPPREV() - Rotina de R�plica de Previs�es de Vendas"
Local aButtons  := {}
Local aSays     := {}

Pergunte(cPerg,.F.)

cTexto1 := "Este Programa tem por objetivo facilitar a digita��o das Previs�es de Vendas de um m�s "
cTexto2 := "para outro. Nos parametros, deve ser informado o Cliente para o qual se deseja copiar "
cTexto3 := "as Previs�es de Vendas, o m�s e ano de origem e o m�s e ano para o qual se deseja "
cTexto4 := "replicar. Se esta rotina for processada mais de uma vez para o mesmo Cliente/per�odo, "
cTexto5 := "somete as Previs�es de Vendas que ainda n�o foram copiadas ser�o consideradas"
cTexto6 := " nas demais execu��es evitando que se duplique as Previs�es."

AADD(aSays,cTexto1)
AADD(aSays,cTexto2)
AADD(aSays,cTexto3)
AADD(aSays,cTexto4)
AADD(aSays,cTexto5)
AADD(aSays,cTexto6)

AADD(aButtons, { 5,.T.,{||  Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| MsgRun("Replicando Previs�es de Vendas...","Aguarde...",{|| fProcessa()}),o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

Return


Static Function fProcessa()

// mv_par03 = m�s de origem
// mv_par04 = ano de origem
// mv_par05 = m�s de destino
// mv_par06 = ano de destino

If mv_par03 == mv_par05 .and. mv_par04 == mv_par06
	MsgStop("Favor preencher per�odos diferentes nos campos de origem e destino da r�plica de Previs�es de Vendas.")
	Return
EndIf

dDataIni := FirstDay(StoD(StrZero(mv_par04,4)+StrZero(mv_par03,2)+'01'))
dDataFim := LastDay(StoD(StrZero(mv_par04,4)+StrZero(mv_par03,2)+'01'))

cQuery := "SELECT * FROM " + RetSqlName("SC4") + " WHERE C4_XXCLIEN = '"+mv_par01+"' AND C4_XXLOJA = '"+mv_par02+"' AND "
cQuery += "C4_DATA >= '"+DtoS(dDataIni)+"' AND C4_DATA <= '"+DtoS(dDataFim)+"' AND D_E_L_E_T_ = '' "

If Select("QUERYSC4") <> 0
	QUERYSC4->( dbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "QUERYSC4"

lContinua := .T.
While !QUERYSC4->( EOF() )
	cDtDest := StoD(StrZero(mv_par06,4)+StrZero(mv_par05,2)+Subs(QUERYSC4->C4_DATA,7,2))
	If (cDtDest - Date()) < 20
		MsgStop("Existem previs�es de vendas a serem replicadas com menos de 20 dias ("+DtoC(cDtDest)+") a partir da data atual. A c�pia n�o poder� ser realizada.")
		lContinua := .F.
		Exit
	EndIf
	QUERYSC4->( dbSkip() )
End

QUERYSC4->( dbGoTop() )

SC4->( dbSetOrder(6) ) // C4_FILIAL + C4_XXCODPA + C4_DATA
nPrevInc := 0

If lContinua
	If !QUERYSC4->( EOF() )
		While !QUERYSC4->( EOF() )
			dDtOrig := StoD(QUERYSC4->C4_DATA)
			cDtDest := StrZero(mv_par06,4)+StrZero(mv_par05,2)+Subs(QUERYSC4->C4_DATA,7,2)
			
			If cDtDest > DtoS(LastDay(StoD(Subs(cDtDest,1,6)+'01')))
				dDtDest := LastDay(StoD(Subs(cDtDest,1,6)+'01'))
			Else
				dDtDest := StoD(cDtDest)
			EndIf
			
			If !SC4->( dbSeek( xFilial() + QUERYSC4->C4_XXCOD + DtoS(dDtDest) ) )
				Reclock("SC4",.T.)
				SC4->C4_FILIAL  := xfilial("SC4")
				SC4->C4_PRODUTO := QUERYSC4->C4_PRODUTO
				SC4->C4_LOCAL   := QUERYSC4->C4_LOCAL
				SC4->C4_QUANT   := QUERYSC4->C4_XXQTDOR
				SC4->C4_DATA    := dDtDest
				SC4->C4_OBS     := QUERYSC4->C4_OBS
				SC4->C4_XXCLIEN := QUERYSC4->C4_XXCLIEN
				SC4->C4_XXLOJA  := QUERYSC4->C4_XXLOJA
				SC4->C4_XXNOMCL := QUERYSC4->C4_XXNOMCL
				SC4->C4_XXQTDOR := QUERYSC4->C4_XXQTDOR
				SC4->C4_XXCNPJ  := QUERYSC4->C4_XXCNPJ
				SC4->C4_XXDTEMI := Date()
				SC4->C4_XXCOD   := U_NEXTPRE()
				SC4->C4_XXCODPA := QUERYSC4->C4_XXCOD
				SC4->( msUnlock() )
				nPrevInc++
			EndIf
			QUERYSC4->( dbSkip() )
		End
	Else
		MsgStop("N�o foram encontradas Previs�es de Vendas para o Cliente: " + mv_par01 + " Loja: " + mv_par02 + Chr(13) +"Entre o per�odo de " + DtoC(dDataIni) + " e " + DtoC(dDataFim) +".")
	EndIf
EndIf

MsgInfo("Foram replicadas " + Alltrim(Str(nPrevInc)) + " Previs�es de Vendas." )

Return
