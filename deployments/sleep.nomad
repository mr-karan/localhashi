job "test" {
  datacenters = ["localhashi"]

  type = "service"

  group "app" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"

      delay = "15s"

      mode = "fail"
    }

    task "redis" {
      driver = "docker"

      config {
        image   = "registry.service.consul:32000/ubuntu:latest"
        command = "sleep"
        args = [
          "infinity"
        ]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
