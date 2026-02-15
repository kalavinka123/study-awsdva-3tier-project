# study-awsdva-3tier-project

## TODO

### 1. ALB 배포 후 CloudFront Origin 연결
현재 CloudFront Origin이 더미 값(`my-alb-123456...`)으로 설정되어 502 Bad Gateway 발생 중.

- [ ] ALB 스택 배포
- [ ] `parameters/cloudfront.json` → `"ALBDnsName"` 을 실제 ALB DNS로 변경
- [ ] `04-cloudfront.yaml` 스택 업데이트

### 2. 도메인 구매 후 Route53 + ACM + CloudFront 커스텀 도메인 연결
도메인 미구매 상태로 `example.com`을 임시 값으로 설정함.

- [ ] `parameters/route53.json`, `acm.json`, `cloudfront.json` → `"DomainName"` 을 실제 도메인으로 변경
- [ ] `02-route53.yaml` 배포 → 출력된 NameServers를 도메인 등록 대행사에 설정
- [ ] `03-acm.yaml` **us-east-1 리전**에 배포 → DNS 검증 완료 대기
- [ ] `04-cloudfront.yaml` → 주석 처리된 Aliases, ViewerCertificate, DNSRecord 활성화 후 스택 업데이트
