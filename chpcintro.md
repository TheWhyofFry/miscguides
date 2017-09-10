class: center, middle

# Do clusters dream of electric humans?
## A gentle introduction to amazing world of High-Performance Computing

---

# Overview

1. How are programs actually run?
2. Why do I need a server?
3. What even is a cluster?

---


# Just a note

I am assuming:
  - You know very little
  - You wonder about certain things, but are too afraid to ask
  - You'll be OK with me giving a lengthy introduction before we start
---


# How are programs actually run

- The shell

- image of shell

---


# Behind the scenes (kinda)

- The shell interprets what you type
- OK, so you want to run the program ls (lists the folder you are in)
- It looks for a special file (ls) and executes it
- It shows output and it's done
- Simple stuff

---

# Behind the scenes (kinda)

- Each program that runs is assigned as a process
- The operating system tends to the needs of the program:
  * Reading a file
  * Getting the necessary RAM for the application
  * Wizard stuff
- The program might need certain outputs, such as printing on screen

---


# Back in your shell!

- image shell execution
- Whatever you do in your shell, by default, is bound to that shell
- This means:
  * Quitting the shell (logging out) implicitly kills (force-ends) the processes associated with it
  * There are ways to stop this from happening (more later)

---



# So you're on a server and you see a shell. . .what do you do?

- The previous point is important here.
- Usually you run things on a server that may take days to run
- You wouldn't want to keep your PC/laptop on and logged in indefinitely until the process finishes

---



# Circumvention - Threading for speed

- You may notice that some programs have a "threading" option
- To understand this, let's look at the anatomy of your average (modern) PC
- It has a CPU, which does all the execution
    * This CPU has cores
    * Cores are like individual workers
    * In theory, spreading the work over multiple workers would decrease the time for completing the task by n-worker times

---

# Some examples

- BLAST

---

# Working on a server

- Servers generally have more power than your lab PC
- More CPUs with more cores with more RAM
- In short, this allows you to complete bigger tasks
  - More CPUs allows you to do things in a reasonable times
  - More RAM means programs you run can handle bigger things

---

# What if you DON'T have a nice server to use ... ?

- Luckily for us, we have the CHPC
- The amount of resources available is astounding
- There are 1,368 nodes at the CHPC with a total of 32,832 cores (average high-end server nowadays ~96 cores)
- Each node is like a little server on its own (typically 24 cores each)
- However, you're looking for chaos if everyone could just do what they want at any given moment
  * Where do you log in?

---

# So you have a concept of queueing

- In order to keep the behemoth afloat, the CHPC uses PBS Pro
- In short:
  * PBS knows about all the nodes
  * It also knows about different queues:
    * You can assign jobs to different queues, depending on your needs
  * It also knows how to queue a specific user, so you can't really hog the queue (it happens)

---

# But HOW is this different to what I've been doing?

- Let's run through an example - something more exciting than ls
- example -blast

---

# I have a gazillion sequences to BLAST

- Right, let's give the CHPC a go ... eek!

# QSUB and other formalities

- First, we would like to execute the command as before

```bash
$ > blastn -query test.fsa -db nr
```

- Imagine this is a big FASTA file with many sequences
- In order to submit this to the queueing system, you need to formalize this in a script

---

# QSUB and other formalities

- The anatomy of a (typical) qsub file

```bash

#!/bin/bash
#PBS -l select=1:ncpus=24:node_type=haswell_reg
#PBS -P CBBI0905
#PBS -q smp
#PBS -l walltime=12:00:00
#PBS -o /mnt/lustre/users/wsmidt/mycustomblast.out
#PBS -e /mnt/lustre/users/wsmidt/mycustomblast.err
#PBS -m abe
#PBS -N MYCUSTOMBLAST
#PBS -M werner.smidt@gmail.com


module load chpc/BIOMODULES
module load blast


#cd /home/wsmidt/Sources/hiv/prepseqs
cd $PBS_O_WORKDIR

blastn --num-threads 24 -query test.fsa -db nr
```
---


# QSUB file explained

* PBS -l : Sets a bunch of parameters:
  * select=1 will select 1 node
  * ncpus=24 specify the job will need 24 cores
  * node_type=haswell_reg - not all nodes are equal, we would like the good ones
* PBS -P : When you register with the CHPC, you are assigned a project code
* PBS -q smp : We would like to put the job in the SMP queue - more on this later
* PBS -l walltime=12:00:00 : Give the job at most 12 hours to run - it will prematurely terminate if it isn't complete


```bash

#!/bin/bash
#PBS -l select=1:ncpus=24:node_type=haswell_reg
#PBS -P CBBI0905
#PBS -q smp
#PBS -l walltime=12:00:00
```

---

# QSUB file explained

* The parameters -o and -e determines where two outputs will go:
  * -o is for _standard out_ - what you usually get on a screen when there is textual output
  * -e is for _standard error_ - this usually contains some informative/error output messages of the program you want to run
* -m abe - Send an email at the beginning (b) end (e) abort (a)
* -M werner.smidt@gmail.com - The address where the mail needs to be sent
* -N MYCUSTOMBLAST - The name of the job you are submitting to the queue


```bash

#PBS -o /mnt/lustre/users/wsmidt/mycustomblast.out
#PBS -e /mnt/lustre/users/wsmidt/mycustomblast.err
#PBS -m abe
#PBS -N MYCUSTOMBLAST
#PBS -M werner.smidt@gmail.com
```

---

# Hang on . . . there are types of queues??

- Right you are, bucko
- The CHPC has different queues and limits according to needs
