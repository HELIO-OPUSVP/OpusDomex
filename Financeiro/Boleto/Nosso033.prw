#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "AP5MAIL.CH"


User Function Nosso033()

//EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA 

if cFilAnt == "01"  //  Santander - Matriz
    _cxBco  := "033"
    _cxAge  := "3072 "
    _cxConta:= "01051781  "
    _cxSub  := "001"

ElseIf cFilAnt == '02'  // Santander - Filial
    _cxBco  := "033"
    _cxAge  := "3078 "
    _cxConta:= "13002050  "
    _cxSub  := "001"
Endif
                                                                                                              
SEE->(DbSetOrder(1))
SEE->( dbSeek( xFilial("SEE") + _cxBco + _cxAge + _cxConta+_cxSub  ) )
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
