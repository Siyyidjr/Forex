#property copyright   "breakermind.com"
#property link        "http://breakermind.com"

#property indicator_chart_window
//---- input parameters
extern int       HGridWeeks=10;       // Period over which to calc High/Low of gird
extern int       HGridPips=100;        // Size of grid in Pips
extern color     HLine=DodgerBlue;        // Color of grid
extern color     HLine2=DodgerBlue;     // Every 100 pips, change grid color to this.



// Recommends settings:
// 1 minute - HGrid.Pips=10, TimeGrid = 10
// 5, 15 minutes - HGrid.Pips=20, TimeGrid= PERIOD_H1 (60)
// 30, 60 minutes - HGrid.Pips=20, TimeGrid = PERIOD_H4 (240) or 2 hours (120)
// 4 hour - HGrid.Pips=50, TimeGrid = PERIOD_D1 (1440) or 12 hours (720)
// 1 day - HGrid.Pips=50, TimeGrid = PERIOD_W1 (10800).


bool firstTime = true;
datetime lastTime = 0;
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  IndicatorShortName("Breakermind.com_100Pips");
   int    counted_bars=IndicatorCounted();
//----
   if ( true /*lastTime == 0 || CurTime() - lastTime > 5*/ ) {
      firstTime = false;
      lastTime = CurTime();
      
      if ( HGridWeeks > 0 && HGridPips > 0 ) {
         double weekH = iHigh( NULL, PERIOD_W1, 0 );
         double weekL = iLow( NULL, PERIOD_W1, 0 );
         
         for ( int i = 1; i < HGridWeeks; i++ ) {
            weekH = MathMax( weekH, iHigh( NULL, PERIOD_W1, i ) );
            weekL = MathMin( weekL, iLow( NULL, PERIOD_W1, i ) );
         }
      
         double pipRange = HGridPips * Point;
         if ( Symbol() == "GOLD" )
            pipRange = pipRange * 10.0;

         double topPips = (weekH + pipRange) - MathMod( weekH, pipRange );
         double botPips = weekL - MathMod( weekL, pipRange );
      
         for ( double p = botPips; p <= topPips; p += pipRange ) {
            string gridname = "grid_" + DoubleToStr( p, Digits );
            ObjectCreate( gridname, OBJ_HLINE, 0, 0, p );
            
            double pp = p / Point;
            int pInt = MathRound( pp );
            int mod = 100;
            if ( Symbol() == "GOLD" )
               mod = 1000;
            if ( (pInt % mod) == 0 )
               ObjectSet( gridname, OBJPROP_COLOR, HLine2 );
            else
               ObjectSet( gridname, OBJPROP_COLOR, HLine );
            ObjectSet( gridname, OBJPROP_STYLE, STYLE_DOT );
            ObjectSet( gridname, OBJPROP_PRICE1, p );
            ObjectSet( gridname, OBJPROP_BACK, true );
         }
      }
            
   }
   
   
        return(0); 
     
      } 

//----
   //return(0);
  

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   firstTime = true;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

   for ( int i = ObjectsTotal() - 1; i >= 0; i-- ) {
      string name = ObjectName( i );
      if ( StringFind( name, "grid_" ) >= 0 ) 
         ObjectDelete( name );
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
