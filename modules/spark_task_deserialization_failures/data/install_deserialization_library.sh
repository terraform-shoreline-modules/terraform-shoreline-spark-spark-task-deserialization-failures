

#!/bin/bash



# Set variables

SPARK_VERSION=${SPARK_VERSION}

DESERIALIZATION_LIBRARY=${NEW_DESERIALIZATION_LIBRARY}



# Stop Spark services

sudo systemctl stop spark-master.service

sudo systemctl stop spark-worker.service



# Install new deserialization library

sudo apt-get update

sudo apt-get install $DESERIALIZATION_LIBRARY



# Update Spark configuration with new deserialization library

sudo sed -i "s#spark.serializer=.*#spark.serializer=org.apache.spark.serializer.KryoSerializer#g" /opt/spark/conf/spark-defaults.conf

sudo sed -i "s#spark.kryo.registrator=.*#spark.kryo.registrator=com.example.MyKryoRegistrator#g" /opt/spark/conf/spark-defaults.conf



# Start Spark services

sudo systemctl start spark-worker.service

sudo systemctl start spark-master.service