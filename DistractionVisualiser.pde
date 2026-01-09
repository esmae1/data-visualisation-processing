Table table;
int numDays = 25;
int rows = 5;
int cols = 5;

String[] triggers = {"Phone","Noise","Thought","Hunger"};
color[] triggerColors = {color(290,204,255), 
color(153,204,255), 
color(255,204,229), 
color(204,255,229)};

// each day stores multiple observations
ArrayList<Observation>[] days = new ArrayList[numDays];

void setup() {
  size(1000, 800);
  background(255);
  noLoop();
  
  // initialise days
  for (int i = 0; i < numDays; i++) days[i] = new ArrayList<Observation>();
  
  // loads the csv
  table = loadTable("distractions.csv","header");
  
  for (TableRow row : table.rows()) {
    int day = row.getInt("day") - 1; // 0-indexed
    String loc = row.getString("location");
    float hour = row.getFloat("hour");
    String trig = row.getString("trigger");
    days[day].add(new Observation(day, loc, hour, trig));
  }
  
  // draws the grid of circles
  int count = 0;
  float startX = 100;
  float startY = 100;
  float spacingX = 180;
  float spacingY = 150;
  
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      if (count >= numDays) break;
      float x = startX + c * spacingX;
      float y = startY + r * spacingY;
      drawDayCircle(x, y, days[count]);
      count++;
    }
  }
  
  drawLegend();
}

// draws each individual circle 
void drawDayCircle(float x, float y, ArrayList<Observation> obsList) {
  fill(200);
  noStroke();
  ellipse(x, y, 80, 80); // main circle
  
  strokeWeight(2);
  
  for (Observation o : obsList) {
    stroke(getTriggerColor(o.trigger));
    pushMatrix();
    translate(x, y);
    float angle = map(o.hour, 0, 24, 0, TWO_PI); // simple map 0-24 hours to 0-360 degrees
    rotate(angle - PI/2); // start at top
    line(0, 0, 60, 0); // all lines same length
    popMatrix();
  }
  
  fill(0);
  textAlign(CENTER);
  textSize(14);
  text(getMostCommonLocation(obsList), x, y + 60);
}

color getTriggerColor(String t) {
  for (int i = 0; i < triggers.length; i++) {
    if (triggers[i].equals(t)) return triggerColors[i];
  }
  return color(0);
}

String getMostCommonLocation(ArrayList<Observation> obsList) {
  if (obsList.size() == 0) return "None";
  HashMap<String,Integer> counts = new HashMap<String,Integer>();
  for (Observation o : obsList) {
    if (!counts.containsKey(o.location)) counts.put(o.location,1);
    else counts.put(o.location, counts.get(o.location)+1);
  }
  String most = "";
  int maxCount = 0;
  for (String k : counts.keySet()) {
    if (counts.get(k) > maxCount) {
      maxCount = counts.get(k);
      most = k;
    }
  }
  return most;
}

void drawLegend() {
  fill(0);
  textAlign(LEFT);
  textSize(14);
  int startX = 900;
  int startY = 400;
  
  for (int i = 0; i < triggers.length; i++) {
    fill(triggerColors[i]);
    rect(startX, startY + i*25, 20, 20);
    fill(0);
    text(triggers[i], startX + 30, startY + i*25 + 15);
  }
}
