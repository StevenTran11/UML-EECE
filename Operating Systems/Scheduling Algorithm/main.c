#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int interval;
int *process;
int *burst;
int *priority;
int *arrival; //givens
int *startTime;
int *waitTime; //starttime - arrival time or idling
int *turnaroundTime; //endtime - arrival time
int *endTime;
int lineCount = 1; //size of queue
double swaitTime[5];
double sturnaroundTime[5];
int contextSwitch[5]; //switching between processes
FILE *write;

//sort algorithm altered to swap 2 arrays
void SelectionSort(double A[], int size, char B[][12])
{
    for (int i = 0; i < size - 1; i++)
    {
        int Imin = i;
        for (int j = i + 1; j < size; j++)
        {
            if (A[j] < A[Imin])
            {
                Imin = j;
            }
        }
        double temp1 = A[Imin];
        A[Imin] = A[i];
        A[i] = temp1;
        char temp2[12];
        strcpy(temp2, B[Imin]);
        strcpy(B[Imin], B[i]);
        strcpy(B[i], temp2);
    }
}

//struct to relate time to scheduling algorithm name
struct time {
    double time[5];
    char array[5][12];
} wait, turn, switches;

//queue from internet copy pasted
struct Queue {
    int front, rear, size;
    unsigned capacity;
    int* array;
};

//initialize queue
struct Queue* createQueue(unsigned capacity)
{
    struct Queue* queue = (struct Queue*)malloc(
        sizeof(struct Queue));
    queue->capacity = capacity;
    queue->front = queue->size = 0;
 
    // This is important, see the enqueue
    queue->rear = capacity - 1;
    queue->array = (int*)malloc(
        queue->capacity * sizeof(int));
    return queue;
}

//check if queue full
int isFull(struct Queue* queue)
{
    return (queue->size == queue->capacity);
}

//check if queue empty
int isEmpty(struct Queue* queue)
{
    return (queue->size == 0);
}

//add to back
void enqueue(struct Queue* queue, int item)
{
    if (isFull(queue))
        return;
    queue->rear = (queue->rear + 1)
                  % queue->capacity;
    queue->array[queue->rear] = item;
    queue->size = queue->size + 1;
}

//pop top altered to not return top value
void dequeue(struct Queue* queue)
{
    if (isEmpty(queue))
        return;
    int item = queue->array[queue->front];
    queue->front = (queue->front + 1)
                   % queue->capacity;
    queue->size = queue->size - 1;
}

//get front of queue
int front(struct Queue* queue)
{
    if (isEmpty(queue))
        return INT_MIN;
    return queue->array[queue->front];
}

//get back of queue
int rear(struct Queue* queue)
{
    if (isEmpty(queue))
        return INT_MIN;
    return queue->array[queue->rear];
}

//print summary
void summary(char *sequence, int switches, int test)
{
    fprintf(write, "PID\t\tWT\t\tTT\n");
    double avwt = 0, avtt = 0;
    for (int i = 0; i < lineCount; i++)
    {
        fprintf(write,"%d\t\t%d\t\t%d\n", process[i], waitTime[i], turnaroundTime[i]);
        avwt += waitTime[i];
        avtt += turnaroundTime[i];
    }
    avwt /= lineCount;
    avtt /= lineCount;
    fprintf(write, "AVG\t\t%.2f\t%.2f\n\n", avwt, avtt);
    fprintf(write, "Process sequence: %s\n", sequence);
    fprintf(write, "Context switches: %d\n\n\n", switches);
    swaitTime[test] = avwt;
    sturnaroundTime[test] = avtt;
    contextSwitch[test] = switches;
}

//print ready queue
void readyQueue(struct Queue* queue)
{
    char readyQ[65536];
    char buffer[6];
    if (isEmpty(queue))
    {
        strcat(readyQ, "empty");
    }
    else
    {
        int first = front(queue);
        sprintf(buffer, "%d", front(queue));
        strcat(readyQ, buffer);
        enqueue(queue, front(queue));
        dequeue(queue);
        while (front(queue) != first)
        {
            strcat(readyQ, "-");
            sprintf(buffer, "%d", front(queue));
            strcat(readyQ, buffer);
            enqueue(queue, front(queue));
            dequeue(queue);
        }
    }
    fprintf(write, "Ready queue: %s\n\n", readyQ);
    strcpy(readyQ, "");
}

void FCFS()
{
    struct Queue* queue = createQueue(lineCount);
    int t = 0;
    int cpuBurst = 0;
    int runningq;
    int temp; //a counter to keep track of things
    char sequence[65536] = ""; //process sequence
    char buffer[6]; //used to add process number of top of q to string sequence
    int switches = 0; //count of context switches
    fprintf(write, "***** FCFS Scheduling *****\n");
    while(t == 0 || !isEmpty(queue) || cpuBurst != 0)
    {
        //FCFS enqueue
        for(int i = 0; i < lineCount; i++)
        {
            if (arrival[i] == t)
            {
                enqueue(queue, process[i]);
            }
        }
        if (t % interval == 0)
        {
            fprintf(write, "t = %d\n", t);
            fprintf(write, "CPU: ");
        }
        //queue not empty, burst = 0
        if (cpuBurst == 0)
        {
            temp = 0;
            //used just for first case (edge case)
            if (t != 0)
            {
                endTime[runningq] = t;
                turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
                if (t % interval == 0)
                    fprintf(write, "Finishing process %d; ", runningq);
            }
            runningq = front(queue);
            startTime[runningq] = t;
            waitTime[runningq] = t - arrival[runningq];
            cpuBurst = burst[front(queue)];
            if (t % interval == 0)
                fprintf(write, "Loading process %d (CPU burst = %d)\n", runningq, cpuBurst);
        }
        //burst != 0
        else
        {
            temp = 1;
            if (t % interval == 0)
                fprintf(write, "Running process %d (remaining CPU burst = %d)\n", runningq, cpuBurst);
        }
        //temp = 0 means process started/ended. concat top of queue then pop queue
        if (temp == 0)
        {
            if (sequence[0] == '\0')
            {
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            else
            {
                strcat(sequence, "-");
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            switches++;
            dequeue(queue);
        }
        if (t % interval == 0)
            readyQueue(queue);
        t++;
        cpuBurst--;
        //edge case last case where burst = 0 and queue is empty where code above does not run
        if (isEmpty(queue) && cpuBurst == 0)
        {
            endTime[runningq] = t;
            turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
            if (t % interval == 0)
            {
                fprintf(write, "t = %d\n", t);
                fprintf(write, "CPU: Finishing process %d\n", runningq);
                fprintf(write, "Ready queue: empty\n");
            }
        }
    }
    fprintf(write, "\n*********************************************************\n");
    fprintf(write, "FCFS Summary (WT = wait time, TT = turnaround time):\n\n");
    summary(sequence, switches, 0);
}

void SJF()
{
    struct Queue* queue = createQueue(lineCount);
    int t = 0;
    int cpuBurst = 0;
    int runningq;
    int temp; //a counter to keep track of things
    char sequence[65536] = ""; //process sequence
    char buffer[6]; //used to add process number of top of queue to string sequence
    int switches = 0; //count of context switches
    fprintf(write, "***** SJF Scheduling *****\n");
    while(t == 0 || !isEmpty(queue) || cpuBurst != 0)
    {
        for(int i = 0; i < lineCount; i++)
        {
            if (arrival[i] == t)
            {
                //Queue empty
                if (isEmpty(queue))
                {
                    enqueue(queue, process[i]);
                }
                //Queue not empty then check where to enqueue the process depending on burst value.
                else
                {
                    temp = 0;
                    bool smallest = true;
                    int first = front(queue);
                    do
                    {
                        if (burst[i] > burst[front(queue)]) //burst # is greater keep cycling queue
                        {
                            smallest = false;
                            enqueue(queue, front(queue));
                            dequeue(queue);
                            if(front(queue) == first) //edge case queue holds 1 process
                            {
                                temp = 1;
                                enqueue(queue, process[i]);
                            }
                        }
                        else if (burst[i] == burst[front(queue)]) //burst # is the same
                        {
                            smallest = false;
                            temp = 1;
                            int bursts = burst[front(queue)];
                            do //wait in line after processes with same burst #
                            {
                                enqueue(queue, front(queue));
                                dequeue(queue);
                            } while (burst[front(queue)] == bursts && front(queue) != first);
                            enqueue(queue, process[i]);
                        }
                        else //burst # is smaller than front burst #
                        {
                            temp = 1;
                            if (smallest == true)
                            {
                                first = process[i];
                            }
                            enqueue(queue, process[i]);
                        }
                        if (temp == 1) //reset queue to original positon
                        {
                            while (front(queue) != first)
                            {
                                enqueue(queue, front(queue));
                                dequeue(queue);
                            }
                        }
                    } while (front(queue) != first || temp != 1);
                }
            }
        }
        //code structure below same as FCFS
        if (t % interval == 0)
        {
            fprintf(write, "t = %d\n", t);
            fprintf(write, "CPU: ");
        }
        if (cpuBurst == 0)
        {
            temp = 0;
            if (t != 0)
            {
                endTime[runningq] = t;
                turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
                if (t % interval == 0)
                    fprintf(write, "Finishing process %d; ", runningq);
            }
            runningq = front(queue);
            startTime[runningq] = t;
            waitTime[runningq] = t - arrival[runningq];
            cpuBurst = burst[front(queue)];
            if (t % interval == 0)
                fprintf(write, "Loading process %d (CPU burst = %d)\n", runningq, cpuBurst);

        }
        else
        {
            temp = 1;
            if (t % interval == 0)
                fprintf(write, "Running process %d (remaining CPU burst = %d)\n", runningq, cpuBurst);
        }
        if (temp == 0)
        {
            if (sequence[0] == '\0')
            {
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            else
            {
                strcat(sequence, "-");
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            switches++;
            dequeue(queue);
        }
        if (t % interval == 0)
            readyQueue(queue);
        t++;
        cpuBurst--;
        if (isEmpty(queue) && cpuBurst == 0)
        {
            endTime[runningq] = t;
            turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
            if (t % interval == 0)
            {
                fprintf(write, "t = %d\n", t);
                fprintf(write, "CPU: Finishing process %d\n", runningq);
                fprintf(write, "Ready queue: empty\n");
            }
        }
    }
    fprintf(write, "\n*********************************************************\n");
    fprintf(write, "SJF Summary (WT = wait time, TT = turnaround time):\n\n");
    summary(sequence, switches, 1);
}

void STCF()
{
    struct Queue* queue = createQueue(lineCount);
    int *tempBurst = (int *)malloc(lineCount * sizeof(int));
    int t = 0;
    int cpuBurst = 0;
    int runningq;
    int temp; //a counter to keep track of things
    char sequence[65536] = ""; //process sequence
    char buffer[6]; //used to add process number of top of queue to string sequence
    int switches = 0; //count of context switches
    for (int i = 0; i < lineCount; i++)
    {
        tempBurst[i] = burst[i];
        waitTime[i] = 0;
        turnaroundTime[i] = 0;
    }
    fprintf(write, "***** STCF Scheduling *****\n");
    while(t == 0 || !isEmpty(queue) || cpuBurst != 0)
    {
        for(int i = 0; i < lineCount; i++)
        {
            //Same code for enqueue as SJF
            if (arrival[i] == t)
            {
                if (isEmpty(queue))
                {
                    enqueue(queue, process[i]);
                }
                else
                {
                    temp = 0;
                    bool smallest = true;
                    int first = front(queue);
                    do
                    {
                        if (burst[i] > burst[front(queue)]) //burst # is greater keep cycling queue
                        {
                            smallest = false;
                            enqueue(queue, front(queue));
                            dequeue(queue);
                            if(front(queue) == first) //edge case queue holds 1 process
                            {
                                temp = 1;
                                enqueue(queue, process[i]);
                            }
                        }
                        else if (burst[i] == burst[front(queue)]) //burst # is the same
                        {
                            smallest = false;
                            temp = 1;
                            int bursts = burst[front(queue)];
                            do //wait in line after processes with same burst #
                            {
                                enqueue(queue, front(queue));
                                dequeue(queue);
                            } while (burst[front(queue)] == bursts && front(queue) != first);
                            enqueue(queue, process[i]);
                        }
                        else //burst # is smaller than front burst #
                        {
                            temp = 1;
                            if (smallest == true)
                            {
                                first = process[i];
                            }
                            enqueue(queue, process[i]);
                        }
                        if (temp == 1) //reset queue to original positon
                        {
                            while (front(queue) != first)
                            {
                                enqueue(queue, front(queue));
                                dequeue(queue);
                            }
                        }
                    } while (front(queue) != first || temp != 1);
                }
            }
        }
        //Mostly same as FCFS
        if (t % interval == 0)
        {
            fprintf(write, "t = %d\n", t);
            fprintf(write, "CPU: ");
        }
        if (cpuBurst == 0)
        {
            if (t != 0)
            {
                endTime[runningq] = t;
                turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
                if (t % interval == 0)
                    fprintf(write, "Finishing process %d; ", runningq);
            }
            runningq = front(queue);
            startTime[runningq] = t;
            cpuBurst = tempBurst[front(queue)];
            if (t % interval == 0)
            {
                fprintf(write, "Loading process %d (CPU burst = %d)\n", runningq, cpuBurst);
                readyQueue(queue);
            }
            if (sequence[0] == '\0')
            {
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            else
            {
                strcat(sequence, "-");
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            dequeue(queue);
            switches++;
        }
        //Different from SJF
        else
        {
            //Queue is already in order of burst->the running process must be smallest burst value.  New process enqueued burst value smaller than running process burst, enqueue current process, save remaining burst
            if (isEmpty(queue) || cpuBurst <= tempBurst[front(queue)])
            {
                if (t % interval == 0)
                {
                    fprintf(write, "Running process %d (remaining CPU burst = %d)\n", runningq, cpuBurst);
                    readyQueue(queue);
                }
            }
            //part where new process is swapped in
            else
            {
                if (sequence[0] == '\0')
                {
                    sprintf(buffer, "%d", front(queue));
                    strcat(sequence, buffer);
                }
                else
                {
                    strcat(sequence, "-");
                    sprintf(buffer, "%d", front(queue));
                    strcat(sequence, buffer);
                }
                int temp = runningq;
                if (t % interval == 0)
                    fprintf(write, "Preempting process %d (remaining CPU burst = %d); loading process %d (CPU burst = %d)\n", runningq, cpuBurst, front(queue), tempBurst[front(queue)]);
                tempBurst[runningq] = cpuBurst;
                runningq = front(queue);
                dequeue(queue);
                if (t % interval == 0)
                    readyQueue(queue);
                enqueue(queue, temp);
                cpuBurst = tempBurst[runningq];
                while  (front(queue) != temp)
                {
                    enqueue(queue, front(queue));
                    dequeue(queue);
                }
                switches++;
            }
        }
        t++;
        cpuBurst--;
        if (isEmpty(queue) && cpuBurst == 0)
        {
            endTime[runningq] = t;
            turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
            if (t % interval == 0)
            {
                fprintf(write, "t = %d\n", t);
                fprintf(write, "CPU: Finishing process %d\n", runningq);
                fprintf(write, "Ready queue: empty\n");
            }
        }
        //Second difference.  Since it preempts processes, cannot calculate waittime from start - arrival
        if (!isEmpty(queue))
        {
            int proc = front(queue);
            do
            {
                waitTime[front(queue)]++;
                enqueue(queue, front(queue));
                dequeue(queue);
            } while (front(queue) != proc);
        }
    }
    fprintf(write, "\n*********************************************************\n");
    fprintf(write, "STCF Summary (WT = wait time, TT = turnaround time):\n\n");
    summary(sequence, switches, 2);
}

void roundRobin()
{
    struct Queue* queue = createQueue(lineCount);
    int *tempBurst = (int *)malloc(lineCount * sizeof(int));
    int t = 0;
    int cpuBurst = 0;
    int counter = 1; //to keep track when using quantum
    int quantum = 2;
    int runningq;
    char sequence[65536] = ""; //process sequence
    char buffer[6]; //used to add process number of top of q to string sequence
    int switches = 0; //count of context switches
    for (int i = 0; i < lineCount; i++)
    {
        tempBurst[i] = burst[i];
        waitTime[i] = 0;
        turnaroundTime[i] = 0;
    }
    fprintf(write, "***** Round robin Scheduling *****\n");
    while(t == 0 || !isEmpty(queue) || cpuBurst != 0)
    {
        //FCFS enqueue
        for(int i = 0; i < lineCount; i++)
        {
            if (arrival[i] == t)
            {
                enqueue(queue, process[i]);
            }
        }
        if (t % interval == 0)
        {
            fprintf(write, "t = %d\n", t);
            fprintf(write, "CPU: ");
        }
        //Same as FCFS
        if (cpuBurst == 0)
        {
            if (t != 0)
            {
                endTime[runningq] = t;
                turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
                if (t % interval == 0)
                    fprintf(write, "Finishing process %d; ", runningq);
            }
            runningq = front(queue);
            startTime[runningq] = t;
            cpuBurst = tempBurst[front(queue)];
            if (sequence[0] == '\0')
            {
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            else
            {
                strcat(sequence, "-");
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            dequeue(queue);
            if (t % interval == 0)
            {
                fprintf(write, "Loading process %d (CPU burst = %d)\n", runningq, cpuBurst);
                readyQueue(queue);
            }
            switches++;
        }
        //This part is different
        else
        {
            //Use Quantum to do round robin
            //using counter to count.  Count % quantum != 0 continue running.  Empty queue is to prevent accessing queue which causes segmentation fault.
            if (counter % quantum != 0  || isEmpty(queue))
            {
                if (t % interval == 0)
                {
                    fprintf(write, "Running process %d (remaining CPU burst = %d)\n", runningq, cpuBurst);
                    readyQueue(queue);
                }
                counter++;
            }
            //Queue isnt empty and counter % quantum = 0  Time to do next process
            else
            {
                if (sequence[0] == '\0')
                {
                    sprintf(buffer, "%d", front(queue));
                    strcat(sequence, buffer);
                }
                else
                {
                    strcat(sequence, "-");
                    sprintf(buffer, "%d", front(queue));
                    strcat(sequence, buffer);
                }
                if (t % interval == 0)
                    fprintf(write, "Preempting process %d (remaining CPU burst = %d); loading process %d (CPU burst = %d)\n", runningq, cpuBurst, front(queue), tempBurst[front(queue)]);
                //Round robin part of queue
                tempBurst[runningq] = cpuBurst;
                int temp = runningq;
                runningq = front(queue);
                dequeue(queue);
                if (t % interval == 0)
                    readyQueue(queue);
                enqueue(queue, temp);
                cpuBurst = tempBurst[runningq];
                counter = 1;
                switches++;
            }
        }
        t++;
        cpuBurst--;
        //last case edge case
        if (isEmpty(queue) && cpuBurst == 0)
        {
            endTime[runningq] = t;
            turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
            if (t % interval == 0)
            {
                fprintf(write, "t = %d\n", t);
                fprintf(write, "CPU: Finishing process %d\n", runningq);
                fprintf(write, "Ready queue: empty\n");
            }
        }
        //same as STCF needs preempt cannot use start - arrival
        if (!isEmpty(queue))
        {
            int proc = front(queue);
            do
            {
                waitTime[front(queue)]++;
                enqueue(queue, front(queue));
                dequeue(queue);
            } while (front(queue) != proc);
        }
    }
    fprintf(write, "\n*********************************************************\n");
    fprintf(write, "Round robin Summary (WT = wait time, TT = turnaround time):\n\n");
    summary(sequence, switches, 3);
}

void priorityQ()
{
    struct Queue* queue = createQueue(lineCount);
    int t = 0;
    int cpuBurst = 0;
    int runningq;
    int temp; //a counter to keep track of things
    char sequence[65536] = ""; //process sequence
    char buffer[6]; //used to add process number of top of queue to string sequence
    int switches = 0; //count of context switches
    fprintf(write, "***** Priority Scheduling *****\n");
    while(t == 0 || !isEmpty(queue) || cpuBurst != 0)
    {
        for(int i = 0; i < lineCount; i++)
        {
            if (arrival[i] == t)
            {
                //SJF but instead of checking for burst, check for priority
                if (isEmpty(queue))
                {
                    enqueue(queue, process[i]);
                }
                else
                {
                    temp = 0;
                    bool smallest = true; //only smallest if queue never got changed
                    int first = front(queue);
                    do
                    {
                        if (priority[i] > priority[front(queue)]) //prio greater keep cycling queue
                        {
                            smallest = false;
                            enqueue(queue, front(queue));
                            dequeue(queue);
                            if(front(queue) == first) //edge case queue holds 1 process
                            {
                                temp = 1;
                                enqueue(queue, process[i]);
                            }
                        }
                        else if (priority[i] == priority[front(queue)]) //prio is the same
                        {
                            smallest = false;
                            temp = 1;
                            int prio = priority[front(queue)];
                            do //wait in line after processes with same prio
                            {
                                enqueue(queue, front(queue));
                                dequeue(queue);
                            } while (priority[front(queue)] == prio && front(queue) != first);
                            enqueue(queue, process[i]);
                        }
                        else //prio is smaller than front
                        {
                            temp = 1;
                            if (smallest == true)
                            {
                                first = process[i];
                            }
                            enqueue(queue, process[i]);
                        }
                        if (temp == 1) //reset queue to original positon
                        {
                            while (front(queue) != first)
                            {
                                enqueue(queue, front(queue));
                                dequeue(queue);
                            }
                        }
                    } while (front(queue) != first || temp != 1);
                }
            }
        }
        //Below same as FCFS
        if (t % interval == 0)
        {
            fprintf(write, "t = %d\n", t);
            fprintf(write, "CPU: ");
        }
        if (cpuBurst == 0)
        {
            temp = 0;
            if (t != 0)
            {
                endTime[runningq] = t;
                turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
                if (t % interval == 0)
                    fprintf(write, "Finishing process %d; ", runningq);
            }
            runningq = front(queue);
            startTime[runningq] = t;
            waitTime[runningq] = t - arrival[runningq];
            cpuBurst = burst[front(queue)];
            if (t % interval == 0)
                fprintf(write, "Loading process %d (CPU burst = %d)\n", runningq, cpuBurst);
        }
        else
        {
            temp = 1;
            if (t % interval == 0)
                fprintf(write, "Running process %d (remaining CPU burst = %d)\n", runningq, cpuBurst);
        }
        if (temp == 0)
        {
            if (sequence[0] == '\0')
            {
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            else
            {
                strcat(sequence, "-");
                sprintf(buffer, "%d", front(queue));
                strcat(sequence, buffer);
            }
            switches++;
            dequeue(queue);
        }
        if (t % interval == 0)
            readyQueue(queue);
        t++;
        cpuBurst--;
        if (isEmpty(queue) && cpuBurst == 0)
        {
            endTime[runningq] = t;
            turnaroundTime[runningq] = endTime[runningq] - arrival[runningq];
            if (t % interval == 0)
            {
                fprintf(write, "t = %d\n", t);
                fprintf(write, "CPU: Finishing process %d\n", runningq);
                fprintf(write, "Ready queue: empty\n");
            }
        }
    }
    fprintf(write, "\n*********************************************************\n");
    fprintf(write, "Priority Summary (WT = wait time, TT = turnaround time):\n\n");
    summary(sequence, switches, 4);
}

int main(int argc, char *argv[])
{
    assert(argc == 4);
    interval = atoi(argv[3]);
    FILE *read;
    read = fopen(argv[1],"r");
    write = fopen(argv[2], "w");
    if (!read)
        return -1;
    char ch;
    while((ch = fgetc(read)) != EOF)
    {
        if(ch=='\n')
            lineCount++;
    }
    fclose(read);
    read = fopen(argv[1],"r");
    process = (int *)malloc(lineCount * sizeof(int));
    burst = (int *)malloc(lineCount * sizeof(int));
    priority = (int *)malloc(lineCount * sizeof(int));
    arrival = (int *)malloc(lineCount * sizeof(int));
    startTime = (int *)malloc(lineCount * sizeof(int));
    waitTime = (int *)malloc(lineCount * sizeof(int));
    endTime = (int *)malloc(lineCount * sizeof(int));
    turnaroundTime = (int *)malloc(lineCount * sizeof(int));
    int num;
    //scan and save values of read file
    for (int i = 0; i < lineCount; i++)
    {
        process[i] = i;
        fscanf(read, "%d", &num);
        burst[i] = num;
        fscanf(read, "%d", &num);
        priority[i] = num;
        fscanf(read, "%d", &num);
        arrival[i] = num;
    }
    fclose(read);
    FCFS();
    SJF();
    STCF();
    roundRobin();
    priorityQ();
    fprintf(write, "***** OVERALL SUMMARY *****\n");
    char algorithm[5][12] = {"FCFS", "SJF", "STCF", "Round robin", "Priority"};
    //using struct to relate scheduling algorithm to wt tt and context switches
    for (int i = 0; i < 5; i++)
    {
        strcpy(wait.array[i], algorithm[i]);
        wait.time[i] = swaitTime[i];
        strcpy(turn.array[i], algorithm[i]);
        turn.time[i] = sturnaroundTime[i];
        strcpy(switches.array[i], algorithm[i]);
        switches.time[i] = contextSwitch[i];
    }
    SelectionSort(wait.time, 5, wait.array);
    SelectionSort(turn.time, 5, turn.array);
    SelectionSort(switches.time, 5, switches.array);
    fprintf(write, "\nWait Time Comparison\n");
    for (int i = 0; i < 5; i++)
    {
        fprintf(write, "%d\t%-*s\t\t%0.2f\n", i + 1, 11, wait.array[i], wait.time[i]);
    }
    fprintf(write, "\nTurnaround Time Comparison\n");
    for (int i = 0; i < 5; i++)
    {
        fprintf(write, "%d\t%-*s\t\t%0.2f\n", i + 1, 11, turn.array[i], turn.time[i]);
    }
    fprintf(write, "\nContext Switch Comparison\n");
    for (int i = 0; i < 5; i++)
    {
        fprintf(write, "%d\t%-*s\t\t%0.0f\n", i + 1, 11, switches.array[i], switches.time[i]);
    }
    fclose(write);
    return 0;
}