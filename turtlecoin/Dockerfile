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

FROM soregums/debian:buster-slim as builder

RUN set -xe; \
    \
    apt-get update \
    && apt-get install -y \
       build-essential \
       g++-8 \
       gcc-8 \
       git \
       libboost-all-dev \
       cmake \
    && rm -rf /var/lib/apt/lists/*
CMD ["bash"]


FROM builder as turtlecoin

ARG FORCE_UPDATE=no
ARG GIT_REPO_BASE_URL=https://github.com/turtlecoin/
ARG GIT_REPO=turtlecoin
ARG GIT_BRANCH=master
ARG GIT_COMMIT
ARG CMAKE_OPTS="-DCMAKE_BUILD_TYPE=Release -DSTATIC=true"

RUN set -xe; \
    \
    echo "FORCE_UPDATE? ${FORCE_UPDATE}" \
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

COPY --from=turtlecoin /turtlecoin/build/src/TurtleCoind /usr/local/bin/TurtleCoind

VOLUME /logs
VOLUME /data

# p2p
EXPOSE 11897/tcp
# RPC
EXPOSE 11898/tcp

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["TurtleCoind", "--no-console", "--log-file", "/logs/TurtleCoind.log", "--data-dir", "/data", "--rpc-bind-ip", "0.0.0.0"]

# # rpc exposed
# mkdir -p ./trtl-v0.14.0-RC1/{data,logs} && docker run --name trtl-v0.14.0-RC1 \
#  -p 0.0.0.0:11897:11897 \
#  -p 0.0.0.0:11898:11898 \
#  -d \
#  --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1/logs,target=/logs \
#  --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1/data,target=/data \
#  --restart=unless-stopped \
#  soregums/turtlecoin:turtlecoind-v0.14.0-RC1

# # no rpc exposed
# mkdir -p ./trtl-v0.14.0-RC1/{data,logs} && docker run --name trtl-v0.14.0-RC1 \
#  -p 0.0.0.0:11897:11897 \
#  -d \
#  --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1/logs,target=/logs \
#  --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1/data,target=/data \
#  --restart=unless-stopped \
#  soregums/turtlecoin:turtlecoind-v0.14.0-RC1

# OR

# # rpc exposed & load checkpoints
# mkdir -p ./trtl-v0.14.0-RC1/{data,logs} && docker run --name trtl-v0.14.0-RC1 \
#   -p 0.0.0.0:11897:11897 \
#   -p 0.0.0.0:11898:11898 \
#   -d \
#   --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1/logs,target=/logs \
#   --mount type=bind,source="$(pwd)"/trtl-v0.14.0-RC1/data,target=/data \
#   --restart=unless-stopped \
#   soregums/turtlecoin:turtlecoind-v0.14.0-RC1 TurtleCoind --no-console --log-file /logs/TurtleCoind.log --data-dir /data  --rpc-bind-ip 0.0.0.0 --load-checkpoints /data/checkpoints.csv

# OR

# mkdir -p ./trtl-1829c1/{data,logs} && docker run --name trtl-1829c1 \
#  -p 0.0.0.0:11897:11897 \
#  -p 0.0.0.0:11898:11898 \
#  -d \
#  --mount type=bind,source="$(pwd)"/trtl-1829c1/logs,target=/logs \
#  --mount type=bind,source="$(pwd)"/trtl-1829c1/data,target=/data \
#  --restart=unless-stopped \
#  soregums/turtlecoin:turtlecoind-1829c1 \
