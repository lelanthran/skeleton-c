
#include <stdio.h>
#include <stdlib.h>

#include "module_one.h"
#include "module_two.h"

/* **********************************************************************
 * This is bare bones; the full example for how to use the framework to
 * write an intuitive command-line interface is in example1_cli.c - this
 * file is only to show that the C++ building works fine.
 */
int main (void)
{
   int val = 12;

   printf ("Module one version: [%s]\n", MODULE_ONE_VERSION);
   printf ("Module two version: [%s]\n", MODULE_TWO_VERSION);

   printf ("Module one result [%i]: %x\n", val, module_one_example (val));
   printf ("Module two result [%i]: %x\n", val, module_two_example (val));
   return EXIT_FAILURE;
}

