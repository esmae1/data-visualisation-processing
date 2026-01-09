class Observation {
  String location;
  float hour;
  String trigger;
  int day;
  
  Observation(int d, String loc, float h, String trig) {
    day = d;
    location = loc;
    hour = h;
    trigger = trig;
  }
}
