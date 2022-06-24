## Elasticsearch Cluster

The compose file is referenced from [geektime-ELK](https://github.com/geektime-geekbang/geektime-ELK), the many practices please see it as well.

Set up 3 nodes elasticsearch cluster along with kibana and cerebro(commented out in docker compose yaml file)
```bash
# up
docker-compose -f ./elk-compose.yaml up -d

# down
docker-compose -f ./elk-compose.yaml down -v
```

Access Kibana console from `localhost:5601`, see docker ps for port mapping detail.

To fill in mock indices, try `mock_index_generate.py` script within virtualenv >= python version 3.8, by default each index has 1 primary and 1 replica shard.
```bash
pip install --no-cache-dir -r requirements.txt

# help message and see default options value
python mock_index_generate.py --help

# create multiple indices with default name and size
python mock_index_generate.py create 2021.10 2021.11 2021.12 2021.13

# delete specified indices
python mock_index_generate.py delete 2021.10 2021.11

# composite, depends on how to arrange
python mock_index_generate.py composite 2021.10 2021.11 2021.12
```

To examine shard distribution:
```bash
export pattern="*-2021.10"

curl -s "localhost:9200/_cat/shards/$pattern?s=node:asc" > shards && cat shards | awk {'print $8'} | uniq -c | sort -rn

cat shards | awk {'print $8'} | uniq -c | sort -rn | awk 'BEGIN { sum = 0; count = 0 } { sum += $1; count += 1 } END { print sum / count }'
```
