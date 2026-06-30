module crode::AST

/*
 * Define the Abstract Syntax for crode
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data Canvas(loc src=|unknown:///|)
  = \canvas(str name, list[Statement] statements);

data Expr(loc src=|unknown:///|)
  = \shapeExpr(Shape shape)
  | \randExpr(real min, real max)
  | \number(real val)
  | \idExpr(str name)
  | \mul(Expr left, Expr right)
  | \div(Expr left, Expr right)
  | \add(Expr left, Expr right)
  | \sub(Expr left, Expr right)
  ;

data Statement(loc src=|unknown:///|)
  = \assignment(str name, Expr expr)
  | \draw(str name, Point point)
  | \repeat(int count, list[Statement] statements)
  | \forLoop(str var, real from, real to, real step, list[Statement] statements)
  ;

data Shape(loc src=|unknown:///|)
  = \circle(real radius, Color color)
  | \ellipse(real width, real height, Color color)
  | \arc(real width, real height, real startAngle, real stopAngle, Color color)
  | \square(real size, Color color)
  | \rect(real width, real height, Color color)
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
