#!/bin/bash
docker build -t florianlemiere/multi-client:latest -t florianlemiere/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t florianlemiere/multi-server:latest -t florianlemiere/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t florianlemiere/multi-worker:latest -t florianlemiere/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push florianlemiere/multi-client:latest
docker push florianlemiere/multi-server:latest
docker push florianlemiere/multi-worker:latest

docker push florianlemiere/multi-client:$SHA
docker push florianlemiere/multi-server:$SHA
docker push florianlemiere/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=florianlemiere/multi-server:$SHA
kubectl set image deployments/client-deployment client=florianlemiere/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=florianlemiere/multi-worker:$SHA