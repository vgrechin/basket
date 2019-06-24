library( rkdb )

h <- open_connection( "127.0.0.1", 5001, "testusername:testpassword" )

execute( h, "select avg px, avg vol by sym from basket" )
execute( h, "select min px, max px by sym from basket" )
execute( h, "select vwap:vol wavg px by sym, bkt:100000000 xbar tm from basket" )
execute( h, "select max px-mins px from basket where sym=`AAPL" )
execute( h, "select count i by dt from basket" )

Sys.setenv( TZ = "GMT" )

res<-execute(h, "select tm, px from basket where sym=`IBM")

plot(res$tm, res$px, type="l", xlab="time",ylab="price")

close_connection( h )
