# Lex-Scanner
A lexical analyzer for given lex specifications/language using Lex generator.

## Installation
**Note:** Make sure you are working in a Linux environment.
You need to install Lex and Yacc. Follow the instruction in [this link](https://jaisantonyk.wordpress.com/2008/03/16/lex-and-yaccbison-in-windows/) for detailed steps to do that.

## Usage

1- Once lex is up and running on your machine, write a lex file with the language specification given [here](https://github.com/abuaesh/Lex-Scanner/blob/master/README.md#specifications-for-the-supported-language). The result is a lex file with the extension _.l_.

2. Compile your lex file in the lex compiler using the command: `flex scanner.l` The result of this command is a C file generated by Lex named _lex.yy.c_ and saved in your root directory.

3. Compile _lex.yy.c_ using a C compiler and save the generated executable as a file, by writing: 
`g++ lex.yy.c –lfl –o output`
By that, the file _output.exe_ is created in the root directory.

4. After that, run the generated executable by typing in the command below and specifying the input file to be tokenized:
`.\output.exe in.txt` we can get the final results as a series of tokens and a list of syntax errors. 

### Specifications for the Supported Language

#### Lex Conventions
The supported language is depicted from Appendix A from the Kenneth Louden's book: Compiler Construction: Principles and Practice, Course Technology, with replacing the definition of ID and NUM as follows:
      ID = letter (letter | digit )* (“.”|@ | “_” | ) (letter | digit )+
      NUM = digit + | digit+ “.” digit +(((E |e) (+|- | ) digit +)|
Also, the characters in the keywords and identifiers can appear as capital or small letters
(i.e. no distinction between capital and small. A is like a and if is like IF and If).

#### Error Handling
The following errors are handled:
1. Reaching the end of file while a comment is not closed.
2. Finding a character which is not in the alphabet of the language.
3. Exiting from the scanning of a token while not reaching the final state. For example, while recognizing an identifier, you find “*” after “-“ ( aaa_*) , or while recognizing a number you find a letter after “e” (2.3eX).
4. Do not handle the problem of having a number followed by an identifier without leavening spaces and similar problems. This will be handled by the parser. For example your scanner will produce as an output num id for the string “12ab” because this string, “12 ab”, is still erroneous even if you leave spaces.
Error messages indicate the line number and character position where the error occurs.

## Known Issues

The expected results as mentioned before are the tokens and lexemes that should appear in the input file _in.txt_, 
in addition to a list of any violations to the syntax rules specified by the lex file we wrote.
The current code generates warnings of unrecognized rules when the file is compiled using lex, and, errors of undefined variables when _lex.yy.c_ is compiled by the C compiler.

## Contribution
You can help contribute to this project by fixing the errors mentioned in the [Known Issues section.](https://github.com/abuaesh/Lex-Scanner/tree/master#known-issues)

## More Information

You can find more information in the description file in the repository.
