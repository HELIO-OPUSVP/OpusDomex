#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2520E   ºAutor  ³Helio Ferreira/Michel Data ³  23/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada rodado na exclusão de toda NF de saída    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//FILIALMG

User Function SF2520E()

Local aAreaGER := GetArea()
Local aAreaSD2 := SD2->( GetArea() )
Local aAreaSF2 := SF2->( GetArea() )
Local nTotLiq  := 0
Local nTotBru  := 0
Local nVolumes := 0
Local nQtdSD2  := 0
Local nQtdXD1  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca os volumes montados para o pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SD2->( dbSetOrder(3) )
If SD2->( dbSeek( xFilial() + SF2->F2_DOC + SF2->F2_SERIE ) )
	
	cAliasXD1 := GetNextAlias()
	cWhereXD1 := "%SUBSTRING(XD1_PVSEP,1,6) = '"+SD2->D2_PEDIDO+"' AND XD1_ZYNOTA = '"+SF2->F2_DOC+"' AND XD1_ZYSERI = '"+SF2->F2_SERIE+"' AND XD1_OCORRE <> '5'%"
	
	BeginSQL Alias cAliasXD1
		
		SELECT XD1_XXPECA, XD1_PESOB, XD1_NIVEMB, R_E_C_N_O_ FROM %table:XD1% XD1 (NOLOCK)
		WHERE XD1.%NotDel%
		AND %Exp:cWhereXD1%
		
	EndSQL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Procura as caixas do volume selecionado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do While (cAliasXD1)->(!Eof())
		
		XD1->( dbGoto( (cAliasXD1)->R_E_C_N_O_) )
		If XD1->( Recno() ) == (cAliasXD1)->R_E_C_N_O_
			If XD1->XD1_OCORRE=="9"
				Reclock("XD1",.F.)
				XD1->XD1_ZYNOTA  := ""
				XD1->XD1_ZYSERIE := ""
				XD1->XD1_ZYDTNF  := CTOD("")
				XD1->XD1_OCORRE  := "4"
				XD1->XD1_PVSEP   := ""
				XD1->XD1_FILORI  := ""
				XD1->( msUnlock() )
			else				
				Reclock("XD1",.F.)
				XD1->XD1_ZYNOTA  := ""
				XD1->XD1_ZYSERIE := ""
				XD1->XD1_ZYDTNF  := CTOD("")
				XD1->( msUnlock() )
			EndIf
		EndIf
		
		(cAliasXD1)->(dbSkip())

	EndDo
	
   Reclock("SF2",.F.)
   SF2->F2_XXVOLUM := 0
   SF2->F2_XXPESOB := 0
   SF2->F2_XXPESOL := 0
   SF2->F2_XXESPEC := ""
   SF2->(MsUnlock())
  
  // Adicionado em 20/09/2019 para Limpar SZY após exclusão de Documento de Saída.    
   cQRY := " UPDATE SZY010 SET ZY_NOTA = '',ZY_SERIE='',ZY_ITEMNF='' WHERE  ZY_NOTA = '"+SF2->F2_DOC+"' AND ZY_SERIE='"+F2_SERIE+"'   and D_E_L_E_T_<>'*'  "
	TCSQLEXEC(cQRY)
   
	
EndIf

RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aAreaGER)

Return
