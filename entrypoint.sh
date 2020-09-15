#!/bin/sh

set -eux

"$INPUT_SERVICE_ACCOUNT_KEY" | base64 -d > /tmp/service_account.json
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

# remove files that have been changed
for file in "$INPUT_DELTAS"
do
  kubectl exec "$pod_name" -- sh -c "rm -rf $dag_directory/file"
done

# upload files that have been changed
for dag_file in "$INPUT_PATH$INPUT_DELTAS"
do
  test ! -f "$dag_file" \
    || kubectl cp "$dag_file" "$pod_name:$dag_directory"
done
