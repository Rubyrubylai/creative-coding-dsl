// Generated from canvas "Square"

function test() {
  fill("black");
  noStroke();
  square(0, 0, (50.));
}

function setup() {
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background("white");

  push();
  translate((random(0., 800.)), (random(0., 600.)));
  rotate(0.0);
  test();
  pop();
}
