// Generated from canvas "Kirby"

function body() {
  fill("pink");
  noStroke();
  circle(0, 0, 270.0000);
}

function foot() {
  fill("red");
  noStroke();
  ellipse(0, 0, 105.000, 45.000);
}

function hand() {
  fill("pink");
  noStroke();
  ellipse(0, 0, 75.000, 50.00);
}

function eye() {
  fill("black");
  noStroke();
  ellipse(0, 0, 28.000, 70.00);
}

function eye_shine() {
  fill("white");
  noStroke();
  circle(0, 0, 16.0000);
}

function cheek() {
  fill("red");
  noStroke();
  ellipse(0, 0, 42.000, 22.000);
}

function smile() {
  noFill();
  stroke("black");
  strokeWeight(4);
  arc(0, 0, 55.000, 35.000, 20., 160.);
}

function setup() {
  createCanvas(800, 600);
  angleMode(DEGREES);
  background(255);

  push();
  translate(235.000, 355.000);
  foot();
  pop();
  push();
  translate(365.000, 355.000);
  foot();
  pop();
  push();
  translate(175.000, 255.000);
  hand();
  pop();
  push();
  translate(425.000, 255.000);
  hand();
  pop();
  push();
  translate(300.00, 250.00);
  body();
  pop();
  push();
  translate(255.000, 220.00);
  eye();
  pop();
  push();
  translate(345.000, 220.00);
  eye();
  pop();
  push();
  translate(260.00, 200.00);
  eye_shine();
  pop();
  push();
  translate(350.00, 200.00);
  eye_shine();
  pop();
  push();
  translate(225.000, 265.000);
  cheek();
  pop();
  push();
  translate(375.000, 265.000);
  cheek();
  pop();
  push();
  translate(300.00, 270.00);
  smile();
  pop();
}
