#!/bin/sh

docker stop some-consul
docker rm some-consul
docker stop some-etcd
docker rm some-etcd
