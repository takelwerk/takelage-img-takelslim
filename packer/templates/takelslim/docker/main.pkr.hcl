source "docker" "takelslim" {
  # export_path = "images/docker/${var.target_repo}.tar"
  image = "${var.base_repo}:${var.base_tag}"
  commit = true
  pull = false
  run_command = [
    "--detach",
    "--interactive",
    "--tty",
    "--name",
    "${var.target_repo}",
    "${var.base_user}:${var.base_tag}",
    "/bin/bash"
  ]
  changes = [
    "WORKDIR /root",
    "ENV DEBIAN_FRONTEND=noninteractive",
    "ENV LANG=C.UTF-8",
    "ENV SUPATH=$PATH",
    "ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    "CMD [\"/bin/bash\"]"
  ]
}

build {
  sources = [
    "source.docker.takelslim"
  ]

  provisioner "shell" {
    inline = [
      "apt-get -y update",
      "apt-get -y dist-upgrade",
      "apt-get install -y --no-install-recommends python3-minimal python3-apt",
      "apt-get clean"
    ]
  }

  post-processor "docker-tag" {
    repository = "${var.local_user}/${var.target_repo}"
    tags = ["${var.target_tag}"]
  }
}
