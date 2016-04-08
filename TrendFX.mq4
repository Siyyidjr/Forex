//+------------------------------------------------------------------+
//|                                               BearBullsPower.mq4 |
//+------------------------------------------------------------------+

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Yellow
#property indicator_color3 Silver
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
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(2, ExtBuffer3);
   SetIndexStyle(2,DRAW_LINE,0,1);
   SetIndexBuffer(3, ExtBuffer4);
   SetIndexStyle(3,DRAW_LINE,0,1);
   IndicatorShortName("BearBullsPower Period (" + Period1 + ") ");
   return(0);
  }

int start()
  {
   double ma, Bears ,Bulls ,a;
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
       
       a = (Bears + Bulls) / 2;
       if(a >= 0)
         {
           ExtBuffer1[i] = Bulls;
           ExtBuffer2[i] = 0;
           ExtBuffer3[i] = Bulls;
           ExtBuffer4[i] = Bulls * -1;
         }
       else
         {
           ExtBuffer1[i] = 0;
           ExtBuffer2[i] = Bears;
           ExtBuffer3[i] = Bears;
           ExtBuffer4[i] = Bears * -1;
         }
     }
   return(0);
  }
