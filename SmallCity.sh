#!/usr/bin/bash
SCRIPTPATH=`dirname $SCRIPT`
if [ -e `which Urho3DPlayer` ]; then
	Urho3DPlayer Data/LuaScripts/SmallCity.lua -w -pp $SCRIPTPATH
else
	echo "Please add Urho3DPlayer to your path"
	echo "https://github.com/urho3d/urho3d"
fi
