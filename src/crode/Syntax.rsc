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

lexical StringLiteral = "\"" ![\"]* "\"";
lexical Id = [a-zA-Z_][a-zA-Z0-9_]* !>> [a-zA-Z0-9_];
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
  = canvas: "canvas" StringLiteral "{" Statement* "}";

syntax Statement
  = assignment: "let" Id "=" Expr
  | draw: "draw" Id "at" Point
  | repeat: "repeat" IntLiteral "{" Statement* "}"
  | forLoop: "for" Id "in" NumberLiteral "to" NumberLiteral "step" NumberLiteral "{" Statement* "}"
  | ifThen: "if" Cond "{" Statement* "}"
  | ifElse: "if" Cond "{" Statement* "}" "else" "{" Statement* "}"
  ;

syntax Expr
  = shape: Shape
  | randExpr: RandExpr
  | number: NumberLiteral
  | idExpr: Id
  | bracket "(" Expr ")"
  > left mul: Expr "*" Expr
  > left div: Expr "/" Expr
  > left modOp: Expr "mod" Expr
  > left add: Expr "+" Expr
  > left sub: Expr "-" Expr
  ;

syntax Cond // TODO Decision: "is", "equals", or "==" ? 
  = isEqual: Expr "equals" Expr
  ;

syntax Shape
  = circleShape: CircleShape
  | ellipseShape: EllipseShape
  | arcShape: ArcShape
  | squareShape: SquareShape
  | rectShape: RectShape
  ;

syntax CircleShape
  = circle: "circle" "{"
    "radius" Expr
    "color" Color
  "}"
  ;

syntax EllipseShape
  = ellipse: "ellipse" "{"
    "width" NumberLiteral
    "height" NumberLiteral
    "color" Color
  "}"
  ;

syntax ArcShape
  = arc: "arc" "{"
    "width" NumberLiteral
    "height" NumberLiteral
    "start" NumberLiteral
    "stop" NumberLiteral
    "color" Color
  "}"
  ;

syntax SquareShape
  = square: "square" "{"
    "size" NumberLiteral
    "color" Color
  "}"
  ;

syntax RectShape
  = rect: "rect" "{"
    "width" NumberLiteral
    "height" NumberLiteral
    "color" Color
  "}"
  ;

syntax RandExpr
  = rand: "rand" "(" NumberLiteral "," NumberLiteral ")";

syntax Point
  = point: "(" Expr "," Expr ")";
