module crode::Check

import crode::AST;
import crode::Parser;
import crode::CST2AST;

import IO;
import List;
import Set;
import Prelude;
import String;

import util::Maybe;


/*
 * Implement a well-formedness checker for the crode language. For this you must use the AST.
 * - Hint: Map regular CST arguments (e.g., *, +, ?) to lists
 * - Hint: Map lexical nodes to Rascal primitive types (bool, int, str)
 * - Hint: Use switch to do case distinction with concrete patterns
 */

bool checkCanvasConfiguration(Canvas canvas){
  return true;
}
