// Generated from canvas "Square"

function setup() {
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background("white");

  let x = random(0., 800.);
  let y = random(0., 600.);
  let angle = 45.;
function test() {
  fill("black");
  noStroke();
  square(0, 0, (50.));
}

  push();
  translate((x), (y));
  rotate(angle);
  test();
  pop();
}
