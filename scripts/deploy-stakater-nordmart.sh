#!/bin/bash
REPLICAS=1
read -p "Enter Number of replicas: " REPLICAS
ITERATION=0
until [ $ITERATION -ge $REPLICAS ]
do
   git clone https://github.com/stakater/StakaterNordmart.git stakater-nordmart-$ITERATION
   chmod 755 stakater-nordmart-$ITERATION/scripts/deploy.sh
   sed -i '/read -p/d' stakater-nordmart-$ITERATION/scripts/deploy.sh
   cd stakater-nordmart-$ITERATION/
   make -f Makefile deploy NAMESPACE_NAME=nordmart-$ITERATION
   echo "Creating nordmart in stakater-nordmart-$ITERATION"
   ITERATION=$[$ITERATION+1]
   cd ..
done