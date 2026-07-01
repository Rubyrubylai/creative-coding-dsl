// Generated from canvas "Square"

function test() {
  fill("black");
  noStroke();
  square(0, 0, (50.));
}

function setup() {
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background(255);

  push();
  translate((random(0., 800.)), (random(0., 600.)));
  test();
  pop();
}
