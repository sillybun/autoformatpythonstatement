#!/usr/bin/env bash

if [ "$1" = "--reverse" ]
then
    cd ftpplugin/python
    rm -rf build
    # rm -f ../python/*.so
    echo "C extension uninstalled sucessfully!"
    exit 0
fi

cd ftplugin/python

echo "Begin to compile C extension of Python3 ..."
python3 setup.py build
if [ $? -eq 0 ]
then
    cp build/lib*3.?/afpython*.so afpython.so
    if [ $? -eq 0 ]
    then
        echo
        echo C extension of Python3 installed sucessfully!
    fi
fi
