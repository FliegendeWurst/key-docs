# Using the classpath directives in KeY

The `classpath` directive allows to include library code into a KeY
project. These classes may be present either as

- a collection of class files
- a collection of normal java source files
- a collection of java stub source files 

or in a combination.

Library classes may carry specifications (invariants, contracts) but do not
contain a model of any contained code.

#### Changes

* Mar 6, 19, **Wolfram Pfeifer**, corrected wrong example, updated list of
  internal classes
* Sep 4, 09, ** mulbrich**, dropping `\noDefaultClasses`, adding
  `\bootclasspath`

# Syntax

The `\classpath` directive may be placed directly in front of the
`\javaSource` directive or instead of it. There may be an arbitrary
number of `\classpath` annotations, but at most one `\bootclasspath`.

The `\bootclasspath` directive is optional. If it appears, however, it has to be
placed directly in front of all \classpath directives.

`\classpath` must be followed by a string describing either a directory or a zip
file. Any jar file is a zip file. The path may either be absolute or is
considered relative to the location of the containing `.key` file.

`\bootclasspath` must be followed by a string denoting a directory. ZIPs
are not supported here at the moment.

Example: A .key-file might begin with

```
\bootclasspath "../systemDir/";
\classpath "/tmp/classes.jar";
\classpath "../classDir/";
\classpath "someLibrary.jar";
\javaSource "../sources";
[..]
```

## Meaning

In KeY there are three kinds of resources read in when loading sources.

### Boot Classes / System Classes / Default Classes

If there is no `\bootclasspath` specified, the classes listed in appendix A.
will be loaded from an interal storage. This class set is closed, i.e. there are
no references to class types outside the set. These classes lack therefore any
method or field whose declaration (w/o method body!) would require knowledge
about an external class.

The method `java.lang.Class Object.getClass()` is not included in class Object
for instance since java.lang.Class is not in the set.

If you miss fields or methods, you need to construct your own base set.

These classes are read in verbatim: All contracts and all method bodies are
taken into consideration and are available during the verification.


## Library giben as Java sources

After loading the default classes, all classpath locations are iterated to
recursivly read in all files ending in `.java` from within the directories and
zip files. All java sources are reduced to stubs, i.e. any method body is
discarded as if it was not given.

Contract specification given in the source code (outside a method body!) are
considered, however!

## Class Files

Thereafter, the locations are iterated once again to retrieve all contained
files with the file name extension ".class". The class files are used to
construct java stubs containing the information stored in the class files.

Inner classes are mapped as expected. Since there are no method bodies,
anonymous classes cannot be included the usual way. Instead a normal class with
an arbitrary name is created.

## Combining (TODO)

It is possible to use both file types: Class files and java stubs. Since KeY
does not YET support external .jml files, however, there may only be either
a class file or a source specification for one class. This should change later.

You can use the "stubmaker" tool available in the key-tools repository to create
a set of skeleton java source files for your libraries and which can be fed to
KeY. They can then be amended with specifications.

### Open sets

It is rather difficult to include all classes that are referenced from the stub
into a collection of classes to create a set of stubs closed under reference.
You would need to capture more than 120 classes to build a such closure around
java.lang.Object. In order to cope with this problem, the following applies:

- All classes in the classpath are used as given.

- For all classes that are referenced in the classpath but are not
  defined anywhere in it, an empty stub is assumed. For a reference to
  `pack.Class` the stub would be: `package pack class Class { }`.

- All references the javaSources must refer to a classpath class or to
  an empty stub created while reading the classpath. There must not be
  unresolved references.

- Please note that the classpath classes cannot access the javaSource
  classes.

- And keep in mind that this mechanism does not apply to the default
  class set.

## No Default Classes

If you want to replace the default classes, put them into a directory
of your choice and specify `\bootclasspath "dir";`
on top of your classpath declarations in the `.key` file. However, you
have to make sure that all classes in A that are *not* marked with a
(*) are defined and have all needed methods and fields. You might want
to look into the key sources[1] to compare the current implementation
of the default classes.

If you forget to include classes, it may to lead to unexpected and 
mysterious errors at runtime of KeY.

[1] `key.core/resources/de/uka/ilkd/key/java/JavaRedux`

## Known issues

- Recoder does not recognise static inner classes. 
  (A patch is on the way)
- Private inner classes are difficult to map.
- If sources in class paths contain JML //@set statements, deletion of
  method bodies may lead to NullPointerException.


## Troubleshooting

What does the error message "Type references to undefined classes may
only appear if they are fully qualified" mean?

As described in Section *Open sets*, stubs are created for all classes that are
referenced in the classpath but are not defined anywhere in it. A problem arises
if the referenced class name is not fully qualified and there are import
statements in the source file where the reference appears. In this case, the
correct location for the stub cannot be determined, which leads to the error
message. A possible solution is to import byte code instead of source code,
since the former always contains fully qualified names.


## List of internally stored classes:

See `key.core/resources/de/uka/ilkd/key/java/JavaRedux/JAVALANG.TXT`
for a comprehensive and uptodate list of the classes currently comprised
in the bootclasspath in KeY.

If you intend to override the bootclasspath, not all classes of these classes
are required in your bootclasspath. However, ommiting essential classes may
result in strange exceptions at runtime.
