## declare an array variable
declare -a infra=("sql-data" "nosql-data" "rabbitmq" "keystore-data" "basket-data")
declare -a charts=("eshop-common" "apigwmm" "apigwms" "apigwwm" "apigwws" "basket-api" "catalog-api" "identity-api" "locations-api" "marketing-api" "mobileshoppingagg" "ordering-api" "ordering-backgroundtasks" "ordering-signalrhub" "payment-api" "webmvc" "webshoppingagg" "webspa" "webstatus" "webhooks-api" "webhooks-web")
declare -a appname="eshop"
## now loop through the above array
for infra in "${infra[@]}"
do
   echo "deploying infra $infra"
helm install --values app.yaml --values inf.yaml --values ingress_values.yaml  --set app.name=$appname --set inf.k8s.dns="f3c8c3bacf8f4fcd966f.westeurope.aksapp.io" --name="$appname-$infra" ./$infra/    

   # or do whatever with individual element of the array
done

## now loop through the above array
for chart in "${charts[@]}"
do
   echo "deploying App $chart"
helm install --values app.yaml --values inf.yaml --values ingress_values.yaml  --set app.name=$appname --set inf.k8s.dns="f3c8c3bacf8f4fcd966f.westeurope.aksapp.io" --name="$appname-$chart" ./$chart/

   # or do whatever with individual element of the array
done
## applying config to allow large headers One step more is needed: we need to configure the nginx ingress controller that AKS has to allow more large headers. 
kubectl apply -f aks-httpaddon-cfg.yaml
## force a restart
kubectl delete po --selector="app=addon-http-application-routing-nginx-ingress" -n kube-system
kubectl delete po --selector="app=addon-http-application-routing-external-dns" -n kube-system
kubectl delete po --selector="app=addon-http-application-routing-default-http-backend" -n kube-system
 



