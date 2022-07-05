#include <assert.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <stdbool.h>

int mainMem[32];
int frame[16][4];
FILE *read;
FILE *write;
int temp;
int pageSize;
int offset = 0;
unsigned int bit;
int full = 0;
pthread_mutex_t mutex;

//track thread id
typedef struct __tinfo_t {
    int thread_id;
    char file[100];
} tinfo_t;

void *threads(void *arg)
{
    tinfo_t *x = (tinfo_t *) arg;
    FILE *temp;
    int virtualMemSize;
    char rw[1];
    char registers[3];
    int addr;
    temp = fopen(x->file, "r");
    //Count lines in file for later
    char ch;
    int lineCount = 0;
    while((ch = fgetc(temp)) != EOF)
    {
        if(ch=='\n')
            lineCount++;
    }
    fclose(temp);
    //Reading File
    temp = fopen(x->file, "r");
    fscanf(temp, "%d", &virtualMemSize);
    //initialize page num
    int openPage = -1;
    int pageNum;
    unsigned int frameNum;
    bool found = true;
    //Algorithm Begins
    for(int i = 0; i < lineCount; i++)
    {
        fscanf(temp, "%s", rw);
        fscanf(temp, "%s", registers);
        fscanf(temp, "%d", &addr);
        fprintf(write, "P%d OPERATION: %c\t%s\t0x%08x\n", x->thread_id, rw[0], registers, addr);
        pthread_mutex_lock(&mutex);
        int pageNum = addr / pageSize;
        int j = 0;
        //Page number changed => Time to change frames
        if(openPage != pageNum)
        {
            fprintf(write, "P%d: page %d not resident in memory\n", x->thread_id, pageNum);
            openPage = pageNum;
            //Check if frames are full
            while(1)
            {
                //If not used
                if(frame[j][1] == 0)
                {
                    frameNum = j;
                    frame[j][1] = 1;
                    frame[j][2] = x->thread_id;
                    frame[j][3] = pageNum;
                    fprintf(write, "P%d: using free frame %d\n", x->thread_id, frame[j][0]);
                    break;
                }
                j++;
                if(j == 16)
                {
                    found = false;
                    break;
                }
            }
            //Frames Full
            if (found == false)
            {
                fprintf(write, "P%d: evicting process %d, page %d from frame %d\n", x->thread_id, frame[full][2], frame[full][3], full);
                frameNum = full;
                full = (full + 1) % 16;
            }
            fprintf(write, "P%d: new translation from page %d to frame %d\n", x->thread_id, openPage, frameNum);
        }
        //Page did not change
        else
        {
            fprintf(write, "P%d: valid translation from page %d to frame %d\n", x->thread_id, openPage, frameNum);
        }
        //Calculate Physical Address
        int PA = frameNum << offset;
        PA += bit & addr;
        pthread_mutex_unlock(&mutex);
        fprintf(write, "P%d: translated VA 0x%08x to PA 0x%08x\n", x->thread_id, addr, PA);
        fprintf(write, "P%d: %s = 0x%08x (mem at virtual addr 0x%08x)\n", x->thread_id, registers, mainMem[bit & addr], addr);
    }
    fclose(temp);
}
int main(int argc, char *argv[])
{
    assert(argc == 4);
    read = fopen(argv[1], "r");
    write = fopen(argv[2], "w");
    int random = atoi(argv[3]);
    int i;
    srand(random);
    //initialization of frame and random memory address
    for(i = 0; i < 16; i++)
    {
        frame[i][0] = i;
        //0 == not used
        frame[i][1] = 0;
    }
    for(i = 0; i < 32; i++)
    {
        mainMem[i] = rand();
    }
    //read file
    int memSize;
    int processes;
    tinfo_t x[processes];
    pthread_t a[processes];
    fscanf(read, "%d", &memSize);
    fscanf(read, "%d", &pageSize);
    //get offset # of bits
    temp = pageSize;
    while(temp != 1)
    {
        temp /= 2;
        offset++;
    }
    for(i = 0; i < offset; i++)
    {
        bit *= 2;
        bit += 1;
    }
    fscanf(read, "%d", &processes);
    //create threads
    char process[10][100];
    for(i = 0; i < processes; i++)
    {
        fscanf(read, "%s", process[i]);
        x[i].thread_id = i;
        strcpy(x[i].file,process[i]);
        fprintf(write, "Process %d started\n", i);
        pthread_create(&a[i], NULL, threads, &x[i]);
    }
    for(i = 0; i < processes; i++)
    {
        pthread_join(a[i], NULL);
        fprintf(write, "Process %d completed\n", x[i].thread_id);
        //Set frames to unused
        for(int j = 0; j < 16; j++)
        {
            if(frame[j][2] == x[i].thread_id)
            {
                frame[j][1] = 0;
            }
        }
    }
    fprintf(write, "Main: program completed");
    fclose(read);
    return 0;
}