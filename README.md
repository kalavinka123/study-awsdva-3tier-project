# 3-Tier Architecture with CloudFormation & CodePipeline

AWS 3-Tier 아키텍처를 CloudFormation으로 관리하고, CodePipeline으로 자동 배포하는 프로젝트입니다.

## Architecture

```
        [Internet]
            │
        [ALB - Public]
            │
    ┌───────┴───────┐
    │   Web (EC2)   │  ← Public Subnet (Auto Scaling)
    └───────┬───────┘
            │
      [ALB - Internal]
            │
    ┌───────┴───────┐
    │   WAS (EC2)   │  ← Private Subnet (Auto Scaling)
    └───────┬───────┘
            │
    ┌───────┴───────┐
    │   DB (RDS)    │  ← Private Subnet (DB)
    └───────────────┘
```

## Folder Structure

```
.
├── bootstrap/                  # Bootstrap (수동 1회 배포)
│   └── pipeline.yaml           # CodePipeline 생성
├── stacks/                     # CloudFormation 스택 (자동 배포)
│   ├── 01-network.yaml         # VPC, Subnet, IGW, NAT
│   ├── 02-security.yaml        # Security Groups, IAM
│   ├── 03-web.yaml             # Web Tier (ALB + EC2 ASG)
│   ├── 04-was.yaml             # WAS Tier (Internal ALB + EC2 ASG)
│   └── 05-db.yaml              # DB Tier (RDS MySQL)
├── parameters/                 # 환경별 파라미터
│   ├── dev.json
│   └── prod.json
├── scripts/                    # 유틸리티 스크립트
│   └── deploy-bootstrap.sh
└── buildspec-validate.yaml     # CodeBuild 설정
```

## Prerequisites

1. AWS CLI 설치 및 설정
2. GitHub 계정
3. AWS CodeStar Connection (GitHub 연결)

## Deployment

### Step 1: Create CodeStar Connection

AWS Console에서 CodeStar Connection을 생성합니다:
1. AWS Console → Developer Tools → Settings → Connections
2. Create connection → GitHub
3. Connection ARN 복사

### Step 2: Deploy Bootstrap

```bash
# 환경 변수 설정
export AWS_REGION=ap-northeast-2
export GITHUB_OWNER=your-github-username
export GITHUB_REPO=study-awsdva-3tier-project
export GITHUB_CONNECTION_ARN=arn:aws:codestar-connections:...

# Bootstrap 배포
chmod +x scripts/deploy-bootstrap.sh
./scripts/deploy-bootstrap.sh dev
```

### Step 3: Push Code

```bash
git add .
git commit -m "Initial infrastructure setup"
git push origin main
```

CodePipeline이 자동으로 트리거되어 인프라를 배포합니다.

## Stack Dependencies

```
01-network → 02-security → 03-web → 04-was → 05-db
```

각 스택은 이전 스택의 Export 값을 Import하여 사용합니다.

## Parameters

### Dev Environment
- Instance Type: t3.micro
- Auto Scaling: 1-2 instances
- RDS: db.t3.micro, Single-AZ

### Prod Environment
- Instance Type: t3.small
- Auto Scaling: 2-4 instances
- RDS: db.t3.small, Multi-AZ

## Cleanup

```bash
# 스택 삭제 (역순)
aws cloudformation delete-stack --stack-name three-tier-dev-db
aws cloudformation delete-stack --stack-name three-tier-dev-was
aws cloudformation delete-stack --stack-name three-tier-dev-web
aws cloudformation delete-stack --stack-name three-tier-dev-security
aws cloudformation delete-stack --stack-name three-tier-dev-network
aws cloudformation delete-stack --stack-name three-tier-dev-bootstrap
```

## Security Features

- Web tier: Public Subnet, ALB로만 접근
- WAS tier: Private Subnet, Internal ALB로만 접근
- DB tier: Private Subnet, WAS Security Group에서만 접근
- RDS 비밀번호: Secrets Manager로 관리
- EC2: SSM Session Manager 접근 가능

## Cost Considerations

Dev 환경 예상 비용 (ap-northeast-2 기준):
- NAT Gateway: ~$32/month
- ALB (2개): ~$32/month
- EC2 (t3.micro x 2-4): ~$15-30/month
- RDS (db.t3.micro): ~$15/month

**Total: ~$94-109/month**
