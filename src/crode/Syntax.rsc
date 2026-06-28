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
  ;

syntax Expr
  = shape: Shape
  ;

syntax Shape
  = circleShape: CircleShape
  | ellipseShape: EllipseShape
  | arcShape: ArcShape
  ;

syntax CircleShape
  = circle: "circle" "{"
    "radius" NumberLiteral
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

syntax Point
  = point: "(" NumberLiteral "," NumberLiteral ")";
