{pkgs, ...}: with pkgs; 
[
  kubernetes-helm
  k9s
  kind
  kubebuilder
  kubectl
  kubectl
  kubelogin
  kubelogin-oidc
  kustomize
  # openshift   Currently using a precompiled binary
  podman
]
