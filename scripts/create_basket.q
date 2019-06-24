basket:([] dt:2019.06.24 2019.06.24; tm:23:10:02.1234 23:10:02.2345; sym:`AAPL`GOOG; px:152.57786212941195 442.2061813220525; vol:100 1000)

select avg px, avg vol by sym from basket
select min px, max px by sym from basket
select vwap:vol wavg px by sym,bkt:100000000 xbar tm from basket

select tm, px from basket where sym=`IBM
