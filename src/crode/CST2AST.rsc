module crode::CST2AST

// This provides println which can be handy during debugging.
import IO;

// These provide useful functions such as toInt, keep those in mind.
import Prelude;
import String;

import util::Maybe;

import crode::AST;
import crode::Syntax;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 * Hint: Use switch to do case distinction with concrete patterns
 * Map regular CST arguments (e.g., *, +, ?) to lists
 * Map lexical nodes to Rascal primitive types (bool, int, str)
 */

str unquote(str text)
  = substring(text, 1, size(text) - 1);

str loadString(StringLiteral text)
  = unquote("<text>");

str loadId(Id id)
  = "<id>";

real loadNumber(NumberLiteral n)
  = toReal("<n>");

int loadInt(IntLiteral n)
  = toInt("<n>");

crode::AST::Color loadColor((Color)`white`) = \white();
crode::AST::Color loadColor((Color)`yellow`) = \yellow();
crode::AST::Color loadColor((Color)`green`) = \green();
crode::AST::Color loadColor((Color)`blue`) = \blue();
crode::AST::Color loadColor((Color)`red`) = \red();
crode::AST::Color loadColor((Color)`purple`) = \purple();
crode::AST::Color loadColor((Color)`pink`) = \pink();
crode::AST::Color loadColor((Color)`black`) = \black();
crode::AST::Color loadColor((Color)`orange`) = \orange();

crode::AST::Point loadPoint((Point)`( <NumExpr x> , <NumExpr y> )`)
  = \mkPoint(loadNumExpr(x), loadNumExpr(y), src=x@\loc);

crode::AST::Shape loadShape((Shape)`<CircleShape circleShape>`)
  = loadCircleShape(circleShape);

crode::AST::Shape loadShape((Shape)`<EllipseShape ellipseShape>`)
  = loadEllipseShape(ellipseShape);

crode::AST::Shape loadShape((Shape)`<ArcShape arcShape>`)
  = loadArcShape(arcShape);

crode::AST::Shape loadShape((Shape)`<SquareShape squareShape>`)
  = loadSquareShape(squareShape);

crode::AST::Shape loadShape((Shape)`<RectShape rectShape>`)
  = loadRectShape(rectShape);

crode::AST::Shape loadShape((Shape)`<StarShape starShape>`)
  = loadStarShape(starShape);

crode::AST::Shape loadCircleShape((CircleShape)`circle { radius <NumExpr radius> color <Color color> }`)
  = \circle(loadNumExpr(radius), loadColor(color), src=radius@\loc);

crode::AST::Shape loadEllipseShape((EllipseShape)`ellipse { width <NumExpr width> height <NumExpr height> color <Color color> }`)
  = \ellipse(loadNumExpr(width), loadNumExpr(height), loadColor(color), src=width@\loc);

crode::AST::Shape loadArcShape((ArcShape)`arc { width <NumExpr width> height <NumExpr height> start <NumExpr startAngle> stop <NumExpr stopAngle> color <Color color> }`)
  = \arc(loadNumExpr(width), loadNumExpr(height), loadNumExpr(startAngle), loadNumExpr(stopAngle), loadColor(color), src=width@\loc);

crode::AST::Shape loadSquareShape((SquareShape)`square { size <NumExpr size> color <Color color> }`)
  = \square(loadNumExpr(size), loadColor(color), src=size@\loc);

crode::AST::Shape loadRectShape((RectShape)`rect { width <NumExpr width> height <NumExpr height> color <Color color> }`)
  = \rect(loadNumExpr(width), loadNumExpr(height), loadColor(color), src=width@\loc);

crode::AST::Shape loadStarShape((StarShape)`star { size <NumExpr size> color <Color color>}`)
  = \star(loadNumExpr(size), loadColor(color), src=size@\loc);

crode::AST::Shape loadShapeExpr((ShapeExpr)`<Shape shapeTree>`)
  = loadShape(shapeTree);

crode::AST::Expr loadExpr((Expr)`<ShapeExpr expr>`)
  = \shapeExpr(loadShapeExpr(expr), src=expr@\loc);

crode::AST::Expr loadExpr((Expr)`<NumExpr expr>`)
  = \numExpr(loadNumExpr(expr), src=expr@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`random(<NumberLiteral min>, <NumberLiteral max>)`)
  = \randExpr(loadNumber(min), loadNumber(max), src=min@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`<NumberLiteral val>`)
  = \number(loadNumber(val), src=val@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`<Id id>`)
  = \idExpr(loadId(id), src=id@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`( <NumExpr expr> )`)
  = loadNumExpr(expr);

crode::AST::NumExpr loadNumExpr((NumExpr)`<NumExpr l> * <NumExpr r>`)
  = crode::AST::mul(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`<NumExpr l> / <NumExpr r>`)
  = crode::AST::div(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`<NumExpr l> mod <NumExpr r>`)
  = \mod(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`<NumExpr l> + <NumExpr r>`)
  = crode::AST::add(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::NumExpr loadNumExpr((NumExpr)`<NumExpr l> - <NumExpr r>`)
  = crode::AST::sub(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::Cond loadCond((Cond)`<NumExpr l> equals <NumExpr r>`)
  = crode::AST::isEqual(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::Cond loadCond((Cond)`<NumExpr l> greaterThan <NumExpr r>`)
  = crode::AST::isGreater(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::Cond loadCond((Cond)`<NumExpr l> lessThan <NumExpr r>`)
  = crode::AST::isLess(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::Cond loadCond((Cond)`<NumExpr l> atLeast <NumExpr r>`)
  = crode::AST::isGreaterEqual(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::Cond loadCond((Cond)`<NumExpr l> atMost <NumExpr r>`)
  = crode::AST::isLessEqual(loadNumExpr(l), loadNumExpr(r), src=l@\loc);

crode::AST::Statement loadStatement((Statement)`let <Id id> = <Expr expr>`)
  = \assignment(loadId(id), loadExpr(expr), src=id@\loc);

crode::AST::Statement loadStatement((Statement)`draw <Id id> at <Point point> rotate <NumExpr angle>`)
  = \draw(loadId(id), loadPoint(point), loadNumExpr(angle), src=id@\loc);

crode::AST::Statement loadStatement((Statement)`draw <Id id> at <Point point>`)
  = \draw(loadId(id), loadPoint(point), \number(0.0), src=id@\loc); // TODO(doc): add default angle as 0 for simplifying AST

crode::AST::Statement loadStatement((Statement)`repeat <IntLiteral count> { <Statement* statements> }`)
  = \repeat(loadInt(count), loadStatements(statements), src=count@\loc);

crode::AST::Statement loadStatement((Statement)`for <Id var> in <NumberLiteral from> to <NumberLiteral to> step <NumberLiteral step> { <Statement* statements> }`)
  = \forLoop(loadId(var), loadNumber(from), loadNumber(to), loadNumber(step), loadStatements(statements), src=var@\loc);

crode::AST::Statement loadStatement((Statement)`if <Cond cond> { <Statement* thenBranch> }`)
  = \ifThen(loadCond(cond), loadStatements(thenBranch), src=cond@\loc);

crode::AST::Statement loadStatement((Statement)`if <Cond cond> { <Statement* thenBranch> } else { <Statement* elseBranch> }`)
  = \ifElse(loadCond(cond), loadStatements(thenBranch), loadStatements(elseBranch), src=cond@\loc);

list[crode::AST::Statement] loadStatements(Statement* statements)
  = [loadStatement(statement) | statement <- statements];

// Keep only the domain-relevant data in the AST.
// Discard concrete syntax details such as keywords, braces, and commas.
public crode::AST::Canvas cst2ast((start[Canvas])`<Canvas canvasTree>`)
  = loadCanvas(canvasTree);

crode::AST::Canvas loadCanvas((Canvas)`canvas <StringLiteral id> width <NumberLiteral width> height <NumberLiteral height> { <Statement* statements> }`)
  = \canvas(loadString(id), loadNumber(width), loadNumber(height), \white(), loadStatements(statements), src=id@\loc);

crode::AST::Canvas loadCanvas((Canvas)`canvas <StringLiteral id> width <NumberLiteral width> height <NumberLiteral height> background <Color background> { <Statement* statements> }`)
  = \canvas(loadString(id), loadNumber(width), loadNumber(height), loadColor(background), loadStatements(statements), src=id@\loc);
