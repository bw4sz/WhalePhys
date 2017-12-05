#gamma prior

# Specify desired mode and sd of gamma distribution:
mode = 150
sd = 20

# Here are the corresponding rate and shape parameter values:
ra = ( mode + sqrt( mode^2 + 4*sd^2 ) ) / ( 2 * sd^2 )
sh = 1 + mode * ra 

show(sh)
show(ra)

# Graph it:
x = seq(0,mode+5*sd,len=1001)
plot( x , dgamma( x , shape=sh , rate=ra ) , type="l" , 
      main=paste("dgamma, mode=",mode,", sd=",sd,sep="") ,
      ylab=paste("dgamma( shape=",signif(sh,3)," , rate=",signif(ra,3)," )",
                 sep="") )
abline( v=mode , lty="dotted" )