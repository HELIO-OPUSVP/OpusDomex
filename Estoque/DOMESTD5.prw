#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "MSOBJECT.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DOMESTD5  ºAutor  Jonas            º Data ³  04/11/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rotina de correção de estornos                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User function DOMESTD5()

	Startjob("U_fCorSD5",getenvserver(),.F.,'01','01')  // Empresa 01 filial 01
	Startjob("U_fCorSD5",getenvserver(),.F.,'01','02')  // Empresa 01 filial 02

Return

User Function fCorSD5(__cEmpresa, __cFilial)
	Local dUlmes :=  CTOD('  /  /  ')
	Local cQuery := ""

	RPCSetType(3)
	RpcSetEnv(__cEmpresa,__cFilial,,,"EST")

	dUlmes :=  GetMV("MV_ULMES")

	cQuery := " SELECT R_E_C_N_O_ as REC, D5_PRODUTO AS PROD, D5_LOCAL AS ARM FROM SD5010 (NOLOCK) WHERE D_E_L_E_T_='' AND D5_DATA>='"+dtos(dUlmes)+"' AND D5_ESTORNO='S' "

	If Select("TEMP") <> 0
		TEMP->( dbCloseArea() )
	EndIf

	TCQUERY cQuery NEW ALIAS "TEMP"

	SD5->( dbSetOrder(1) )
	SB1->( dbSetOrder(1) )
	P07->( dbSetOrder(1) )
	While TEMP->(!EOF())
		SD5->(dbgoto(TEMP->REC))
		If TEMP->REC  ==  SD5->(RECNO())
			If SD5->D5_ESTORNO=="S"
				RecLock("SD5",.F.)
				SD5->( dbDelete() )
				SD5->( MsUnlock() )
			Endif
			If SB1->(DBseek(xFilial()+TEMP->PROD))
				//If SB1->B1_TIPO=='PA'
				//	Reclock("P05",.T.)
				//	P05->P05_FILIAL := "01"
				//	P05->P05_ALIAS  := "SB2"
				//	P05->P05_INDICE := "1"
				//	P05->P05_CHAVE  := "01" + TEMP->PROD + TEMP->ARM
				//	P05->P05_CAMPO  := "B2_QEMP"
				//	P05->P05_TIPO   := "N"
				//	P05->P05_SOMA   := "-0"
				//	P05->P05_DTINC  := DATE()
				//	P05->P05_HRINC  := Time()
				//	P05->P05_PRODUT := TEMP->PROD
				//	P05->P05_LOCAL  := TEMP->ARM
				//	P05->( msUnlock() )
				//Else
				If !P07->(dbSeek(xFilial()+TEMP->PROD+SD5->D5_LOCAL))
					RecLock("P07",.T.)
					P07->P07_FILIAL := xFilial("P07")
					P07->P07_PRODUT := TEMP->PROD
					P07->P07_LOCAL	:= TEMP->ARM
					P07->P07_DATA   := StoD('20170101')
					P07->P07_HORA   := "00:00:00"
					P07->( MsUnlock() )
				EndIf
				//Endif
			EndIf
		EndIf
		TEMP->(dbSkip())
	Enddo

Return
