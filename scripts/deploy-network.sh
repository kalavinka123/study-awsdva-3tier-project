#!/bin/bash
set -e

# Configuration
PROJECT_NAME="three-tier"
REGION="${AWS_REGION:-ap-northeast-2}"
ENVIRONMENT="${1:-dev}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

STACK_NAME="${PROJECT_NAME}-${ENVIRONMENT}-network"
TEMPLATE_FILE="stacks/01-network.yaml"
PARAMETERS_FILE="parameters/${ENVIRONMENT}.json"

echo -e "${YELLOW}=== Network Stack Deployment ===${NC}"
echo "Project: $PROJECT_NAME"
echo "Region: $REGION"
echo "Environment: $ENVIRONMENT"
echo "Stack Name: $STACK_NAME"
echo ""

# Check if parameters file exists
if [ ! -f "$PARAMETERS_FILE" ]; then
    echo -e "${RED}Error: Parameters file not found: $PARAMETERS_FILE${NC}"
    exit 1
fi

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}Error: Template file not found: $TEMPLATE_FILE${NC}"
    exit 1
fi

# Validate template
echo -e "${YELLOW}Validating template...${NC}"
aws cloudformation validate-template \
    --template-body file://$TEMPLATE_FILE \
    --region "$REGION" > /dev/null

echo -e "${GREEN}Template validation passed${NC}"
echo ""

# Extract network-related parameters from JSON
PARAMS=$(cat $PARAMETERS_FILE | python3 -c "
import json
import sys
data = json.load(sys.stdin)
params = data.get('Parameters', {})
network_params = ['ProjectName', 'Environment', 'VpcCidr', 'PublicSubnet1Cidr', 'PublicSubnet2Cidr', 'PrivateSubnet1Cidr', 'PrivateSubnet2Cidr', 'DBSubnet1Cidr', 'DBSubnet2Cidr']
overrides = []
for key in network_params:
    if key in params:
        overrides.append(f'{key}={params[key]}')
print(' '.join(overrides))
")

echo -e "${GREEN}Deploying network stack: $STACK_NAME${NC}"
echo "Parameters: $PARAMS"
echo ""

# Deploy stack
aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file "$TEMPLATE_FILE" \
    --parameter-overrides $PARAMS \
    --region "$REGION" \
    --no-fail-on-empty-changeset

echo ""
echo -e "${GREEN}=== Network stack deployment completed ===${NC}"
echo ""

# Get outputs
echo -e "${YELLOW}Stack Outputs:${NC}"
aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue]' \
    --output table
