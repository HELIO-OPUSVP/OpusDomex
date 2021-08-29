//altera a ordem no recalculo do custo médio

*-------------------------------------------------------------------------------
User Function MA330TRB() //-- Manipulação customizada do arquivo de trabalho
*-------------------------------------------------------------------------------
/*
TRB->(DBGOTOP())

msgalert('Iniciar ordem 400')
DO WHILE .NOT. TRB->(EOF())
	//IF alltrim(TRB_COD)=='16451KITACE01'
	IF alltrim(TRB_COD)$('1648CKIT01|16451KITACE01|16411MOD003|16485A369300E0V|16486KITACE01F|164E3KIT01|164E6KIT01|164GS10KIT01|164GS30|164S4KITACE01|27712S10100101|31015RTKFLEX405|3110D1M00|3120D009125186|321010RG31650|350007220252560|350007502222016|500081115037002|500081432M3')
		IF ALLTRIM(TRB_CF)=='RE1' //--.AND. TRB->TRB_TES=='999'
			Reclock('TRB',.f.)
			TRB->TRB_ORDEM :='400'
			TRB->( msunlock() )
		ENDIF
	ENDIF
	TRB->(DBSKIP())
ENDDO
*/
Return Nil
