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

crode::AST::Point loadPoint((Point)`( <Expr x> , <Expr y> )`)
  = \mkPoint(loadExpr(x), loadExpr(y), src=x@\loc);

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

crode::AST::Shape loadCircleShape((CircleShape)`circle { radius <NumberLiteral radius> color <Color color> }`)
  = \circle(loadNumber(radius), loadColor(color), src=radius@\loc);

crode::AST::Shape loadEllipseShape((EllipseShape)`ellipse { width <NumberLiteral width> height <NumberLiteral height> color <Color color> }`)
  = \ellipse(loadNumber(width), loadNumber(height), loadColor(color), src=width@\loc);

crode::AST::Shape loadArcShape((ArcShape)`arc { width <NumberLiteral width> height <NumberLiteral height> start <NumberLiteral startAngle> stop <NumberLiteral stopAngle> color <Color color> }`)
  = \arc(loadNumber(width), loadNumber(height), loadNumber(startAngle), loadNumber(stopAngle), loadColor(color), src=width@\loc);

crode::AST::Shape loadSquareShape((SquareShape)`square { size <NumberLiteral size> color <Color color> }`)
  = \square(loadNumber(size), loadColor(color), src=size@\loc);

crode::AST::Shape loadRectShape((RectShape)`rect { width <NumberLiteral width> height <NumberLiteral height> color <Color color> }`)
  = \rect(loadNumber(width), loadNumber(height), loadColor(color), src=width@\loc);

crode::AST::Expr loadExpr((Expr)`<Shape shapeTree>`)
  = \shapeExpr(loadShape(shapeTree), src=shapeTree@\loc);

crode::AST::Expr loadExpr((Expr)`rand(<NumberLiteral min>, <NumberLiteral max>)`)
  = \randExpr(loadNumber(min), loadNumber(max), src=min@\loc);

crode::AST::Expr loadExpr((Expr)`<NumberLiteral val>`)
  = \number(loadNumber(val), src=val@\loc);

crode::AST::Expr loadExpr((Expr)`<Id id>`)
  = \idExpr(loadId(id), src=id@\loc);

crode::AST::Statement loadStatement((Statement)`let <Id id> = <Expr expr>`)
  = \assignment(loadId(id), loadExpr(expr), src=id@\loc);

crode::AST::Statement loadStatement((Statement)`draw <Id id> at <Point point>`)
  = \draw(loadId(id), loadPoint(point), src=id@\loc);

crode::AST::Statement loadStatement((Statement)`repeat <IntLiteral count> { <Statement* statements> }`)
  = \repeat(loadInt(count), loadStatements(statements), src=count@\loc);

crode::AST::Statement loadStatement((Statement)`for <Id var> in <NumberLiteral from> to <NumberLiteral to> step <NumberLiteral step> { <Statement* statements> }`)
  = \forLoop(loadId(var), loadNumber(from), loadNumber(to), loadNumber(step), loadStatements(statements), src=var@\loc);

list[crode::AST::Statement] loadStatements(Statement* statements)
  = [loadStatement(statement) | statement <- statements];

// Keep only the domain-relevant data in the AST.
// Discard concrete syntax details such as keywords, braces, and commas.
public crode::AST::Canvas cst2ast((start[Canvas])`<Canvas canvasTree>`)
  = loadCanvas(canvasTree);

crode::AST::Canvas loadCanvas((Canvas)`canvas <StringLiteral id> { <Statement* statements> }`)
  = \canvas(loadString(id), loadStatements(statements), src=id@\loc);
