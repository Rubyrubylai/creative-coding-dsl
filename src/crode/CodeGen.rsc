module crode::CodeGen

import IO;
import String;

import util::Math;

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
    case \circle(real radius, Color color): {
      real diameter = radius * 2.0 * scaleUnit;
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  circle(0, 0, <diameter>);\n";
    }
    case \ellipse(real width, real height, Color color): {
      real jsWidth = width * scaleUnit;
      real jsHeight = height * scaleUnit;
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  ellipse(0, 0, <jsWidth>, <jsHeight>);\n";
    }
    case \arc(real width, real height, real startAngle, real stopAngle, Color color): {
      real jsWidth = width * scaleUnit;
      real jsHeight = height * scaleUnit;
      return "  noFill();\n"
           + "  stroke(<colorToJs(color)>);\n"
           + "  strokeWeight(4);\n"
           + "  arc(0, 0, <jsWidth>, <jsHeight>, <startAngle>, <stopAngle>);\n";
    }
    case \square(real size, Color color): {
      real jsSize = size * scaleUnit;
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  square(0, 0, <jsSize>);\n"; // 0,0 is location of topleft corner, whereas circle/eclipse it's centre. TODO documentation
    }
    case \rect(real width, real height, Color color): {
      real jsWidth = width * scaleUnit;
      real jsHeight = height * scaleUnit;
      return "  fill(<colorToJs(color)>);\n"
           + "  noStroke();\n"
           + "  rect(0, 0, <jsWidth>, <jsHeight>)";
    }
  }
  return "";
}

str generateExpr(Expr expr) {
  switch (expr) {
    case \shapeExpr(Shape shape): return generateShape(shape);
    // case \randExpr(real min, real max): {
    //   real jsMin = min * scaleUnit;
    //   real jsMax = max * scaleUnit;
    //   return "random(<jsMin>, <jsMax>)";
    // } // TODO fix rand
    
  }
  return "";
}

real evalExpr(Expr e) {
  switch(e) {
    case \number(real v):
      return v;

    case \randExpr(real min, real max): {
      real r = arbReal();
      return r * (max - min) + min;
    }
  }
  return "";
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
      real px = evalExpr(x) * scaleUnit;
      real py = evalExpr(y) * scaleUnit;
      return "  push();\n"
           + "  translate(<px>, <py>);\n"
           + "  <name>();\n"
           + "  pop();\n";
    }
  }
  return "";
}

str generateDefinitions(list[Statement] statements)
  = joinStrings([generateStatement(statement) | statement <- statements, \assignment(_, _) := statement]);

str generateDrawCalls(list[Statement] statements)
  = joinStrings([generateStatement(statement) | statement <- statements, \draw(_, _) := statement]);

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
