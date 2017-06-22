#!/usr/bin/env bash

# Clean Up
rm -rf mode/
rm -rf theme/

# Generate standalone Script Import
echo "<script src=\"../codemirror/lib/codemirror.js\"></script>" > "codemirror-standalone.html"

# Generate Base Style Module and Script Import
echo "<script src=\"../codemirror/lib/codemirror.js\"></script>" > "codemirror.html"
echo "<dom-module id=\"codemirror\"><template><style>" >> "codemirror.html"
cat "node_modules/codemirror/lib/codemirror.css" >> "codemirror.html"
echo "</style></template></dom-module>" >> "codemirror.html"

# Generate Modes
for m in $(find node_modules/codemirror/mode -mindepth 2 -maxdepth 2 -type f -name "*.js"| awk -F"node_modules/codemirror/mode/" '{print $2}')
  do
    mkdir -p "mode/$(basename $m .js)"
    echo "<script src=\"../../codemirror/mode/$m\"></script>" > "mode/${m/%.js/.html}"
  done

# Generate Mode Style Modules
for m in $(find node_modules/codemirror/mode -mindepth 2 -maxdepth 2 -type f -name "*.css"| awk -F"node_modules/codemirror/mode/" '{print $2}')
  do
    echo "<dom-module id=\"$(basename $m .css)\"><template><style>" > "mode/${m/%.css/-style.html}"
    cat "node_modules/codemirror/mode/$m" >> "mode/${m/%.css/-style.html}"
    echo "</style></template></dom-module>" >> "mode/${m/%.css/-style.html}"
  done

# Generate Theme Style Modules
mkdir -p theme
for t in $(ls node_modules/codemirror/theme)
  do
    echo "<dom-module id=\"${t/%.css/}\"><template><style>" > "theme/${t/%.css/.html}"
    cat "node_modules/codemirror/theme/$t" >> "theme/${t/%.css/.html}"
    echo "</style></template></dom-module>" >> "theme/${t/%.css/.html}"
  done
