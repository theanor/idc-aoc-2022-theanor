ARG IMAGE=containers.intersystems.com/intersystems/iris-community:2022.3.0.555.0
FROM $IMAGE

        
WORKDIR /opt/irisapp
ARG TESTS=0
ARG MODULE="dc-sample-template"
ARG NAMESPACE="IRISAPP"

#COPY  Installer.cls .
RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly
