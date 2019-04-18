#  NACAP - Not Another Coding Assignment for a Portfolio
This system consists of two microservices and a Postgresql database.  It attempts to solve this fictional user story:

```
As an advertiser on a social media network I want to quickly find members of a user's network
at connections N-Deep that like a set of particular songs because I want to quickly mine
this collection for other particular user's to research.
```

## Launch

Notes:
- Must start Database to use system
- Cahce App hard-coded to start on port 9000
- Network Builder App hard-coded to start on port 9001
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


A poorly designed Postgresql Database and data interface layer was defined to serve as the backing store.

## Tools

A custom rest_tool was built to help manually test the system

```
# Posts a small test dataset to the Cache and backing store.
ruby rest_tool.rb post http://localhost:9000/cache cache_data/small_set.json

# Returns user information about user Scott
ruby rest_tool.rb get http://localhost:9000/cache/Scott

# Gets the network for User 'Scott', two layers deep
ruby rest_tool.rb get http://localhost:9001/net/Scott/2
  
```


## Database
The data set being served includes information about Users and Songs.  Users can like multiple Songs and have multiple connections to other Users.

Tables:
USERS:  user_id, username
SONGS: song_id, song_tile
SONG_LIKES: user_id, song_id
USER_CONNECTIONS: user_id,user_id



```
pg_ctl -D /usr/local/var/nacap -l logfile start

psql nacap_demo

```
