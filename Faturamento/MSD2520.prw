#include "rwmake.ch"
#include "totvs.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MSD2520  ºAutor  ³Helio Ferreira      º Data ³  23/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada rodado após a exclusao do item da nota    º±±
±±º          ³ 		                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSD2520()

	SZY->( dbSetOrder(2) ) // Pedido + item + data

	If SZY->( dbSeek( xFilial() + SD2->D2_PEDIDO + SD2->D2_ITEMPV + DtoS(SD2->D2_EMISSAO) ) )

		While !SZY->( EOF() ) .and. SZY->ZY_FILIAL == xFilial("SZY") .and. SZY->ZY_PEDIDO == SD2->D2_PEDIDO .AND. SZY->ZY_ITEM == SD2->D2_ITEMPV

			If SZY->ZY_NOTA == SD2->D2_DOC .And. SZY->ZY_SERIE == SD2->D2_SERIE .And. SZY->ZY_ITEMNF == SD2->D2_ITEM .And. Dtos(SZY->ZY_PRVFAT) == Dtos(SD2->D2_EMISSAO)
				Reclock("SZY",.F.)
				SZY->ZY_NOTA   := ""
				SZY->ZY_SERIE  := ""
				SZY->ZY_ITEMNF := ""
				SZY->( msUnlock() )
			EndIf
			SZY->(dbSkip())

		EndDo

	EndIf


	// Limpa Registro no SD9 para permitir Reutilizar a NF - 15/05/2020 - MAURESI
	////if Alltrim(SD2->D2_SERIE) == "A"
	// esta retornando, NF com chave no sefaz e autorização de cancelamento
	if Alltrim(SD2->D2_SERIE) $ "A/001"
		cQuery := " UPDATE " +RetSqlName("SD9")+" "
		cQuery += " SET D9_FILIAL = '',D9_DTUSO='',D9_HORA='',D9_USUARIO='',D9_FILORI='' "
		cQuery += " WHERE D9_SERIE = '"+SD2->D2_SERIE+"' AND D9_DOC = '"+SD2->D2_DOC+"'  AND D9_FILIAL='01' "
		cQuery += " AND D9_DOC+D9_SERIE NOT IN "
		cQuery += " (SELECT TOP 1 F2_DOC+F2_SERIE FROM SF2010 "
		cQuery += " WHERE F2_DOC='"+SD2->D2_DOC+"' AND F2_SERIE='"+SD2->D2_SERIE+"' AND F2_CHVNFE<>'' "
		cQuery += " AND F2_FILIAL='01') "
		// ALTERACAO MLS  16/09/2020, PARA NAO RETORNAR NOTA EXCLUIDA(CANCELADA) COM CHAVE NO SEFAZ

		//TCSQLEXEC(cQuery)

	endif


Return ( .T. )
