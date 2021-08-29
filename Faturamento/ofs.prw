#include "rwmake.ch"

user function OFS()

local filtro, totalnum
private mv_par01, mv_par02, mv_par03, mv_par04, mv_par05

totalnum := 0

dbselectarea("SC5")
dbsetorder(1)

pergunte("MTR101", .t.)

//if mv_par03 > 2
 // msgbox("Parâmetro de listagem não suportado", "Erro")
//else
  //filtro := 'C1_FILIAL == xFilial("SC1") .and. '
  //if mv_par03 == 2
     // filtro += 'C1_QUJE < C1_QUANT .and. '
  //endif
  
  filtro = 'C5_NUM >= MV_PAR01 .and. C5_NUM <= MV_PAR02 .and. C5_EMISSAO >= MV_PAR03 .and. C5_EMISSAO <= MV_PAR04'
  dbsetfilter({|| &filtro}, filtro)
  dbgotop()
  while !eof()
    totalnum++
    dbskip()
  enddo
  dbclearfil()
  
  msgbox("O total de OFs geradas são: " + alltrim(str(totalnum)) + " OFs.", "Soma de OFs", "INFO")
//endif

return