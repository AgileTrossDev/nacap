#  NACAP - Not Another Coding Assignment for a Portfolio
This system consists of two microservices and a Postgresql database.  It attempts to solve this fictional problem:

```
As an advertiser on a social media network I want to quickly find members of a user's network
of connections N-Deep that like a set of particular songs because I want to quickly mine
this collection for other particular user's to research.
```

## Launch

```
pg_ctl -D /usr/local/var/nacap -l logfile start
rake cache_start
rake net_builder_start

```



## Design Decisions
The data needed to be served with a RESTful interface.  Since Social Network's tend to be rather large,
I was not going to be able to store the entire data set in memory, however we are also constrained by
the number of database transactions.

To implement the solution I decided to build an in-memory cache
of recently used data with the assumption the advertiser will query users of the social network that
were returned from a previous query.An algorithm was put in place to cap the number of data records
stored in memory and uses a custom algorithm to determine the oldest record to be evicted when new
data needs to be loaded.

A second service was built to perform the filtering of the social network based on the request of the
advertiser.  A custom algorithm was built to effeciently use the cache service to build the requested
data set.


A poorly designed Postgresql Database was defined to serve as the backing store.


## Manual Testing

```
ruby rest_tool.rb post http://localhost:9000/cache cache_data/small_set.json 
ruby rest_tool.rb get http://localhost:9000/cache/scott
  
```


## Database
```
pg_ctl -D /usr/local/var/nacap -l logfile start

psql nacap_demo

```
