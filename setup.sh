#/usr/bin/bash

git submodule update --init

cd reveal.js
ln -sf ../index.html
ln -sf ../slides.md
