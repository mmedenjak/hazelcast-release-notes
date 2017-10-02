#!/bin/bash

function buildDocumentation {
    init $1
    cleanIfExists
    createHTML
    delete
    echo "Done"
}

function init {
	VERSION=$1
	OUTPUT_DIR="target"
	HTML_SOURCE_DIR="daux/docs"
	HTML_OUTPUT_DIR="daux/static"
	MANIFEST_FILE_NAME="manifest.json"
	MERGED_FILE_NAME="index.md"
	COPYRIGHT_FILE_NAME="copyright.txt"
	DATE=`date +%b\ %d\,\ %Y`
	YEAR=`date +%Y`
}

function cleanIfExists {
	if [ -e "./$OUTPUT_DIR" ]; then
		echo "Cleaning $OUTPUT_DIR"
		$(rm -rf "./$OUTPUT_DIR")
	fi
}

function writeManifestFile {
    if [[ -e "./$MANIFEST_FILE_NAME" ]]; then
        $(rm -rf "./$MANIFEST_FILE_NAME")
    fi

    writeManifest=$( echo $1 >> ${MANIFEST_FILE_NAME})
    if [[ $? -eq 0 ]]; then
        echo "Manifest file succesfully written."
    else
        echo "Error writing manifest file"
        echo ${writeManifest}
        delete
        exit -1
    fi
}


function createHTML {
    MANIFEST_FILE_BODY="{\"title\": \"Documentation\",
\"rootDir\": \".\",
\"date\": \"${DATE}\",
\"version\": \"${VERSION}\",
\"maxTocLevel\":1,
\"files\":[\"./$MERGED_FILE_NAME\"]}"

    writeManifestFile "${MANIFEST_FILE_BODY}"

    echo "Creating release notes HTML"
    createHtml=$(daux )
    if [[ $? -eq 0 ]]; then
        echo "Release Notes created succesfully "
    else
        echo "Error creating Release Notes"
        delete
        exit -1
    fi
}


function delete {
    echo "Deleting created files"
    $(rm -rf "./$COPYRIGHT_FILE_NAME")
    $(rm -rf "./$MERGED_FILE_NAME")
    $(rm -rf "./$MANIFEST_FILE_NAME")
    $(rm -rf "./title.txt")
    $(rm -rf "./src/images")
}

buildDocumentation $1
