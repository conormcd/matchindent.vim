# Match Indentation Style

Some people like tabs, some like spaces. Very few people like it when you edit
their stuff and use a different method of indentation.

This plugin scans through a file when it's opened and attempts to guess which
style of indentation is being used. It then overrides your preferences so that
you match the style of the file.

Currently it only detects the three most common styles of indentation, tabs, 2
spaces and 4 spaces. Patches to make this plugin more general are welcomed.

## Installation

### Using Pathogen

    cd ~/.vim
	git clone git://github.com/conormcd/matchindent.vim bundle/matchindent.vim

### Manual Install

    git clone git://github.com/conormcd/matchindent.vim
	cp -R matchindent.vim/plugin/* ~/.vim/plugin/
