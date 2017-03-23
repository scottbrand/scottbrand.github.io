#!/bin/bash


THISDIR=$(pwd)

cd $(dirname $0)

CLI=$(pwd)/org.osgi.impl.bundle.repoindex.cli-3.3.0.jar

echo Starting to build indexes on repositories now in directory: $(pwd)


if [ "$JAVA" == "" ] ; then
	JAVA=$(which java)
fi
if [ "$JAVA" == "" ] ; then
	echo "No java found, exiting with -1"
	exit -1
fi

echo "Executing with java: " $(java -version)


cygwin=false
case "$(uname)" in
  CYGWIN*) cygwin=true ;;
esac

if [ "$1" == "" ] ; then
	echo need to provide the name of the repository you want to index as a command line parameter.
	echo For example:  buildIndex.sh  gpd
	exit -1
fi

for i in $(find ./* -type d -prune)
do
	if [ "$i" != "./$1" ] ; then
		test		
#echo skipping $i since it was not asked to be indexed.  Index directory is: $1 
	else
		cd $i
		echo Build Index in Directory: $i
		if $cygwin; then
	    		"$JAVA" -jar $(cygpath -wp $CLI) -n "$i" *.jar
		else
	    		"$JAVA" -jar $CLI -n "$i" *.jar
		fi
		cd ..
	fi
done
echo Finished building indexes on repositories in directory $(pwd)
cd $THISDIR
