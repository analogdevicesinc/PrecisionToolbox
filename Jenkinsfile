@Library('tfc-lib') _

dockerConfig = getDockerConfig(['MATLAB','Vivado'], matlabHSPro=false)
dockerConfig.add("-e MLRELEASE=R2021b")
dockerHost = 'docker'

////////////////////////////

hdlBranches = ['master']

stage("Build Toolbox") {
    dockerParallelBuild(hdlBranches, dockerHost, dockerConfig) { 
	branchName ->
	withEnv(['HDLBRANCH='+branchName]) {
	    checkout scm
	    sh 'git submodule update --init' 
	    sh 'make -C ./CI/scripts gen_tlbx'
	}
        stash includes: '**', name: 'builtSources', useDefaultExcludes: false
        archiveArtifacts artifacts: '*.mltbx', followSymlinks: false, allowEmptyArchive: true
    }
}

/////////////////////////////////////////////////////

classNames = ['ADC']

stage("Hardware Streaming Tests") {
    dockerParallelBuild(classNames, dockerHost, dockerConfig) { 
        branchName ->
        withEnv(['HW='+branchName]) {
            unstash "builtSources"
            sh 'make -C ./CI/scripts test_streaming'
        }
    }
}

//////////////////////////////////////////////////////

node {
    stage('Deploy Development') {
        unstash "builtSources"
        uploadArtifactory('PrecisionToolbox','*.mltbx')
    }
    if (env.BRANCH_NAME == 'master') {
        stage('Deploy Production') {
            unstash "builtSources"
//             uploadFTP('PrecisionToolbox','*.mltbx')
        }
    }
}
