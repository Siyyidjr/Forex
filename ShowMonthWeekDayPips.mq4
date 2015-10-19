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
double profit = 0;

int init()                         
{
  //Comment((MarketInfo(Symbol(),MODE_TICKVALUE)*Point)/MarketInfo(Symbol(),MODE_TICKSIZE));
   IndicatorShortName("ShowWeek");
   windowIndex=WindowFind("ShowWeek");     
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
  profit = 0;
   ObjectsDeleteAll(windowIndex);
   string txt1 = "";
   string txt2 = "";
   string txt3 = "";
   double ma50 = 0;
   double open  = Open[0];
   
   
   double Wopen = iOpen(Symbol(),PERIOD_W1,0);
   double Dopen = iOpen(Symbol(),PERIOD_D1,0);
   double Mopen = iOpen(Symbol(),PERIOD_MN1,0);
   double Wpips = (Wopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT)/10;
   double Dpips = (Dopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT)/10;
   double Mpips = (Mopen-Bid)/MarketInfo(OrderSymbol(),MODE_POINT)/10;   
   
   Print( Symbol() + " Digits " + Digits + " Point " + DoubleToString(Point, 5));
   
   Wpips = MathAbs(NormalizeDouble(Wopen-Bid,Digits)/Point)/10;
   Dpips = MathAbs(NormalizeDouble(Dopen-Bid,Digits)/Point)/10;
   Mpips = MathAbs(NormalizeDouble(Mopen-Bid,Digits)/Point)/10;
   
   if(Digits == 0)
   {
      Wpips = MathAbs(NormalizeDouble(Wopen-Bid,Digits)/Point);
      Dpips = MathAbs(NormalizeDouble(Dopen-Bid,Digits)/Point);
      Mpips = MathAbs(NormalizeDouble(Mopen-Bid,Digits)/Point);
   }
   
   ma50 = iMA(NULL,0,50,0,MODE_SMA,PRICE_OPEN,0);
         
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
   ObjectSet("signal3",OBJPROP_YDISTANCE,20);
   ObjectSetText("signal3",Text1,9,"Arial", Black);
         
   Text1 = " WeekPips: " + DoubleToString(Wpips,2) + " DayPips: " + DoubleToString(Dpips,2) + " MonthPips: " + DoubleToString(Mpips,2); 
   ObjectCreate("signal4",OBJ_LABEL,windowIndex,0,0);
   ObjectSet("signal4",OBJPROP_XDISTANCE,25);
   ObjectSet("signal4",OBJPROP_YDISTANCE,35);
   ObjectSetText("signal4",Text1,11,"Arial", Green);         
    
         
    

//--------------------------------------------------------------------
   return(0);                          
  }
//--------------------------------------------------------------------
int deinit()
{
   ObjectsDeleteAll(windowIndex);
   // delete all objects   
   return(0);
}
