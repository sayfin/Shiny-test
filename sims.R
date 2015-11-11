nsim<- 500


mdbConnect <- odbcDriverConnect("Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=//sydnn033/Archive/Oil/OIL.mdb")

str_sql_spot_mthly<- "SELECT AveragePricesMonthly.Month, AveragePricesMonthly.Brent, AveragePricesMonthly.WTI, AveragePricesMonthly.Tapis,
AveragePricesMonthly.NBP,AvgMonthlyFXrate.[AUD/NZD],AveragePricesMonthly.Kutubu, AveragePricesMonthly.Gippsland,
AveragePricesMonthly.MOPJ, JCC_Query.JCC, AvgMonthlyFXrate.FXavg FROM JCC_Query RIGHT JOIN (AveragePricesMonthly LEFT JOIN AvgMonthlyFXrate
ON AvgMonthlyFXrate.month=AveragePricesMonthly.Month) ON JCC_Query.Month=AveragePricesMonthly.Month ORDER BY AveragePricesMonthly.Month
asc"


spot_mthly<- sqlQuery(mdbConnect, str_sql_spot_mthly, errors = TRUE, 10)
spot_mthly$Gippsland<-spot_mthly$Brent+spot_mthly$Gippsland

nbr_obs<- NROW(spot_mthly)

log_ret_mthly<- log(spot_mthly[2:nbr_obs, colnames(spot_mthly)[2:11]])-log(spot_mthly[1:nbr_obs-1, colnames(spot_mthly)[2:11]])

log_ret_mthly<- cbind(spot_mthly$Month[2:nrow(spot_mthly)],log_ret_mthly)

log_ret_cor<- cor(log_ret_mthly[colnames(log_ret_mthly)[2:11]], use="complete.obs", method = "pearson")

cholesky_d <- chol(log_ret_cor)

iid_norm <- rnorm(nsim*(ncol(spot_mthly)-1),0,1)
dim(iid_norm)<-c(nsim, ncol(spot_mthly)-1)
colnames(iid_norm)<-colnames(spot_mthly)[2:ncol(spot_mthly)]

#corr_noise <- log_ret_mthly[,2:length(log_ret_mthly)]%*%cholesky_d

