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
