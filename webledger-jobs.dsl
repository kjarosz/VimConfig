pipelineJob('WebLedgerBackend') {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            name('master')
            url('https://github.com/kjarosz/WebLedgerBackend.git')
            credentials("
          }
        }
      }
      scriptPath('jenkins.dsl')
    }
  }
}
