FROM nvidia/cuda:11.6.0-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# Install base utilities
RUN apt-get update --fix-missing && \
  apt-get install -y wget bzip2 ca-certificates curl git ffmpeg libsm6 libxext6 -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

# Add files.
COPY . /root

# Install dependencies.
RUN conda create -n re3-pytorch-env python=3.6.8
RUN conda env update -n re3-pytorch-env -f env.yml

# Unpack demo assets.
RUN tar -zxvf ./demo/data.tar.gz && rm -rf ./demo/data.tar.gz
RUN tar -zxvf /root/assets/checkpoints_small.tar.gz && rm -rf /root/assets/checkpoints_small.tar.gz
RUN mv /root/checkpoints_small /root/logs

# Debug
RUN pip install opencv-python torch==1.10.2 torchvision==0.11.3

ENTRYPOINT [ "python", "demo/image_demo.py" ]
#ENTRYPOINT [ "python", "-V" ]
