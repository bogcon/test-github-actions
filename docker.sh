#!/bin/sh

echo ">>> Install deps"
apk add docker curl jq

network=$(docker inspect --format '{{json .NetworkSettings.Networks}}' `hostname` | jq -r 'keys[0]')
echo "network = ${network}"

echo ">>> Run Consul Docker Image"
docker pull -q consul:1.12.0
docker run -d \
    --name=some-consul \
    -p 8500:8500 \
    --network "${network}" \
    -e CONSUL_BIND_INTERFACE=eth0 \
    consul:1.12.0

echo ">>> Run Etcd Docker Image"
docker pull -q quay.io/coreos/etcd:v3.5.3
docker run -d \
    --name=some-etcd \
    -p 2379:2379 \
    --network "${network}" \
    quay.io/coreos/etcd:v3.5.3 \
    /usr/local/bin/etcd -advertise-client-urls http://some-etcd:2379 -listen-client-urls http://0.0.0.0:2379

echo ">>> Show Running Docker Containers"
sleep 10
docker ps

echo ">>> Executing some commands upon dockers"
curl -X PUT --data-binary "@data.json" http://some-consul:8500/v1/kv/test-key
curl -X GET http://some-consul:8500/v1/kv/test-key
docker exec some-etcd /bin/sh -c "export ETCDCTL_API=3 && /usr/local/bin/etcdctl put test-key test-value"
docker exec some-etcd /bin/sh -c "export ETCDCTL_API=3 && /usr/local/bin/etcdctl get test-key"
