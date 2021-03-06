#include "topconn.ch"
#include "totvs.ch"

/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?QryMauri  ?Autor  ?Helio Ferreira      ? Data ?  31/07/17   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ? Programa criado a partir das querys do Mauricio para       ???
???          ? otimiza??o do banco de dados SQL                           ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
*/

User Function QryMauri()

If !MsgYesNo("Deseja realmente rodar os Scripts de otimiza??o do banco de dados?")
   Return
EndIf

If Type("cUsuario") == "U"
	RPCSetType(3)
	aAbreTab := {}
	RpcSetEnv("01","01",,,,,aAbreTab)
EndIf

cQuery := ""
//cQuery += "/*Perform a 'USE <database name>' to select the database in which to run the script.*/             "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "--Declare variables                                                                                  "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
cQuery += "USE DADOS_P11                                                                                      "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
cQuery += "SET NOCOUNT ON;                                                                                    "+Chr(13)
cQuery += "DECLARE @tablename varchar(255);                                                                   "+Chr(13)
cQuery += "DECLARE @execstr   varchar(400);                                                                   "+Chr(13)
cQuery += "DECLARE @objectid  int;                                                                            "+Chr(13)
cQuery += "DECLARE @indexid   int;                                                                            "+Chr(13)
cQuery += "DECLARE @frag      decimal;                                                                        "+Chr(13)
cQuery += "DECLARE @maxfrag   decimal;                                                                        "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Decide on the maximum fragmentation to allow for.                                               "+Chr(13)
cQuery += "SELECT @maxfrag = 90.0;                                                                             "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Declare a cursor.                                                                               "+Chr(13)
cQuery += "DECLARE tables CURSOR FOR                                                                          "+Chr(13)
cQuery += "   SELECT TABLE_SCHEMA + '.' + TABLE_NAME                                                          "+Chr(13)
cQuery += "   FROM INFORMATION_SCHEMA.TABLES                                                                  "+Chr(13)
cQuery += "   WHERE TABLE_TYPE = 'BASE TABLE';                                                                "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Create the table.                                                                               "+Chr(13)
cQuery += "CREATE TABLE #fraglist (                                                                           "+Chr(13)
cQuery += "   ObjectName char(255),                                                                           "+Chr(13)
cQuery += "   ObjectId int,                                                                                   "+Chr(13)
cQuery += "   IndexName char(255),                                                                            "+Chr(13)
cQuery += "   IndexId int,                                                                                    "+Chr(13)
cQuery += "   Lvl int,                                                                                        "+Chr(13)
cQuery += "   CountPages int,                                                                                 "+Chr(13)
cQuery += "   CountRows int,                                                                                  "+Chr(13)
cQuery += "   MinRecSize int,                                                                                 "+Chr(13)
cQuery += "   MaxRecSize int,                                                                                 "+Chr(13)
cQuery += "   AvgRecSize int,                                                                                 "+Chr(13)
cQuery += "   ForRecCount int,                                                                                "+Chr(13)
cQuery += "   Extents int,                                                                                    "+Chr(13)
cQuery += "   ExtentSwitches int,                                                                             "+Chr(13)
cQuery += "   AvgFreeBytes int,                                                                               "+Chr(13)
cQuery += "   AvgPageDensity int,                                                                             "+Chr(13)
cQuery += "   ScanDensity decimal,                                                                            "+Chr(13)
cQuery += "   BestCount int,                                                                                  "+Chr(13)
cQuery += "   ActualCount int,                                                                                "+Chr(13)
cQuery += "   LogicalFrag decimal,                                                                            "+Chr(13)
cQuery += "   ExtentFrag decimal);                                                                            "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Open the cursor.                                                                                "+Chr(13)
cQuery += "OPEN tables;                                                                                       "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Loop through all the tables in the database.                                                    "+Chr(13)
cQuery += "FETCH NEXT                                                                                         "+Chr(13)
cQuery += "   FROM tables                                                                                     "+Chr(13)
cQuery += "   INTO @tablename;                                                                                "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
cQuery += "WHILE @@FETCH_STATUS = 0                                                                           "+Chr(13)
cQuery += "BEGIN                                                                                              "+Chr(13)
//cQuery += "-- Do the showcontig of all indexes of the table                                                   "+Chr(13)
cQuery += "   INSERT INTO #fraglist                                                                           "+Chr(13)
cQuery += "   EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''')                                                 "+Chr(13)
cQuery += "      WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS');                                         "+Chr(13)
cQuery += "   FETCH NEXT                                                                                      "+Chr(13)
cQuery += "      FROM tables                                                                                  "+Chr(13)
cQuery += "      INTO @tablename;                                                                             "+Chr(13)
cQuery += "END;                                                                                               "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Close and deallocate the cursor.                                                                "+Chr(13)
cQuery += "CLOSE tables;                                                                                      "+Chr(13)
cQuery += "DEALLOCATE tables;                                                                                 "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Declare the cursor for the list of indexes to be defragged.                                     "+Chr(13)
cQuery += "DECLARE indexes CURSOR FOR                                                                         "+Chr(13)
cQuery += "   SELECT ObjectName, ObjectId, IndexId, LogicalFrag                                               "+Chr(13)
cQuery += "   FROM #fraglist                                                                                  "+Chr(13)
cQuery += "   WHERE LogicalFrag >= @maxfrag                                                                   "+Chr(13)
cQuery += "      AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0;                                   "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Open the cursor.                                                                                "+Chr(13)
cQuery += "OPEN indexes;                                                                                      "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Loop through the indexes.                                                                       "+Chr(13)
cQuery += "FETCH NEXT                                                                                         "+Chr(13)
cQuery += "   FROM indexes                                                                                    "+Chr(13)
cQuery += "   INTO @tablename, @objectid, @indexid, @frag;                                                    "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
cQuery += "WHILE @@FETCH_STATUS = 0                                                                           "+Chr(13)
cQuery += "BEGIN                                                                                              "+Chr(13)
cQuery += "   PRINT 'Executing DBCC INDEXDEFRAG (0, ' + RTRIM(@tablename) + ',                                "+Chr(13)
cQuery += "      ' + RTRIM(@indexid) + ') - fragmentation currently '                                         "+Chr(13)
cQuery += "       + RTRIM(CONVERT(varchar(15),@frag)) + '%';                                                  "+Chr(13)
cQuery += "   SELECT @execstr = 'DBCC INDEXDEFRAG (0, ' + RTRIM(@objectid) + ',                               "+Chr(13)
cQuery += "       ' + RTRIM(@indexid) + ')';                                                                  "+Chr(13)
cQuery += "   EXEC (@execstr);                                                                                "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
cQuery += "   FETCH NEXT                                                                                      "+Chr(13)
cQuery += "      FROM indexes                                                                                 "+Chr(13)
cQuery += "      INTO @tablename, @objectid, @indexid, @frag;                                                 "+Chr(13)
cQuery += "END;                                                                                               "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Close and deallocate the cursor.                                                                "+Chr(13)
cQuery += "CLOSE indexes;                                                                                     "+Chr(13)
cQuery += "DEALLOCATE indexes;                                                                                "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "-- Delete the temporary table.                                                                     "+Chr(13)
cQuery += "DROP TABLE #fraglist;                                                                              "+Chr(13)
cQuery += "GO                                                                                                 "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "--dbcc memorystatus                                                                                "+Chr(13)
//cQuery += "--select * FROM #fraglist;                                                                         "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)
//cQuery += "----EXEC sp_updatestats                                                                            "+Chr(13)
//cQuery += "                                                                                                   "+Chr(13)

MsgRun("Executando query 1/3","Refaz indices - INDEXDEFRAG.qry",{|| TCSQLEXEC(cQuery) })

Return
