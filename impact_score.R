require(mixtools)

impact_score <- function(x,b,thresh=1e-12) {
  

  fg <- normalmixEM2comp(x, lambda = 0.5, mu = c(0,1), sigsqrd = c(0.15))
  bg <- normalmixEM2comp(b, lambda = 0.5, mu = c(0,1), sigsqrd = c(0.15))
  
  
  loglik.bg <- bg$lambda[1] * dnorm(x, mean=bg$mu[1], sd=bg$sigma[1]) +
    bg$lambda[2] * dnorm(x, mean=bg$mu[2], sd=bg$sigma[1])
  loglik.bg[loglik.bg<thresh] <- thresh
  loglik.bg <- sum(log(loglik.bg))
  

  loglik.fg <- fg$lambda[1] * dnorm(x, mean=fg$mu[1], sd=fg$sigma[1]) +
    fg$lambda[2] * dnorm(x, mean=fg$mu[2], sd=fg$sigma[1])
  loglik.fg[loglik.fg<thresh] <- thresh

  
  diff_bg_fg <- loglik.fg - loglik.bg
  diff_bg_fg <- mean(1/diff_bg_fg)
  diff_bg_fg <- 1/diff_bg_fg
  diff_bg_fg <- diff_bg_fg ^ (1/log10(length(x)))

  
  lB <- fg$lambda[1]
  lA <- fg$lambda[2]
  
  delta <- diff(fg$mu)
  
  score <- (lA / lB) * (delta/(1-delta)) * diff_bg_fg
  return(c(score, lA/lB, delta/(1-delta), diff_bg_fg))
}
