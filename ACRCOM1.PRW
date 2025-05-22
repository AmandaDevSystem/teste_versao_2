#Include "Totvs.ch"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR550  ³ Autor ³ Marco Bianchi         ³ Data ³ 05/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Notas Fiscais                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT - R4                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// em 22/04 Criado query para somar as cotações (SC8) (Cotação/item), não será utilizado a regra da query original.
// em 23/04 C1_APROV = 'L' para C1_APROV <> 'R'

User Function ACRCOM1()
    Local oReport
    Private cAlias1   := GetNextAlias()

    //-- Interface de impressao
    oReport := FTReport()
    oReport:PrintDialog()
Return

Static Function FTReport()
    Local oReport

    local cNomPro   := "ACRCOM1"
    local cTitulo   := "Relatório de análise de reposição de estoque por depósito"
    local cPerg     := "ACRCOM1"

    Private oSection1

    oReport:=TReport():New(cNomPro,cTitulo,cPerg,{|oReport| FGerArq( oReport )},"")
    oReport:SetLandscape() 
    oReport:SetTotalInLine(.F.)

    Pergunte(cPerg,.F.)

    oSection1 := TRSection():New(oReport,"ANALISE",{cAlias1})

    TRCell():New(oSection1,OemToAnsi("Filial"                  ) ,,,                             ,TamSx3("ZC0_FILIAL")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 01
    TRCell():New(oSection1,OemToAnsi("Armazém"                 ) ,,,                             ,TamSx3("ZC0_LOCAL")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 02
    TRCell():New(oSection1,OemToAnsi("Produto"                 ) ,,,                             ,TamSx3("ZC0_PRODUT")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 03
    TRCell():New(oSection1,OemToAnsi("Descrição"               ) ,,,                             ,TamSx3("B1_DESC")[1]		,,,"LEFT",,"LEFT",,,,,,.T.) // 04
    TRCell():New(oSection1,OemToAnsi("Grupo"                   ) ,,,                             ,TamSx3("B1_GRUPO")[1]	    ,,,"LEFT",,"LEFT",,,,,,.T.) // 05 
    TRCell():New(oSection1,OemToAnsi("Estoque mínimo"          ) ,,,PesqPict("ZC0","ZC0_ESTMIN"	),TamSx3("ZC0_ESTMIN")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 06 (produtos x depósitos).
    TRCell():New(oSection1,OemToAnsi("Estoque máximo "         ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 07 (produtos x depósitos).
    TRCell():New(oSection1,OemToAnsi("Saldo"                   ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 08 do produto no depósito.
    TRCell():New(oSection1,OemToAnsi("Sol.Armz Não Baixadas"   ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 09 Solicitações ao armazém (não baixadas e do armazém selecionado).
    TRCell():New(oSection1,OemToAnsi("Sol.Compras"             ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 10 Solicitações de compras (SC aprovadas em aberto (sem cotação e sem pedido de compras) e do armazém selecionado)
    TRCell():New(oSection1,OemToAnsi("Cotações"                ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 11 Cotação em andamento (cotações sem pedido de compras e do armazém selecionado).
    TRCell():New(oSection1,OemToAnsi("PC c/Saldo"              ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 12 Pedido de compras (com saldo e não rejeitados e do armazém selecionado).
    TRCell():New(oSection1,OemToAnsi("PC Rejeitados"           ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 13 Pedido de compras rejeitados (com saldo, rejeitados e do armazém selecionado).
    TRCell():New(oSection1,OemToAnsi("PC Não aprovados"        ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 13 Pedido de compras não aprovados s (com saldo, rejeitados e do armazém selecionado).
    TRCell():New(oSection1,OemToAnsi("Saldo Depo. 95"          ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 14 (SB2).
    TRCell():New(oSection1,OemToAnsi("Saldo Depo. 95 Matriz"   ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 14 (SB2).
    TRCell():New(oSection1,OemToAnsi("Saldo Depo. 01 matriz"   ) ,,,PesqPict("ZC0","ZC0_ESTMAX"	),TamSx3("ZC0_ESTMAX")[1]	,,,"LEFT",,"LEFT",,,,,,.T.) // 14 (SB2).

Return(oReport)

Static Function FGerArq(oReport)
    local aArrayDad := {}

    // /*************************************************
    // * Fun?? para gerar SQL com base nos parametros **
    // **************************************************/
    aArrayDad := FGrvArq()
    // aadd(aArrayDad, {"0101","ZZZZ","ZZZZZZZZZZZZ","AAAAAAAAAAAAAAAAAAAAAAAAAAA","ZZZZ",0,0,0,0,0,0,0,0,0})


    // /*****************************************************************
    // * Fun?? para percorrer tabela temporaria e ralziar tratamentos **
    // ******************************************************************/
    FGerRel(aArrayDad, oReport)

Return(Nil)


Static Function FGrvArq()
    Local cQuery 	:= ''
    Local aArrayDad	:= {}
    Local nSaldoSC8 := 0 
    
    
    cQuery := "SELECT ZC0_FILIAL, ZC0_PRODUT, B1_DESC, B1_GRUPO, ZC0_LOCAL, ZC0_ESTMAX, ZC0_ESTMIN,  ISNULL(SB2A.B2_QATU,0 ) AS B2_QATU, " + CRLF
    cQuery += " ISNULL(SB2B.B2_QATU,0 ) AS B2_QATU95, " + CRLF
    cQuery += " (SELECT SUM(CQ_QTDISP) FROM "+RetSqlname("SCQ")+" SCQ WHERE SCQ.D_E_L_E_T_ <>'*' AND CQ_QTDISP > 0 AND CQ_FILIAL = ZC0_FILIAL AND CQ_PRODUTO = ZC0_PRODUT AND CQ_LOCAL = ZC0_LOCAL) AS SOLNBAIX," + CRLF
    cQuery += " (SELECT B2_QATU FROM SB2010 SB2 WHERE SB2.D_E_L_E_T_ <>'*' AND B2_FILIAL='0101'  AND B2_LOCAL = '95' AND B2_COD=ZC0_PRODUT) AS SLD010195, " + CRLF 
    cQuery += " (SELECT B2_QATU FROM SB2010 SB2 WHERE SB2.D_E_L_E_T_ <>'*' AND B2_FILIAL='0101'  AND B2_LOCAL = '01' AND B2_COD=ZC0_PRODUT) AS SLD010101, " + CRLF 
    cQuery += " (SELECT SUM(C1_QUANT - C1_QUJE) FROM "+RetSqlname("SC1")+" SC1 WHERE SC1.D_E_L_E_T_ <>'*' AND C1_COTACAO = '' AND C1_APROV <> 'R' AND C1_QUJE < C1_QUANT AND C1_FILIAL = ZC0_FILIAL AND C1_PRODUTO = ZC0_PRODUT AND C1_LOCAL = ZC0_LOCAL) AS SOLICOMP," + CRLF
    cQuery += " (SELECT SUM(C8_QUANT)/COUNT(*) FROM "+RetSqlname("SC8")+" SC8 WHERE SC8.D_E_L_E_T_ <>'*' AND C8_NUMPED = '' AND C8_ITEMPED ='' AND C8_FILIAL = ZC0_FILIAL AND C8_PRODUTO = ZC0_PRODUT ) AS QTDCOTAC," + CRLF
    cQuery += " (SELECT SUM(C7_QUANT - C7_QUJE)  FROM "+RetSqlname("SC7")+" SC7 WHERE SC7.D_E_L_E_T_ = '' AND C7_QUJE < C7_QUANT AND C7_CONAPRO = 'L' AND C7_RESIDUO = '' AND C7_FILIAL = ZC0_FILIAL AND C7_PRODUTO = ZC0_PRODUT AND C7_LOCAL = ZC0_LOCAL ) AS PEDCSALD," + CRLF
    cQuery += " (SELECT SUM(C7_QUANT - C7_QUJE)  FROM "+RetSqlname("SC7")+" SC7 WHERE SC7.D_E_L_E_T_ = '' AND C7_QUJE < C7_QUANT AND C7_CONAPRO = 'R' AND C7_RESIDUO = '' AND C7_FILIAL = ZC0_FILIAL AND C7_PRODUTO = ZC0_PRODUT AND C7_LOCAL = ZC0_LOCAL ) AS PEDCREJE, " + CRLF
    cQuery += " (SELECT SUM(C7_QUANT - C7_QUJE)  FROM "+RetSqlname("SC7")+" SC7 WHERE SC7.D_E_L_E_T_ = '' AND C7_QUJE < C7_QUANT AND C7_CONAPRO <> 'L' AND C7_CONAPRO <> 'R' " + CRLF
    cQuery += " AND C7_RESIDUO = '' AND C7_FILIAL = ZC0_FILIAL AND C7_PRODUTO = ZC0_PRODUT AND C7_LOCAL = ZC0_LOCAL ) AS PEDSSALD" + CRLF
    cQuery += " FROM "+RetSqlname("ZC0")+" ZC0 " + CRLF
    cQuery += " INNER JOIN "+RetSqlname("SB1")+" SB1 ON B1_COD = ZC0_PRODUT AND SB1.D_E_L_E_T_ = '' AND B1_FILIAL = '' " + CRLF
    cQuery += " LEFT JOIN "+RetSqlname("SB2")+" SB2A ON SB2A.B2_COD = ZC0_PRODUT AND SB2A.D_E_L_E_T_ = '' AND SB2A.B2_FILIAL = ZC0_FILIAL AND SB2A.B2_LOCAL = ZC0_LOCAL " + CRLF
    cQuery += " LEFT JOIN "+RetSqlname("SB2")+" SB2B ON SB2B.B2_COD = ZC0_PRODUT AND SB2B.D_E_L_E_T_ = '' AND SB2B.B2_FILIAL = ZC0_FILIAL AND SB2B.B2_LOCAL = '95' " + CRLF
    cQuery += " WHERE ZC0.D_E_L_E_T_ = '' " + CRLF
    cQuery += " AND ZC0_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CRLF
    cQuery += " AND ZC0_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CRLF
    cQuery += " AND ZC0_PRODUT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " + CRLF
    cQuery += " AND B1_GRUPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' " + CRLF
    cQuery += " ORDER BY ZC0_FILIAL, ZC0_LOCAL, B1_GRUPO, ZC0_PRODUT " + CRLF

    MemoWrite( "C:\TEMP\ACRCOM1-01.SQL", cQuery )

    dbUseArea(.T., "TOPCONN",TCGenQry(,,cQuery),cAlias1,.T., .T.)

    Do While (cAlias1)->(!EOF())
         nSaldoSC8 := 0 
         cQuery2 := " SELECT C8_NUM, C8_ITEM, C8_QUANT " + CRLF
         cQuery2 += " FROM "+RetSqlname("SC8")+" SC8 WHERE SC8.D_E_L_E_T_ <>'*' AND C8_NUMPED = '' AND C8_ITEMPED ='' " + CRLF
         cQuery2 += " AND C8_FILIAL = '"+(cAlias1)->ZC0_FILIAL+"' AND C8_PRODUTO = '"+(cAlias1)->ZC0_PRODUT+"' " + CRLF
         cQuery2 += " GROUP BY C8_NUM, C8_ITEM, C8_QUANT "  + CRLF
        // ALERT(cQuery2)

         dbUseArea(.T., "TOPCONN",TCGenQry(,,cQuery2),"QRY_SC8",.T., .T.)  
         QRY_SC8->(dbGoTop())
         Do While QRY_SC8->(!eof())
            nSaldoSC8 += QRY_SC8->C8_QUANT 
            QRY_SC8->(dbskip())
         Enddo 

         AADD(aArrayDad,{;
            (cAlias1)->ZC0_FILIAL		,;						//1
            (cAlias1)->ZC0_LOCAL		,;						//2
            (cAlias1)->ZC0_PRODUT		,;						//3
            (cAlias1)->B1_DESC			,;						//4
            (cAlias1)->B1_GRUPO		    ,;						//5
            (cAlias1)->ZC0_ESTMIN		,;						//6
            (cAlias1)->ZC0_ESTMAX	    ,;						//7
            (cAlias1)->B2_QATU          ,;						//8
            (cAlias1)->SOLNBAIX		    ,;						//9
            (cAlias1)->SOLICOMP		    ,;						//10
            nSaldoSC8		            ,;						//11
            (cAlias1)->PEDCSALD		    ,;						//12
            (cAlias1)->PEDCREJE		    ,;						//13
            (cAlias1)->PEDSSALD		    ,;						//14
            (cAlias1)->B2_QATU95        ,;						//15
            (cAlias1)->SLD010195	    ,;						//16
            (cAlias1)->SLD010101        })						//17
 
 // (cAlias1)->QTDCOTAC		    ,;						

        (cAlias1)->(dbskip())
        QRY_SC8->(Dbclosearea())
        
    EndDo

Return(aArrayDad)


Static Function FGerRel(aArrayDad, oReport)
    Local oSec1 := oReport:Section(1)
    local xI    := 0

    // oReport:PrintText(OemToAnsi("ANALISE CLIENTES X FATURAMENTO X LIMITE DE CREDITO"),,900)
    oReport:SkipLine()

    oSec1:Cell(01):SetBlock({|| aArrayDad[xI][01]})  //"Filial"                  
    oSec1:Cell(02):SetBlock({|| aArrayDad[xI][02]})  //"Armazém"                 
    oSec1:Cell(03):SetBlock({|| aArrayDad[xI][03]})  //"Produto"                 
    oSec1:Cell(04):SetBlock({|| aArrayDad[xI][04]})  //"Descrição"               
    oSec1:Cell(05):SetBlock({|| aArrayDad[xI][05]})  //"Grupo"                   
    oSec1:Cell(06):SetBlock({|| aArrayDad[xI][06]})  //"Estoque mínimo"          
    oSec1:Cell(07):SetBlock({|| aArrayDad[xI][07]})  //"Estoque máximo "         
    oSec1:Cell(08):SetBlock({|| aArrayDad[xI][08]})  //"Saldo"                   
    oSec1:Cell(09):SetBlock({|| aArrayDad[xI][09]})  //"Sol.Armz Não Baixadas"   
    oSec1:Cell(10):SetBlock({|| aArrayDad[xI][10]})  //"Sol.Compras"             
    oSec1:Cell(11):SetBlock({|| aArrayDad[xI][11]})  //"Cotações"                
    oSec1:Cell(12):SetBlock({|| aArrayDad[xI][12]})  //"PC c/Saldo"              
    oSec1:Cell(13):SetBlock({|| aArrayDad[xI][13]})  //"PC Rejeitados"
    oSec1:Cell(14):SetBlock({|| aArrayDad[xI][14]})  //"PC não aprovados e não Rejeitados"           
    oSec1:Cell(15):SetBlock({|| aArrayDad[xI][15]})  //"Saldo Depo. 95 - filial"          
    oSec1:Cell(16):SetBlock({|| aArrayDad[xI][16]})  //"Saldo Depo. 95 - matriz "          
    oSec1:Cell(17):SetBlock({|| aArrayDad[xI][17]})  //"Saldo Depo. 01 - matriz "          

    For xI := 1 To Len(aArrayDad)
        If oReport:Cancel()
            Exit
        EndIf
        oReport:StartPage()
        oReport:IncMeter()
        oSec1:Init()
        oSec1:PrintLine(,,.T.)
    Next xI
    oSec1:Finish()

Return(Nil)
