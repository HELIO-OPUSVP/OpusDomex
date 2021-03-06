#INCLUDE "TOTVS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A250PRLT    �Autor  �Mauricio L. Souza � Data �  13/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Troca ou Trata o lote e a data de validade���
���          � Apontamento de OP                                          ���
�������������������������������������������������������������������������͹��
��                                                                        ���
�� O P.E. deve retornar um array bidimensional com as informacoes:        ���
�� [1] Lote a ser utilizado                                               ���
�� [2] Data de validade a ser utilizada                                   ���
�� [3] Campo logico onde ira inibir a tela de getdados da sugestao        ���
��     do lote. .F. N�O exibe a tela                                      ���
��                                                                        ���
��	chamada no fonte MATA250	                                            ���
��	aRetExecBl:=ExecBlock("A250PRLT",.F.,.F.,                              ���
��	  {aCols[nx,6],aCols[nx,7],lExibeLt})                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*--------------------------------------------------------------*
User Function A250PRLT()
*--------------------------------------------------------------*
Local aArea250  := GetArea()
Local aAreaSG1  := SG1->( GetArea() )
Local nX        := 0
Local cSEQUEN   := ''
Local cLote     := ''                       //-- Lote sugerido pelo sistema
Local cData     := StoD("20491231")         //-- Data de Validade sugerida pelo sistema
Local lExibeLt  := .F.                      //-- Exibir a getdados para confirma��o da sugest�o do lote na tela.
Local aRet      := {}

cSEQUEN:=SUBSTR(SC2->C2_SEQUEN,2,2)

IF VAL(SC2->C2_SEQUEN)>99
	cSEQUEN:='99'
	FOR nX :=100 TO VAL(SC2->C2_SEQUEN)
		cSEQUEN:=SOMA1(cSEQUEN)
	NEXT
ENDIF

lSilk := .F. 
//-------------------------ALTERA��O 20/05/2015 --------MAURICIO----------------------------
/*
If SG1->( dbSeek( xFilial() + SC2->C2_PRODUTO   ) )
	While !SG1->( EOF() ) .and. SG1->G1_COD == SC2->C2_PRODUTO
		If Subs(SG1->G1_COMP,1,6) == '500960'
			lSilk := .T.
			Exit
		EndIf
		SG1->( dbSkip() )
	End
EndIf
*/

SG1->(DBSETORDER(1))

If SG1->( dbSeek( xFilial() + SC2->C2_PRODUTO +  '500960' ) )
   lSilk := .T.
EndIf
//-------------------------FIM ALTERA��O 20/05/2015 --------MAURICIO----------------------------

//If !lSilk
   cLote    := U_RetLotC6(SC2->C2_NUM+SC2->C2_ITEM+cSEQUEN)   
//Else
//   cLote    := "LOTE1308"
//EndIf

aRet     := {cLote,cData,lExibeLt}

RestArea(aAreaSG1)
RestArea(aArea250)

Return aRet
