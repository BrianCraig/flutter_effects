// rounds to nearest fraction, example
// nearStep(0.78, 5) => 0.75
// it will fall in the nearest of 5 steps
// [dec(x).0, dec(x).25, dec(x).5, dec(x).75, dec(x)+1.0]
float nearStep(float x, int steps){
    return round(x * (steps - 1)) / (steps - 1);
}
