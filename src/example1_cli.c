
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
 *
 * This program provides a basic framework for a command-line driven
 * program which has intuitive command argument processing and provides a
 * comprehensive help message for each command.
 *
 * Using this framework lets the program handle commands and lets the
 * caller intersperse arguments to those commands and options to the main
 * program without the programmer having to do much work. See the help
 * message string literal in the help message function below for an
 * example of the usage.
 */



/* *******************************************************************
 * Functions for parsing the command-line.
 */
static const char *find_opt (const char **lopts, const char *lname,
                              const char **sopts, char sname);

static bool process_args (int argc, char **argv,
                          char ***args, char ***lopts, char ***sopts);

/* Utility function for freeing an allocated array of allocated strings.
 */
static void string_array_free (char **sarr);

/* *******************************************************************
 * Functions for the help system.
 * This is a generic template for displaying your help messages. Each
 * command that your command-line program supports must have an entry here
 * describing its use.
 *
 * Call the 'print_help_msg' function with NULL to print all the help, or
 * with a specific command to print just the help message for that
 * command.
 */
static void print_help_msg (const char *cmd)
{

   /* First, #define a single formatted string for each command that the
    * program recognises. Use the examples here for COMMAND_HELP and
    * COMMAND_SQUARE.
    *
    * Later on, below this, you will use these #defines wherever the help
    * message is needed.
    */
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

   /* Place each command string together with its help message into a
    * single array, as show below for the commands "help" and "square".
    * If you forget to do this the user will not be able to request help
    * for a specific command.
    */
   static const struct {
      const char *cmd;
      const char *msg[20];
   } cmd_help[] = {
      { "help",                  { COMMAND_HELP             }  },
      { "square",                { COMMAND_SQUARE           }  },
   };

   /* Now write your full help message as shown below. Note this each
    * line is a string literal with a comma at the end - this means that
    * each line is a single string in an array of strings.
    */
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
   /* This is where you place your #defines for each command. You can
    * place empty lines before or after each entry to visually offset them
    * in the output.
    */
COMMAND_HELP,
"",
"----------------",
"PROGRAM COMMANDS",
"----------------",
COMMAND_SQUARE,
   };

   /* There is no need to modify anything for the rest of this function.
    * Output is determined solely by the two arrays above.
    */
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
 * Functions for handling the commands. Each command that your program
 * supports will have an associated function. For example if your program
 * supports the command 'list', you will create a function called
 * 'cmd_list' in this section.
 *
 * Each command function will take a single parameter of array-of-strings,
 * the function will then have all of its arguments in that
 * array-of-strings.
 *
 * The function must return an integer that will be returned unchanged to
 * the operating system. I recommend using EXIT_SUCCESS and EXIT_FAILURE
 * because they are already defined for success and failure returns.
 */
typedef int (command_func_t) (const char **args);

int cmd_help (const char **args)
{
   // This is the help command. Help is both a command and an option to
   // the program. This function implements the help command. Processing
   // the options is performed by the main program, and the main program
   // will call print_help_msg() with the correct arguments if the user
   // requested help via an option.
   print_help_msg (args[1]);
   return EXIT_SUCCESS;
}

int cmd_square (const char **args)
{
   // This is the example function of how all your command implementations
   // will look. Note that on error EXIT_FAILURE is returned while on
   // success EXIT_SUCCESS is returned.
   int val = 0;
   if ((sscanf (args[1], "%i", &val))!=1) {
      fprintf (stderr, "Failed to scan [%s] as an integer.\n", args[1]);
      return EXIT_FAILURE;
   }

   val = module_one_example (val);
   printf ("SQUARE: %i\n", val);

   return EXIT_SUCCESS;
}

/* *******************************************************************
 * Finally, the main function. Note that we have a small handler to free
 * all the memory that main allocates.
 */
char **g_args = NULL,
     **g_lopts = NULL,
     **g_sopts = NULL;

void cleanup_func (void)
{
   string_array_free (g_args);
   string_array_free (g_lopts);
   string_array_free (g_sopts);
}

int main (int argc, char **argv)
{
   /* All your commands must be stored in this array, along with the
    * function to call for that command and the minimum and maximum number
    * of arguments that the command takes.
    *
    * Note that the minimum/maximum argument count includes the command
    * itself, so you need to add 1 to the actual number of arguments that
    * your command takes.
    *
    * For example, 'help' takes only a single command - the name of the
    * command to provide help for. This means that, together with the
    * 'help' command itself, there must be exactly two arguments.
    *
    * The command is stored in l_args[0], and all its arguments are stored
    * from l_args[1] onwards.
    */
   static const struct command_t {
      const char *cmd;
      int (*fptr) (const char **args);
      size_t min_args;
      size_t max_args;
   } cmds[] = {
      { "help",                  cmd_help,               2, 2     },
      { "square",                cmd_square,             2, 2     },
   };

   const struct command_t *cmd = NULL;

   printf ("Library version: [%s]\n", skeleton_version);
   printf ("Module one version: [%s]\n", MODULE_ONE_VERSION);
   printf ("Module two version: [%s]\n", MODULE_TWO_VERSION);

   /* Make sure we call the exit handler if anything happens and we are
    * not able to return cleanly.
    */
   atexit (cleanup_func);


   /* Before doing anything else you must process all the arguments to
    * main(). After processing, all the arguments to the command are
    * stored in g_args, all the long options found are stored in g_lopts
    * and all the short options found is stored in g_sopts.
    *
    * Later on you can examine the options and perform certain actions
    * based on them. For example, if '--help' or '-h' is supplied as an
    * option then you must display the help message for the command in
    * g_args[0], or the full help message if there are no commands
    * specified.
    *
    * program --help          # Provide full help message
    * program help square     # Provide the help message for command square
    * program square --help   # Provide the help message for command square
    */
   if (!(process_args (argc, argv, &g_args, &g_lopts, &g_sopts))) {
      fprintf (stderr, "Failed to process argument list "
                       "(argument list too long?)");
      return EXIT_FAILURE;
   }

   const char *opt_help = find_opt ((const char **)g_lopts, "help",
                                    (const char **)g_sopts, 'h');

   if (opt_help) {
      // If g_args[0] is NULL, the full help message is printed.
      print_help_msg (g_args ? g_args[0] : NULL);
      return EXIT_SUCCESS;
   }




   // Count the number of arguments there are in the g_args array
   size_t nargs = 0;
   for (size_t i=0; g_args && g_args[i]; i++)
      nargs++;

   if (!g_args || nargs < 1) {
      fprintf (stderr, "No command specified. Try --help\n");
      return EXIT_FAILURE;
   }

   /* At this point, after you have examined/searched for all the options
    * you are interested in, the execution of the command proceeds. This
    * loop simply searches for the correct command. After the loop we
    * check that the number of arguments are more than the minimum
    * required and less than the maximum allowed, then runs the command
    * function.
    */
   for (size_t i=0; i<sizeof cmds/sizeof cmds[0]; i++) {
      if ((strcmp (cmds[i].cmd, g_args[0]))==0) {
         cmd = &cmds[i];
         break;
      }
   }


   // If we did not find an entry in the array, tell the user that the
   // command is unrecognised and then exit.
   if (!cmd) {
      fprintf (stderr, "Unrecognised command: [%s]\n", g_args[0]);
      return EXIT_FAILURE;
   }

   // If the user supplied too few or too many arguements, tell them so
   // and then exit.
   if (nargs < cmd->min_args) {
      fprintf (stderr, "[%s] Too few arguments: minimum is %zu, got %zu\n",
                       cmd->cmd, cmd->min_args, nargs);
      print_help_msg (cmd->cmd);
      return EXIT_FAILURE;
   }

   if (nargs > cmd->max_args) {
      fprintf (stderr, "[%s] Too many arguments: maximum is %zu, got %zu\n",
                       cmd->cmd, cmd->max_args, nargs);
      print_help_msg (cmd->cmd);
      return EXIT_FAILURE;
   }

   // Finally, we run the command and return the result to the operating
   // system.
   return cmd->fptr ((const char **)g_args);
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


