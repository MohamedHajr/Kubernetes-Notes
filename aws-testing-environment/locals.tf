locals {
  master_nodes = {
    ingress = [
      ### SSH Access
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      ### Kuberenetes API Server
      {
        from_port       = 6443
        to_port         = 6443
        protocol        = "tcp"
        security_groups = [aws_security_group.worker_nodes_sg.id]
        self            = true
      },
      ### ETCD Server Client API
      {
        from_port = 2379
        to_port   = 2380
        protocol  = "tcp"
        self      = true
      },
      ### Kubelet API
      {
        from_port = 10250
        to_port   = 10250
        protocol  = "tcp"
        self      = true
      },
      ### Kube Scheduler 
      {
        from_port = 10251
        to_port   = 10251
        protocol  = "tcp"
        self      = true
      },
      ### Kube Controler Manager
      {
        from_port = 10252
        to_port   = 10252
        protocol  = "tcp"
        self      = true
      },
    ]
  }

  worker_nodes = {
    ingress = [
      ### SSH Access
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      ### Kubelet API
      {
        from_port   = 10250
        to_port     = 10250
        protocol    = "tcp"
        self        = true
        cidr_blocks = ["0.0.0.0/0"]
      },
      ### NodePort Services
      {
        from_port   = 30000
        to_port     = 32767
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        self        = true
      },
    ]
  }
}
