CE.funnel = function(x){
  #Extract se and yi from metafor object and store in dat
  se = sqrt(x$vi)
  yi = x$yi
  dat = data.frame(yi, se)
  #Seq from 0-max se, and define 90-99%CIs for null; store in dfCI
  se.seq=seq(0, max(dat$se), 0.001)
  ll90 = 0-(qnorm(1 - (.10/2))*se.seq)
  ul90 = 0+(qnorm(1 - (.10/2))*se.seq)
  ll95 = 0-(qnorm(1 - (.05/2))*se.seq)
  ul95 = 0+(qnorm(1 - (.05/2))*se.seq)
  ll99 = 0-(qnorm(1 - (.01/2))*se.seq)
  ul99 = 0+(qnorm(1 - (.01/2))*se.seq)
  null = rep(0, length(se.seq))
  dfCI = data.frame(ll90, ul90, ll95, ul95, ll99, ul99, se.seq, null)
  
  #Store APA-format theme object
  apatheme <-
    theme_bw()+                                      #apply ggplot2() black and white theme
    theme(panel.grid.major = element_blank(),        #eliminate major grid lines
          panel.grid.minor = element_blank(),        #eliminate minor grid lines
          panel.background = element_blank(),        #eliminate the square panel background
          panel.border = element_blank(),            #eliminate the square panel border
          text=element_text(family="Arial"),         #use arial font
          legend.title=element_blank(),              #eliminate lengend title
          legend.position= "right",                  #position legend to the right of the plot
          axis.line.x = element_line(color="black"), #include a black border along the x-axis
          axis.line.y = element_line(color="black"))
  
  #Make contour-enhanced funnel plot
  ce.fp = ggplot(data = dat, aes_(x = substitute(se)))+#Map se to x
    #Add data-points to the scatterplot
    geom_point(aes_(y = substitute(yi)), shape = 16, alpha = .75) +
    #Give the x- and y- axes informative labels
    xlab('Standard Error') + ylab('Effect Size')+
    #Add effect size horizontal line (which will be flipped vertical)
    geom_segment(aes(x = min(se.seq), y = null, xend = max(se.seq), yend = null), linetype='solid', data=dfCI) +
    #Add lines for 90% CI around null at different levels of se
    geom_line(aes(x = se.seq, y = ll90), linetype = 'solid', data = dfCI) +
    geom_line(aes(x = se.seq, y = ul90), linetype = 'solid', data = dfCI) +
    #Add lines for 95% CI around null at different levels of se
    geom_line(aes(x = se.seq, y = ll95), linetype = 'dashed', data = dfCI) +
    geom_line(aes(x = se.seq, y = ul95), linetype = 'dashed', data = dfCI) +
    #Ribbons for 90%-95% levels
    geom_ribbon(data = dfCI, aes(x = se.seq, ymin = ll90, ymax = ll95), alpha = .20)+
    geom_ribbon(data = dfCI, aes(x = se.seq, ymin = ul90, ymax = ul95), alpha = .20)+
    #Ribbon for 95%-99% levels
    geom_ribbon(data = dfCI, aes(x = se.seq, ymin = ll95, ymax = ll99), alpha = .40)+
    geom_ribbon(data = dfCI, aes(x = se.seq, ymin = ul95, ymax = ul99), alpha = .40)+
    #Add lines for 99% CI around null at different levels of se
    geom_line(aes(x = se.seq, y = ll99), linetype = 'dotted', data = dfCI) +
    geom_line(aes(x = se.seq, y = ul99), linetype = 'dotted', data = dfCI) +
    #Reverse the x-axis ordering (se) 
    scale_x_reverse()+
    #And now we flip the axes so that SE is on y- and Zr is on x-
    coord_flip()+
    #Apply APA-format theme 
    apatheme
  
  ce.fp
  return(ce.fp)
}
