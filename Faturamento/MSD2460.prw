#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Helio Ferreira      º Data ³  23/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada rodado após a gravação de cada registro   º±±
±±º          ³ no SD2                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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