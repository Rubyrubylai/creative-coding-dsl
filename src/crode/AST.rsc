module crode::AST

/*
 * Define the Abstract Syntax for crode
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data Canvas(loc src=|unknown:///|)
  = \canvas(str name, real width, real height, Color background, list[Statement] statements);

data NumExpr(loc src=|unknown:///|)
  = \randExpr(real min, real max)
  | \number(real val)
  | \idExpr(str name)
  | \mul(NumExpr left, NumExpr right)
  | \div(NumExpr left, NumExpr right)
  | \mod(NumExpr left, NumExpr right)
  | \add(NumExpr left, NumExpr right)
  | \sub(NumExpr left, NumExpr right)
  ;

data Expr(loc src=|unknown:///|)
  = \shapeExpr(Shape shape)
  | \numExpr(NumExpr expr)
  ;

data Cond(loc src=|unknown:///|)
  = \isEqual(NumExpr left, NumExpr right)
  | \isGreater(NumExpr left, NumExpr right)
  | \isLess(NumExpr left, NumExpr right)
  | \isGreaterEqual(NumExpr left, NumExpr right)
  | \isLessEqual(NumExpr left, NumExpr right)
  ;

data Statement(loc src=|unknown:///|)
  = \assignment(str name, Expr expr)
  | \draw(str name, Point point, NumExpr angle)
  | \repeat(int count, list[Statement] statements)
  | \forLoop(str var, real from, real to, real step, list[Statement] statements)
  | \ifThen(Cond cond, list[Statement] thenBranch)
  | \ifElse(Cond cond, list[Statement] thenBranch, list[Statement] elseBranch)
  ;

data Shape(loc src=|unknown:///|)
  = \circle(NumExpr radius, Color color)
  | \ellipse(NumExpr width, NumExpr height, Color color)
  | \arc(NumExpr width, NumExpr height, NumExpr startAngle, NumExpr stopAngle, Color color)
  | \square(NumExpr size, Color color)
  | \rect(NumExpr width, NumExpr height, Color color)
  | \star(NumExpr size, Color color)
  ;

data Color(loc src=|unknown:///|)
  = \white()
  | \yellow()
  | \green() 
  | \blue()
  | \red()
  | \purple()
  | \pink()
  | \black()
  | \orange()
  ;

data Point(loc src=|unknown:///|)
  = \mkPoint(NumExpr x, NumExpr y);
