// Generated from canvas "DrawNumber"

function setup() {
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background("white");

function snowflake() {
  fill("black");
  noStroke();
  circle(0, 0, (random(2., 6.) * 2.0));
}

  let i = (0. + snowflake);
  push();
  translate((100.), (100.));
  rotate(0.0);
  snowflake();
  pop();
}
