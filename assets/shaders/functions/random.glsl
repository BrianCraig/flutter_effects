

//get a scalar random value from a 3d value
float random(vec3 value, vec3 dotDir){
    //get scalar value from 3d vector
    float random = dot(value, dotDir);
    //make value more random by making it bigger and then taking teh factional part
    random = fract(sin(random) * 143758.5453);
    return random;
}

float random(vec3 value) {
    return random(value, vec3(12.9898, 78.233, 37.719));
}

//get a scalar random value from a 2d value
float random(vec2 value, vec2 dotDir){
    //get scalar value from 3d vector
    float random = dot(value, dotDir);
    //make value more random by making it bigger and then taking teh factional part
    random = fract(sin(random) * 143758.5453);
    return random;
}

float random(vec2 value){
    return random(value, vec2(12.9898, 78.233));
}


vec3 random3(vec2 value){
    return vec3(
        random(value, vec2(12.989, 78.233)),
        random(value, vec2(39.346, 11.135)),
        random(value, vec2(73.156, 52.235))
    );
}