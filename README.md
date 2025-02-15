# key-docs

*Author: Alexander Weigl <weigl@kit.edu>*

## Getting Started to Write

An overview about some markdown (extension) is avaiable in `docs/howtodoc.md` or 
http://key-project.org/docs/howtodoc/

Webpages are determined by folder structure under `docs/`. Just create or change
files within this folder. The top-level header is the title of this page in the
menu (fallback the filename).

**Pushes to master branch, triggers rebuilding and publishing.**


## Getting Started to Build (locally)

Install the necessary libraries locally: 

```
$ pip install --user  mkdocs  mkdocs-material  pymdown-extensions \
                      pygments markdown-blockdiag markdown-aafigure==v201904.0004
```

You can start development web-server, which automatically rerender and refresh
on changes, with

```
$ mkdocs serve
```

HTML is build with 

```
$ mkdocs build
```

into `site/`

