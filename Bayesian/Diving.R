sink("Bayesian/Diving.jags")
cat("
    model{
    
    pi <- 3.141592653589
    
    #for each if 6 argos class observation error
    
    for(x in 1:6){
    
    ##argos observation error##
    argos_prec[x,1:2,1:2] <- argos_cov[x,,]
    
    #Constructing the covariance matrix
    argos_cov[x,1,1] <- argos_sigma[x]
    argos_cov[x,1,2] <- 0
    argos_cov[x,2,1] <- 0
    argos_cov[x,2,2] <- argos_alpha[x]
    }
    
    for(i in 1:ind){
    for(g in 1:tracks[i]){
    
    ## Priors for first true location
    #for lat long
    y[i,g,1,1:2] ~ dmnorm(argos[i,g,1,1,1:2],argos_prec[1,1:2,1:2])
    
    #First movement - random walk.
    y[i,g,2,1:2] ~ dmnorm(y[i,g,1,1:2],iSigma)
    
    ###First Behavioral State###
    state[i,g,1] ~ dcat(lambda[]) ## assign state for first obs
    
    #Process Model for movement
    for(t in 2:(steps[i,g]-1)){
    
    #Behavioral State at time T
    phi[i,g,t,1] <- alpha[state[i,g,t-1]] 
    phi[i,g,t,2] <- 1-phi[i,g,t,1]
    state[i,g,t] ~ dcat(phi[i,g,t,])
    
    #Turning covariate
    #Transition Matrix for turning angles
    T[i,g,t,1,1] <- cos(theta[state[i,g,t]])
    T[i,g,t,1,2] <- (-sin(theta[state[i,g,t]]))
    T[i,g,t,2,1] <- sin(theta[state[i,g,t]])
    T[i,g,t,2,2] <- cos(theta[state[i,g,t]])
    
    #Correlation in movement change
    d[i,g,t,1:2] <- y[i,g,t,] + gamma[state[i,g,t]] * T[i,g,t,,] %*% (y[i,g,t,1:2] - y[i,g,t-1,1:2])
    
    #Gaussian Displacement in location
    y[i,g,t+1,1:2] ~ dmnorm(d[i,g,t,1:2],iSigma)
    
    
    }
    
    #Final behavior state
    phi[i,g,steps[i,g],1] <- alpha[state[i,g,steps[i,g]-1]] 
    phi[i,g,steps[i,g],2] <- 1-phi[i,g,steps[i,g],1]
    state[i,g,steps[i,g]] ~ dcat(phi[i,g,steps[i,g],])
    
    ##	Measurement equation - irregular observations
    # loops over regular time intervals (t)    
    
    for(t in 2:steps[i,g]){
    
    # loops over observed locations within interval t
    for(u in 1:idx[i,g,t]){ 
    zhat[i,g,t,u,1:2] <- (1-j[i,g,t,u]) * y[i,g,t-1,1:2] + j[i,g,t,u] * y[i,g,t,1:2]
    
    #for each lat and long
    #argos error
    argos[i,g,t,u,1:2] ~ dmnorm(zhat[i,g,t,u,1:2],argos_prec[argos_class[i,g,t,u],1:2,1:2])
    
    #for each dive depth
    #dive depth at time t
    divedepth[i,g,t,u] ~ dnorm(depth_mu[state[i,g,t]],depth_tau[state[i,g,t]])T(0.01,)
    
    #dive speed (max depth/duration)
    duration[i,g,t,u] ~ dnorm(duration_mu[state[i,g,t]],duration_tau[state[i,g,t]])T(0.01,)
    
    #Assess Model Fit
    
    #Fit dive discrepancy statistics
    eval[i,g,t,u] ~ dnorm(depth_mu[state[i,g,t]],depth_tau[state[i,g,t]])
    E[i,g,t,u]<-pow((dive[i,g,t,u]-eval[i,g,t,u]),2)/(eval[i,g,t,u])
    
    dive_new[i,g,t,u] ~ dnorm(depth_mu[state[i,g,t]],depth_tau[state[i,g,t]])T(0.01,)
    Enew[i,g,t,u]<-pow((dive_new[i,g,t,u]-eval[i,g,t,u]),2)/(eval[i,g,t,u])
    
    }
    }
    }
    }
    
    ###Priors###
    
    #Process Variance
    iSigma ~ dwish(R,2)
    Sigma <- inverse(iSigma)
    
    ##Mean Angle
    tmp[1] ~ dbeta(10, 10)
    tmp[2] ~ dbeta(10, 10)
    
    # prior for theta in 'traveling state'
    theta[1] <- (2 * tmp[1] - 1) * pi
    
    # prior for theta in 'foraging state'    
    theta[2] <- (tmp[2] * pi * 2)
    
    ##Move persistance
    # prior for gamma (autocorrelation parameter)
    #from jonsen 2016
    
    ##Behavioral States
    
    gamma[1] ~ dbeta(4,2)		## gamma for state 1
    dev ~ dunif(0.2,1)			## a random deviate to ensure that gamma[1] > gamma[2]
    gamma[2] <- gamma[1] * dev
    
    #Intercepts
    alpha[1] ~ dbeta(1,1)
    alpha[2] ~ dbeta(1,1)
    
    #Probability of behavior switching 
    lambda[1] ~ dbeta(1,1)
    lambda[2] <- 1 - lambda[1]
    
    #Dive Priors
    #average max depth
    depth_mu[1] ~ dnorm(0,0.0001)T(0,)
    
    #we know that foraging dives are probably 0.1km deeper,
    #but are not more than 0.5 km deeper
    forage ~ dunif(20,500)
    depth_mu[2] <- depth_mu[1] + forage
    
    #speed = depth/duration priors
    duration_mu[1] ~ dnorm(5,0.001)
    time_forage~dunif(0,60)
    duration_mu[2] = duration_mu[1] + time_forage 
    
    #depth and duration variance
    depth_tau[1] ~ dunif(0,500)
    depth_tau[2] ~ dunif(0,500)
    duration_tau[1] ~ dunif(0,500)
    duration_tau[2] ~ dunif(0,500)
    
    ##Argos priors##
    #longitudinal argos precision, from Jonsen 2005, 2016, represented as precision not sd
    
    #by argos class
    argos_sigma[1] <- 11.9016
    argos_sigma[2] <- 10.2775
    argos_sigma[3] <- 1.228984
    argos_sigma[4] <- 2.162593
    argos_sigma[5] <- 3.885832
    argos_sigma[6] <- 0.0565539
    
    #latitidunal argos precision, from Jonsen 2005, 2016
    argos_alpha[1] <- 67.12537
    argos_alpha[2] <- 14.73474
    argos_alpha[3] <- 4.718973
    argos_alpha[4] <- 0.3872023
    argos_alpha[5] <- 3.836444
    argos_alpha[6] <- 0.1081156
    
    }"
    ,fill=TRUE)
sink()