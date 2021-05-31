source "docker" "takelslim" {
  export_path = "images/docker/${var.target_repo}.tar"
  image = "${var.base_repo}:${var.base_tag}"
  run_command = [
    "--detach",
    "--interactive",
    "--tty",
    "--name",
    "${var.target_repo}",
    "{{ .Image }}",
    "/bin/bash"
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

  post-processor "docker-import" {
    keep_input_artifact = true
    changes = [
      "WORKDIR /root",
      "ENV DEBIAN_FRONTEND=noninteractive",
      "ENV LANG=C.UTF-8",
      "ENV SUPATH=$PATH",
      "ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
      "CMD [\"/bin/bash\"]"
    ]
    repository = "${var.target_user}/${var.target_repo}"
    tag = "${var.target_tag}"
  }
}
