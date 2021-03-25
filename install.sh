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
arch_name="$(uname -m)"

if [ "${arch_name}" = "x86_64" ]; then
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Running on Rosetta 2"
        python3 setup.py build
    else
        echo "Running on native Intel"
        python3 setup.py build
    fi
elif [ "${arch_name}" = "arm64" ]; then
    echo "Running on ARM"
    /opt/homebrew/bin/python3.9 setup.py build
else
    echo "Unknown architecture: ${arch_name}"
fi

if [ $? -eq 0 ]
then
    cp build/lib*3.?/afpython*.so afpython.so
    if [ $? -eq 0 ]
    then
        echo
        echo C extension of Python3 installed sucessfully!
    fi
fi
