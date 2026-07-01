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

function stars() {
  fill("yellow");
  noStroke();
  {
    let outerR = (random(0., 0.3) * 100.0);
    let innerR = outerR * 0.4;
    beginShape();
    for (let i = 0; i < 5 * 2; i++) {
      let angle = (Math.PI / 5) * i - Math.PI / 2;
      let rad = (i % 2 === 0) ? outerR : innerR;
      vertex(rad * Math.cos(angle), rad * Math.sin(angle));
    }
    endShape(CLOSE);
  }
}

function setup() {
  createCanvas(800, 600);
  angleMode(DEGREES);
  background(255);

  for (let i = 0; i < 300; i++) {
  if ((random(0., 1.) < 0.95)) {
  push();
  translate((random(0., 7.8) * 100.0), (random(0., 5.8) * 100.0));
  snowflake();
  pop();
  } else {
  push();
  translate((random(0., 7.8) * 100.0), (random(0., 2.) * 100.0));
  stars();
  pop();
  }
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
