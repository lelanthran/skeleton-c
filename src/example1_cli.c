
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "module_one.h"
#include "module_two.h"

/* *******************************************************************
 * This is a basic command-line driven program:
 * 1. All the inputs are specified on the command-line.
 * 2. The program will perform a single action based on the command, the
 *    command arguments and whatver options are passed to the command
 *    line.
 * 3. The program will then return the result of that command to the
 *    environment.
 */



/* *******************************************************************
 * Functions for parsing the command-line.
 */
static const char *find_opt (const char **lopts, const char *lname,
                             const char **sopts, char sname);

static bool process_args (int argc, char **argv,
                          char ***args, char ***lopts, char ***sopts);

/* *******************************************************************
 * Functions for the help system.
 */
static void print_help_msg (const char *cmd)
{
#define COMMAND_HELP    \
"  help <command>",\
"     Provide the help message for the specified command <command>.",\
""

#define COMMAND_SQUARE    \
"  square <number>",\
"     Multiply the specified <number> by itself and print the output. If",\
"     <number> cannot be parsed as an integer an error message will be",\
"     printed.",\
""

   static const struct {
      const char *cmd;
      const char *msg[20];
   } cmd_help[] = {
      { "help",                  { COMMAND_HELP             }  },
      { "square",                { COMMAND_SQUARE           }  },
   };

   static const char *msg[] = {
"Example C program: A command-line program to serve as a template for a",
"command-line driven program.",
"",
"-----",
"USAGE",
"-----",
"     example1_cli help <command>",
"     example1_cli [options] <command>",
"     example1_cli <command> [options]",
"",
"The first form of usage displays the builtin help on the specified command.",
"The second and third forms of usage are identical in behaviour and serve to",
"show that commands and options may be interspersed.",
"",
"Options are of the form of  '--name=value' while commands and command",
"arguments are positional.",
"",
"",
"-------",
"OPTIONS",
"-------",
" --help",
"     Print this message, then exit.",
"",
" --verbose",
"     Be verbose in the messages printed to screen. By default only errors",
"     and some informational messages are printed.",
"",
"",
"",
"----------------",
"GENERAL COMMANDS",
"----------------",
COMMAND_HELP,
"",
"----------------",
"PROGRAM COMMANDS",
"----------------",
COMMAND_SQUARE,
   };

   if (!cmd) {
      for (size_t i=0; i<sizeof msg/sizeof msg[0]; i++) {
         printf ("%s\n", msg[i]);
      }
      return;
   }

   for (size_t i=0; i<sizeof cmd_help/sizeof cmd_help[0]; i++) {
      if ((strcmp (cmd_help[i].cmd, cmd))==0) {
         for (size_t j=0;
              j<sizeof cmd_help[i].msg/sizeof cmd_help[i].msg[0];
              j++) {
            if (cmd_help[i].msg[j]) {
               printf ("%s\n", cmd_help[i].msg[j]);
            }
         }
         return;
      }
   }
   printf ("   (Unrecognised command [%s])\n", cmd);
}

/* *******************************************************************
 * Functions for handling the commands.
 */



/* *******************************************************************
 * Finally, the main function.
 */

int main (int argc, char **argv)
{
   char **args = NULL,
        **lopts = NULL,
        **sopts = NULL;

   int val = 12;

   if (!(process_args (argc, argv, &args, &lopts, &sopts))) {
      fprintf (stderr, "Failed to process argument list "
                       "(argument list too long?)");
      return EXIT_FAILURE;
   }

   const char *opt_help = find_opt ((const char **)lopts,   "help",
                                     (const char **)sopts,  'h');

   if (opt_help) {
      print_help_msg (NULL);
      return EXIT_SUCCESS;
   }

   printf ("Module one version: [%s]\n", MODULE_ONE_VERSION);
   printf ("Module two version: [%s]\n", MODULE_TWO_VERSION);

   printf ("Module one result [%i]: %x\n", val, module_one_example (val));
   printf ("Module two result [%i]: %x\n", val, module_two_example (val));

   return EXIT_SUCCESS;
}


/* ********************************************************************
 * An even more comprehensive command-line parsing mechanism. This method
 * allows the program to have long options (--name=value) short options
 * (-n value or -nvalue or -abcnvalue) mixed with non-options (arguments
 * without a '-' or '--'.
 *
 * The caller will be able to support intuitive arguments when options and
 * arguments can be mixed freely. For example the following are all
 * equivalent:
 *   progname --infile=/path/to/infile command-name --outfile=/path/to/outfile
 *   progname command-name --outfile=/path/to/outfile --infile=/path/to/infile
 *   progname --outfile=/path/to/outfile --infile=/path/to/infile command-name
 *
 * To support all of the above the parser must be run on the main() argc and
 * argv parameters, after which all of the arguments, long options and
 * short options will be stored in arrays provided by the caller.
 *
 * The arrays containing the arguments and options are all positional, in that
 * they will contain the arguments in the order they were processed.
 *
 * The arguments array can be searched linearly, stopping when the array
 * element is NULL.
 *
 * The long options array can be searched similarly for the entire
 * name=value pair, or can be searched with the provided function
 * find_lopt() which will return only the value part of the string, which
 * may be an empty string if the user did not provide a value.
 *
 * The short options can be searched linearly using the first element of
 * each string in the array to determine if the option is stored (and
 * using the rest of the string as the value for that option) or can be
 * searched using the function find_sopt() which will return the value
 * part of the option, which may be an empty string if the user did not
 * provide a value for the option.
 *
 * The caller can search for both long options and short options
 * simultaneously using the find_opt() function which will return the long
 * option for the specified long option name if it exists, or the short
 * option for the specified short option name if it exists.
 *
 *
 */
static void string_array_free (char **sarr)
{
   for (size_t i=0; sarr && sarr[i]; i++) {
      free (sarr[i]);
   }
   free (sarr);
}

static char **string_array_append (char ***dst, const char *s1, const char *s2)
{
   bool error = true;
   size_t nstr = 0;

   for (size_t i=0; (*dst) && (*dst)[i]; i++)
      nstr++;

   char **tmp = realloc (*dst, (sizeof **dst) * (nstr + 2));
   if (!tmp)
      goto errorexit;

   *dst = tmp;
   (*dst)[nstr] = NULL;
   (*dst)[nstr+1] = NULL;

   char *scopy = malloc (strlen (s1) + strlen (s2) + 1);
   if (!scopy)
      goto errorexit;

   strcpy (scopy, s1);
   strcat (scopy, s2);

   (*dst)[nstr] = scopy;

   error = false;

errorexit:
   if (error) {
      return NULL;
   }

   return *dst;
}

static const char *find_lopt (const char **lopts, const char *name)
{
   if (!lopts || !name)
      return NULL;

   size_t namelen = strlen (name);
   for (size_t i=0; lopts[i]; i++) {
      size_t maxlen = strlen (lopts[i]);
      if (maxlen != namelen)
         continue;
      if ((strncmp (name, lopts[i], maxlen))==0) {
         char *ret = strchr (lopts[i], '=');
         return ret ? &ret[1] : "";
      }
   }
   return NULL;
}


static const char *find_sopt (const char **sopts, char opt)
{
   if (!sopts || !opt)
      return NULL;

   size_t index = 0;
   for (size_t i=0; sopts[i]; i++)
      index++;

   for (size_t i=index; i>0; i--) {
      for (size_t j=0; sopts[i-1][j]; j++) {
         if (sopts[i-1][j]==opt)
            return &sopts[i-1][j+1];
      }
   }
   return NULL;
}

static const char *find_opt (const char **lopts, const char *lname,
                             const char **sopts, char sname)
{
   const char *ret = NULL;

   if (lopts && lname)
      ret = find_lopt (lopts, lname);

   if (!ret && sopts && sname)
      ret = find_sopt (sopts, sname);

   return ret;
}

static bool process_args (int argc, char **argv,
                          char ***args, char ***lopts, char ***sopts)
{
   int error = true;

   char **largs = NULL,
        **llopts = NULL,
        **lsopts = NULL;

   free (*args);
   free (*lopts);
   free (*sopts);

   *args = NULL;
   *lopts = NULL;
   *sopts = NULL;

   for (int i=1; i<argc && argv[i]; i++) {
      if ((strncmp (argv[i], "--", 2))==0) {
         // Store in lopt
         if (!(string_array_append (&llopts, &argv[i][2], "")))
            goto errorexit;

         continue;
      }
      if (argv[i][0]=='-') {
         for (size_t j=1; argv[i][j]; j++) {
            if (argv[i][j+1]) {
               if (!(string_array_append (&lsopts, &argv[i][j], "")))
                  goto errorexit;
            } else {
               char *value = &argv[i+1][0];
               if (!value || value[0]==0 || value[0]=='-')
                  value = "";
               if (!(string_array_append (&lsopts, &argv[i][j], value)))
                  goto errorexit;
               if (argv[i+1] && argv[i+1][0]!='-')
                  i++;
               break;
            }
         }
         continue;
      }
      // Default - store in largs
      if (!(string_array_append (&largs, argv[i], "")))
         goto errorexit;

   }

   *args = largs;
   *lopts = llopts;
   *sopts = lsopts;

   error = false;

errorexit:
   if (error) {
      string_array_free (largs);
      string_array_free (llopts);
      string_array_free (lsopts);
   }

   return !error;
}


