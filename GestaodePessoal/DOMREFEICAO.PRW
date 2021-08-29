//------------------------------------------------------------------------------------//
//Empresa...:  OPUS - HIGIEX
//------------------------------------------------------------------------------------//
//Empresa...:
//Funcao....: ANALISTA DE SISTEMAS
//Autor.....: MAURICIO LIMA DE SOUZA
//Data......:
//Uso.......:
//Versao....: 
//419	REFEICAO
//826	REFEICAO EMPRESA
//------------------------------------------------------------------------------------//

#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

#INCLUDE "MSOBJECT.CH"

*----------------------------------------------------------------------------------------
USER FUNCTION DOMREFEICAO() // CALCULO DESCONTO VALE REFEICAO
*----------------------------------------------------------------------------------------
Local oFont1 	:= TFont():New("Arial Narrow",,022,,.F.,,,,,.F.,.F.)

Local _cPAR01 :=SPACE(LEN(SRA->RA_MAT))
Local _cPAR02 :=SPACE(LEN(SRA->RA_MAT))
Local _cPAR03 :=0
Local _cPAR04 :=DATE()

Local lLOOP     := .T.
Local lImport   := .F.

Local oGet1
Local oGet2
Local oGet3
Local oGet4

Local oSButton1
Local oSButton2
Local vSAL:='101' // SALÁRIO
Local vPDF:='420' //	DESC VALE TRANSPORTE
Local vPDE:='819' //	VL TRANSP - EMPRESA 
Local _nValorSal :=0
Local _nHorasSal :=0

Static oDlgTRA

PRIVATE ccadastro :='Calculo Vale Refeição Domex'

DO WHILE lLOOP
	_cPAR01 :=SPACE(LEN(SF1->F1_DOC))
	_cPAR02 :=SPACE(LEN(SF1->F1_DOC))
	_cPAR03 :=0
	_cPAR04 :=DATE()
	
	DEFINE MSDIALOG oDlgTRA TITLE ccadastro FROM 000, 000  TO 280, 300 COLORS 0, 16777215 PIXEL
	
	@ 011, 010 SAY oSay1 PROMPT "Vale Refeição" 	 SIZE 136, 014 OF oDlgTRA FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 037, 010 SAY oSay2 PROMPT "Matricula de    :"   	 SIZE 045, 007 OF oDlgTRA COLORS 0, 16777215 PIXEL
	@ 050, 010 SAY oSay3 PROMPT "Matricula até   :"     SIZE 045, 007 OF oDlgTRA COLORS 0, 16777215 PIXEL
	@ 063, 010 SAY oSay3 PROMPT "Valor por Func. :"     SIZE 045, 007 OF oDlgTRA COLORS 0, 16777215 PIXEL
	@ 076, 010 SAY oSay3 PROMPT "Data Pagamento  :"     SIZE 045, 007 OF oDlgTRA COLORS 0, 16777215 PIXEL
//	@ 089, 010 SAY oSay3 PROMPT "" 		    SIZE 045, 007 OF oDlgTRA COLORS 0, 16777215 PIXEL
	
	@ 037, 060 MSGET oGet1 VAR _cPAR01 WHEN(.T.) F3 "SRA"   SIZE 050, 010 OF oDlgTRA COLORS 0, 16777215 PIXEL
	@ 050, 060 MSGET oGet2 VAR _cPAR02 WHEN(.T.) F3 "SRA"   SIZE 050, 010 OF oDlgTRA COLORS 0, 16777215 PIXEL
	@ 063, 060 MSGET oGet3 VAR _cPAR03 WHEN(.T.) PICTURE PesqPict("SRC","RC_VALOR",16,2) SIZE 050, 010 OF oDlgTRA COLORS 0, 16777215 PIXEL
	@ 076, 060 MSGET oGet4 VAR _cPAR04 WHEN(.T.)            SIZE 050, 010 OF oDlgTRA COLORS 0, 16777215 PIXEL
//	@ 089, 050 MSGET oGet5 VAR _cPAR05 WHEN(.T.) SIZE 150, 010 OF oDlgTRA COLORS 0, 16777215 PIXEL
	
	DEFINE SBUTTON oSButton1 FROM 110, 041 TYPE 01 OF oDlgTRA ENABLE Action (lImport :=.T., oDlgTRA:End() )
	DEFINE SBUTTON oSButton2 FROM 110, 077 TYPE 02 OF oDlgTRA ENABLE Action (lLOOP   :=.F., oDlgTRA:End() )//oDlgTRA:End()
	
	ACTIVATE MSDIALOG oDlgTRA CENTERED
	
	IF lImport ==.T. .AND. _cPAR03 >0
		lImport :=.F.

		SRC->(DBSELECTAREA('SRC'))
		SRC->(DBSETORDER(1))

		SRA->(DBSELECTAREA('SRA'))
		SRA->(DBSETORDER(1))
		SRA->(DBGOTOP())

      DO WHILE !SRA->(EOF())
         nDESC:=0
         IF! SRA->RA_SITFOLH $'D/A' .AND. SRA->RA_MAT>=_cPAR01 .AND. SRA->RA_MAT<=_cPAR02 
            //--------------------------------------------------------------------------
             If SRC->(DBSEEK(xFilial('SRC')+SRA->RA_MAT+vSAL)) 
                _nValorSal := SRC->RC_VALOR
                _nHorasSal := SRC->RC_HORAS
             EndIf
            
            SRC->(DBSEEK(xFilial('SRC')+SRA->RA_MAT+vPDF))
            IF SRC->(FOUND())
               RECLOCK("SRC",.F.)
               ELSE
               RECLOCK("SRC",.T.)
            ENDIF
            
            IF SRA->RA_SALARIO < 2500
               nDESC :=5
               ELSE
                 nDESC :=(SRA->RA_SALARIO*0.005)
            ENDIF
                 
            SRC->RC_FILIAL :=xFILIAL('SRC')
            SRC->RC_MAT    :=SRA->RA_MAT
            SRC->RC_PD     :=vPDF
            SRC->RC_TIPO1  :='V'
            SRC->RC_HORAS  :=20
            SRC->RC_VALOR  :=nDESC
            SRC->RC_DATA   :=_cPAR04
            SRC->RC_CC     :=SRA->RA_CC
            SRC->RC_TIPO2  :='I'                                                                        
	         SRC->(msUnlock())
	         
            //--------------------------------------------------------------------------	         
            SRC->(DBSEEK(xFilial('SRC')+SRA->RA_MAT+vPDE))
            IF SRC->(FOUND())
               RECLOCK("SRC",.F.)
               ELSE
               RECLOCK("SRC",.T.)
            ENDIF
            
            SRC->RC_FILIAL :=xFILIAL('SRC')
            SRC->RC_MAT    :=SRA->RA_MAT
            SRC->RC_PD     :=vPDE
            SRC->RC_TIPO1  :='V'
            SRC->RC_HORAS  :=20
            SRC->RC_VALOR  :=_cPAR03-nDESC
            SRC->RC_DATA   :=_cPAR04
            SRC->RC_CC     :=SRA->RA_CC
            SRC->RC_TIPO2  :='I'                                                                        
	         SRC->(msUnlock())
            //--------------------------------------------------------------------------	         
		   ENDIF
		   SRA->(DBSKIP())
		ENDDO 
		MSGALERT('Fim processamento') 
	ENDIF	
	
ENDDO

