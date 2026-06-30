// Generated from canvas "Snow"

function snowflake() {
  fill("black");
  noStroke();
  circle(0, 0, 10.0000);
}

function setup() {
  createCanvas(800, 600);
  angleMode(DEGREES);
  background(255);

  for (let i = 0; i < 300; i++) {
  push();
  translate(random(0.0, 780.00), random(0.0, 580.00));
  snowflake();
  pop();
  }
}
