#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RGPEXFUN ºAutor  ³Michel Sander       º Data ³  02/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funções genéricas para roteiro de cálculo da folha         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RGPEM01()
                           
LOCAL aArea 	 := GetArea()
LOCAL cAliasRGB := GetNextAlias() 
LOCAL cPerCalc  := SubStr(DTOS(M->RG_DTGERAR),1,6)
LOCAL cWhere    := "%RGB_MAT='"+SRA->RA_MAT+"' AND RGB_PROCES='"+SRA->RA_PROCES+"' AND RGB_ROTEIR='RES' AND RGB_PERIOD='"+cPerCalc+"' AND RGB_TIPO2='I'%"

BEGINSQL Alias cAliasRGB
	
	SELECT * FROM %Table:RGB% (NOLOCK) RGB
	WHERE RGB.%NotDel% AND %Exp:cWhere%
	
ENDSQL

If (cAliasRGB)->(!Eof())

	If MsgYesNo("Deseja importar lançamentos fixos para a complementar?")

		Do While (cAliasRGB)->(!Eof())

			fGeraVerba((cAliasRGB)->RGB_PD,(cAliasRGB)->RGB_VALOR,(cAliasRGB)->RGB_HORAS,,,,,,,,.T.)			
			(cAliasRGB)->(dbSkip())

		EndDo

	EndIf
                                
   nPosVerba := fLocaliaPD("123")
	If nPosVerba <> 0
		If aPD[fLocaliaPD("123"),5] > 0
	      If MsgYesNo("Deseja deletar DSR Indevido?")
	         FDELPD("123")
	      EndIf
	   EndIf
	EndIf
	   
   nPosVerba := fLocaliaPD("106")
	If nPosVerba <> 0
		If aPD[fLocaliaPD("106"),5] > 0
	      If MsgYesNo("Deseja deletar ADICIONAL NOTURNO Indevido?")
	         FDELPD("106")
	      EndIf
	   EndIf
	EndIf

EndIf

(cAliasRGB)->(dbCloseArea())

RestArea(aArea)

Return                                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DOMREF01 ºAutor  ³Michel A. Sander    º Data ³  16/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Roteiro para calculo de refeicoes				              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DOMREF01()
      
LOCAL nSalUso   := SRA->RA_SALARIO // FBuscaPD(aCodFol[31,1])
Local nValDom   := 0
Local nCafe     := 0
Local nDesconto := 0
Local nQtdDHome := 0
//Local cQryHome  := ""
//Local aAreaAtu  := GetArea()

//If SRA->RA_XXREFEI == "S"

	If SRA->RA_CATFUNC $ "M/E"
	
		If nSalUso <= M_REFEICAO    // M_REFEICAO = 2500

		   nCafe   := If(SRA->RA_XXCAFE =="S",M_REFECAFE,0)
		   nValDom := If(SRA->RA_XXREFEI=="S",M_REFEIVAL,0)
		         
		   nDesconto := (nCafe + nValDom)
		   
		ElseIf nSalUso > M_REFEICAO
		   
		   nCafe   := If(SRA->RA_XXCAFE =="S",M_REFECAFE,0)
		   nValDom := If(SRA->RA_XXREFEI=="S",((nSalUso*0.5)/100),0)
		   
		   nDesconto := (nCafe + nValDom)
		EndIf  
		//Verificar os dias de home Office
		/*
		cQryHome := " SELECT TMP.PC_MAT,COUNT(*) QTDABO FROM ( "
		cQryHome += " SELECT PC_MAT,PC_DATA FROM " + RetSQlName("SPC") + " SPC  "
		cQryHome += " JOIN " + RetSqlName("SX6") + " SX6 ON SX6.X6_VAR = 'MV_PAPONTA' AND SX6.X6_FIL = '' "
		cQryHome += " WHERE SPC.D_E_L_E_T_ ='' AND PC_DATA BETWEEN SUBSTRING(X6_CONTEUD,1,8) AND SUBSTRING(X6_CONTEUD,10,8)  AND SPC.PC_ABONO  = '59' AND SPC.PC_MAT = '" + SRA->RA_MAT + "' "
		cQryHome += " GROUP BY PC_MAT,PC_DATA "
		cQryHome += " ) TMP "
		cQryHome += " GROUP BY TMP.PC_MAT "
		
		If Select("QRYHOME") > 0
			QRYHOME->(DbCloseArea())	
		EndIf
		TCQUERY cQryHome NEW ALIAS "QRYHOME"
		iF QRYHOME->(!EOF())
			nQtdDHome :=  QRYHOME->QTDABO
		EndIf
		If Select("QRYHOME") > 0
			QRYHOME->(DbCloseArea())	
		EndIf		
		RestArea(aAreaAtu)
		*/
		//If DIASTRAB > 19
		//	nQtdDHome := 19
		//EndIf
   		//If SRA->RA_SITFOLH == "F" .or. SRA->RA_SITFOLH == "A"
		   //FGeraVerba( aCodfol[0050,1],(nDesconto/30)*DIASTRAB,,,,"V",,,,dDataBase)
		FGeraVerba( "419",iif(((nDesconto/30)*(DIASTRAB - nQtdDHome)) >50,50,((nDesconto/30)*(DIASTRAB - nQtdDHome))) ,,,,"V",,,,dDataBase)
		//Else
		   //FGeraVerba( aCodfol[0050,1],nDesconto,,,,"V",,,,dDataBase)
		   //FGeraVerba( "419",nDesconto,,,,"V",,,,dDataBase)
		//EndIf                                  
		
	EndIf

//EndIf

Return
