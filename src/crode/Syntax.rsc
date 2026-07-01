module crode::Syntax

/*
 * Define a concrete syntax for crode.
 */

// ===========================================================================
// Comment and whitespace parsing
layout Layout = WhitespaceOrComment* !>> [\ \t\n\f\r] !>> "//" !>> "/*";

syntax WhitespaceOrComment
  = whitespace: Whitespace
  | comment: LineComment
  ;

lexical Whitespace
  = [\u0009-\u000D \u0020 \u0085 \u00A0 \u1680 \u180E \u2000-\u200A \u2028 \u2029 \u202F \u205F \u3000];

lexical LineComment
  = @category="Comment" "//"  ![\n]* $;
// ===========================================================================

keyword Keywords
  = "let" | "draw" | "at" | "repeat" | "for" | "in" | "to" | "step"
  | "if" | "else" | "canvas" | "background" | "rotate" | "random" | "mod"
  | "circle" | "ellipse" | "arc" | "square" | "rect" | "star"
  | "radius" | "width" | "height" | "size" | "color" | "start" | "stop"
  | "white" | "yellow" | "green" | "blue" | "red" | "purple" | "pink" | "black" | "orange"
  | "equals" | "lessThan" | "greaterThan" | "atLeast" | "atMost"
  ;

lexical StringLiteral = "\"" ![\"]* "\"";
lexical Id = [a-zA-Z_][a-zA-Z0-9_]* !>> [a-zA-Z0-9_] \ Keywords;
lexical NumberLiteral
  = "-"? [0-9]+ "." [0-9]+
  | "-"? [0-9]+
  ;
lexical IntLiteral = [0-9]+ !>> [0-9];
lexical Color
= "white"
| "yellow"
| "green"
| "blue"
| "red"
| "purple"
| "pink"
| "black"
| "orange"
;

start syntax Canvas
  = canvas: "canvas" StringLiteral "width" NumberLiteral "height" NumberLiteral "{" Statement* "}"
  | backgroundCanvas: "canvas" StringLiteral "width" NumberLiteral "height" NumberLiteral "background" Color "{" Statement* "}";

syntax Statement
  = assignment: "let" Id "=" Expr
  | rotatedDraw: "draw" Id "at" Point "rotate" NumExpr
  | draw: "draw" Id "at" Point
  | repeat: "repeat" IntLiteral "{" Statement* "}"
  | forLoop: "for" Id "in" NumberLiteral "to" NumberLiteral "step" NumberLiteral "{" Statement* "}"
  | ifThen: "if" Cond "{" Statement* "}"
  | ifElse: "if" Cond "{" Statement* "}" "else" "{" Statement* "}"
  ;

syntax Expr
  = shapeExpr: ShapeExpr
  | numExpr: NumExpr
  ;

syntax ShapeExpr
  = shape: Shape
  ;

syntax NumExpr
  = randExpr: RandExpr
  | number: NumberLiteral
  | idExpr: Id
  | bracket "(" NumExpr ")"
  > left mul: NumExpr "*" NumExpr
  > left div: NumExpr "/" NumExpr
  > left modOp: NumExpr "mod" NumExpr
  > left add: NumExpr "+" NumExpr
  > left sub: NumExpr "-" NumExpr
  ;

syntax Cond // TODO Decision: "is", "equals", or "==" ? 
  = isEqual: NumExpr "equals" NumExpr
  | isGreater: NumExpr "greaterThan" NumExpr
  | isLess: NumExpr "lessThan" NumExpr
  | isGreaterEqual: NumExpr "atLeast" NumExpr
  | isLessEqual: NumExpr "atMost" NumExpr
  ;

syntax Shape
  = circleShape: CircleShape
  | ellipseShape: EllipseShape
  | arcShape: ArcShape
  | squareShape: SquareShape
  | rectShape: RectShape
  | starShape: StarShape
  ;

syntax CircleShape
  = circle: "circle" "{"
    "radius" NumExpr
    "color" Color
  "}"
  ;

syntax EllipseShape
  = ellipse: "ellipse" "{"
    "width" NumExpr
    "height" NumExpr
    "color" Color
  "}"
  ;

syntax ArcShape
  = arc: "arc" "{"
    "width" NumExpr
    "height" NumExpr
    "start" NumExpr
    "stop" NumExpr
    "color" Color
  "}"
  ;

syntax SquareShape
  = square: "square" "{"
    "size" NumExpr
    "color" Color
  "}"
  ;

syntax RectShape
  = rect: "rect" "{"
    "width" NumExpr
    "height" NumExpr
    "color" Color
  "}"
  ;

syntax StarShape
  = star: "star" "{"
    "size" NumExpr
    "color" Color
  "}"
  ;

syntax RandExpr
  = random: "random" "(" NumberLiteral "," NumberLiteral ")";

syntax Point
  = point: "(" NumExpr "," NumExpr ")";
