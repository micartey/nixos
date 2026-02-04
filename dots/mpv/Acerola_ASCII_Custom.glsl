//!HOOK MAIN
//!BIND HOOKED
//!DESC AcerolaFX ASCII (Adjustable)

// Edit these values here to customize:
#define block_size 3.0
#define exposure 1.3
#define blend_base 1.0     // 0.0 = white text, 1.0 = original colors
#define saturation 0.8     // 0.0 = black & white, 1.0 = full color
#define hue_shift 0.0      // 0.0 to 1.0
#define edge_strength 2
#define edge_threshold 0.2

// Helper for hue shift
vec3 hue_rotate(vec3 col, float hue) {
    vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(hue * 6.2831853);
    return col * cosAngle + cross(k, col) * sin(hue * 6.2831853) + k * dot(k, col) * (1.0 - cosAngle);
}

float get_bit_adj(uint mask, int bit) {
    return float((mask >> uint(bit)) & 1u);
}

float get_char_mask_adj(int char_index, vec2 p) {
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
        mask_lo = 0x181818FFu;
        mask_hi = 0x00001818u;
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

    if (bit < 32) return get_bit_adj(mask_lo, bit);
    else return get_bit_adj(mask_hi, bit - 32);
}

vec4 hook() {
    vec2 pos = HOOKED_pos;
    vec2 tex_size = HOOKED_size;
    vec2 pix_pos = pos * tex_size;

    vec2 block_index = floor(pix_pos / block_size);
    vec2 local_pos = floor(mod(pix_pos, block_size)) * (8.0 / block_size);
    vec2 block_center_uv = (block_index + 0.5) * block_size / tex_size;

    vec3 col = texture(HOOKED_raw, block_center_uv).rgb;
    float luma = dot(col, vec3(0.2126, 0.7152, 0.0722)) * exposure;
    int char_index = int(clamp(luma * 10.0, 0.0, 9.0));

    float density_mask = get_char_mask_adj(char_index, local_pos);

    // Edge detection (Sobel)
    vec3 luma_coeffs = vec3(0.2126, 0.7152, 0.0722);
    float tl = dot(texture(HOOKED_raw, pos + vec2(-1, -1) / tex_size).rgb, luma_coeffs);
    float tc = dot(texture(HOOKED_raw, pos + vec2(0, -1) / tex_size).rgb, luma_coeffs);
    float tr = dot(texture(HOOKED_raw, pos + vec2(1, -1) / tex_size).rgb, luma_coeffs);
    float ml = dot(texture(HOOKED_raw, pos + vec2(-1, 0) / tex_size).rgb, luma_coeffs);
    float mr = dot(texture(HOOKED_raw, pos + vec2(1, 0) / tex_size).rgb, luma_coeffs);
    float bl = dot(texture(HOOKED_raw, pos + vec2(-1, 1) / tex_size).rgb, luma_coeffs);
    float bc = dot(texture(HOOKED_raw, pos + vec2(0, 1) / tex_size).rgb, luma_coeffs);
    float br = dot(texture(HOOKED_raw, pos + vec2(1, 1) / tex_size).rgb, luma_coeffs);

    float gx = (tl + 2.0 * ml + bl) - (tr + 2.0 * mr + br);
    float gy = (tl + 2.0 * tc + tr) - (bl + 2.0 * bc + br);
    float mag = length(vec2(gx, gy)) * edge_strength;

    float final_mask = density_mask;

    if (mag > edge_threshold) {
        float angle = atan(gy, gx) / 3.14159265;
        float abs_angle = abs(angle);
        int edge_idx;
        if (abs_angle < 0.125 || abs_angle > 0.875) edge_idx = 10;
        else if (abs_angle > 0.375 && abs_angle < 0.625) edge_idx = 11;
        else if (angle > 0.0) edge_idx = 12;
        else edge_idx = 13;

        float edge_mask = get_char_mask_adj(edge_idx, local_pos);
        final_mask = mix(density_mask, edge_mask, clamp(mag, 0.0, 1.0));
    }

    // Color Processing
    vec3 text_col = mix(vec3(1.0), col, blend_base);

    // Saturation & Hue Shift
    float text_luma = dot(text_col, luma_coeffs);
    text_col = mix(vec3(text_luma), text_col, saturation);

    if (hue_shift != 0.0) {
        text_col = hue_rotate(text_col, hue_shift);
    }

    return vec4(text_col * final_mask, 1.0);
}
