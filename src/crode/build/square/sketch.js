// Generated from canvas "Kirby"

function test() {
  fill("black");
  noStroke();
  square(0, 0, 50.00);
}

function setup() {
  createCanvas(800, 600);
  angleMode(DEGREES);
  background(255);

  push();
  translate(random(0.0, 800.0), random(0.0, 600.0));
  test();
  pop();
}
