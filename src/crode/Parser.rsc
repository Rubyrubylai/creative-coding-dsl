module crode::Parser

import ParseTree;
import IO;
import crode::Syntax;

/*
 * We already provided the parser for the crode language. The name of the function must be parseCrode.
 * This function receives as a parameter the path of the file to parse represented as a loc, and returns a parse tree
 * that represents the parsed program.
 */

start[Canvas] parseCrode(loc filePath) {
    return parse(#start[Canvas], filePath);
}
