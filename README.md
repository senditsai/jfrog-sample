# How to upload jar using curl to JFrog Artifactory?

## Prepare 
* A csv file. The format: `jarfile`,`groupId`,`artifactId`,`version`
* Project libraries location

## How to use
* <pre>./autoGenDependency.sh test.csv lib/path</pre>

## Output result
* All dependency declarations in `pom.xml`, You can copy and paste into your project root pom.xml
* The generated jar POM file also upload together

## Reference
* https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-GenerateMavenPOMFile
