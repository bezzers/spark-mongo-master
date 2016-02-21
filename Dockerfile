FROM gettyimages/spark
MAINTAINER Paul Beswick

# Add necessary libraries for ipython and git
RUN apt-get update
RUN apt-get install -y python-dev python-pip python-numpy python-scipy python-pandas gfortran
RUN apt-get install -y git-all

# Download the mongo-hadoop connector library and build it
RUN git clone https://github.com/mongodb/mongo-hadoop.git
RUN cd /mongo-hadoop && ./gradlew jar

# Create a file to run as the entrypoint which passes a spark master argument to docker run through
RUN echo /usr/spark/bin/spark-class org.apache.spark.deploy.master.Master \
	--jars /mongo-hadoop/spark/build/libs/mongo-hadoop-spark-1.5.0-rc1-SNAPSHOT.jar \
	--driver-class-path /mongo-hadoop/spark/build/libs/mongo-hadoop-spark-1.5.0-rc1-SNAPSHOT.jar \
	 >> /run.sh

RUN chmod +x /run.sh

ENTRYPOINT ["/bin/bash","/run.sh"]
