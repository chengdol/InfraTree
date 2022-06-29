## Elasticsearch Cluster

The compose file is referenced from [geektime-ELK](https://github.com/geektime-geekbang/geektime-ELK), I have tailored the compose file to create hot/warm/cold tiers ES by specifying the `node.roles` ENV variable, see compose file for detail.

Set up 3 nodes elasticsearch cluster along with kibana (comment out cerebro if needed):
```bash
# up
docker-compose -f ./elk-compose.yaml up -d

# down
docker-compose -f ./elk-compose.yaml down -v
```
Access Kibana console from browser `http://localhost:5601/`, check `docker ps` for port mapping detail. Verify the node roles are good:
```bash
GET _cat/nodes
GET _cluster/health
```

# Hot/Warm/Cold Tiers
To try hot/warm/cold tiers, data stream and see how ILM works:
```bash
# update cluster setting
PUT _cluster/settings
{
  "persistent": {
    "indices.lifecycle.poll_interval":"1s"
  }
}

# create Policy
# here I only enable hot and deletion phases
PUT /_ilm/policy/ilm_hot_deletion
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_docs": 3,
            "max_age": "1d"
          }
        }
      },
      "delete": {
        "min_age": "20s",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}

# create template
# set number_of_replicas to 0 as I only have 1 node per tier
PUT /_index_template/hot_deletion_template
{
  "index_patterns" : ["hd-*"],
  "data_stream": {},
  "priority": 1000,
  "template": {
    "settings" : {
      "index" : {
        "lifecycle" : {
          "name" : "ilm_hot_deletion"
        },
        "number_of_shards" : "1",
        "number_of_replicas": "0"
      }
    },
    "mappings" : { },
    "aliases" : { }
  }
}

# repeats the request to index doc to DS
# create stream hd-hello with fake data
POST hd-hello/_doc/
{
  "@timestamp": "2099-04-08T11:06:07.000Z",
  "user": {
    "id": "8a4f500d"
  },
  "message": "Login successful"
}

# create stream hd-apple with fake data
POST hd-apple/_doc/
{
  "@timestamp": "2099-04-08T11:06:07.000Z",
  "user": {
    "id": "8a4f500d"
  },
  "message": "Login successful"
}

# create stream hd-peach with fake data
POST hd-peach/_doc/
{
  "@timestamp": "2099-04-08T11:06:07.000Z",
  "user": {
    "id": "8a4f500d"
  },
  "message": "Login successful"
}

# check doc status in specific index
GET .ds-hd-hello-*/_search?pretty
 
# delete data stream
DELETE /_data_stream/hd-hello
DELETE /_data_stream/hd-apple
```

# Mock Indices
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
