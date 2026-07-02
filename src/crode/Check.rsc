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
    case \canvas(_, real width, real height, _, list[Statement] statements): {
      return width > 0.0
          && height > 0.0
          && checkStatements(statements, {}, {});
    }
  }
  return false;
}

bool checkStatements(list[Statement] statements, set[str] shapeNames, set[str] numberNames) {
  // assignment only support in block scope
  set[str] localShapeNames = {};
  set[str] localNumberNames = {};

  for (statement <- statements) {
    set[str] visibleShapeNames = shapeNames + localShapeNames;
    set[str] visibleNumberNames = numberNames + localNumberNames;

    switch (statement) {
      case \assignment(str name, \shapeValue(Shape shape)): {
        if (name in visibleShapeNames || name in visibleNumberNames) { // cannot assign variable with same name
          return false;
        }
        if (!checkShape(shape, visibleNumberNames)) {
          return false;
        }
        localShapeNames += {name};
      }
      case \assignment(str name, \numValue(NumExpr expr)): {
        if (name in visibleShapeNames || name in visibleNumberNames) { // cannot assign variable with same name
          return false;
        }
        if (!checkNumExpr(expr, visibleNumberNames)) {
          return false;
        }
        localNumberNames += {name};
      }
      case \draw(str name, Point point, NumExpr angle): {
        // can only draw shape
        // point x/y can only be numExpr
        // rotate angle can only be numExpr
        if (!(name in visibleShapeNames) 
            || !checkPoint(point, visibleNumberNames)
            || !checkNumExpr(angle, visibleNumberNames)) {
          return false;
        }
      }
      case \repeat(_, list[Statement] body): {
        if (!checkStatements(body, visibleShapeNames, visibleNumberNames)) {
          return false;
        }
      }
      case \forLoop(str var, real from, real to, real step, list[Statement] body): {
        if (var in visibleShapeNames || var in visibleNumberNames) {
          return false;
        }
        if (!checkForLoopRange(from, to, step)) {
          return false;
        }
        if (!checkStatements(body, visibleShapeNames, visibleNumberNames + {var})) {
          return false;
        }
      }
      case \ifThen(Cond cond, list[Statement] thenBranch): {
        if (!checkCond(cond, visibleNumberNames)
            || !checkStatements(thenBranch, visibleShapeNames, visibleNumberNames)) {
          return false;
        }
      }
      case \ifElse(Cond cond, list[Statement] thenBranch, list[Statement] elseBranch): {
        if (!checkCond(cond, visibleNumberNames)
            || !checkStatements(thenBranch, visibleShapeNames, visibleNumberNames)
            || !checkStatements(elseBranch, visibleShapeNames, visibleNumberNames)) {
          return false;
        }
      }
    }
  }
  return true;
}

// for loop range
bool checkForLoopRange(real from, real to, real step)
  = from < to && step > 0.0;

// shape parameter can only be numExpr
bool checkShape(Shape shape, set[str] numberNames) {
  switch (shape) {
    case \circle(NumExpr radius, _):
      return checkPositiveNumExpr(radius, numberNames);
    case \ellipse(NumExpr width, NumExpr height, _):
      return checkPositiveNumExpr(width, numberNames)
          && checkPositiveNumExpr(height, numberNames);
    case \arc(NumExpr width, NumExpr height, NumExpr startAngle, NumExpr stopAngle, _):
      return checkPositiveNumExpr(width, numberNames)
          && checkPositiveNumExpr(height, numberNames)
          && checkNumExpr(startAngle, numberNames)
          && checkNumExpr(stopAngle, numberNames);
    case \square(NumExpr size, _):
      return checkPositiveNumExpr(size, numberNames);
    case \rect(NumExpr width, NumExpr height, _):
      return checkPositiveNumExpr(width, numberNames)
          && checkPositiveNumExpr(height, numberNames);
    case \star(NumExpr size, _):
      return checkPositiveNumExpr(size, numberNames);
  }
  return false;
}

bool checkPoint(Point point, set[str] numberNames) {
  switch (point) {
    case \mkPoint(NumExpr x, NumExpr y):
      return checkNumExpr(x, numberNames) && checkNumExpr(y, numberNames);
  }
  return false;
}

// if condition can only compare numExpr
bool checkCond(Cond cond, set[str] numberNames) {
  switch (cond) {
    case \isEqual(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
    case \isGreater(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
    case \isLess(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
    case \isGreaterEqual(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
    case \isLessEqual(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
  }
  return false;
}

bool checkPositiveNumExpr(NumExpr expr, set[str] numberNames) {
  switch (expr) {
    case \number(real val):
      return val > 0.0;
    case \randExpr(real min, _):
      return min > 0.0;
  }
  return checkNumExpr(expr, numberNames);
}

bool checkNumExpr(NumExpr expr, set[str] numberNames) {
  switch (expr) {
    case \number(_):
      return true;
    case \randExpr(real min, real max):
      return min < max;
    case \idExpr(str name):
      return name in numberNames;
    // arithmetic can only be numExpr
    case \mul(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
    case \div(NumExpr left, NumExpr right):
      return !isZeroLiteral(right)
          && checkNumExpr(left, numberNames)
          && checkNumExpr(right, numberNames);
    case \mod(NumExpr left, NumExpr right):
      return !isZeroLiteral(right)
          && checkNumExpr(left, numberNames)
          && checkNumExpr(right, numberNames);
    case \add(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
    case \sub(NumExpr left, NumExpr right):
      return checkNumExpr(left, numberNames) && checkNumExpr(right, numberNames);
  }
  return false;
}

bool isZeroLiteral(NumExpr expr) {
  switch (expr) {
    case \number(0.0):
      return true;
  }
  return false;
}
