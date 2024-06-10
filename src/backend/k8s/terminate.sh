kubectl delete namespace asky

kubectl delete all --all -n default

helm uninstall filebeat  -n default
helm uninstall logstash  -n default
helm uninstall elasticsearch  -n default
helm uninstall kibana  -n default

kubectl delete pv postgres-pv-volume    