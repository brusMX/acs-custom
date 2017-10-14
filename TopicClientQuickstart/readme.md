# Service Bus Topic Subscriber and Publisher

## Execution using Docker

```sh
docker run -p 8095 -e SOURCE_TOPIC_CONNECTIONSTRING="source Service bus topic connection string"  -e SOURCE_SUBSCRIPT
IONNAME="source topic subscriber name"   -e TARGET_TOPIC_NAME="target topic name"  -e TARGET_TOPIC_CONNECTIONSTRING="target topic connection string"    -e SOURCE_TOPICNAME="source topic name"    maninderjit/topicprocessor:0.1
```