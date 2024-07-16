# Use the base CUDA 11.2.2 image for TensorFlow 1.15.4 compatibility
FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu18.04

# Install essential packages
RUN apt update -y
RUN apt install python3.7 -y
RUN apt install python3-pip -y 
RUN apt install git -y
RUN apt install wget -y
RUN apt install curl -y
RUN apt install bzip2 -y
RUN apt install libopenmpi-dev -y

# Set Python 3.7 as the default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Install Miniconda
ENV MINICONDA_VERSION=py37_4.9.2
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && rm miniconda.sh
ENV PATH=/opt/conda/bin:$PATH

# Set the working directory
WORKDIR /workspace

# Copy the project code into the container
COPY fine-tuning-locomotion-main /workspace/fine-tuning-locomotion
WORKDIR /workspace/fine-tuning-locomotion

RUN pip install --upgrade pip
RUN pip install -r /workspace/fine-tuning-locomotion/requirements.txt
RUN pip install protobuf==3.20.*
RUN pip install numpy --upgrade

RUN apt update -y
RUN apt install libgl1-mesa-glx -y
RUN apt install libgl1-mesa-dri -y

RUN apt install mesa-utils -y
RUN conda install -c conda-forge libgcc=5.2.0
RUN conda install -c anaconda libstdcxx-ng
RUN conda install -c conda-forge gcc=12.1.0
RUN apt-get install x11-apps -y

RUN export LIBGL_ALWAYS_INDIRECT=1

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV SDL_VIDEO_GL_DRIVER=libGL.so.1.7.0
ENV DISPLAY=:1
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/nvidia"
ENV  __NV_PRIME_RENDER_OFFLOAD=1
ENV __GLX_VENDOR_LIBRARY_NAME=nvidia

# Set the entrypoint to bash
CMD ["bash"]

