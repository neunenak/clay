FROM --platform=linux/amd64 ubuntu:22.04

RUN apt update -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y build-essential
RUN DEBIAN_FRONTEND=noninteractive apt install -y wget
RUN DEBIAN_FRONTEND=noninteractive apt install -y curl
WORKDIR /tmp/
RUN wget https://github.com/Kitware/CMake/releases/download/v3.28.4/cmake-3.28.4-linux-x86_64.tar.gz
RUN tar zxvf cmake-3.28.4-linux-x86_64.tar.gz
RUN DEBIAN_FRONTEND=noninteractive apt install -y git
RUN DEBIAN_FRONTEND=noninteractive apt install -y libwayland-dev
RUN DEBIAN_FRONTEND=noninteractive apt install -y pkg-config
RUN DEBIAN_FRONTEND=noninteractive apt install -y libxkbcommon-dev
RUN DEBIAN_FRONTEND=noninteractive apt install -y xorg-dev

# Install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

ADD . /tmp/clay

WORKDIR /tmp/clay

# Build with FFI test enabled, then run the FFI test
CMD /tmp/cmake-3.28.4-linux-x86_64/bin/cmake . -DCLAY_INCLUDE_FFI_TEST=ON && \
    /tmp/cmake-3.28.4-linux-x86_64/bin/cmake --build . && \
    ./tests/ffi-test/clay_ffi_test