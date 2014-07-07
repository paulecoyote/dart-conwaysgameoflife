import 'dart:html';
import 'dart:async';
import 'culture.dart';
import 'dart:math';

CanvasElement ce;
CanvasRenderingContext2D c2d;
var rng = new Random();

var redCells = new culture();
var greenCells = new culture();
var blueCells = new culture();
var yellowCells = new culture();
var cultures = [redCells,greenCells,blueCells,yellowCells];
Stopwatch stopWatch = new Stopwatch();
var lastTime = null;

// Main Entry point.
void main() {

  CanvasElement ce = querySelector('#surface');
  c2d = ce.getContext("2d");

  int cells = 699 + rng.nextInt(99);

  redCells.initPopulation(cells);
  greenCells.initPopulation(cells~/1.1);
  blueCells.initPopulation(cells~/1.2);
  yellowCells.initPopulation(cells~/1.3);
  stopWatch.start();
  lastTime = stopWatch.elapsedMicroseconds;
  window.animationFrame.then(updateAll);
}

// Draw all the 4 cultures.
void drawAll() {
  c2d.setFillColorRgb(0, 0, 0);
  c2d.fillRect(0, 0, 800, 800);

  draw(redCells, true, false, false);
  draw(greenCells, false, true, false);
  draw(blueCells, false, false, true);
  draw(yellowCells, true, true, false);

  c2d.setFillColorRgb(255, 255, 255);
  var newTime = stopWatch.elapsedMicroseconds;
  var diff = newTime - lastTime;
  var fps = 1000000 / (diff);
  c2d.fillText("FPS: ${fps.toStringAsFixed(1)}", 10, 10);
  lastTime = newTime;
}

// Update all the cultures.
void updateAll(num delta) {
  cultures.forEach((c)=>c.update());
  drawAll();
  window.animationFrame.then(updateAll);
}

// Draw out all cells in the culture.
void draw(culture aCulture, bool red, bool green, bool blue) {

  var myCulture = aCulture;
  int w = myCulture.width;
  int pixel = 10;

  for (int x = 0; x < w; x++) {
    for (int y = 0; y < w; y++) {
      var c = myCulture.cellDish["$x-$y"];

      if (c.state != 0) {

        int colLevel = ((x * y) * c.age * c.updates) % 255;
        int r = red ? colLevel : 0;
        int g = green ? colLevel : 0;
        int b = blue ? colLevel : 0;
        c2d.setFillColorRgb( r, g, b, 128);

        c2d.beginPath();
        c2d.arc(x * pixel + pixel / 2, y * pixel + pixel / 2, pixel / 2, 0, 6.28);
        c2d.fill();
      }

    }
  }

}
