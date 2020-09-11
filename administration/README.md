# Administration

## Configuration

Change the Zookeeper-Hosts in the `administration-compose.yaml` file to the hosts where your Zookeepers are running:  
` ZK_HOSTS: "<zk01>:2181,<zk02>:2182,<zk03>:2183"`

## Starting

Start the administration services by running `docker-compose -f administration-compose.yaml` up.

