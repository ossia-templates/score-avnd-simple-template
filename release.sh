#!/bin/bash
rm -rf release
mkdir -p release

cp -rf MyAvndEffect *.{hpp,cpp,txt,json} LICENSE release/

mv release score-addon-my-avnd-effect
7z a score-addon-my-avnd-effect.zip score-addon-my-avnd-effect
