
## declare an array variable
declare -a infra=("sql-data" "nosql-data" "rabbitmq" "keystore-data" "basket-data")
declare -a charts=("eshop-common" "apigwmm" "apigwms" "apigwwm" "apigwws" "basket-api" "catalog-api" "identity-api" "locations-api" "marketing-api" "mobileshoppingagg" "ordering-api" "ordering-backgroundtasks" "ordering-signalrhub" "payment-api" "webmvc" "webshoppingagg" "webspa" "webstatus" "webhooks-api" "webhooks-web")
declare appname="eshop"
## now loop through the above array
for infra in "${infra[@]}"
do
   echo "removing infra $infra"
   helm del --purge $appname-$infra

   # or do whatever with individual element of the array
done

## now loop through the above array
for chart in "${charts[@]}"
do
   echo "deploying App $chart"
    helm del --purge  $appname-$chart
   # or do whatever with individual element of the array
done



helm del --purge
