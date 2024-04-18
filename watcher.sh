#!/bin/bash

# Define the namespace where the deployment is running
NAMESPACE="sre"

# Define the name of the deployment to monitor
DEPLOYMENT="swype-app"

# Set the maximum number of allowed restarts before taking action
MAX_RESTARTS=3

# Start an infinite loop to monitor the deployment
while true; do
  # Retrieve the number of restarts from the pod related to the deployment
  RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
  
  # Output the current number of restarts for monitoring purposes
  echo "Current number of restarts: ${RESTARTS}"

  # Check if the restarts exceed the maximum allowed restarts
  if (( RESTARTS > MAX_RESTARTS )); then
    # If true, scale down the deployment to zero replicas and print a message
    echo "Maximum number of restarts exceeded. Scaling down the deployment..."
    kubectl scale --replicas=0 deployment/${DEPLOYMENT} -n ${NAMESPACE}
    # Break out of the loop after taking action
    break
  fi

  # Wait for 60 seconds before checking again
  sleep 60
done
