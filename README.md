# study-awsdva-3tier-project

## TODO: 도메인 구매 후 수정 필요

도메인 미구매 상태로 `example.com`을 임시 값으로 설정함. 도메인 구매 후 아래 항목을 수정할 것.

### 1. 파라미터 파일 - DomainName 변경
- [ ] `parameters/route53.json` → `"DomainName": "example.com"` 을 실제 도메인으로 변경
- [ ] `parameters/acm.json` → `"DomainName": "example.com"` 을 실제 도메인으로 변경
- [ ] `parameters/cloudfront.json` → `"DomainName": "example.com"` 을 실제 도메인으로 변경

### 2. 스택 배포 (순서 준수)
- [ ] `02-route53.yaml` 배포 후 출력된 NameServers를 도메인 등록 대행사에 설정
- [ ] `03-acm.yaml` **us-east-1 리전**에 배포
- [ ] `04-cloudfront.yaml` 배포 (ALBDnsName도 실제 값으로 변경 필요)
