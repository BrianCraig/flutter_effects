// returns .5 if the function is between [0, 1]
// otherwise returns 0 if negative, or 1 if larger than 1
float debug0to1(float x) {
    if(x < -4) {
        return 0;
    }
    if(x > 4) {
        return 1;
    }
    return .5;
}

// returns .5 if the function is between [-1, 1]
// otherwise returns 0 if less than -1, or 1 if larger than 1
float debugN1to1(float x) {
    if(x < -1) {
        return 0;
    }
    if(x > 1) {
        return 1;
    }
    return .5;
}

// [-3, 3] to [0, 1], unclamped
vec4 simplexFixer(vec4 x) {
    return x / 6 + .5;
}

vec3 debugValue(float val) {
    if(val < -1)
    return vec3(1.0, 0, 0);
    if(val < -0.5)
    return vec3(0.6, 0, 0);
    if(val < 0)
    return vec3(1, 0, 0);
    if(val < 0.2)
    return vec3(0.1, 0.2, 0);
    if(val < 0.8)
    return vec3(0, 1, 0);
    if(val < 1)
    return vec3(0, 0.2, 0.1);
    if(val < 1.5)
    return vec3(0, 0, 1);
    if(val < 2)
    return vec3(0, 0, 0.6);
    return vec3(0, 0, 1);
}
