#!/usr/bin/env python
import click
import curator
import random
import logging
from datetime import datetime
import elasticsearch
# set seed for doc id generation
random.seed(datetime.now().timestamp())

def create_index(client, suffixes, size, index_name):
    click.echo("> Start index creation:")
    
    body = {
        "settings": {
            "index": {
                "number_of_shards": 1,  
                "number_of_replicas": 1 
            }
        }
    }
    # create index
    for suffix in suffixes:
        for i in range(size):
            name = f"{i}-{index_name}-{suffix}"
            try:
                client.indices.create(index=name, body=body)
                # add doc
                index_content = {
                    # default timestamp
                    "@timestamp": f"{datetime.now()}",
                    # can customize message here
                    "message": "This is a mock doc for mock index"
                }
                client.create(index=name,
                          id=str(random.random())[2:],
                          body=index_content)
            except elasticsearch.exceptions.RequestError:
                click.secho("index group [0~{size})-{index_name}-{suffix} already existed!", 
                            fg="green")
                break
        click.secho(f"create index group [0~{size})-{index_name}-{suffix} done!",
                    fg="green")
    click.echo("< End index creation")


def delete_index(client, suffixes, size, index_name):
    click.echo("> Start index deletion")

    for suffix in suffixes:
        ilo = curator.IndexList(client)
        try:
            ilo.filter_by_regex(kind='suffix', value=suffix)
        except curator.exceptions.NoIndices:
            ilo.indices = []
        if ilo.indices:
            delete_indices = curator.DeleteIndices(ilo)
            delete_indices.do_action()
            click.secho(f"delete index group [0~{size})-{index_name}-{suffix} done!",
                        fg="red")
        else:
            click.secho(f"index group [0~{size})-{index_name}-{suffix} already has been deleted!",
                        fg="red")

    click.echo("< End index deletion")


def delete_index_node(client, suffixes, index_name):
    click.echo("> Start index deletion on node es7_01")
    
    params = {
        "s": "node:asc",
        "format": "json"
    }
    for suffix in suffixes:
        shard_list = client.cat.shards(index=f"*-{suffix}",
                                             params=params)
        for shard in shard_list:
            if shard["node"] == "es7_01":
                client.indices.delete(index=shard["index"])
                click.secho(f"delete index {shard['index']} due to node es7_01",
                            fg="red")

    click.echo("< End index deletion on node es7_01")


@click.command()
@click.argument("action",
                type=click.Choice(["create", "delete", "composite"]))
@click.argument("suffixes",
                type=str,
                nargs=-1)
@click.option("-e", "--es-host",
              type=str,
              default="localhost:9200",
              help="elasticsearch host address, default \"localhost:9200\"")
@click.option("-s", "--size",
              type=int,
              default=50,
              help="number of index to each suffix, only work on create stage, default 50")
@click.option("-i", "--index-name",
              type=str,
              default="test",
              help="index name, default \"test\"")
def cli(action, suffixes, es_host, size, index_name):
    """
    Generate mock index with specified pattern and number:

    SUFFIXES: suffix appended to index
    """
    client = elasticsearch.Elasticsearch(hosts = es_host)
    if action == "create":
        create_index(client, suffixes, size, index_name)
    elif action == "delete":
        delete_index(client, suffixes, size, index_name)
    elif action == "composite":
        create_index(client, suffixes, size, index_name)
        # delete first index hosted in es7_01 node
        # this can make other suffix index unbalance across data nodes
        delete_index_node(client, suffixes[:1], index_name)

if __name__ == "__main__":
    cli()