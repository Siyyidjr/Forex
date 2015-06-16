#property copyright   "2015, Marcin Łukaszewski, https://breakermind.com"                                     
#property version     "1.00"                                                      
#property description "Indicator Show open positions pips value."
#property icon        "\\Images\\ico.ico";
#property strict

#property indicator_separate_window // Drawing in a separate window
extern int font = 11;   
       
//--------------------------------------------------------------------
int windowIndex;

string Text = "Breakermind.com Open positions pips value:";

int init()                         
{
  //Comment((MarketInfo(Symbol(),MODE_TICKVALUE)*Point)/MarketInfo(Symbol(),MODE_TICKSIZE));
   IndicatorShortName("Breakermind_ShowPips");
   windowIndex=WindowFind("Breakermind_ShowPips");     
   Print(windowIndex);
   if(windowIndex<0)
   {
   Print("Can\'t find window");
   return(0);
   } 
         
   ObjectCreate("signal",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal",OBJPROP_XDISTANCE,5);
   ObjectSet("signal",OBJPROP_YDISTANCE,15);
   ObjectSetText("signal",Text,7,"Arial",Black);
   return(0);                         
  }
//--------------------------------------------------------------------
int start()                        
  {
  
    int total=OrdersTotal();
    // write open orders
    int y = 35;
    for(int pos=0;pos<total;pos++)
    {
     if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
     
      double pips = OrderOpenPrice() - MarketInfo(OrderSymbol(),MODE_BID);
      string position = "";
      if(OrderType() == OP_BUY){
      pips = (OrderClosePrice()-OrderOpenPrice())/MarketInfo(OrderSymbol(),MODE_POINT) / 10;      
       position = "BUY " + OrderLots() + " (" + (OrderLots()*MarketInfo(Symbol(),MODE_LOTSIZE))+ ") " + OrderSymbol()+ " " +OrderOpenPrice()+" => " + OrderProfit() + " " + AccountCurrency()+ " | Pips: " + NormalizeDouble(pips,2);            
        ObjectCreate    ("O_"+OrderTicket(), OBJ_LABEL, windowIndex, 0, 0);  //text label 
        ObjectSetText("O_"+OrderTicket(),position,font, "Verdana", DodgerBlue);     
        ObjectSet("O_"+OrderTicket(),OBJPROP_XDISTANCE,25);
        ObjectSet("O_"+OrderTicket(),OBJPROP_YDISTANCE,y + (25 * pos));
        Print(position);
      }else if(OrderType() == OP_SELL){
        pips = (OrderOpenPrice()-OrderClosePrice())/MarketInfo(OrderSymbol(),MODE_POINT) / 10;      
        position = "SELL " + OrderLots() + " (" + (OrderLots()*MarketInfo(Symbol(),MODE_LOTSIZE))+ ") " + OrderSymbol()+ " " +OrderOpenPrice()+" => " + OrderProfit() + " " + AccountCurrency()+ " | Pips: " + NormalizeDouble(pips,2);
      
        ObjectCreate    ("O_"+OrderTicket(), OBJ_LABEL, windowIndex, 0, 0);  //text label 
        ObjectSetText("O_"+OrderTicket(),position,font, "Verdana", Red);     
        ObjectSet("O_"+OrderTicket(),OBJPROP_XDISTANCE,25);
        ObjectSet("O_"+OrderTicket(),OBJPROP_YDISTANCE,y + (25 * pos));
        Print(position);
           
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
