module crode::CodeGen

import IO;
import String;

import crode::AST;
import crode::Parser;
import crode::CST2AST;

/*
 * Code generation for crode.
 */

real scaleUnit = 100.0;

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
    case \circle(Expr radius, Color color): {
      str diameter = "(<generateExprValue(radius)> * 2.0 * <scaleUnit>)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  circle(0, 0, <diameter>);\n";
    }
    case \ellipse(Expr width, Expr height, Color color): {
      str jsWidth = "(<generateExprValue(width)> * <scaleUnit>)";
      str jsHeight = "(<generateExprValue(height)> * <scaleUnit>)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  ellipse(0, 0, <jsWidth>, <jsHeight>);\n";
    }
    case \arc(Expr width, Expr height, Expr startAngle, Expr stopAngle, Color color): {
      str jsWidth = "(<generateExprValue(width)> * <scaleUnit>)";
      str jsHeight = "(<generateExprValue(height)> * <scaleUnit>)";
      str jsStartAngle = "(<generateExprValue(startAngle)>)";
      str jsStopAngle = "(<generateExprValue(stopAngle)>)";
      return "  noFill();\n"
           + "  stroke(<colorToJs(color)>);\n"
           + "  strokeWeight(4);\n"
           + "  arc(0, 0, <jsWidth>, <jsHeight>, <jsStartAngle>, <jsStopAngle>);\n";
    }
    case \square(Expr size, Color color): {
      str jsSize = "(<generateExprValue(size)> * <scaleUnit>)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  square(0, 0, <jsSize>);\n"; // 0,0 is location of topleft corner, whereas circle/eclipse it's centre. TODO documentation
    }
    case \rect(Expr width, Expr height, Color color): {
      str jsWidth = "(<generateExprValue(width)> * <scaleUnit>)";
      str jsHeight = "(<generateExprValue(height)> * <scaleUnit>)";
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  rect(0, 0, <jsWidth>, <jsHeight>)";
    }
    case \star(Expr size, Color color): {
      str sizeExpr = "(<generateExprValue(size)> * <scaleUnit>)";
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

str generateExpr(Expr expr) {
  switch (expr) {
    case \shapeExpr(Shape shape): return generateShape(shape);    
  }
  return "";
}

str generateExprValue(Expr expr) {
  switch (expr) {
    case \number(real v): return "<v>";
    case \randExpr(real min, real max): return "random(<min>, <max>)"; // unscaled here
    case \idExpr(str name): return name;
    case \mul(Expr l, Expr r): return "(<generateExprValue(l)> * <generateExprValue(r)>)";
    case \div(Expr l, Expr r): return "(<generateExprValue(l)> / <generateExprValue(r)>)";
    case \mod(Expr l, Expr r): return "(<generateExprValue(l)> % <generateExprValue(r)>)";
    case \add(Expr l, Expr r): return "(<generateExprValue(l)> + <generateExprValue(r)>)";
    case \sub(Expr l, Expr r): return "(<generateExprValue(l)> - <generateExprValue(r)>)";
  }
  return "0";
}

str generateCoordExpr(Expr expr)
  = "(<generateExprValue(expr)> * <scaleUnit>)";

str generateCond(Cond cond) {
  switch (cond) {
    case \isEqual(Expr l, Expr r):
      return "(<generateExprValue(l)> === <generateExprValue(r)>)";
  } 
  return "false";
}

str generateStatement(Statement statement) {
  switch (statement) {
    case \assignment(str name, Expr expr): {
      return "function <name>() {\n"
           + generateExpr(expr)
           + "}\n\n";
    }
    // TODO Extend \assignment to include variable assignments (let y = 5)
    case \draw(str name, \mkPoint(Expr x, Expr y)): {
      str px = generateCoordExpr(x);
      str py = generateCoordExpr(y);
      return "  push();\n"
           + "  translate(<px>, <py>);\n"
           + "  <name>();\n"
           + "  pop();\n";
    }
  }
  return "";
}

str generateDefinitions(list[Statement] statements)
  = joinStrings([generateDefinitionsFor(s) | s <- statements]);

str generateDefinitionsFor(Statement statement) {
  switch (statement) {
    case \assignment(_, _): return generateStatement(statement);
    case \repeat(_, list[Statement] statements): return generateDefinitions(statements); // TODO Documentation: Do not repeat the JS function declaration (also, they are static, can we randomize radius, width, height etc?)
    case \forLoop(_, _, _, _, list[Statement] statements): return generateDefinitions(statements);
    case \ifThen(_, list[Statement] thenBranch):
      return generateDefinitions(thenBranch);
    case \ifElse(_, list[Statement] thenBranch, list[Statement] elseBranch):
      return generateDefinitions(thenBranch) + generateDefinitions(elseBranch);
  }
  return "";
}

str generateDrawCalls(list[Statement] statements)
  = joinStrings([generateDrawCallsFor(s) | s <- statements]);

str generateDrawCallsFor(Statement statement) {
  switch (statement) {
    case \draw(_, _): return generateStatement(statement);
    case \repeat(int count, list[Statement] statements):
      return "  for (let i = 0; i \< <count>; i++) {\n"
           + generateDrawCalls(statements)
           + "  }\n";
    case \forLoop(str var, real from, real to, real step, list[Statement] statements):
      return "  for (let <var> = <from>; <var> \< <to>; <var> += <step>) {\n"
           + generateDrawCalls(statements)
           + "  }\n";
    case \ifThen(Cond cond, list[Statement] thenBranch):
      return "  if (<generateCond(cond)>) {\n"
           + generateDrawCalls(thenBranch)
           + "  }\n";
    case \ifElse(Cond cond, list[Statement] thenBranch, list[Statement] elseBranch):
      return "  if (<generateCond(cond)>) {\n"
           + generateDrawCalls(thenBranch)
           + "  } else {\n"
           + generateDrawCalls(elseBranch)
           + "  }\n";
  }
  return "";
}

public str generateP5(Canvas canvas) {
  switch (canvas) {
    case \canvas(str name, list[Statement] statements): {
      return "// Generated from canvas \"<name>\"\n\n"
           + generateDefinitions(statements)
           + "function setup() {\n"
           + "  createCanvas(800, 600);\n"
           + "  angleMode(DEGREES);\n"
           + "  background(255);\n\n"
           + generateDrawCalls(statements)
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
    case \canvas(str name, _): {
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
  generateP5Files(cst2ast(parseCrode(sourceFile)), baseName(sourceFile));
}
