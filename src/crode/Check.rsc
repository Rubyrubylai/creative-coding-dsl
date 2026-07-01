module crode::Check

import crode::AST;


/*
 * Implement a well-formedness checker for the crode language. For this you must use the AST.
 * - Hint: Map regular CST arguments (e.g., *, +, ?) to lists
 * - Hint: Map lexical nodes to Rascal primitive types (bool, int, str)
 * - Hint: Use switch to do case distinction with concrete patterns
 */

bool checkCanvasConfiguration(Canvas canvas){
  switch (canvas) {
    case \canvas(_, _, _, _, list[Statement] statements): {
      return checkStatements(statements, {});
    }
  }
  return false;
}

bool checkStatements(list[Statement] statements, set[str] shapeNames) {
  set[str] localShapeNames = {};

  for (statement <- statements) {
    set[str] visibleShapeNames = shapeNames + localShapeNames;

    switch (statement) {
      case \assignment(str name, \shapeValue(_)): {
        localShapeNames += {name};
      }
      case \draw(str name, _, _): {
        if (!(name in visibleShapeNames)) {
          return false;
        }
      }
      case \repeat(_, list[Statement] body): {
        if (!checkStatements(body, visibleShapeNames)) {
          return false;
        }
      }
      case \forLoop(_, _, _, _, list[Statement] body): {
        if (!checkStatements(body, visibleShapeNames)) {
          return false;
        }
      }
      case \ifThen(_, list[Statement] thenBranch): {
        if (!checkStatements(thenBranch, visibleShapeNames)) {
          return false;
        }
      }
      case \ifElse(_, list[Statement] thenBranch, list[Statement] elseBranch): {
        if (!checkStatements(thenBranch, visibleShapeNames)
            || !checkStatements(elseBranch, visibleShapeNames)) {
          return false;
        }
      }
    }
  }
  return true;
}
