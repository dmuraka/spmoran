
ipkgs <- rownames(installed.packages())
if (!("plm" %in% ipkgs)) install.packages("plm")
if (!("splm" %in% ipkgs)) install.packages("splm")
if (!("spData" %in% ipkgs)) install.packages("spData")
if (!("spmoran" %in% ipkgs)) install.packages("spmoran")
if(packageVersion("spmoran") < "0.2.2.5") install.packages("spmoran")

library(plm);library(splm);library(spData);library(spmoran)

data(Produc, package = "plm")
data(usaww)
#usaww[usaww>0]<-1

Produc[1:5,]
y     <- Produc$gsp
x     <- data.frame(log_pcap=log(Produc$pcap), log_pc=log(Produc$pc),
                    log_emp=log(Produc$emp), unemp=Produc$unemp)

s_id  <- Produc[,"state"]
meig  <- meigen(cmat=usaww,s_id=s_id)# Moran eigenvectors by states
mod0  <- resf(y=y,x=x,meig=meig) # pooling model

xgroup<- Produc[,"state"]
mod1  <- resf(y=y,x=x,meig=meig,xgroup=xgroup)# individual model

xgroup<- Produc[,c("year")]
mod2  <- resf(y=y,x=x,meig=meig,xgroup=xgroup)# time model

xgroup<- Produc[,c("state","year")]
mod3  <- resf(y=y,x=x,meig=meig,xgroup=xgroup)# two-way model
mod0$e
mod1$e
mod2$e
mod3$e

ng1   <- nongauss_y(y_nonneg=TRUE)
ng2   <- nongauss_y(y_nonneg=TRUE,tr_num=1)
ng3   <- nongauss_y(y_nonneg=TRUE,tr_num=2)

xgroup<- Produc[,"state"]
mod1_1<- resf(y=y,x=x,meig=meig,xgroup=xgroup,nongauss=ng1)
mod1_2<- resf(y=y,x=x,meig=meig,xgroup=xgroup,nongauss=ng2)
mod1_3<- resf(y=y,x=x,meig=meig,xgroup=xgroup,nongauss=ng3)
mod1_1

mod1_1$b_g[[1]]
