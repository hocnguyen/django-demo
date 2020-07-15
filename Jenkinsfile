pipeline {
   agent any
   environment {
       TEST_PASS="0"
   }
   stages {
      stage('Checking branch name') {
          steps {
            echo "Banch name is: ${params.branch_name}"
            echo "Backend DEFAULT Banch is: ${params.ut_branch_default}"
            }
        }
      
      stage('RUN UNIT TEST'){
         when {
            expression {return (params.repo_name == "django-demo")}
         }
         steps {
            script {
                if(params.merged == true){
                    BRANCH_NAME = "${params.branch_name}"
		    print(BRANCH_NAME)
                } else {
                    BRANCH_NAME = "refs/pulls/origin/pr/${params.pull_number}"
                }
                print "success"
            }
         }
         post {
                success {
                    script {
                            publishCoverageGithub(filepath:'/home/server/workspace/deep/coverage/coverage.xml', coverageXmlType: 'jacoco', comparisonOption: [ value: 'optionFixedCoverage', fixedCoverage: '0.65' ], coverageRateType: 'Line')
                        }
                }
            }
      }
   }
}
