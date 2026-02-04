//!HOOK MAIN
//!BIND HOOKED
//!DESC AcerolaFX Advanced ASCII (Edge Overlay)

#define BLOCK_SIZE 5
#define EDGE_STRENGTH 1.5

float get_bit(uint mask, int bit) {
    return float((mask >> uint(bit)) & 1u);
}

float get_char_mask(int char_index, vec2 p) {
    int x = int(p.x);
    int y = int(p.y);
    int bit = x + y * 8;
    uint mask_lo = 0u;
    uint mask_hi = 0u;

    if (char_index == 0) return 0.0;
    // Edge characters
    else if (char_index == 10) { // |
        mask_lo = 0x18181818u;
        mask_hi = 0x18181818u;
    } else if (char_index == 11) { // -
        mask_lo = 0x0000FF00u;
        mask_hi = 0x00FF0000u;
    } else if (char_index == 12) { // /
        mask_lo = 0x80402010u;
        mask_hi = 0x08040201u;
    } else if (char_index == 13) { // \
                                        mask_lo = 0x01020408u; mask_hi = 0x10204080u;
    }
    // Density characters
    else if (char_index == 1) {
        mask_lo = 0x00000000u;
        mask_hi = 0x00001800u;
    }
    else if (char_index == 2) {
        mask_lo = 0x00001800u;
        mask_hi = 0x00001800u;
    }
    else if (char_index == 3) {
        mask_lo = 0x00000000u;
        mask_hi = 0x0000FF00u;
    }
    else if (char_index == 4) {
        mask_lo = 0x18181800u;
        mask_hi = 0x00181818u;
    }
    else if (char_index == 5) {
        mask_lo = 0x3C66663Cu;
        mask_hi = 0x00000000u;
    }
    else if (char_index == 6) {
        mask_lo = 0x663C3C66u;
        mask_hi = 0x663C3C66u;
    }
    else if (char_index == 7) {
        mask_lo = 0x3C66663Cu;
        mask_hi = 0x3C66663Cu;
    }
    else if (char_index == 8) {
        mask_lo = 0x66FF66FFu;
        mask_hi = 0x66FF66FFu;
    }
    else {
        mask_lo = 0xFFFFFFFFu;
        mask_hi = 0xFFFFFFFFu;
    }

    if (bit < 32) return get_bit(mask_lo, bit);
    else return get_bit(mask_hi, bit - 32);
}

vec4 hook() {
    vec2 pos = HOOKED_pos;
    vec2 tex_size = HOOKED_size;
    vec2 pix_pos = pos * tex_size;
    vec2 block_index = floor(pix_pos / float(BLOCK_SIZE));
    vec2 local_pos = floor(mod(pix_pos, float(BLOCK_SIZE)));
    vec2 block_center_uv = (block_index + 0.5) * float(BLOCK_SIZE) / tex_size;

    // Part 1: Density base
    vec3 block_col = texture(HOOKED_raw, block_center_uv).rgb;
    float luma = dot(block_col, vec3(0.2126, 0.7152, 0.0722));
    int density_idx = int(clamp(luma * 10.0, 0.0, 9.0));
    float density_mask = get_char_mask(density_idx, local_pos);

    // Part 2: Edge detection overlay
    float tl = dot(texture(HOOKED_raw, pos + vec2(-1, -1) / tex_size).rgb, vec3(0.333));
    float tc = dot(texture(HOOKED_raw, pos + vec2(0, -1) / tex_size).rgb, vec3(0.333));
    float tr = dot(texture(HOOKED_raw, pos + vec2(1, -1) / tex_size).rgb, vec3(0.333));
    float ml = dot(texture(HOOKED_raw, pos + vec2(-1, 0) / tex_size).rgb, vec3(0.333));
    float mr = dot(texture(HOOKED_raw, pos + vec2(1, 0) / tex_size).rgb, vec3(0.333));
    float bl = dot(texture(HOOKED_raw, pos + vec2(-1, 1) / tex_size).rgb, vec3(0.333));
    float bc = dot(texture(HOOKED_raw, pos + vec2(0, 1) / tex_size).rgb, vec3(0.333));
    float br = dot(texture(HOOKED_raw, pos + vec2(1, 1) / tex_size).rgb, vec3(0.333));

    float gx = (tl + 2.0 * ml + bl) - (tr + 2.0 * mr + br);
    float gy = (tl + 2.0 * tc + tr) - (bl + 2.0 * bc + br);
    float mag = length(vec2(gx, gy)) * EDGE_STRENGTH;

    float final_mask = density_mask;

    if (mag > 0.2) {
        float angle = atan(gy, gx) / 3.14159265;
        float abs_angle = abs(angle);
        int edge_idx;
        if (abs_angle < 0.125 || abs_angle > 0.875) edge_idx = 10;
        else if (abs_angle > 0.375 && abs_angle < 0.625) edge_idx = 11;
        else if (angle > 0.0) edge_idx = 12;
        else edge_idx = 13;

        float edge_mask = get_char_mask(edge_idx, local_pos);
        final_mask = mix(density_mask, edge_mask, clamp(mag, 0.0, 1.0));
    }

    return vec4(block_col * final_mask, 1.0);
}
