#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    int PID;
    int processes = atoi(argv[1]);
    pid_t pids;

    if (processes > 25)
    {
        printf("# of processes cannot be > 25\n");
        return 0;
    }

    printf("Parent pid is %d\n", getpid());
    for (int i = 0; i < processes; i++)
    {
        pids = fork();
        if (pids == 0)
        {
            printf("Started child %d with pid %d\n", i + 1, getpid());
            if ((i + 1) % 5 == 1)
            {
                system("./test1");
            }
            else if ((i + 1) % 5 == 2)
            {
                system("./test2");
            }
            else if ((i + 1) % 5 == 3)
            {
                system("./test3");
            }
            else if ((i + 1) % 5 == 4)
            {
                system("./test4");
            }
            else
            {
                system("./test5");
            }
            return 0;
        }
    }

    for (int i = 0; i < processes; i++)
    {
        PID = wait(NULL);
        printf("Child %d (PID %d) finished\n", i + 1, PID);
    }
    return 0;
}