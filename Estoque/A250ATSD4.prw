//LOCALIZA��O   :  Function A250Atu - Fun��o utilizada para atualizar das tabelas relacionadas a produ��o.
//EM QUE PONTO :  O ponto de entrada 'A250ATSD4' permite a atualiza��o ou n�o da tabela de empenhos na atualiza��o de 
//saldos do apontamento de produ��o simples. Ao pesquisar OP posivionada, verifica-se que a mesma � OP original de algum 
//empenho, em que � gravado o numero do lote e/ou quebra de empenho em 2 , gerando outro empenho com a diferen�a da quantidade.

User Function A250ATSD4
Local _aSaveArea := GetArea()
LocaL lRet       := .F.
RestArea(_aSaveArea)

Return lRet //-- Retorno permite atualizar o empenho ou nao