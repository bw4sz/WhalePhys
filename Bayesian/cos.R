x<-runif(1e4,0,24)
alpha=-1
beta=3
beta2=0
timef<-function(x){
    y<-inv.logit(alpha + beta* cos((2*pi*x)/(24)) + beta2 * sin((2*pi*x)/24)^2)
    return(data.frame(x,y))
}
y<-timef(x)
d<-data.frame(x,y)
d$Season<-"Summer"
ggplot(data=d,aes(x=x,y=y,col=Season)) + geom_point() + geom_line() 

x<-runif(1e4,0,24)
alpha=-0.8
beta=3
beta2=0
timef<-function(x){
  y<-inv.logit(alpha + beta* cos((2*pi*x)/(24)) + beta2 * sin((2*pi*x)/24)^2)
  return(data.frame(x,y))
}

y<-timef(x)
d2<-data.frame(x,y)
d2$Season<-"Fall"
d3<-bind_rows(d,d2)
ggplot(data=d3,aes(x=x,y=y,col=Season)) + geom_point() + geom_line() + labs(x="Hour",y="P(Resting->Foraging)")
