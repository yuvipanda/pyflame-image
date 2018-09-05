# PyFlame Docker Image

Do you have a runaway containerized python process that is inexplicably using too much CPU?

Did you ever think "If only I can profile this python process running inside
a docker container, I could solve this mystery"?

Have you ever gone "ah, if only this kubernetes cluster was running ubuntu
or debian as base OS so I can install pyflame in it!"?

If the answer to any of these questions is yes, this image might help you!

## What is it?

An image containing [PyFlame](https://github.com/uber/pyflame) for use in
various containerized situations. See the pyflame docs for more info on how to
use PyFlame!

## How to use this image?

Let's say you are running a kubernetes cluster, and want to profile a particular
python process.

1. Find the host the pod containing the process is running in. You can do this
   by looking at the output of `kubectl --namespace=<namespace> get pod -o wide`
2. SSH into that node
3. Spin up this image and get shell in it:

   ```bash
   docker run -it --pid=host --privileged --cap-add SYS_PTRACE yuvipanda/pyflame:py3.6-1.6.3 /bin/bash
   ```
    > add --privileged to solve `Failed to setns 4: Operation not permitted` error

4. Find the pid of the process you want to profile. You can use normal tools like
   `top` or `ps` for this - they will show all processes runningin the host, including
   the ones running inside containers.

5. Profile process, generate a flame graph, and post it to gist!

   ```bash
   pyflame -x -p <id> -s 60 -o 60s && flamegraph.pl 60s > 60s.svg && gist-paste 60s.svg
   ```

   This will profile the process with pid `<pid>` for 60s, write the output to a file
   called `60s`, generate a flamegraph svg called `60s.svg` from it, and upload it
   to gist! 

   You can pass in various params to `pyflame`, `flamegraph.pl` or `gist-paste` to
   customize this process.

## Further reading

Brendan Gregg's [FlameGraphs](http://www.brendangregg.com/flamegraphs.html) page,
which contains all the things you might ever want to know about FlameGraphs. 

This [ACM Article](https://queue.acm.org/detail.cfm?id=2927301) explains what they
are and how to read them.

Brendan Gregg's [LISA Presentation](http://www.brendangregg.com/blog/2017-04-23/usenix-lisa-2013-flame-graphs.html)
on flamegraphs is also excellent, with demos and a great talk!
