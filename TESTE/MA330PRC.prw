#INCLUDE "RWMAKE.CH"
/*Ponto-de-Entrada: MA330PRC - Desliga o processo de transfer�ncia de materiais no rec�lculo do custo m�dio
Ponto de entrada utilizado para desligar o processo de transferencia de materiais executado na rotina de 
recalculo do custo medio. 
Somente devera ser utilizado por clientes que n�o utilizam o processo de transferencia de materias do produto Protheus Estoque e Custos
 e desejam melhorar a performance da execu��o da rotina de recalculo do custo m�dio.
*/
*-----------------------------------
User Function MA330PRC()
*-----------------------------------
//Local lRet := .F.
//MSGALERT('MA330PRC')
Return Nil // lRet