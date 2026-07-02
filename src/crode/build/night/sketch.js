// Generated from canvas "Night"

function setup() {
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background("black");

function snowflake() {
  fill("white");
  noStroke();
  circle(0, 0, (random(2., 6.) * 2.0));
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

  for (let $crode_repeat_i = 0; $crode_repeat_i < 300; $crode_repeat_i++) {
  if ((random(0., 1.) < 0.5)) {
  push();
  translate((random(0., 780.)), (random(0., 580.)));
  rotate(0.0);
  snowflake();
  pop();
  } else {
  push();
  translate((random(0., 780.)), (random(0., 200.)));
  rotate(random(0., 90.));
  stars();
  pop();
  }
  }
}
