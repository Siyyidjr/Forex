#property link      "https://breakermind.com"
#property copyright   "https://breakermind.com"                                     
#property version     "v1.0"                                                     
#property description "Indicator week open and day open."

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Black
#property indicator_color2 Teal
//---- buffers
double dailyopen[];
double weeklyopen[];
double line;
double d,w;

int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,1,2);
   SetIndexBuffer(0,dailyopen);
   SetIndexStyle(1,DRAW_LINE,1,3);
   SetIndexBuffer(1,weeklyopen);
   
   string dopen, wopen;
   dopen = "Daily Open";
   wopen = "Weekly Open";
   
   IndicatorShortName(dopen);
   IndicatorShortName(wopen);
   
   SetIndexLabel(0,dopen);
   SetIndexLabel(1,wopen);
   
   SetIndexDrawBegin(0,1);
   //SetIndexDrawBegin(1,1);
   
//----
   return(0);
  }
int deinit()
  {
   ObjectDelete("Weekly Open");
   ObjectDelete("Daily Open");
   return(0);
  }
int start()
  {
   int counted_bars=IndicatorCounted();
   int limit, i;
   
   if(counted_bars==0)
      {//d=Period();
       //if (d>240)return(-1);
       ObjectCreate("Weekly Open",OBJ_HLINE,0,0,0);
       ObjectCreate("Daily Open",OBJ_HLINE,0,0,0);
      }
   
  
   if(counted_bars<0) return(-1);
   
   limit=(Bars-counted_bars)-1;
   
   for(i=limit; i>=0; i--)
      {
       if(1==TimeDayOfWeek(Time[i]) && 1!=TimeDayOfWeek(Time[i+1]))
         {
          w=Open[i];
          ObjectMove("Weekly Open",0,Time[i],line);
         }
       if (TimeDay(Time[i]) !=TimeDay(Time[i+1]))
         {
          d=Open[i];
          ObjectMove("Daily Open",0,Time[i],line);
         }
       weeklyopen[i]=w;
       dailyopen[i]=d;
      } 
   return(0);
  }
