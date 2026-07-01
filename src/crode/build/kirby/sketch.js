// Generated from canvas "Kirby"

function body() {
  fill("pink");
  noStroke();
  circle(0, 0, (135. * 2.0));
}

function foot() {
  fill("red");
  noStroke();
  ellipse(0, 0, (105.), (45.));
}

function hand() {
  fill("pink");
  noStroke();
  ellipse(0, 0, (75.), (50.));
}

function eye() {
  fill("black");
  noStroke();
  ellipse(0, 0, (28.), (70.));
}

function eye_shine() {
  fill("white");
  noStroke();
  circle(0, 0, (8. * 2.0));
}

function cheek() {
  fill("red");
  noStroke();
  ellipse(0, 0, (42.), (22.));
}

function smile() {
  noFill();
  stroke("black");
  strokeWeight(4);
  arc(0, 0, (55.), (35.), (20.), (160.));
}

function setup() {
  createCanvas(800., 600.);
  angleMode(DEGREES);
  background(255);

  push();
  translate((235.), (355.));
  foot();
  pop();
  push();
  translate((365.), (355.));
  foot();
  pop();
  push();
  translate((175.), (255.));
  hand();
  pop();
  push();
  translate((425.), (255.));
  hand();
  pop();
  push();
  translate((300.), (250.));
  body();
  pop();
  push();
  translate((255.), (220.));
  eye();
  pop();
  push();
  translate((345.), (220.));
  eye();
  pop();
  push();
  translate((260.), (200.));
  eye_shine();
  pop();
  push();
  translate((350.), (200.));
  eye_shine();
  pop();
  push();
  translate((225.), (265.));
  cheek();
  pop();
  push();
  translate((375.), (265.));
  cheek();
  pop();
  push();
  translate((300.), (270.));
  smile();
  pop();
}
