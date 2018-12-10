FROM soregums/debian:buster-slim as builder

RUN apt update \
    && apt install -y \
       build-essential \
       g++-8 \
       gcc-8 \
       git \
       libboost-all-dev \
       cmake \
    && git clone -b master --single-branch https://github.com/turtlecoin/turtlecoin \
    && mkdir turtlecoin/build \
    && cd turtlecoin/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DSTATIC=true .. \
    && make -j$(nproc)

CMD ["bash"]


FROM soregums/debian:buster-slim as turtlecoind
COPY --from=builder /turtlecoin/build/src/TurtleCoind /bin/TurtleCoind
VOLUME /data
ENTRYPOINT ["TurtleCoind"]
CMD ["--no-console", "--log-file", "/data/TurtleCoind.log"]
