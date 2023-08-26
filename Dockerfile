FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    vim  \
    git
WORKDIR /opt

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -r Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

COPY env.yaml .
COPY requirements.txt .

RUN pip install --upgrade pip && \
    conda update -n base -c defaults conda && \
    conda env create -n multi_source_diffusion -f env.yaml && \
    conda init && \
    echo "conda activate multi_source_diffusion" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV multi_source_diffusion && \
    PATH /opt/conda/envs/multi_source_diffusion/bin:$PATH

WORKDIR /