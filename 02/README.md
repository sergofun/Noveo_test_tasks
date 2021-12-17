# continents_grouping
Exercise 02/03

Now, let’s imagine we have 100 000 000 job offers in our database, and 1000 new job offers per second (yeah, it’s a lot coming in!). What do you implement if we want the same output than in the previous exercise in real-time?

From my point of view there are a few options:
1) I guess it makes sense to put all incoming job offers into message queue (for example it could be Apache Kafka). 
   In this case we will have persistent log for job offers (all these offers could be obtained by other services if required) 
   and at the same time we could scale out statistics service as a consumers group to cooperate during statistic update.
   
2) The second option suppose using time series database, which supports geolocation data type and provides aggregate
function to obtain up to date offers statistic (for example we can use clickhouse for such purposes)
   
3) If it is required to get job offers updates from SQL-like DB (let's suppose it might be PostrgreSQL), I think we 
can configure DB to support batching for reading and handle job offers updates by using elixir flow for the efficient
   paraller updates handling (keeping current statistics in ETS, persistent_term etc - it depends on requirements).
