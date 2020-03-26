job("WebLedgerBackend") {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            name("master")
            url("https://github.com/kjarosz/WebLedgerBackend.git")
            credentials("github-credentials")
          }
        }
      }
      scriptPath("jenkins.dsl")
    }
  }
}
