#!/usr/bin/env bash

# Clean Up
rm -rf mode/
rm -rf theme/

# Generate Modes
for m in $(find node_modules/codemirror/mode -mindepth 2 -maxdepth 2 -type f -name "*.js"| awk -F"node_modules/codemirror/mode/" '{print $2}')
  do
    mkdir -p "mode/$(basename $m .js)"
    echo "<script src=\"../../codemirror/mode/$m\"></script>" > "mode/${m/%.js/.html}"
  done

# TODO: Add support for mode styling
# for m in $(find node_modules/codemirror/mode -mindepth 2 -maxdepth 2 -type f -name "*.css"| awk -F"node_modules/codemirror/mode/" '{print $2}')
#   do
#     mkdir -p "mode/$(basename $m .js)"
#     echo "<script src=\"../../codemirror/mode/$m\"></script>" > "mode/${m/%.js/.html}"
#   done

mkdir -p theme
for t in $(ls node_modules/codemirror/theme)
  do
    echo "<dom-module id=\"${t/%.css/}\"><template><style>" > "theme/${t/%.css/.html}"
    cat "node_modules/codemirror/theme/$t" >> "theme/${t/%.css/.html}"
    echo "</style></template></dom-module>" >> "theme/${t/%.css/.html}"
  done
