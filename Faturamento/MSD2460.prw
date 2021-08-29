#include "rwmake.ch"
#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Helio Ferreira      � Data �  23/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada rodado ap�s a grava��o de cada registro   ���
���          � no SD2                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function MSD2460()
Local aSaveArea	:= GetArea()


SZY->( dbSetOrder(2) ) // Pedido + item + data

If SZY->( dbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV ) )  //+ DtoS(SD2->D2_EMISSAO) ) )

	While !SZY->( EOF() ) .and. SZY->ZY_FILIAL == xFilial("SZY") .and. SZY->ZY_PEDIDO == SD2->D2_PEDIDO .AND. SZY->ZY_ITEM == SD2->D2_ITEMPV // .AND. !Empty(SZY->ZY_NOTA)

		if Empty(SZY->ZY_NOTA) .and. (SZY->ZY_PRVFAT == SD2->D2_EMISSAO) .and. SZY->ZY_QUANT = SD2->D2_QUANT 
     
			    Reclock("SZY",.F.)
				    SZY->ZY_NOTA   := SD2->D2_DOC
				    SZY->ZY_SERIE  := SD2->D2_SERIE
				    SZY->ZY_ITEMNF := SD2->D2_ITEM
			    SZY->( msUnlock() )			 
      Endif

		SZY->( dbSkip() )
	End
	
EndIf
 
/*
If SZY->( dbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV + DtoS(SD2->D2_EMISSAO) ) )

	 While !SZY->( EOF() ) .and. SZY->ZY_FILIAL == xFilial("SZY") .and. SZY->ZY_PEDIDO == SD2->D2_PEDIDO .AND. SZY->ZY_ITEM == SD2->D2_ITEMPV .AND. !Empty(SZY->ZY_NOTA)
	    SZY->( dbSkip() )
	 End
	 If SZY->ZY_FILIAL == xFilial("SZY") .and. SZY->ZY_PEDIDO == SD2->D2_PEDIDO .AND. SZY->ZY_ITEM == SD2->D2_ITEMPV .AND. Empty(SZY->ZY_NOTA)
	    Reclock("SZY",.F.)
		    SZY->ZY_NOTA   := SD2->D2_DOC
		    SZY->ZY_SERIE  := SD2->D2_SERIE
		    SZY->ZY_ITEMNF := SD2->D2_ITEM
	    SZY->( msUnlock() )
	 EndIf
	
EndIf
*/
RestArea(aSaveArea)
Return