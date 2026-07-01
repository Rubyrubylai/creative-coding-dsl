module crode::AST

/*
 * Define the Abstract Syntax for crode
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data Canvas(loc src=|unknown:///|)
  = \canvas(str name, real width, real height, Color background, list[Statement] statements);

data Expr(loc src=|unknown:///|)
  = \shapeExpr(Shape shape)
  | \randExpr(real min, real max)
  | \number(real val)
  | \idExpr(str name)
  | \mul(Expr left, Expr right)
  | \div(Expr left, Expr right)
  | \mod(Expr left, Expr right)
  | \add(Expr left, Expr right)
  | \sub(Expr left, Expr right)
  ;

data Cond(loc src=|unknown:///|)
  = \isEqual(Expr left, Expr right)
  | \isGreater(Expr left, Expr right)
  | \isLess(Expr left, Expr right)
  | \isGreaterEqual(Expr left, Expr right)
  | \isLessEqual(Expr left, Expr right)
  ;

data Statement(loc src=|unknown:///|)
  = \assignment(str name, Expr expr)
  | \draw(str name, Point point)
  | \repeat(int count, list[Statement] statements)
  | \forLoop(str var, real from, real to, real step, list[Statement] statements)
  | \ifThen(Cond cond, list[Statement] thenBranch)
  | \ifElse(Cond cond, list[Statement] thenBranch, list[Statement] elseBranch)
  ;

data Shape(loc src=|unknown:///|)
  = \circle(Expr radius, Color color)
  | \ellipse(Expr width, Expr height, Color color)
  | \arc(Expr width, Expr height, Expr startAngle, Expr stopAngle, Color color)
  | \square(Expr size, Color color)
  | \rect(Expr width, Expr height, Color color)
  | \star(Expr size, Color color)
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
  = \mkPoint(Expr x, Expr y);
