

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
