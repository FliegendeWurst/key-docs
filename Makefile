prepare:
	pip install --user  mkdocs  mkdocs-material  pymdown-extensions pygments markdown-blockdiag mkdocs-bibtex markdown-aafigure==v201904.0004 mkdocs-build-plantuml-plugin

serve:
	mkdocs serve

build:
	mkdocs build
