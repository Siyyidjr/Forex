#property copyright   "https://breakermind.com"                                     
#property version     "1.00"                                                      
#property description "Indicator Show open positions pips value."
//#property icon        "\\Images\\ico.ico";
#property strict

#property indicator_separate_window // Drawing in a separate window
extern int font = 13;   
       
//--------------------------------------------------------------------
int windowIndex;

string Text = "";
string Text1 = "";
int init()                         
{
  //Comment((MarketInfo(Symbol(),MODE_TICKVALUE)*Point)/MarketInfo(Symbol(),MODE_TICKSIZE));
   IndicatorShortName("ShowPips");
   windowIndex=WindowFind("ShowPips");     
   Print(windowIndex);
   if(windowIndex<0)
   {
   Print("Can\'t find window");
   return(0);
   } 
   return(0);                         
  }
//--------------------------------------------------------------------
int start()                        
  {
   ObjectsDeleteAll();
   string txt1 = "";
   string txt2 = "";
   string txt3 = "";
   double ma50 = 0;
   double open  = Open[0];
   
   
   double Wopen = iOpen(Symbol(),PERIOD_W1,0);
   double Dopen = iOpen(Symbol(),PERIOD_D1,0);
   double Wpips = (Wopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT) / 10;
   double Dpips = (Dopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT) / 10;
   
   
   ma50 = iMA(NULL,0,50,0,MODE_SMA,PRICE_OPEN,0);
         
   Text1 = "Equity: " + DoubleToString(AccountEquity(),2) + "   WeekOpen: " + iOpen(Symbol(),PERIOD_W1,0) + " DayOpen: " + iOpen(Symbol(),PERIOD_D1,0);         
   ObjectCreate("signal",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal",OBJPROP_XDISTANCE,30);
   ObjectSet("signal",OBJPROP_YDISTANCE,15);
   ObjectSetText("signal",Text1,11,"Arial", Green);
   
   Text1 = " Balance: " + DoubleToString(AccountBalance(),2);         
   ObjectCreate("signal1",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal1",OBJPROP_XDISTANCE,25);
   ObjectSet("signal1",OBJPROP_YDISTANCE,35);
   ObjectSetText("signal1",Text1,11,"Arial", Red);

   Text1 = " FreeMargin: " + DoubleToString(AccountFreeMargin(),2);         
   ObjectCreate("signal2",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal2",OBJPROP_XDISTANCE,25);
   ObjectSet("signal2",OBJPROP_YDISTANCE,55);
   ObjectSetText("signal2",Text1,11,"Arial", DodgerBlue);
   
 
    
   
   if(open > Wopen)
   {
      txt1 = " BUY ";         
   }else{
      txt1 = " SELL ";
   }      
   
   if(open > Dopen)
   {
      txt2 = " BUY ";         
   }else{
      txt2 = " SELL ";
   }   

   if(open > ma50 )
   {
      txt3 = " BUY ";         
   }else{
      txt3 = " SELL ";
   }
     
   Text1 = Symbol() + " [  W: " + txt1 + " D: " + txt2 + " MA50: " + txt3 + " ] "; 
   ObjectCreate("signal3",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal3",OBJPROP_XDISTANCE,29);
   ObjectSet("signal3",OBJPROP_YDISTANCE,80);
   ObjectSetText("signal3",Text1,9,"Arial", Black);
         
   Text1 = " WeekPips: " + DoubleToString(Wpips,2) + " DayPips: " + DoubleToString(Dpips,2); 
   ObjectCreate("signal4",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal4",OBJPROP_XDISTANCE,25);
   ObjectSet("signal4",OBJPROP_YDISTANCE,95);
   ObjectSetText("signal4",Text1,11,"Arial", Green);         
    
         
    int total=OrdersTotal();
    // write open orders
    int y = 35;
    int count = 0;
    for(int pos=0;pos<total;pos++)
    {
    
     if(OrderSelect(pos,SELECT_BY_POS)==false) continue;     
      double pips = OrderOpenPrice() - MarketInfo(OrderSymbol(),MODE_BID);
      string position = "";
      if(OrderType() == OP_BUY){
       pips = (OrderClosePrice()-OrderOpenPrice())/MarketInfo(OrderSymbol(),MODE_POINT) / 10;      
       position = "BUY " + DoubleToString(OrderLots(),2) + " (" + (OrderLots()*MarketInfo(Symbol(),MODE_LOTSIZE))+ ") " + OrderSymbol()+ " " +OrderOpenPrice()+" => " + DoubleToString(OrderProfit(),2) + " " + AccountCurrency()+ " | Pips: " + DoubleToString(pips,2);            
        ObjectCreate    ("O_"+OrderTicket(), OBJ_LABEL, windowIndex, 0, 0);
        ObjectSetText("O_"+OrderTicket(),position,font, "Verdana", DodgerBlue);     
        ObjectSet("O_"+OrderTicket(),OBJPROP_XDISTANCE,450);
        ObjectSet("O_"+OrderTicket(),OBJPROP_YDISTANCE,y + (25 * count));
        Print(position);
        count++;
      }else if(OrderType() == OP_SELL){
        pips = (OrderOpenPrice()-OrderClosePrice())/MarketInfo(OrderSymbol(),MODE_POINT) / 10;      
        position = "SELL " + DoubleToString(OrderLots(),2) + " (" + (OrderLots()*MarketInfo(Symbol(),MODE_LOTSIZE))+ ") " + OrderSymbol()+ " " +OrderOpenPrice()+" => " + DoubleToString(OrderProfit(),2) + " " + AccountCurrency()+ " | Pips: " + DoubleToString(pips,2);
        ObjectCreate    ("O_"+OrderTicket(), OBJ_LABEL, windowIndex, 0, 0);
        ObjectSetText("O_"+OrderTicket(),position,font, "Verdana", Red);     
        TextSetFont("Verdana", font, FW_BOLD);
        ObjectSet("O_"+OrderTicket(),OBJPROP_XDISTANCE,450);
        ObjectSet("O_"+OrderTicket(),OBJPROP_YDISTANCE,y + (25 * count));
        Print(position);           
        count++;
      }   
    } 
    

//--------------------------------------------------------------------
   return(0);                          
  }
//--------------------------------------------------------------------
int deinit()
{
   ObjectsDeleteAll();
   // delete all objects   
   return(0);
}
