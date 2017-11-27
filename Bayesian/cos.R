x<-runif(1e4,0,24)
alpha=70
beta=10
beta2=10
timef<-function(x){
    y<-alpha + beta* cos((2*pi*x)/(24)) + beta2 * sin((2*pi*x)/24)
    return(data.frame(x,y))
}
y<-timef(x)
d<-data.frame(x,y)
d$Season<-"Summer"
ggplot(data=d,aes(x=x,y=y,col=Season)) + geom_point() + geom_line() 

