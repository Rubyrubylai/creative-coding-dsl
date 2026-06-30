// Generated from canvas "Snow"

function snowflake() {
  fill("black");
  noStroke();
  circle(0, 0, (random(0.02, 0.06) * 2.0 * 100.0));
}

function bubble() {
  fill("blue");
  noStroke();
  circle(0, 0, ((random(0.2, 0.4) / 2.) * 2.0 * 100.0));
}

function block() {
  fill("red");
  noStroke();
  square(0, 0, (random(0.2, 0.4) * 100.0));
}

function setup() {
  createCanvas(800, 600);
  angleMode(DEGREES);
  background(255);

  for (let i = 0; i < 300; i++) {
  push();
  translate((random(0., 7.8) * 100.0), (random(0., 5.8) * 100.0));
  snowflake();
  pop();
  }
  for (let i = 0.; i < 8.; i += 0.5) {
  if (((i % 1.) === 0.5)) {
  push();
  translate((i * 100.0), (5. * 100.0));
  bubble();
  pop();
  } else {
  push();
  translate((i * 100.0), (5. * 100.0));
  block();
  pop();
  }
  }
}
