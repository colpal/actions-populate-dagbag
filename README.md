# Populate Dagbag

CI for populating an airflow dagbag

> **IMPORTANT: Master branch action removes all items in the dagbag and repopulates all of them. Please refer to the delta-only branch for a *smarter* way to handle this**

## Usage

```yaml
uses: colpal/actions-populate-dagbag@master
    with:
        # SA Key stored as GitHub secret
        SERVICE_ACCOUNT_KEY: ${{ secrets.YOUR_SERVICE_ACCOUNT_KEY }}
        # GCP project
        PROJECT: YOUR_PROJECT
        # GCP cluster
        CLUSTER: YOUR_CLUSTER
        # GCP project zone
        ZONE: YOUR_ZONE
        # reference the namespace enviornmanetal variable
        NAMESPACE: ${{ env.NAMESPACE }}
        # reference the pod label enviornmental variable
        POD_LABEL: ${{ env.POD_LABEL }}
        # optional arg for path to the folder that contains dag files (must end in /)
        PATH: YOUR_DAG_PATH/
```
