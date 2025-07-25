@Library('tfc-lib@adef-ci') _

flags = gitParseFlags()

dockerConfig = getDockerConfig(['MATLAB','Vivado','Internal'], matlabHSPro=false)
dockerConfig.add("-e MLRELEASE=R2023b")
dockerHost = 'docker'

////////////////////////////

hdlBranches = ['main','hdl_2021_r2']

stage("Build Toolbox") {
    dockerParallelBuild(hdlBranches, dockerHost, dockerConfig) { 
	branchName ->
	try {
		withEnv(['HDLBRANCH='+branchName,'LC_ALL=C.UTF-8','LANG=C.UTF-8']) {
		    checkout scm
		    sh 'git submodule update --init' 
		    sh 'make -C ./CI/scripts gen_tlbx'
		}
        } catch(Exception ex) {
		if (branchName == 'hdl_2021_r2') {
		    error('Production Toolbox Build Failed')
		}
		else {
		    unstable('Development Build Failed')
		}
        }
        if (branchName == 'hdl_2021_r2') {
            local_stash('builtSources')
            archiveArtifacts artifacts: 'hdl/*', followSymlinks: false, allowEmptyArchive: true
        }
    }
}

//////////////////////////////////////////////////////

node('baremetal || lab_b5') {
    cstage('Deploy Development', "", flags) {
        local_unstash("builtSources", '', false)
        uploadArtifactory('PrecisionToolbox','*.mltbx')
    }
}

