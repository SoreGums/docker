# docker build \
# -t soregums/turtlecoin:turtlecoind-testnet-cntrtlv2 \
# --build-arg GIT_REPO=testnet \
# --build-arg GIT_BRANCH=config-for-testnet \
# --target daemon .

FROM soregums/debian:buster-slim as builder

RUN apt update \
    && apt install -y \
       build-essential \
       g++-8 \
       gcc-8 \
       git \
       libboost-all-dev \
       cmake
CMD ["bash"]


FROM builder as turtlecoin

ARG FORCE_UPDATE=no
ARG GIT_REPO_BASE_URL=https://github.com/turtlecoin/
ARG GIT_REPO=turtlecoin
ARG GIT_BRANCH=master

# This method downloads the least number of bytes
#   it also means that it can only checkout the latest commit at the time of 
#   invocation.
# Will investigate a universal solution that can do least bytes & specific 
#  commit which is actually needed for Krang.
# This can be shortened to a single git clone command, however then it might
#  not work for individual commits...
RUN echo "FORCE_UPDATE? ${FORCE_UPDATE}" \
    && mkdir /turtlecoin \
    && cd /turtlecoin \
    && git init \
    && git remote add origin ${GIT_REPO_BASE_URL}${GIT_REPO} \
    && git fetch --depth 1 origin ${GIT_BRANCH} \
    && git checkout ${GIT_BRANCH} \
    && mkdir /turtlecoin/build \
    && cd /turtlecoin/build \
    && cmake -DCMAKE_BUILD_TYPE=Release -DSTATIC=true .. \
    && make -j$(nproc)

CMD ["bash"]


FROM soregums/debian:buster-slim as daemon

COPY --from=turtlecoin /turtlecoin/build/src/TurtleCoind /bin/TurtleCoind

VOLUME /logs
VOLUME /data

# p2p
EXPOSE 11897/tcp
# RPC
EXPOSE 11898/tcp

ENTRYPOINT ["TurtleCoind"]
CMD ["--no-console", "--log-file", "/logs/TurtleCoind.log", "--data-dir", "/data"]


FROM soregums/turtlecoin:blocks as daemon-blocks

COPY --from=turtlecoin /turtlecoin/build/src/TurtleCoind /bin/TurtleCoind
VOLUME /logs

# p2p
EXPOSE 11897/tcp
# RPC
EXPOSE 11898/tcp

ENTRYPOINT ["TurtleCoind"]
CMD ["--no-console", "--log-file", "/logs/TurtleCoind.log", "--data-dir", "/data"]

# docker run --name cntrtlv2-11810 \
#  -p 0.0.0.0:11810:11897 \
#  -p 0.0.0.0:11811:11897 \
#  -d \
#  soregums/turtlecoin:turtlecoind-testnet-cntrtlv2-blocks \
#  
