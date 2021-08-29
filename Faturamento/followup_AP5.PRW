#include "rwmake.ch"
#include "print.ch"
#include "font.ch"
#include "colors.ch"


user function followup()

setprvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,WNREL,ARETURN,NLASTKEY,CPERG,NLIN,ARQTRAB,I")
setprvt("EJECT,FCABEC,FPRINCIPAL,CABEC1,CABEC2,AORDEM,NTOTAL,INDCAMPOS")

titulo   := "Impressao de Follow-up"
cDesc1   := "Este programa ira emitir o relatorio de follow-up"
cDesc2   := "pela data de proximo contato"
cDesc3   := " "
cString  := "SCJ"
wnrel    := "FOLLOWUP"     
nTotal   := 0   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aReturn:= { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey:= 0
cPerg := "FOLWUP"
aOrdem := { "Cliente", "Data" }
indcampos := { "CJ_CLIENTE", "CJ_DTCONT" }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Da Data                                      ³
//³ mv_par02     // Ate Data                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia Controle Para a Funcao SETPRINT                            ³
//³   nome arq. = arq.principal / nome relat / perg. / 4 x descr.rel.³
//³   dicionario / ordem / compressao relatorio / tamanho            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               // Tamanho Papel - P-080,M-132,G-220

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,.T.,"M")

nLastKey:=IIf(LastKey()==27,27,nLastKey)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

nLastKey:=IIf(LastKey()==27,27,nLastKey)

If nLastKey == 27
	Return
Endif

RptStatus({|| fPrincipal()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim de impressao                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
  Set Device to Screen
  Set Printer To
  dbCommitAll()
  OurSpool(wnrel)
Endif

MS_FLUSH()

// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

static function fPrincipal()

dbselectarea("SCJ")   
	

// Cria indice pela Data do Proximo Follow-up

arqtrab := criatrab(nil,.f.)
indregua("SCJ",arqtrab,indcampos[aReturn[8]],,"CJ_DTCONT >= mv_par01 .and. CJ_DTCONT <= mv_par02 .and. CJ_CLIENTE >= mv_par03 .and. CJ_CLIENTE <= mv_par04 .and. CJ_NUM >= mv_par05 .and. CJ_NUM <= mv_par06","Criando indice ...")

// Configura a impressora

//fInic()

// Imprime os comentarios

//fCabec()
Tamanho := "M"
m_pag := 1
if aReturn[5] == 2
  CABEC1 := "Relação de CN's com data de Novo Contato de "+dtoc(mv_par01)+" até "+dtoc(mv_par02)
  CABEC2 := "Número da CN"+space(10)+"Próx. Follow-up"+space(10)+"Comentário"
  titulo := "Impressão de Follow-up"
else
  CABEC1 := "Relacao de CN's com data de Novo Contato de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
  CABEC2 := "Numero da CN"+space(5)+"Prox. Follow-up"+space(5)+"Cliente"+space(5)+"Comentario"
endif

nlin := cabec(titulo,cabec1,cabec2,wnrel,Tamanho) + 1    

while !eof()
  if ( iif(mv_par07 == 1, CJ_STATUS = "A" , .t.) .and. ;
       iif(mv_par07 == 3, CJ_STATUS = "B" , .t.) .and. ;
       iif(mv_par07 == 4, CJ_SITUACAO$"MT|MP", .t.) )       
       
	  
       

//while !eof()
 // if ( iif(mv_par07 == 1, empty(CJ_SITUACAO), .t.) .and. ;
   //    iif(mv_par07 == 3, CJ_SITUACAO$"BT|BP", .t.) .and. ;
     //  iif(mv_par07 == 4, CJ_SITUACAO$"MT|MP", .t.) )
     
     
		 
		
		
    	dbSelectArea("SA1")
		dbSetOrder(1)
		dbseek(xfilial()+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)

	    dbSelectArea("SCJ")
	//	dbSetOrder(1)
   //	dbseek(xfilial()+SCK->CK_CLIENTE+SCK->CK_LOJA)

  
    @nlin, 0  psay SCJ->CJ_NUM
    @nlin, 19 psay SCJ->CJ_DTCONT
    @nlin, 30 psay SA1->A1_NREDUZ
   // @nlin, 45 psay  nTotal Picture "@R 99,999,999.99"            
                      
    for i := 1 to mlcount(SCJ->CJ_DESC)
      if nlin > 56
//        eject()
//        fCabec()
        nlin := cabec(titulo,cabec1,cabec2,wnrel,Tamanho) + 1
      endif
      @nlin, 53 psay memoline(SCJ->CJ_DESC,, i)
      nlin := nlin+1
    next
    if mlcount(SCJ->CJ_DESC) == 0
      nlin := nlin + 1
    endif
    @nlin, 0 psay CHR(27)+CHR(5)+CHR(1)+replicate("-",132)+CHR(27)+CHR(5)+CHR(2)
    nlin := nlin+1
  endif
  dbskip()
enddo

//eject()

RetIndex("SCJ")
ferase(arqtrab + OrdBagExt())

return

static function fCabec()

@nlin, 0 psay "Relacao de CN's com data de Novo Contato de "+dtoc(mv_par01)+" ate "+dtoc(mv_par02)
nlin := nlin+1
@nlin, 0 psay replicate("-",132)
nlin := nlin+1
@nlin, 0 psay "Numero da CN"+space(10)+"Prox. Follow-up"+space(10)+"Comentario"
nlin := nlin+1
@nlin, 0 psay replicate("-",132)
nlin := nlin+2

return

static function eject()

@nlin, 0 psay chr(12)
//nlin := 0

return

static function fInic()

@ nLin,01 PSAY CHR(27)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca na varial public __DRIVER o tipo de impressora escolhida ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTamImp  := "(s15H"
If SubStr( __DRIVER, 1, 4) == "HPLJ"
  _cTipImp := "L"
  cTamImp  := "(s0p17.50h0T"
  @ nLin,01 PSAY cTamImp
ElseIf SubStr( __DRIVER, 1, 2) == "HP"
  _cTipImp := "J"       
  cTamImp  := "(s15H"
  @ nLin,01 PSAY "(s15H"
ElseIf SubStr( __DRIVER, 1, 4) == "EPSO"
  _cTipImp := "M"
Else
  _cTipImp := "J"   
EndIf

return