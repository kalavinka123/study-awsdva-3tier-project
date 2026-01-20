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

echo -e "${YELLOW}=== Bootstrap Deployment ===${NC}"
echo "Project: $PROJECT_NAME"
echo "Region: $REGION"
echo "Environment: $ENVIRONMENT"
echo ""

# Check if required parameters are set
if [ -z "$GITHUB_OWNER" ]; then
    read -p "Enter GitHub Owner: " GITHUB_OWNER
fi

if [ -z "$GITHUB_REPO" ]; then
    read -p "Enter GitHub Repository Name: " GITHUB_REPO
fi

if [ -z "$GITHUB_CONNECTION_ARN" ]; then
    echo -e "${YELLOW}Note: Create CodeStar connection in AWS Console first${NC}"
    read -p "Enter GitHub CodeStar Connection ARN: " GITHUB_CONNECTION_ARN
fi

STACK_NAME="${PROJECT_NAME}-${ENVIRONMENT}-bootstrap"

echo ""
echo -e "${GREEN}Deploying bootstrap stack: $STACK_NAME${NC}"

aws cloudformation deploy \
    --stack-name "$STACK_NAME" \
    --template-file bootstrap/pipeline.yaml \
    --parameter-overrides \
        ProjectName="$PROJECT_NAME" \
        Environment="$ENVIRONMENT" \
        GitHubOwner="$GITHUB_OWNER" \
        GitHubRepo="$GITHUB_REPO" \
        GitHubBranch="main" \
        GitHubConnectionArn="$GITHUB_CONNECTION_ARN" \
    --capabilities CAPABILITY_NAMED_IAM \
    --region "$REGION"

echo ""
echo -e "${GREEN}=== Bootstrap deployment completed ===${NC}"
echo ""
echo "Next steps:"
echo "1. Push your code to GitHub"
echo "2. CodePipeline will automatically deploy your infrastructure"
echo ""

# Get outputs
echo -e "${YELLOW}Stack Outputs:${NC}"
aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --region "$REGION" \
    --query 'Stacks[0].Outputs' \
    --output table
