job "registry" {
  datacenters = ["localhashi"]

  group "registry" {
    count = 1
    network {
      mode = "host"
      port "http" {
        static       = 32000
        to           = 5000
        host_network = "private"
      }
    }

    service {
      name = "registry"
      port = "http"
    }

    task "registry" {
      driver = "docker"
      config {
        image = "registry:2"
        ports = ["http"]
      }

      resources {
        cpu    = 256
        memory = 128
      }
    }
  }
}