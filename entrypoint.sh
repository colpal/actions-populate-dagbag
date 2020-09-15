#!/bin/bash

set -eux

echo "$INPUT_SERVICE_ACCOUNT_KEY" | base64 -d > /tmp/service_account.json
gcloud auth activate-service-account --key-file=/tmp/service_account.json

gcloud container clusters get-credentials "$INPUT_CLUSTER" \
  --project "$INPUT_PROJECT" \
  --zone "$INPUT_ZONE"
kubectl config set-context \
  --current \
  --namespace="$INPUT_NAMESPACE"

dag_directory=/exports/dags
pod_name=$(\
  kubectl get pod \
    -l "$INPUT_POD_LABEL" \
    -o jsonpath='{.items[0].metadata.name}'\
)

for dag_file in $INPUT_DELTAS; do
  if [[ $dag_file == *.py ]]; then
    # remove files that have been changed
    kubectl exec "$pod_name" -- sh -c "rm -rf $dag_directory/$dag_file"
    # add changed file to dagbag
    test ! -f "$INPUT_PATH$dag_file" \
      || kubectl cp "$INPUT_PATH$dag_file" "$pod_name:$dag_directory"
  fi
done

