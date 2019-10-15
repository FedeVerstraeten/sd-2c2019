#include <stdio.h>

#define BYTE_TO_BINARY_PATTERN "%c%c%c%c"
#define BYTE_TO_BINARY(byte)  \
  (byte & 0x80 ? '1' : '0'), \
  (byte & 0x40 ? '1' : '0'), \
  (byte & 0x20 ? '1' : '0'), \
  (byte & 0x10 ? '1' : '0'), \
  (byte & 0x08 ? '1' : '0'), \
  (byte & 0x04 ? '1' : '0'), \
  (byte & 0x02 ? '1' : '0'), \
  (byte & 0x01 ? '1' : '0') 

//assumes little endian
void printBits(size_t const size, void const * const ptr)
{
    unsigned char *b = (unsigned char*) ptr;
    unsigned char byte;
    int i, j;

    for (i=size-1;i>=0;i--)
    {
        for (j=7;j>=0;j--)
        {
            byte = (b[i] >> j) & 1;
            printf("%u", byte);
        }
    }
    puts("");
}

int main(int argc,char* argv[])
{
  unsigned int byte_a=0x0;
  unsigned int byte_b=0x0;
  unsigned int byte_s=0x0;
  
  byte_a=(unsigned int)atoi(argv[1]); 
  byte_b=(unsigned int)atoi(argv[2]); 
  byte_s=(unsigned int)atoi(argv[3]); 
  
  fprintf(stdout, "uint: %u + %u = %u\n",byte_a,byte_b,byte_s);
  fprintf(stdout, "  0b"); 
  printBits(sizeof(byte_a), &byte_a);
  fprintf(stdout, "+ 0b"); 
  printBits(sizeof(byte_b), &byte_b);
  fprintf(stdout, "= 0b"); 
  printBits(sizeof(byte_s), &byte_s);
  return 0;
}
