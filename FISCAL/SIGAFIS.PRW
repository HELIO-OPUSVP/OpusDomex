#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

USER FUNCTION SIGAFIS    

// ATUALIZA SFT com Aliquota Majorada do COFINS para nao apresentar erro no SPED COONTRIBUICOES
// Sempre que a Aliquoa foi 10.65  significa que tem 1% de Majoracao e o campo FT_ALIQCOF deve estar preenchido com 1

cQR1:= " UPDATE SFT010 SET FT_MALQCOF = 1 WHERE FT_ESTADO = 'EX' AND FT_ALIQCOF = 10.65 AND FT_MALQCOF = 0 AND D_E_L_E_T_ = ''  "
TCSQLEXEC(cQR1)


RETURN