#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "AP5MAIL.CH"


User Function NossoRDT()

//EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA 

cPortador   := Padr("341",3)
cAgencia    := Padr("1529",5)
cConta      := Padr("01594-1",10)
cSbConta	:= "001"
cCarteira  :=  "109" //"112"

dbSelectArea("SEE")
DbSetOrder(1)
DbSeek(xFilial("SEE")+cPortador+cAgencia+cConta+cSbConta)

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
