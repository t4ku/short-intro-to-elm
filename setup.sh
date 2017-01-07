#/usr/bin/bash

git submodule update --init

cd reveal.js

npm install

ln -sf ../index.html
ln -sf ../slides.md
