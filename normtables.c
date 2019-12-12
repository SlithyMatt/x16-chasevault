#include <stdio.h>
#include <math.h>

#define XFN "normx.txt"
#define YFN "normy.txt"

int main(int argc, char **argv) {
   FILE *ofp;

   ofp = fopen(XFN, "w");
   if (ofp == NULL) {
      printf("Error opening %s for writing\n", XFN);
      return -1;
   }

   double x;
   double y;
   double theta;
   int normx;
   double t01 = 0.5*(acos(0)-atan(4.0)) + atan(4.0);
   double t12 = 0.5*(atan(4.0)-atan(1.5)) + atan(1.5);
   double t23 = 0.5*(atan(1.5)-atan(1.0)) + atan(1.0);
   double t34 = 0.5*(atan(2.0/3.0)-atan(0.25)) + atan(0.25);

   for (x = 1; x <=128; x++) {
      for (y = 1; y <=128; y++) {
         theta = atan((double)x/(double)y);
         if (theta > t01) {
            normx = 0;
         } else if (theta > t12) {
            normx = 1;
         } else if (theta > t23) {
            normx = 2;
         } else if (theta > t34) {
            normx = 3;
         } else {
            normx = 4;
         }
         fprintf(ofp, "%d", normx);
      }
      fprintf(ofp, "\n");
   }

   fclose(ofp);

   ofp = fopen(YFN, "w");
   if (ofp == NULL) {
      printf("Error opening %s for writing\n", YFN);
      return -1;
   }

   int normy;
   t01 = atan(0.25)/2.0;
   t12 = 0.5*(atan(2.0/3.0)-atan(0.25)) + atan(0.25);
   t23 = 0.5*(atan(1.0)-atan(2.0/3.0)) + atan(2.0/3.0);
   t34 = 0.5*(atan(4.0)-atan(1.5)) + atan(1.5);

   for (x = 1; x <=128; x++) {
      for (y = 1; y <=128; y++) {
         theta = atan((double)x/(double)y);
         if (theta < t01) {
            normy = 0;
         } else if (theta < t12) {
            normy = 1;
         } else if (theta < t23) {
            normy = 2;
         } else if (theta < t34) {
            normy = 3;
         } else {
            normy = 4;
         }
         fprintf(ofp, "%d", normy);
      }
      fprintf(ofp, "\n");
   }

   fclose(ofp);


   return 0;
}
