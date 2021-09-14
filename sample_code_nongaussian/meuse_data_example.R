#### For details, see spmoran/vignette_nongaussian.pdf ####

ipkgs <- rownames(installed.packages())
if (!("sf" %in% ipkgs)) install.packages("sf")
if (!("automap" %in% ipkgs)) install.packages("automap")
if (!("spmoran" %in% ipkgs)) install.packages("spmoran")

library(sf);library(automap);library(spmoran)

data(meuse)
meuse[1:5,]
coords<-meuse[,c("x","y")]
y     <-meuse$zinc
hist(y)

x     <-data.frame(dist= meuse[,"dist"],
                   ffreq2=ifelse(meuse$ffreq==2,1,0),
                   ffreq3=ifelse(meuse$ffreq==3,1,0))

meig  <-meigen(coords)
mod0  <-resf(y=y, x=x,meig=meig)
mod0$e
plot(mod0$pdf)

ng1   <-nongauss_y(y_nonneg=TRUE)
mod1  <-resf(y=y,x=x, meig=meig, nongauss=ng1)
mod1
plot(mod1$pdf)

ng2   <-nongauss_y(y_nonneg=TRUE, tr_num=1)
ng3   <-nongauss_y(y_nonneg=TRUE, tr_num=2)

mod2  <-resf(y=y, x=x,meig=meig, nongauss=ng2)
mod3  <-resf(y=y, x=x,meig=meig, nongauss=ng3)
mod2$e
mod3$e
mod2

plot(mod2$pdf,type="l")
coef_marginal(mod2)

data(meuse.grid)
coords0<-meuse.grid[,c("x","y")]
x0     <-data.frame(dist= meuse.grid$dist,
                   ffreq2=ifelse(meuse.grid$ffreq==2,1,0),
                   ffreq3=ifelse(meuse.grid$ffreq==3,1,0))

meig0  <-meigen0(meig=meig, coords0=coords0)
pres   <-predict0(mod=mod2,x0=x0,meig0=meig0, compute_quantile = TRUE)#
pres$pred[1:2,]
pres$pred_quantile[1:2,]

coordinates(meuse) <- c("x", "y")
meuse_sf<-st_as_sf(meuse)
plot(meuse_sf[,"zinc"], pch=20, axes=TRUE, key.pos = 1)

data(meuse.grid)
gridded(meuse.grid) <- c("x", "y")
kres   <- autoKrige(log(zinc)~dist+ffreq, meuse,meuse.grid)

pred   <- data.frame(coords0,pred=pres$pred[,"pred"],
                     len95=pres$pred_quantile$q0.975 - pres$pred_quantile$q0.025,
                     pred_transG=pres$pred[,"pred_transG"],
                     pred_transG_se=pres$pred[,"pred_transG_se"],
                     pres$pred_quantile,
                     kpred=exp(kres$krige_output$var1.pred))
coordinates(pred)<-c("x","y")
pred_sf <-st_as_sf(pred)

plot(pred_sf[,c("pred","kpred")], pch=20, axes=TRUE, key.pos = 1)
plot(pred_sf[,c("q0.025","q0.5","q0.975")], pch=20, axes=TRUE, key.pos = 1)
plot(pred_sf[,c("len95")], pch=20, axes=TRUE, key.pos = 1)
plot(pred_sf[,"pred_transG"], pch=20, axes=TRUE, key.pos = 1)
plot(pred_sf[,"pred_transG_se"], pch=20, axes=TRUE, key.pos = 1)




