int[] hex = int[] ( 432534, 287812, 431151, 492679, 630664, 989063, 923542, 1016866, 431766, 433799, 434073, 497559, 921886, 498071, 988959, 988945);

bool drawHex4(int value, vec2 coord, vec2 pos)
{
    if (coord.x < pos.x || coord.y < pos.y) return false;
    ivec2 p = ivec2((coord - pos) / 2.);
    int dig = p.x / 5;
    p.x = p.x - dig * 5;
    if (dig >= 0 && dig < 4 && p.y < 5 && p.x < 4)
    {
        int v = hex[(value >> (12 - dig * 4)) & 15];
        return (v & (1 << (p.x + p.y * 4))) != 0;
    }
    return false;
}