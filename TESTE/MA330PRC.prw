#INCLUDE "RWMAKE.CH"
/*Ponto-de-Entrada: MA330PRC - Desliga o processo de transferência de materiais no recálculo do custo médio
Ponto de entrada utilizado para desligar o processo de transferencia de materiais executado na rotina de 
recalculo do custo medio. 
Somente devera ser utilizado por clientes que não utilizam o processo de transferencia de materias do produto Protheus Estoque e Custos
 e desejam melhorar a performance da execução da rotina de recalculo do custo médio.
*/
*-----------------------------------
User Function MA330PRC()
*-----------------------------------
//Local lRet := .F.
//MSGALERT('MA330PRC')
Return Nil // lRet