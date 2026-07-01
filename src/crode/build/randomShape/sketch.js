// Generated from canvas "RandomShape"

function bubble() {
  fill("blue");
  noStroke();
  circle(0, 0, ((random(20., 40.) / 2.) * 2.0));
}

function stars() {
  fill("yellow");
  noStroke();
  {
    let outerR = (random(0., 30.));
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
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background("white");

  if ((random(0., 1.) < 0.95)) {
  push();
  translate((random(0., 780.)), (random(0., 200.)));
  rotate(0.0);
  stars();
  pop();
  } else {
  push();
  translate((random(0., 780.)), (random(0., 200.)));
  rotate(0.0);
  bubble();
  pop();
  }
}
