//!HOOK MAIN
//!BIND HOOKED
//!DESC AcerolaFX Standard ASCII

#define BLOCK_SIZE 8.0

float get_bit_std(uint mask, int bit) {
    return float((mask >> uint(bit)) & 1u);
}

float get_char_mask_std(int char_index, vec2 p) {
    int x = int(p.x);
    int y = int(p.y);
    int bit = x + y * 8;
    uint mask_lo = 0u;
    uint mask_hi = 0u;

    if (char_index == 0) return 0.0;
    else if (char_index == 1) { mask_lo = 0x00000000u; mask_hi = 0x00001800u; }
    else if (char_index == 2) { mask_lo = 0x00001800u; mask_hi = 0x00001800u; }
    else if (char_index == 3) { mask_lo = 0x00000000u; mask_hi = 0x0000FF00u; }
    else if (char_index == 4) { mask_lo = 0x181818FFu; mask_hi = 0x00001818u; }
    else if (char_index == 5) { mask_lo = 0x3C66663Cu; mask_hi = 0x00000000u; }
    else if (char_index == 6) { mask_lo = 0x663C3C66u; mask_hi = 0x663C3C66u; }
    else if (char_index == 7) { mask_lo = 0x3C66663Cu; mask_hi = 0x3C66663Cu; }
    else if (char_index == 8) { mask_lo = 0x66FF66FFu; mask_hi = 0x66FF66FFu; }
    else { mask_lo = 0xFFFFFFFFu; mask_hi = 0xFFFFFFFFu; }

    if (bit < 32) return get_bit_std(mask_lo, bit);
    else return get_bit_std(mask_hi, bit - 32);
}

vec4 hook() {
    vec2 pos = HOOKED_pos;
    vec2 tex_size = HOOKED_size;
    vec2 pix_pos = pos * tex_size;
    
    vec2 block_idx = floor(pix_pos / BLOCK_SIZE);
    vec2 local_pos = floor(mod(pix_pos, BLOCK_SIZE));
    vec2 block_center_uv = (block_idx + 0.5) * BLOCK_SIZE / tex_size;
    
    // Use the exact same sampling method as the working Shader 9
    vec3 col = texture(HOOKED_raw, block_center_uv).rgb;
    float luma = dot(col, vec3(0.2126, 0.7152, 0.0722));
    int char_index = int(clamp(luma * 10.0, 0.0, 9.0));
    
    float mask = get_char_mask_std(char_index, local_pos);
    return vec4(vec3(1.0) * mask, 1.0);
}
