# This is what I did when I watched the time series lecture (for my data practical).
# Why? Hurricanes are time series (so is gambling and stock markets and phylogenies etc.)

# Then when I understand the example, I figure out how to apply it to my data.
# Q? Then A! (hopefully)

# Nile data that they use
help(Nile)
str(Nile)
help(Nile)

# Plot the Nile data
plot(Nile)

# Plot the Nile data with xlab and ylab arguments
plot(Nile, xlab = "Year", ylab = "River Volume (1e9 m^{3})")

# Plot the Nile data with xlab, ylab, main, and type arguments
plot(Nile, xlab = "Year", ylab = "River Volume (1e9 m^{3})", main = "Annual River Nile Volume at Aswan, 1871-1970", type = "b")

# Let's try it with our data -- first what does it look like?
df <- read.csv('us landfall hurricanes since 1850.csv')
str(df)

# Screw it, let's try it
plot(df)

# What happened? Plotted everything -- not like plot(Nile) -- WHY?

# Try again -- WTF is this? What does the plot do? What is X?
plot(df$Year)

# Google: https://www.google.com/search?client=safari&rls=en&q=what+is+a+time+seris+obkect+in+r&ie=UTF-8&oe=UTF-8

# The ts() function will convert a numeric vector into an R time series object. The format is ts(vector, start=, end=, frequency=) where start and end are the times of the first and last observation and frequency is the number of observations per unit time (1=annual, 4=quartly, 12=monthly, etc.).

# Basic way information about methods are shown to you
# https://financetrain.com/creating-a-time-series-object-in-r
# Like reading the news -- skim until you find what you want to know

# "monthly prices of the S&P Composite Index for the last three years starting from July 2014 to June 2017"
sp_vector <- c(1973.1,1961.53,1993.23,1937.27,2044.57,2054.27,2028.18,2082.2,2079.99,2094.86,2111.94,2099.29,2094.14,2039.87,1944.41,2024.81,2080.62,2054.08,1918.6,1904.42,2021.95,2075.54,2065.55,2083.89,2148.9,2170.95,2157.69,2143.02,2164.99,2246.63,2275.12,2329.91,2366.82,2359.31,2395.35,2433.99)
sp_vector
class(sp_vector)

plot(sp_vector) # "plot does not contain any time index information"

# "data set contains monthly stock prices from July 2017 to June 2017"
sp_ts <- ts(sp_vector,start=c(2014,7),frequency=12)
plot(sp_ts)
plot.ts(sp_ts)


# How to do it on hurricanes? SHIT. Have to figure it out. Create time series
tmp <- df %>% select(Year)

# Maybe the data doesn't fit the model?
# Multiple observations per year
# Take the mean?
# Change the data?
# For frequency...! We can take the number and then apply the years.
# But for severity... can we make the data fit the question? Should we is the first question.

# So let's combine columns and counts -- but wait what if years are simply skipped?
# Double check your data! Here we are OK, e.g.:
# 1862 None 0
tmp <- df %>% select(Year) %>% summarize(count = n())
tmp

# Shit, what happened? We counted all of em. We need em by groups.
tmp <- df %>% select(Year) %>% group_by(Year) %>% summarize(count = n())

# When is start / stop?
tmp %>% arrange(Year) # 1852
tmp %>% arrange(desc(Year)) # 2021
summary(tmp) # One command

# Let's try the default
ts(tmp)

h_freq <- ts(tmp)
plot(h_freq)

# WHAT THE ACTUAL $%#^?
help(ts)
ts(tmp, 1852, 2021) # WTF??


# Let's go back to the example
sp_vector # Some numbers
sp_ts <- ts(sp_vector,start=c(2014,7),frequency=12) # Some magic
sp_ts

# Hurricanes!
h_freq <- tmp %>% select(count)
ts(h_freq) # Getting closer?
ts_h_freq <- ts(h_freq, start = 1852, end = 2021, frequency = 1) # Looks more sp_ts like!
ts_h_freq

# Cross fingers
plot(ts_h_freq) # Way betters! ;D

# Some time series specific commands
start(ts_h_freq)
end(ts_h_freq)
frequency(ts_h_freq)
deltat(ts_h_freq)
cycle(ts_h_freq)

# We can apply other fuctions to a time series
mean(ts_h_freq)

# How to imput estimates that are missing

# Plot the AirPassengers data
plot(AirPassengers)

# Compute the mean of AirPassengers
mean(AirPassengers, na.rm = TRUE)

# Impute mean values to NA in AirPassengers
AirPassengers[85:96] <- mean(AirPassengers, na.rm = TRUE)

# Generate another plot of AirPassengers
plot(AirPassengers)

# Add the complete AirPassengers data to your plot
rm(AirPassengers)
points(AirPassengers, type = "l", col = 2, lty = 3)


# Multiple plots 

# Generate a simple plot of eu_stocks (EuStockMarkets) -> multivariate time series!
plot(EuStockMarkets)
help(EuStockMarkets)

# Use ts.plot with eu_stocks
ts.plot(EuStockMarkets, col = 1:4, xlab = "Year", ylab = "Index Value", main = "Major European Stock Indices, 1991-1998")

# Add a legend to your ts.plot
legend("topleft", colnames(EuStockMarkets), lty = 1, col = 1:4, bty = "n")


# How to do this for years x frequency for each hurricane category?
# https://www.google.com/search?client=safari&rls=en&q=how+to+create+mts+in+r&ie=UTF-8&oe=UTF-8
# https://stat.ethz.ch/R-manual/R-devel/library/stats/html/ts.union.html

str(df)

h_count
cat0 <- h_count %>% filter(Category == 0) %>% select(count)
cat1 <- h_count %>% filter(Category == 1) %>% select(count)
cat2 <- h_count %>% filter(Category == 2) %>% select(count)
cat3 <- h_count %>% filter(Category == 3) %>% select(count)
cat4 <- h_count %>% filter(Category == 4) %>% select(count)
cat5 <- h_count %>% filter(Category == 5) %>% select(count)

# ts_h_freq <- ts(h_freq, start = 1852, end = 2021, frequency = 1)

# ts_cat0 <- ts(cat0, start = 1852, frequency = 1)
ts_cat1 <- ts(cat1, start = 1852, frequency = 1)
ts_cat2 <- ts(cat2, start = 1852, frequency = 1)
ts_cat3 <- ts(cat3, start = 1852, frequency = 1)
ts_cat4 <- ts(cat4, start = 1852, frequency = 1)
ts_cat5 <- ts(cat5, start = 1852, frequency = 1)

# Now we bind them
# ts_by_cat <- ts.union(ts_cat0, ts_cat1, ts_cat2, ts_cat3, ts_cat4, ts_cat5)
ts_by_cat <- ts.union(ts_cat1, ts_cat2, ts_cat3, ts_cat4, ts_cat5)

# Try plotting
plot(ts_by_cat)
plot.ts(ts_by_cat) # Apparently does the same thing. Why?
ts.plot(ts_by_cat) # Different. Why?

ts.plot(cbind(ts_cat1, ts_cat2))
plot(ts_cat2, ts_cat1)

# Use ts.plot with eu_stocks
# ts.plot(ts_by_cat, col = 1:6, xlab = "Year", ylab = "Count", main = "Hurricanes")
ts.plot(ts_by_cat, col = 1:5, xlab = "Year", ylab = "Count", main = "Hurricanes")

# Add a legend to your ts.plot
# legend("topright", colnames(ts_by_cat), lty = 1, col = 1:6, bty = "n")


# Remove trend with diff
# "A difference series lets you examine the increments or changes in a given time series. It always has one fewer observations than the original series."
plot(AirPassengers)
tmp <- diff(AirPassengers)
plot(tmp)

plot(ts_h_freq)
tmp <- diff(ts_h_freq)
plot(tmp)


# Removing seasonality -- what kind of questions can we ask? Are hurricanes becoming more frequent outside of certain seasons?
# First need to create a seasonal data frame of the hurricane data 
# https://www.google.com/search?client=safari&rls=en&q=create+r+dataframe+years+and+months&ie=UTF-8&oe=UTF-8

head(df)
tail(df)

# Couldn't figure this out
seq(1852, 2021, by="month") # fail
seq(1852, 2021) # works, not need months
seq(as.Date("1852/1/1"), as.Date("2022/1/1"), by="month") # works, not need months


# So brute force it! 
Year <- rep(seq(from = 1852, to = 2021), times = 12)
Month <- rep(c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"), times = 170)
Year <- sort(Year)
ym_df <- as.data.frame(cbind(Year, Month))
str(ym_df)
ym_df$Year <- as.numeric(ym_df$Year)

tmp <- left_join(ym_df, df)
tmp <- tmp %>% select(Year, Category)

ts_h_freq_by_month <- ts(tmp, start = 1852, end = 2021, frequency = 12)
plot(ts_h_freq_by_month)

tmp <- diff(ts_h_freq_by_month, lag=12)
plot(tmp)

# Not working... moving on.



# Estimate models
is.ts(ts_h_freq)

arima(ts_h_freq, order = c(0, 0, 0)) # Fit WN model
arima(ts_h_freq, order=c(0,1,0)) # Fit RW model
arima(ts_h_freq, order=c(0,0,1)) # Fit MA model (first)

# Calculate the sample mean and sample variance of y
mean(ts_h_freq)
var(ts_h_freq)



tsData = ts(RawData, start = c(2011,1), frequency = 12)






# Auto correlation

# Define x_t0 as x[-1]
x_t0 <- x[-1] 

# Define x_t1 as x[-n]
x_t1 <- x[-n]

# Confirm that x_t0 and x_t1 are (x[t], x[t-1]) pairs  
head(cbind(x_t0, x_t1))

# Plot x_t0 and x_t1
plot(x_t0, x_t1)

# View the correlation between x_t0 and x_t1
cor(x_t0, x_t1)

# Use acf with x
acf(x, lag.max = 1, plot = FALSE)

# Confirm that difference factor is (n-1)/n 
cor(x_t1, x_t0) * (n-1)/n
