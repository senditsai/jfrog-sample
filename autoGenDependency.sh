# JFog Artifactory autoGenDependecy script

filename=$1
filepath=$2
resultfile="pom.xml"
token="your JFrog token"
replace="."
replacewith="/"
echo "---------------------------------------------"
echo "pom dependency config producing,source filename: $1, filepath: $2, resultfile: $resultfile" 
echo "---------------------------------------------"
for n in $(grep -v "^#" $filename)
do
    jar=$(echo $n|cut -f1 -d ",")
    groupId=$(echo $n|cut -f2 -d ",")
    artifactId=$(echo $n|cut -f3 -d ",")
    version=$(echo $n|cut -f4 -d ","|tr -d '\r')

    # Generate jar POM file
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><project xmlns=\"http://maven.apache.org/POM/4.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd\">" >> $artifactId-$version.pom
    echo "  <modelVersion>4.0.0</modelVersion>" >> $artifactId-$version.pom
    echo "  <groupId>${groupId}</groupId>" >> $artifactId-$version.pom
    echo "  <artifactId>${artifactId}</artifactId>" >> $artifactId-$version.pom
    echo "  <version>${version}</version>" >> $artifactId-$version.pom
    echo "  <description>Artifactory auto generated POM</description>" >> $artifactId-$version.pom
    echo "</project>" >> $artifactId-$version.pom
    echo "---------------------------------------------"
    echo "Generate jar POM file done."
    echo "---------------------------------------------"

    echo $jar
    echo "<dependency>" >> $resultfile
    echo "    <groupId>${groupId}</groupId>" >> $resultfile
    echo "    <artifactId>${artifactId}</artifactId>" >> $resultfile
    echo "    <version>${version}</version>" >> $resultfile
    echo "</dependency>" >> $resultfile

    groupIdTmp="${groupId//${replace}/${replacewith}}"
    # Change your JFrog Artifactory URL
    curl -k -u admin:$token -X PUT https://jfrog.artifactory.com/artifactory/repo/$groupIdTmp/$artifactId/$version/ -T $filepath/$jar
    echo "---------------------------------------------"
    echo "Maven jar file upload successfully."
    echo "---------------------------------------------"
    curl -k -u admin:$token -X PUT https://jfrog.artifactory.com/artifactory/repo/$groupIdTmp/$artifactId/$version/ -T $artifactId-$version.pom
    echo "---------------------------------------------"
    echo "Generate jar POM file upload successfully."
    echo "---------------------------------------------"
    rm -rf $artifactId-$version.pom 
done
rm -rf output.txt
echo "Clean log and generate pom file."
echo "-------------------end-----------------------"
