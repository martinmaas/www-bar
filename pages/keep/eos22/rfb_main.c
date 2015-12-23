#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "encoding.h"
#include "teapot.h"

static const uint32_t width = 256;
static const uint32_t height = 192;
static const uint32_t bpp = 32;
static uint32_t fb[256 * 192] __attribute__((aligned(256)));

void pixel_shade(float* out_colors, float* pos, float* norm, float* lightPosition, float* lightColor);

void write_tohost(uint8_t device, uint8_t cmd, uint64_t payload)
{
  uint64_t reg = 0;
  reg |= ((uint64_t)device << 56);
  reg |= ((uint64_t)cmd << 48);
  reg |= (payload << 16 >> 16);
  write_csr(tohost, reg);
}

uint64_t read_fromhost()
{
  uint64_t reg;
  while (1) {
    reg = swap_csr(fromhost, 0);
    if (reg != 0) break;
  }
  return reg;
}

int enumerate_devices()
{
  char id[64] __attribute__((aligned(64)));
  for (int idx=0; idx<256; idx++) {
    write_tohost(idx, -1, ((uint64_t)id << 8)|0xFF);
    read_fromhost();
    printf("id=%s\n", id);
    if (strcmp(id, "rfb") == 0) {
      return idx;
    }
  }
  return -1;
}

void configure_rfb(int rfb)
{
  uint64_t magic_constant = 0;
  magic_constant |= ((uint64_t)width << 48 >> 48);
  magic_constant |= ((uint64_t)height << 48 >> 32);
  magic_constant |= ((uint64_t)bpp << 48 >> 16);
  printf("rfb=%d, magic_constant=%x, fb=%x\n", rfb, magic_constant, fb);
  write_tohost(rfb, 0, magic_constant);
  read_fromhost();
  write_tohost(rfb, 1, (uint64_t)fb);
  read_fromhost();
}

char get_char()
{
  write_tohost(1, 0, 0);
  return read_fromhost() << 56 >> 56;
}

int main(int argc, char** argv)
{
  int rfb = enumerate_devices();
  configure_rfb(rfb);
  printf("rfb up and running at %d!\n", rfb);
  float lpos[3] = {1.0f, 1.0f, 1.0f};
  float lcolor[3] = {2.0f, 2.0f, 2.0f};
  while (1) {
    signed char* obj = teapot;
    for (int i=0; i<width*height; i++) {
      float pos[3] = {(float)obj[0]*0.03f, (float)obj[1]*0.03f, (float)obj[2]*0.03f};
      float norm[3] = {(float)obj[3]*0.03f, (float)obj[4]*0.03f, (float)obj[5]*0.03f};
      float out[4];
      pixel_shade(out, pos, norm, lpos, lcolor);
      uint8_t r = out[0] * 255.0f;
      uint8_t g = out[1] * 255.0f;
      uint8_t b = out[2] * 255.0f;
      fb[i] = (b << 16) | (g << 8) | r;
      obj += 6;
    }
    char ch = get_char();
    if (ch == 'd') {
      lpos[0] += 1.0f;
      printf("move light to right. %d %d %d\n", (int)lpos[0], (int)lpos[1], (int)lpos[2]);
    }
    if (ch == 'a') {
      lpos[0] -= 1.0f;
      printf("move light to left. %d %d %d\n", (int)lpos[0], (int)lpos[1], (int)lpos[2]);
    }
    if (ch == 'w') {
      lpos[1] += 1.0f;
      printf("move light to up. %d %d %d\n", (int)lpos[0], (int)lpos[1], (int)lpos[2]);
    }
    if (ch == 's') {
      lpos[1] -= 1.0f;
      printf("move light to down. %d %d %d\n", (int)lpos[0], (int)lpos[1], (int)lpos[2]);
    }
    if (ch == 'z') {
      lpos[2] += 1.0f;
      printf("move light to back. %d %d %d\n", (int)lpos[0], (int)lpos[1], (int)lpos[2]);
    }
    if (ch == 'x') {
      lpos[2] -= 1.0f;
      printf("move light to forward. %d %d %d\n", (int)lpos[0], (int)lpos[1], (int)lpos[2]);
    }
    if (ch == 'r') {
      lcolor[2] -= 0.1f;
      printf("r-- %d %d %d\n", (int)(lcolor[2]*256), (int)(lcolor[1]*256), (int)(lcolor[0]*256));
    }
    if (ch == 'R') {
      lcolor[2] += 0.1f;
      printf("r++ %d %d %d\n", (int)(lcolor[2]*256), (int)(lcolor[1]*256), (int)(lcolor[0]*256));
    }
    if (ch == 'g') {
      lcolor[1] -= 0.1f;
      printf("g-- %d %d %d\n", (int)(lcolor[2]*256), (int)(lcolor[1]*256), (int)(lcolor[0]*256));
    }
    if (ch == 'G') {
      lcolor[1] += 0.1f;
      printf("g++ %d %d %d\n", (int)(lcolor[2]*256), (int)(lcolor[1]*256), (int)(lcolor[0]*256));
    }
    if (ch == 'b') {
      lcolor[0] -= 0.1f;
      printf("b-- %d %d %d\n", (int)(lcolor[2]*256), (int)(lcolor[1]*256), (int)(lcolor[0]*256));
    }
    if (ch == 'B') {
      lcolor[0] += 0.1f;
      printf("b++ %d %d %d\n", (int)(lcolor[2]*256), (int)(lcolor[1]*256), (int)(lcolor[0]*256));
    }
  }
  return 0;
}
