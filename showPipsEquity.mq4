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
      
   Text1 = "Equity: " + DoubleToString(AccountEquity(),2);         
   ObjectCreate("signal",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal",OBJPROP_XDISTANCE,25);
   ObjectSet("signal",OBJPROP_YDISTANCE,15);
   ObjectSetText("signal",Text1,11,"Arial", Green);
   
   Text1 = " Balance: " + DoubleToString(AccountBalance(),2);         
   ObjectCreate("signal1",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal1",OBJPROP_XDISTANCE,25);
   ObjectSet("signal1",OBJPROP_YDISTANCE,40);
   ObjectSetText("signal1",Text1,11,"Arial", Red);

   Text1 = " FreeMargin: " + DoubleToString(AccountFreeMargin(),2);         
   ObjectCreate("signal2",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal2",OBJPROP_XDISTANCE,25);
   ObjectSet("signal2",OBJPROP_YDISTANCE,60);
   ObjectSetText("signal2",Text1,11,"Arial", DodgerBlue);
         
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
       position = "BUY " + OrderLots() + " (" + (OrderLots()*MarketInfo(Symbol(),MODE_LOTSIZE))+ ") " + OrderSymbol()+ " " +OrderOpenPrice()+" => " + DoubleToString(OrderProfit(),2) + " " + AccountCurrency()+ " | Pips: " + DoubleToString(pips,2);            
        ObjectCreate    ("O_"+OrderTicket(), OBJ_LABEL, windowIndex, 0, 0);
        ObjectSetText("O_"+OrderTicket(),position,font, "Verdana", DodgerBlue);     
        ObjectSet("O_"+OrderTicket(),OBJPROP_XDISTANCE,250);
        ObjectSet("O_"+OrderTicket(),OBJPROP_YDISTANCE,y + (25 * count));
        Print(position);
        count++;
      }else if(OrderType() == OP_SELL){
        pips = (OrderOpenPrice()-OrderClosePrice())/MarketInfo(OrderSymbol(),MODE_POINT) / 10;      
        position = "SELL " + OrderLots() + " (" + (OrderLots()*MarketInfo(Symbol(),MODE_LOTSIZE))+ ") " + OrderSymbol()+ " " +OrderOpenPrice()+" => " + DoubleToString(OrderProfit(),2) + " " + AccountCurrency()+ " | Pips: " + DoubleToString(pips,2);
        ObjectCreate    ("O_"+OrderTicket(), OBJ_LABEL, windowIndex, 0, 0);
        ObjectSetText("O_"+OrderTicket(),position,font, "Verdana", Red);     
        TextSetFont("Verdana", font, FW_BOLD);
        ObjectSet("O_"+OrderTicket(),OBJPROP_XDISTANCE,250);
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
