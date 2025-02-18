![Java CI](https://github.com/crossecore/crossecore-generator/workflows/Java%20CI/badge.svg?branch=master)

# About
This is a fork of CrossEcore's [crossecore-generator](https://github.com/crossecore/crossecore-generator). It aims at generating a custom TypeScript implementation integrating with [eaSirius](https://github.com/andreasdomanowski/eaSirius/). Therefore, it generates a ```package.json``` project description that already includes all dependencies and scripts necessary for editor generation.

# Build from source
```bash
./gradlew customFatJar
```
You find the Jar here: `build/libs/crossecore-generator_20200201-0643.jar`

# Usage

```bash
java -jar crossecore-generator.jar -L typescript -e Model.ecore -p
./output/mypackage/
```

```
usage: crossecore
 -d <boolean>     boolean=0 skips generation of html documentation.
                  boolean=1 enables generation of html documentation.
                  Default is 1.
 -e <file>        source file (.ecore)
 -L <language>    target programming language. Valid values are
                  typescript, csharp, java, swift.
 -p <directory>   target path
```

# Tests

## Build Antlr Parsers and Lexers

Download 
* https://github.com/antlr/grammars-v4/blob/master/typescript/TypeScriptLexer.g4
* https://github.com/antlr/grammars-v4/blob/master/typescript/TypeScriptParser.g4
* https://github.com/antlr/grammars-v4/blob/master/typescript/Java/TypeScriptLexerBase.java
* https://github.com/antlr/grammars-v4/blob/master/typescript/Java/TypeScriptParserBase.java

Run the following command
```bash
java -jar antlr-4.8-complete.jar TypeScriptLexer.g4 -package antlr.typescript
```

