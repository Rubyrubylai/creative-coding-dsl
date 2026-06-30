// Generated from canvas "Snow"

function snowflake() {
  fill("black");
  noStroke();
  circle(0, 0, 10.0000);
}

function bubble() {
  fill("blue");
  noStroke();
  circle(0, 0, 40.000);
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
  for (let i = 0.; i < 8.; i += 0.6) {
  push();
  translate((i * 100.0), 500.0);
  bubble();
  pop();
  }
}
