module crode::CodeGen

import IO;
import String;

import crode::AST;
import crode::Parser;
import crode::CST2AST;
import crode::Check;

/*
 * Code generation for crode.
 */

str colorToJs(Color color) {
  switch (color) {
    case \white(): return "\"white\"";
    case \yellow(): return "\"yellow\"";
    case \green(): return "\"green\"";
    case \blue(): return "\"blue\"";
    case \red(): return "\"red\"";
    case \purple(): return "\"purple\"";
    case \pink(): return "\"pink\"";
    case \black(): return "\"black\"";
    case \orange(): return "\"orange\"";
  }
  return "\"black\"";
}

str joinStrings(list[str] parts) {
  str result = "";
  for (part <- parts) {
    result += part;
  }
  return result;
}

str generateShape(Shape shape) {
  switch (shape) {
    case \circle(NumExpr radius, Color color): {
      str diameter = "(<generateNumExprValue(radius)> * 2.0)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  circle(0, 0, <diameter>);\n";
    }
    case \ellipse(NumExpr width, NumExpr height, Color color): {
      str jsWidth = "(<generateNumExprValue(width)>)";
      str jsHeight = "(<generateNumExprValue(height)>)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  ellipse(0, 0, <jsWidth>, <jsHeight>);\n";
    }
    case \arc(NumExpr width, NumExpr height, NumExpr startAngle, NumExpr stopAngle, Color color): {
      str jsWidth = "(<generateNumExprValue(width)>)";
      str jsHeight = "(<generateNumExprValue(height)>)";
      str jsStartAngle = "(<generateNumExprValue(startAngle)>)";
      str jsStopAngle = "(<generateNumExprValue(stopAngle)>)";
      return "  noFill();\n"
           + "  stroke(<colorToJs(color)>);\n"
           + "  strokeWeight(4);\n"
           + "  arc(0, 0, <jsWidth>, <jsHeight>, <jsStartAngle>, <jsStopAngle>);\n";
    }
    case \square(NumExpr size, Color color): {
      str jsSize = "(<generateNumExprValue(size)>)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  square(0, 0, <jsSize>);\n"; // 0,0 is location of topleft corner, whereas circle/eclipse it's centre. TODO documentation
    }
    case \rect(NumExpr width, NumExpr height, Color color): {
      str jsWidth = "(<generateNumExprValue(width)>)";
      str jsHeight = "(<generateNumExprValue(height)>)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  rect(0, 0, <jsWidth>, <jsHeight>);\n";
    }
    case \star(NumExpr size, Color color): {
      str sizeExpr = "(<generateNumExprValue(size)>)";
      int points = 5;
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  {\n"
           + "    let outerR = <sizeExpr>;\n"
           + "    let innerR = outerR * 0.4;\n"
           + "    beginShape();\n"
           + "    for (let i = 0; i \< <points> * 2; i++) {\n"
           + "      let angle = (Math.PI / <points>) * i - Math.PI / 2;\n"
           + "      let rad = (i % 2 === 0) ? outerR : innerR;\n"
           + "      vertex(rad * Math.cos(angle), rad * Math.sin(angle));\n"
           + "    }\n"
           + "    endShape(CLOSE);\n"
           + "  }\n";
    }
  }
  return "";
}

str generateNumExprValue(NumExpr expr) {
  switch (expr) {
    case \number(real v): return "<v>";
    case \randExpr(real min, real max): return "random(<min>, <max>)";
    case \idExpr(str name): return name;
    case \mul(NumExpr l, NumExpr r): return "(<generateNumExprValue(l)> * <generateNumExprValue(r)>)";
    case \div(NumExpr l, NumExpr r): return "(<generateNumExprValue(l)> / <generateNumExprValue(r)>)";
    case \mod(NumExpr l, NumExpr r): return "(<generateNumExprValue(l)> % <generateNumExprValue(r)>)";
    case \add(NumExpr l, NumExpr r): return "(<generateNumExprValue(l)> + <generateNumExprValue(r)>)";
    case \sub(NumExpr l, NumExpr r): return "(<generateNumExprValue(l)> - <generateNumExprValue(r)>)";
  }
  return "0";
}

str generateCoordExpr(NumExpr expr)
  = "(<generateNumExprValue(expr)>)";

str generateCond(Cond cond) {
  switch (cond) {
    case \isEqual(NumExpr l, NumExpr r):
      return "(<generateNumExprValue(l)> === <generateNumExprValue(r)>)";
    case \isGreater(NumExpr l, NumExpr r):
      return "(<generateNumExprValue(l)> \> <generateNumExprValue(r)>)";
    case \isLess(NumExpr l, NumExpr r):
      return "(<generateNumExprValue(l)> \< <generateNumExprValue(r)>)";
    case \isGreaterEqual(NumExpr l, NumExpr r):
      return "(<generateNumExprValue(l)> \>= <generateNumExprValue(r)>)";
    case \isLessEqual(NumExpr l, NumExpr r):
      return "(<generateNumExprValue(l)> \<= <generateNumExprValue(r)>)";
  } 
  return "false";
}

str generateStatement(Statement statement) {
  switch (statement) {
    case \assignment(str name, \shapeValue(Shape shape)): {
      return "function <name>() {\n" // TODO(doc): specify block scope
           + generateShape(shape)
            + "}\n\n";
    }
    case \assignment(str name, \numValue(NumExpr expr)): {
      return "  let <name> = <generateNumExprValue(expr)>;\n";
    }
    case \draw(str name, \mkPoint(NumExpr x, NumExpr y), NumExpr angle): {
      str px = generateCoordExpr(x);
      str py = generateCoordExpr(y);
      str rotation = generateNumExprValue(angle);
      return "  push();\n"
           + "  translate(<px>, <py>);\n"
           + "  rotate(<rotation>);\n"
           + "  <name>();\n"
           + "  pop();\n";
    }
  }
  return "";
}



str generateSetupStatements(list[Statement] statements)
  = joinStrings([generateSetupStatement(s) | s <- statements]);

str generateSetupStatement(Statement statement) {
  switch (statement) {
    case \assignment(_, _):
      return generateStatement(statement);
    case \draw(_, _, _):
      return generateStatement(statement);
    case \repeat(int count, list[Statement] statements):
      return "  for (let $crode_repeat_i = 0; $crode_repeat_i \< <count>; $crode_repeat_i++) {\n"
           + generateSetupStatements(statements)
           + "  }\n";
    case \forLoop(str var, real from, real to, real step, list[Statement] statements):
      return "  for (let <var> = <from>; <var> \< <to>; <var> += <step>) {\n"
           + generateSetupStatements(statements)
           + "  }\n";
    case \ifThen(Cond cond, list[Statement] thenBranch):
      return "  if (<generateCond(cond)>) {\n"
           + generateSetupStatements(thenBranch)
           + "  }\n";
    case \ifElse(Cond cond, list[Statement] thenBranch, list[Statement] elseBranch):
      return "  if (<generateCond(cond)>) {\n"
           + generateSetupStatements(thenBranch)
           + "  } else {\n"
           + generateSetupStatements(elseBranch)
           + "  }\n";
  }
  return "";
}

public str generateP5(Canvas canvas) {
  switch (canvas) {
    case \canvas(str name, real width, real height, Color backgroundColor, list[Statement] statements): {
      str jsWidth = "<width>";
      str jsHeight = "<height>";
      return "// Generated from canvas \"<name>\"\n\n"
           + "function setup() {\n"
           + "  createCanvas(<jsWidth>, <jsHeight>);\n"
           + "  angleMode(DEGREES);\n"
           + "  background(<colorToJs(backgroundColor)>);\n\n"
           + generateSetupStatements(statements)
           + "}\n";
    }
  }
  return "";
}

str dropExtension(str fileName) {
  if (endsWith(fileName, ".crode")) {
    return substring(fileName, 0, size(fileName) - size(".crode"));
  }
  return fileName;
}

str fileName(loc sourceFile) {
  int slash = findLast(sourceFile.path, "/");
  if (slash < 0) {
    return sourceFile.path;
  }
  return substring(sourceFile.path, slash + 1);
}

str baseName(loc sourceFile)
  = dropExtension(fileName(sourceFile));

public str generateHtml(Canvas canvas, str jsFileName) {
  switch (canvas) {
    case \canvas(str name, _, _, _, _): {
      return "\<!doctype html\>\n"
           + "\<html lang=\"en\"\>\n"
           + "  \<head\>\n"
           + "    \<meta charset=\"utf-8\"\>\n"
           + "    \<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"\>\n"
           + "    \<title\><name>\</title\>\n"
           + "    \<script src=\"https://cdn.jsdelivr.net/npm/p5@1.9.4/lib/p5.min.js\"\>\</script\>\n"
           + "    \<script src=\"./<jsFileName>\"\>\</script\>\n"
           + "  \</head\>\n"
           + "  \<body\>\n"
           + "  \</body\>\n"
           + "\</html\>\n";
    }
  }
  return "";
}

public str generateHtml(Canvas canvas)
  = generateHtml(canvas, "sketch.js");

void ensureDirectory(loc directory) {
  if (!exists(directory)) {
    mkDirectory(directory);
  }
}

void generateP5Files(Canvas canvas, str outputName) {
  loc outputDir = |project://creative-coding-dsl/src/crode/build/<outputName>|;
  ensureDirectory(outputDir);
  writeFile(|project://creative-coding-dsl/src/crode/build/<outputName>/sketch.js|, generateP5(canvas));
  writeFile(|project://creative-coding-dsl/src/crode/build/<outputName>/index.html|, generateHtml(canvas));
}

public void generateP5FromFile(loc sourceFile) {
  loc buildRoot = |project://creative-coding-dsl/src/crode/build|;
  ensureDirectory(buildRoot);
  Canvas ast = cst2ast(parseCrode(sourceFile));
  if (checkCanvasConfiguration(ast)) {
    generateP5Files(ast, baseName(sourceFile));
  } else {
    println("Invalid crode program: <sourceFile.path>");
  }
}
