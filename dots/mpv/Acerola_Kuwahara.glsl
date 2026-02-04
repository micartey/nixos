//!HOOK MAIN
//!BIND HOOKED
//!DESC Kuwahara Filter

#define RADIUS 3

vec4 hook() {
    vec2 size = HOOKED_size;
    vec2 pos = HOOKED_pos;

    vec4 m[4];
    vec3 s[4];
    for (int i = 0; i < 4; i++) {
        m[i] = vec4(0.0);
        s[i] = vec3(0.0);
    }

    for (int j = -RADIUS; j <= 0; j++) {
        for (int i = -RADIUS; i <= 0; i++) {
            vec3 c = HOOKED_texOff(vec2(i, j)).rgb;
            m[0] += vec4(c, 1.0);
            s[0] += c * c;
        }
    }

    for (int j = -RADIUS; j <= 0; j++) {
        for (int i = 0; i <= RADIUS; i++) {
            vec3 c = HOOKED_texOff(vec2(i, j)).rgb;
            m[1] += vec4(c, 1.0);
            s[1] += c * c;
        }
    }

    for (int j = 0; j <= RADIUS; j++) {
        for (int i = 0; i <= RADIUS; i++) {
            vec3 c = HOOKED_texOff(vec2(i, j)).rgb;
            m[2] += vec4(c, 1.0);
            s[2] += c * c;
        }
    }

    for (int j = 0; j <= RADIUS; j++) {
        for (int i = -RADIUS; i <= 0; i++) {
            vec3 c = HOOKED_texOff(vec2(i, j)).rgb;
            m[3] += vec4(c, 1.0);
            s[3] += c * c;
        }
    }

    float min_sigma2 = 1e+20;
    vec4 result = vec4(0.0);

    for (int i = 0; i < 4; i++) {
        m[i].rgb /= m[i].a;
        s[i] = abs(s[i] / m[i].a - m[i].rgb * m[i].rgb);
        float sigma2 = s[i].r + s[i].g + s[i].b;
        if (sigma2 < min_sigma2) {
            min_sigma2 = sigma2;
            result = vec4(m[i].rgb, 1.0);
        }
    }

    return result;
}
