//+------------------------------------------------------------------+
//|                                              FxStarEu_Master.mq4 |
//|                                          https://forex.fxstar.eu |
//+------------------------------------------------------------------+
#property copyright "Marcin Łukaszewski"
#property link      "https://forex.fxstar.eu"
#property version   "1.00"
#property strict

//--- include library https://www.mql5.com/en/articles/932
#include <MQLMySQL.mqh>

//--- position refresh timer
extern int timer = 3; 

string INI;
int newbar = 0;
string Host, User, Password, Database, Socket, Query; // database credentials
int Port,ClientFlag;
int DB; // database identifier
 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   //create timer
   EventSetTimer(timer);
   //Print (MySqlVersion());
   Host = "localhost";
   User = "fx";
   Password = "pass";
   Database = "fxstareu";
   Port     = 3306;
   Socket   = "0";
   ClientFlag = CLIENT_MULTI_STATEMENTS;
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
{
   if(newbar != Time[0]){          
   newbar = (int)Time[0];
   Print(TimeToStr(Time[0], TIME_DATE|TIME_SECONDS) + " Account equity " + DoubleToString(NormalizeDouble(AccountEquity(),2),2));
   Balance(); 
   }   
}

void Balance()
{
 Print ("Host: ",Host, ", User: ", User, ", Database: ",Database, " Connecting...");  
 DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag); 
 if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
 Query = "INSERT INTO account (time, accountid, balance, equity, margin, freemargin, currency, leverage) VALUES('" + TimeToStr(Time[0], TIME_DATE|TIME_SECONDS) + "','" + AccountNumber() + "', '" + AccountBalance() + "', '" + AccountEquity() + "', '" + AccountMargin() + "', '" + AccountFreeMargin() + "', '" + AccountCurrency() + "', '" + AccountLeverage() + "')";
 if (MySqlExecute(DB, Query))
     {
      Print ("Succeeded: ", Query);
     }
 else
     {
      Print ("Error: ", MySqlErrorDescription);
      Print ("Query: ", Query);
     }
     
 MySqlDisconnect(DB);
 Print ("Mysql Disconnected. Done!");
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
 
   Print ("Host: ",Host, ", User: ", User, ", Database: ",Database, " Connecting...");
   DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);   
   if (DB == -1) { Alert ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
    
   int orders=OrdersTotal();
   for(int i=0;i<orders;i++)
     {
     if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
     Print("Orders error ",GetLastError());
     break;
     }
     
     // SELL ORDERS
         if(OrderType() == OP_SELL){   
         
         Print(OrderOpenPrice());
          Query = "INSERT INTO OpenSignal (id, symbol, volume, type, opent, openp, account, sl, tp) VALUES('" + OrderTicket() + "','" + OrderSymbol() + "', '" + OrderLots() + "','SELL','" + OrderOpenTime() + "','" + OrderOpenPrice() + "','" + AccountNumber() + "','" + OrderStopLoss() + "','" + OrderTakeProfit() + "') ON DUPLICATE KEY UPDATE sl='" + OrderStopLoss() + "', tp='" + OrderTakeProfit() + "'";
          if (MySqlExecute(DB, Query))
              {
               Print ("Succeeded: ", Query);
              }
          else
              {
               Print ("Error: ", MySqlErrorDescription);
               Print ("Query: ", Query);
              }
         }
      // BUY ORDERS
         if(OrderType() == OP_BUY){   
          
          Print(OrderOpenPrice());
          Query = "INSERT INTO OpenSignal (id, symbol, volume, type, opent, openp, account, sl, tp) VALUES('" + OrderTicket() + "','" + OrderSymbol() + "', '" + OrderLots() + "','BUY','" + OrderOpenTime() + "','" + OrderOpenPrice() + "','" + AccountNumber() + "','" + OrderStopLoss() + "','" + OrderTakeProfit() + "') ON DUPLICATE KEY UPDATE sl='" + OrderStopLoss() + "', tp='" + OrderTakeProfit() + "'";
          if (MySqlExecute(DB, Query))
              {
               Print ("Succeeded: ", Query);
              }
          else
              {
               Print ("Error: ", MySqlErrorDescription);
               Print ("Query: ", Query);
              }
         }            
         
     }

   int ii, hTotal;
   hTotal= OrdersHistoryTotal();
   for(ii=0;ii<hTotal;ii++)
     {
      if(OrderSelect(ii,SELECT_BY_POS,MODE_HISTORY)==false)
        {
         Print("History Error ",GetLastError());
         break;
        }
        
        int Pips = 0;
     // SELL ORDERS
         if(OrderType() == OP_SELL){   
          
          Print(OrderOpenPrice());
          Query = "INSERT INTO CloseSignal (id, closet, closep, profit, pips, account) VALUES('" + OrderTicket() + "','" + OrderOpenTime() + "','" + OrderOpenPrice() + "','" + OrderProfit() + "','" + Pips + "','" + AccountNumber() + "')";
          if (MySqlExecute(DB, Query))
              {
               Print ("Succeeded: ", Query);
              }
          else
              {
               Print ("Error: ", MySqlErrorDescription);
               Print ("Query: ", Query);
              }
         }
      // BUY ORDERS
         if(OrderType() == OP_BUY){           

          Print(OrderOpenPrice());
          Query = "INSERT INTO CloseSignal (id, closet, closep, profit, pips, account) VALUES('" + OrderTicket() + "','" + OrderOpenTime() + "','" + OrderOpenPrice() + "','" + OrderProfit() + "','" + Pips + "','" + AccountNumber() + "')";
          if (MySqlExecute(DB, Query))
              {
               Print ("Succeeded: ", Query);
              }
          else
              {
               Print ("Error: ", MySqlErrorDescription);
               Print ("Query: ", Query);
              }
         }  
         
    }
   MySqlDisconnect(DB);
   Print ("Mysql Disconnected. Done!");
 }
//+------------------------------------------------------------------+

 /*
  // multi-insert
  Query =         "INSERT INTO `test_table` (id, code, start_date) VALUES (1,\'EURUSD\',\'2014.01.01 00:00:01\');";
  Query = Query + "INSERT INTO `test_table` (id, code, start_date) VALUES (2,\'EURJPY\',\'2014.01.02 00:02:00\');";
  Query = Query + "INSERT INTO `test_table` (id, code, start_date) VALUES (3,\'USDJPY\',\'2014.01.03 03:00:00\');";
  if (MySqlExecute(DB, Query))
     {
      Print ("Succeeded! 3 rows has been inserted by one query.");
     }
  else
     {
      Print ("Error of multiple statements: ", MySqlErrorDescription);
     }
   */
