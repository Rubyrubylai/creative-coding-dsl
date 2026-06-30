module crode::AST

/*
 * Define the Abstract Syntax for crode
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data Canvas(loc src=|unknown:///|)
  = \canvas(str name, list[Statement] statements);

data Expr(loc src=|unknown:///|)
  = \shapeExpr(Shape shape);

data Statement(loc src=|unknown:///|)
  = \assignment(str name, Expr expr)
  | \draw(str name, Point point)
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
  = \point(real x, real y);
