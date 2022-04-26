// This is a sample file for using `nomctx` with the cluster spawned in VMs.

clusters "single" {
  address   = "http://127.0.0.1:4646"
  namespace = "default"
}

clusters "multi" {
  address   = "http://10.100.0.11:4646"
  namespace = "default"
  // token     = "c0a7d714-46df-4c6e-954a-269578c3804d"
}
 