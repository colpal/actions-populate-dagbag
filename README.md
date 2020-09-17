# Populate Dagbag

CI for populating an airflow dagbag

> **IMPORTANT: This branch is to be used in conjunction with the [Changed Files](https://github.com/colpal/actions-changed-files) action**

## Usage

```yaml
steps:
  - uses: actions/checkout@v2.3.1
    with:
      # Be sure to set the fetch-depth to 0 to allow arbitrary analysis of previous commits
      fetch-depth: 0
  # Be sure to set an ID on the step that invokes the action. We need this later to access outputs!
  - id: changed
    uses: colpal/actions-changed-files@v1.0.0
  - run: echo '${{ steps.changed.outputs.text }}'

  - uses: colpal/actions-populate-dagbag@delta-only
    with:
      # SA Key stored as GitHub secret
      SERVICE_ACCOUNT_KEY: ${{ secrets.YOUR_SERVICE_ACCOUNT_KEY }}
      # GCP project
      PROJECT: YOUR_PROJECT
      # GCP cluster
      CLUSTER: YOUR_CLUSTER
      # GCP project zone
      ZONE: YOUR_ZONE
      # Reference the namespace enviornmanetal variable
      NAMESPACE: ${{ env.NAMESPACE }}
      # Reference the pod label enviornmental variable
      POD_LABEL: ${{ env.POD_LABEL }}
      # Pass changed files output from Changed Files action to this action
      DELTAS: ${{ steps.changed.outputs.text }}
```
