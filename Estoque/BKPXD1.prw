#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BKPXD1    ºAutor  ³Helio Ferreira      º Data ³  01/20/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de BAckup do XD1. Pega os registros antigos do    º±±
±±º          ³ XD1, grava no XD3 e apaga do XD1.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BKPXD1()
Private nMaxReg := 100000
Private nRegAtu := 1
Private lOk     := .T.

If Type("cUsuario") == "U"
	RPCSetType(3)
	aAbreTab := {}
	RpcSetEnv("01","01",,,,,aAbreTab)
EndIf

Processa({|lEnd| ProcRun() },"Processando registros antigos do XD1...")

Return

Static Function ProcRun()    

Local cFilter := ""

dbSelectArea("XD1")
dbSelectArea("XD3")



aCamposXD1 := {}

_cAlias := 'XD1'

_aCpoSX3 := FwSX3Util():GetAllFields(_cAlias)

//_cAcols    := "ZD3_COD/ZD3_DESCRI/ZD3_UM"

For i := 1 To Len(_aCpoSX3)

    If(X3Uso(GetSx3Cache(_aCpoSX3[i], 'X3_USADO'))) //.And. AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')) $ _cAcols)

       // nUsado++

        aAdd(aCamposXD1, AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')),;                     
                        GetSx3Cache(_aCpoSX3[i], 'X3_TAMANHO'),;
                        GetSx3Cache(_aCpoSX3[i], 'X3_DECIMAL'))                     
    Endif

Next i
       

/*                       


	SX3->( dbSetOrder(1) )
	SX3->( dbSeek("XD1") )
	
DO While ( !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "XD1" )
	aadd(aCamposXD1,{SX3->X3_CAMPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	SX3->( dbSkip() )
ENDDO
  */
  
  
//SX3->( dbSeek("XD3") )



aCamposXD3 := {}

_cAlias := 'XD3'

_aCpoSX3 := FwSX3Util():GetAllFields(_cAlias)

//_cAcols    := "ZD3_COD/ZD3_DESCRI/ZD3_UM"

For i := 1 To Len(_aCpoSX3)

    If(X3Uso(GetSx3Cache(_aCpoSX3[i], 'X3_USADO'))) //.And. AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')) $ _cAcols)

       // nUsado++

        aAdd(aCamposXD3, AllTrim(GetSx3Cache(_aCpoSX3[i], 'X3_CAMPO')),;                     
                       			  GetSx3Cache(_aCpoSX3[i], 'X3_TAMANHO'),;
                                GetSx3Cache(_aCpoSX3[i], 'X3_DECIMAL'))                     
    Endif

Next i
    

/*
DO While ( !SX3->(Eof()) .And. SX3->X3_ARQUIVO == "XD3" )
	aadd(aCamposXD3,{SX3->X3_CAMPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	SX3->( dbSkip() )
ENDDO

*/

For x := 1 to Len(aCamposXD1)
	nTemp := aScan(aCamposXD3,{ |aVet| Subs(aVet[1],4) == Subs(aCamposXD1[x,1],4) })
	
	If Empty(nTemp)
		MsgYesNo("Campo " + aCamposXD1[X,1] + " não encontrado no XD3")
		lOk := .F.
	Else
		If aCamposXD1[x,2] <> aCamposXD3[nTemp,2] .or. aCamposXD1[x,3] <> aCamposXD3[nTemp,3]
			MsgYesNo("Campos " + aCamposXD1[x,1] + " com tamanho diferente no XD1 e XD3")
			lOk := .F.
		EndIf
	EndIf
	
Next x

If lOk
	cQuery := "SELECT COUNT(*) AS CONTAGEM FROM XD1010 WHERE XD1_DTDIGI < '"+DtoS(Date()-400)+"' AND "
	cQuery += "(XD1_OCORRE = '5' OR (XD1_OCORRE = '6' AND XD1_LOCAL = '13') ) AND "
	cQuery += "XD1_XXPECA NOT IN (SELECT XD3_XXPECA FROM XD3010 WHERE D_E_L_E_T_ = '' ) AND "
	cQuery += "D_E_L_E_T_ = '' "
	
	TCQUERY cQuery NEW ALIAS "CONTAGEM"

   If MsgYesNo("Deseja processar o total "+Alltrim(Str(CONTAGEM->CONTAGEM))+" (YES) ou apenas "+Alltrim(Str(nMaxReg))+" registros (NO)")
      nMaxReg := CONTAGEM->CONTAGEM
   Else
      //nMaxReg := 1000
   EndIf
   
   ProcRegua(nMaxReg)
   
	cQuery := "SELECT TOP "+Alltrim(Str(nMaxReg))+" * FROM XD1010 WHERE XD1_DTDIGI < '"+DtoS(Date()-400)+"' AND "
	cQuery += "(XD1_OCORRE = '5' OR (XD1_OCORRE = '6' AND XD1_LOCAL = '13') ) AND "
	cQuery += "XD1_XXPECA NOT IN (SELECT XD3_XXPECA FROM XD3010 WHERE D_E_L_E_T_ = '' ) AND "
	cQuery += "D_E_L_E_T_ = '' "
	
	TCQUERY cQuery NEW ALIAS "QUERYXD1"
	
	TcSetField("QUERYXD1","XD1_DTDIGI","D", 8, 0)
	TcSetField("QUERYXD1","XD1_ZYDTNF","D", 8, 0)
	
	XD3->( dbSetOrder(1) )
	SX3->( dbSetOrder(1) )
	
	While !QUERYXD1->( EOF() )
		If !XD3->( dbSeek( QUERYXD1->XD1_FILIAL + QUERYXD1->XD1_XXPECA ) )
			SX3->( dbSeek("XD1") )
			Reclock("XD3",.T.)
			While !SX3->( EOF() ) .and. SX3->X3_ARQUIVO == 'XD1'
				&("XD3->XD3_"+Subs(SX3->X3_CAMPO,5)) := &("QUERYXD1->XD1_"+Subs(SX3->X3_CAMPO,5))
				SX3->( dbSkip() )
			End
			XD3->( msUnlock() )
			
			If XD1->( dbSeek(XD3->XD3_FILIAL + XD3->XD3_XXPECA) )
				Reclock("XD1",.F.)
				XD1->( dbDelete() )
				XD1->( msUnlock() )
			EndIf
		Else
			// compara os campos e deleta o XD1
		End
		QUERYXD1->( dbSkip() )
		//IncRegua(Alltrim(Str(nRegAtu))+"/1000")
		IncProc(Alltrim(Str(nRegAtu))+"/"+Alltrim(Str(nMaxReg)))
		nRegAtu++
	End
	
EndIf

MsgInfo("Processamento concluído...")





Return
