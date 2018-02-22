FROM python:3.6

RUN apt-get update && \
    apt-get install autoconf automake autotools-dev g++ libtool pkg-config gist -y && \
    git clone https://github.com/uber/pyflame.git && \
    cd pyflame && \
    git checkout v1.6.3 && \
    ./autogen.sh && \
    ./configure && \
    make install && \
    cd .. && rm -rf pyflame && \
    apt-get purge --yes autoconf automake autotools-dev g++ libtool pkg-config && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/brendangregg/FlameGraph && \
    cd FlameGraph && git checkout a8d807a && \
    mv flamegraph.pl /usr/local/bin
