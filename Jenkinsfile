//@Library('tfc-lib') _
library(identifier: 'jenkinssharedlib@MATLAB-bootfiles', retriever: modernSCM(
  [$class: 'GitSCMSource',
       remote: 'https://github.com/ribhudp23/jenkinssharedlib-private-fork.git',
       credentialsId: 'GH-SharedLib-Private-Fork-Access'
]))
https://github.com/ribhudp23/jenkinssharedlib-private-fork.git

dockerConfig = getDockerConfig(['MATLAB','Vivado'], matlabHSPro=false)
dockerConfig.add("-e MLRELEASE=R2021b")
dockerHost = 'docker'

////////////////////////////


hdlBranches = ['main']

stage("Build Toolbox") {
    dockerParallelBuild(hdlBranches, dockerHost, dockerConfig) { 
	branchName ->
	withEnv(['HDLBRANCH='+branchName]) {
	    checkout scm
	    sh 'git submodule update --init' 
        sh 'pip3 install -r requirements_doc.txt'
		sh 'make -C ./CI/gen_doc doc'

	    sh 'make -C ./CI/scripts gen_tlbx'
	}
        stash includes: '**', name: 'builtSources', useDefaultExcludes: false
        archiveArtifacts artifacts: '*.mltbx', followSymlinks: false, allowEmptyArchive: true
    }
}

/////////////////////////////////////////////////////



//////////////////////////////////////////////////////
node {
    stage('Deploy Development') {
        unstash "builtSources"
        uploadArtifactory('PrecisionToolbox','*.mltbx')
    }
    if (env.BRANCH_NAME == 'main') {
        stage('Deploy Production') {
            unstash "builtSources"
            uploadFTP('PrecisionToolbox','*.mltbx')
        }
    }
    
}
