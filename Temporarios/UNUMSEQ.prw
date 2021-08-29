#include "rwmake.ch"
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UNUMSEQ   ºAutor  ³Helio Ferreira      º Data ³  26/08/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de semáforo para movimentações de estoque/aberturaº±±
±±º          ³ OP                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function INUMSEQ(cRotina)   //UNUMSEQ
Local _Retorno
Local aAreaGER := GetArea()
Local nLoop    := 0
Local lLoop    := .T.
Local lWhile   := .T.

Private nTempoMin := 5

//Default cCodigo := ""
//Default cRotina := ""

If !Empty(__XXNumSeq)
   MsgStop("Finalizando o semáforo " + __XXNumSeq + " na abertura de um novo.")
   U_FNUMSEQ(__XXNumSeq)
EndIf

//If Empty(cCodigo)
	SX6->( Dbsetorder(1) )
	
	If SX6->( dbSeek(SPACE(02)+"MV_XNUMSEQ") )
		While lLoop .and. nLoop < 10000
			If RecLock("SX6",.F.) .And. lLoop
				_NextNum        := Soma1(Alltrim(SX6->X6_CONTEUD))
				SX6->X6_CONTEUD := _NextNum
				SX6->( Msunlock() )
				lLoop    := .F.
			EndIf
			nLoop ++
		End
	EndIf
	
	//BEGIN TRANSACTION
	
	Reclock("SZZ",.T.)
	SZZ->ZZ_FILIAL  := "01"
	SZZ->ZZ_CODIGO  := _NextNum
	SZZ->ZZ_DATA    := Date()
	SZZ->ZZ_HORA    := Time()
	SZZ->ZZ_STATUS  := "0"
	SZZ->ZZ_ID      := If(Empty(__cUserID),"IDBRAN",__cUserID)
	SZZ->ZZ_ROTINA  := cRotina
	SZZ->ZZ_DTULTIM := Date()
	SZZ->ZZ_HRULTIM := Time()
	SZZ->( msUnlock() )
	SZZ->( dbGoTop() )
	
	lWhile := .T.
	
	While lWhile
    	SZZ->( dbSetOrder(2) )    // Status + Codigo
		If SZZ->( dbSeek( xFilial() + "0" ) )
			If SZZ->ZZ_CODIGO == _NextNum
				lWhile := .F.
				_Retorno := _NextNum
			Else
			   SZZ->( dbSetOrder(1) )      // Codigo
				If SZZ->( dbSeek( xFilial() + _NextNum ) )
					Reclock("SZZ",.F.)
					SZZ->ZZ_DTULTIM := Date()
					SZZ->ZZ_HRULTIM := Time()
					SZZ->( msUnlock() )
				EndIf
				
				SZZ->( dbSetOrder(2) )        // Status + Codigo
		      SZZ->( dbSeek( xFilial() + "0" ) )
	
				fEspera()
				
				SZZ->( dbSetOrder(1) )        // Codigo
				SZZ->( dbSeek( xFilial() + _NextNum ) )
				
				fLibSozinho()
			EndIf
		EndIf
	End
//Else
	
//	SZZ->( dbSetOrder(1) )   // ZZ_CODIGO
//	If SZZ->( dbSeek( xFilial() + cCodigo ) )
		//Reclock("SZZ",.F.)
		//SZZ->ZZ_STATUS := '1'
		//SZZ->ZZ_DATAF  := Date()
		
		//If SZZ->( FieldPos("ZZ_HORAF") ) > 0
		//   SZZ->ZZ_HORAF  := Time()
		//EndIf
		
		//SZZ->( msUnlock() )
		
//		TCSQLEXEC("UPDATE " + RetSqlName("SZZ") + " SET ZZ_STATUS = '1',ZZ_DATAF = '"+DtoS(Date())+"',ZZ_HORAF = '"+Time()+"' WHERE R_E_C_N_O_ = " + Str(SZZ->(Recno())))
		
		// End Transaction
		
//	EndIf
//EndIf

RestArea(aAreaGER)

Return _Retorno


User Function FNUMSEQ(cCodigo) // UNUMSEQ
Local _Retorno
Local aAreaGER := GetArea()
Local nLoop    := 0
Local lLoop    := .T.
Local lWhile   := .T.

//Default cCodigo := ""
//Default cRotina := ""

If !Empty(cCodigo)	
	SZZ->( dbSetOrder(1) )   // ZZ_CODIGO
	If SZZ->( dbSeek( xFilial() + cCodigo ) )
		Reclock("SZZ",.F.)
		SZZ->ZZ_STATUS := '1'
		SZZ->ZZ_DATAF  := Date()
	   SZZ->ZZ_HORAF  := Time()
		SZZ->( msUnlock() )
		SZZ->( dbGoTop() )
		//TCSQLEXEC("UPDATE " + RetSqlName("SZZ") + " SET ZZ_STATUS = '1',ZZ_DATAF = '"+DtoS(Date())+"',ZZ_HORAF = '"+Time()+"' WHERE R_E_C_N_O_ = " + Str(SZZ->(Recno())))
		
		// End Transaction
		__XXNumSeq := ""
	EndIf
EndIf

RestArea(aAreaGER)

Return


Static Function fEspera()
Local nMinSZZ
Local nMinAtu

nMinSZZ   :=    (((SZZ->ZZ_DTULTIM - StoD("20170906"))*24)*60) + (Val(Subs(SZZ->ZZ_HRULTIM,1,2))*60) + Val(Subs(SZZ->ZZ_HRULTIM,4,2))
nMinAtu   :=    (((   Date()       - StoD("20170906"))*24)*60) + (Val(Subs(Time()         ,1,2))*60) + Val(Subs(Time()         ,4,2))

MsgRun("Aguardando usuário " + SZZ->ZZ_ID + " - " + UsrFullName(SZZ->ZZ_ID)+" ocorrência " + SZZ->ZZ_CODIGO,"Aguarde: " + Alltrim(Str(nMinSZZ+nTempoMin-nMinAtu)) + " minutos - Rotina" + SZZ->ZZ_ROTINA,{|| Sleep(500) })

Return

Static Function fLibSozinho()

Local nMinSZZ
Local nMinAtu

nMinSZZ   :=    (((SZZ->ZZ_DTULTIM - StoD("20170906"))*24)*60) + (Val(Subs(SZZ->ZZ_HRULTIM,1,2))*60) + Val(Subs(SZZ->ZZ_HRULTIM,4,2))
nMinAtu   :=    (((   Date()       - StoD("20170906"))*24)*60) + (Val(Subs(Time()         ,1,2))*60) + Val(Subs(Time()         ,4,2))

If   nMinAtu > (nMinSZZ + nTempoMin)
	
	TCSQLEXEC("UPDATE " + RetSqlName("SZZ") + " SET ZZ_STATUS = '1',ZZ_DATAF = '"+DtoS(Date())+"',ZZ_HORAF = '"+Time()+"' WHERE R_E_C_N_O_ = " + Str(SZZ->(Recno())))
	
EndIf

Return
