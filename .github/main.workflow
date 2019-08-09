workflow "PR Builder" {
  resolves = ["Build Android"]
  on = "pull_request"
}

action "Build Android" {
  uses = "docker://bitriseio/docker-android"
  runs = "./android/gradlew assembleDebug"
}
