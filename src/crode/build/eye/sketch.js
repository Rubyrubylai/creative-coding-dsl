// Generated from canvas "Eye"

function eye() {
  fill("black");
  noStroke();
  circle(0, 0, (30. * 2.0));
}

function setup() {
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background(255);

  push();
  translate((80.), (50.));
  eye();
  pop();
}
