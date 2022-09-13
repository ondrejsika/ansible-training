setup-cluster:
  slu scripts kubernetes install-ingress --use-proxy-protocol
  slu scripts kubernetes install-cert-manager
  slu scripts kubernetes install-cluster-issuer
  slu wait-for tcp -a k8s.sikademo.com:443

install-operator:
	kustomize build . | kubectl apply -f -

install-awx:
	kubectl apply -f awx.yml

get-password:
	slu awx password
