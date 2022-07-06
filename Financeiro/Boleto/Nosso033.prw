#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "AP5MAIL.CH"


User Function Nosso033()

//EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA 

if cFilAnt == "01"  //  Santander - Matriz

    cPortador   := Padr("033",3)
    cAgencia    := Padr("3072",5)
    cConta      := Padr("01051781",10)
    cSbConta	:= Padr("001",3)
    cCarteira  :=  "101" 


ElseIf cFilAnt == '02'  // Santander - Filial

    cPortador   := Padr("033",3)
    cAgencia    := Padr("3078",5)
    cConta      := Padr("13002050",10)  //  conta completa para localizar no SEE ( para Codigo de barras é diferente)
    cSbConta	:= Padr("001",3)
    cCarteira  :=  "101" 

Endif
                                                                                                              
SEE->(DbSetOrder(1))
SEE->( dbSeek( xFilial("SEE")  +cPortador+cAgencia+cConta+cSbConta  ) )
//nRecSEE :=  SEE->( Recno())      //nRecSEE := 7  //    CARREGAR O RECNO DO BANCO NA TABELA SEE  ******

nNossoNum := Strzero( Val(SEE->EE_FAXATU)+1 ,8)

//Atualiza SEE

dbSelectArea("SEE")
RecLock("SEE",.F.)

    SEE->EE_FAXATU  :=  nNossoNum

MsUnlock()

//Atualiza Titulo
RecLock('SE1',.f.)
SE1->E1_NUMBCO := nNossoNum
MsUnlock('SE1')


Return(nNossoNum)
