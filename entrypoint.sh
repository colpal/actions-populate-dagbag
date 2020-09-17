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

for dag_file_path in $INPUT_DELTAS; do
  if [[ $dag_file_path == *.py ]] && [[ $dag_file_path == $INPUT_PATH* ]]; then
    # split file + path into an array & fetch last element (file name)
    IFS='/' read -r -a path_array <<< "$dag_file_path"
    dag_file=${path_array[-1]}
    # remove files that have been changed
    kubectl exec "$pod_name" -- sh -c "rm -rf $dag_directory/$dag_file"
    # add changed file to dagbag
    test ! -f "$dag_file_path" \
      || kubectl cp "$dag_file_path" "$pod_name:$dag_directory"
  fi
done

# recursively change file owner of files in directory to airflow
kubectl exec "$pod_name" -- sh -c "chown -R 1000:1000 $dag_directory"
