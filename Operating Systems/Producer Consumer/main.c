#include <assert.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

// global variable
int buffersize;
int generate; // twice buffer size
int producers;
int consumers;
int in = 0;    // in counter
int out = 0;   // out counter
int count = 0; // to count # values in buffer
int *buffer;   // array
sem_t empty;   // locks
sem_t full;
pthread_mutex_t mutex;

// track thread id
typedef struct __tinfo_t
{
    int thread_id;
} tinfo_t;

void *producer(void *arg)
{
    tinfo_t *x = (tinfo_t *)arg;
    int random;
    bool toggle;
    printf("P%d: Producing %d values\n", x->thread_id, generate);
    for (int i = 0; i < generate; i++)
    {
        if (count == buffersize)
        {
            printf("P%d: Blocked due to full buffer\n", x->thread_id);
            toggle = true;
        }
        random = 1 + (rand() % 10);
        sem_wait(&empty);
        pthread_mutex_lock(&mutex);
        if (count < buffersize && toggle == true)
        {
            printf("P%d: Done waiting on full buffer\n", x->thread_id);
            toggle = false;
        }
        buffer[in] = random;
        printf("P%d: Writing %d to position %d\n", x->thread_id, buffer[in], in);
        in = (in + 1) % buffersize;
        count++;
        pthread_mutex_unlock(&mutex);
        sem_post(&full);
    }
    printf("P%d: Exiting\n", x->thread_id);
}

void *consumer(void *arg)
{
    tinfo_t *y = (tinfo_t *)arg;
    int consuming;
    bool toggle;
    if (y->thread_id < consumers - 1)
        consuming = producers * generate / consumers;
    else
        consuming = producers * generate / consumers + producers * generate % consumers;
    printf("C%d: Consuming %d values\n", y->thread_id, consuming);
    for (int i = 0; i < consuming; i++)
    {
        if (count == 0)
        {
            printf("C%d: Blocked due to empty buffer\n", y->thread_id);
            toggle = true;
        }
        sem_wait(&full);
        pthread_mutex_lock(&mutex);
        if (count > 0 && toggle == true)
        {
            printf("C%d: Done waiting on empty buffer\n", y->thread_id);
            toggle = false;
        }
        int value = buffer[out];
        printf("C%d: Reading %d from position %d\n", y->thread_id, value, out);
        out = (out + 1) % buffersize;
        count--;
        pthread_mutex_unlock(&mutex);
        sem_post(&empty);
    }
    printf("C%d: Exiting\n", y->thread_id);
}

int main(int argc, char *argv[])
{
    // initialization
    assert(argc == 4);
    buffersize = atoi(argv[1]);
    assert(buffersize > 0);
    generate = buffersize * 2;
    buffer = (int *)malloc(buffersize * sizeof(int)); // reallocate for array
    producers = atoi(argv[2]);
    assert(producers > 0);
    consumers = atoi(argv[3]);
    assert(consumers > 0);
    pthread_t p[producers];
    pthread_t c[consumers];
    tinfo_t x[producers]; // for id
    tinfo_t y[consumers]; // for id
    pthread_mutex_init(&mutex, NULL);
    sem_init(&empty, 0, buffersize);
    sem_init(&full, 0, 0);
    int i;
    for (i = 0; i < producers; i++)
    {
        x[i].thread_id = i;
        printf("Main: started producer %d\n", i);
        pthread_create(&p[i], NULL, producer, &x[i]); // create producer threads
    }
    for (i = 0; i < consumers; i++)
    {
        y[i].thread_id = i;
        printf("Main: started consumer %d\n", i);
        pthread_create(&c[i], NULL, consumer, &y[i]); // create consumer threads
    }
    for (i = 0; i < producers; i++)
    {
        printf("Main: producer %d joined\n", x[i].thread_id);
        pthread_join(p[i], NULL);
    }
    for (i = 0; i < consumers; i++)
    {
        printf("Main: consumer %d joined\n", y[i].thread_id);
        pthread_join(c[i], NULL);
    }
    printf("Main: program completed\n");
    pthread_mutex_destroy(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);
    return 0;
}