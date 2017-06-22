#!/usr/bin/env bash

# Clean Up
rm -rf mode/
rm -rf theme/

# Generate standalone Script Import
codemirrorScriptPath="codemirror-standalone.html"
echo "<script src=\"../codemirror/lib/codemirror.js\"></script>" > $codemirrorScriptPath

# Generate standalone Style Module
codemirrorStyleModulePath="codemirror-style.html"
echo "<dom-module id=\"codemirror\"><template><style>" > $codemirrorStyleModulePath
cat "node_modules/codemirror/lib/codemirror.css" >> $codemirrorStyleModulePath
echo "</style></template></dom-module>" >> $codemirrorStyleModulePath

# Generate Base Style Module and Script Import
cat $codemirrorScriptPath $codemirrorStyleModulePath > "codemirror.html"


# Generate Modes
for m in $(find node_modules/codemirror/mode -mindepth 2 -maxdepth 2 -type f -name "*.js"| awk -F"node_modules/codemirror/mode/" '{print $2}')
  do
    filename=$(basename $m .js)

    mkdir -p "mode/$filename"
    echo "<script src=\"../../../codemirror/mode/$m\"></script>" > "mode/$filename/$filename.html"
  done

# Generate Mode Style Modules
for m in $(find node_modules/codemirror/mode -mindepth 2 -maxdepth 2 -type f -name "*.css"| awk -F"node_modules/codemirror/mode/" '{print $2}')
  do
    filename=$(basename $m .css)
    outputPath="mode/$filename/$filename-style.html"

    echo "<dom-module id=\"$filename\"><template><style>" > $outputPath
    cat "node_modules/codemirror/mode/$m" >> $outputPath
    echo "</style></template></dom-module>" >> $outputPath
  done

# Generate Theme Style Modules
mkdir -p theme
for t in $(ls node_modules/codemirror/theme)
  do
    filename=$(basename $t .css)
    outputPath="theme/$filename.html"

    echo "<dom-module id=\"$filename\"><template><style>" > $outputPath
    cat "node_modules/codemirror/theme/$t" >> $outputPath
    echo "</style></template></dom-module>" >> $outputPath
  done
