#### For details, see spmoran/vignette_nongaussian.pdf ####

ipkgs <- rownames(installed.packages())
if (!("spdep" %in% ipkgs)) install.packages("spdep")
if (!("sf" %in% ipkgs)) install.packages("sf")
if (!("spmoran" %in% ipkgs)) install.packages("spmoran")
if(packageVersion("spmoran") < "0.2.2.5") install.packages("spmoran")

library(spdep);library(sf);library(spmoran)

data(boston)
y       <- boston.c[, "CMEDV"]
x       <- boston.c[,c("CRIM", "AGE")]
xconst  <- boston.c[,c("ZN","DIS","RAD","NOX",  "TAX","RM", "PTRATIO", "B")]
coords  <- boston.c[,c("LON","LAT")]
meig 	  <- meigen(coords=coords)
# or
#cmat   <- nb2mat(boston.soi,style="B")
#meig 	<- meigen(cmat=cmat)

ng1     <- nongauss_y(y_nonneg=TRUE)
ng2     <- nongauss_y(y_nonneg=TRUE,tr_num=1)
ng3     <- nongauss_y(y_nonneg=TRUE,tr_num=2)

mod0	  <- resf_vc(y=y,x=x, x_nvc=TRUE,xconst=xconst,meig=meig )
mod1	  <- resf_vc(y=y,x=x, x_nvc=TRUE,xconst=xconst,meig=meig, nongaus=ng1 )
mod2	  <- resf_vc(y=y,x=x, x_nvc=TRUE,xconst=xconst,meig=meig, nongaus=ng2 )
mod3	  <- resf_vc(y=y,x=x, x_nvc=TRUE,xconst=xconst,meig=meig, nongaus=ng3 )
mod0$e
mod1$e
mod2$e
mod3$e

mod2
coef_marginal_vc(mod2)
plot(mod2$pdf,type="l")

############################
####### This part is not available if cmat is used in the meigen function
plot_s(mod2,0)
plot_s(mod2,1)
plot_s(mod2,1,pmax=0.05)
plot_s(mod2,2)
plot_s(mod2,2,pmax=0.05)

############################

boston.tr0<- st_read(system.file("shapes/boston_tracts.shp",package="spData")[1])
boston.tr <- boston.tr0[order(boston.tr0$TOWNNO),1:8]
b_est     <- mod2$b_vc
boston.tr <- cbind(boston.tr, b_est)
names(boston.tr)
plot(boston.tr[,"CRIM"],axes=TRUE,lwd=0.1, key.pos = 1)
plot(boston.tr[, "AGE"],axes=TRUE,lwd=0.1, key.pos = 1)




