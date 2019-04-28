# docker build \
# -t soregums/turtlecoin:turtlecoind-v0.14.0-RC1 \
# --build-arg GIT_REPO=turtlecoin \
# --build-arg GIT_BRANCH=v0.14.0-RC1 \
# .

# OR

# docker build \
# -t soregums/turtlecoin:turtlecoind-1829c1 \
# --build-arg GIT_REPO=turtlecoin \
# --build-arg GIT_COMMIT=1829c1713f79207906c63f3f2dd989a939054d83 \
# .

FROM debian:buster-slim as builder

RUN set -xe; \
    \
    apt-get update \
    && apt-get install -y --no-install-recommends \
       ccache \
       cmake \
       cpp \
       g++ \
       g++-8 \
       gcc \
       gcc-8 \
       git \
       libboost-all-dev \
       make \
    && rm -rf /var/lib/apt/lists/*

ARG REFRESH_CCACHE=no
ARG GIT_REPO_BASE_URL=https://github.com/turtlecoin/
ARG GIT_REPO=turtlecoin
ARG GIT_BRANCH=master
ARG GIT_COMMIT
ARG CMAKE_OPTS="-DCMAKE_BUILD_TYPE=Release -DSTATIC=true"

RUN set -xe; \
    \
    echo "REFRESH_CCACHE? ${REFRESH_CCACHE}" \
    && test -z "${GIT_COMMIT}" && git clone --single-branch -b ${GIT_BRANCH} --depth 1 ${GIT_REPO_BASE_URL}${GIT_REPO} /turtlecoin || : \
    && test -z "${GIT_COMMIT}" || git clone ${GIT_REPO_BASE_URL}${GIT_REPO} /turtlecoin && :\
    && test -z "${GIT_COMMIT}" || cd /turtlecoin && : \
    && test -z "${GIT_COMMIT}" || git checkout ${GIT_COMMIT} && : \
    && mkdir /turtlecoin/build \
    && cd /turtlecoin/build \
    && cmake ${CMAKE_OPTS} .. \
    && make -j$(nproc)

ARG FORCE_REBUILD=no

RUN set -xe; \
    \
    echo "FORCE_REBUILD? ${FORCE_REBUILD}" \
    && test -z "${GIT_COMMIT}" && git clone --single-branch -b ${GIT_BRANCH} --depth 1 ${GIT_REPO_BASE_URL}${GIT_REPO} /turtlecoin || : \
    && test -z "${GIT_COMMIT}" || git clone ${GIT_REPO_BASE_URL}${GIT_REPO} /turtlecoin && :\
    && test -z "${GIT_COMMIT}" || cd /turtlecoin && : \
    && test -z "${GIT_COMMIT}" || git checkout ${GIT_COMMIT} && : \
    && mkdir /turtlecoin/build \
    && cd /turtlecoin/build \
    && cmake ${CMAKE_OPTS} .. \
    && make -j$(nproc)
    
CMD ["bash"]


FROM soregums/debian:buster-slim as daemon

# p2p
EXPOSE 11897/tcp
# RPC
EXPOSE 11898/tcp

VOLUME /opt/turtlecoin

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

COPY --from=builder /turtlecoin/build/src/TurtleCoind /usr/local/bin/TurtleCoind

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["TurtleCoind", "--no-console", "--log-file", "/opt/turtlecoin/TurtleCoind.log", "--data-dir", "/opt/turtlecoin"]

# docker run --name trtl-v0.14.0-RC1-11810 \
# -p 0.0.0.0:11810:11897 \
# -p 0.0.0.0:11811:11897 \
# -d \
# --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1-11810/logs,target=/logs \
# --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1-11810/data,target=/data \
# soregums/turtlecoin:turtlecoind-v0.14.0-RC1 

# OR

# docker run --name trtl-1829c1-11810 \
#  -p 0.0.0.0:11810:11897 \
#  -p 0.0.0.0:11811:11897 \
#  -d \
#  --mount type=bind,source="$(pwd)"/trtl-1829c1-11810/logs,target=/logs \
#  --mount type=bind,source="$(pwd)"/trtl-1829c1-11810/data,target=/data \
#  soregums/turtlecoin:turtlecoind-1829c1 \
