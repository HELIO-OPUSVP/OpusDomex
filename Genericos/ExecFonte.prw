#INCLUDE�"PROTHEUS.CH"

/*/{Protheus.doc}�ExecFonte
(Essa�fun��o�tende�a�executar�uma�fun��o�de�usuario�que��informada�por�parametro
A�partir�do�release�25�do�protheus�n�o��mais�poss�vel�executar�fun��es�de�usu�rio�pelo�
lan�amento�padronizado.�Sendo�assim,�criamos�essa�rotina�para�que�seja�colocada�no�menu�do�Protheus�12
e�por�meio�dela�o�desenvolver�possa�executar�suas�rotinas�sem�a�necessidade�de�ficar�colocando-as�nos�menus)
@type��User�Function
@author�Augusto
@since�04/06/2020
@version�version
@param�
@return�Return�Nil
@example
(examples)
@see�(links_or_references)
/*/

USER�FUNCTION�ExecFonte()

����LOCAL�cNomeFonte����:=�""  //variavel que ir� receber o nome do fonte digitado 
����LOCAL�aFonte��������:=�{}  //Array que ir� armazenar os dados da fun��o retornada pelo GetApoInfo()
����LOCAL�aPergs��������:=�{}  //Array que armazena as perguntas do ParamBox()

    //adiciona elementos no array de perguntas 
����aAdd(�aPergs�,�{1,�"Nome�do�fonte�",�space(10),�"",�"",�"",�"",�40,�.T.}�) 
�
    //If que valida o OK do parambox() e para o conteudo do parametro para a variavel
����if ParamBox(aPergs,�"DIGITAR�NOME�DO�ARQUIVO�.PRW"�)
��������cNomeFonte�:=�ALLTRIM(�MV_PAR01�)
    endif

    //Caso o usu�rio digite o U_ ou () no nome do fonte, retira esses caracteres
����cNomeFonte�:=�StrTran(�cNomeFonte�,�"U_"�,�""�)
����cNomeFonte�:=�StrTran(�cNomeFonte�,�"()"�,�""�)
   
   /*
    //Valida se retornou os dados do fonte do rpo
����IF�!LEN(�aFonte�)
��������MsgAlert(�DECODEUTF8(�"Fonte�n�o�encontrado�no�RPO"�)�,�"ops!"�)
��������RETURN�u_ExecFonte()
����ENDIF
*/
    //complementa a variavel e executa macro substitui��o chamando a rotina
����cNomeFonte�:=�"U_"+cNomefonte+"()"
����&cNomeFonte

RETURN�NIL
