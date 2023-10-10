## Loading Libraries
library(shiny)
library(shinydashboard)
library(httr)
library(jsonlite)
library(lubridate)
library(ggplot2)
library(stringr)
library(dplyr)
library(tidyr)
library(RColorBrewer)

########################################################################
## Helper Functions
########################################################################


########################################################################
########################################################################


########################################################################
## Server Code
########################################################################
function(input, output, session) {

	########################################################################
	## Create Tx Data
	########################################################################
	## Reactive value to score TxData
	txdata <- reactiveValues(data = NULL)

	## Get Tx Data
	observeEvent(input$wallproc,{
									if(nchar(input$walladd)==42)
									{
										## All Txs
										tx_all <- list()
										offset <- 0
										finished <- FALSE
										progress <- Progress$new()
										progress$set(message = "Fetching Transaction Details", value = 0)
										while(!finished)
										{
											## Tx URL
											tx_url <- paste0("https://safe-transaction-mainnet.safe.global/api/v1/safes/",input$walladd,"/all-transactions/?executed=true&limit=10&offset=",offset,"&queued=false&trusted=false")
											tx_t <- content(GET(tx_url))
											tx_all <- c(tx_all,tx_t[[4]])
											if(is.null(tx_t$`next`)) finished <- TRUE
											offset <- offset+10
											progress$set(message = "Fetching Transaction Details", value = offset/tx_t$count)
										}
										progress$close()
										txsdtls <- tx_all[sapply(tx_all,function(x) !is.null(x$nonce))]

										## Parse Tx Details into a DF
										txdf <- data.frame(
															safeTxHash = sapply(txsdtls,function(x) x$safeTxHash),
															nonce = sapply(txsdtls,function(x) x$nonce),
															txHash = sapply(txsdtls,function(x) ifelse(is.null(x$transactionHash),NA,x$transactionHash)),
															isSuccessful = sapply(txsdtls,function(x) ifelse(is.null(x$isSuccessful),NA,x$isSuccessful)),
															isExecuted = sapply(txsdtls,function(x) x$isExecuted),
															executor = sapply(txsdtls,function(x) ifelse(is.null(x$executor),NA,x$executor)),
															confirmationsRequired = sapply(txsdtls,function(x) x$confirmationsRequired),
															submissionDate = as_datetime(sapply(txsdtls,function(x) x$submissionDate)),
															executionDate = as_datetime(sapply(txsdtls,function(x) ifelse(is.null(x$executionDate),NA,as_datetime(x$executionDate))))
												)
										txdf$SignedBy <- lapply(txsdtls,function(x) sapply(x$confirmations,function(y) y$owner))
										txdf$SignedAt <- lapply(txsdtls,function(x) as_datetime(sapply(x$confirmations,function(y) y$submissionDate)))
										txdata$data <- txdf
										# saveRDS(txdf,"~/Desktop/SafeTxTimes/data.RDS")
									}
									# if(nchar(input$walladd)==41) txdata$data <- readRDS("~/Desktop/SafeTxTimes/data.RDS")
	})
	########################################################################
	########################################################################

	########################################################################
	## Visualisations
	########################################################################
	output$p1 <- renderPlot({
								if(is.null(txdata$data)) return(NULL)

								## Prepare Data
								data <- txdata$data
								pdata <- data.frame(
														`Transaction ID` = data$nonce,
														RawDuration = as.numeric(difftime(data$executionDate,data$submissionDate,units="secs")),
														check.names=FALSE
											)
								p1 <- ggplot(data = pdata, aes(x = `Transaction ID`, y = RawDuration/60/60)) +
								geom_line() +
								geom_point() +
								annotate("rect", ymin = -Inf, ymax = 24, xmin = -Inf, xmax = Inf, alpha = 0.2, fill = "green") +
								annotate("rect", ymin = 24, ymax = 72, xmin = -Inf, xmax = Inf, alpha = 0.2, fill = "grey") +
								annotate("rect", ymin = 72, ymax = 168, xmin = -Inf, xmax = Inf, alpha = 0.2, fill = "orange") +
								annotate("rect", ymin = 168, ymax = Inf, xmin = -Inf, xmax = Inf, alpha = 0.2, fill = "red") +
								scale_x_continuous(breaks = pretty(0:max(pdata$`Transaction ID`),n = 20)) +
								scale_y_continuous(breaks = 24 * (0:30)) +
								labs(
									title = paste0("Execution Time for Transactions over Time"),
									y = "Execution Time (Hours)"
								)
								return(p1)
							})
	output$h2 <- renderUI({
								if(is.null(txdata$data)) return(NULL)
								h4("Gnosis Safe Multi-Signature Sequence Plot")
					})
	output$p2 <- renderPlot({
								if(is.null(txdata$data)) return(NULL)

								## Prepare Data
								data <- txdata$data
								allwalls <- unique(unlist(data$SignedBy))
								vdata <- as.data.frame(mapply(function(x,y,allwalls) match(allwalls,x[order(y)]),data$SignedBy,data$SignedAt,MoreArgs=list(allwalls=allwalls)))
								rownames(vdata) <- allwalls
								colnames(vdata) <- data$nonce
								edata <- data.frame(
														`Transaction ID` = data$nonce,
														RawDuration = as.numeric(difftime(data$executionDate,data$submissionDate,units="secs")),
														check.names=FALSE
											)
								xdata <- 	vdata %>%
											mutate(Address = rownames(vdata)) %>%
											gather(key = `Transaction ID`, value = Value, 1:(ncol(.) - 1)) %>%
											filter(!is.na(Value)) %>%
											left_join(edata %>% mutate(`Transaction ID` = as.character(`Transaction ID`))) %>%
											mutate(`Transaction ID Num` = readr::parse_number(`Transaction ID`)) %>%
											arrange(`Transaction ID Num`) %>%
											mutate(
													`Transaction ID` = factor(`Transaction ID`,
													levels = unique(`Transaction ID`)),
													Value = factor(Value),
													Address = factor(Address),
													`Transaction ID Num` = as.numeric(`Transaction ID`)
											)
								tdata <- 	xdata %>%
											group_by(`Transaction ID`) %>%
											summarise(
														`Transaction ID Num` = `Transaction ID Num`[1],
														RawDuration = RawDuration[1],
														FirstAddress = levels(Address)[min(as.numeric(Address))],
														LastAddress = levels(Address)[max(as.numeric(Address))],
											)

								txtimes <- ifelse(is.na(str_extract(duration(tdata$RawDuration),"(?<=\\().+?(?=\\))")),paste0(sapply(ceiling(tdata$RawDuration),function(x) max(x,0))," Seconds"),str_extract(duration(tdata$RawDuration),"(?<=\\().+?(?=\\))"))
								dark_pal <- brewer.pal(length(levels(xdata$Value)), "Dark2")
								p2 <- 	ggplot(xdata, aes(y = `Transaction ID Num`, x = Address)) +
										geom_segment(data = tdata,aes(y = `Transaction ID Num`, yend = `Transaction ID Num`,x = FirstAddress, xend = LastAddress)) +
										geom_tile(size = .5, fill = "white", aes(colour = Value)) +
										geom_text(aes(label = Value, size = Value, colour = Value),size=8) +
										scale_x_discrete(label = function(x) stringr::str_trunc(x, 16, side = "center")) +
										scale_y_continuous("Transaction ID", expand = c(0, 0), breaks = tdata$`Transaction ID Num`, labels = tdata$`Transaction ID`,limits=c(0,max(tdata$`Transaction ID Num`)+1), sec.axis = sec_axis(~ ., name = "Execution Time", breaks = tdata$`Transaction ID Num`, labels = txtimes)) +
										scale_colour_manual(values = dark_pal) +
										coord_equal() +
										theme(
												legend.position = "off",
												axis.text.x = element_text(size=10,angle = 90, hjust = 1),
												axis.text.y = element_text(size=10),
												plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")
										)
								return(p2)
							},height = 4000,width=600)
	########################################################################
	########################################################################
}
