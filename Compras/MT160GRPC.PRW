#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
Autor: Jackson Santos
Finalidade: ajustar campos do pedido de compras na gera��o atrav�s do analisa cota��o

*/

User Function MT160GRPC
    Local aAreaAtu := GetArea()
    Local aAreaSc7 := SC7->(GetArea())

        If !EmptY(Alltrim(SC8->C8_XXOBSC))           
                //Trazer o campo Observa��o para o Pedido de compras conforme foi digitado na cota��o.
                SC7->C7_OBS := Substr(Alltrim(SC7->C7_OBS) + Alltrim(SC8->C8_XXOBSC),1,TamSx3("C7_OBS")[1])           
        EndIF
     RestArea(aAreaSc7)
    RestArea(aAreaAtu)
Return NIL

/*
User Function AVALCOPC()
    Local aAreaAtu := GetArea()
    Local aAreaSc7 := SC7->(GetArea())
        If !EmptY(Alltrim(SC8->C8_XXOBSC))
            Reclock("SC7",.f.)
                //Trazer o campo Observa��o para o Pedido de compras conforme foi digitado na cota��o.
                SC7->C7_OBS := Substr(Alltrim(SC7->C7_OBS) + Alltrim(SC8->C8_XXOBSC),1,TamSx3("C7_OBS")[1])

            SC7->(MsUnlock())
        EndIF
    RestArea(aAreaSc7)
    RestArea(aAreaAtu)
Return 
*/
