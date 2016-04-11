//+------------------------------------------------------------------+
//|                                                     TrendFX3.mq4 |
//+------------------------------------------------------------------+
#property copyright "2016 Copyright Fxstar.eu"
#property link      "https://fxstar.eu"
#property version   "1.00"
#property description   "MA Trend power histogram (M1, M5, M15) in one window"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Silver
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Black

extern int Period1 = 50;
double ExtBuffer1[];
double ExtBuffer2[];
double ExtBuffer3[];
double ExtBuffer4[];

int init()
  {
   SetIndexBuffer(0, ExtBuffer1);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
   
   SetIndexBuffer(1, ExtBuffer2);
   SetIndexStyle(1,DRAW_LINE,0,2);
   SetIndexBuffer(2, ExtBuffer3);
   SetIndexStyle(2,DRAW_LINE,0,1);
   SetIndexBuffer(3, ExtBuffer4);
   SetIndexStyle(3,DRAW_LINE,0,1);
   IndicatorShortName("TrendFX3 Period (" + Period1 + ") ");
   return(0);
  }

int start()
  {
   double ma, Bears ,Bulls ,a, m1,m2,m3, a1,a2,a3,  b1,b2,b3, b11,b22,b33;
   int i, limit;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) 
       return(-1);
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars; 
   for(i = 0; i < limit; i++)
     {
       ma = iMA(NULL, 0, Period1, 0, MODE_SMA, PRICE_OPEN, i);
       Bulls = High[i] - ma;
       Bears = Low[i] - ma;

       m1 = iMA(NULL, PERIOD_M1, Period1, 0, MODE_SMA, PRICE_OPEN, i);
       m2 = iMA(NULL, PERIOD_M5, Period1, 0, MODE_SMA, PRICE_OPEN, i);
       m3 = iMA(NULL, PERIOD_M15, Period1, 0, MODE_SMA, PRICE_OPEN, i);
              
       b1 = iHigh(NULL,PERIOD_M1,i) - m1;
       b2 = iHigh(NULL,PERIOD_M5,i) - m2;
       b3 = iHigh(NULL,PERIOD_M15,i) -m3;
      
       b11 = iLow(NULL,PERIOD_M1,i) -m1;
       b22 = iLow(NULL,PERIOD_M5,i) -m2;
       b33 = iLow(NULL,PERIOD_M15,i) -m3;
         
       a1 = (b1 + b11) / 2;
       a2 = (b2 + b22) / 2;
       a3 = (b3 + b33) / 2;
       
       a = (Bears + Bulls) / 2;
       
       if(a >= 0)
         {
           ExtBuffer1[i] = Bulls;
           ExtBuffer2[i] = a1;
           ExtBuffer3[i] = a2;
           ExtBuffer4[i] = a3;
         }
       else
         {
           ExtBuffer1[i] = Bears;
           ExtBuffer2[i] = a1;
           ExtBuffer3[i] = a2;
           ExtBuffer4[i] = a3;
         }
     }
   return(0);
  }
