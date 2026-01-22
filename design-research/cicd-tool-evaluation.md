# CD의 핵심

**코드 변경사항을 자동으로 빌드/테스트/배포 준비 상태까지 만들고,**  
**언제든 안전하게 릴리스할 수 있게 만드는 것**

## 배포 요구사항 정의하기

먼저 **어떻게, 어디에 배포할지**를 명확히 — 컨테이너, VM, 서버리스, 정적 배포 중 무엇인지.  
또한 **온프레미스인지 클라우드인지**도 정해야.

이 결정이 필요한 **필수 연동 기능**과 **아키텍처 요구사항**을 좌우한다.

1. **버전 관리 모범 사례 적용**
	- Git 같은 버전관리 시스템 사용
	- 브랜치 전략 운영(Trunk-based / GitFlow 등)
	- PR(Pull Request) + 코드리뷰 강제
	- 커밋 메시지 규칙(예: `feat`, `fix`, `chore` 등 Conventional Commits)로 이력 정리
2. **자동 테스트 구현**
	- 자동 테스트는 회귀(regression)와 품질 저하를 막는 핵심
	- 유닛 테스트(Unit)
	- 통합 테스트(Integration)
	- E2E 테스트(End-to-End, 사용자 시나리오 기반)
	- CI에서 코드 변경마다 자동 실행되도록 구성
3. **지속적 통합(CI) 설정**
	- CI는 문제를 초기에 발견해서 큰 사고를 막는 장치
	- 푸시/PR 생성 시 자동으로 빌드 + 테스트 실행
	- 실패하면 즉시 개발자에게 피드백(상태 체크/알림)
	- 결과가 빨리 와야 개발 흐름이 끊기지 않음
4. **의존성(Dependencies) 효과적으로 관리**
	- 환경마다 “되기도 하고 안 되기도 하는” 문제를 줄이려면 의존성 관리가 중요
	- 의존성 캐싱으로 빌드 속도 개선
	- lockfile 사용으로 동일한 버전 재현성 확보
	- Dependabot / Renovate로 자동 업데이트 PR 생성
	- 취약점 점검 도구(`npm audit`, Snyk 등) 사용
5. **배포 프로세스 자동화**
	- 배포 자동화의 목표는 **사람 실수를 줄이고**, **항상 같은 방식으로 배포**되게 하는 것
	- 수동 배포 절차를 스크립트/자동화로 대체
	- 클릭 몇 번이 아니라, “재현 가능한 배포”가 되어야 함
6. **지속적 전달(CD) 파이프라인 구축**
	- CD는 CI 다음 단계로, 릴리스를 언제든 가능하게 만드는 흐름
	- “빌드 → 테스트 → 스테이징 배포 → 검증 → 프로덕션 준비” 같은 파이프라인 구성
	- **환경을 단계적으로 승격(promotion)** 하는 방식 추천
	- 핵심은 **한 번 빌드한 artifact를 동일하게 여러 환경에 배포**하는 것
7. **모니터링과 로깅 연동**
	- 포만 빠르면 끝이 아니라, “문제 발생 시 즉시 알아야”
	- 로그(logging) 수집/검색 체계
	- 모니터링/알림(에러율, 응답속도, 트래픽, 서비스 상태 등)
	- 배포 후 이상 징후를 빨리 발견하는 구조
8. **보안 및 컴플라이언스(규정 준수) 보장**
	- 보안을 나중에 붙이면 비용이 커짐. 파이프라인에 통합해야
	- 비밀키/토큰 같은 secrets 안전한 저장
	- 의존성 취약점 검사
	- 접근 제어 및 감사(누가 무엇을 배포했는지)
9. **성능과 확장성 최적화**
	- 트래픽이 늘어도 서비스가 버텨야
	- 성능/부하 테스트를 파이프라인에 포함
		- 예: JMeter, Gatling, k6, Locust 등
	- 오토스케일링, 로드밸런싱, 리소스 조정
	- Terraform/Kubernetes 등 IaC로 인프라 자동화
10. **지속적 개선 문화 조성**
	- CD는 툴만으로 되는 게 아니라 “팀 문화”가 핵심
	- 정기 회고(retrospective)로 병목/문제 개선
	- 빌드 시간, 실패율, 배포 성공률 같은 지표 기반으로 개선
	- 학습 공유, 베스트 프랙티스 도입

---

## The 10-Step CHECKLIST

<details>
<summary><strong>펼치기</strong></summary>

### 1. Adopt Version Control Best Practices

**Version control is the backbone of modern software development, enabling teams to collaborate effectively and maintain a history of code changes.**

**Use Systems Like Git:** Implement a distributed version control system like Git to manage your codebase. Git allows multiple developers to work independently and merge their changes seamlessly. It provides robust features for branching, merging, and reverting changes, making it suitable for projects of any size.  
**Implement trunk-based development (GitFlow):** Establish a branching strategy that aligns with your workflow, such as Gitflow, feature branching, or trunk-based development. Use branches to isolate work on new features or bug fixes.  
**Enforce pull requests and code reviews:** Incorporate code reviews into your process by utilizing pull requests on platforms like GitHub or Bitbucket. Code reviews enhance code quality, encourage knowledge sharing, and promote team collaboration.  
**Maintain clean commit history with conventional commits:** Use a standardized commit message format to indicate change type, scope, and purpose, improving readability and traceability. For example, by categorizing commits into types like “fix,” “feat,” or “chore”.

- **Use Systems Like Git:** Implement a distributed version control system like Git to manage your codebase. Git allows multiple developers to work independently and merge their changes seamlessly. It provides robust features for branching, merging, and reverting changes, making it suitable for projects of any size.
- **Implement trunk-based development (GitFlow):** Establish a branching strategy that aligns with your workflow, such as Gitflow, feature branching, or trunk-based development. Use branches to isolate work on new features or bug fixes.
- **Enforce pull requests and code reviews:** Incorporate code reviews into your process by utilizing pull requests on platforms like GitHub or Bitbucket. Code reviews enhance code quality, encourage knowledge sharing, and promote team collaboration.
- **Maintain clean commit history with conventional commits:** Use a standardized commit message format to indicate change type, scope, and purpose, improving readability and traceability. For example, by categorizing commits into types like “fix,” “feat,” or “chore”.

### 2. Set Up Continuous Integration (CI)

**Continuous Integration is crucial for detecting issues early and ensuring that code changes integrate smoothly into the main codebase.**

**Automate Builds and Tests Using CI Tools:** Utilize a CI platform like Semaphore to automate your build and test processes. Semaphore allows you to define workflows consisting of pipelines, which are sequences of tasks to build, test, and deploy your application. You can create pipelines using the visual workflow editor or by writing YAML configuration files for greater control and versioning. For instance, you can set up a pipeline that triggers whenever code is pushed to a branch or a pull request is opened. In your pipeline configuration, you specify the steps needed to build your application and run your test suite.  
**Provide Immediate Feedback to Developers:** Configure your CI system to report build and test results promptly. Semaphore integrates with version control systems to provide status checks on commits and pull requests. Immediate feedback allows developers to address issues quickly, maintaining code quality and reducing the likelihood of defects reaching production. Semaphore’s integration capabilities ensure that developers are notified of build failures or test issues as soon as they occur, fostering a proactive development environment.

- **Automate Builds and Tests Using CI Tools:** Utilize a CI platform like Semaphore to automate your build and test processes. Semaphore allows you to define workflows consisting of pipelines, which are sequences of tasks to build, test, and deploy your application. You can create pipelines using the visual workflow editor or by writing YAML configuration files for greater control and versioning. For instance, you can set up a pipeline that triggers whenever code is pushed to a branch or a pull request is opened. In your pipeline configuration, you specify the steps needed to build your application and run your test suite.
- **Provide Immediate Feedback to Developers:** Configure your CI system to report build and test results promptly. Semaphore integrates with version control systems to provide status checks on commits and pull requests. Immediate feedback allows developers to address issues quickly, maintaining code quality and reducing the likelihood of defects reaching production. Semaphore’s integration capabilities ensure that developers are notified of build failures or test issues as soon as they occur, fostering a proactive development environment.

### 3. Implement Automated Testing

**Automated testing ensures that code changes do not introduce regressions and that your application behaves as expected.**

**Write Unit, Integration, and End-to-End Tests:** Develop a comprehensive testing strategy that includes different levels of testing. [Unit tests](https://www.browserstack.com/guide/unit-testing-a-detailed-guide) check individual components, [integration tests](https://semaphore.io/blog/unit-testing-vs-integration-testing) verify the interaction between components, and [end-to-end tests](https://microsoft.github.io/code-with-engineering-playbook/automated-testing/e2e-testing/) simulate real user scenarios. This layered approach helps catch issues at various stages.  
**Automate Tests to Run on Every Code Change:** Configure your CI pipeline to run tests automatically whenever code is pushed or a pull request is opened. Tools like Semaphore allow you to define jobs within your pipeline that execute your tests. For example, in a JavaScript project using Jest, you can set up a job that runs `npm test` as part of your pipeline.

- **Write Unit, Integration, and End-to-End Tests:** Develop a comprehensive testing strategy that includes different levels of testing. [Unit tests](https://www.browserstack.com/guide/unit-testing-a-detailed-guide) check individual components, [integration tests](https://semaphore.io/blog/unit-testing-vs-integration-testing) verify the interaction between components, and [end-to-end tests](https://microsoft.github.io/code-with-engineering-playbook/automated-testing/e2e-testing/) simulate real user scenarios. This layered approach helps catch issues at various stages.
- **Automate Tests to Run on Every Code Change:** Configure your CI pipeline to run tests automatically whenever code is pushed or a pull request is opened. Tools like Semaphore allow you to define jobs within your pipeline that execute your tests. For example, in a JavaScript project using Jest, you can set up a job that runs `npm test` as part of your pipeline.

### 4. Manage Dependencies Effectively

**Proper dependency management ensures that your application builds and runs consistently across different environments.**

**Cache Dependencies:** In CI/CD pipelines, caching dependencies can drastically speed up builds. Caches eliminate the need to fetch packages from scratch on every run, saving time and network bandwidth. Ensure the cache invalidates properly when the lockfile changes to avoid stale or inconsistent installs.

- **Cache Dependencies:** In CI/CD pipelines, caching dependencies can drastically speed up builds. Caches eliminate the need to fetch packages from scratch on every run, saving time and network bandwidth. Ensure the cache invalidates properly when the lockfile changes to avoid stale or inconsistent installs.

**Use lockfiles:** Employ tools specific to your programming language to manage libraries and packages. For example, use npm or Yarn for JavaScript projects, pip for Python, or Maven/Gradle for Java. These tools help you specify exact versions of dependencies, ensuring consistency and reproducibility.  
**Keep Dependencies Updated and Secure:** Regularly update your dependencies to benefit from the latest features and security patches. Automate this process using tools like Dependabot or Renovate, which can create pull requests when new versions are available. Additionally, use security auditing tools such as `npm audit` or Snyk to detect vulnerabilities in your dependencies.

- **Use lockfiles:** Employ tools specific to your programming language to manage libraries and packages. For example, use npm or Yarn for JavaScript projects, pip for Python, or Maven/Gradle for Java. These tools help you specify exact versions of dependencies, ensuring consistency and reproducibility.
- **Keep Dependencies Updated and Secure:** Regularly update your dependencies to benefit from the latest features and security patches. Automate this process using tools like Dependabot or Renovate, which can create pull requests when new versions are available. Additionally, use security auditing tools such as `npm audit` or Snyk to detect vulnerabilities in your dependencies.

### 5. Automate Deployment Processes

**Automating deployment processes ensures that software releases are consistent, repeatable, and less prone to human error.**

**Utilize Infrastructure as Code (IaC):** Implement tools like Terraform, Ansible, or CloudFormation to define and manage your infrastructure through code. IaC allows you to version control your infrastructure configurations alongside your application code, ensuring that environments can be recreated or scaled reliably. By integrating IaC into your CI/CD pipeline, you can automate the provisioning and configuration of environments needed for testing, staging, and production. Semaphore pipelines can include jobs that execute IaC scripts, enabling you to manage infrastructure changes as part of your deployment process.

- **Utilize Infrastructure as Code (IaC):** Implement tools like Terraform, Ansible, or CloudFormation to define and manage your infrastructure through code. IaC allows you to version control your infrastructure configurations alongside your application code, ensuring that environments can be recreated or scaled reliably. By integrating IaC into your CI/CD pipeline, you can automate the provisioning and configuration of environments needed for testing, staging, and production. Semaphore pipelines can include jobs that execute IaC scripts, enabling you to manage infrastructure changes as part of your deployment process.

### 6. Establish Continuous Delivery Pipelines

**A well-defined pipeline automates the flow of code changes from commit to deployment, ensuring that every change is tested, validated, and ready for release.**

**Define clear stage progression:** Outline the stages your code should pass through before reaching production. Common stages include build, test, staging, and production. Each stage can have its own set of checks and balances to ensure code quality and readiness. In Semaphore, pipelines are defined using YAML configuration files. You can specify the sequence of blocks (stages), dependencies, and the conditions under which each block should run.

- **Define clear stage progression:** Outline the stages your code should pass through before reaching production. Common stages include build, test, staging, and production. Each stage can have its own set of checks and balances to ensure code quality and readiness. In Semaphore, pipelines are defined using YAML configuration files. You can specify the sequence of blocks (stages), dependencies, and the conditions under which each block should run.

이미지(참고):  
https://semaphore.io/wp-content/uploads/2025/01/01-stage-progression-1056x184.webp

**Automate Gating & Promotions:** As each stage (e.g., test, staging) completes successfully, you can set up automatic or manual “gates” that determine when to promote the application to the next stage. For instance, after all tests pass in the staging environment, you can automatically trigger a production deployment. This ensures only tested, stable code is promoted.

- **Automate Gating & Promotions:** As each stage (e.g., test, staging) completes successfully, you can set up automatic or manual “gates” that determine when to promote the application to the next stage. For instance, after all tests pass in the staging environment, you can automatically trigger a production deployment. This ensures only tested, stable code is promoted.

### 7. Integrate Monitoring and Logging

**Integrating monitoring and logging into your CD pipeline ensures that you can track application performance, detect issues early, and respond proactively.**

- **Provide a Single Pane of Glass with Unified Dashboards:** Consolidate logs, metrics, traces, and alerts into one dashboard for end-to-end observability.
- **Set Up Centralized Logging and Alerts:** Collect logs into a centralized system and configure alerts.
- **Utilize Trace Sampling to Optimize Data Storage:** Capture only a fraction of requests to manage tracing cost.
- **Implement Performance Monitoring:** Track system health and consider automatic rollback when metrics indicate problems.

### 8. Ensure Security and Compliance

**Security and compliance are critical components of a robust Continuous Delivery pipeline.**

- **Integrate Security Scans into Pipelines:** Add automated scanning for code, dependencies, and configurations.
- **Automate Compliance Checks and Manage Secrets Securely:** Manage secrets securely and automate compliance checks. (Semaphore Secrets 참고: https://docs.semaphore.io/using-semaphore/secrets)

**Integrating security and compliance into your pipeline reduces risks and helps maintain user trust.**

### 9. Optimize for Performance and Scalability

Include performance and load testing in your pipeline (JMeter, Gatling, Grafana k6, Locust).  
Design infrastructure to scale efficiently with auto-scaling, load balancing, and resource allocation. IaC(Terraform/Kubernetes)로 자동화.

### 10. Foster a Culture of Continuous Improvement

- **Hold Regular Retrospectives:** Use pipeline metrics to identify bottlenecks and improve.
- **Encourage Ongoing Learning and Adoption of Best Practices:** Share knowledge and keep up with trends.

**By fostering a culture of continuous improvement, your team remains agile, innovative, and better equipped to deliver high-quality software.**

</details>

---

## Links

1. [20-Point Checklist Before Choosing a CI/CD Tool](https://dev.to/hexshift/20-point-checklist-before-choosing-a-cicd-tool-50k4)
2. [The 10-Step Checklist for Continuous Delivery - Semaphore](https://semaphore.io/blog/continuous-delivery-checklist?utm_source=chatgpt.com)