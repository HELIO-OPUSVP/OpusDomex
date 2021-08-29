//LOCALIZAÇÃO   :  Function A250Atu - Função utilizada para atualizar das tabelas relacionadas a produção.
//EM QUE PONTO :  O ponto de entrada 'A250ATSD4' permite a atualização ou não da tabela de empenhos na atualização de 
//saldos do apontamento de produção simples. Ao pesquisar OP posivionada, verifica-se que a mesma é OP original de algum 
//empenho, em que é gravado o numero do lote e/ou quebra de empenho em 2 , gerando outro empenho com a diferença da quantidade.

User Function A250ATSD4
Local _aSaveArea := GetArea()
LocaL lRet       := .F.
RestArea(_aSaveArea)

Return lRet //-- Retorno permite atualizar o empenho ou nao