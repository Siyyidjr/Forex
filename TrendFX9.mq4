//+------------------------------------------------------------------+
//|                                                     TrendFX9.mq4 |
//|                                                https://fxstar.eu |
//| MA Trend power histogram                                         |
//| (M1, M5, M15, M30, H1, H4, D1) in one window.                    |
//+------------------------------------------------------------------+
#property copyright "2016 Copyright Fxstar.eu"
#property link      "https://fxstar.eu"
#property version   "1.00"
#property description   "MA Trend power histogram (M1, M5, M15, M30, H1, H4, D1) in one window."
#property strict

#property indicator_separate_window
#property indicator_buffers 9
#property indicator_color1 Silver
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Black
#property indicator_color5 Blue
#property indicator_color6 Red
#property indicator_color7 Chartreuse
#property indicator_color8 Orange

extern int Period1 = 50;
double ExtBuffer1[];
double ExtBuffer2[];
double ExtBuffer3[];
double ExtBuffer4[];
double ExtBuffer5[];
double ExtBuffer6[];
double ExtBuffer7[];
double ExtBuffer8[];

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
   SetIndexBuffer(4, ExtBuffer5);
   SetIndexStyle(4,DRAW_LINE,0,1);  
   SetIndexBuffer(5, ExtBuffer6);
   SetIndexStyle(5,DRAW_LINE,0,1);
   SetIndexBuffer(6, ExtBuffer7);
   SetIndexStyle(6,DRAW_LINE,0,2);   
   SetIndexBuffer(7, ExtBuffer8);
   SetIndexStyle(7,DRAW_LINE,0,1);  
   
   IndicatorShortName("TrendFX9 Period (" + Period1 + ") ");
   return(0);
  }

int start()
  {
   double ma, Bears ,Bulls ,a, m1,m2,m3,m4,m5,m6,m7, a1,a2,a3,a4,a5,a6,a7,  b1,b2,b3,b4,b5,b6,b7, b11,b22,b33,b44,b55,b66,b77;
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
       m4 = iMA(NULL, PERIOD_M30, Period1, 0, MODE_SMA, PRICE_OPEN, i);
       m5 = iMA(NULL, PERIOD_H1, Period1, 0, MODE_SMA, PRICE_OPEN, i);
       m6 = iMA(NULL, PERIOD_H4, Period1, 0, MODE_SMA, PRICE_OPEN, i);
       m7 = iMA(NULL, PERIOD_D1, Period1-10, 0, MODE_SMA, PRICE_OPEN, i);
                     
       b1 = iHigh(NULL,PERIOD_M1,i) - m1;
       b2 = iHigh(NULL,PERIOD_M5,i) - m2;
       b3 = iHigh(NULL,PERIOD_M15,i) -m3;
       b4 = iHigh(NULL,PERIOD_M30,i) - m4;
       b5 = iHigh(NULL,PERIOD_H1,i) -m5;
       b6 = iHigh(NULL,PERIOD_H4,i) -m6;
       b7 = iHigh(NULL,PERIOD_D1,i) -m7;
             
       b11 = iLow(NULL,PERIOD_M1,i) -m1;
       b22 = iLow(NULL,PERIOD_M5,i) -m2;
       b33 = iLow(NULL,PERIOD_M15,i) -m3;
       b44 = iLow(NULL,PERIOD_M30,i) -m4;
       b55 = iLow(NULL,PERIOD_H1,i) -m5;
       b66 = iLow(NULL,PERIOD_H4,i) -m6;
       b77 = iLow(NULL,PERIOD_D1,i) -m7;

       
       a1 = (b1 + b11) / 2;
       a2 = (b2 + b22) / 2;
       a3 = (b3 + b33) / 2;
       a4 = (b4 + b44) / 2;
       a5 = (b5 + b55) / 2;
       a6 = (b6 + b66) / 2;
       a7 = (b7 + b77) / 2;
              
       a = (Bears + Bulls) / 2;
       
       if(a >= 0)
         {
           ExtBuffer1[i] = Bulls;
           ExtBuffer2[i] = a1;
           ExtBuffer3[i] = a2;
           ExtBuffer4[i] = a3;
           ExtBuffer5[i] = a4;
           ExtBuffer6[i] = a5;
           ExtBuffer7[i] = a6;
           ExtBuffer8[i] = b7;
         }
       else
         {
           ExtBuffer1[i] = Bears;
           ExtBuffer2[i] = a1;
           ExtBuffer3[i] = a2;
           ExtBuffer4[i] = a3;
           ExtBuffer5[i] = a4;
           ExtBuffer6[i] = a5;           
           ExtBuffer7[i] = a6;
           ExtBuffer8[i] = b7;
         }
     }
   return(0);
  }
