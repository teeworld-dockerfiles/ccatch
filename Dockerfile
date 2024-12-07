FROM alpine:3.20.3 AS build

RUN apk add --no-cache \
	cmake \
	curl-dev \
	g++ \
	gcc \ 
	libpng-dev \
	libwebsockets-dev \
	mariadb-dev \
	ninja \
	python3 \
	sqlite-dev

COPY . /tw/sources

WORKDIR /tw/build

RUN cmake /tw/sources \
	-Wno-dev \
    -DCMAKE_INSTALL_PREFIX=/tw/install \
	-DANTIBOT=ON \
	-DAUTOUPDATE=OFF \
	-DCLIENT=OFF \
	-DDEV=OFF \
	-DIPO=ON \
	-DMYSQL=OFF \
	-DPREFER_BUNDLED_LIBS=OFF \
	-DVIDEORECORDER=OFF \
	-DVULKAN=OFF \
	-DWEBSOCKETS=ON \
	-GNinja

RUN cmake --build . -t install

# ---

FROM alpine:3.20.3 AS ccatch

RUN apk add --no-cache \
	libcurl \
	libstdc++ \
	libwebsockets \
	sqlite-libs
	
COPY --from=build /tw/install/bin /tw/bin

WORKDIR /tw/data

ENTRYPOINT ["/tw/bin/ccatch_srv"]
