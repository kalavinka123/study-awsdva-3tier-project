## CloudFormation 프로젝트 구조 모범사례

### 요약
- CDK 를 제외하고 CFn 프로젝트 구조에 대한 공식 문서는 없음
- 기본 원칙으로는 프로젝트를 작게 시작해서 확장해나가는 식으로, 필요에 따라 구조화하자는 글도 있었음
- AWS Sample Github 저장소의 구조를 참고할 수는 있음¹
- (외부 문서) OSI 계층처럼 레이어 방식으로 구조화하는 방법²

### 참조
1. https://github.com/aws-samples/ecs-refarch-cloudformation
```
ecs-refarch-cloudformation/
├── LICENSE
├── NOTICE
├── README.md
├── buildspec.yml
├── images
...
├── infrastructure
│   ├── ecs-cluster.yaml
│   ├── lifecyclehook.yaml
│   ├── load-balancers.yaml
│   ├── security-groups.yaml
│   └── vpc.yaml
├── master.yaml
├── services
│   ├── product-service
│   │   ├── service.yaml
│   │   └── src
│   │       ├── Dockerfile
│   │       ├── Makefile
│   │       ├── main.go
│   │       └── users
│   └── website-service
│       ├── service.yaml
│       └── src
│           ├── Dockerfile
│           ├── Makefile
│           ├── main.go
│           └── users
└── tests
    └── validate-templates.sh
```

2. https://leebriggs.co.uk/blog/2023/08/17/structuring-iac
```
├── certs
│   ├── Pulumi.development.yaml
│   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── __main__.py
│   ├── requirements.txt
│   └── venv
├── cluster
│   ├── Pulumi.development.yaml
│   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── README.md
│   ├── __main__.py
│   ├── requirements.txt
│   └── venv
├── shared_database
│   ├── Pulumi.development.yaml
|   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── __main__.py
│   ├── components
│   ├── requirements.txt
│   └── venv
├── domains
│   ├── Pulumi.development.yaml
│   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── __main__.py
│   ├── requirements.txt
│   └── venv
├── cache
│   ├── Pulumi.development.yaml
│   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── __main__.py
│   ├── requirements.txt
│   └── venv
├── shared_example_app
│   ├── Pulumi.development.yaml
│   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── README.md
│   ├── __main__.py
│   ├── productionapp.py
│   ├── requirements.txt
│   └── venv
├── shared_bucket
│   ├── Pulumi.development.yaml
│   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── __main__.py
│   ├── requirements.txt
│   └── venv
├── vpc
│   ├── Pulumi.development.yaml
│   ├── Pulumi.production.yaml
│   ├── Pulumi.yaml
│   ├── __main__.py
│   ├── requirements.txt
│   └── venv
└── vpn
    ├── Pulumi.development.yaml
    ├── Pulumi.production.yaml
    ├── Pulumi.yaml
    ├── __main__.py
    ├── requirements.txt
    └── venv
```