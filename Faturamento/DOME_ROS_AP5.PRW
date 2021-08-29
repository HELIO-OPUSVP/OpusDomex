#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01
#include "fileio.ch"        // incluido por Fabrício (05/04/04)

User Function DOME_ROS()        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 

ALERT("Rotina DOME_ROS  desabilitada em 24/7/2019.   Avise o TI.")    
Return

SetPrvt("NUMORC,OBSERV,NCTP,CSITUACAO,")

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³rdmake    ³ Dom_lib  ³ Autor ³ Marcia Natale         ³ Data ³ 17.11.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ³±±
±±³Descri‡…o ³ Rotina de Liberacao de Itens de Orcamentos                 ³±±
±±³          ³                                                            ³±±        ³±±
±±³          ³                                                            ³±±        ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo  De Itens de Orcamento                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
NumOrc := Space(6)
Observ := Space(6)
nCtp   := Space(3)

@ 206,182 To 422,618 Dialog oDlg Title OemToAnsi("Baixa de Orcamento ")
@ 10,16 Say "Orcamento"
@ 10,46 Get NumOrc Picture "@!" Valid .T. F3 "SCJ"
@ 35,16 Say "Observ.  "
@ 35,46 Get Observ Picture "@!" Valid .T. F3 "MO"
@ 60,16 Say "Dpt      "
@ 60,46 Get nCtp Picture "@!" Valid .T. F3 "OP"

@ 6,154  BmpButton Type 1 Action Libera()// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> @ 6,154  BmpButton Type 1 Action Execute(Libera)
@ 35,155 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg Centered
Return

// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> Function Libera
Static Function Libera()
dbSelectArea("SCK")
dbSetOrder(1)
DBSETFILTER({|| CK_NUM == NumOrc},"CK_NUM == NumOrc ")

dbSelectArea("SCJ")            //Orcamento cabecalho
dbSetOrder(1)
dbSeek(xFilial("SCJ")+NumOrc)
cSituacao := CJ_SITUACA
if !empty(Observ) .or. Observ <> space(6)
   dbSelectArea("SCK")
   dbSeek(xFilial("SCK")+NumOrc)
   if !found()
      msgbox("Orcamanento Inexistente")
   endif
   While !EOF() .AND. SCK->CK_NUM == NumOrc
      IF SCJ->CJ_STATUS == "A"
         If empty(SCK->CK_NUMPV) 
           If Reclock("SCK",.F.)
              SCK->CK_NUMPV := "MORTO"
              SCK->CK_OBS := Observ
              SCK->CK_DPT := nCtp
              cSituacao := "MT"
              dbCommit()
              Msunlock()
           Else
              MSGALERT("Registro nao pode ser Travado")
              Loop
           Endif
         Endif
      ELSE

         cSituacao := "MP"
         msgbox("Orcamento j  baixado")
      ENDIF
      dBskip()
   Enddo
   IF !empty(Observ) .or. Observ <> space(6)
      dbSelectArea("SCJ")            //Orcamento cabecalho
      dbSetOrder(1)
      dbSeek(xFilial("SCJ")+NumOrc)
      if !found()
         msgbox("Nao existe !")
      endif
      If Reclock("SCJ",.F.)
         SCJ->CJ_STATUS :="B"
         SCJ->CJ_SITUACA := cSituacao
         Msunlock()
         dbCommit()
      Else
         MSGALERT("Registro nao pode ser Travado")
      Endif
   ENDIF
ENDIF
if empty(Observ)
   dbSelectArea("SCK")
   dbSeek(xFilial("SCK")+NumOrc)
   While !EOF() .AND. SCK->CK_NUM == NumOrc

      If Reclock("SCK",.F.)
         SCK->CK_DPT := nCtp
         dbCommit()
         Msunlock()
      Else
         MSGALERT("Registro nao pode ser Travado")
      Endif
      dBskip()
   Enddo
Endif

Close(oDlg)
Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                         F  I   M                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DBCLEARFILTER()
// Substituido pelo assistente de conversao do AP5 IDE em 20/07/01 ==> __Return(0)
Return(0)        // incluido pelo assistente de conversao do AP5 IDE em 20/07/01


