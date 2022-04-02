#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>

void main(int argc, char **argv) {
   FILE *ifp;
   FILE *ofp;

   int address;
   char ascii;

   if (argc < 3) {
      printf("Usage: %s [source ASCII file] [converted hex file]\n", argv[0]);
      return;
   }

   ifp = fopen(argv[1], "r");
   if (ifp == NULL) {
      printf("Error opening %s for reading\n", argv[1]);
      return;
   }
   ofp = fopen(argv[2], "w");
   if (ofp == NULL) {
      printf("Error opening %s for writing\n", argv[2]);
      return;
   }

   ascii = fgetc(ifp);
   while (ascii != EOF) {
      if ((ascii >= '!') && (ascii <= 'Z')) {
         fprintf(ofp, "%02x00 ", ascii);
      } else if (ascii == ' ') {
         fprintf(ofp, "0000 ");
      } else if (ascii == '\n') {
         fprintf(ofp, "\n");
      }
      ascii = fgetc(ifp);
   }

   fclose(ifp);
   fclose(ofp);
}
