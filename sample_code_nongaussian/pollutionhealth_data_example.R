#### For details, see spmoran/vignette_nongaussian.pdf ####

ipkgs <- rownames(installed.packages())
if (!("sf" %in% ipkgs)) install.packages("sf")
if (!("rgeos" %in% ipkgs)) install.packages("rgeos")
if (!("CARBayesdata" %in% ipkgs)) install.packages("CARBayesdata")
if (!("spdep" %in% ipkgs)) install.packages("spdep")
if (!("spmoran" %in% ipkgs)) install.packages("spmoran")

library(sf);library(rgeos);library(CARBayesdata);library(spdep);library(spmoran)


data("pollutionhealthdata")
head(pollutionhealthdata)

data("GGHB.IG")
W.nb   <- poly2nb(GGHB.IG)
W.list <- nb2listw(W.nb, style = "B")
W      <- nb2mat(W.nb, style = "B")

formula<- observed ~ jsa + price + pm10 + offset(log(expected))
mod0   <- glm(formula = formula, family = "quasipoisson",data = pollutionhealthdata)
mod0

y      <- pollutionhealthdata[,"observed"]
x      <- pollutionhealthdata[,c("jsa","price","pm10")]
xgroup <- pollutionhealthdata[,"year"]
offset <- pollutionhealthdata[,"expected"]

ng1    <- nongauss_y( y_type = "count")
ng2    <- nongauss_y( y_type = "count", tr_num=1 )

s_id   <- pollutionhealthdata[,"IG"]
meig   <- meigen(cmat=W, s_id = s_id )
mod1   <- resf(y=y, x=x, meig=meig, xgroup=xgroup, offset=offset,nongauss=ng1)
mod2   <- resf(y=y, x=x, meig=meig, xgroup=xgroup, offset=offset,nongauss=ng2)
mod3   <- resf_vc(y=y, x=x, xgroup=xgroup, offset=offset,meig=meig,nongauss=ng1)
mod4   <- resf_vc(y=y, x=x, xgroup=xgroup, offset=offset,meig=meig,nongauss=ng2)

mod1$e
mod2$e
mod3$e
mod4$e

mod3
mod3$b_g
coef_marginal_vc(mod3)
plot(y,mod3$pred[,1])
mod3$pred_quantile[1:2,]
#plot(mod3$pdf,type="l")

obs    <- y[pollutionhealthdata[,"year"] == 2007]
pred   <- mod3$pred[pollutionhealthdata[,"year"] == 2007, ]
b_est  <- mod3$b_vc[pollutionhealthdata[,"year"] == 2007,]
pred_qt<- mod3$pred_quantile[pollutionhealthdata[,"year"] == 2007,]

poly   <- st_as_sf(GGHB.IG)
poly   <- cbind(poly, obs, pred, b_est, pred_qt)

plot(poly[,c("obs","pred")],axes=TRUE, lwd=0.1, key.pos = 1)
plot(poly[,c("q0.025","q0.5","q0.975")],axes=TRUE, lwd=0.1, key.pos = 1)
plot(poly[,"X.Intercept."],axes=TRUE,lwd=0.1, key.pos = 1)
#plot(poly[,"jsa"],axes=TRUE,lwd=0.1, key.pos = 1)
plot(poly[,"price"],axes=TRUE,lwd=0.1, key.pos = 1)
