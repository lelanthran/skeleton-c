
#include <stdio.h>
#include <stdlib.h>

#include "module_one.h"
#include "module_two.h"

int main (int argc, char **argv)
{
   int val = 12;
   argc = argc;
   argv = argv;

   printf ("Module one version: [%s]\n", MODULE_ONE_VERSION);
   printf ("Module two version: [%s]\n", MODULE_TWO_VERSION);

   printf ("Module one result [%i]: %x\n", val, module_one_example (val));
   printf ("Module two result [%i]: %x\n", val, module_two_example (val));
   return EXIT_FAILURE;
}

