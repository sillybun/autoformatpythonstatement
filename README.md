# autoformat-python

## Introduction

This is a plugin aimed to autoformat python statement. When you finish type a line and type \<Cr\> to start a new line, the previous line will be formatted automatically.

It also boost the start new line time for large python file. No delay at all.

## Details

if you write python file like that:

```
a =1+2<cursor>
```
that looks ulgy, right? Don't worry. With the help of this plugin, you simply press return button in `insert mode` or `normal mode`, then the code will be formated automatically by autopep8 into this:

```
a = 1 + 2
<cursor>
```

## Installation

Use your plugin manager of choice.

- [Vundle](https://github.com/gmarik/vundle)
  - Add `Bundle 'https://github.com/sillybun/autoformatpythonstatement'` to .vimrc
  - Run `:BundleInstall`
  - And change to the plugin directory and run in shell `./install.sh`

- [vim-plug](https://github.com/junegunn/vim-plug)
  - Add `Plug 'https://github.com/sillybun/autoformatpythonstatement', {'do': './install.sh'}` to .vimrc
  - Run `:PlugInstall`

> Warning: for macos m1 users, if you use arm64 vim (chech it via `:version`), please make sure that you run `install.sh` using arm64 python (e.g. downloaded from arm homebrew)

For m1 user, `install.sh` will call `/opt/homebrew/bin/python3.9 setup.py build` to build core library.

## Usage

Everytime you type enter, the previous line will be formatted automatically.

`:ChangeFormatCurrentLineMode`: this command is to switch the plugin on/off state.

## Configuration

```
let g:autoformatpython_break_long_lines = 0
```

If this value is set to 1, long lines will be broken into several shorter lines automatically.
