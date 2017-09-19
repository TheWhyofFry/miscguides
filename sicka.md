## Getting your stuff from your google drive to the CHPC

I've noticed that many of you like to use Google Drive (GD) to store your raw data on. While generally, I would discourage this practice as the *primary* source of your data, it does make it easier to share with people.  The CHPC does use globus, but you need the paid version of the service in order to share data efficiently with people.  We've also shown that data can be directly shared on the CHPC by changing permissions of folders. This is not ideal, since it implicitly makes the data available to _all_ other users. 

There are quite a few ways to access GD from the command line.  I will be covering the installtion and usage of one such package today, namely [skicka](https://github.com/google/skicka).  Skicka is a package made with the Go programming language.  We can ask the CHPC staff to make this package available globally, but instead we will install it ourselves.  Generally, if you have a package that will be needed by other people, it is not good practice to do this, but I have a suspicion that this tool will not be installed in a global fashion on the CHPC, since it is something that can directly interface with personal data. 

## What you will need

First, we need to setup an evironment for the Go programming language.  This is needed, because ``Go`` needs to know where to install pacakges and where exactly you are running Go from.  Login to ``scp.chpc.ac.za`` and add the following line to your `~/.basrc` file:

```bash
export PATH=~/go/bin:$PATH # add the go binary directory to the PATH, so we can direclty run the programs
export GOBIN=~/go/bin
export GOPATH=~/go
```

Next, create the go folders with:

```
mkdir ~/go
mkdir ~/go/bin
```

Good! Technically, we should run an interactive session to install packages. We can be sneaky and avoid this step, but for the sake of not peeving admins/tech staff, let's start an interactive session with:

```
qsub -I -l select=1:ncpu=1:queue=test -l walltime=1:0:0 -P [projectname]
```

And wait for the interactive session to appear.  Our go environment variables should be set up, but we need to load the ``go`` module in order to fetch and install the ``skicka`` package. Do this with:

```
moudle load chpc/go/1.7.4
```

And to install the package, we do a two-step process. First, we ask ``go`` to get the package and then to install it.  
```
go get github.com/google/skicka
go install github.com/google/skicka

```

I highly doubt you would be using many go packages, but for those that are interested, you _can_ do the install directly, but I would recommend first downloading and then installing it, in case you need to make modifications.  Also, be _careful_ when copying commands like the ones above. You need to _verify_ that the link is correct and that it indeed points to the correct package.

Good! Try running the following command:

```
skicka --help
```

It should bring up a wall of text describing the use of the tool/parameters etc. Let's follow the official guide you can get [here](https://github.com/google/skicka). Skip to point 4 in the ["Getting Started"](https://github.com/google/skicka#getting-started) section. Run the command:


```
skicka init
```

The next step, we'll do a little differenty. What the program needs is an authentication token that will allow it to access your GD files. By default, it will open a web browser to your GD.  However, here you'll copy the link shown in the terminal, open the browser and paste the link.  Use your UP login that you use for the TUKS gmail.  It will provide you with a code. You need to copy this code and paste this back into the terminal:


```
werner.local-> skicka -no-browser-auth ls
Go to the following link in your browser:
[link]
Enter verification code: [paste the code here]
```

After you've entered the code, you should be able to see the files in your root folder of your GD. To download a file/folder, issue the command:


```
skicka download [/yourfolderorfile] [destination]
```

You can make a ``~/lustre/tmp`` folder for testing purposes.  Download your files here. To upload a file:


```
skicka upload [yourfolderorfile] [destination on your google drive]
```

As an example, do the following:

```
echo "my file contains this text" > ~/myfile.txt
skicka upload ~/myfile.txt /
skicka ls /
skicka download /myfile.txt ~/lustre/tmp
```

The file should now be both in your GD and your ``~/lustre/tmp`` folder. 



