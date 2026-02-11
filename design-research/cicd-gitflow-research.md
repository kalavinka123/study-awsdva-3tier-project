## CICD 에서의 Git Branch 관리

### 요약
- GitFlow, Github Flow, Trunk Branching 전략 모두 CICD 에 적합함[1]
- 다중 계정에서의 Trunk Branching 전략[2]:
    - 관리할 Branch 가 가장 적음. (최소 main 하고 release 뿐)[3][4][5]
- GitFlow 전략 -> 참고문서[6] 참조
- Github Flow 전략 -> 참고문서[7] 참조
- 그외 일반적인 DevOps 가이드[8], AWS 에서의 CICD[9], CICD 의 Branch 관리[10][11]

### 참고문서
- [1] https://docs.aws.amazon.com/prescriptive-guidance/latest/choosing-git-branch-approach/introduction.html#using-ci-cd-practices
- [2] https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/implement-a-trunk-branching-strategy-for-multi-account-devops-environments.html
- [3] https://trunkbaseddevelopment.com/
- [4] https://trunkbaseddevelopment.com/branch-for-release/
- [5] https://medium.com/@oakley349/you-should-be-doing-trunk-based-development-f6ad8356f1d6
- [6] https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/implement-a-gitflow-branching-strategy-for-multi-account-devops-environments.html
- [7] https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/implement-a-github-flow-branching-strategy-for-multi-account-devops-environments.html
- [8] https://docs.aws.amazon.com/wellarchitected/latest/devops-guidance/devops-guidance.html
- [9] https://docs.aws.amazon.com/whitepapers/latest/practicing-continuous-integration-continuous-delivery/welcome.html
- [10] https://medium.com/@VamK/ci-cd-branches-strategies-449befdeb1b5
- [11] https://www.youtube.com/watch?v=gqXLu7JFetQ