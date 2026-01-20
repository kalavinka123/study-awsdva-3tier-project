# Infrastructure as Code (IaC) 평가 문서

## 1. IaC 개요

### 1.1 IaC란?
Infrastructure as Code(IaC)는 인프라를 코드로 정의하고 관리하는 방식입니다.

```
기존 방식 (수동)              IaC 방식 (자동화)
┌──────────────┐            ┌──────────────┐
│  AWS Console │            │   Code(YAML) │
│   클릭 클릭   │     →      │   git push   │
│  수동 설정    │            │   자동 배포   │
└──────────────┘            └──────────────┘
```

### 1.2 IaC의 핵심 가치

| 가치 | 설명 |
|------|------|
| **버전 관리** | Git으로 인프라 변경 이력 추적 |
| **재현성** | 동일한 환경을 여러 번 생성 가능 |
| **자동화** | CI/CD 파이프라인과 통합 |
| **문서화** | 코드 자체가 인프라 문서 역할 |
| **협업** | PR/코드 리뷰를 통한 변경 검토 |

---

## 2. 주요 IaC 도구 비교

### 2.1 비교 매트릭스

| 항목 | CloudFormation | Terraform | AWS CDK | Pulumi |
|------|----------------|-----------|---------|--------|
| **제공사** | AWS | HashiCorp | AWS | Pulumi Inc. |
| **언어** | YAML/JSON | HCL | TypeScript, Python, Java 등 | TypeScript, Python, Go 등 |
| **클라우드 지원** | AWS Only | Multi-Cloud | AWS Only | Multi-Cloud |
| **상태 관리** | AWS 자동 관리 | State 파일 필요 | CloudFormation 사용 | Pulumi Cloud 또는 Self-hosted |
| **비용** | 무료 | 무료 (Enterprise 유료) | 무료 | 무료 (Team 유료) |
| **학습 곡선** | 중간 | 중간 | 높음 | 높음 |
| **커뮤니티** | AWS 공식 | 매우 큼 | 성장 중 | 성장 중 |

### 2.2 시장 점유율 (2024-2025 기준)

```
Terraform      ████████████████████████  (~70%)
CloudFormation ████████████              (~35%)
AWS CDK        ██████                    (~15%)
Pulumi         ███                       (~8%)

* 복수 사용으로 100% 초과
```

---

## 3. 도구별 상세 분석

### 3.1 AWS CloudFormation

#### 개요
AWS 네이티브 IaC 서비스로, YAML 또는 JSON으로 인프라를 정의합니다.

#### 예시 코드
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  MyVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      Tags:
        - Key: Name
          Value: my-vpc
```

#### 장점
| 장점 | 설명 |
|------|------|
| **AWS 네이티브** | 새 서비스 출시 시 즉시 지원 |
| **상태 자동 관리** | State 파일 관리 불필요 |
| **무료** | 추가 비용 없음 |
| **Drift Detection** | 콘솔 변경 감지 기능 |
| **StackSets** | 멀티 계정/리전 배포 |
| **DVA 시험 범위** | AWS 자격증 시험에 포함 |

#### 단점
| 단점 | 설명 |
|------|------|
| **AWS 전용** | 다른 클라우드 사용 불가 |
| **장황한 문법** | 간단한 리소스도 코드가 김 |
| **프로그래밍 한계** | 조건문/반복문 제한적 |
| **롤백 한계** | 일부 리소스 롤백 실패 시 수동 개입 필요 |

#### 적합한 경우
- AWS 단독 사용 프로젝트
- AWS DVA/SAA 자격증 준비
- 소규모~중규모 인프라

---

### 3.2 Terraform

#### 개요
HashiCorp에서 개발한 오픈소스 IaC 도구로, HCL(HashiCorp Configuration Language)을 사용합니다.

#### 예시 코드
```hcl
provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}
```

#### 장점
| 장점 | 설명 |
|------|------|
| **멀티 클라우드** | AWS, GCP, Azure, K8s 등 지원 |
| **풍부한 Provider** | 수천 개의 Provider 생태계 |
| **모듈 시스템** | 재사용 가능한 모듈 구조 |
| **Plan 기능** | 변경 사항 미리 확인 |
| **업계 표준** | 취업 시 가장 많이 요구됨 |
| **강력한 커뮤니티** | 문서, 예제, 모듈 풍부 |

#### 단점
| 단점 | 설명 |
|------|------|
| **State 관리 필요** | S3 + DynamoDB 등 별도 구성 필요 |
| **State Lock** | 동시 실행 시 충돌 가능 |
| **버전 호환성** | Provider 버전 관리 주의 필요 |
| **AWS 신규 서비스 지연** | AWS 출시 후 Provider 업데이트까지 시간 소요 |

#### State 관리 구성 예시
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

#### 적합한 경우
- 멀티 클라우드/하이브리드 환경
- 대규모 인프라
- DevOps/SRE 커리어 목표

---

### 3.3 AWS CDK (Cloud Development Kit)

#### 개요
프로그래밍 언어로 CloudFormation 템플릿을 생성하는 프레임워크입니다.

#### 예시 코드 (TypeScript)
```typescript
import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';

export class MyStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string) {
    super(scope, id);

    new ec2.Vpc(this, 'MyVPC', {
      cidr: '10.0.0.0/16',
      maxAzs: 2,
    });
  }
}
```

#### 장점
| 장점 | 설명 |
|------|------|
| **프로그래밍 언어** | TypeScript, Python, Java 등 사용 |
| **타입 안정성** | IDE 자동완성, 컴파일 타임 오류 체크 |
| **추상화 레벨** | 고수준 Construct로 간결한 코드 |
| **반복/조건문** | 프로그래밍 언어의 모든 기능 사용 |
| **테스트 가능** | 단위 테스트 작성 가능 |

#### 단점
| 단점 | 설명 |
|------|------|
| **학습 곡선** | 프로그래밍 + AWS + CDK 모두 이해 필요 |
| **AWS 전용** | 다른 클라우드 미지원 |
| **디버깅 어려움** | CloudFormation 변환 후 오류 추적 복잡 |
| **버전 관리** | CDK 버전과 Construct 버전 호환성 |

#### 적합한 경우
- 개발자 중심 팀
- 복잡한 인프라 로직 필요
- 기존 TypeScript/Python 프로젝트

---

### 3.4 Pulumi

#### 개요
범용 프로그래밍 언어로 멀티 클라우드 인프라를 정의하는 IaC 도구입니다.

#### 예시 코드 (TypeScript)
```typescript
import * as aws from "@pulumi/aws";

const vpc = new aws.ec2.Vpc("my-vpc", {
  cidrBlock: "10.0.0.0/16",
  tags: {
    Name: "my-vpc",
  },
});

export const vpcId = vpc.id;
```

#### 장점
| 장점 | 설명 |
|------|------|
| **멀티 클라우드** | AWS, GCP, Azure, K8s 지원 |
| **프로그래밍 언어** | TypeScript, Python, Go, C# 등 |
| **상태 관리 간편** | Pulumi Cloud 제공 |
| **테스트/디버깅** | 표준 테스트 프레임워크 사용 |

#### 단점
| 단점 | 설명 |
|------|------|
| **작은 커뮤니티** | Terraform 대비 자료/예제 부족 |
| **유료 기능** | 팀 기능은 유료 |
| **취업 시장** | 요구하는 회사가 적음 |

#### 적합한 경우
- 프로그래밍 선호 + 멀티 클라우드 필요
- 스타트업/신규 프로젝트

---

## 4. 선택 가이드

### 4.1 상황별 추천

```
┌─────────────────────────────────────────────────────────────┐
│                    IaC 도구 선택 가이드                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Q1. 멀티 클라우드가 필요한가?                               │
│      │                                                      │
│      ├─ Yes ──▶ Q2. 프로그래밍 언어 선호?                   │
│      │              │                                       │
│      │              ├─ Yes ──▶ Pulumi                       │
│      │              └─ No  ──▶ Terraform ⭐                 │
│      │                                                      │
│      └─ No ───▶ Q3. AWS 자격증 준비 중?                     │
│                     │                                       │
│                     ├─ Yes ──▶ CloudFormation ⭐            │
│                     └─ No  ──▶ Q4. 개발자 중심 팀?          │
│                                    │                        │
│                                    ├─ Yes ──▶ AWS CDK       │
│                                    └─ No  ──▶ CloudFormation│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 팀/프로젝트 규모별 추천

| 규모 | 추천 도구 | 이유 |
|------|-----------|------|
| **개인/학습** | CloudFormation | AWS 기본 이해, 무료, 간단 |
| **소규모 팀 (AWS Only)** | CloudFormation 또는 CDK | 상태 관리 부담 없음 |
| **중규모 팀** | Terraform | 모듈화, 협업 기능 |
| **대규모/엔터프라이즈** | Terraform Enterprise | 거버넌스, 정책 관리 |
| **멀티 클라우드** | Terraform | 업계 표준 |

---

## 5. 현재 프로젝트 선택

### 5.1 선택: AWS CloudFormation

### 5.2 선택 이유

| 이유 | 설명 |
|------|------|
| **학습 목적** | AWS DVA 시험에 CloudFormation 포함 |
| **AWS 전용** | 3-Tier 아키텍처가 AWS에서만 운영 |
| **상태 관리** | 별도 State 관리 인프라 불필요 |
| **비용** | 추가 비용 없음 |
| **CodePipeline 통합** | AWS 네이티브 CI/CD와 자연스러운 연동 |

### 5.3 관리 방식

```
┌─────────────────────────────────────────────────────┐
│              GitOps with CloudFormation             │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. 개발자가 YAML 수정                               │
│         │                                           │
│         ▼                                           │
│  2. Git Push (main branch)                          │
│         │                                           │
│         ▼                                           │
│  3. CodePipeline 자동 트리거                         │
│         │                                           │
│         ├──▶ Validate (cfn-lint)                    │
│         │                                           │
│         ├──▶ Deploy to Dev                          │
│         │                                           │
│         └──▶ Deploy to Prod (승인 후)               │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 6. 향후 마이그레이션 고려사항

### 6.1 CloudFormation → Terraform 전환 시

```bash
# 1. 기존 리소스 Import
terraform import aws_vpc.main vpc-12345678

# 2. 또는 도구 사용
# - cf2tf (CloudFormation to Terraform)
# - former2 (AWS 리소스를 Terraform으로 Export)
```

### 6.2 전환 시점 고려
- 멀티 클라우드 요구사항 발생 시
- 팀 규모 확장 시
- 모듈 재사용 요구 증가 시

---

## 7. 참고 자료

### 공식 문서
- [AWS CloudFormation 문서](https://docs.aws.amazon.com/cloudformation/)
- [Terraform 문서](https://developer.hashicorp.com/terraform/docs)
- [AWS CDK 문서](https://docs.aws.amazon.com/cdk/)
- [Pulumi 문서](https://www.pulumi.com/docs/)

### 학습 리소스
- AWS Skill Builder - CloudFormation
- HashiCorp Learn - Terraform
- AWS Workshop - CDK

---

## 8. 결론

| 항목 | 현재 프로젝트 |
|------|---------------|
| **IaC 도구** | AWS CloudFormation |
| **관리 방식** | GitOps (GitHub + CodePipeline) |
| **환경 분리** | parameters/dev.json, prod.json |
| **향후 계획** | 필요 시 Terraform 전환 고려 |

```
현재: CloudFormation (학습/AWS 집중)
    │
    │  멀티 클라우드 필요 시
    ▼
미래: Terraform (확장성/업계 표준)
```
