{pkgs, ...}: with pkgs; 
[
  cargo
  cmake
  go
  k9s
  kind
  kubebuilder
  kubectl
  kubectl
  kubelogin
  kubelogin-oidc
  kustomize
  mage
  nodejs
  # openshift   Currently using a precompiled binary
  podman
  tree-sitter
  yq
  vagrant
]
